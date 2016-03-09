/*
 * This class/trigger tested in CreateNewDevAppRecord.testSubmitDevAppsForApproval
 */

public with sharing class ApplicationManagerMatrixUpdate {
	public static List<Application_Manager_Selection_Matrix__c> ammList;
	public static Map<Id, DeviceApplicationAssoc__c> updateMap = new Map<Id, DeviceApplicationAssoc__c>();


	public static void processRecords(Set<ID> ammIds){
		ammList = [SELECT Id, Device__c, Application_Manager__c, Application_Type__c FROM Application_Manager_Selection_Matrix__c WHERE Id IN : ammIds];
		
		/*Map<Id, Application_Manager_Selection_Matrix__c> ammIdMap = new Map<Id, Application_Manager_Selection_Matrix__c>();
		ammIdMap.putAll(ammList);

		List<Id> OtherAmmDeviceIds = new List<Id>();
		List<Id> RegularAmmDeviceIds = new List<Id>();	
			
		for(Application_Manager_Selection_Matrix__c amm : ammList){
			if(amm.Application_Type__c == 'Other'){
				OtherAmmDeviceIds.add(amm.Device__c);
			}
			else{
				RegularAmmDeviceIds.add(amm.Device__c);		
			}
		}
		
		for(DeviceApplicationAssoc__c devApp : [SELECT Id, Application_Manager_Selection_Approver__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : OtherAmmDeviceIds AND Approval_Status__c = 'Not Submitted' AND Application_Type__c != 'Embedded' AND Application_Type__c != 'Preload']){
			devApp.Application_Manager_Selection_Approver__c = amm.Application_Manager__c;
			updateList.add(devApp);
		}
		
		for(DeviceApplicationAssoc__c devApp : [SELECT Id, Application_Manager_Selection_Approver__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : RegularAmmDeviceIds AND Approval_Status__c = 'Not Submitted' AND Application_Type__c =: amm.Application_Type__c]){
			devApp.Application_Manager_Selection_Approver__c = amm.Application_Manager__c;
			updateList.add(devApp);
		}		
		*/
		for(Application_Manager_Selection_Matrix__c amm : ammList){
			if(amm.Application_Type__c == 'Other'){
				for(DeviceApplicationAssoc__c devApp : [SELECT Id, Application_Manager_Selection_Approver__c FROM DeviceApplicationAssoc__c WHERE Device__c =: amm.Device__c AND Approval_Status__c = 'Not Submitted' AND Application_Type__c != 'Embedded' AND Application_Type__c != 'Preload']){
					if(updateMap.containsKey(devApp.Id)){
						DeviceApplicationAssoc__c temp = updateMap.remove(devApp.Id);
						temp.Application_Manager_Selection_Approver__c = amm.Application_Manager__c;
						updateMap.put(temp.Id, temp);
					} else {
						devApp.Application_Manager_Selection_Approver__c = amm.Application_Manager__c;
						updateMap.put(devApp.Id, devApp);
					}
				}
			}
			else{
				for(DeviceApplicationAssoc__c devApp : [SELECT Id, Application_Manager_Selection_Approver__c FROM DeviceApplicationAssoc__c WHERE Device__c =: amm.Device__c AND Approval_Status__c = 'Not Submitted' AND Application_Type__c =: amm.Application_Type__c]){
					if(updateMap.containsKey(devApp.Id)){
						DeviceApplicationAssoc__c temp = updateMap.remove(devApp.Id);
						temp.Application_Manager_Selection_Approver__c = amm.Application_Manager__c;
						updateMap.put(temp.Id, temp);
					} else {
						devApp.Application_Manager_Selection_Approver__c = amm.Application_Manager__c;
						updateMap.put(devApp.Id, devApp);
					}
				}				
			}
		}
		update updateMap.values();
	
	}

	//@future
	public static void updateRecords(Set<ID> aifIds){
		processRecords(aifIds);
	}
}