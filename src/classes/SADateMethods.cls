/*****************************
Event 1: New DevApp record [p1->if Contracts have later date update]
Event 2: DevApp deleted [p1->if Contract.Date == DeletedDevApp.Date add to List->p2]
Event 3: Device marked as deleted or cancelled [p1->if Contract.Date == CancelledDev.Date add to list->p2]
Event 4: Device's SA Date is made later [p1->if Contract.Date == Device.OldDate add to list->p2]
Event 5: Devices SA Date is made earlier [p1->if Contracts have later date update]
Event 6: New ContractApp is created 
Event 7: ContractApp is deleted

p1: Find all related records (apps, contracts)
p2: Find all related apps, devices-> find earliest SA Date -> Update Contracts

Event 1 == Event 5
Event 2 == Event 4 == Event 3
Event 6 == Event 7


This code saved from earlier version just to remember its format:
List<DeviceApplicationAssoc__c> devApps = [SELECT Device__r.Id, Device__r.SA_Date__c FROM DeviceApplicationAssoc__c WHERE Application__c IN (SELECT Application__c FROM ContApplAssoc__c WHERE Contract__c IN : contractIdsToUpdate)];
*****************************/

/*
contracts to exclude

DEA - Device Evaluation Agreement
MNDA - Multiparty NDA
NDA - Non-Disclosure Agreement
PUM - Prototype Unit Agreement
TLA - Tools Licensing Agreement

*/

