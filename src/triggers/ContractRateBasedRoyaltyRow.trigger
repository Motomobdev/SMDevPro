trigger ContractRateBasedRoyaltyRow on Contract_Rate_Based_Royalty_Row__c (after delete, after insert) {
	if(trigger.isAfter && trigger.isInsert){		
		ContractRateBasedRoyaltyRow_Insert.afterInsert(trigger.new);		
	}	
	if(trigger.isAfter && trigger.isDelete){
		ContractRateBasedRoyaltyRow_Delete.afterDelete(trigger.old);
	}
}