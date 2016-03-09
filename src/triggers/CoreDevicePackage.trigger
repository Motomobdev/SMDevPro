trigger CoreDevicePackage on Core_Device_Package__c (after insert, after update) {
	if(trigger.isAfter && trigger.isInsert){
		CoreDevicePackage_Insert.afterInsert(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isUpdate){
		CoreDevicePackage_Update.afterUpdate(trigger.new, trigger.old);	
	}
}