@isTest
public class Z_TestFactory {

        /**
         * Insert a test account in the db
         */
        public static Account makeAccount() {
                
                Account testAcc = new Account();
                
                testAcc.Name = 'my test account';
                testAcc.BillingState = 'CA';
                testAcc.ShippingState = 'CA';
                
                insert testAcc;
                return testAcc;
        }
        
        
        /**
         * Insert a test contact associated with an account in the db
         */
        public static Contact makeContact(Account testAcc) {
                
                Contact testContact = new Contact();
                
                testContact.FirstName = 'firstname';
                testContact.LastName = 'lastname';
                testContact.Email = 'email@mail.me';
                
                testContact.AccountId = testAcc.Id;
                
                insert testContact;
                return testContact;
        }
        
        
        /**
         * Insert a test opportunity associated with an account
         */
        public static Opportunity makeOpportunity(Account testAcc) {
                
                Opportunity testOpp = new Opportunity();
                
                testOpp.Name = 'my test opportunity';
                testOpp.StageName = 'Opportunity Identified';
                testOpp.CloseDate = System.today();
                
                testOpp.AccountId = testAcc.Id;
                
                insert testOpp;
                return testOpp;
        }
        
        
        /**
         * Insert a test quote based on an opportunity in the db
         */
        public static zqu__Quote__c makeQuote(Opportunity testOpp) {
                
                zqu__Quote__c testQuote = new zqu__Quote__c();
                
                testQuote.Name = 'my test quote';
                
                testQuote.zqu__Opportunity__c = testOpp.Id;
                
                insert testQuote;
                return testQuote;
        }
        
        /**
         * Insert a test application 
         */
        public static Application__c makeApplication() {
                
                Application__c testApp = new Application__c();
                
                testApp.Name = 'my test app';
                
                insert testApp;
                return testApp;
        }

}