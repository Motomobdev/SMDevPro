public with sharing class CoreDevicePackageProgram_Delete {
	// tested by CoreDeviceMethodsTest
	public static void beforeDelete(List<Core_Device_Package_Program__c> oldList){
		List<Core_Device_Package_Program__c> cdppBeingDeleted = new List<Core_Device_Package_Program__c>();
		
		for(Core_Device_Package_Program__c cdpp : oldList){
			if(cdpp.Source_Id__c != null){
				cdpp.addError('You cannot remove this Program from this Core because it was added via the Source');
			} else if(cdpp.Source_Name__c == null){
				cdppBeingDeleted.add(cdpp);
			}
		}
		
		if(!cdppBeingDeleted.isEmpty()){
			CoreDevicePackageProgramMethods.removeAppsFromCoreDevicePackageAndCoreDevices(cdppBeingDeleted);
		}
	}
}