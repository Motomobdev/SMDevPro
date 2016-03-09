public with sharing class SWKitSalesModelRelationship_Update {
	public static void afterUpdate(List<SWKit_SalesModel_Relationship__c> newList, List<SWKit_SalesModel_Relationship__c> oldList){
		List<SWKit_SalesModel_Relationship__c> noLongerActive = new List<SWKit_SalesModel_Relationship__c>();
			
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Current_SWKIT_SM_Mapping__c == 'N' && oldList[i].Current_SWKIT_SM_Mapping__c == 'Y'){
				noLongerActive.add(newList[i]);
			}
		}
		if(!noLongerActive.isEmpty()){
			SWKitSalesModelRelationshipMethods.updateSalesModelsFromDevicesWithSWKitsToNotActive(noLongerActive);
			
			List<SWKit_SalesModel_Relationship__c> swsmrToDelete = [SELECT Id FROM SWKit_SalesModel_Relationship__c WHERE Id IN : noLongerActive];
			delete swsmrToDelete;
		}
	}
}