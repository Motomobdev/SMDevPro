trigger DeviceCountry on DeviceCountryAssoc__c (after delete, after insert) {
	Set<Id> devIds = new Set<Id>();
	if(trigger.isInsert){
		for(DeviceCountryAssoc__c dc : trigger.new){
			devIds.add(dc.Device__c);
		}
	}
	
	if(trigger.isDelete){
		for(DeviceCountryAssoc__c dc : trigger.old){
			devIds.add(dc.Device__c);
		}	
	}
	
	//DeviceCountryMethods.setMicrogenCountriesOnDevice(devIds);
	
	/*** BEGIN calculate Partner Manager Checklist Approval automation ***/
	Map<Id, Application__c> appsToCheckPartnerApprovalAutomation = new Map<Id, Application__c>([SELECT Id, Automate_Partner_Checklist_Approval__c FROM Application__c WHERE Id IN (SELECT Application__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : devIds) AND Automate_Partner_Checklist_Approval__c=true]);
	List<Id> appIdsUnchecked = new List<Id>();
	for(Id appId : appsToCheckPartnerApprovalAutomation.keySet()){
		appIdsUnchecked.add(appId);
	}
	PartnerManagerChecklistApproval.calculatePartnerManagerChecklistApproval(appIdsUnchecked);
	//PartnerManagerChecklistApproval.calculatePartnerManagerChecklistApproval(appsToCheckPartnerApprovalAutomation);	
	/*** END calculate Partner Manager Checklist Approval automation ***/
}