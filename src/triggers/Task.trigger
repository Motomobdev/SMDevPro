trigger Task on Task (after insert, after update) {
	if(trigger.isInsert){
		Task_Insert.afterInsert(trigger.new);
	}
	
	if(trigger.isUpdate){
		Task_Update.afterUpdate(trigger.new, trigger.old);
	}
}