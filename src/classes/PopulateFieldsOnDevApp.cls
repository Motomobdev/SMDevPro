public with sharing class PopulateFieldsOnDevApp {
	public static void populateContractOwner(List<DeviceApplicationAssoc__c> devApps, Set<Id> appIds){
		Map<Id, Application__c> appIdMap = new Map<Id, Application__c>([SELECT Id, Application_Contract_Owner__c FROM Application__c WHERE Id IN : appIds]);
		
		for(DeviceApplicationAssoc__c devApp : devApps){
			try{
				//devApp.Contract_Owner__c = appIdMap.get(devApp.Application__c).Application_Contract_Owner__c;
			} catch (System.Nullpointerexception e){
				
			}
		}
	}
}