@isTest
public with sharing class Z_CustomQuoteEdit_TEST {
	
	public static testMethod void testEdit() {
		// Create the quote object
        Account acc = Z_TestFactory.makeAccount();
        Opportunity opp = Z_TestFactory.makeOpportunity(acc);
    	zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
    	
    	// Update quote information
        quote.zqu__Currency__c = 'USD';
        quote.zqu__StartDate__c = Date.today().addDays(1);
        update quote;
        
		Test.startTest();

        ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
        
		Z_CustomQuoteEdit editQuote = new Z_CustomQuoteEdit(stdController);
		
		editQuote.getContracts();
		
		//editQuote.SavePlugin.doUpdate(editQuote.quote, stdController);
		Z_CustomQuoteEdit.SavePlugin savePlugin = new Z_CustomQuoteEdit.SavePlugin();
		PageReference newPage = savePlugin.doUpdate(editQuote.quote, editQuote);
		
		Test.stopTest();
	}
}