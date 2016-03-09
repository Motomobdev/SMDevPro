public with sharing class CoreDevicePackageApplication_Update {
  
  // Tested by CoreDeviceMethodsTest
  public static void afterUpdate(List<Core_Device_Package_Application__c> newList, List<Core_Device_Package_Application__c> oldList){
    Set<Id> coreIds = new Set<Id>();
    Set<Id> appIds = new Set<Id>();
    Map<String, Boolean> coreIdAppIdNewIncludeInBOMMap = new Map<String, Boolean>();
    Map<String, Boolean> coreIdAppIdOldIncludeInBOMMap = new Map<String, Boolean>();
    Map<String, String> coreIdAppIdAppSourceIdMap = new Map<String, String>();
    
    for(Integer i=0; i<newList.size(); i++){
      // Check to see if Include in BOM has been updated 
      // build map of old value, new value, and map including Application Source Id. This will allow to keep a 1-1 connection between coreApp and devApp
      if(newList[i].Include_in_BOM__c != oldList[i].Include_in_BOM__c){
        coreIds.add(newList[i].Core_Device_Package__c);
        appids.add(newList[i].Application__c);
        coreIdAppIdNewIncludeInBOMMap.put(newList[i].Core_Device_Package__c + '' + newList[i].Application__c, newList[i].Include_in_BOM__c);
        coreIdAppIdOldIncludeInBOMMap.put(newList[i].Core_Device_Package__c + '' + newList[i].Application__c, oldList[i].Include_in_BOM__c);

        String newAppSourceId = newList[i].Application_Source_Id__c;
        if (newAppSourceId == null)
            newAppSourceId = ((String)(newList[i].Core_Device_Package__c)).substring(0,15);
        
        String oldAppSourceId = oldList[i].Application_Source_Id__c;
        if (oldAppSourceId == null)
            oldAppSourceId = ((String)(oldList[i].Core_Device_Package__c)).substring(0,15);
        
        coreIdAppIdAppSourceIdMap.put(newList[i].Core_Device_Package__c + '' + newList[i].Application__c + '' + newAppSourceId, oldAppSourceId);
      }
    }
    
    // If there are CoreApps with updated Include in BOM, update related devApps
    if(!coreIdAppIdNewIncludeInBOMMap.isEmpty()){
      List<DeviceApplicationAssoc__c> devAppsToUpdate = new List<DeviceApplicationAssoc__c>(); 
      for(DeviceApplicationAssoc__c da : [SELECT Id, Application__c, Source_Id__c, Include_in_BOM__c,
              Application_Source_Id__c, Device__c 
              FROM DeviceApplicationAssoc__c 
              WHERE Source_Id__c IN : coreIds 
              AND Application__c IN : appIds]) {
        
        // if application source id matches and matching core-app's include in bom has been updated        
        if((coreIdAppIdAppSourceIdMap.get(da.Source_Id__c + '' + da.Application__c + '' + da.Application_Source_Id__c) == da.Application_Source_Id__c) && (coreIdAppIdNewIncludeInBOMMap.get(da.Source_Id__c + '' + da.Application__c) != null)){
          // if devApp BOM field matches the coreApp original BOM setting then you can assume they are not out of sync and can allow the coreApp update to propogate through
          if((da.Include_in_BOM__c == coreIdAppIdOldIncludeInBOMMap.get(da.Source_Id__c + '' + da.Application__c)) && (da.Include_in_BOM__c != coreIdAppIdNewIncludeInBOMMap.get(da.Source_Id__c + '' + da.Application__c))){
            da.Include_in_BOM__c = coreIdAppIdNewIncludeInBOMMap.get(da.Source_Id__c + '' + da.Application__c);
            devAppsToUpdate.add(da);
          }
        }
      }
      
      if(!devAppsToUpdate.isEmpty()) { 
        Set<Id> deviceAppIds = new Set<Id>();
        Set<Id> devIds = new Set<Id>();
    
        for(Integer i=0; i<devAppsToUpdate.size(); i++){
          // get list of related App Id's
          deviceAppIds.add(devAppsToUpdate[i].Application__c);
          devIds.add(devAppsToUpdate[i].Device__c);
        }
        
        // The devAppsToUpdate list gets updated in the check duplicates
        DeviceApplicationMethods.checkForDuplicates(devAppsToUpdate, devIds, deviceAppIds);
      	update devAppsToUpdate;
      }
    }
  }
}