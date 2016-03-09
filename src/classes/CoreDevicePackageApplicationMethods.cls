public with sharing class CoreDevicePackageApplicationMethods {

    // Re-written by Rajesh -- The original method from Jesse had bugs
    public static void setIncludeInBOMForDuplicateCoreApps(
        List<Core_Device_Package_Application__c> newList){

        Set<Id> appIds = new Set<Id>();
        Map<Id, List<Core_Device_Package_Application__c>> coreIdCoreAppListMap = 
            new Map<Id, List<Core_Device_Package_Application__c>>();
        
        // Build a map of CDP ID keys and CDPA records as values using the input
        for (Integer i = 0; i < newList.size(); i++) {
        
            if (!coreIdCoreAppListMap.containsKey(newList[i].Application__c)) {                
                coreIdCoreAppListMap.put(newList[i].Core_Device_Package__c,
                    new List<Core_Device_Package_Application__c>());
            }

            coreIdCoreAppListMap.get(newList[i].Core_Device_Package__c).add(newList[i]);
            
            appIds.add(newList[i].Application__c);
        }
        
        // Ensure only one occurance of CDPA (for a particular app)
        // has include in BOM checked when duplicates exist.
        for (String coreId : coreIdCoreAppListMap.keyset()) {
        
            Set<Id> cdpa_appIds = new Set<Id>();
            for (Core_Device_Package_Application__c cdpa : 
                coreIdCoreAppListMap.get(coreId)) {
                
                if (cdpa.include_in_bom__c) {
                    if (cdpa_appIds.contains(cdpa.Application__c))
                        cdpa.include_in_bom__c = false;
                    else
                        cdpa_appIds.add(cdpa.Application__c);
                }
            }
        }
        
        // Build a map of Core ID keys and CDPA values using the database
        Map<Id, List<Core_Device_Package_Application__c>> existingCoreIdCoreAppListMap = 
            new Map<Id, List<Core_Device_Package_Application__c>>();
            
        for (Core_Device_Package_Application__c cdpa : 
                [SELECT Id, Core_Device_Package__c, Application__c, Include_in_BOM__c 
                FROM Core_Device_Package_Application__c 
                WHERE Core_Device_Package__c IN : coreIdCoreAppListMap.keyset()
                  and Application__c in : appIds
                  AND Include_in_BOM__c = TRUE]) {
                  
            if (!existingCoreIdCoreAppListMap.containsKey(cdpa.Core_Device_Package__c)) {
                existingCoreIdCoreAppListMap.put(cdpa.Core_Device_Package__c,
                    new List<Core_Device_Package_Application__c>());
            }
            
            existingCoreIdCoreAppListMap.get(cdpa.Core_Device_Package__c).add(cdpa);
        }
        
        // check to see if any new apps for a core are a duplicate
        for (Integer i = 0; i < newList.size(); i++) {
            boolean firstTime = true;
            Set<Id> uniqueAppId = new Set<Id>();
            
            if (newList[i].include_in_bom__c &&
                existingCoreIdCoreAppListMap.containsKey(newList[i].Core_Device_Package__c)) {
                // CDPAs with include in BOM checked
                for (Core_Device_Package_Application__c cdpa : 
                    existingCoreIdCoreAppListMap.get(newList[i].Core_Device_Package__c)) {
                    
                    // Same app
                    if (newList[i].application__c == cdpa.application__c) {
                        // Exists more than once with 
                        if (uniqueAppId.contains(cdpa.application__c))
                            newList[i].include_in_bom__c = false;
                        else
                            uniqueAppId.add(cdpa.application__c);
                    }
                }
            }
        }
    }
    
    /* This code is from Jesse and has bugs
    public static void setIncludeInBOMForDuplicateCoreApps(
        List<Core_Device_Package_Application__c> newList){
        Map<Id, List<Core_Device_Package_Application__c>> appIdCoreAppListMap = 
            new Map<Id, List<Core_Device_Package_Application__c>>();
        Set<Id> coreIds = new Set<Id>();
        
        // check newList to see if there are duplicates in newList itself
        Set<Id> newAppsBeingInserted = new Set<Id>();
        for(Integer i=0; i<newList.size(); i++){
            coreIds.add(newList[i].Core_Device_Package__c);
            
            if(!newAppsBeingInserted.contains(newList[i].Application__c) && 
                newList[i].Include_in_BOM__c == true){
                newAppsBeingInserted.add(newList[i].Application__c);
            } else if(newAppsBeingInserted.contains(newList[i].Application__c) && 
                        newList[i].Include_in_BOM__c == true){
                newList[i].Include_in_BOM__c = false;
            }
        }
        
        // build list of existing core apps mapped by core Id
        Map<Id, Set<Id>> existingCoreIdAppIdSetMap = new Map<Id, Set<Id>>();
        //Set<Id> tempSet;
        //List<Core_Device_Package_Application__c> existingCDPAToBeUpdate = 
        // new List<Core_Device_Package_Application__c>();
        for(Core_Device_Package_Application__c cdpa : 
                [SELECT Id, Core_Device_Package__c, Application__c, Include_in_BOM__c 
                FROM Core_Device_Package_Application__c 
                WHERE Core_Device_Package__c IN : coreIds]){
            Set<Id> tempList = existingCoreIdAppIdSetMap.get(cdpa.Core_Device_Package__c);
            if(tempList == null){
                tempList = new Set<Id>{cdpa.Application__c};
            } else {
                tempList.add(cdpa.Application__c);
            }
            
            existingCoreIdAppIdSetMap.put(cdpa.Core_Device_Package__c, tempList);
        }
        
        // check to see if any new apps for a core are a duplicate
        for(Integer i=0; i<newList.size(); i++){
            if((newList[i].Include_in_BOM__c == true) && 
                (existingCoreIdAppIdSetMap.get(newList[i].Core_Device_Package__c) != null)){
                Set<Id> tempSet = existingCoreIdAppIdSetMap.get(
                                    newList[i].Core_Device_Package__c);
                if(tempSet.contains(newList[i].Application__c)){
                    // This core already has this app included in bom
                    newList[i].Include_in_BOM__c = false;
                }
            }
        }
    }
    */
    
    public static void addApplicationToCoreDevicePackageDevices(
        List<Core_Device_Package_Application__c> newList){
        List<Id> coreDevicePackageIds = new List<Id>();
        Map<Id, String> coreDevicePackageIdApplicationNameMap = new Map<Id, String>();
        Map<Id, List<Core_Device_Package_Application__c>> coreIdAppListMap = 
            new Map<Id, List<Core_Device_Package_Application__c>>();
        
        for(Core_Device_Package_Application__c cdpa : newList){     
            coreDevicePackageIds.add(cdpa.Core_Device_Package__c);
            System.debug('THIS IS CDP.ID: ' + cdpa.Core_Device_Package__c);
            
            if(coreIdAppListMap.containsKey(cdpa.Core_Device_Package__c)){
                List<Core_Device_Package_Application__c> tempList = 
                    coreIdAppListMap.get(cdpa.Core_Device_Package__c);
                tempList.add(cdpa);
                coreIdAppListMap.put(cdpa.Core_Device_Package__c, tempList);
            } else {
                coreIdAppListMap.put(cdpa.Core_Device_Package__c, 
                    new List<Core_Device_Package_Application__c>{cdpa});
            }
        }
        
        Map<Id, Core_Device_Package__c> cdpMap = 
            new Map<Id, Core_Device_Package__c>(
                [SELECT Id, Name 
                FROM Core_Device_Package__c 
                WHERE Id IN : coreDevicePackageIds]);
        
        List<Device__c> devicesWithThisCore = new List<Device__c>();
        
        //List<Device__c> devicesWhoseOwnersNeedToBeInformedOfUpdate = new List<Device__c>();
        
        List<DeviceApplicationAssoc__c> devAppsToInsert = 
            new List<DeviceApplicationAssoc__c>();
        List<Blocked_Action__c> blockedActionsToInsert = new List<Blocked_Action__c>();
        for(Device__c d : [SELECT Id, Name, Device_Name_plus_ID__c, 
                Core_Device_Package__c, Core_Device_Package__r.Name, 
                OwnerId, SWBOM_Reviewed_and_Approved__c, Device_ID__c 
                FROM Device__c 
                WHERE Core_Device_Package__c IN : coreDevicePackageIds]){
            if(coreIdAppListMap.containsKey(d.Core_Device_Package__c)){
                String applicationSourceId = d.Core_Device_Package__c;
                if(applicationSourceId.length() == 18){
                    applicationSourceId = applicationSourceId.substring(0,15);
                }
                for(Core_Device_Package_Application__c cdpa : 
                        coreIdAppListMap.get(d.Core_Device_Package__c)){
                    if(d.SWBOM_Reviewed_and_Approved__c == 'Yes'){
                        blockedActionsToInsert.add(
                            new Blocked_Action__c(Action_Attempted__c = 'Insert', 
                                Application__c = cdpa.Application__c, 
                                Application_Source_Id__c = applicationSourceId, 
                                Device__c = d.Id, 
                                Source_Id__c = d.Core_Device_Package__c, 
                                Source_Name__c = d.Core_Device_Package__r.Name));
                    } else {
                        devAppsToInsert.add(
                            new DeviceApplicationAssoc__c(
                                Application__c = cdpa.Application__c,
                                Device__c = d.Id,
                                Source_Id__c = d.Core_Device_Package__c,
                                Source_Name__c = d.Core_Device_Package__r.Name,
                                Include_in_BOM__c = cdpa.Include_in_BOM__c,
                                Application_Source_Id__c = applicationSourceId));
                    }
                }
            }
        }

        insert devAppsToInsert;
        insert blockedActionsToInsert;
        
        /*if(!devicesWhoseOwnersNeedToBeInformedOfUpdate.isEmpty()){
            emailDeviceOwnersOfUpdatedCore(
            devicesWhoseOwnersNeedToBeInformedOfUpdate, cdpMap, 
            coreDevicePackageIdApplicationNameMap, 'added to');
        }*/
    }
    
    public static void removeApplicationFromCorePackageDeviceDevices(
        List<Core_Device_Package_Application__c> oldList){
        List<Id> coreDevicePackageIds = new List<Id>();
        List<Id> appIds = new List<Id>();
        List<String> applicationSourceIds = new List<String>();
        
        Map<Id, String> coreDevicePackageIdApplicationNameMap = new Map<Id, String>();
        
        for(Core_Device_Package_Application__c cdpa : oldList){         
            coreDevicePackageIds.add(cdpa.Core_Device_Package__c);
            appIds.add(cdpa.Application__c);
            String applicationSourceId = cdpa.Core_Device_Package__c;
            if(applicationSourceId.length() == 18){
                applicationSourceId = applicationSourceId.substring(0,15);
            }
            applicationSourceIds.add(applicationSourceId);
            
            coreDevicePackageIdApplicationNameMap.put(cdpa.Core_Device_Package__c, 
                            cdpa.Application__r.Name);
        }
        
        Map<Id, Core_Device_Package__c> cdpMap = 
            new Map<Id, Core_Device_Package__c>(
            [SELECT Id, Name 
            FROM Core_Device_Package__c 
            WHERE Id IN : coreDevicePackageIds]);
        
        List<DeviceApplicationAssoc__c> devAppsToDelete = new List<DeviceApplicationAssoc__c>();
        List<Blocked_Action__c> blockedActionsToInsert = new List<Blocked_Action__c>();
        
        //List<Id> tempDeviceIdList = new List<Id>();       
        //List<Id> deviceIds = new List<Id>();
        
        for(DeviceApplicationAssoc__c da : [SELECT Id, 
                Device__r.SWBOM_Reviewed_and_Approved__c, Device__c, 
                Application__c, Application_Source_Id__c, Source_Id__c, 
                Source_Name__c 
                FROM DeviceApplicationAssoc__c 
                WHERE Application__c IN : appIds 
                AND Source_Id__c IN : coreDevicePackageIds 
                AND Application_Source_Id__c IN : applicationSourceIds]){
            if(da.Device__r.SWBOM_Reviewed_and_Approved__c == 'Yes'){
                blockedActionsToInsert.add(
                    new Blocked_Action__c(Action_Attempted__c = 'Delete', 
                    Application__c = da.Application__c, 
                    Application_Source_Id__c = da.Application_Source_Id__c, 
                    Device__c = da.Device__c, 
                    Source_Id__c = da.Source_Id__c, 
                    Source_Name__c = da.Source_Name__c, 
                    Device_Application_if_delete__c = da.Id));
            } else {
                da.Source_Id__c = null;
                da.Source_Name__c = null;
                devAppsToDelete.add(da);
            }
        }       
        
        update devAppsToDelete;
        delete devAppsToDelete;
        
        insert blockedActionsToInsert;
    }

    private static testmethod void CoreDevicePackageApplicationMethodsTest(){
        /* Test's this class and 
            CoreDevicePackageApplication_Insert/Delete classes and trigger */
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp');
        insert cdp;
        
        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c appOnCore = 
            new Application__c(Name='appOnProgram', Account__c=a.Id, 
                Application_Type__c='Preload', 
                Application_Sub_Type__c='faketype', 
                Application_Category__c='fakeCategory', 
                Description__c='fakeDescription', Available_For_Use__c=true);
        insert appOnCore;
        
        User u = [SELECT ID, Username From User
                    Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Device__c d = new Device__c(Name='d1', Core_Device_Package__c = cdp.Id);
        Device__c d2 = new Device__c(Name='d2', Core_Device_Package__c = cdp.Id, 
                SWBOM_Reviewed_and_Approved__c='Yes', SW_BOM_List_Approver__c=u.Id);
        Device__c d3 = new Device__c(Name='d3', Core_Device_Package__c = cdp.Id);
        Device__c d4 = new Device__c(Name='d4', Core_Device_Package__c = cdp.Id);
        System.runAs(u) {           
            insert new List<Device__c>{d,d2,d3,d4};
        }
        
        Core_Device_Package_Application__c cdpa = 
            new Core_Device_Package_Application__c(Core_Device_Package__c=cdp.Id, 
                Application__c=appOnCore.Id);

        Test.startTest();
            insert cdpa;
            
            try{
                DeviceApplicationAssoc__c devApp3 = 
                    [SELECT Id, Approval_Status__c 
                    FROM DeviceApplicationAssoc__c 
                    WHERE Device__c =: d3.Id 
                    AND Application__c =: appOnCore.Id];
                devApp3.Approval_Status__c = 'Approved';
                update devApp3;      
                d3.SWBOM_Reviewed_and_Approved__c='Yes';
                d3.SW_BOM_List_Approver__c=u.Id;
                update d3;
                
                DeviceApplicationAssoc__c devApp4 =
                    [SELECT Id, Approval_Status__c 
                    FROM DeviceApplicationAssoc__c
                    WHERE Device__c =: d4.Id
                    AND Application__c =: appOnCore.Id];
                devApp4.Include_in_BOM__c=false;
                update devApp4;
                
                cdpa.Source_Id__c = 'sourceId';
                cdpa.Application_Source_Id__c = 'appsource';
                update cdpa;
                try {    
                    delete cdpa;
                } catch(System.DMLException e){
                    System.assert(
                        e.getMessage().contains(
                        'You cannot delete this Application from this ' +
                        'Core because it was added via the Source'));
                }
                
                cdpa.Source_Id__c = null;
                cdpa.Application_Source_Id__c = null;
                update cdpa;            
                delete cdpa;
            }catch(System.QueryException e){
                
            }
        Test.stopTest();
    }   
}