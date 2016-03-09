/**
 * BOM Application Data Access Object.
 * Application__c DAO.  
 * @author: Jimens Lima - jimens@motorola.com
 */
public class BOMApplicationDAO {

    /**
     * @param  - A Filter parameter
     * @return - A List of Application__c filtered by Name.
     */
    public List<Application__c> searchAppsByFilter(BOMAppFilter filter){
        
        try{
            List<Application__c> apps = null;
			
            if(!String.isEmpty(filter.appName)){
                apps = searchByAppName(filter.appName);
            }
            
            return apps;
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            throw e;
        }
	
		return null;        
    }
    
    /**
     * @param stableName - The Stable Name on Stable__c
     * @return A Application List filtered by Stable Name 
     */
    public List<BOMGenericWrapper> searchByStableLine(ID stableLine){
        
        try{

            String query = 'Select Id,Name,Stable_App_Status__c,Application__c from Stable_Application__c where Stable__r.Id = \'' + stableLine + '\'';
            
            List<Stable_Application__c> stableApplications = Database.query(query);

            List<String> appIds 				  		   = new List<String>();
			Map<String,Boolean> mandatoryAppsIncludedOnBOM = new Map<String,Boolean>();
            Map<String,String> appStatus 			   = new Map<String,String>();
            
            for(Stable_Application__c stable: stableApplications){
                if(stable.Stable_App_Status__c.equals('Mandatory')){
            		mandatoryAppsIncludedOnBOM.put(stable.Application__c,TRUE);
                }
                
                appStatus.put(stable.Application__c, stable.Stable_App_Status__c);
                appIds.add(stable.Application__c);
            }

            String inStmt = BOMUtils.generateInStatement(appIds);
            
            if(inStmt!=null && !String.isEmpty(inStmt)){
	            List<Application__c> applications = searchAppsByIds(inStmt);
                List<BOMGenericWrapper> appsWrapper = BOMUtils.parseSObjectListToWrapper(applications);
                
                for(BOMGenericWrapper appWrapper: appsWrapper){
                    
                    if(mandatoryAppsIncludedOnBOM.containsKey(appWrapper.getApp().Id)){
                        appWrapper.disableCheck = TRUE;
                    }else{
                        appWrapper.includeInBOM = FALSE;
                    }
                    appWrapper.status = appStatus.get(appWrapper.getApp().Id);
                }

                return appsWrapper;
            }
            
            return null;
        }catch(Exception e){
            throw e;
        }
        return null;
    }
    
    /**
     * @param cdpName - Core Device Package Name
     * @return A Application List filtered by Core Device Package 
     */
    public List<Application__c> searchByCoreDevicePackage(ID cdpParam){
       
        try{
            String query = 'SELECT Id,Name,Application__c ';
            	   query += ' FROM Core_Device_Package_Application__c ';
             	   query += ' WHERE Core_Device_Package__r.Id = \''+cdpParam+'\'';
            
            List<Core_Device_Package_Application__c> cdpApplications = Database.query(query);
            if(cdpApplications!=null && !cdpApplications.isEmpty()){
                List<String> appIds = new List<String>();
    
                for(Core_Device_Package_Application__c cdp: cdpApplications){
                    appIds.add(cdp.Application__c);
                }

                if(!appIds.isEmpty()){
                    String inStmt = BOMUtils.generateInStatement(appIds);
                    List<Application__c> applications = searchAppsByIds(inStmt);
                    
                    return applications;
                }
            }
            
            return null;
        }catch(Exception e){
            throw e;
        }
        return null;
    }
	
    /**
     * @param ID - Search a Program by your ID
     */
    public Program__c searchProgramByID(ID programID){
        
        try{
            Program__c program = [SELECT ID,Name,Reviewed_Approved__c from Program__c WHERE ID = :programID];
            return program;
        }catch(System.DmlException de){
            throw de;
        }
        
        return null;
    }

