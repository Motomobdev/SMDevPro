trigger StableApplication on Stable_Application__c (before insert, after insert, after update, before delete, after delete) {
	if(trigger.isBefore && trigger.isInsert){
		StableApplication_Insert.beforeInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isInsert){
		StableApplication_Insert.afterInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isUpdate){
		StableApplication_Update.afterUpdate(trigger.new, trigger.old);
	}
	
	if(trigger.isBefore && trigger.isDelete){
		StableApplication_Delete.beforeDelete(trigger.old);
	}
	
	if(trigger.isAfter && trigger.isDelete){
		StableApplication_Delete.afterDelete(trigger.old);
	}
}