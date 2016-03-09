/*
 * Test code for calculatePercentatgeOnDevice found in calculatePercentExecutedContractsOnBomOrSDTest
 */

trigger Contract on Contract (before insert, after insert, before update, after update) {
	if(trigger.isBefore && trigger.isInsert){
		Contract_Insert.beforeInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isInsert){
		Contract_Insert.afterInsert(trigger.new);
	}
	
	if(trigger.isBefore && trigger.isUpdate){
		Contract_Update.beforeUpdate(trigger.new, trigger.old);		
	}
	
	if(trigger.isAfter && trigger.isUpdate){		
		Contract_Update.afterUpdate(trigger.new, trigger.old);
	}
}