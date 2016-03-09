public with sharing class CoreDevicePackage_Update {
	public static void afterUpdate(List<Core_Device_Package__c> newList, List<Core_Device_Package__c> oldList){
		List<Core_Device_Package__c> coreWithFirstStable = new List<Core_Device_Package__c>();
		List<Core_Device_Package__c> coreWithUpdatedNew = new List<Core_Device_Package__c>();
		List<Core_Device_Package__c> coreWithUpdatedOld = new List<Core_Device_Package__c>();
		List<Core_Device_Package__c> coreWithRemovedStable = new List<Core_Device_Package__c>();
		
		for(Integer i=0; i<newList.size(); i++){
			// check to see if stable has changed on the Core
			system.debug('NEW AND OLD STABLE IDS: ' + newList[i].Stable__c + ', ' + oldList[i].Stable__c);
			if(newList[i].Stable__c != oldList[i].Stable__c){
				if(newList[i].Stable__c != null && oldList[i].Stable__c == null){
					// first stable selected
					coreWithFirstStable.add(newList[i]);					
				} else if(newList[i].Stable__c != null && oldList[i].Stable__c != null){
					// stable updated
					coreWithUpdatedNew.add(newList[i]);
					coreWithUpdatedOld.add(oldList[i]);
				} else if(newList[i].Stable__c == null && oldList[i].Stable__c != null){
					// stable removed
					coreWithRemovedStable.add(oldList[i]);					
				}
			}
		}
		
		if(!coreWithFirstStable.isEmpty()){
			CoreDevicePackageMethods.addStableElementsToCoreDevicePackage(coreWithFirstStable);
			CoreDevicePackageMethods.addStableToCoreDevicePackageDevices(coreWithFirstStable); 
		}
		
		if(!coreWithUpdatedNew.isEmpty()){
			CoreDevicePackageMethods.removeStableElementsFromCoreDevicePackage(coreWithUpdatedOld);
			CoreDevicePackageMethods.removeStableFromCoreDevicePackageDevices(coreWithUpdatedOld);
			
			CoreDevicePackageMethods.addStableElementsToCoreDevicePackage(coreWithUpdatedNew);
			CoreDevicePackageMethods.addStableToCoreDevicePackageDevices(coreWithUpdatedNew); 
		}
		
		if(!coreWithRemovedStable.isEmpty()) { 
			CoreDevicePackageMethods.removeStableElementsFromCoreDevicePackage(coreWithRemovedStable);
			CoreDevicePackageMethods.removeStableFromCoreDevicePackageDevices(coreWithRemovedStable); 
		}
	}
}