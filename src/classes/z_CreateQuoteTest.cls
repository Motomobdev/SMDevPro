@isTest
public with sharing class z_CreateQuoteTest {
	
	public static testMethod void testSubscription() {
		// Create the quote object
        Account acc = Z_TestFactory.makeAccount();
        Opportunity opp = Z_TestFactory.makeOpportunity(acc);
    	zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
		ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
		
		z_CreateQuote createQuote = new z_CreateQuote(stdController);
		createQuote.quoteType = 'Subscription';
		createQuote.oppId = opp.Id;
		
		List<selectOption> contracts = createQuote.getcontracts();
		
		//z_CreateQuote.DefaultRecordPlugin defaultPlugin = new z_CreateQuote.DefaultRecordPlugin();
		//defaultPlugin.populateDefaultFieldValue(quote, createQuote);
		
		Boolean validated = createQuote.validate();
		System.assert(validated);
		System.assert(createQuote.nextUrl != null);
		
		createQuote.nextUrl = null;
		createQuote.billAcctId = '234';
		validated = createQuote.validate();
		System.assert(validated);
		System.assert(createQuote.nextUrl != null);
		System.assert(createQuote.nextUrl != null);
		createQuote.opp = opp;
		createQuote.quote = new zqu__Quote__c();
		z_CreateQuote.DefaultRecordPlugin defaultRec = new z_CreateQuote.DefaultRecordPlugin();
		defaultRec.populateDefaultFieldValue(quote, createQuote);
	}
	
	public static testMethod void testAmendment() {
		// Create the quote object
        Account acc = Z_TestFactory.makeAccount();
        Opportunity opp = Z_TestFactory.makeOpportunity(acc);
    	zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
		ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
		
		z_CreateQuote createQuote = new z_CreateQuote(stdController);
		createQuote.quoteType = 'Amendment';
		createQuote.oppId = '123';
		createQuote.billAcctId = '234';

		
		Boolean validated = createQuote.validate();
		System.assert(!validated);
		System.assert(createQuote.nextUrl == null);
		
		createQuote.subId = '345';
		validated = createQuote.validate();
		System.assert(validated);
		System.assert(createQuote.nextUrl != null);
		z_CreateQuote.CancelRecordPlugin cancel = new z_CreateQuote.CancelRecordPlugin();
		cancel.doCancel(quote, createQuote);
	}
	
	public static testMethod void testRenewal() {
		// Create the quote object
        Account acc = Z_TestFactory.makeAccount();
        Opportunity opp = Z_TestFactory.makeOpportunity(acc);
    	zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
		ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
		
		z_CreateQuote createQuote = new z_CreateQuote(stdController);
		createQuote.quoteType = 'Renewal';
		createQuote.oppId = '123';
		createQuote.billAcctId = '234';
		Boolean validated = createQuote.validate();
	
		System.assert(!validated);
		System.assert(createQuote.nextUrl == null);
		
		createQuote.subId = '345';
		validated = createQuote.validate();
		System.assert(validated);
		System.assert(createQuote.nextUrl != null);
		
		
	}
	
	public static testMethod void testGibberish() {
		// Create the quote object
        Account acc = Z_TestFactory.makeAccount();
        Opportunity opp = Z_TestFactory.makeOpportunity(acc);
    	zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
		ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
		
		z_CreateQuote createQuote = new z_CreateQuote(stdController);
		createQuote.quoteType = 'NotAValidType';
		createQuote.oppId = '123';
		Boolean validated = createQuote.validate();
		System.assert(!validated);
		System.assert(createQuote.nextUrl == null);
	}
}