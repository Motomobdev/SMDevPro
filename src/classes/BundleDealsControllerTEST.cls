@isTest (SeeAllData=true)
public class BundleDealsControllerTEST {

     static Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];

     @isTest static void test_bundleDeal() {
        User levUser = createLevUser();
        System.runAs(levUser){
             Account testAcct = createAccount();
            System.debug('############### testAcct:' + testAcct); 
            
            Opportunity testOpp = createOpp(testAcct);
            System.debug('############### testOpp:' + testOpp);
            
            Quote testQot = createQuote(testOpp);
            System.debug('############### testQot:' + testQot);


            Account parentAcct = createAccount();

            Product2 p = createProduct('Agate');
            Product2 p2 = createProduct('Test');
            
            Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true and isActive = true limit 1];
            PricebookEntry pe = createPricebooKEntry(pbook, p);
            PricebookEntry pe2 = createPricebooKEntry(pbook, p2);
    
            ApexPages.currentPage().getParameters().put('qId', testQot.Id);
            BundleDealsController bdc = new BundleDealsController();
            BundleDealsController.acctWrapper acr = new BundleDealsController.acctWrapper(testAcct);
            BundleDealsController.acctWrapper acr2 = new BundleDealsController.acctWrapper(parentAcct);
            bdc.mainAccounts = new List<BundleDealsController.acctWrapper>();
            acr.checked = true; //Mark account as selected to exist so the processes can find it in bundle deal.
            acr2.checked = true; //Mark account as selected to exist so the processes can find the parent of the bundle deal.
            bdc.filterAcct = testAcct; //prepare the filters
            //Put the parameter of the accountID in the URL as this is what happens in the interface when you select a parent account.
            PageReference pRef = Page.BundleDeals;
            pRef.getParameters().put('accountID', parentAcct.id);
            Test.setCurrentPage(pRef);


            List<PriceBookEntry> pbes = [select 
            id, 
            product2Id, 
            product2.Name, 
            product2.ProductCode, 
            product2.Project__c, 
            product2.Program__c,
            product2.Family, 
            product2.Business_Unit__c, 
            UnitPrice 
            FROM PriceBookEntry Limit 5];

            System.debug('############### pbes:' + pbes);

            bdc.parentAccountId = parentAcct.id;

            bdc.initPage();
            bdc.searchAccounts();
            bdc.mainAccounts.add(acr2);
            bdc.mainAccounts.add(acr);
            bdc.setParentAccountId();
            bdc.createBundle();
            bdc.createDeal();
            bdc.cancelCreate();
            bdc.addExecutiveNote(testQot.Id); //Add an executive Note

            System.debug('############### bdc.mainAccounts Count:' + bdc.mainAccounts.size());
            System.debug('############### bdc.mainAccounts:' + bdc.mainAccounts);
            System.debug('############### bdc.mainQuery:' + bdc.mainQuery);

        }



     }
     
     
     static testMethod void testPicklistFunctionality(){
     	//All we can do is assert that the picklists have values. Coding dependencies/picklist values would require changes anytime the metadata changed.
     	BundleDealsController bdc = new BundleDealsController();
     	
     	System.assert(bdc.getAccountTypeValues().size() > 0);
     	System.assert(bdc.getAccountSubTypeValues().size() > 0);
     	System.assert(bdc.getAccountRegionValues().size() > 0);
     	System.assert(bdc.getAccountSubRegionValues().size() > 0);
     	System.assert(bdc.getAccountCountryValues().size() > 0);
     }

    public static Account createAccount(){
        Account act = new Account();
        act.Name = 'Test Lev Account ' + Math.random();
        act.Type = 'Prospect';
        act.Account_Subtype__c = 'Retailer';
        act.Country__c = 'US';
        act.Sub_Region__c = 'North America';
        act.Region__c = 'North America';
        act.Active__c = true;
        act.Allow_Opportunities__c = true;
        insert act;
        return act;
    }
  
    public static Pricebook2 createPricebook()
    {
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = 'Agate Pricebook';
        insert pb2;
        return pb2;
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
    
    public static Opportunity createOpp(Account act, Boolean parentOpp){
            Opportunity oppo = new Opportunity();
            oppo.Name = 'Test Lev Opp';
            oppo.stageName = 'New';
            oppo.closeDate = System.today();
            oppo.Account = act;
            oppo.Year__c = '2014';
            oppo.Quarter__c = 'Q3';
            oppo.Pricebook2Id = standardPb.Id;
            insert oppo;
            return oppo;
    }
      public static Opportunity createOpp(Account act){
            Opportunity oppo = new Opportunity();
            oppo.Name = 'Test Lev Opp';
            oppo.stageName = 'New';
            oppo.closeDate = System.today();
            oppo.Account = act;
            oppo.Year__c = '2014';
            oppo.Quarter__c = 'Q3';
            oppo.Pricebook2Id = standardPb.Id;
            insert oppo;
            return oppo;
    }
    
    public static Product2 createProduct(string name)
    {
        Product2 p = new Product2();
        p.Name = name;
        insert p;
        return p;
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

        insert qot;
        return qot;
    }

    public static Quote createQuote(Opportunity opp){
        Quote qot = new Quote();
        qot.Name = 'Test Lev Quote';
        qot.OpportunityID = opp.Id;
        qot.Deal_Review_Date__c = System.today();
        qot.Pricebook2Id = standardPb.Id;
        insert qot;
        return qot;
    }
    
    public static User createLevUser(){
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'stdlev', Email='standarduser@levementum.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@levementum.com');
      return u;
    }
}