public with sharing class CoreDevicePackage_Insert {
    public static void afterInsert(List<Core_Device_Package__c> newList){
        List<Core_Device_Package__c> coreWithStable = new List<Core_Device_Package__c>();
        
        for(Core_Device_Package__c cdp : newList){
            //if(cdp.Stable__c != null){
                coreWithStable.add(cdp);
            //}
        }
        
        CoreDevicePackageMethods.addStableElementsToCoreDevicePackage(coreWithStable);
    }
}