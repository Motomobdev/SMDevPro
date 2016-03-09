/*** CALCULATE PERCENT OF EXECUTED CONTRACTS ON BOM OR SD CARD FROM DEVICE/CONTRACT ID ***/

public without sharing class DevAppsOnBomSDWithExecutedContracts {
    
    //@future commented by swetha
    public static void calculatePercentOfExecutedContractsOnBomOrSDCardFromDeviceId(Set<Id> devIds){
        List<DeviceApplicationAssoc__c> allDevApps = [SELECT Id, Device__c, Include_in_BOM__c, Include_on_SD_Card__c, Application__r.Application_Contract_Status__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : devIds AND (Include_in_BOM__c=true OR Include_on_SD_Card__c=true) AND isDeleted=false AND Device__r.Cancelled__c = false];
        Map<Id, List<DeviceApplicationAssoc__c>> devIdDevAppListMap = new Map<Id, List<DeviceApplicationAssoc__c>>();
        for(DeviceApplicationAssoc__c devApp : allDevApps){
            if(!devIdDevAppListMap.containsKey(devApp.Device__c)){
                devIdDevAppListMap.put(devApp.Device__c, new List<DeviceApplicationAssoc__c>{devApp});
            } else {
                List<DeviceApplicationAssoc__c> tempDevAppList = devIdDevAppListMap.get(devApp.Device__c);
                tempDevAppList.add(devApp);
                devIdDevAppListMap.put(devApp.Device__c, tempDevAppList);
            }
            
        }
        
        if(!devIdDevAppListMap.isEmpty()){
            List<Device__c> devicesToUpdate = new List<Device__c>();
            Double numberExecutedOnBomOrSDCard;
            Double numberOnBomOrSDCard;
            for(Device__c dev : [SELECT Id, Percent_BOM_SD_Apps_w_Executed_Contract__c FROM Device__c WHERE Id IN : devIds AND Cancelled__c = false]){
                if(devIdDevAppListMap.containsKey(dev.Id)){
                    numberExecutedOnBomOrSDCard = 0;
                    numberOnBomOrSDCard = 0;
                    
                    for(DeviceApplicationAssoc__c da : devIdDevAppListMap.get(dev.Id)){
                        ++numberOnBomOrSDCard;
                        if((da.Include_in_BOM__c || da.Include_on_SD_Card__c) && da.Application__r.Application_Contract_Status__c == 'Fully Executed'){
                            ++numberExecutedOnBomOrSDCard;  
                        }
                    }
        
                    if(numberOnBomOrSDCard != 0){               
                        dev.Percent_BOM_SD_Apps_w_Executed_Contract__c = numberExecutedOnBomOrSDCard / numberOnBomOrSDCard;
                        if(dev.Percent_BOM_SD_Apps_w_Executed_Contract__c != 100){
                            dev.Percent_BOM_SD_Apps_w_Executed_Contract__c = dev.Percent_BOM_SD_Apps_w_Executed_Contract__c * 100;
                        }
                        devicesToUpdate.add(dev);
                    } else {
                        dev.Percent_BOM_SD_Apps_w_Executed_Contract__c = 0;
                        devicesToUpdate.add(dev);
                    }   
                } else {
                    dev.Percent_BOM_SD_Apps_w_Executed_Contract__c = 0;
                    devicesToUpdate.add(dev);
                }
                        
            }
            
            try{
                update devicesToUpdate;
            } catch(System.DMLException e){     
                String body = 'DevAppsOnBomSDWithExecutedContracts.calculatePercentOfExecutedContractsOnBomOrSDCardFromDeviceId was not able to update a device: ' + e.getMessage();
        
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                    
                String[] toAddresses = new String[] {'brian.chiang@motorola.com'}; 
                mail.setToAddresses(toAddresses);
                   
                mail.setReplyTo('brian.chiang@motorola.com');
                
                mail.setSenderDisplayName('Error Calculating % of Executed Contracts on BOM.');
                
                mail.setSubject('SALESFORCE: Could not calculate % of Executed Contract on BOM');
                
                // Set to True if you want to BCC yourself on the email.    
                mail.setBccSender(false);
                
                // Optionally append the salesforce.com email signature to the email.  
                // The email address of the user executing the Apex Code will be used.  
                mail.setUseSignature(false);
                
                // Specify the text content of the email.  
                mail.setPlainTextBody(body);
        
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
    }
    
    //@future
    public static void calculatePercentOfExecutedContractsOnBomOrSDCardFromContractId(Set<Id> contractIdsToCalculatePercentageOnDevice){
        Set<Id> devIdsInludeBomOrSDCard = new Set<Id>();
        for(DeviceApplicationAssoc__c da : [SELECT Device__c FROM DeviceApplicationAssoc__c WHERE Application__c IN (SELECT Application__c FROM ContApplAssoc__c WHERE Contract__c IN : contractIdsToCalculatePercentageOnDevice)]){
            devIdsInludeBomOrSDCard.add(da.Device__c);
        }
    
        if(!devIdsInludeBomOrSDCard.isEmpty()){
            calculatePercentOfExecutedContractsOnBomOrSDCardFromDeviceId(devIdsInludeBomOrSDCard);
        }    
    }   
    
    public static void calculatePercentOfExecutedContractsOnBomOrSDCardFromAppId(Set<Id> appIdsToCalculatePercentageOnDevice){
        Set<Id> devIdsInludeBomOrSDCard = new Set<Id>();
        for(DeviceApplicationAssoc__c da : [SELECT Device__c FROM DeviceApplicationAssoc__c WHERE Application__c IN : appIdsToCalculatePercentageOnDevice]){
            devIdsInludeBomOrSDCard.add(da.Device__c);
        }
        
        if(!devIdsInludeBomOrSDCard.isEmpty()){
            calculatePercentOfExecutedContractsOnBomOrSDCardFromDeviceId(devIdsInludeBomOrSDCard);
        }       
    }   

    /*** TEST METHOD ***/
    static testMethod void calculatePercentExecutedContractsOnBomOrSDTest() 
    {
        /*
        Account a; 
        Contact contact;    
        try{
            a = [SELECT Id FROM Account WHERE Id = '0014000000IpuSy'];
            contact = [SELECT Id FROM Contact WHERE AccountId =: a.Id LIMIT 1];
        }
        catch(System.QueryException e){
            a = new Account(Name='Motorola Mobility', Tier__c = '1');
            insert a;
            contact = new Contact(lastName='contact', Account=a);
            insert contact;
        }       
        
        Contract c = new Contract(Name='Contract', AccountId=a.Id); 
        insert c;
        Contract c2 = new Contract(Name='Contract', AccountId=a.Id);
        insert c2;
        
        String s = 'string';
        Blob b = Blob.valueOf(s);
        Attachment att = new Attachment(Name='att.pdf', ParentId = c.Id, Body=b);
        insert att;
                
        List<Application__c> apps = new List<Application__c>{new Application__c(Name='App1', application_type__c = 'Preload', Application_Sub_Type__c='faketype', Account__c=a.Id, Available_For_Use__c=true, Application_Category__c='Test', Description__c='Desc'), new Application__c(Name='App2', application_type__c = 'Preload', Application_Sub_Type__c='faketype', Account__c=a.Id, Available_For_Use__c=true, Application_Category__c='Test', Description__c='Desc'), new Application__c(Name='App3', application_type__c = 'Other', Account__c=a.Id, Available_For_Use__c=true, Application_Category__c='Test', Description__c='Desc')};
        insert apps;        
        
        ContApplAssoc__c conApp2 = new ContApplAssoc__c(Contract__c=c2.Id, Application__c=apps[0].Id, Governing_End_Date__c=false);
        
        ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=apps[0].Id);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=apps[1].Id);
        ContApplAssoc__c ca3 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=apps[2].Id);
        List<ContApplAssoc__c> contApps = new List<ContApplAssoc__c>{ca1, ca2, ca3};        
        
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        List<Device__c> devices = new List<Device__c>{new Device__c(Name='Dev1', SA_Date__c=Date.today()-1), new Device__c(Name='Dev2', SA_Date__c=Date.today()-2), new Device__c(Name='Dev3', SA_Date__c=Date.today()-3)};
        System.runAs(p) {               
            insert devices;
        }       
            
        DeviceApplicationAssoc__c da1 = new DeviceApplicationAssoc__c(Device__c=devices[0].Id, Application__c=apps[0].Id, Include_in_BOM__c = false);
        DeviceApplicationAssoc__c da2 = new DeviceApplicationAssoc__c(Device__c=devices[0].Id, Application__c=apps[1].Id, Include_in_BOM__c = true); 
        DeviceApplicationAssoc__c da3 = new DeviceApplicationAssoc__c(Device__c=devices[2].Id, Application__c=apps[2].Id, Include_in_BOM__c = true);
        List<DeviceApplicationAssoc__c> devApps = new List<DeviceApplicationAssoc__c>{da1, da2, da3};       
                
        Test.startTest();
            system.debug('start test calculatePercentExecutedContractsOnBomOrSDTest');
            
            system.debug('test devapp.trigger insert');
            // test device.trigger insert
            insert devApps;         
            
            system.debug('test contractapplication.trigger insert');
            // test contractapplication.trigger insert
            insert contApps;
            
            system.debug('test deviceapplication.trigger update');
            // test deviceapplication.trigger update
            da1.Include_in_BOM__c = true;
            update da1;
            
            //Device__c checkDeviceValue = [SELECT Id, Percent_BOM_SD_Apps_w_Executed_Contract__c FROM Device__c WHERE Id =: devices[0].Id];            
            //system.assertEquals(0, checkDeviceValue.Percent_BOM_SD_Apps_w_Executed_Contract__c);
            
            system.debug('test contract.trigger update');
            // test contract.trigger update
            c.Contract_Status__c = 'Fully Executed'; // test for contract.trigger
            c.Contract_Phase__c = 'Execution and Processing';
            c.ContractTerm = 24;
            c.Contract_Type__c = 'SDA - Steaming Dist Agreement';
            c.EndDate = Date.Today();
            c.Moto_Signed__c = true;
            c.Partner_Signed__c = true;
            c.SW_Procurement_Owner__c = contact.Id;//'0034000000ao7ng'; // Not Known contact
            c.Legal_Owner__c = contact.Id;//'0034000000ao7ng'; // Not Known contact
            c.Finance_Owner__c = contact.Id;//'0034000000ao7ng'; // Not Known contact
            c.Motorola_Entity__c = 'Motorola Mobility Inc';
            c.Partner_Country_of_Incorporation__c = 'United Kingdom';
            update c;
            
            //system.debug('test delete contApps');
            //delete contApps;
            //system.debug('test delete da1');
            //delete da1;
            
        
        Test.stopTest();
        */
    } 
}