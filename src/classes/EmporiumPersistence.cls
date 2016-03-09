/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 02/28/2014
// Last Modified: José Elias Araújo
// Last Modified by: 08/20/2014
//
// Description:
// This class is responsible for storing data into salesforce 
// database.
// 
// Test Class: 
// EmporiumPersistenceTest.cls
/**********************************************************/
public class EmporiumPersistence{ 

    // Description:  
    // This method saves a set of application on salesforce database.
    //
    // Input: List<EmporiumApplicationDownloadStats> of applications 
    //        to be stored.
    //
    // Returns: none
	//         
    public void save(List<EmporiumApplicationDownloadStats> apps){ 
        try{
            //Saving information into Application download stats object
            List<Application_Download_Stats__c> downloadStatsList = convert(apps);            
            Schema.SObjectField uniqueID = Application_Download_Stats__c.Fields.UniqueID__c;
			Database.UpsertResult[] downStatsResult;
            downStatsResult = Database.upsert(downloadStatsList, uniqueID, true);
            
            Map<ID, Application_Download_Stats__c> appStatsMapping;
            appStatsMapping = new Map<ID, Application_Download_Stats__c>(downloadStatsList);
            
            List<Active_Users_By_Application_Version__c> newVersionList;
            newVersionList = new List<Active_Users_By_Application_Version__c>();
			for(ID appStatsID : appStatsMapping.keySet()){
                
                for(EmporiumApplicationDownloadStats app : apps){
                    if (app.getUniqueID().equals(appStatsMapping.get(appStatsID).uniqueID__c)){
                        
                        for(EmporiumActiveUserByApplicationVersion version : app.getActiveUsersByVersion()){
                            Active_Users_By_Application_Version__c customObjectVersion;
                            customObjectVersion = version.getSObject();
                            customObjectVersion.Application_Download_Stats__c = appStatsID;
                            newVersionList.add(customObjectVersion);
                        }
                        break;
                    }
                }
            }
            
            Schema.SObjectField versionUniqueID = Active_Users_By_Application_Version__c.Fields.UniqueID__c;
			Database.UpsertResult[] usersByVersionResult;
            usersByVersionResult = Database.upsert(newVersionList, versionUniqueID, true);
            
            List<Database.UpsertResult[]> results = new List<Database.UpsertResult[]>();
            results.add(downStatsResult);
            results.add(usersByVersionResult);            
            checkErrors(results);
            
        }catch(Exception e) {
            throw new EmporiumException(e.getMessage());                
        }
    }
    
    // Description:  
    // This method checks if upsert commands have executed correctly.
    // If any error occurred while upserting, an exception is thrown.
    //
    // Input: List<Database.UpsertResult[]> of upsert results
    //
    // Returns: none
	//  
    private void checkErrors(List<Database.UpsertResult[]> results){
        List<String> dbErrorMessages = new List<String>();
        
        for(Database.UpsertResult[] dmlResults : results){
            for(Database.UpsertResult dmlResult : dmlResults){
                if (!dmlResult.isSuccess()){
                    for(Database.Error errors : dmlResult.getErrors()){
                        dbErrorMessages.add(errors.getMessage());   
                    }
                }
            }  
    	}
        
        if(!dbErrorMessages.isEmpty()){
        	throw new EmporiumException(String.join(dbErrorMessages, '/r/n'));  
        }
    }
    
