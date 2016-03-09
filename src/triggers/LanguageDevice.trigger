trigger LanguageDevice on Language_Device__c (after delete, after insert) {
	Set<Id> devIds = new Set<Id>();
	if(trigger.isInsert){
		/*** BEGIN calculate Partner Manager Checklist Approval automation PART 1A ***/
		for(Language_Device__c ld : trigger.new){
			devIds.add(ld.Device__c);
		}
		/*** END calculate Partner Manager Checklist Approval automation PART 1A ***/
	}
	
	if(trigger.isDelete){
		/*** BEGIN calculate Partner Manager Checklist Approval automation PART 1B ***/
		for(Language_Device__c ld : trigger.old){
			devIds.add(ld.Device__c);
		}
		/*** END calculate Partner Manager Checklist Approval automation PART 1B ***/		
	}
	/*** BEGIN calculate Partner Manager Checklist Approval automation PART 2 ***/
	Map<Id, Application__c> appsToCheckPartnerApprovalAutomation = new Map<Id, Application__c>([SELECT Id, Automate_Partner_Checklist_Approval__c FROM Application__c WHERE Id IN (SELECT Application__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : devIds) AND Automate_Partner_Checklist_Approval__c=true]);
	List<Id> appIdsUnchecked = new List<Id>();
	for(Id appId : appsToCheckPartnerApprovalAutomation.keySet()){
		appIdsUnchecked.add(appId);
	}
	PartnerManagerChecklistApproval.calculatePartnerManagerChecklistApproval(appIdsUnchecked);		
	//PartnerManagerChecklistApproval.calculatePartnerManagerChecklistApproval(appsToCheckPartnerApprovalAutomation);	
	/*** END calculate Partner Manager Checklist Approval automation PART 2 ***/
}