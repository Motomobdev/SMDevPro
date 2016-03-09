trigger ContractApplication on ContApplAssoc__c (before insert, after insert, before update, after update, after delete) {
	
	if(trigger.isBefore && trigger.isInsert){	
		ContractApplication_Insert.beforeInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isInsert){	
		ContractApplication_Insert.afterInsert(trigger.new);
	}
	
	if(trigger.isBefore && trigger.isUpdate){
		ContractApplication_Update.beforeUpdate(trigger.new, trigger.old);		
	}
	
	if(trigger.isAfter && trigger.isUpdate){
		ContractApplication_Update.afterUpdate(trigger.new, trigger.old);		
	}	
	
	if(trigger.isAfter && trigger.isDelete){
		ContractApplication_Delete.afterDelete(trigger.old);
	}
}