@isTest
public class AppsOnSWBundleTest
{   
    public static TestMethod void getAppsOnSWBundleTest(){
       
        
        Device__c testDev = new Device__c();
        testDev.Name = 'Test Device Bin';
        Insert(testDev);
        
        Application__c testApp = new Application__c();
        testApp.Name = 'Test Application Bin';
        testApp.Application_Type__c = 'Embedded';
        Insert(testApp);
        
        SW_Bundle__c testSWBundle = new SW_Bundle__c();
        testSWBundle.Name = 'Test SW Bundle';
        Insert(testSWBundle);
        
        SW_Bundle_Application__c testSWApp = new SW_Bundle_Application__c();
        testSWApp.Application__c = testApp.Id;
        testSWApp.Service_Type__c = testSWBundle.Id;
        insert(testSWApp);
        
        SW_Bundle_Device__c testSWDev = new SW_Bundle_Device__c();
        testSWDev.Device__c = testDev.Id;
        testSWDev.SW_Bundle_Device__c = testSWBundle.Id;
        insert(testSWDev);
        
        ApexPages.currentPage().getParameters().put('id', testDev.Id);
        AppsOnSWBundleForDeviceController obj = new AppsOnSWBundleForDeviceController();
        
        //obj.deviceId = testDev.Id;
        
        obj.getAppsOnSWBundle();
    }
    
}