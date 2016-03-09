public with sharing class Application_Insert {
	public static void beforeInsert(List<Application__c> newList){
		ApplicationMethods.setAvailableForUseToFalse(newList);
		ApplicationMethods.setSkipLRBField(newList);
	}
	
	public static void afterInsert(List<Application__c> newList){
		ApplicationMethods.fillMicrogenApplicationId(newList);
	}
}