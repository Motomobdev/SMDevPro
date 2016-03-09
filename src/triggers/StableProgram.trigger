trigger StableProgram on Stable_Program__c (before insert, after insert, before delete, after delete) {
	if(trigger.isBefore && trigger.isInsert){
		StableProgram_Insert.beforeInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isInsert){
		StableProgram_Insert.afterInsert(trigger.new);
	}
	
	if(trigger.isBefore && trigger.isDelete){
		StableProgram_Delete.beforeDelete(trigger.old);
	}
	
	if(trigger.isAfter && trigger.isDelete){
		StableProgram_Delete.afterDelete(trigger.old);
	}
}