/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 04/01/2014
// Last Modified: José Elias Araújo
// Last Modified by: 05/28/2014
//
// Description:
// This test class contains methods to persist data 
// related to LaunchCal application
/**********************************************************/
public class LaunchCalPersistence {
	
	Application__c[] apps;
	Motorola_Core_Directory__c[] cores;
	List<String> errorsOcurred = new List<String>(); 
	
	// Description:
	// This method persists the LaunchCals that are with correct data
	// 
	// Inputs: List<LaunchCal> of LaunchCals
	// 
	// Returns: List<String> of occured error messages.
	//
	// Last Modified: 04/02/2014
	public List<String> save(List<LaunchCal> launchCalList){
		try{
			apps = searchApplications(launchCalList);
			cores = searchCoreDirectory(launchCalList);
			boolean hasCore;
			boolean hasApp;
			List<LaunchCal__c> launchCalCustom = new List<LaunchCal__c>();
			for (LaunchCal launch : launchCalList){				
				hasApp = false;
				if (launch.application != null){
					for (Application__c app : apps){
						if (launch.application.getApplicationID().equals(app.Application_ID__c)){
							launch.application = new Application(app);
							hasApp = true;
							break;
						}
					}
				}else{
					continue;
				}
				 
				if (launch.createdBy != null){
					hasCore = false;
					for (Motorola_Core_Directory__c core : cores){
                        if (launch.createdBy != null){ 
                            String emailUser = launch.createdBy.getEmail();
                            emailUser = emailUser.substring(0, emailUser.indexOf('@'));
                            if (launch.createdBy.getEmail().equalsIgnoreCase(core.Mail__c) || 
                                launch.createdBy.getEmail().equalsIgnoreCase(core.FriendlyEmailAddress__c) ||
                                emailUser.equalsIgnoreCase(core.MMID__c) || 
                                emailUser.equalsIgnoreCase(core.CoreID__c)){
								launch.createdBy = new MotorolaCoreDirectory(core);
								hasCore = true;
								break;
                            }
						}
					}
				} 
				
				if (hasApp && hasCore){
					launchCalCustom.add(launch.getSObject());	
				}else{
					if (launch.application == null){
						errorsOcurred.add('The launchCal "' + launch.name + '" does not have application');						
					}else{
						if (!hasApp){
							errorsOcurred.add('The application ID "' + launch.application.getApplicationID() + '" that is related to LaunchCal "' + launch.name + '" does not exists');	
						}
						
					}
					if (launch.createdBy == null){
						errorsOcurred.add('The launchCal "' + launch.name + '" does not define a creator');							
					}else{
						if (!hasCore){
							errorsOcurred.add('The email "' + launch.createdBy.getEmail() + '" specified in launchCal "' + launch.name + ' specified as creator does not exists');		
						}
					}
						
					
				}			
			}
			
			Schema.SObjectField launchUniqueIDField = LaunchCal__c.Fields.Unique_Id__c;
			List<Database.upsertResult>  bulkResult = Database.upsert(launchCalCustom, launchUniqueIDField, false);
			saveApprovers(launchCalList, bulkResult);	
        
            return errorsOcurred; 
		}catch(Exception e){
			throw new LaunchCalException(e.getMessage() +  ' - ' + e.getStackTraceString());
		}	
	}
	
