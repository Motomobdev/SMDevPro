public with sharing class DeviceApplicationApprovalProcess {
    Map<Id, DeviceApplicationAssoc__c> devAppMap;
    
    public DeviceApplicationApprovalProcess(){
    	
    }
    
    public DeviceApplicationApprovalProcess(List<DeviceApplicationAssoc__c> daList){
        devAppMap = new Map<Id, DeviceApplicationAssoc__c>();
        
        List<String> devAppIds = new List<String>();
        for(Integer i=0; i<daList.size(); i++){
            devAppIds.add(daList[i].Id);
        }
        
        List<DeviceApplicationAssoc__c> devAppFull = [SELECT id, Account__c, Approval_Status__c ,Application_Type__c, LRB_Approval__c, Application__r.Application_Type__c, Application_Contract_LRB_Pipeline_ID__c, 
        Application_Contract_LRB_Approved_Devic__c, Application_Contract_LRB_Approved_Region__c, Application_Contract_Decision__c, Application__r.Carrier_Furnished__c
        , Application__r.Account_Name__c, DTS_Approval__c, Application_Mgr_Selection_Approval__c, Application__r.Royalty_High__c, Application__r.Royalty_Low__c,
        Confirmation_of_Budget_Royalties__c, Partner_Manager_Checklist_Approval__c, Past_LRB_Approval__c, Past_SDS_Approval__c, Past_App_Mgr_Approval__c,
        Past_Budget_Approval__c, Device__r.Business_Unit__c, Application__r.Application_Sub_Type__c, Past_Partner_Manager_Approval__c, X3rd_Party_Approval_Status__c,
        Skip_Partner_Manager_Approval_Language__c, Skip_Partner_Manager_Approval_Country__c, Device__r.Skip_Budget_Approval__c,
        X3rd_Party_Approval_Required__c, Device__r.Platform__c FROM DeviceApplicationAssoc__c WHERE Id IN : devAppIds ];

        devAppMap.putAll(devAppFull);
    }
    
    public DeviceApplicationApprovalProcess(List<Id> devAppIds){
        devAppMap = new Map<Id, DeviceApplicationAssoc__c>();
                
        List<DeviceApplicationAssoc__c> devAppFull = [SELECT id, Account__c, Approval_Status__c, Application_Type__c, LRB_Approval__c, Application__r.Application_Type__c, Application_Contract_LRB_Pipeline_ID__c, 
        Application_Contract_LRB_Approved_Devic__c, Application_Contract_LRB_Approved_Region__c, Application_Contract_Decision__c, Application__r.Carrier_Furnished__c
        , Application__r.Account_Name__c, DTS_Approval__c, Application_Mgr_Selection_Approval__c, Application__r.Royalty_High__c, Application__r.Royalty_Low__c,
        Confirmation_of_Budget_Royalties__c, Partner_Manager_Checklist_Approval__c, Past_LRB_Approval__c, Past_SDS_Approval__c, Past_App_Mgr_Approval__c,
        Past_Budget_Approval__c, Device__r.Business_Unit__c, Application__r.Application_Sub_Type__c, Past_Partner_Manager_Approval__c, X3rd_Party_Approval_Status__c,
        Skip_Partner_Manager_Approval_Language__c, Skip_Partner_Manager_Approval_Country__c, Device__r.Skip_Budget_Approval__c,
        X3rd_Party_Approval_Required__c, Device__r.Platform__c FROM DeviceApplicationAssoc__c WHERE Id IN : devAppIds ];

        devAppMap.putAll(devAppFull);
    }
    
    public void setSkipfields(List<DeviceApplicationAssoc__c> daList){
        
        devAppMap = new Map<Id, DeviceApplicationAssoc__c>([SELECT id, Account__c, Approval_Status__c ,Application_Type__c, LRB_Approval__c, Application__r.Application_Type__c, Application_Contract_LRB_Pipeline_ID__c, 
        Application_Contract_LRB_Approved_Devic__c, Application_Contract_LRB_Approved_Region__c, Application_Contract_Decision__c, Application__r.Carrier_Furnished__c
        , Application__r.Account_Name__c, DTS_Approval__c, Application_Mgr_Selection_Approval__c, Application__r.Royalty_High__c, Application__r.Royalty_Low__c,
        Confirmation_of_Budget_Royalties__c, Partner_Manager_Checklist_Approval__c, Past_LRB_Approval__c, Past_SDS_Approval__c, Past_App_Mgr_Approval__c,
        Past_Budget_Approval__c, Device__r.Business_Unit__c, Application__r.Application_Sub_Type__c, Past_Partner_Manager_Approval__c, X3rd_Party_Approval_Status__c,
        Skip_Partner_Manager_Approval_Language__c, Skip_Partner_Manager_Approval_Country__c, Device__r.Skip_Budget_Approval__c,
        X3rd_Party_Approval_Required__c, Device__r.Platform__c, Application__r.Automate_Partner_Checklist_Approval__c FROM DeviceApplicationAssoc__c WHERE Id IN : daList ]);
    	
    	
    	List<DeviceApplicationAssoc__c> devAppsForPartnerManagerChecklistApproval = new List<DeviceApplicationAssoc__c>();
    	
    	for(DeviceApplicationAssoc__c devApp : devAppMap.Values()){
    		devApp.Skip_SDS_Approval__c = skipSDSApproval(devApp.Id);
    		devApp.Skip_App_Manager_Selection_Approval__c = skipApplicationManagerSelectionApproval(devApp.Id);
    		system.debug('THIS IS devApp.Application__r.Automate_Partner_Checklist_Approval__c: ' + devApp.Application__r.Automate_Partner_Checklist_Approval__c);
    		if(devApp.Application__r.Automate_Partner_Checklist_Approval__c == true){ devAppsForPartnerManagerChecklistApproval.add(devApp); }
    	}
    	
    	system.debug('DEVAPPS FOR PartnerMGRCHECKLIST: ' + devAppsForPartnerManagerChecklistApproval);

		PartnerManagerChecklistApproval.calculatePartnerManagerChecklistApproval(devAppsForPartnerManagerChecklistApproval);
    	
    	update devAppMap.values();
    }

    public Boolean skipLRBApproval(Id devAppId){
        // follow entry critera for step 1 of approval process
        // if all checks pass do NOT skip LRB Approval step
        //system.debug('apptype: ' + devApp.Application__r.Application_Type__c + ', Application_Contract_LRB_Pipeline_ID__c: ' + devApp.Application_Contract_LRB_Pipeline_ID__c + ', lrb approv dev: ' + devApp.Application_Contract_LRB_Approved_Devic__c + ', lrb app region: ' + devApp.Application_Contract_LRB_Approved_Region__c + ', contract decision: ' + devApp.Application_Contract_Decision__c);
        if((devAppMap.get(devAppId).Application__r.Application_Type__c == 'Services' || devAppMap.get(devAppId).Application__r.Application_Type__c == 'Embedded' || devAppMap.get(devAppId).Application__r.Application_Type__c == 'Preload') || devAppMap.get(devAppId).Application_Type__c == null){
            if(devAppMap.get(devAppId).Application_Contract_LRB_Pipeline_ID__c != 'grandfathered'){
            	if(devAppMap.get(devAppId).Application_Contract_Decision__c != 'Pass'){  
                	if(devAppMap.get(devAppId).Application_Contract_Decision__c != 'Exempt / N/A' ){                        
                    	return false;
                  	}
                }                  
            }
        }       
        return true;
    }
    
    public Boolean isThisLRBApprovalStep(Id devAppId){
        if(devAppMap.get(devAppId).Approval_Status__c == 'In Progress'){
            if(devAppMap.get(devAppId).Past_LRB_Approval__c == false){
                return true;
            }
        }       
        return false;
    }
    
    public Boolean skipSDSApproval(Id devAppId){
        // follow entry criteria for step 2 of approval process
        // if all checks pass do NOT skip SDS approval
        if(((devAppMap.get(devAppId).Application__r.Carrier_Furnished__c != 'Carrier managed') && (devAppMap.get(devAppId).Application__r.Application_Type__c == 'Carrier App')) || ((devAppMap.get(devAppId).Application__r.Application_Type__c == 'Preload') && (devAppMap.get(devAppId).Application__r.Account_Name__c != 'Google')) || (devAppMap.get(devAppId).Application__r.Application_Type__c == null)){
            if(devAppMap.get(devAppId).Device__r.Business_Unit__c != 'Companion Products'){
            	return false;
            }
        }   
        return true;
    }
    
    public Boolean isThisSDSApprovalStep(Id devAppId){
        if(devAppMap.get(devAppId).Approval_Status__c == 'In Progress'){
            if(devAppMap.get(devAppId).Past_LRB_Approval__c == true){
                if(devAppMap.get(devAppId).Past_SDS_Approval__c == false){
                    return true;
                }
            }   
        }       
        return false;
    }    
    
     public Boolean skipApplicationManagerSelectionApproval(Id devAppId){
        // follow entry criteria for step 3 of approval process
        // if all checks pass do NOT skip Application Manager Selection approval
        if(devAppMap.get(devAppId).Application__r.Application_Type__c == 'Preload' || (devAppMap.get(devAppId).Application__r.Application_Type__c == 'Carrier App' && devAppMap.get(devAppId).Application__r.Carrier_Furnished__c != 'Carrier Managed')){
        	if(devAppMap.get(devAppId).Account__c == 'Google' && devAppMap.get(devAppId).Device__r.Platform__c != 'Android'){
                if(devAppMap.get(devAppId).Device__r.Business_Unit__c != 'Companion Products'){
                    return false;
                }
        	}
        }                    
        return true;
    }
    
    public Boolean isThisApplicationManagerSelectionApproval(Id devAppId){
        if(devAppMap.get(devAppId).Approval_Status__c == 'In Progress'){
            if(devAppMap.get(devAppId).Past_LRB_Approval__c == true){
                if(devAppMap.get(devAppId).Past_SDS_Approval__c == true){
                    if(devAppMap.get(devAppId).Past_App_Mgr_Approval__c == false){
                        return true;
                    }
                }
            }           
        }
        return false;
    }
    
    public Boolean skipBudgetRoyaltiesApproval(Id devAppId){
        // follow entry criteria for step 4 of approval process
        // if all checks pass do NOT skip Budget Royalties approval     
        return devAppMap.get(devAppId).Device__r.Skip_Budget_Approval__c;
    }
    
    public Boolean isThisBudgetRoyaltiesApproval(Id devAppId){
        if(devAppMap.get(devAppId).Approval_Status__c == 'In Progress'){
            if(devAppMap.get(devAppId).Past_LRB_Approval__c == true){
                if(devAppMap.get(devAppId).Past_SDS_Approval__c == true){
                    if(devAppMap.get(devAppId).Past_App_Mgr_Approval__c == true){
                        if(devAppMap.get(devAppId).Past_Budget_Approval__c == false){
                            return true;
                        }
                    }
                }
            }           
        }
        return false;
    }
    
    public Boolean skipPartnerManagerChecklistApproval(Id devAppId){
        // follow entry criteria for step 5 of approval process
        // if all checks pass do NOT skip Partner Manager Checklist approval
        if(/*devAppMap.get(devAppId).Skip_Partner_Manager_Approval_Language__c == true && */devAppMap.get(devAppId).Skip_Partner_Manager_Approval_Country__c == true){
        	// languages check disabled as per 2/23 weekly meeting, Ingred's note
        	return true;
        }        
        return false;
    }
    
    public Boolean isThisPartnerManagerChecklistApproval(Id devAppId){
        if(devAppMap.get(devAppId).Approval_Status__c == 'In Progress'){
            if((devAppMap.get(devAppId).Past_Budget_Approval__c == true) /*&& (devAppMap.get(devAppId).Partner_Manager_Checklist_Approval__c == 'In Progress')*/){
        		if(devAppMap.get(devAppId).Past_Partner_Manager_Approval__c == false){
            		return true;
        		}
            }
        }
        return false;
    }
    
    public Boolean isThis3rdPartyPartnerApproval(Id devAppId){
    	if(devAppMap.get(devAppId).Past_Partner_Manager_Approval__c == true && 
    		devAppMap.get(devAppId).X3rd_Party_Approval_Status__c == 'In Progress' &&
    		devAppMap.get(devAppId).X3rd_Party_Approval_Required__c == true){
    			return true;
		}
    	return false;
    }
}