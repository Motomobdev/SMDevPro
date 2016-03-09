trigger LanguageApplication on Language_Application__c (after delete, after insert) {
	Set<Id> appIds = new Set<Id>();
	if(trigger.isInsert){
		/*** BEGIN calculate Partner Manager Checklist Approval automation PART 1A ***/
		for(Language_Application__c la : trigger.new){
			appIds.add(la.Application__c);
		}
		/*** END calculate Partner Manager Checklist Approval automation PART 1A ***/
	}
	
	if(trigger.isDelete){
		/*** BEGIN calculate Partner Manager Checklist Approval automation PART 1B ***/
		for(Language_Application__c la : trigger.old){
			appIds.add(la.Application__c);
		}
		/*** END calculate Partner Manager Checklist Approval automation PART 1B***/		
	}
	/*** BEGIN calculate Partner Manager Checklist Approval automation PART 2 ***/	
	//Map<Id, Application__c> appsToCheckPartnerApprovalAutomation = new Map<Id, Application__c>([SELECT Id, Automate_Partner_Checklist_Approval__c FROM Application__c WHERE Id IN : appIdsUnchecked]);
	if(!appIds.isEmpty()){
		List<Id> appIdsUnchecked = new List<Id>();
		for(Application__c app : [SELECT Id FROM Application__c WHERE Id IN : appIds AND Automate_Partner_Checklist_Approval__c=true]){
			appIdsUnchecked.add(app.Id);
		}
		PartnerManagerChecklistApproval.calculatePartnerManagerChecklistApproval(appIdsUnchecked);
	}
	//PartnerManagerChecklistApproval.calculatePartnerManagerChecklistApproval(appsToCheckPartnerApprovalAutomation);
	/*** END calculate Partner Manager Checklist Approval automation PART 2 ***/
}