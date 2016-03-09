/*
 * Test code for this class found in NPI_DeviceMatrices.TestMethod1()
 */
public with sharing class AIFApprovalMatrixUpdate {  
  	public static List<AIF_Approval_Matrix__c> aifList;
  	public static List<DeviceApplicationAssoc__c> updateList = new List<DeviceApplicationAssoc__c>();


  	public static void processRecords(Set<ID> aifIds){
    	aifList = [SELECT Id, Device_Name__c, LRB_Approver__c, DTS_Approver__c, FMD_Status_Check_Approver__c, Confirmation_of_Budget_Approver__c, Finance_Approver__c, Application_Requester__c FROM AIF_Approval_Matrix__c WHERE Id IN : aifIds];
    
    	Set<Id> deviceIds = new Set<Id>();
    	for(AIF_Approval_Matrix__c aif : aifList){
    		deviceIds.add(aif.Device_Name__c);
    	}
    
    	List<DeviceApplicationAssoc__c> devApps = [SELECT Id, Device__c, Requester__c, FMD_Status_Check_Approver__c, Confirmation_of_Budget_Approver__c, DTS_Approver__c, Finance_Approver__c, LRB_Approver__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : deviceIds AND Approval_Status__c != 'Approved' AND Device_Cancelled__c = 'No'];
    	
    	Map<Id, DeviceApplicationAssoc__c> devAppIdMap = new Map<Id, DeviceApplicationAssoc__c>();
  
    	for(AIF_Approval_Matrix__c aam : aifList){    
      		for(Integer i=0; i<devApps.size(); i++){
      			if(aam.Device_Name__c == devApps[i].Device__c){
			        devApps[i].LRB_Approver__c = aam.LRB_Approver__c;
			        devApps[i].DTS_Approver__c = aam.DTS_Approver__c;
			        devApps[i].FMD_Status_Check_Approver__c = aam.FMD_Status_Check_Approver__c;
			        devApps[i].Confirmation_of_Budget_Approver__c = aam.Confirmation_of_Budget_Approver__c;
			        devApps[i].Finance_Approver__c = aam.Finance_Approver__c;
			        devApps[i].Requester__c = aam.Application_Requester__c;
			        devAppIdMap.put(devApps[i].Id, devApps[i]);
      			}      
      		}
    	}
    	
    	updateList = devAppIdMap.Values();
    	update updateList;    
  	}

  	@future
  	public static void updateRecords(Set<ID> aifIds){
    	processRecords(aifIds);
  	}
  
	private testmethod static void AIFApprovalMatrixUpdateTest(){                
	    User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
	    Account acc = new Account(Name='account');
		insert acc;

	    List<Application__c> apps = new List<Application__c>{new Application__c(Name='App1', application_type__c = 'Preload', Application_Sub_Type__c='faketype', Royalty_Low__c=5, Royalty_High__c=25, Account__c=acc.Id, Available_For_Use__c=true)};
	    insert apps;
	    
	    Device__c dev = new Device__c(Name='Dev1');
	    
	    System.runAs(p) {        
	    	insert dev;
		}
		      
	    DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c(Device__c=dev.Id, Application__c=apps[0].Id);
	    insert devApp;
		    
		AIF_Approval_Matrix__c aam = [SELECT id FROM AIF_Approval_Matrix__c WHERE Device_Name__c =: devApp.Device__c LIMIT 1];        
	    Test.startTest();
	    	update aam;	
        Test.stopTest();
  	}

}