	// Description:
	// This method persists the LaunchCals's approvers that are with correct data
	//
	//Inputs: List<LaunchCal> of LaunchCals, List<Database.upsertResult> of bulkResults.
	//
	// Last Modified: 04/02/2014
	@TestVisible
	void saveApprovers(List<LaunchCal> launchCalList, List<Database.upsertResult> bulkResult){
		try{
			String launchCalStmt =  'select ID, Unique_ID__c from LaunchCal__c where ID in (';
			boolean anySaved = false;
			for(Integer i = 0; i < bulkResult.size(); i++){
				if (bulkResult.get(i).isSuccess()){
                	anySaved = true;
                    launchCalStmt += '\'' + bulkResult.get(i).getId() + '\'';
                    launchCalStmt += ',';
                }else{
                    errorsOcurred.add('Errors while saving a launchCal ' + bulkResult.get(i).getErrors());	
                }
			}
            
            launchCalStmt = launchCalStmt.substring(0, launchCalStmt.length()-1);
            
			
			if (anySaved){				
				map<string,Id> recordTypeMap = new map<string,Id>();
	    		list<RecordType> recTypes = [Select Id, Name From RecordType Where sObjectType = 'LaunchCal_Motorola_Core_Directory__c' and isActive = true];
	     		for(RecordType rt : recTypes){
	        		 recordTypeMap.put(rt.Name, rt.Id);
	     		}
				
				launchCalStmt += ')';
                LaunchCal__c[] savedLaunches = Database.query(launchCalStmt);
				List<LaunchCal_Motorola_Core_Directory__c> launchCalMotorolaCoreDirTobeSave = new List<LaunchCal_Motorola_Core_Directory__c>();
				for (LaunchCal launch : launchCalList){
					ID hasID;
					for (LaunchCal__c savedLaunch : savedLaunches){
						if (launch.uniqueId.equals(savedLaunch.Unique_Id__c)){
							hasID = savedLaunch.ID;
							break;
						}				
					}
					
					if (hasID != null){
						List<LaunchCalMotorolaCoreDirectory> approvers = launch.approvers;
						for (LaunchCalMotorolaCoreDirectory approver : approvers){
							boolean hasCore = false;
							for (Motorola_Core_Directory__c core : cores){
                                if (approver.flippedBy != null ){
                                    String userEmail = approver.flippedBy.getEmail();
                                    userEmail = userEmail.substring(0, userEmail.indexOf('@'));
                                    if (approver.flippedBy.getEmail().equalsIgnoreCase(core.Mail__c) || 
                                        approver.flippedBy.getEmail().equalsIgnoreCase(core.FriendlyEmailAddress__c) ||
                                        userEmail.equalsIgnoreCase(core.MMID__c) ||
                                        userEmail.equalsIgnoreCase(core.CoreID__c)){
                                            
										approver.flippedBy = new MotorolaCoreDirectory(core);
										String flippedByFirstName = (core.GivenName__c != null ? core.GivenName__c : '');
										String flippedByLastName = (core.SurName__c != null ? core.SurName__c : '');
										approver.name = flippedByFirstName  + ' ' + flippedByLastName;
                	                    hasCore = true;
										break;
                                    }
								}else if (approver.flippedBy == null && approver.launcherType == LaunchCalMotorolaCoreDirectory.Type.Approver){
									approver.name = '';
                                    hasCore = true;
								}

							}
							if (hasCore){					
								approver.getSObject().LaunchCal__c = hasID;	
								approver.uniqueID = launch.uniqueID + approver.uniqueID;
								approver.getSObject().RecordTypeId = recordTypeMap.get(approver.launcherType.name());
								launchCalMotorolaCoreDirTobeSave.add(approver.getSObject());
							}else{
								if (approver.flippedBy == null){
									errorsOcurred.add('The launchCal Motorola Core "' + approver.launcherType.name() + '" does not defined in flippedBy');	
								}else{
									errorsOcurred.add('The email "' + approver.flippedBy.getEmail() + '" defined in ' + approver.launcherType.name() + ' does not exists');	
								}
									
							}	
						}
					}
				}
				
				Schema.SObjectField launchUniqueIDField = LaunchCal_Motorola_Core_Directory__c.Fields.Unique_Id__c;
				
				Database.upsert(launchCalMotorolaCoreDirTobeSave, launchUniqueIDField, false);
			}
		}catch(Exception e){
			throw new LaunchCalException(e.getMessage() +  ' - ' + e.getStackTraceString());
		}
		
	}
		
