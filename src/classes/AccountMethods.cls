public with sharing class AccountMethods {

    /*
     * Created by: Jesse
     * Creation date: Unknown
     * Description: <TO-DO>
     * Change history:
     * Date: 11-Jan-2013 Changed by: Rajesh Krishnaiah
     * Change: Moved the account owner change method to future to avoid too many DML rows error
     * Date: 24-Aug-2012 Changed by: Rajesh Krishnaiah
     * Change: Added Approval_Status__c != 'Approved' filter so
     *   we don't update approved device app records when an account owner changes.
     * Date: 20-Aug-2012 Changed by: Rajesh Krishnaiah
     * Change: The updatedApplicationsAndDevAppsAfterAccountOwnerChange method was generating
     *         too many script statements error. Optimized the code to use lists and maps.
     * Date: 03/Aug/2012 Changed By: Neel Desai
     * Change: updatedApplicationsAndDevAppsAfterAccountOwnerChange method was generating 
     */
    public static void collectContractInformationIntoTextFieldForLRBSlides(List<Contract> newContracts){
        List<Id> accountIds = new List<Id>();
        
        for(Contract c : newContracts){
            accountIds.add(c.AccountId);
        }
        
        List<Account> accountsWithContracts = [SELECT Id, All_Contracts_List__c, 
                                               (SELECT Name, Contract_Type__c, Contract_Status__c 
                                                FROM Contracts 
                                                WHERE Contract_Status__c != 'Dropped' 
                                                AND Contract_Type__c != 'NDA - Non-Disclosure Agreement' 
                                                AND Contract_Type__c != 'PUM - Prototype Unit Agreement' 
                                                AND Contract_Type__c != 'SEA - Software Evaluation Agreement' 
                                                AND Contract_Type__c != 'MNDA - Multiparty NDA' 
                                                AND Contract_Type__c != 'TLA - Tools Licensing Agreement') 
                                               FROM Account WHERE Id IN : accountIds];
        
        for(Account a : accountsWithContracts){
            String contractList;
            for(Contract c : a.Contracts){
                if(contractList == null){
                    contractList = c.Name + ' - ' + c.Contract_Type__c + ' - ' + c.Contract_Status__c + '\n';
                } else {
                    contractList = contractList + c.Name + ' - ' + c.Contract_Type__c + ' - ' + c.Contract_Status__c + '\n';
                }
            }
            a.All_Contracts_List__c = contractList;
        }
        
        update accountsWithContracts;
    }
    
    public static void updatedApplicationsAndDevAppsAfterAccountOwnerChange(List<Id> accountIdsWithUpdatedOwners){      
        List<Account> accountList = [SELECT Id, OwnerId FROM Account 
                                     WHERE Id IN : accountIdsWithUpdatedOwners];
        /*** Begin update Account Owner on related Applications ***/
        Map<Id, Application__c> appIdMap = 
            new Map<Id, Application__c>([SELECT Id, AcctOwnerApp__c, Account__c 
                                         FROM Application__c 
                                         WHERE Account__c IN :accountIdsWithUpdatedOwners]);   
        List<Application__c> apps = appIdMap.values();
        
        for(Integer i=0; i<apps.size(); i++){
            for(Integer k=0; k<accountList.size(); k++){
                if(apps[i].Account__c == accountList[k].Id){
                    apps[i].AcctOwnerApp__c = accountList[k].OwnerId;
                }
            }
        }
        
        /*** End update Account Owner on related Applications ***/
        
        /*** Begin update Account Owner on related DevApps ***/
        
        /* BEGIN: Fix for Ticket #63789 | Neel Desai | 3/Sep/2012 */

        Set<Id> appids = new Set<Id>();
        
        Map<Id, DeviceApplicationAssoc__c> devAppIdMap = new Map<Id, DeviceApplicationAssoc__c>();  
        
        for(Id appid : appIdMap.keySet())
        {
            appids.add(appid);
            
            if(appids.size() == 25)
            {
                List<DeviceApplicationAssoc__c> tempList = [SELECT  Id, AcctOwner__c, Application__c, Approval_Status__c
                                                            FROM    DeviceApplicationAssoc__c 
                                                            WHERE   Application__c IN :appids AND 
                                                                    Approval_Status__c != 'Approved'];
                                                    
                for(DeviceApplicationAssoc__c temp : tempList)
                {
                    devAppIdMap.put(temp.Id, temp);
                }
                
                appids.clear();
            }
        } 

        if(appids.size() > 0)
        {
            List<DeviceApplicationAssoc__c> tempList = [SELECT  Id, AcctOwner__c, Application__c, Approval_Status__c
                                                        FROM    DeviceApplicationAssoc__c 
                                                        WHERE   Application__c IN :appids AND 
                                                                Approval_Status__c != 'Approved'];
                                                    
            for(DeviceApplicationAssoc__c temp : tempList)
            {
                devAppIdMap.put(temp.Id, temp);
            }
        }        

        /* END: Fix for Ticket #63789 | Neel Desai | 3/Sep/2012 */

        List<DeviceApplicationAssoc__c> devApps = devAppIdMap.values();
        
        // Rajesh -- Added on 20-Aug-2012 -- Start
        Map<Id, List<DeviceApplicationAssoc__c>> appIdDevAppsMap =
            new Map<Id, List<DeviceApplicationAssoc__c>>();
        
        for(DeviceApplicationAssoc__c devApp : devApps){
            List<DeviceApplicationAssoc__c> localDevApps = 
                appIdDevAppsMap.get(devApp.Application__c);

            if (localDevApps == null) {
                localDevApps = new List<DeviceApplicationAssoc__c>();
                localDevApps.add(devApp);
            } else
                localDevApps.add(devApp);
            
            appIdDevAppsMap.put(devApp.Application__c, localDevApps);
        }
        
        for (Application__c app : apps) {
            List<DeviceApplicationAssoc__c> localDevApps = appIdDevAppsMap.get(app.id);
            if (localDevApps != null) {
                for (DeviceApplicationAssoc__c devApp : localDevApps)
                    devApp.AcctOwner__c = app.AcctOwnerApp__c;
            }
        }

        // Rajesh -- Added on 20-Aug-2012 -- End
        
        /* Commented by Rajesh
        for(Integer i=0; i<devApps.size(); i++){
            for(Integer k=0; k<apps.size(); k++){
                if(devApps[i].Application__c == apps[k].Id){
                    devApps[i].AcctOwner__c = apps[k].AcctOwnerApp__c;
                }
            }
        }
        */
        /*** End update Account Owner on related DevApps ***/
        try
        {
            update apps;
            update devApps;
        } 
        catch(System.DMLException e)
        {
            sendCustomEmail(accountIdsWithUpdatedOwners);
        }
        catch(Exception ex) {}
    }
    
    public static void sendCustomEmail(List<Id> accountIdsWithUpdatedOwners)
    {
            String body = 'An account owner update could not be completed by user. ' +
                'These are the accounts that were updated: ' + accountIdsWithUpdatedOwners;
    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
            String[] toAddresses = new String[] {'sfdc@motorola.com','brian.chiang@motorola.com'};
            mail.setToAddresses(toAddresses);
            
            mail.setSubject('SALESFORCE: Could not complete owner update');
            
            // Set to True if you want to BCC yourself on the email.    
            mail.setBccSender(false);
            
            // Optionally append the salesforce.com email signature to the email.  
            // The email address of the user executing the Apex Code will be used.  
            mail.setUseSignature(false);
            
            // Specify the text content of the email.  
            mail.setPlainTextBody(body);
    
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
    }
    
    public static testmethod void collectContractInformationIntoTextFieldForLRBSlidesTest(){
        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        
        Contract c1 = new Contract(Name='c1', AccountId=a.Id, StartDate=Date.today(), Contract_Type__c='faketype');
        Contract c2 = new Contract(Name='c2', AccountId=a.Id, StartDate=Date.today(), Contract_Type__c='faketype');
        
        Test.startTest();
            insert new List<Contract> {c1, c2};
            c2.Contract_Status__c = 'new status';
            update c2;
        Test.stopTest();
    }
    
    public static testmethod void updatedApplicationsAndDevAppsAfterAccountOwnerChangeTest(){
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Account a = new Account(Name='Account1', ownerId = p.Id);
        insert a;
        
        Device__c dev = new Device__c(Name='Dev1');
        insert dev;
        
        List<Application__c> appList = new List<Application__c>();
        List<DeviceApplicationAssoc__c> devAppList = new List<DeviceApplicationAssoc__c>();

        for(Integer i=0; i<26; i++)
        {
            Application__c app = new Application__c(Name='App ' + i, application_type__c = 'Preload', 
                                                    Royalty_Low__c=5, Royalty_High__c=25, Account__c=a.Id, 
                                                    Application_Sub_Type__c='faketype', 
                                                    Application_Category__c='fakeCategory', 
                                                    Description__c='fakeDescription', 
                                                    Available_For_Use__c=true);
            appList.add(app);
        }
        
        insert appList;
        
        for(Integer i=0; i<26; i++)
        {
            DeviceApplicationAssoc__c da = new DeviceApplicationAssoc__c(Device__c=dev.Id, Application__c=appList[i].Id);
            devAppList.add(da);
        }
        
        insert devAppList;
        
        Test.startTest();
            a.OwnerId = '005400000012v9N'; // moto partner management
            update a;
            sendCustomEmail(new List<Id> {a.Id});
        Test.stopTest();
    }
}