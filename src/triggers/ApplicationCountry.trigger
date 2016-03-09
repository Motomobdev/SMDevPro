trigger ApplicationCountry on Application_Country__c (after delete, after insert) {	
	Set<Id> appIds = new Set<Id>();
	
	if(trigger.isInsert){
		/*** BEGIN calculate Partner Manager Checklist Approval automation PART 1A ***/
		for(Application_Country__c ac : trigger.new){
			appIds.add(ac.Application__c);
		}
		/*** END calculate Partner Manager Checklist Approval automation PART 1A ***/		
	}
	
	if(trigger.isDelete){
		/*** BEGIN calculate Partner Manager Checklist Approval automation PART 1B ***/
		for(Application_Country__c ac : trigger.old){
			appIds.add(ac.Application__c);
		}		
		/*** END calculate Partner Manager Checklist Approval automation PART 1B***/
	}
	/*** BEGIN calculate Partner Manager Checklist Approval automation PART 2 ***/

	if(!appIds.isEmpty()){
		List<Id> appIdsUnchecked = new List<Id>();
		for(Application__c app : [SELECT Id FROM Application__c WHERE Id IN : appIds AND Automate_Partner_Checklist_Approval__c=true]){
			appIdsUnchecked.add(app.Id);
		}
		PartnerManagerChecklistApproval.calculatePartnerManagerChecklistApproval(appIdsUnchecked);
	}
	/*** END calculate Partner Manager Checklist Approval automation PART 2 ***/
	
	if(!appIds.isEmpty()){
		ApplicationCountryMethods.setLegallyShippableCountriesOnApplication(appIds);
		ApplicationCountryMethods.setApplicationCountriesCondensedListsOnApp(appIds);
	}
}