    // Description:  
    // Convert a list of stats to a list stats as custom objects.
    // This generated list will be used to save on the database with bulk
    // insertion.
    //
    // Input: List<EmporiumApplication> of applications to be stored.
    //
    // Returns: List<Application_Download_Stats__c> of stats
    //          as custom objects
	//     
    @TestVisible List<Application_Download_Stats__c> convert(List<EmporiumApplicationDownloadStats> apps){ 
        List<Application_Download_Stats__c> downloadStatsList = new List<Application_Download_Stats__c>();
        
        try{
	        List<String> applicationNotFoundList = new List<String>();

            Application__c[] appDataset;
            Motorola_Core_Directory__c[] codeDirDataset;
            Application_Download_Stats__c[] appDownloadStatsDataset;
                
            map<string,Id> recordTypeMap = new map<string,Id>();
	    	list<RecordType> recTypes = [Select Id, Name From RecordType Where sObjectType = 'Application_Download_Stats__c' and isActive = true];
	     	for(RecordType rt : recTypes){
	        	recordTypeMap.put(rt.Name, rt.Id);
	     	}
            
            if (apps.size() > 0){                    
                //In order to avoid to hit salesforce limits, this code
                //selects only the records with package name and email related to
                //information from emporium, that's why the query command is composed
                //with "where" clause to bring only records that is related to emporium.
                String applicationQueryStmt = 'select Package_Name__c, Name, Application_External_Unique_ID__c, Application_ID__c, ID from Application__c where Package_Name__c in ';        
			    String motorolaCoreDirqueryStmt = 'select CoreID__c, Mail__c, FriendlyEmailAddress__c from Motorola_Core_Directory__c where Mail__c in ';                                
                applicationQueryStmt += '(';
                motorolaCoreDirqueryStmt  += '(';
                    
                for (Integer i =0; i < apps.size(); i++){
                    if (apps.get(i).getApplication().getPackageName() !=null){ 
                        if (!apps.get(i).getApplication().getPackageName().trim().equals('')){
				            applicationQueryStmt += '\'' + apps.get(i).getApplication().getPackageName() + '\'';
                            if ((i+1) < apps.size()){
                                applicationQueryStmt += ',';
                            }                                
                        }

                        if (!apps.get(i).getUploadedBy().getEmail().trim().equals('')){
                            motorolaCoreDirqueryStmt += '\'' + apps.get(i).getUploadedBy().getEmail() + '\'';
                            if ((i+1) < apps.size()){	
	                            motorolaCoreDirqueryStmt  += ',';
    	                    }
                        }
                    }
                }
            
                applicationQueryStmt += ')';
                motorolaCoreDirqueryStmt += ')';    
            
			    appDataset = Database.query(applicationQueryStmt);                  
   		        codeDirDataset = Database.query(motorolaCoreDirqueryStmt);          
            }
		    
            for (EmporiumApplicationDownloadStats app : apps){            
    		    boolean hasApp = false;
    		    boolean hasDirectory;
    		    if (app.getApplication().getPackageName() != null){
		  	        for(Application__c appRecord : appDataset){
	  	  	            if (app.getApplication().getPackageName().equals(appRecord.Package_Name__c)){                    
		        	        hasApp = true;
	    	        	    app.setApplication(new Application(appRecord));
	                        break;
	                    }
	            	}
	            
	           		hasDirectory = false;
	            	for(Motorola_Core_Directory__c codeRecord : codeDirDataset){  
	                	if (app.getUploadedBy().getEmail().equals(codeRecord.Mail__c) || app.getUploadedBy().getEmail().equals(codeRecord.FriendlyEmailAddress__c)){
	                    	hasDirectory = true;
		                    app.setUploadedBy(new MotorolaCoreDirectory(codeRecord));
	    	                break;
	        	        }
	            	}
    		    }else{
    		    	applicationNotFoundList.add('There is no package name for "' + app.getApplication().getName() + '" application');
    		    }
                
        	    if (hasApp){
            	    if (!hasDirectory){
	                	app.setUploadedBy(null);
                	}
                    app.getSObject().RecordTypeId = recordTypeMap.get('Emporium');
	                downloadStatsList.add(app.getSObject());
    	        }else{
        	        applicationNotFoundList.add('The application "'+ app.getApplication().getName() + '" was not found in Application__c');   
            	}
	        }               
            if (!Test.isRunningTest()){
	    	    String errorNotification = 'The following applications are being handled by emporium. However the following errors ocurred: \r\n\r\n';
			    for(String appNotFound : applicationNotFoundList){
    		        errorNotification += ' - ' + appNotFound + '\r\n';
     			}
        
      			EmailManager.send('Application not found', errorNotification);                
            }            
        }catch(Exception e){
            throw new EmporiumException(e.getMessage());    
        }
        
        return downloadStatsList;
    }

}