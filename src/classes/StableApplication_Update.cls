public with sharing class StableApplication_Update {
	public static void afterUpdate(List<Stable_Application__c> newList, List<Stable_Application__c> oldList){
		List<Stable_Application__c> stableAppsWithStatusUpdates = new List<Stable_Application__c>();
		List<Id> stableIdsWithUpdatedStatus = new List<Id>();
		List<Id> appIdsWithUpdatedStatus = new List<Id>();
		List<Id> stableIds = new List<Id>();
		List<Id> appIds = new List<Id>();
		
		for(Integer i=0; i<newList.size(); i++){
			system.debug('newlist.status new,old: ' + newList[i].Stable_App_Status__c +', ' + oldList[i].Stable_App_Status__c);
			if(newList[i].Stable_App_Status__c != oldList[i].Stable_App_Status__c){
				stableIdsWithUpdatedStatus.add(newList[i].Stable__c);
				appIdsWithUpdatedStatus.add(newList[i].Application__c);
			}
			
			if(newList[i].Stable_App_Status__c == 'Mandatory' && newList[i].Stable_App_Status__c != oldList[i].Stable_App_Status__c){
				stableIds.add(newList[i].Stable__c);
				appIds.add(newList[i].Application__c);
				
			}
		}
		
		StableApplicationMethods.normalizeStatusOfStableAppDuplicates(stableIds, appIds);
		
		if(!stableIds.isEmpty()){
			List<DeviceApplicationAssoc__c> devApps = [SELECT Id, Include_in_BOM__c FROM DeviceApplicationAssoc__c WHERE Source_Id__c IN : stableIds AND Application__c IN : appIds AND Include_in_BOM__c = false];
			for(DeviceApplicationAssoc__c da : devApps){
				da.Include_in_BOM__c = true;
			}
			update devApps;
		}
	}
}