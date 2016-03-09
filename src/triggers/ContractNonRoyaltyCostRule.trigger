trigger ContractNonRoyaltyCostRule on Contract_Non_Royalty_Cost_Rule__c (after delete, before insert) {
	if(trigger.isBefore && trigger.isInsert){		
		ContractNonRoyaltyCostRule_Insert.beforeInsert(trigger.new);		
	}	
	if(trigger.isAfter && trigger.isDelete){
		ContractNonRoyaltyCostRule_Delete.afterDelete(trigger.old);
	}
}