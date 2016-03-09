public with sharing class CoreDevicePackageMethods {

    /*
     * Created by: Jesse
     * Creation date: Unknown
     * Description: <TO-DO>
     * Change history:
     * Date: 19-Jul-2012 Changed by: Rajesh Krishnaiah
     * Change: Added logic to clone CDP apps and not copy
     *         apps from the stable. This is because the apps on the
     *         original CDP could have changes and we want the clone
     *         CDP operation to bring over those changes.
     */

    public static void addStableElementsToCoreDevicePackage(List<Core_Device_Package__c> newList){
        List<Id> stableIds = new List<Id>();
        List<Id> programIds = new List<Id>();
        Map<Id, String> stableIdNameMap = new Map<Id, String>();
        // for each core get stable Id
        for(Core_Device_Package__c cdp : newList){
            stableIds.add(cdp.Stable__c);
        }
        
        // for each stable create list of program Ids
        Map<Id, List<Id>> stableIdProgramIdListMap = new Map<Id, List<Id>>();
        for(Stable_Program__c sp : [SELECT Id, Stable__c, Stable__r.Name, Program__c 
                                    FROM Stable_Program__c 
                                    WHERE Stable__c IN : stableIds]){
            stableIdNameMap.put(sp.Stable__c, sp.Stable__r.Name);
            programIds.add(sp.Program__c);
            
            List<Id> tempList = stableIdProgramIdListMap.get(sp.Stable__c);
            if(tempList == null){
                tempList = new List<Id>{sp.Program__c};
            } else {
                tempList.add(sp.Program__c);
            }
            stableIdProgramIdListMap.put(sp.Stable__c, tempList);
        }
        
        // for each stable create list of Stable-Applications 
        Map<Id, List<Stable_Application__c>> stableIdStableAppListMap = 
            new Map<Id, List<Stable_Application__c>>();
        
        // Rajesh Start
        // Build a list of stable apps only when not invoked from
        // the clone CDP action.
        if (CloneCoreDevicePackage.insertAppsFromCDP_AndNotFromStable == false) {
            // Rajesh End
            for(Stable_Application__c sa : 
                [SELECT Id, Stable__c, Stable__r.Name, Application__c, Source_Id__c 
                 FROM Stable_Application__c 
                 WHERE Stable__c IN : stableIds]){
                stableIdNameMap.put(sa.Stable__c, sa.Stable__r.Name);
                List<Stable_Application__c> tempList = stableIdStableAppListMap.get(sa.Stable__c);
                if(tempList == null){
                    tempList = new List<Stable_Application__c>{sa};
                } else {
                    tempList.add(sa);
                }
                stableIdStableAppListMap.put(sa.Stable__c, tempList);
            }
        }
                
        List<Core_Device_Package_Program__c> coreProgramsToInsert = 
            new List<Core_Device_Package_Program__c>();		
        List<Core_Device_Package_Application__c> coreAppsToInsert = 
            new List<Core_Device_Package_Application__c>();
        
        // for each core create new corePrograms based on stable Id
        // for each coreProgram being added create coreApps, based on appId
        // for each stableApp not from a source create coreApps
        for(Core_Device_Package__c cdp : newList){
            if(stableIdProgramIdListMap.get(cdp.Stable__c) != null){
                for(Id programId : stableIdProgramIdListMap.get(cdp.Stable__c)){
                    coreProgramsToInsert.add(new Core_Device_Package_Program__c(
                        Core_Device_Package__c = cdp.Id, 
                        Program__c = programId, 
                        Source_Id__c = cdp.Stable__c, 
                        Source_Name__c = stableIdNameMap.get(cdp.Stable__c)));
                }
            }
            
            if(stableIdStableAppListMap.get(cdp.Stable__c) != null){
                for(Stable_Application__c sa :stableIdStableAppListMap.get(cdp.Stable__c)){
                    String applicationSourceId = null;
                    if(sa.Source_Id__c == null){
                        //add this application with Application Source Id as Stable
                        applicationSourceId = cdp.Stable__c;
                    } else {
                        //add this application with Application Source Id as Program
                        applicationSourceId = sa.Source_Id__c;
                    }
                    if(applicationSourceId.length() == 18){
                        applicationSourceId = applicationSourceId.substring(0,15);
                    }
                    coreAppsToInsert.add(new Core_Device_Package_Application__c(
                        Core_Device_Package__c=cdp.Id,
                        Application__c=sa.Application__c,
                        Source_Id__c=cdp.Stable__c,
                        Source_Name__c = stableIdNameMap.get(cdp.Stable__c),
                        Application_Source_Id__c = applicationSourceId));
                }
            }
        }
        
        // Rajesh Start
        // Clone source CDP apps if we got here from the "clone CDP screen"
        if (CloneCoreDevicePackage.insertAppsFromCDP_AndNotFromStable) {
            // The newList will have only one record during the clone
            // New CDP ID is in the first record of the newList
            Id cdpId = newList[0].id;
            for (Core_Device_Package_Application__c originalCdpApp : 
                [select Application__c, Source_Id__c, Source_Name__c, Application_Source_Id__c,
                        Include_in_BOM__c
                  from Core_Device_Package_Application__c
                  where Core_Device_Package__c = :CloneCoreDevicePackage.existingCoreId
                  and Source_Id__c = :CloneCoreDevicePackage.sourceCDP_StableID]) {
    
                coreAppsToInsert.add(new Core_Device_Package_Application__c(
                    Core_Device_Package__c = cdpId,
                    Application__c = originalCdpApp.Application__c,
                    Source_Id__c = originalCdpApp.Source_Id__c,
                    Source_Name__c = originalCdpApp.Source_Name__c,
                    Application_Source_Id__c = originalCdpApp.Application_Source_Id__c,
                    Include_in_BOM__c = originalCdpApp.Include_in_BOM__c));
            }
        }
        // Rajesh End
        
        insert coreProgramsToInsert;
        insert coreAppsToInsert;		
    }
    
    public static void addStableToCoreDevicePackageDevices(List<Core_Device_Package__c> newList){
        Map<Id, Core_Device_Package__c> coreIdMap = new Map<Id, Core_Device_Package__c>(newList);
                
        List<Device__c> devices = 
            [SELECT Id, Core_Device_Package__c, Stable__c 
             FROM Device__c 
             WHERE Core_Device_Package__c IN : coreIdMap.keySet()];
        for(Device__c d : devices){
            if(coreIdMap.get(d.Core_Device_Package__c).Stable__c != null){
                d.Stable__c = coreIdMap.get(d.Core_Device_Package__c).Stable__c;
            }
        }
        
        if(!devices.isEmpty()) { 
            update devices;
            for(Device__c d : devices){
                StableDevicemethods.addStableElementsToDevice(d);
            }
        }
    }
    
    public static void removeStableElementsFromCoreDevicePackage(List<Core_Device_Package__c> oldList){
        List<Id> stableIds = new List<Id>();
        List<Id> coreIds = new List<Id>();
        
        for(Core_Device_Package__c cdp : oldList){
            coreIds.add(cdp.Id);
            system.debug('THIS IS STABLE: ' + cdp.Stable__c);
            stableIds.add(cdp.Stable__c);
        }
        
        List<Core_Device_Package_Program__c> coreProgramsToDelete = 
            [SELECT Id, Source_Id__c 
             FROM Core_Device_Package_Program__c 
             WHERE Core_Device_Package__c IN : coreIds 
             AND Source_Id__c IN : stableIds];
        for(Core_Device_Package_Program__c cdpp : coreProgramsToDelete){
            cdpp.Source_Id__c = null;
            cdpp.Source_Name__c = null;
        }
        update coreProgramsToDelete;
        delete coreProgramsToDelete;
    
    
        List<Core_Device_Package_Application__c> coreAppsToDelete = 
            [SELECT Id, Source_Id__c 
             FROM Core_Device_Package_Application__c 
             WHERE Core_Device_Package__c IN : coreIds 
             AND Source_Id__c IN : stableIds];
        for(Core_Device_Package_Application__c cdpa : coreAppsToDelete){
            cdpa.Source_Id__c = null;
            cdpa.Source_Name__c = null;
        }
        update coreAppsToDelete;
        delete coreAppsToDelete;
    }
    
    
    public static void removeStableFromCoreDevicePackageDevices(List<Core_Device_Package__c> oldList){
        Map<Id, Core_Device_Package__c> coreIdMap = new Map<Id, Core_Device_Package__c>(oldList);
                
        List<Device__c> devices = [SELECT Id, Core_Device_Package__c, Stable__c 
                                   FROM Device__c 
                                   WHERE Core_Device_Package__c IN : coreIdMap.keySet()];
        for(Device__c d : devices){
            String applicationSourceId = null;
            if(coreIdMap.get(d.Core_Device_Package__c).Stable__c == d.Stable__c){
                // stable came from core
                StableDevicemethods.removeStableElementsFromDevice(d, d.Core_Device_Package__c);	
            } else {
                // stable did not come from core
                StableDevicemethods.removeStableElementsFromDevice(d, d.Stable__c);
            }
            
            d.Stable__c = null;
        }
        
        if(!devices.isEmpty()) { update devices; }
    }
    
    private static testmethod void CoreDevicePackageMethodsTest1(){
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp');
        insert cdp;
        
        User u = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Device__c d = new Device__c(Name='d', Core_Device_Package__c = cdp.Id);
        System.runAs(u) {			
            insert new List<Device__c>{d};
        }
        
        Stable__c s = new Stable__c(Name='s');
        Stable__c s2 = new Stable__c(Name='s');
        insert new List<Stable__c>{s,s2};
        
        
        
        Program__c p1 = new Program__c(Name='p1');
        Program__c p2 = new Program__c(Name='p2');
        insert new List<Program__c>{p1,p2};
        
        Stable_Program__c sp = new Stable_Program__c(Stable__c=s.Id, Program__c=p1.Id);
        Stable_Program__c sp2 = new Stable_Program__c(Stable__c=s.Id, Program__c=p2.Id);
        insert new List<Stable_Program__c>{sp, sp2};
        
        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        Application__c app2 = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        Application__c app3 = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        Application__c app4 = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        insert new List<Application__c>{app, app2, app3, app4};
        
        Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
        insert c;
        ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app2.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca3 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app3.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca4 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app4.Id, Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca1, ca2, ca3, ca4};
        
        
        Stable_Application__c sa = new Stable_Application__c(Stable__c=s.Id, Application__c=app.Id);
        Stable_Application__c sa2 = new Stable_Application__c(Stable__c=s.Id, Application__c=app2.Id);
        insert new List<Stable_Application__c>{sa, sa2};
        
        Program_Application__c pa = new Program_Application__c(Program__c=p1.Id, Application__c=app3.Id);
        Program_Application__c pa2 = new Program_Application__c(Program__c=p1.Id, Application__c=app4.Id);
        insert new List<Program_Application__c>{pa, pa2};
        
        Test.startTest();
            cdp.Stable__c = s.Id;
            update cdp;
            
            //cdp.Stable__c = s2.Id;
            //update cdp;
            
            //cdp.Stable__c = null;
            //update cdp;
        Test.stopTest();
    }
    
    private static testmethod void CoreDevicePackageMethodsTest2(){
        Stable__c s = new Stable__c(Name='s');
        Stable__c s2 = new Stable__c(Name='s');
        insert new List<Stable__c>{s,s2};
        
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp', Stable__c = s.Id);
        insert cdp;
        
        User u = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Device__c d = new Device__c(Name='d', Core_Device_Package__c = cdp.Id);
        System.runAs(u) {			
            insert new List<Device__c>{d};
        }
        
        Program__c p1 = new Program__c(Name='p1');
        Program__c p2 = new Program__c(Name='p2');
        insert new List<Program__c>{p1,p2};
        
        Stable_Program__c sp = new Stable_Program__c(Stable__c=s.Id, Program__c=p1.Id);
        Stable_Program__c sp2 = new Stable_Program__c(Stable__c=s.Id, Program__c=p2.Id);
        insert new List<Stable_Program__c>{sp, sp2};
        
        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        Application__c app2 = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        Application__c app3 = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        Application__c app4 = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        insert new List<Application__c>{app, app2, app3, app4};
        
        Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
        insert c;
        ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app2.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca3 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app3.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca4 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app4.Id, Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca1, ca2, ca3, ca4};
        
        Stable_Application__c sa = new Stable_Application__c(Stable__c=s.Id, Application__c=app.Id);
        Stable_Application__c sa2 = new Stable_Application__c(Stable__c=s.Id, Application__c=app2.Id);
        insert new List<Stable_Application__c>{sa, sa2};
        
        Program_Application__c pa = new Program_Application__c(Program__c=p1.Id, Application__c=app3.Id);
        Program_Application__c pa2 = new Program_Application__c(Program__c=p1.Id, Application__c=app4.Id);
        insert new List<Program_Application__c>{pa, pa2};
        
        Test.startTest();
            //cdp.Stable__c = s.Id;
            //update cdp;
            
            cdp.Stable__c = s2.Id;
            update cdp;
            
            cdp.Stable__c = null;
            update cdp;
        Test.stopTest();
    }
}