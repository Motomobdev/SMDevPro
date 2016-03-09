@isTest
private class OpportunityMethodsTest 
{
    //// Following test method added by Neel on 07-Nov-2013 //// 
    static testMethod void createZuoraOpportunityTest()
    {
        String recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Software Royalty').getRecordTypeId();
        
        Account ac1 = new Account(Name = 'Test Account 1', Allow_Opportunities__c = false);
        insert ac1;
        
        Contract ct1 = new Contract(Name = 'Test Contract 1', AccountId = ac1.Id);
        insert ct1;
        Contract ct2 = new Contract(Name = 'Test Contract 2', AccountId = ac1.Id);
        insert ct2;
        
        Opportunity op1 = new Opportunity(RecordTypeId = recordTypeId,
                                          Name = ct1.Name,
                                          AccountId = ct1.AccountId,
                                          Contract__c = ct1.Id,
                                          StageName = '7. Closed Won',
                                          CloseDate = Date.today().addMonths(3));
        insert op1;
        
        Test.startTest();
        
        List<Contract> ctList = new List<Contract>();
        ctList.add(ct1);
        ctList.add(ct2);
        
        OpportunityMethods.createZuoraOpportunity(ctList);
        
        Test.stopTest();
        
        Account[] acList = [SELECT Name, Allow_Opportunities__c FROM Account];
        Opportunity[] opList = [SELECT RecordTypeId, Name, AccountId, Contract__c, StageName, CloseDate FROM Opportunity];
        
        system.assertEquals(acList[0].Allow_Opportunities__c, true); // method should have set this flag to true before inserting opportunity
        
        system.assertEquals(opList.size(), 2); // count must be 2 (1 created manually, 1 created by method). Method should skip existing opportunity
        
        for(Opportunity op : opList)
        {
            if(op.Id != op1.Id) // opportunity created by method (for Contract 2 i.e. ct2)
            {
                system.assertEquals(op.RecordTypeId, recordTypeId); // record type should be Software Royalty
                system.assertEquals(op.Name, ct2.Name); // opportunity name should be same as contract name
                system.assertEquals(op.AccountId, ct2.AccountId); // opportunity account should be same as contract account
                system.assertEquals(op.Contract__c, ct2.Id); // opportunity contract should point to contract
                system.assertEquals(op.StageName, '7. Closed Won'); // stage should be initila stage
                system.assertEquals(op.CloseDate, Date.today().addMonths(3)); // close date should be today + 3 months
            }
        }
        
    }
}