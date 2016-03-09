public with sharing class DeviceApplicationMethods {
    public static void checkForDuplicates(List<DeviceApplicationAssoc__c> newList, Set<Id> deviceIds, Set<Id> appIds){
        
        Map<String, List<DeviceApplicationAssoc__c>> existingDevAppsMap = new Map<String, List<DeviceApplicationAssoc__c>>();
        
        for(DeviceApplicationAssoc__c da : [SELECT Id, Device__c, Application__c, Include_in_BOM__c, Approval_Status__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : deviceIds AND Application__c IN : appIds /*AND (Include_in_BOM__c = true OR Approval_Status__c = 'Approved')*/]){
            system.debug('THIS APP EXISTS ON DEVICE ALREADY: ' + da.Application__c);
            String key = da.Device__c + '' + da.Application__c;
            List<DeviceApplicationAssoc__c> tempList = existingDevAppsMap.get(key);
            if(tempList == null){
                tempList = new List<DeviceApplicationAssoc__c>{da}; 
            } else {
                tempList.add(da);
            }
            existingDevAppsMap.put(key, tempList);
        }
        system.debug('THESE APPS EXIST ON DEVICE ALREADY: ' + existingDevAppsMap);
        if(!existingDevAppsMap.isEmpty()){
            for(Integer i=0; i<newList.size(); i++){
                system.debug('THIS IS A NEW APP FOR DEVICE: ' + newList[i].Application__c);
                system.debug('THIS IS NEW DEVAPP.Include_in_BOM__c: ' + newList[i].Include_in_BOM__c);
                
                if(newList[i].Include_in_BOM__c == true){
                    boolean myIncludeInBom = true;
                    
                    String key = newList[i].Device__c + '' + newList[i].Application__c;
                    
                    // If any of the same device and app combo records have the Include in bom checked
                    // then set the include in BOM for this record to be false
                    //if(existingDevAppsMap.containsKey(key)){
                    
                    // Loop thru all records with this device and app combo.
                    // If any one of these records has the include in bom as true,
                    // break out of the loop so the newList record's 
                    // include in BOM is set to false (only one record can have the IIB active).
                    if (existingDevAppsMap.get(key) != null) {
                        for (DeviceApplicationAssoc__c da : existingDevAppsMap.get(key)) {
                            if (da.Include_in_BOM__c == true) {
                                system.debug('THIS APP IS ON THE DEVICE: ' + newList[i].Application__c);
                                myIncludeInBom = false;
                                break;
                            }
                        }
                        newList[i].Include_in_BOM__c = myIncludeInBom;
                    }
                }
            }
        }
    }
    
    public static void checkForSWBOMReviewedAndApprovedDevicesBeforeDevAppInsertionOrDeletion(List<DeviceApplicationAssoc__c> devApps, String action, Map<Id, String> sourceIdNameMap, String sourceType, Map<Id, List<String>> sourceIdApplicationNameListMap){
        
    }
    
    private static testmethod void checkForDuplicatesTest(){
        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='fakeValueToSkipSomeSteps', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        insert app;
        
        //User u = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Device__c d = new Device__c(Name='d');
        //System.runAs(u) {         
            insert d;
        //}
        
        DeviceApplicationAssoc__c devApp1 = new DeviceApplicationAssoc__c(Device__c=d.Id, Application__c=app.Id, Include_in_BOM__c = true);
        insert devApp1;
        
        Test.startTest();
            DeviceApplicationAssoc__c devApp2 = new DeviceApplicationAssoc__c(Device__c=d.Id, Application__c=app.Id, Include_in_BOM__c = true);
            insert devApp2;
        Test.stopTest();        
    }
}