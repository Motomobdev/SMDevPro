/**
 * @author: Cuauhtemoc Munoz
 * @email:  cmunoz@levementum.com
 * @date:   Nov/07/14
 * @description: Test Utility class used in test classes
 * @todo:   Need to create object lists not just single ones. 
 *          We need to return a collection and insert objects
 *          rather than individual objects.
 */
public class TestUtilities 
{
    public static Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];
    
    public static Account createAccount()
    {
        Account act = null;
        try
        {
            act = new Account();
            act.Name = 'Test Lev Account';
            insert act;

        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return act;
    }
    
    public static Pricebook2 createPricebook()
    {
        Pricebook2 pb2 = null;
        try
        {
            pb2 = new Pricebook2();
            pb2.Name = 'Agate Pricebook';
            insert pb2;
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return pb2;
    }
    
    public static PricebookEntry createPricebookEntry(Pricebook2 pb, Product2 pr)
    {
        PricebookEntry pe = null;
        try
        {
            pe = new PricebookEntry();
            pe.UnitPrice = 50;
            pe.Pricebook2Id = standardPb.Id;
            pe.Product2Id = pr.Id;
            pe.isActive = true;
            insert pe;
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return pe;
    }
    
    public static Opportunity createOpp(Account act)
    {
        Opportunity oppo = null;
        try
        {
            oppo = new Opportunity();
            oppo.Name = 'Test Lev Opp';
            oppo.stageName = 'New';
            oppo.closeDate = System.today();
            oppo.Account = act;
            oppo.Year__c = '2014';
            oppo.Quarter__c = 'Q3';
            oppo.Pricebook2Id = standardPb.Id;
            insert oppo;
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return oppo;
    }
    
    public static Product2 createProduct()
    {
        Product2 p = null;
        try
        {
            p = new Product2();
            p.Name = 'Agate';
            insert p;
        }catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return p;
    }
    
    public static QuoteLineItem createQuoteLineItem(Quote q, Product2 p, PricebookEntry pe)
    {
        QuoteLineItem qot = null;
        try
        {
            qot = new QuoteLineItem();
            qot.quoteId = q.Id;
            qot.PricebooKEntryId = pe.Id;
            qot.Quantity = 5;
            qot.UnitPrice = 50;
            qot.Product2Id = p.Id;
            qot.Quarter__c = 'Q4';
            qot.Year__C = '2014';
            qot.Deal_Type__c = 'Proposal';
            qot.Approval_Status__c  = 'Pending';
            insert qot;

            qot = new QuoteLineItem();
            qot.quoteId = q.Id;
            qot.PricebooKEntryId = pe.Id;
            qot.Quantity = 5;
            qot.UnitPrice = 50;
            qot.Product2Id = p.Id;
            qot.Quarter__c = 'Q4';
            qot.Year__C = '2014';
            qot.Deal_Type__c = 'Plan';
            qot.Approval_Status__c  = 'Pending';
            insert qot;

        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return qot;
    }

    public static Quote createQuote(Opportunity opp)
    {
        Quote qot = null;
        try
        {
            qot = new Quote();
            qot.Name = 'Test Lev Quote';
            qot.OpportunityID = opp.Id;
            qot.Deal_Review_Date__c = System.today();
            qot.Pricebook2Id = standardPb.Id;
            insert qot;

        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return qot;
    }
    
    public static User createLevUser()
    {
        User u = null;
        try
        {
          Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
          u = new User(Alias = 'stdlev', Email='standarduser@levementum.com', 
          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
          LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@levementum.com');

        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return u;
    }
}