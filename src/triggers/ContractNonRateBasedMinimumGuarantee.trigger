trigger ContractNonRateBasedMinimumGuarantee on Contract_NonRate_Based_Minimum_Guarantee__c (before insert, after delete) {
	if(trigger.isBefore && trigger.isInsert){		
		ContractNonRateBasedMinGuarantee_Insert.beforeInsert(trigger.new);		
	}	
	if(trigger.isAfter && trigger.isDelete){
		ContractNonRateBasedMinGuarantee_Delete.afterDelete(trigger.old);
	}
}