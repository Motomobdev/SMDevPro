trigger SWKit_SalesModel_Relationship on SWKIT_SalesModel_Relationship__c (before insert, after update) {
	if(trigger.isBefore && trigger.isInsert){
		SWKitSalesModelRelationship_Insert.beforeInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isUpdate){
		SWKitSalesModelRelationship_Update.afterUpdate(trigger.new, trigger.old);
	}
}