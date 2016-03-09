/*
 *
 * Royalty Cost code tested by CreateNewDevAppRecord.testSubmitDevAppsForApproval()
 */

trigger DeviceApplication on DeviceApplicationAssoc__c (before insert, after insert, before update, after update, before delete, after delete) {
	
	if(trigger.isBefore && trigger.isInsert){
		DeviceApplication_Insert.beforeInsert(trigger.new);
	}
		
	if(trigger.isAfter && trigger.isInsert){
		DeviceApplicationApprovalProcess daap = new DeviceApplicationApprovalProcess();
		daap.setSkipfields(trigger.new);	
		DeviceApplication_Insert.afterInsert(trigger.new);		
	}	
	 
	if(trigger.isBefore && trigger.isUpdate){
		DeviceApplication_Update.beforeUpdate(trigger.new, trigger.old);	
	}
	
	if(trigger.isBefore && trigger.isDelete){
		DeviceApplication_Delete.beforeDelete(trigger.old);
	}
	
	if(trigger.isAfter && trigger.isDelete){
		DeviceApplication_Delete.afterDelete(trigger.old);
	}
}