    /**
     * @param programID - Program__c id
     * @return 		    - A List of Application__c related to Program
     * TODO - Continue
     */
    public List<BOMGenericWrapper> searchAppsByProgram(ID programID){
        try{
            String query = 'SELECT Application_Cost_Current__c,Application_Cost_High__c,';
            	   query += 'Application_Cost_Low__c,Application__c,Id,IsDeleted,Name,';
            	   query += 'Program__c,Status__c FROM Program_Application__c where Program__r.id = \''+programID+'\'';
            
            List<Program_Application__c> programApps = Database.query(query);
			
            if(programApps!=null && !programApps.isEmpty()){
                List<ID> appIds 			 = new List<ID>();
                Map<String,String> appStatus = new Map<String,String>();
                
                //Iterating through Program_Application__c List
                for(Program_Application__c programApp :programApps){
                    appIds.add(programApp.Application__c);
                    appStatus.put(programApp.Application__c, programApp.Status__c);
                }
                    
                String inStmt = BOMUtils.generateInStatement(appIds);
                
                if(inStmt!=null && !String.isEmpty(inStmt)){
                    List<Application__c> apps = searchAppsByIds(inStmt);
                    List<BOMGenericWrapper> genericApps = BOMUtils.parseSObjectListToWrapper(apps);
                    
                    for(BOMGenericWrapper appWrapper: genericApps){
                        
                        String status = appStatus.get(appWrapper.getApp().Id);
                        appWrapper.status = status;
                        if(status.equals('Mandatory')){
                            appWrapper.disableCheck = TRUE;
                        }else{
                            appWrapper.includeInBOM = FALSE;
                        }
                    }
                    
                    return genericApps;
                }
            }
            
        }catch(System.DmlException de){
			throw de;            
        }
        return null;
    }
    
    /**
     * @param cdpParam - Core Device Package ID
     * @return A BOMGenericWrapper(Application__c) List filtered by Core Device Package.
     */
    public List<BOMGenericWrapper> searchAppsByCoreDevicePackage(ID cdpParam){
       
        try{
            String query = 'SELECT Id,Name,Application__c,Include_in_BOM__c ';
            	   query += ' FROM Core_Device_Package_Application__c ';
             	   query += ' WHERE Core_Device_Package__r.Id = \''+cdpParam+'\'';
            
            List<Core_Device_Package_Application__c> cdpApplications = Database.query(query);
            Map<String,Boolean> appsIncludedInBOM = new Map<String,Boolean>();
            if(cdpApplications!=null && !cdpApplications.isEmpty()){
                List<String> appIds = new List<String>();
    
                for(Core_Device_Package_Application__c cdp: cdpApplications){
                    
                    if(cdp.Include_in_BOM__c){
                        appsIncludedInBOM.put(cdp.Application__c, TRUE);
                    }
                    
                    appIds.add(cdp.Application__c);
                }

                if(!appIds.isEmpty()){
                    String inStmt = BOMUtils.generateInStatement(appIds);
                    
                    List<Application__c> applications = searchAppsByIds(inStmt);
                    List<BOMGenericWrapper> wrapperApps = new List<BOMGenericWrapper>();
                    for(Application__c app: applications){
                        
                        BOMGenericWrapper appWrapper = new BOMGenericWrapper(app);
                        if(!appsIncludedInBOM.containsKey(app.Id)){
                            appWrapper.includeInBOM = FALSE;
                        }
                        wrapperApps.add(appWrapper);
                    }
                    
                    return wrapperApps;
                }
            }

        }catch(Exception e){
            throw e;
        }
        return null;
    }

    /**
     * @param appName - Application__c Name
     * @return A Application List filtered by Application Name 
     */
    private List<Application__c> searchByAppName(String appName){
        try{
			
            if(!String.isEmpty(appName)){
                String param = '\'%'+appName+'%\'';
                appName = 'Name like '+param;
            }
            else{
                return null;
            }
           
            String query = 'SELECT Application_ID__c,Id,Name,';
            	   query += 'Application_Contract_Status__c,';
             	   query += 'Application_Type__c,Available_For_Use__c,Automate_Partner_Checklist_Approval__c, ';
             	   query += 'Skip_LRB_Approval__c FROM Application__c WHERE '+appName + ' Order by Application_ID__c LIMIT 500';
            
            List<Application__c> applications = Database.query(query);
				
    		return applications;

        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            throw e;
        }
        return null;
    }
    
    
    //Search an Application by id
    public Application__c searchAppById(String appId) {
        try{
            Application__c app = [SELECT 
	                                  Application_ID__c,
    	                              Application_Contract_Status__c,
                                  	  Automate_Partner_Checklist_Approval__c,
        	                          Id,
            	                      Name,
                                  	  Skip_LRB_Approval__c
                                  FROM Application__c WHERE Id = :appId];
            return app;
        }catch(Exception e){
            throw e;
        }
    }
    
    /**
     * @param String inStmt with Application ID's.
     * @return A List with Application__c content.
     */
    private List<Application__c> searchAppsByIds(String inStmt){
         try{

            String query = 'SELECT Application_ID__c,Id,Name,';
            	   query += 'Application_Contract_Status__c,';
             	   query += 'Application_Type__c,Available_For_Use__c,Automate_Partner_Checklist_Approval__c, ';
             	   query += 'Skip_LRB_Approval__c FROM Application__c WHERE Id '+inStmt + ' LIMIT 500';
            
            List<Application__c> applications = Database.query(query);
				
    		return applications;

        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            throw e;
        }
        return null;
    }
    
