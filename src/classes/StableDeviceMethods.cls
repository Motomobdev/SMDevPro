public with sharing class StableDeviceMethods {
        
    public static void addStableElementsToDevice(Device__c device){
        Stable__c stable = [SELECT Id, Name FROM Stable__c WHERE Id =: device.Stable__c];
        
        String source;
        String sourceName;
        Core_Device_Package__c cdp;
        Boolean stableCameFromCore = false;
        
        if(device.Core_Device_Package__c != null){
            try{
                cdp = [SELECT Id, Stable__c, Name FROM Core_Device_Package__c WHERE Id =: device.Core_Device_Package__c];
            } catch(System.QueryException e){
                
            }
        }
        if(device.Core_Device_Package__c != null && cdp != null && cdp.Stable__c == device.Stable__c){
            // stable came from core should source should be core
            source = device.Core_Device_Package__c;
            sourceName = cdp.Name;
            stableCameFromCore = true;
        } else {
            // stable did not come from core, source should be stable
            source = stable.Id;
            sourceName = stable.Name;
        }
        system.debug('Start of addStableElementsToDevice, device.stable + ' + device.Stable__c);
        
        List<Id> programIds = new List<Id>();
        
        List<Program_Device__c> programDevicesToInsert = new List<Program_Device__c>();
        List<DeviceApplicationAssoc__c> devAppsToInsert = new List<DeviceApplicationAssoc__c>();
        
        //create new Program Devices to insert
        for(Stable_Program__c stableProgram : [SELECT Id, Stable__c, Program__c FROM Stable_Program__c WHERE Stable__c =: stable.Id]){
            programDevicesToInsert.add(new Program_Device__c(Device__c = device.Id, Program__c = stableProgram.Program__c, Source_Id__c = source, Source_Name__c = sourceName));
            programIds.add(stableProgram.Program__c);   
        }
        
        //create new Stable Applications to insert
        for(Stable_Application__c sa : [SELECT Id, Stable__c, Application__c, Source_Id__c FROM Stable_Application__c WHERE Stable__c =: stable.Id]){
            String applicationSourceId = null;
            if(sa.Source_Id__c == null){
                //add this application with Application Source Id as Stable
                applicationSourceId = sa.Stable__c;
            } else {
                //add this application with Application Source Id as Program
                applicationSourceId = sa.Source_Id__c;
            }
            if(applicationSourceId.length() == 18){
                applicationSourceId = applicationSourceId.substring(0,15);
            }

            // 4-Feb-2014: Rajesh: Set the default approval status to Approved because the
            // stable is pre-approved.
            devAppsToInsert.add(new DeviceApplicationAssoc__c(Device__c = device.Id, Application__c = sa.Application__c, Source_Id__c = source, Source_Name__c = sourceName, Application_Source_Id__c = applicationSourceId, 
            Approval_Status__c = 'Approved'));
        }   
                
        if(!programDevicesToInsert.isEmpty()){
            insert programDevicesToInsert;
        }
        
        if(!devAppsToInsert.isEmpty()){ 
            insert devAppsToInsert; 
        }
    }
    
    public static void removeStableElementsFromDevice(Device__c device, Id source){
        system.debug('THIS IS Device ID: ' + device.Id);
        system.debug('THIS IS device.stable__c: ' + device.Stable__c);
        system.debug('THIS IS source ID: ' + source);
        List<DeviceApplicationAssoc__c> devAppsToDelete = new List<DeviceApplicationAssoc__c>();

        List<Program_Device__c> programDevicesToDelete = [SELECT Id, Program__c FROM Program_Device__c WHERE Source_Id__c =: source AND Device__c =: device.Id];
        for(Program_Device__c pg : programDevicesToDelete){
            pg.Source_Id__c = null;
        }
        
        devAppsToDelete = [SELECT Id FROM DeviceApplicationAssoc__c WHERE Source_Id__c =: source and Device__c =: device.Id];
        for(DeviceApplicationAssoc__c da : devAppsToDelete){
            da.Source_Id__c = null;
        }
        
        update programDevicesToDelete;          
        delete programDevicesToDelete;
        update devAppsToDelete;
        delete devAppsToDelete;
    }
        
    private static testmethod void StableDeviceMethodsTest1(){
        
        Stable__c s = new Stable__c(Name='testStable');
        insert s;
        Stable__c s2 = new Stable__c(Name='testStable');
        insert s2;
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp', Stable__c = s2.Id);
        insert cdp;
        Device__c d = new Device__c(Name='testDevice', Stable__c=s.Id);
        insert d;
        Device__c d2 = new Device__c(Name='testDevice', Stable__c=s2.Id, Core_Device_Package__c = cdp.Id);
        insert d2;
        Program__c p = new Program__c(Name='testProgram', Reviewed_Approved__c = 'No');
        insert p;
        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c appOnStable = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        //Application__c appOnProgram = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        //insert new List<Application__c>{appOnStable,appOnProgram};
        insert appOnStable;
        Contract c = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=appOnStable.Id, Governing_End_Date__c=true);
        insert ca;
        /*Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=appOnProgram.Id);
        insert pa;*/ 
        Stable_Application__c sa = new Stable_Application__c(Stable__c=s.Id, Application__c=appOnStable.Id);
        insert sa;      
        Stable_Program__c sp = new Stable_Program__c(Stable__c=s.Id, Program__c=p.Id);
        insert sp;
                
        Test.startTest();
            addStableElementsToDevice(d);
            addStableElementsToDevice(d2);
            
            removeStableElementsFromDevice(d, s.Id);
        Test.stopTest();
    }
    
    /*private static testmethod void StableDeviceMethodsTest2(){
        
        Stable__c s = new Stable__c(Name='testStable');
        insert s;
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp', Stable__c = s.Id);
        insert cdp;

        Device__c d2 = new Device__c(Name='testDevice', Stable__c=s.Id, Core_Device_Package__c = cdp.Id);
        insert d2;
        Program__c p = new Program__c(Name='testProgram', Reviewed_Approved__c = 'Yes');
        insert p;
        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c appOnStable = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        Application__c appOnProgram = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        insert new List<Application__c>{appOnStable,appOnProgram};
        Contract c = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=appOnProgram.Id, Governing_End_Date__c=true);
        insert ca;
        Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=appOnProgram.Id);
        insert pa; 
        Stable_Application__c sa = new Stable_Application__c(Stable__c=s.Id, Application__c=appOnStable.Id);
        insert sa;      
        Stable_Program__c sp = new Stable_Program__c(Stable__c=s.Id, Program__c=p.Id);
        insert sp;
                
        Test.startTest();
            addStableElementsToDevice(d2);
        Test.stopTest();
    }*/
}