	// Description:  
    // This method receives a list of LaunchCals and looks for all applications
    // related with launchCals present in the list.
    //
    // Input: List<LaunchCal> of LaunchCal.
    //
    // Returns: Application__c[] of applications related with launches
    //          passed as argument.
	//  
    @TestVisible
	public Application__c[] searchApplications(List<LaunchCal> launchCalList){
		String applicationQueryStmt;
		try{
			Application__c[] appDataset;
			if (launchCalList.size() > 0){
				applicationQueryStmt = 'select ID, Name, Application_ID__c, Package_Name__c from Application__c where Application_ID__c in (';
				Integer appNumber =0;
				for(Integer i = 0; i < launchCalList.size(); i++){
					if (launchCalList.get(i).application != null && !launchCalList.get(i).application.getApplicationID().equals('null')){
						appNumber++;
						applicationQueryStmt += '\'' + launchCalList.get(i).application.getApplicationID() + '\'';	
						if ((i+1) < launchCalList.size()){
	                		applicationQueryStmt += ',';
	                	}
					}
				}
				applicationQueryStmt += ')';
				
				
				applicationQueryStmt = applicationQueryStmt.replace(',)', ')');

				if (appNumber > 0){
					appDataset = Database.query(applicationQueryStmt);
					return appDataset;								
				}else{
					return new Application__c[0];
				}
			}else{
				return new Application__c[0];
			}	
		}catch(Exception e){
			throw new LaunchCalException(e.getMessage() +  ' - ' + e.getStackTraceString() + ' ' + applicationQueryStmt);
		}	
		
	}
	
	// Description:  
    // This method receives a list of LaunchCals and looks for all motorola core directories
    // related with launchCals present in the list.
    //
    // Input: List<LaunchCal> of LaunchCal.
    //
    // Returns: Motorola_Core_Directory__c[] of motorola core directories related with launches
    //          passed as argument.
	//  
    @TestVisible
	Motorola_Core_Directory__c[] searchCoreDirectory(List<LaunchCal> launchCalList){
		try{
			Motorola_Core_Directory__c[] motorolaCoreDataset;
			if (launchCalList.size() > 0){
				String motorolaCoreDirectoryQueryStmt = 'select ID, MMID__c, CoreID__c, Mail__c, FriendlyEmailAddress__c, GivenName__c, Surname__c from Motorola_Core_Directory__c where Mail__c in (';
				String emailList = '';
				String coreIdList = '';                
				for(Integer i = 0; i < launchCalList.size(); i++){
					if (launchCalList.get(i).createdBy != null && !launchCalList.get(i).createdBy.getEmail().equals('null')){
                        String emailAddress = launchCalList.get(i).createdBy.getEmail();
						emailList += '\'' + emailAddress + '\'';	
						coreIdList += '\'' + emailAddress.substring(0, emailAddress.indexOf('@')) + '\'';	                        
						if ((i+1) < launchCalList.size() || launchCalList.get(i).approvers.size() > 0){
	                		emailList += ',';
	                		coreIdList += ',';                            
	                	}
						
						for(Integer j = 0; j < launchCalList.get(i).approvers.size(); j++){                            
							if (launchCalList.get(i).approvers.get(j).flippedBy != null && !launchCalList.get(i).approvers.get(j).flippedBy.getEmail().equals('null')){
								String emailApprover = launchCalList.get(i).approvers.get(j).flippedBy.getEmail();                                
								emailList += '\'' + emailApprover + '\'';	
								coreIdList += '\'' + emailApprover.substring(0, emailApprover.indexOf('@')) + '\'';                                
								if ((j+1) < launchCalList.get(i).approvers.size() || (i+1) < launchCalList.size()){
	                				emailList += ',';
			                		coreIdList += ',';                                      
	                			}
							}
						}						
					}
				}
                
                emailList = (emailList.endsWith(',') ? emailList.substring(0, emailList.length ()-1) : emailList);
                coreIdList = (coreIdList.endsWith(',') ? coreIdList.substring(0, coreIdList.length ()-1) : coreIdList);
                
				motorolaCoreDirectoryQueryStmt += emailList + ')';
				motorolaCoreDirectoryQueryStmt += ' or FriendlyEmailAddress__c in (' + emailList + ')';
				motorolaCoreDirectoryQueryStmt += ' or MMID__c in (' + coreIdList + ')';
				motorolaCoreDirectoryQueryStmt += ' or CoreID__c in (' + coreIdList + ')';                               
                
				motorolaCoreDataset = Database.query(motorolaCoreDirectoryQueryStmt);
				
				return motorolaCoreDataset;			
			}else{
				return new Motorola_Core_Directory__c[0];
			}	
		}catch(Exception e){
			throw new LaunchCalException(e.getMessage() +  ' - ' + e.getStackTraceString());
		}			
	}
}