    /**
     * Analyse the entire List of selected Apps, Stables and Core Device Package
     */
    public List<BOMApplicationApproval> getAutoApproval(List<BOMGenericWrapper> apps,
                                               Map<BOMGenericWrapper,List<BOMGenericWrapper>> stables,
                                               Map<BOMGenericWrapper,List<BOMGenericWrapper>> corePacks,
                                               Map<BOMGenericWrapper,List<BOMGenericWrapper>> programApps){
            
        List<BOMApplicationApproval> appApprovals = new List<BOMApplicationApproval>();
		try{
        	
            //App Level Analyses
            if(apps!=null && !apps.isEmpty()){
				
                for(BOMGenericWrapper appWrapper: apps){
					Application__c app = appWrapper.getApp();
                    BOMApplicationApproval appApproval = new BOMApplicationApproval();
                    
                    //Means that is an app is Automate_Partner_Checklist_Approval__c.
                    //It will be auto-aproved when create DevApp Junction data.
                    Boolean autoApprove = FALSE;
                    try{
                        autoApprove = app.Automate_Partner_Checklist_Approval__c;
                    }catch(Exception e1){
                        System.debug('auto approve is false 1');
                    }
                    if(autoApprove){
                        appApproval.application = app;
                        appApproval.autoApprove = TRUE;
                        
                        if(!appWrapper.isIncludedInBOM()){
                            appApproval.includeInBOM = FALSE;
                        }
						appApprovals.add(appApproval);
                    }else{

                        appApproval.application = app;
                        appApproval.autoApprove = FALSE;
                        
                        if(!appWrapper.isIncludedInBOM()){
                            appApproval.includeInBOM = FALSE;
                        }else{
                            appApproval.autoApprove  = TRUE;
                        }
                        appApprovals.add(appApproval);
                    }
                }
            }
            
            //Stable Analyses
            if(stables!=null && !stables.isEmpty()){
                for(BOMGenericWrapper stableWrapper: stables.keySet()){
                    Stable__c stable = stableWrapper.getStable();
                    
                    List<BOMGenericWrapper> stableApps = stables.get(stableWrapper);

                    if(stableApps!=null && !stableApps.isEmpty()){
						
                        for(BOMGenericWrapper stableApp : stableApps){
                            Application__c app = stableApp.getApp();
                            
                            BOMApplicationApproval appApproval = new BOMApplicationApproval();
                    
                            //If this field is marked as TRUE, the DevApp should be auto-approved automatically 
                            Boolean autoApprove = FALSE;
                             
                            try{
                                autoApprove = app.Automate_Partner_Checklist_Approval__c;
                            }catch(Exception e1){
                                System.debug('auto approve is false 2');
                            }
                            if(autoApprove){
                                appApproval.application = app;
                                appApproval.autoApprove = TRUE;
                                appApproval.stable = stable;
                                
                                if(!stableApp.isIncludedInBOM()){
                                    appApproval.includeInBOM = FALSE;
                                }
                            }else{
                                if(isAppMandatoryFromStable(app.Id,stable.Id)){
                                    
                                    appApproval.application = app;
                                    appApproval.stable      = stable;
                                    appApproval.autoApprove = TRUE;
                                    
                                    if(!stableApp.isIncludedInBOM()){
                                        appApproval.includeInBOM = FALSE;
                                    }
                                }else{
                                    appApproval.application = app;
                                    appApproval.stable      = stable;
                                    appApproval.autoApprove = FALSE;
                                
                                    if(!stableApp.isIncludedInBOM()){
                                        appApproval.includeInBOM = FALSE;
                                    }else{
                                        appApproval.autoApprove = TRUE;
                                    }
                                }
                            }
                            appApprovals.add(appApproval);
                        }
                    }
                }
            }
            
            //CDP Analyses
            if(corePacks!=null && !corePacks.isEmpty()){
                
                for(BOMGenericWrapper cdpWrapper : corePacks.keySet()){
                	Core_Device_Package__c corePack = cdpWrapper.getCDP();
                    
                     List<BOMGenericWrapper> cdpApps = corePacks.get(cdpWrapper);

                     if(cdpApps!=null && !cdpApps.isEmpty()){
                            
                         for(BOMGenericWrapper cdpApp : cdpApps){
                             Application__c app = cdpApp.getApp();
                             
                             BOMApplicationApproval appApproval = new BOMApplicationApproval();
                             
                             //Means that is an app is Automate_Partner_Checklist_Approval__c
                             //It will be auto-aproved when create DevApp Junction.
                             Boolean autoApprove = FALSE;
                             
                             try{
                                 autoApprove = app.Automate_Partner_Checklist_Approval__c;
                             }catch(Exception e1){
                                 System.debug('auto approve is false 3');
                             }
                             
                             if(autoApprove){
                                 appApproval.application = app;
                                 appApproval.autoApprove = TRUE;
                                 appApproval.corePack	 = corePack;
                                 
                                 if(!cdpApp.isIncludedInBOM()){
                                     appApproval.includeInBOM = FALSE;
                                 }
                                 appApprovals.add(appApproval);
                             }else{
                                 if(isAppIncludedInBOMFromCDP(app.Id, corePack.Id)){
                                     
                                     appApproval.application  = app;
                                     appApproval.corePack     = corePack;
                                     appApproval.autoApprove  = TRUE;
                                     appApproval.includeInBOM = TRUE;

                                 }else{
                                     appApproval.application = app;
                                     appApproval.corePack    = corePack;
                                     appApproval.autoApprove = FALSE;
                                
                                     if(!cdpApp.isIncludedInBOM()){
                                        appApproval.includeInBOM = FALSE;
                                     }else{
                                         appApproval.includeInBOM = TRUE;
                                     }
                                 }
                                 appApprovals.add(appApproval);
                             }
                         }
                     }
                }
            }
            
            
            //Program Apps
            if(programApps!=null && !programApps.isEmpty()){
                
                for(BOMGenericWrapper programWrapper : programApps.keySet()){
                	Program__c program = programWrapper.getProgram();
                    
                    
                     List<BOMGenericWrapper> progApps = programApps.get(programWrapper);

                     if(progApps!=null && !progApps.isEmpty()){
                            
                         for(BOMGenericWrapper appWrapper : progApps){
                             Application__c app = appWrapper.getApp();
                             
                             BOMApplicationApproval appApproval = new BOMApplicationApproval();
                             
                             //Means that is an app is Automate_Partner_Checklist_Approval__c
                             //It will be auto-aproved when create DevApp Junction.
                             Boolean autoApprove = FALSE;
                             
                             try{
                                 if(program.Reviewed_Approved__c!=null){
                                 	autoApprove = program.Reviewed_Approved__c.equals('Yes');    
                                 }
                             }catch(Exception e1){
                                 System.debug('auto approve is false 3');
                             }
                             
                             if(autoApprove){
                                 appApproval.application = app;
                                 appApproval.autoApprove = TRUE;
                                 appApproval.program	 = program;
                                 
                                 if(!appWrapper.isIncludedInBOM()){
                                     appApproval.includeInBOM = FALSE;
                                 }
                                 
                             }else{
                                 
                                 appApproval.application = app;
                                 appApproval.autoApprove = FALSE;
                                 appApproval.program     = program;

                                 if(!appWrapper.isIncludedInBOM()){
                                     appApproval.includeInBOM = FALSE;
                                 }else{
                                     appApproval.includeInBOM = TRUE;
                                 }
                             }
                             appApprovals.add(appApproval);
                         }
                     }
                }
            }
            
        }catch(Exception e){
            System.debug('Error on getAutoApproval = '+e);
        	throw e;
        }
        return appApprovals;
    }
    