public with sharing class SADateMethods {   
    
    // Events 6, 7
    // @future -- COMMENTED BY SWETHA FOR TEST
    public static void conAppsCreatedOrDeleted(Set<Id> contractIds){
        List<String> contractTypesNotToInclude = new List<String>{'DEA - Device Evaluation Agreement','MNDA - Multiparty NDA', 'NDA - Non-Disclosure Agreement', 'PUM - Prototype Unit Agreement', 'TLA - Tools Licensing Agreement'};
        
        // we have a list of all the contract Ids that had Contract Application created or Deleted 
        List<Id> appIds;
        List<Contract> contractsToUpdate = new List<Contract>();
        
        for(Contract contract : [SELECT Id, Earliest_Device_SA_Date__c, Earliest_SA_Date_Device__c FROM Contract WHERE Id IN : contractIds AND Contract_Type__c NOT IN : contractTypesNotToInclude]){
            appIds = new List<Id>();
            
            for(ContApplAssoc__c ca : [SELECT Id, Application__c, Contract__r.Id, Contract__r.Earliest_Device_SA_Date__c, Contract__r.Earliest_SA_Date_Device__c FROM ContApplAssoc__c WHERE Contract__c =: contract.Id]){
                appIds.add(ca.Application__c);              
            }
            
            for(DeviceApplicationAssoc__c devApp : [SELECT Device__r.Id, Device__r.SA_Date__c FROM DeviceApplicationAssoc__c WHERE Device__r.Cancelled__c = false AND Device__r.SA_Date__c != null AND Application__c != null AND Application__c IN : appIds]){
                if(contract.Earliest_Device_SA_Date__c > devApp.Device__r.SA_Date__c || contract.Earliest_Device_SA_Date__c == null){
                    contract.Earliest_Device_SA_Date__c = devApp.Device__r.SA_Date__c;
                    contract.Earliest_SA_Date_Device__c = devApp.Device__r.Id;                  
                }
            }
            contractsToUpdate.add(contract);    
        }
        
        if(!contractsToUpdate.isEmpty()){
            update contractsToUpdate;
        }    
    }

    // Events 1, 5
    // Assumes called when 1 device has its date made earlier or when app(s) are added to a single device
    // @future -- COMMENTED BY SWETHA FOR TEST
    public static void newDevAppOrEarlierDate(Set<Id> deviceIds){
        List<String> contractTypesNotToInclude = new List<String>{'DEA - Device Evaluation Agreement','MNDA - Multiparty NDA', 'NDA - Non-Disclosure Agreement', 'PUM - Prototype Unit Agreement', 'TLA - Tools Licensing Agreement'};
        
        Set<Id> appIds = new Set<Id>();
        Map<Id, DeviceApplicationAssoc__c> appIdDevAppMap = new Map<Id, DeviceApplicationAssoc__c>();

        for(DeviceApplicationAssoc__c da : [SELECT Id, Device__c, Application__c, Device__r.SA_Date__c FROM DeviceApplicationAssoc__c WHERE Device__r.Cancelled__c = false AND Device__r.SA_Date__c != null AND Application__c != null AND Device__c IN : deviceIds]){
            appIds.add(da.Application__c);
            appIdDevAppMap.put(da.Application__c, da);
        }
        
        Map<Id, Contract> contractsToUpdate = new Map<Id, Contract>();
        
        for(ContApplAssoc__c conApp : [SELECT Id, Application__c, Contract__c, Contract__r.Id, Contract__r.Earliest_Device_SA_Date__c, Contract__r.Earliest_SA_Date_Device__c FROM ContApplAssoc__c WHERE Application__c IN : appIds AND Contract__r.Contract_Type__c NOT IN : contractTypesNotToInclude]){
            if(conApp.Contract__r.Earliest_Device_SA_Date__c==null || (conApp.Contract__r.Earliest_Device_SA_Date__c > appIdDevAppMap.get(conApp.Application__c).Device__r.SA_Date__c)){
                if(!contractsToUpdate.containsKey(conApp.Contract__c)){
                    contractsToUpdate.put(conApp.Contract__c, new Contract(Id=conApp.Contract__c, Earliest_Device_SA_Date__c = appIdDevAppMap.get(conApp.Application__c).Device__r.SA_Date__c, Earliest_SA_Date_Device__c = appIdDevAppMap.get(conApp.Application__c).Device__c));
                }
                else{
                    if(contractsToUpdate.get(conApp.Contract__c).Earliest_Device_SA_Date__c > appIdDevAppMap.get(conApp.Application__c).Device__r.SA_Date__c){//conApp.Contract__r.Earliest_Device_SA_Date__c){
                        contractsToUpdate.put(conApp.Contract__c, new Contract(Id=conApp.Contract__c, Earliest_Device_SA_Date__c = appIdDevAppMap.get(conApp.Application__c).Device__r.SA_Date__c, Earliest_SA_Date_Device__c = appIdDevAppMap.get(conApp.Application__c).Device__c));
                    }
                }
            }
        }

        update contractsToUpdate.values();
    }
    
    //Events 2, 3, 4
    // @future -- COMMENTED BY SWETHA FOR TEST
    public static void devAppDeletedOrDevCancelledOrLaterDate(Set<Id> deviceIds){
        List<String> contractTypesNotToInclude = new List<String>{'DEA - Device Evaluation Agreement','MNDA - Multiparty NDA', 'NDA - Non-Disclosure Agreement', 'PUM - Prototype Unit Agreement', 'TLA - Tools Licensing Agreement'};
        
        List<Contract> contracts = new List<Contract>();
        List<Id> contractIds = new List<Id>(); 
        for(Contract c : [SELECT Id, Earliest_Device_SA_Date__c, Earliest_SA_Date_Device__c FROM Contract WHERE Earliest_SA_Date_Device__c IN : deviceIds AND Contract_Type__c NOT IN : contractTypesNotToInclude]){
            c.Earliest_Device_SA_Date__c = null;
            c.Earliest_SA_Date_Device__c = null;
            contracts.add(c);
            contractIds.add(c.Id);
        }
        // now we have a list of all the contracts who had any of the updated devices as the earliest device
        
        if(!contracts.isEmpty()){
            List<ContApplAssoc__c> conApps = new List<ContApplAssoc__c>();
            List<Id> apps = new List<Id>();
            
            For(ContApplAssoc__c ca : [SELECT Id, Application__c, Contract__c FROM ContApplAssoc__c WHERE Application__c != null AND Contract__c IN : contractIds]){
                conApps.add(ca);
            }
            
            Map<Id, DeviceApplicationAssoc__c> appIdDevAppMap = new Map<Id, DeviceApplicationAssoc__c>();

            for(DeviceApplicationAssoc__c devApp : [SELECT Device__r.Id, Device__r.SA_Date__c, Application__c FROM DeviceApplicationAssoc__c WHERE Device__r.Cancelled__c = false AND Device__r.SA_Date__c != null AND Application__c != null AND Application__c IN (SELECT Application__c FROM ContApplAssoc__c WHERE Contract__c IN : contractIds) ORDER BY Device__r.SA_Date__c ASC]){
                if(!appIdDevAppMap.containsKey(devApp.Application__c) && devApp.Device__r.SA_Date__c != null){
                    appIdDevAppMap.put(devApp.Application__c, devApp);
                }
            }                   
                    
            // now we have all the conApps and devApps that are related to any of the contracts
            // need to iterate through all the list for each contract
            for(Contract c : contracts){
                for(ContApplAssoc__c ca : conApps){
                    if(ca.Contract__c == c.Id){                     
                        if(appIdDevAppMap.containsKey(ca.Application__c)){
                            if(c.Earliest_Device_SA_Date__c == null || c.Earliest_Device_SA_Date__c > appIdDevAppMap.get(ca.Application__c).Device__r.SA_Date__c){
                                c.Earliest_Device_SA_Date__c = appIdDevAppMap.get(ca.Application__c).Device__r.SA_Date__c;
                                c.Earliest_SA_Date_Device__c = appIdDevAppMap.get(ca.Application__c).Device__r.Id;
                            }
                        }
                    }
                }
            }
            update contracts;
        }
    }
    
/*
        Not Needed Either??
        
    private testmethod static void TestSADateMethodsAndTriggersDelete() {
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        
        Account a1 = new Account(Name='Account1TestSADate');
        insert a1;
        
        Contract c1 = new Contract(Name='Contract1TestSADate', AccountId=a1.Id, StartDate=DATE.today());
        insert c1;
        
        List<Application__c> apps = new List<Application__c>{new Application__c(Name='App1', application_type__c = 'Embedded', Account__c=a1.Id, Available_For_Use__c=true), new Application__c(Name='App2', application_type__c = 'Preload', Application_Sub_Type__c='faketype', Account__c=a1.Id, Available_For_Use__c=true), new Application__c(Name='App3', application_type__c = 'Other', Account__c=a1.Id, Available_For_Use__c=true)};
        insert apps;
        
        List<Device__c> devices = new List<Device__c>{new Device__c(Name='Dev1', SA_Date__c=Date.today()-3), new Device__c(Name='Dev2', SA_Date__c=Date.today()-2), new Device__c(Name='Dev3', SA_Date__c=Date.today()-1)};
        System.runAs(p) {               
            insert devices;
        }
        
        ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c1.Id, Application__c=apps[0].Id, Governing_End_Date__c=false);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c1.Id, Application__c=apps[1].Id, Governing_End_Date__c=false);
        ContApplAssoc__c ca3 = new ContApplAssoc__c(Contract__c=c1.Id, Application__c=apps[2].Id, Governing_End_Date__c=false);
        List<ContApplAssoc__c> contApps = new List<ContApplAssoc__c>{ca1, ca2, ca3};
                
        DeviceApplicationAssoc__c da1 = new DeviceApplicationAssoc__c(Device__c=devices[0].Id, Application__c=apps[0].Id, Include_in_BOM__c=false);
        DeviceApplicationAssoc__c da2 = new DeviceApplicationAssoc__c(Device__c=devices[1].Id, Application__c=apps[1].Id, Include_in_BOM__c=false); 
        DeviceApplicationAssoc__c da3 = new DeviceApplicationAssoc__c(Device__c=devices[2].Id, Application__c=apps[2].Id, Include_in_BOM__c=false);
        List<DeviceApplicationAssoc__c> devApps = new List<DeviceApplicationAssoc__c>{da1, da2, da3};

        insert contApps;

        insert devApps; 

        devices[0].SA_Date__c = Date.today()+3;
        update devices[0];
        devices[2].SA_Date__c = Date.today()-5;
        update devices[2];
        
        Test.startTest();
        system.debug('Start Test  - TestSADateMethodsAndTriggersDelete');
        delete da3;
        
        delete ca2;     
        system.debug('Stop Test  - TestSADateMethodsAndTriggersDelete');
        Test.stopTest();
    }           
*/  

/*
    NOT NEEDED, conAppsCreatedOrDeleted is tested by DeviceMethods.calculatePercentExecutedContractsOnBomOrSDTest
    
    private testmethod static void TestSADateMethodsAndTriggersInsertConApps() {
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        
        Account a1 = new Account(Name='Account1TestSADate');
        insert a1;
        
        Contract c1 = new Contract(Name='Contract1TestSADate', AccountId=a1.Id, StartDate=DATE.today());
        insert c1;
        
        List<Application__c> apps = new List<Application__c>{new Application__c(Name='App1', application_type__c = 'Embedded', Available_For_Use__c=true), new Application__c(Name='App2', application_type__c = 'Preload', Application_Sub_Type__c='faketype', Available_For_Use__c=true), new Application__c(Name='App3', application_type__c = 'Other', Available_For_Use__c=true)};
        insert apps;
        
        List<Device__c> devices = new List<Device__c>{new Device__c(Name='Dev1', SA_Date__c=Date.today()-3), new Device__c(Name='Dev2', SA_Date__c=Date.today()-2), new Device__c(Name='Dev3', SA_Date__c=Date.today()-1)};
        System.runAs(p) {               
            insert devices;
        }
       
        ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c1.Id, Application__c=apps[0].Id, Governing_End_Date__c=false);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c1.Id, Application__c=apps[1].Id, Governing_End_Date__c=false);
        ContApplAssoc__c ca3 = new ContApplAssoc__c(Contract__c=c1.Id, Application__c=apps[2].Id, Governing_End_Date__c=false);
        List<ContApplAssoc__c> contApps = new List<ContApplAssoc__c>{ca1, ca2, ca3};
                
        DeviceApplicationAssoc__c da1 = new DeviceApplicationAssoc__c(Device__c=devices[0].Id, Application__c=apps[0].Id, Include_in_BOM__c=false);
        DeviceApplicationAssoc__c da2 = new DeviceApplicationAssoc__c(Device__c=devices[1].Id, Application__c=apps[1].Id, Include_in_BOM__c=false); 
        DeviceApplicationAssoc__c da3 = new DeviceApplicationAssoc__c(Device__c=devices[2].Id, Application__c=apps[2].Id, Include_in_BOM__c=false);
        List<DeviceApplicationAssoc__c> devApps = new List<DeviceApplicationAssoc__c>{da1, da2, da3};
        
        insert devApps; 
        system.debug('Start Test  - TestSADateMethodsAndTriggersInsertConApps');
        Test.startTest();
        system.debug('Stop Test  - TestSADateMethodsAndTriggersInsertConApps');
        insert contApps;

        Test.stopTest();

    }   
    
*/

/*
        
        NOT NEEDED, newDevAppOrEarlierDate is tested by DeviceMethods.calculatePercentExecutedContractsOnBomOrSDTest
        
    private testmethod static void TestSADateMethodsAndTriggersInsertDevApps() {
        system.debug('test insert devApps SA Date');
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        
        Account a1 = new Account(Name='Account1TestSADate');
        insert a1;
        
        Contract c1 = new Contract(Name='Contract1TestSADate', AccountId=a1.Id, StartDate=DATE.today());
        insert c1;
        
        List<Application__c> apps = new List<Application__c>{new Application__c(Name='App1', application_type__c = 'Embedded', Available_For_Use__c=true), new Application__c(Name='App2', application_type__c = 'Preload', Application_Sub_Type__c='faketype', Available_For_Use__c=true), new Application__c(Name='App3', application_type__c = 'Other', Available_For_Use__c=true)};
        insert apps;
        
        List<Device__c> devices = new List<Device__c>{new Device__c(Name='Dev1', SA_Date__c=Date.today()-1), new Device__c(Name='Dev2', SA_Date__c=Date.today()-2), new Device__c(Name='Dev3', SA_Date__c=Date.today()-3)};
        System.runAs(p) {               
            insert devices;
        }
       
        ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c1.Id, Application__c=apps[0].Id, Governing_End_Date__c=false);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c1.Id, Application__c=apps[1].Id, Governing_End_Date__c=false);
        ContApplAssoc__c ca3 = new ContApplAssoc__c(Contract__c=c1.Id, Application__c=apps[2].Id, Governing_End_Date__c=false);
        List<ContApplAssoc__c> contApps = new List<ContApplAssoc__c>{ca1, ca2, ca3};
                
        DeviceApplicationAssoc__c da1 = new DeviceApplicationAssoc__c(Device__c=devices[0].Id, Application__c=apps[0].Id, Include_in_BOM__c=false);
        DeviceApplicationAssoc__c da2 = new DeviceApplicationAssoc__c(Device__c=devices[1].Id, Application__c=apps[1].Id, Include_in_BOM__c=false); 
        DeviceApplicationAssoc__c da3 = new DeviceApplicationAssoc__c(Device__c=devices[2].Id, Application__c=apps[2].Id, Include_in_BOM__c=false);
        List<DeviceApplicationAssoc__c> devApps = new List<DeviceApplicationAssoc__c>{da1, da2, da3};
        
        insert contApps;
        system.debug('Start Test  - TestSADateMethodsAndTriggersInsertDevApps');
        Test.startTest();
        
        insert devApps; 
        
        system.debug('Stop Test  - TestSADateMethodsAndTriggersInsertDevApps');

        Test.stopTest();
    
    }       
*/

}