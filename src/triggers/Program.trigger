trigger Program on Program__c (before insert, after insert, before update, after update) {
	if(trigger.isBefore && trigger.isInsert){
		Program_Insert.beforeInsert(trigger.new);
	}
	
	// will program fields be filled in when record is created or after creation during first "update"?
	if(trigger.isAfter && trigger.isInsert){
		Program_Insert.afterInsert(trigger.new);
	}
	
	if(trigger.isBefore && trigger.isUpdate){
		Program_Update.beforeUpdate(trigger.new, trigger.old);
	}
	
	if(trigger.isAfter && trigger.isUpdate){
		Program_Update.afterUpdate(trigger.new, trigger.old);
	}
}