    /**
	 * Verify if an App is Mandatory from a Stable Application.
	 */
    private Boolean isAppMandatoryFromStable(ID appID,ID stableID){
        try{
            Stable_Application__c stableApp = [SELECT Stable_App_Status__c FROM Stable_Application__c WHERE Application__c = :appID AND Stable__c = :stableID];
            
            if(stableApp!=null && stableApp.Stable_App_Status__c.equals('Mandatory')){
				return TRUE;
            }

        }catch(System.DmlException e){
            throw e;
        }
        return FALSE;
    }
    
    /**
     * Verify is an App is Mandatory from a Program_Application junction object.
     */
    private Boolean isAppMandatoryFromProgram(ID appID, ID programID){
        
        try{
            Program_Application__c programApp = [Select Status__c FROM Program_Application__c WHERE Application__c = :appID AND Program__c = :programID];
            
            if(programApp.Status__c !=null && programApp.Status__c.equals('Mandatory')){
                return TRUE;
            }
            
        }catch(System.DmlException dmle){
            throw dmle;
        }
		
		return false;        
    }
    
    
     /**
     * Verify if an App is Include In BOM in a Core Device Package Application.
     * 
     */
    private Boolean isAppIncludedInBOMFromCDP(ID appID, ID cdpID){
        try{
            Core_Device_Package_Application__c cdpa = [SELECT 
                                                       		Include_in_BOM__c 
                                                       FROM 
                                                       		Core_Device_Package_Application__c 
                                                       WHERE Application__c = :appID 
                                                       AND Core_Device_Package__c = :cdpID];
            
            if(cdpa!=null && cdpa.Include_in_BOM__c==TRUE){
                return TRUE;
            }
        }catch(System.DmlException e){
            throw e;
        }
        return FALSE;
    }
}