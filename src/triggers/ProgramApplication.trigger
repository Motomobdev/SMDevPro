trigger ProgramApplication on Program_Application__c (before insert, after insert, after update, before delete, after delete) {
	if(trigger.isBefore && trigger.isInsert){
		ProgramApplication_Insert.beforeInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isInsert){
		ProgramApplication_Insert.afterInsert(trigger.new, trigger.old);
	}
	
	if(trigger.isAfter && trigger.isUpdate){
		ProgramApplication_Update.afterUpdate(trigger.new, trigger.old);
	}
	
	if(trigger.isBefore && trigger.isDelete){
		ProgramApplication_Delete.beforeDelete(trigger.old);
	}
}