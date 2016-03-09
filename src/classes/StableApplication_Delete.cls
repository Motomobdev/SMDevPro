public with sharing class StableApplication_Delete {
	public static void beforeDelete(List<Stable_Application__c> oldList){
		List<Id> appIds = new List<Id>();
		List<Id> stableIds = new List<Id>();
		List<String> applicationSourceIds = new List<String>();
		for(Stable_Application__c sa : oldList){
			if(sa.Source_Id__c == null && sa.Application_Source_Id__c == null){
				appIds.add(sa.Application__c);
				stableIds.add(sa.Stable__c);
				String applicationSourceId = sa.Stable__c;
				if(applicationSourceId.length() == 18){
					applicationSourceId = applicationSourceId.substring(0,15);
				}
				applicationSourceIds.add(applicationSourceId);
			}
		}
		
		try{
			StableApplicationMethods.checkSourceBeforeStableAppDelete(oldList);
			StableApplicationMethods.removeAppsFromStableParentsAndStableDevices(appIds, stableIds, applicationSourceIds);
		} catch(System.DMLException e){
			for(Stable_Application__c sa : oldList){
				sa.addError('There was a problem removing Application from Cores and Devices that use Stable');
			}
		}
	}
	
	public static void afterDelete(List<Stable_Application__c> oldList){
		List<Id> appIds = new List<Id>();
		List<Id> stableIds = new List<Id>();
		for(Stable_Application__c sa : oldList){
			appIds.add(sa.Application__c);
			stableIds.add(sa.Stable__c);
		}
		StableMethods.calculateApplicationCostsFromStableIds(stableIds);
		StableApplicationMethods.normalizeStatusOfStableAppDuplicates(stableIds, appIds);
	}
}