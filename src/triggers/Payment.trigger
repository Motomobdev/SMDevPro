trigger Payment on Payment__c (before insert, after insert, before update, after update) {
	// tested by PopulateAccountOwner.populateAccountOwnerOnPaymentTest
	if(trigger.isBefore && trigger.isInsert){
		Payment_Insert.beforeInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isInsert){
		Payment_Insert.afterInsert(trigger.new);
	}
	
	// tested by PopulateAccountOwner.populateAccountOwnerOnPaymentTest
	if(trigger.isBefore && trigger.isUpdate){
		Payment_Update.beforeUpdate(trigger.new, trigger.old);
	}
	
	if(trigger.isAfter && trigger.isUpdate){
		Payment_Update.afterUpdate(trigger.new, trigger.old);
	}
}