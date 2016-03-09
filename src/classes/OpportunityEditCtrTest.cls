/*******************************************************************************************************
CREATED BY : Neel Desai
CREATED ON : 18/Sep/2013
*******************************************************************************************************/
@isTest(SeeAllData=true)
private class OpportunityEditCtrTest {

    static testMethod void myUnitTest() {
        PriceBook2 pb = [select Id from Pricebook2 where isStandard = true LIMIT 1];
        String stdPriceBookId = pb.Id;

        Product2 p1 = new Product2(Name='Test Product 1', isActive=true, business_unit__c = 'Mobile Devices');
        insert p1;
        Product2 p2 = new Product2(Name='Test Product 2', isActive=true, business_unit__c = 'Companion Products');
        insert p2;

        PricebookEntry pbe1 = new PricebookEntry(Pricebook2Id=stdPriceBookId, Product2Id=p1.Id, UnitPrice=100,
            currencyIsoCode = 'USD', isActive=true);
        insert pbe1;
        PricebookEntry pbe2 = new PricebookEntry(Pricebook2Id=stdPriceBookId, Product2Id=p2.Id, UnitPrice=200,
            currencyIsoCode = 'USD', isActive=true);
        insert pbe2;

        //create dummy accounts
        Account acc1 = new Account(Name = 'Test Acc 1', Allow_Opportunities__c = false);
        insert acc1;
        Account acc2 = new Account(Name = 'Test Acc 2', Allow_Opportunities__c = true);
        insert acc2;

        // Create a product bundle with 2 lines
        Product_Bundle__c pbundle1 = new Product_Bundle__c(name = ' Test Bundle - 2 Products', type__c = 'Music');
        insert pbundle1;

        Product_Bundle_Line__c pbl1 = new Product_Bundle_Line__c(product_bundle__c = pbundle1.id,
            product__c = p1.id, quantity__c = 2);
        insert pbl1;

        Product_Bundle_Line__c pbl2 = new Product_Bundle_Line__c(product_bundle__c = pbundle1.id,
            product__c = p2.id, quantity__c = 4);
        insert pbl2;

        // Create a product bundle with one line
        Product_Bundle__c pbundle2 = new Product_Bundle__c(name = 'Test Bundle - No Products', type__c = 'Music');
        insert pbundle2;

        Product_Bundle_Line__c pbl3 = new Product_Bundle_Line__c(product_bundle__c = pbundle2.id,
            product__c = p1.id, quantity__c = 4);
        insert pbl3;

        Opportunity opp1 = new Opportunity();
        ApexPages.StandardController sc1 = new ApexPages.StandardController(opp1);

        //set page
        PageReference pageRef1 = Page.OpportunityEdit;
        pageRef1.getParameters().put('accid', acc1.Id); //for this account, creating opportunity is not allowed
        Test.setCurrentPage(pageRef1);
        //controller
        OpportunityEditCtr con1 = new OpportunityEditCtr(sc1);

        con1.cancel();

        //////====================================================================================

        PageReference pageRef2 = Page.OpportunityEdit;
        pageRef2.getParameters().put('accid', acc2.Id); //creating opportunity is allowed on this account
        Test.setCurrentPage(pageRef2);
        ApexPages.StandardController sc2 =new ApexPages.StandardController(opp1);
        OpportunityEditCtr con2 = new OpportunityEditCtr(sc2);

        con2.opp.StageName = '5. Active Negotiation';
        con2.newStage = '5. Active Negotiation';
        con2.stageChange();

        con2.opp.StageName = '8. Closed Lost';
        con2.newStage = '8. Closed Lost';
        con2.stageChange();

        con2.opp.Name = 'Test1';
        con2.opp.AccountId = acc2.Id;
        con2.opp.CloseDate = Date.today();
        con2.opp.Quarter__c = 'Q1';
        con2.opp.Year__c = '2014';
        con2.opp.NextStep = 'test';
        con2.opp.Next_Milestone_Date__c = Date.today();
        con2.opp.Description = 'test';

        con2.opp.ForecastCategoryName = 'Pipeline';
        con2.saveAndAddProduct();

        con2.opp.ForecastCategoryName = 'Omitted';
        con2.saveAndAddProduct();

        //////====================================================================================

        Opportunity opp3 = new Opportunity(Name='Test Opp 3', AccountId=acc2.Id, CloseDate=Date.today(),
                                           Description='Testing', ForecastCategoryName='Pipeline', NextStep='Test',
                                           StageName='1. Prospecting', Next_Milestone_Date__c=Date.today(),
                                           Quarter__c='Q1', Year__c='2014');
        insert opp3;

        OpportunityLineItem oli1 = new OpportunityLineItem(PriceBookEntryId=pbe1.Id, OpportunityId=opp3.Id, Quantity=1, TotalPrice=100, ServiceDate=Date.newInstance(2014, 1, 1));
        insert oli1;
        OpportunityLineItem oli2 = new OpportunityLineItem(PriceBookEntryId=pbe2.Id, OpportunityId=opp3.Id, Quantity=1, TotalPrice=200, ServiceDate=Date.newInstance(2014, 1, 1), Product_Forecast_Category__c='Commit');
        insert oli2;

        PageReference pageRef3 = Page.OpportunityEdit;
        pageRef3.getParameters().put('id', opp3.Id);
        Test.setCurrentPage(pageRef3);
        ApexPages.StandardController sc3 =new ApexPages.StandardController(opp3);
        OpportunityEditCtr con3 = new OpportunityEditCtr(sc3);

        con3.opp.StageName = '';
        con3.newStage = '';
        con3.stageChange();

        con3.opp.StageName = '2. Presenting Device';
        con3.newStage = '2. Presenting Device';
        con3.stageChange();
        con3.opp.NextStep = 'Test';
        con3.opp.Next_Milestone_Date__c = Date.today();
        con3.save();

        con3.opp.Quarter__c = 'Q2';
        con3.save();

        con3.opp.StageName = '8. Closed Lost';
        con3.newStage = '8. Closed Lost';
        con3.stageChange();

        con3.opp.NextStep = 'Test';
        con3.opp.Next_Milestone_Date__c = Date.today();

        con3.opp.ForecastCategoryName = 'Pipeline';
        con3.save();

        con3.opp.ForecastCategoryName = 'Closed';
        con3.save();

        con3.opp.ForecastCategoryName = 'Omitted';
        con3.save();

        con3.cancel();

        //////====================================================================================

        Opportunity opp4 = new Opportunity(Name='Test Opp 4', AccountId=acc2.Id, CloseDate=Date.today(),
                                           Description='Testing', ForecastCategoryName='Omitted', NextStep='Test',
                                           StageName='8. Closed Lost', Next_Milestone_Date__c=Date.today(),
                                           Quarter__c='Q1', Year__c='2014');
        insert opp4;

        PageReference pageRef4 = Page.OpportunityEdit;
        pageRef4.getParameters().put('id', opp4.Id);
        Test.setCurrentPage(pageRef4);
        ApexPages.StandardController sc4 =new ApexPages.StandardController(opp4);
        OpportunityEditCtr con4 = new OpportunityEditCtr(sc4);

        con4.newStage = '';
        con4.stageChange();

        con4.opp.StageName = '7. Closed Won';
        con4.newStage = '7. Closed Won';
        con4.stageChange();

        con4.opp.ForecastCategoryName = 'Pipeline';
        con4.save();

        con4.opp.ForecastCategoryName = 'Closed';
        con4.save();

        con4.opp.StageName = '8. Closed Lost';
        con4.newStage = '8. Closed Lost';
        con4.stageChange();
        con4.opp.ForecastCategoryName = 'Omitted';
        con4.save();

        acc2.Type = 'Prospect';
        update acc2;

        con4.opp.StageName = '7. Closed Won';
        con4.newStage = '7. Closed Won';
        con4.stageChange();

        //set page
        PageReference pageRef5 = Page.OpportunityEdit;
        pageRef5.getParameters().put('clone', opp3.Id);
        pageRef5.getParameters().put('cloneli', 'true');
        Test.setCurrentPage(pageRef5);
        //controller
        ApexPages.StandardController sc5 = new ApexPages.StandardController(opp3);
        OpportunityEditCtr con5 = new OpportunityEditCtr(sc5);

        con5.opp.NextStep = 'Test1';
        con5.opp.Next_Milestone_Date__c = Date.today();
        con5.opp.Id = null;
        con5.cloneSave();

        //set page
        PageReference pageRef6 = Page.OpportunityEdit;
        pageRef6.getParameters().put('clone', opp3.Id);
        Test.setCurrentPage(pageRef6);
        //controller
        ApexPages.StandardController sc6 = new ApexPages.StandardController(opp3);
        OpportunityEditCtr con6 = new OpportunityEditCtr(sc6);

        con6.opp.NextStep = 'Test2';
        con6.opp.Next_Milestone_Date__c = Date.today();
        con6.opp.Id = null;
        con6.cloneSave();

        //////====================================================================================

        // Product bundle related test cases
        Opportunity opp7 = new Opportunity(Name='Test Opp 7', AccountId=acc2.Id, CloseDate=Date.today(),
                               Description='Testing', ForecastCategoryName='Pipeline', NextStep='Test',
                               StageName='1. Prospecting', Next_Milestone_Date__c=Date.today(),
                               Quarter__c='Q2', Year__c='2014', currencyIsoCode = 'USD');
        insert opp7;

        //, Pricebook2Id = stdPriceBookId
        PageReference pageRef7 = Page.OpportunityEdit;
        pageRef7.getParameters().put('accid', acc2.Id); //creating opportunity is allowed on this account
        Test.setCurrentPage(pageRef7);
        ApexPages.StandardController sc7 = new ApexPages.StandardController(opp7);
        OpportunityEditCtr con7 = new OpportunityEditCtr(sc7);

        // After the save, the Type value gets changed to bundle
        opp7.Type = 'Stand Alone (No Bunlde)';
        opp7.Product_Bundle__c = pbundle1.id;
        opp7.Product_Bundle_Quantity__c = 2000;
        con7.save();

        List<OpportunityLineItem> myOliList = [select id from OpportunityLineItem where OpportunityId = :opp7.id];
        system.assertEquals(myOliList.size(), 2);

        // call the constructor to reset oppCurr value
        sc7 = new ApexPages.StandardController(opp7);
        con7 = new OpportunityEditCtr(sc7);
        opp7.Product_Bundle_Quantity__c = 3000;
        con7.save();

        // call the constructor to reset oppCurr value
        sc7 = new ApexPages.StandardController(opp7);
        con7 = new OpportunityEditCtr(sc7);

        // Changing product bundle will delete prior bundle's lines and add new ones.
        // The new bundle has only one line
        opp7.Product_Bundle__c = pbundle2.id;
        con7.save();

        myOliList = [select id from OpportunityLineItem where OpportunityId = :opp7.id];
        //system.assertEquals(myOliList.size(), 2);

        //////====================================================================================

        // Product bundle related test cases
        Opportunity opp8 = new Opportunity(Name='Test Opp 7', AccountId=acc2.Id, CloseDate=Date.today(),
                               Description='Testing', ForecastCategoryName='Pipeline', NextStep='Test',
                               StageName='1. Prospecting', Next_Milestone_Date__c=Date.today(),
                               Quarter__c='Q2', Year__c='2014', currencyIsoCode = 'USD',
                               Type = 'Stand Alone (No Bunlde)');
        insert opp8;

        //, Pricebook2Id = stdPriceBookId
        PageReference pageRef8 = Page.OpportunityEdit;
        pageRef8.getParameters().put('accid', acc2.Id); //creating opportunity is allowed on this account
        Test.setCurrentPage(pageRef8);
        ApexPages.StandardController sc8 = new ApexPages.StandardController(opp7);
        OpportunityEditCtr con8 = new OpportunityEditCtr(sc7);

        // Test: Select a product bundle validation rule
        opp8.Type = 'Bundle';
        opp8.Product_Bundle__c = null;
        con8.save();

        // Test: Product bundle quantity is required validation rule
        opp8.Type = 'Bundle';
        opp8.Product_Bundle__c = pbundle1.Id;
        con8.save();

        // Just for the sake of code coverage
        con8.resetAlertFields();

    }
}