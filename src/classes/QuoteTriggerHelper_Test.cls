@isTest
public class QuoteTriggerHelper_Test {
    static testmethod void testCopyAcctID(){
        Account acct = new Account();
        acct.RecordTypeId = [select id from recordtype where sobjecttype = 'Account' and developername = 'MD'].Id;
        acct.Name = 'Testing123Test';
        acct.Region__c = 'Global';
        acct.General_Business_Outlook__c = 'teststring';
        acct.General_industry_trends__c = 'teststring';
        acct.Position_In_Market__c = 'teststring';
        acct.Business_Entity_Type__c = 'INC.';
        acct.Decision_Making_Philosophy__c = 'Cenrtalized';
        acct.Key_customers__c = 'teststring';
        acct.Entity_Established_State_Country__c = 'tx/usa';
        acct.Technology_Type__c = 'CDMA';
        acct.Head_Quarter_Location__c = '1234 some street, Dallas, TX 77777';
        insert acct;
        
        Opportunity oppt = new Opportunity();
        oppt.RecordTypeId = [select id from recordtype where sobjecttype = 'Opportunity' and developername = 'MML_Sales'].Id;
        oppt.Name = 'TestOppty1234';
        oppt.AccountId = acct.Id;
        oppt.CloseDate = Date.today().addDays(20);
        oppt.Quarter__c = 'Q1';
        oppt.Year__c = '2014';
        oppt.Type = 'Stand Alone (No Bundle)';
        oppt.StageName = '1. Prospecting';
        oppt.CurrencyIsoCode = 'USD';
        oppt.NextStep = 'teststring';
        oppt.Next_Milestone_Date__c = Date.today().addDays(3);
        oppt.Description = 'teststring';
        insert oppt;
        
        Quote qt = new Quote();
        qt.Name = 'testQuote321';
        qt.Deal_Review_Date__c = date.today().addDays(10);
        qt.OpportunityId = oppt.Id;
        insert qt;
        
        system.assertEquals(qt.Account__c, qt.Opportunity_Account_ID__c);
        
        update qt;
        system.assertEquals(qt.Account__c, qt.Opportunity_Account_ID__c);
    }
}