@isTest(SeeAllData = true) //this is required only to get Standard PriceBook record (no actual data is used)
private class OpportunitySnapshotScriptTest 
{
	@isTest static void unitTest() 
	{
        String recordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('MML Sales').getRecordTypeId(); //GTM record type
        
        PriceBook2 pb = [SELECT Id FROM Pricebook2 WHERE isStandard = true LIMIT 1]; //standard price book
        
        Account acc = new Account(Name = 'Test account', Allow_Opportunities__c = true);
        insert acc;
        
        Product2 p = new Product2(Name = 'Test Product', isActive = true);
        insert p;
        
        PricebookEntry pbe = new PricebookEntry(Pricebook2Id = pb.Id, Product2Id = p.Id, UnitPrice = 100, isActive = true);
        insert pbe;
        
        Opportunity opp = new Opportunity(Name = 'Test opportunity', RecordTypeId = recordTypeId, AccountId = acc.Id, CloseDate = Date.today(), StageName = '1. Prospecting', NextStep = 'Test', Next_Milestone_Date__c = Date.today());
        insert opp;
        
        List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
        oliList.add(new OpportunityLineItem(PriceBookEntryId = pbe.Id, OpportunityId = opp.Id, Quantity = 1, TotalPrice = 10));
        oliList.add(new OpportunityLineItem(PriceBookEntryId = pbe.Id, OpportunityId = opp.Id, Quantity = 2, TotalPrice = 20));
        oliList.add(new OpportunityLineItem(PriceBookEntryId = pbe.Id, OpportunityId = opp.Id, Quantity = 3, TotalPrice = 30));
        oliList.add(new OpportunityLineItem(PriceBookEntryId = pbe.Id, OpportunityId = opp.Id, Quantity = 4, TotalPrice = 40));
        insert oliList;
        
        Date currSnapDate = Date.today().addYears(1); //future date to make sure test method processes above inserted records instead of actual records from the object
        Date prevSnapDate = currSnapDate.addDays(-7);
        
        opp = [SELECT Opportunity_Number__c, StageName, ForecastCategoryName FROM Opportunity WHERE Id = :opp.Id];
        
        oliList = [SELECT Opportunity_Line_Number__c, Quantity, Product_Forecast_Category__c FROM OpportunityLineItem WHERE OpportunityId = :opp.Id];
        
        List<Opportunity_Snapshot__c> snapList = new List<Opportunity_Snapshot__c>();
        
        for(Integer i = 0; i < oliList.size(); i++)
        {
            /*
            Logic:
            - line 1 & 2 present in previous & current week
            - line 3 present in previous week but not present in current week (ie. line 3 got deleted in current week)
            - line 4 not present in previous week but present in current week (ie. line 4 got added in current week)
            */
            if(i != 3) //previous week won't have 4th line item - simulate new line item
                snapList.add(new Opportunity_Snapshot__c(Account__c = acc.Id, 
                                                         Opportunity_Number__c = opp.Opportunity_Number__c, 
                                                         Opportunity_Line_Number__c = oliList[i].Opportunity_Line_Number__c, 
                                                         Quantity__c = oliList[i].Quantity, 
                                                         Stage__c = opp.StageName, 
                                                         Forecast_Category__c = opp.ForecastCategoryName, 
                                                         Product_Forecast_Category__c = oliList[i].Product_Forecast_Category__c,
                                                         WoW_Flag__c = 'New',
                                                         Snapshot_Date__c = prevSnapDate));
            if(i != 2) //current week won't have 3rd line item - simulate delete of line item
                snapList.add(new Opportunity_Snapshot__c(Account__c = acc.Id, 
                                                         Opportunity_Number__c = opp.Opportunity_Number__c, 
                                                         Opportunity_Line_Number__c = oliList[i].Opportunity_Line_Number__c, 
                                                         Quantity__c = oliList[i].Quantity, 
                                                         Stage__c = opp.StageName, 
                                                         Forecast_Category__c = opp.ForecastCategoryName, 
                                                         Product_Forecast_Category__c = oliList[i].Product_Forecast_Category__c,
                                                         Snapshot_Date__c = currSnapDate));
        }
        
        insert snapList;
        
		Test.startTest();
        
        OpportunitySnapshotScript.SnapshotUpdateScript(); //run script on dummy test records
        
		Test.stopTest();
	}
	
	
}