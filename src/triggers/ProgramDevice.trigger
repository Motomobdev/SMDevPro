trigger ProgramDevice on Program_Device__c (before insert, after insert, before delete) {
	if(trigger.isBefore && trigger.isInsert){
		ProgramDevice_Insert.beforeInsert(trigger.new);
	}
	
	if(trigger.isBefore && trigger.isDelete){
		ProgramDevice_Delete.beforeDelete(trigger.old);
	}

}