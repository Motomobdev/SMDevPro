@isTest(SeeAllData=true)
public with sharing class z_QuoteOptionTest {
	
	public static testmethod void testRedirect() {
		Account testAcc = z_TestFactory.makeAccount();
		Contact testCon = z_TestFactory.makeContact(testAcc);
		Opportunity testOpp = z_TestFactory.makeOpportunity(testAcc);
		
		//Fail validate
		z_QuoteOption qOptionFail = new z_QuoteOption(null);
		
		ApexPages.StandardController controller = new ApexPages.StandardController(testOpp);
		z_QuoteOption qOption = new z_QuoteOption(controller);
		
		PageReference prefExistingBilling = qOption.onload();
		
		qOption.testCreateAccounts = false;
		PageReference prefNoBilling = qOption.onload();
		
		System.assert(!prefExistingBilling.getUrl().equals(prefNoBilling.getUrl()));
		
	}
}