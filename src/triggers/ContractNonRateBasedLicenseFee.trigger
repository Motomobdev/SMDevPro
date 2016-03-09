trigger ContractNonRateBasedLicenseFee on Contract_Non_Rate_Based_License_Fee__c (before insert, after delete) {
	if(trigger.isBefore && trigger.isInsert){		
		ContractNonRateBasedLicenseFee_Insert.beforeInsert(trigger.new);		
	}	
	if(trigger.isAfter && trigger.isDelete){
		ContractNonRateBasedLicenseFee_Delete.afterDelete(trigger.old);
	}
}