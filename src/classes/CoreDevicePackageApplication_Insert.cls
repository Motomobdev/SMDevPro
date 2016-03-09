public with sharing class CoreDevicePackageApplication_Insert {
	// tested by CoreDeviceMethodsTest
	public static void beforeInsert(List<Core_Device_Package_Application__c> newList){
		CoreDevicePackageApplicationMethods.setIncludeInBOMForDuplicateCoreApps(newList);
		
		List<Core_Device_Package_Application__c> cdpAppsToInsert = new List<Core_Device_Package_Application__c>();
		for(Core_Device_Package_Application__c cdpa : newList){
			if(cdpa.Source_Id__c == null){
				cdpAppsToInsert.add(cdpa);
			}
		}
		try{
			CoreDevicePackageApplicationMethods.addApplicationToCoreDevicePackageDevices(cdpAppsToInsert);
		} catch(System.DMLException e){
			for(Core_Device_Package_Application__c cdpa : newList){
				cdpa.addError('There was a problem adding Application to devices that use this Core.');
			}
		}
	}
}