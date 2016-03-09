public with sharing class CloneCoreDevicePackage {
    /*
     * Created by: Jesse
     * Creation date: Unknown
     * Description: <TO-DO>
     * Change history:
     * Date: 21-Jul-2012 Changed by: Rajesh Krishnaiah
     * Changes: Added static variables to prevent 
     *     -- CDP program's after insert trigger from inserting CDP Apps
     *     -- CDP's stable from inserting stable applications.
     *     The applications will be copied from the source CDP to target 
     */ 
  
    public Core_Device_Package__c existingCore {get; set;}
    public Core_Device_Package__c newCore {get; set;}
      
    // This is used to skip after/before insert trigger execution
    // on the core device program.
    public static boolean insertAppsFromCDP_AndNotFromPrograms = false;
    public static Id existingCoreId = null;
    public static Id newCoreId = null;
      
    // This is used to skip after insert trigger execution
    // on the core device package
    public static boolean insertAppsFromCDP_AndNotFromStable = false;
    public static Id sourceCDP_StableID = null;
      
    public CloneCoreDevicePackage(ApexPages.StandardController controller){  
        existingCore = [SELECT Name, Stable__c, Id FROM Core_Device_Package__c WHERE Id =: controller.getId()];
        newCore = new Core_Device_Package__c(Name=existingCore.Name + ' - CLONE', Stable__c = existingCore.Stable__c);
    }
    
    public PageReference createNewCore(){
      try {
        // Insert newCore, also adds Stable Elements to Core
        insertAppsFromCDP_AndNotFromStable = true;
        sourceCDP_StableID = existingCore.stable__c;
        existingCoreId = existingCore.id;
        insert newCore;
        insertAppsFromCDP_AndNotFromStable = false;
        
        // add Programs to Core
        List<Core_Device_Package_Program__c> cdpProgramsToInsert = new List<Core_Device_Package_Program__c>();
        for(Core_Device_Package_Program__c cdpp : [SELECT Program__c FROM Core_Device_Package_Program__c WHERE Core_Device_Package__c =: existingCore.Id AND Source_Id__c = null]){
            cdpProgramsToInsert.add(new Core_Device_Package_Program__c(Core_Device_Package__c = newCore.Id, Program__c = cdpp.Program__c));
        }
        
        // Rajesh -- START 
        // The trigger on the CDP Program causes CDP Apps to be inserted.
        // We force the trigger execution to insert the apps from CDP Apps
        // by setting this request specific static variable to true.        
        insertAppsFromCDP_AndNotFromPrograms = true;
        existingCoreId = existingCore.id;
        newCoreId = newCore.id;
        insert cdpProgramsToInsert;
        existingCoreId = null;
        newCoreId = null;
        insertAppsFromCDP_AndNotFromPrograms = false;
        // Rajesh -- END 
        
        // add Applications to Core
        List<Core_Device_Package_Application__c> cdpAppsToInsert = new List<Core_Device_Package_Application__c>();
        for(Core_Device_Package_Application__c cdpa : [SELECT Application__c, Include_in_BOM__c FROM Core_Device_Package_Application__c WHERE Core_Device_Package__c =: existingCore.Id AND Source_Id__c = null]){
            cdpAppsToInsert.add(new Core_Device_Package_Application__c(Core_Device_Package__c = newCore.Id, Application__c = cdpa.Application__c, Include_in_BOM__c = cdpa.Include_in_BOM__c));
        }
        insert cdpAppsToInsert;
          
        PageReference pr = new PageReference('/' + newCore.Id);
        pr.setRedirect(true);
        return pr;
      } catch (System.DMLException e){
        existingCore.addError('There was a problem creating the clone. You can try again or contact Brian Chiang, brian.chiang@motorola.com, for assistance.');
        return null;
      }
    }
    
    public PageReference cancel(){
        PageReference pr = new PageReference('/' + existingCore.Id);
        pr.setRedirect(true);
        return pr;
    }
    
    private static testmethod void CloneCoreDevicePackageTest(){
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
        
        Test.startTest();
            ApexPages.StandardController setCon = new ApexPages.StandardController(cdp);  
            ApexPages.currentPage().getParameters().put('Id', cdp.Id);
            CloneCoreDevicePackage page = new CloneCoreDevicePackage(setCon);
            PageReference pr = page.cancel();
            pr = page.createNewCore();
        Test.stopTest();            
    }
}