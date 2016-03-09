public with sharing class CoreDevicePackageApplication_Delete {
	// tested by CoreDeviceMethodsTest
	public static void beforeDelete(List<Core_Device_Package_Application__c> oldList){
		List<Core_Device_Package_Application__c> cdpaList = new List<Core_Device_Package_Application__c>();
		for(Core_Device_Package_Application__c cdpa : oldList){
			if(cdpa.Source_Id__c != null){
				cdpa.addError('You cannot delete this Application from this Core because it was added via the Source');
			} else if(cdpa.Source_Id__c == null && cdpa.Application_Source_Id__c == null){
				cdpaList.add(cdpa);
			}
		}
		
		try{
			CoreDevicePackageApplicationMethods.removeApplicationFromCorePackageDeviceDevices(cdpaList);		
		} catch(System.DMLException e){
			for(Core_Device_Package_Application__c cdpa : oldList){
				cdpa.addError('There was a problem removing Application from devices that use this Core.');
			}
		}
	}
}