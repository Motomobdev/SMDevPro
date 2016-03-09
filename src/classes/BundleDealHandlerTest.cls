@isTest (SeeAllData=true)
private class BundleDealHandlerTest {
         
    static Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];


    static testMethod void testBD() {

        Test.startTest();
        Account testAcct = createAccount();

        Opportunity testOpp = createOpp(testAcct);
        Quote testQot = createQuote(testOpp);

        Product2 p2 = createProduct('Test');
        Product2 p = createProduct('Test2');
        Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true and isActive = true limit 1];

        PricebookEntry pe = createPricebooKEntry(pbook, p);

        QuoteLineItem qli3 = createQuoteLineItem(testQot, p2,pe);
        QuoteLineItem qli2 = createQuoteLineItem(testQot, p2,pe);
        QuoteLineItem qli4 = createQuoteLineItem(testQot, p2,pe);

        Quote qot2 = createQuote(testOpp);
        testQot.Name = 'tested update';
        testQot.ParentQuote__c = qot2.Id;
        testQot.HasStoplight__c = true;
        testQot.HasSummary__c = true;
        update testQot;
        BundleDealHandler.aggregateFields( qli2,  qli3);
        BundleDealHandler.resetFields(  qli4);

        totalColItem tci = new totalColItem();


        Test.stopTest();


    }

    public static Pricebook2 createStPb(){
        Pricebook2 spb = new Pricebook2();
        //spb.IsStandard = true;
        spb.Name = 'Test';
        spb.IsActive = true;
        insert spb;
        return spb;
    }

    public static Pricebook2 createPricebook()
    {
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = 'Agate Pricebook';
        insert pb2;
        return pb2;
    }

    public static Account createAccount(){
        Account act = new Account();
        act.Name = 'Test Lev Account';
        act.Type = 'Prospect';
        act.Account_Subtype__c = 'Retailer';
        act.Country__c = 'US';
        act.Sub_Region__c = 'North America';
        act.Region__c = 'North America';
        insert act;
        return act;
    }
    
    public static Opportunity createOpp(Account act){
            Opportunity oppo = new Opportunity();
            oppo.Name = 'Test Lev Opp';
            oppo.stageName = 'New';
            oppo.closeDate = System.today();
            oppo.Account = act;
            oppo.Year__c = '2014';
            oppo.Quarter__c = 'Q3';
            Pricebook2 spb = createStPb();
            oppo.Pricebook2Id = standardPb.Id;
            insert oppo;
            return oppo;
    }
    public static Quote createQuote(Opportunity opp){
        Quote qot = new Quote();
        qot.Name = 'Test Lev Quote';
        qot.OpportunityID = opp.Id;
        qot.Deal_Review_Date__c = System.today();
        Pricebook2 spb = createStPb();
        qot.Pricebook2Id = standardPb.Id;
        insert qot;
        return qot;
    }

    public static Product2 createProduct(string name)
    {
        Product2 p = new Product2();
        p.Name = name;
        insert p;
        return p;
    }
    public static PricebookEntry createPricebookEntry(Pricebook2 pb, Product2 pr)
    {
        PricebookEntry pe = new PricebookEntry();
        pe.UnitPrice = 50;
        pe.Pricebook2Id = pb.Id;
        pe.Product2Id = pr.Id;
        pe.IsActive = true;
        insert pe;
        return pe;
    }
    public static QuoteLineItem createQuoteLineItem(Quote q, Product2 p, PricebookEntry pe){
        QuoteLineItem qot = new QuoteLineItem();
        qot.quoteId = q.Id;
        qot.PricebooKEntryId = pe.Id;
        qot.Quantity = 5;
        qot.UnitPrice = 50;
        qot.Product2Id = p.Id;
        qot.Quarter__c = 'Q4';
        qot.Year__C = '2014';
        qot.Units__c = 1111;
        qot.MinimumCommitQuantity__c = 1111;
        qot.InvoicePrice__c = 10;
        qot.SDF__c = 10;
        qot.iMDF__c = 10;
        qot.COOP__c = 10;
        qot.MDF__c = 10;
        qot.SVM__c = 10;
        qot.IPP__c = 10;
        qot.National_Retail__c = 10;
        qot.CSAT__c = 10;
        qot.QP__c = 10;
        qot.TC__c = 10;
        qot.ILW__c = 10;
        qot.TDF__c = 10;
        qot.Fees__c = 10;
        qot.Negotiation_Buffer__c = 10;
        qot.MCPU__c = 10;
        qot.AP__c = 10;
        qot.motoagents__c = 10;

        insert qot;
        return qot;
    }
}