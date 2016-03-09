trigger CoreDevicePackageApplication on Core_Device_Package_Application__c (before delete, before insert, before update, after update) {
	if(trigger.isBefore && trigger.isInsert){
		CoreDevicePackageApplication_Insert.beforeInsert(trigger.new);
	}
	
    if(trigger.isBefore && trigger.isUpdate){
		CoreDevicePackageApplicationMethods.setIncludeInBOMForDuplicateCoreApps
            (trigger.new);
	}
	
    if(trigger.isAfter && trigger.isUpdate){
		CoreDevicePackageApplication_Update.afterUpdate(trigger.new, trigger.old);
	}
	
	if(trigger.isBefore && trigger.isDelete){
		CoreDevicePackageApplication_Delete.beforeDelete(trigger.old);
	}
}