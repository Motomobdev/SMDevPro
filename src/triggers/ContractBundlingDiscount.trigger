trigger ContractBundlingDiscount on Contract_Bundling_Discount__c (after delete, before insert) {
	if(trigger.isBefore && trigger.isInsert){		
		ContractBundlingDiscount_Insert.beforeInsert(trigger.new);		
	}	
	if(trigger.isAfter && trigger.isDelete){
		ContractBundlingDiscount_Delete.afterDelete(trigger.old);
	}
}