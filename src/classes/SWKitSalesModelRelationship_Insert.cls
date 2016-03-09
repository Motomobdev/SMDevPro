public with sharing class SWKitSalesModelRelationship_Insert {
	public static void beforeInsert(List<SWKit_SalesModel_Relationship__c> newList){
		SWKitSalesModelRelationshipMethods.fillInLookupFieldsOnNewRecords(newList);
		SWKitSalesModelRelationshipMethods.syncSalesModelsToDevicesWithSWKits(newList);
	}
}