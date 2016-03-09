public with sharing class Application_Delete {
	public static void beforeDelete(List<Application__c> oldList){
		ApplicationMethods.validateApplicationDelete(oldList);
	}
}