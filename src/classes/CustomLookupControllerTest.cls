/**
 * @author:	Cuauhtemoc Munoz
 * @email:	cmunoz@levementum.com
 * @date:	Nov/07/14
 * @description: Provides a test class for a custom look up for products
 *               created on SoftDealClone.page for CustomLookupController.cls
 */
@isTest (SeeAllData=true)
public class CustomLookupControllerTest 
{
	public static TestUtilities tu = new TestUtilities();
	public static testMethod void testestCustomLookup() 
	{
		try
		{
			Test.startTest();
				User user = TestUtilities.createLevUser();
				Product2 prod = TestUtilities.createProduct();
				Account acct = TestUtilities.createAccount();
				Opportunity opp = TestUtilities.createOpp(acct);
				Quote quote = TestUtilities.createQuote(opp);
				Pricebook2 pb = TestUtilities.standardPb;
				PricebookEntry pe = TestUtilities.createPricebookEntry(pb, prod);
				CustomLookupController cl = new CustomLookupController();
				cl.quoteId = quote.Id;
				cl.searchString = '';
				cl.search();
				cl.searchProduct();
				cl.getFormTag();
				cl.getTextBox();
				cl.clearSearch();
			Test.stopTest();
		}
		catch(Exception ex)
		{
			system.debug(ex.getMessage());
		}
	}
}