public with sharing class CoreDevicePackageProgram_Insert {
	// tested by CoreDeviceMethodsTest
	public static void beforeInsert(List<Core_Device_Package_Program__c> newList){
		List<Core_Device_Package_Program__c> coreDevicePackageProgramsToInsert = new List<Core_Device_Package_Program__c>();
		
		for(Core_Device_Package_Program__c cdpp : newList){
			if(cdpp.Source_Id__c == null){
				coreDevicePackageProgramsToInsert.add(cdpp);
			}
		}
		
		if(!coreDevicePackageProgramsToInsert.isEmpty()){
			CoreDevicePackageProgramMethods.addAppsToCoreDevicePackageAndCoreDevices(coreDevicePackageProgramsToInsert);
		}
	}
}