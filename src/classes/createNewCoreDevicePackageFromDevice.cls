public with sharing class createNewCoreDevicePackageFromDevice {
//action="{!createCoreAndBuildLists}"
    public Core_Device_Package__c newCore {get; set;}
    public Device__c device {get; set;}

    public createNewCoreDevicePackageFromDevice(ApexPages.StandardController controller){  
        device = (Device__c)controller.getRecord();
        newCore = new Core_Device_Package__c(Name='New Core From Device ' + device.Name, Stable__c = device.Stable__c);
    }
    
    public Boolean getIsCoreInserted(){
        if(newCore.Id != null){
            return true;
        }
        return false;
    }
    
    public void createCoreAndBuildLists(){
        insert newCore;
        
        insertElements(newCore.Id, device.Stable__c, device.Id);
    }
    
    @future
    public static void insertElements(Id coreId, Id stableId, Id deviceId){        
        List<Core_Device_Package_Program__c> cdpProgramsToInsert = new List<Core_Device_Package_Program__c>();
        for(Program_Device__c pd : [SELECT Program__c FROM Program_Device__c WHERE Device__c =: deviceId AND (Source_Id__c = '' OR Source_Id__c = null)]){
            cdpProgramsToInsert.add(new Core_Device_Package_Program__c(Core_Device_Package__c = coreId, Program__c = pd.Program__c));
        }
        insert cdpProgramsToInsert;
        
        List<Core_Device_Package_Application__c> cdpAppsToInsert = new List<Core_Device_Package_Application__c>();
        for(DeviceApplicationAssoc__c da : [SELECT Application__c FROM DeviceApplicationAssoc__c WHERE Device__c =: deviceId AND (Source_Id__c = '' OR Source_Id__c = null)]){
            cdpAppsToInsert.add(new Core_Device_Package_Application__c(Core_Device_Package__c = coreId, Application__c = da.Application__c));
        }
        insert cdpAppsToInsert;
    }
    
    public PageReference continueToNewCore(){
        PageReference pr = new PageReference('/' + newCore.Id);
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference cancel(){
        PageReference pr = new PageReference('/' + device.Id);
        pr.setRedirect(true);
        return pr;
    }
    
    private static testmethod void createNewCoreDevicePackageFromDeviceTest(){
        Stable__c s = new Stable__c(Name='stable');
        insert s;
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='core');
        insert cdp;
        Program__c p = new Program__c(Name='program');
        insert p;
        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        insert app;
        Device__c d = new Device__c(Name='d', Stable__c=s.Id, Core_Device_Package__c=cdp.id);
        insert d;
        DeviceApplicationAssoc__c da = new DeviceApplicationAssoc__c(Device__c=d.Id, Application__c=app.id);
        insert da;
        Program_Device__c pd = new Program_Device__c(Program__c=p.Id, Device__c=d.Id);
        insert pd;
        
        Test.startTest();
            ApexPages.StandardController setCon = new ApexPages.StandardController(d);  
            ApexPages.currentPage().getParameters().put('Id', d.Id);
            createNewCoreDevicePackageFromDevice page = new createNewCoreDevicePackageFromDevice(setCon);
            PageReference pr = page.cancel();
            Boolean bool = page.getIsCoreInserted();
            page.createCoreAndBuildLists();
            bool = page.getIsCoreInserted();
            pr = page.continueToNewCore();
        Test.stopTest();            
    }
}