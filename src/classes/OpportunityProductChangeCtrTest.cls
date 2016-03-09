/********************************************************************************************************
Test Class For: OpportunityProductChangeCtr & OpportunityProductChangeBatch
********************************************************************************************************/
@isTest(SeeAllData=true) // this is required only to get Standard PriceBook record (no actual data is used)
private class OpportunityProductChangeCtrTest 
{
    @isTest static void myUnitTest() 
    {
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User admin = [SELECT Id FROM User WHERE ProfileId = :prof.Id AND IsActive = true LIMIT 1];
        
        System.runAs(admin)
        {
            String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MML Sales').getRecordTypeId(); //GTM record type
            
            PriceBook2 pb = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1]; //standard price book
            
            Account acc = new Account(Name = 'Test account', Allow_Opportunities__c = true);
            insert acc;
            
            Product2 p1 = new Product2(Name = 'Test Product 1', isActive = true);
            insert p1;
            
            PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = p1.Id, UnitPrice = 100, isActive = true);
            insert pbe1;
            
            Product2 p2 = new Product2(Name = 'Test Product 2', isActive = true);
            insert p2;
            
            PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = p2.Id, UnitPrice = 200, isActive = true);
            // do not insert pricebook entry for product 2 now
                            
            Opportunity opp = new Opportunity(Name = 'Test opportunity', RecordTypeId = recordTypeId, AccountId = acc.Id, CloseDate = Date.today(), StageName = '1. Prospecting', NextStep = 'Test', Next_Milestone_Date__c = Date.today());
            insert opp;
            
            OpportunityLineItem oli = new OpportunityLineItem(PriceBookEntryId = pbe1.Id, OpportunityId = opp.Id, Quantity = 10, TotalPrice = 1000);
            insert oli;
            
            opp = [SELECT Opportunity_Number__c, StageName, ForecastCategoryName FROM Opportunity WHERE Id = :opp.Id];
            oli = [SELECT Opportunity_Line_Number__c, Quantity, Product_Forecast_Category__c FROM OpportunityLineItem WHERE OpportunityId = :opp.Id LIMIT 1];
            
            
            Opportunity_Snapshot__c snap = new Opportunity_Snapshot__c(Account__c = acc.Id, 
                                                                       Opportunity_Number__c = opp.Opportunity_Number__c, 
                                                                       Opportunity_Line_Number__c = oli.Opportunity_Line_Number__c, 
                                                                       Quantity__c = oli.Quantity, 
                                                                       Stage__c = opp.StageName, 
                                                                       Forecast_Category__c = opp.ForecastCategoryName, 
                                                                       Product_Forecast_Category__c = oli.Product_Forecast_Category__c,
                                                                       WoW_Flag__c = 'New',
                                                                       Snapshot_Date__c = Date.today());
            insert snap;
            
            Test.startTest();
            
            PageReference pageRef = Page.OpportunityProductChange;
            Test.setCurrentPage(pageRef);
            
            OpportunityProductChangeCtr ctr = new OpportunityProductChangeCtr();
            
            ctr.change(); // nothing to do message
            
            ctr.lineItemIds = String.valueOf(oli.Id) + ',';
            ctr.change(); // line terminated message
            
            ctr.lineItemIds = String.valueOf(oli.Id);
            ctr.change(); // input new product name message
            
            ctr.lineItemIds = String.valueOf(oli.Id);
            ctr.productName = p2.Name;
            ctr.change(); // no pricebook entry found message
            
            insert pbe2; // insert pricebook entry for product 2
            
            ctr.lineItemIds = String.valueOf(oli.Id) + '\r\n' + 'Test';
            ctr.productName = p2.Name;
            ctr.change(); // actual change. this will also call batch class.
            
            oli = [SELECT Opportunity_Line_Number__c, Quantity, Product_Forecast_Category__c FROM OpportunityLineItem WHERE OpportunityId = :opp.Id LIMIT 1]; // get updated line
            
            ctr.lineItemIds = oli.Opportunity_Line_Number__c + '\r\n' + 'Test';
            ctr.idType = 'Auto Number';
            ctr.productName = p2.Name;
            ctr.change(); // to test Auto Number, Invalid ID and no change required message
            
            Test.stopTest();
        }
    }
}