public with sharing class StableApplication_Insert {
	public static void beforeInsert(List<Stable_Application__c> newList){
		List<Id> appIds = new List<Id>();
		List<Id> stableIds = new List<Id>();
		
		for(Stable_Application__c sa : newList){
			appIds.add(sa.Application__c);
			stableIds.add(sa.Stable__c);
		}
		
		// temporarily removed as validation as per Keith P
		//StableApplicationMethods.checkForApplictionContract(newList, appIds);
		StableApplicationMethods.checkForExistingStableApplicationsAndPopulateFields(newList, appIds, stableIds);
	}
	
	public static void afterInsert(List<Stable_Application__c> newList){
		List<Id> stableIds = new List<Id>();
		List<Id> appIds = new List<Id>();
		List<Stable_Application__c> stableAppsWithoutSource = new List<Stable_Application__c>();
		
		for(Stable_Application__c sa : newList){
			stableIds.add(sa.Stable__c);
			appIds.add(sa.Application__c);
			if(sa.Source_Id__c == null){ stableAppsWithoutSource.add(sa); }
		}
		StableMethods.calculateApplicationCostsFromStableIds(stableIds);
		
		StableApplicationMethods.normalizeStatusOfStableAppDuplicates(stableIds, appIds);
		
		try{
			StableApplicationMethods.addAppToStableParents(stableAppsWithoutSource);
		} catch(System.DMLException e){
			for(Stable_Application__c sa : newList){
				sa.addError('There was a problem adding Application to Cores and Devices that use Stable');
			}
		}
	}
}