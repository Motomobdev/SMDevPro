trigger Stable on Stable__c (before update) {
	if(trigger.isBefore && trigger.isUpdate){
		Stable_Update.beforeUpdate(trigger.new, trigger.old);
	}
}