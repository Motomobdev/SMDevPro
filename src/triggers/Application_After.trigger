/*
** Test code for this trigger can be found in CreateNewDevAppRecord.testSubmitDevAppsForApproval()
*/

trigger Application_After on Application__c (after update) {
	//Map<Id, Application__c> updatedPartnerApprovalApps = new Map<Id, Application__c>();
	List<Id> updatedPartnerApprovalAppIds = new List<Id>();
	List<DeviceApplicationAssoc__c> thirdPartyUpdateList = new List<DeviceApplicationAssoc__c>();
	List<DeviceApplicationAssoc__c> relatedDevAppsForAppTypeUpdate = new List<DeviceApplicationAssoc__c>();
	List<Id> appsWithUpdatedRoyaltyCost = new List<Id>();
	
	for(Integer i=0; i<trigger.new.size(); i++){
		// check to see if roaylty high cost has been updated
		if((trigger.new[i].Royalty_High__c != trigger.old[i].Royalty_High__c) || (trigger.new[i].Royalty_Low__c != trigger.old[i].Royalty_Low__c) || trigger.new[i].Royalty_Current__c != trigger.old[i].Royalty_Current__c){
			appsWithUpdatedRoyaltyCost.add(trigger.new[i].Id);
		}
		
		// Check to see if Application Type has been updated
		if(trigger.new[i].Application_Type__c != trigger.old[i].Application_Type__c){
			List<DeviceApplicationAssoc__c> relatedDevApps = [SELECT id, device__c, application__c, application_type__c, DTS_Support__c, LRB_Approver__c, DTS_Approver__c, FMD_Status_Check_Approver__c, Confirmation_of_Budget_Approver__c, Finance_Approver__c, Requester__c, Device__r.ODM_Device__c, application__r.Account__r.Name, application__r.Carrier_Furnished__c FROM DeviceApplicationAssoc__c WHERE application__c =: trigger.new[i].Id AND (Approval_Status__c = 'Not Submitted' OR Approval_Status__c = 'Rejected')];
			if(!relatedDevApps.isEmpty()){
				relatedDevAppsForAppTypeUpdate.addAll(relatedDevApps);
			}			
		}
		
		// Check to see if Application 3rd Party Approval has been Updated
		// Test code for this section can be found at the end of test code in CreateNewDevAppRecord.cls
		if(trigger.new[i].X3rd_Party_Approval_Required__c != trigger.old[i].X3rd_Party_Approval_Required__c){
			for(DeviceApplicationAssoc__c devApp : [SELECT Id, X3rd_Party_Approval_Required__c FROM DeviceApplicationAssoc__c WHERE Application__c =: trigger.new[i].Id AND X3rd_Party_Approval_Status__c != 'Approved' AND X3rd_Party_Approval_Status__c != 'Rejected' AND Device_Cancelled__c != 'Yes' AND Approval_Status__c != 'Approved' AND Approval_Status__c != 'In Progress']){
				devApp.X3rd_Party_Approval_Required__c = trigger.new[i].X3rd_Party_Approval_Required__c;
				if(devApp.X3rd_Party_Approval_Required__c == true){
					devApp.X3rd_Party_Approval_Status__c = 'In Progress';
				}
				else{
					devApp.X3rd_Party_Approval_Status__c = 'N/A';
				}
				thirdPartyUpdateList.add(devApp);
			}						
		}
		
		/*** BEGIN calculate Partner Manager Checklist Approval automation ***/		
		// Check if App has been marked/unmarked for automatic Partner Checklist approval or 
		if(trigger.new[i].Automate_Partner_Checklist_Approval__c != trigger.old[i].Automate_Partner_Checklist_Approval__c || trigger.new[i].GMS_App__c != trigger.old[i].GMS_App__c){
			updatedPartnerApprovalAppIds.add(trigger.new[i].Id);
			//updatedPartnerApprovalApps.put(trigger.new[i].Id, trigger.new[i]);
		}
		/*** END calculate Partner Manager Checklist Approval automation ***/
	}
	
	// for Royalty High updated
	if(!appsWithUpdatedRoyaltyCost.isEmpty()){
		DeviceMethods.calculateEstimatedRoyaltyCostFromApps(appsWithUpdatedRoyaltyCost);
		ApplicationMethods.updateProgramApplicationCosts(appsWithUpdatedRoyaltyCost);
		StableMethods.calculateApplicationCostsFromAppIds(appsWithUpdatedRoyaltyCost);
		
		List<DeviceApplicationAssoc__c> devApps = [SELECT Id FROM DeviceApplicationAssoc__c WHERE Application__c IN : appsWithUpdatedRoyaltyCost AND Device_Cancelled__c = 'NO' AND (App_Item_State__c = '12 - Prelim' OR App_Item_State__c = '32 - Controlled')];
		if(!devApps.isEmpty()){ update devApps; }
	}
	
	// For App Type updates
	if(relatedDevAppsForAppTypeUpdate.size() > 0){
		AIFApproval.setAIFApprovers(relatedDevAppsForAppTypeUpdate);
		ApplicationManager.setAppManagers (relatedDevAppsForAppTypeUpdate);
		update relatedDevAppsForAppTypeUpdate;
	}		
	
	// update DevApps whose 3rd party requirment has changed
	if(!thirdPartyUpdateList.isEmpty()){
		update thirdPartyUpdateList;
	}
	
	// calculate partner manager checklist approval automation
	if(!updatedPartnerApprovalAppIds.isEmpty()){
		PartnerManagerChecklistApproval.calculatePartnerManagerChecklistApproval(updatedPartnerApprovalAppIds);
	}	
}