trigger CoreDevicePackageProgram on Core_Device_Package_Program__c (before delete, before insert) {
	if(trigger.isBefore && trigger.isInsert){
		CoreDevicePackageProgram_Insert.beforeInsert(trigger.new);
	}
	
	if(trigger.isBefore && trigger.isDelete){
		CoreDevicePackageProgram_Delete.beforeDelete(trigger.old);
	}
}