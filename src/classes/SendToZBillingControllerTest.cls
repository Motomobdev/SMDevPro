@isTest
private class SendToZBillingControllerTest {

        static testMethod void testComponent() {
        	zqu__Quote__c testQuote = makeQuote();
        	
            testQuote.zqu__ZuoraAccountID__c = '12345';
            
            update testQuote;
            
            Test.startTest();

	        // Test Controller
	        ApexPages.Standardcontroller stdcon = new ApexPages.Standardcontroller(testQuote);        
	        SendToZBillingController qcon = new SendToZBillingController(stdcon);
            
            qcon.send();
            PageReference newRef = qcon.goToQuote();
            
        	Test.stopTest();      
        	
        }
        
        /**
         * Prepare a quote
         */
        private static zqu__Quote__c makeQuote() {
                
                Account acc = Z_TestFactory.makeAccount();
                Contact con = Z_TestFactory.makeContact(acc);
                Opportunity opp = Z_TestFactory.makeOpportunity(acc);
                
                zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
                
                quote.zqu__StartDate__c = date.today();
                quote.zqu__SoldToContact__c = con.Id;
                quote.zqu__BillToContact__c = con.Id;
                quote.zqu__Currency__c = 'USD';
                
                update quote;
                return quote;
        }
}