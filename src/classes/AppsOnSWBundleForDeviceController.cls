public with sharing class AppsOnSWBundleForDeviceController {
    public string deviceId{get; set;}
    public Device__c device{get; set;}
    Set<Id> appIDs = new Set<Id>();
    Set<Id> SWBundleIDs = new Set<Id>();
    
    public AppsOnSWBundleForDeviceController(){
        deviceId = ApexPages.currentPage().getParameters().get('id');
        device = [SELECT Device_Id__c, Name FROM Device__c WHERE Id = :deviceId];
    }
    public List<Application__c> getAppsOnSWBundle(){
        List<SW_Bundle_Device__c> SWBundleDevices = [SELECT Id, SW_Bundle_Device__c FROM SW_Bundle_Device__c WHERE Device__c = :deviceId];
        for(SW_Bundle_Device__c SWDevice : SWBundleDevices){
            SWBundleIDs.add(SWDevice.SW_Bundle_Device__c);
        }
        List<SW_Bundle_Application__c> appOnSWBundles = [SELECT Id, Application__r.Id FROM SW_Bundle_Application__c WHERE Service_Type__c IN :SWBundleIDs];
        for(SW_Bundle_Application__c app : appOnSWBundles){
            appIDs.add(app.Application__r.Id);
        }
        
        return [SELECT Id, Name, Application_ID__c, Application_Contract_Phase__c, Account__r.Name FROM Application__c WHERE Id IN :appIDs ORDER BY Account__r.Name];
        
    }

}