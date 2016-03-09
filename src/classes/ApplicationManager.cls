/*
Methods used to set various Application Manager/Approver fields on Device Applications when they are created
The fields that are set here are used by Device Application Approval Process
*/

public with sharing class ApplicationManager {

	//Define both variables
	//public static string dev_apps_sfdc = '';
	public static Set<Id> dev_apps_sfdc2 = NEW Set<Id>();
	private static boolean isTestMode = false;
   	
   	private static Map<ID,Application_Manager_Selection_Matrix__c> PRE_APPLICATION_MAP_CONST {
        get {
            if (PRE_APPLICATION_MAP_CONST == null) { PRE_APPLICATION_MAP_CONST = getPREApplicationManagerMap(); }
            return PRE_APPLICATION_MAP_CONST;
        }
        set;
    }
    private static Map<ID,Application_Manager_Selection_Matrix__c> OTHER_APPLICATION_MAP_CONST {
        get {
            if (OTHER_APPLICATION_MAP_CONST == null) { OTHER_APPLICATION_MAP_CONST = getOTHERApplicationManagerMap(); }
            return OTHER_APPLICATION_MAP_CONST;
        }
        set;
    }
    private static Map<ID,Application_Manager_Selection_Matrix__c> EMB_APPLICATION_MAP_CONST {
        get {
            if (EMB_APPLICATION_MAP_CONST == null) { EMB_APPLICATION_MAP_CONST=getEMBApplicationManagerMap(); }
            return EMB_APPLICATION_MAP_CONST;
        }
        set;
    }       

	//PRELOAD - App Type Map
	private static Map<ID,Application_Manager_Selection_Matrix__c> getPREApplicationManagerMap(){ 
		Map<ID,Application_Manager_Selection_Matrix__c> results = new Map<ID,Application_Manager_Selection_Matrix__c>(); 

		for(Application_Manager_Selection_Matrix__c record : [select device__c, application_type__c,application_manager__c from Application_Manager_Selection_Matrix__c WHERE Device__c in : dev_apps_sfdc2 AND application_type__c='Preload']){ results.put(record.device__c, record); }
	   	return results; 
	} 

	//EMBEDDED - App Type Map
	private static Map<ID,Application_Manager_Selection_Matrix__c> getEMBApplicationManagerMap(){ 
		Map<ID,Application_Manager_Selection_Matrix__c> results = new Map<ID,Application_Manager_Selection_Matrix__c>(); 

		for(Application_Manager_Selection_Matrix__c record : [select device__c, application_type__c,application_manager__c from Application_Manager_Selection_Matrix__c  WHERE Device__c in : dev_apps_sfdc2 AND application_type__c='Embedded']){ results.put(record.device__c, record); }
	   	return results; 
	} 

	//OTHER - App Type Map
	private static Map<ID,Application_Manager_Selection_Matrix__c> getOTHERApplicationManagerMap(){ 
		Map<ID,Application_Manager_Selection_Matrix__c>results = new Map<ID,Application_Manager_Selection_Matrix__c>(); 

	   	for(Application_Manager_Selection_Matrix__c record : [select device__c, application_type__c,application_manager__c from Application_Manager_Selection_Matrix__c WHERE Device__c in : dev_apps_sfdc2 AND application_type__c !='Preload' AND application_type__c !='Embedded']){ results.put(record.device__c, record); }
	   	return results; 
	} 


	//Set the Application Managers - REVISED BY JESSE
	public static void setAppManagers(Deviceapplicationassoc__c[] devapps){ 
	    
	    // get list of all device Id's from devApp records
		for (Deviceapplicationassoc__c d:devapps){
		    dev_apps_sfdc2.add(d.Device__c);
		}			
		
		/* RULES FROM Kirsten Row
		If app is a type other than Preload or CBS- Motorola Managed (carrier furnished): Set this to "No Support" and skip SDS Approval step
		If app type is Preloads or CBS- Carrier managed, automate to:
			GMS apps- Set this to "No Support" and skip SDS Approval step
			If the device is an ODM program, always set to "Tier 2 support" and route for SDS approval
			For Preloads or CBS-Motorola managed, set to "Tier 1" and route for SDS approval			
		*/		  
	        
		for (Deviceapplicationassoc__c devApp : devapps){
		   System.debug('DEVICE ********************* ' + devApp.device__c);
		        
		    if(devApp.device__c != null){
		    	// New version of logic v2
				if (devApp.application_type__c == 'Embedded'){				
					try{
	                    devApp.Application_Manager_Selection_Approver__c= EMB_APPLICATION_MAP_CONST.get(devApp.device__c).application_manager__c; 
						devApp.DTS_Support__c = 'No';
					} catch(System.NullPointerException e){
						
					}
					// skip SDS approval
				}
				else if (devApp.application_type__c == 'Other' || devApp.application_type__c == 'Postload' || devApp.application_type__c == 'Services'|| devApp.application_type__c == 'IP Settlement' || devApp.application_type__c == ''){ 
                    try{
	                    devApp.Application_Manager_Selection_Approver__c= OTHER_APPLICATION_MAP_CONST.get(devApp.device__c).application_manager__c; 
	     				devApp.DTS_Support__c = 'No';
	     			} catch(System.NullPointerException e){
						
					}
     				// skip SDS Approval
	            } 
			    else if (devApp.Application_Type__c == 'Preload'){ 
			    	try{
                    	devApp.Application_Manager_Selection_Approver__c= PRE_APPLICATION_MAP_CONST.get(devApp.device__c).application_manager__c;
                    } catch(System.NullPointerException e){
						
					}   
										
					// if type is NOT ODM set DT Support = Tier 1  - route for approval
					if(devApp.Device__r.ODM_Device__c == true){ devApp.DTS_Support__c = 'Tier 2'; 
						// route for SDS approval
		    		}
		    		else{ devApp.DTS_Support__c = 'Tier 1';
		    			// route for SDS approval
		    		}
					
					// if GMS -  to "No Support" and skip SDS Approval step	(where google is the account)
					if(devApp.application__r.Account__r.Name == 'Google'){ devApp.DTS_Support__c = 'No';
						// skip SDS Approval
					}
		        } 
			    else if (devApp.application_type__c == 'Carrier App'){ 
			    	try{
                    	devApp.Application_Manager_Selection_Approver__c= OTHER_APPLICATION_MAP_CONST.get(devApp.device__c).application_manager__c;
			    	} catch(System.NullPointerException e){
						
					}
                    if(devApp.application__r.Carrier_Furnished__c == 'Motorola managed'){ devApp.DTS_Support__c = 'Tier 1';
                    	// route for SDS approval
                    }
                    if(devApp.application__r.Carrier_Furnished__c == 'Carrier managed'){ devApp.DTS_Support__c = 'No';
     					// skip SDS Approval
                    }			
				}
		    	else {
					devApp.Application_Manager_Selection_Approver__c = NULL;
		    	}

		   }
   		}
   		
	}   

private testmethod static void FINALTEST() {
//Map<ID,Application_Manager_Selection_Matrix__c>mymap1= getotherApplicationManagerMap();
//Map<ID,Application_Manager_Selection_Matrix__c>mymap2= getEmbApplicationManagerMap();
    DeviceApplicationAssoc__c d = new DeviceApplicationAssoc__c();
    List<DeviceApplicationAssoc__c> ds = new List<DeviceApplicationAssoc__c>();
    ds.add(d);
    setAppManagers(ds);
}
}