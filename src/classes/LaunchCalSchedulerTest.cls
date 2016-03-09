/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 04/02/2014
// Last Modified: José Elias Araújo
// Last Modified by: 05/07/2014
//
// Description:
// This test class contains methods to test if the 
// scheduler class is able to schedule the LaunchCal data
// importing.
/**********************************************************/
@isTest(SeeAllData=true)
public class LaunchCalSchedulerTest {
	
	// Description:  
    // Create a new entry in the LaunchCalGoogleAccount
    // custom setting. Its name is TestGoogleAccount
    // and is used only during the tests.
    //
    // Input: none 
    //
    // Returns: none  
    private static void createGoogleAccountTest(){
        boolean hasTestAccount = false;
    	Map<String, LaunchCalGoogleAccount__c> accounts = LaunchCalGoogleAccount__c.getAll();
		List<String> accountsNames = new List<String>();
		accountsNames.addAll(accounts.keySet());         
		for (String accountName : accountsNames) {
			LaunchCalGoogleAccount__c account = accounts.get(accountName);
		    if (account.Name.equals('TestAccount')){
				hasTestAccount = true;
                break;
            }
		}         
        
        if (!hasTestAccount){
        	LaunchCalGoogleAccount__c googleAccount = new LaunchCalGoogleAccount__c();
        	googleAccount.Name='TestAccount';
        	googleAccount.email__c='eliasq@motorlla.com';
        	googleAccount.password__c='ltzfywqnbytjkpfl';
        	try{
				insert googleAccount;
        	}catch(DMLException e){
           		System.assert(false, e.getMessage());
        	}        
        }
    }
   
    // Description:  
    // Delete an entry in the LaunchCalGoogleAccount
    // custom setting called TestGoogleAccount.
    // It is used only during the tests.
    //
    // Input: none
    //
    // Returns: none     
    private static void deleteGoogleAccountTest(){
    	Map<String, LaunchCalGoogleAccount__c> accounts = LaunchCalGoogleAccount__c.getAll();
		List<String> accountsNames = new List<String>();
		accountsNames.addAll(accounts.keySet());        
		for (String accountName : accountsNames) {
			LaunchCalGoogleAccount__c account = accounts.get(accountName);
		    if (account.Name.equals('TestAccount')){ 
				delete account;
		        break;
            }
		}  
    } 
	
    // Description:
	// This test case submit a schedule to run the 
    // LaunchCalScheduler class and then checks the job
    // has been created.
	//
	// Last Modified: 04/02/2014
    public static testMethod void testEmporiumScheduler(){
        // Setup
        createGoogleAccountTest();
        
        // Execution 
        Test.startTest();
        String cron = '0 5 * * 1-12 ? *';
		String jobId = System.schedule('testBasicScheduledApex', cron, new LaunchCalScheduler(0));        
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();        
        
        // Assertions
        System.assertEquals(cron, ct.CronExpression);
        deleteGoogleAccountTest();        
    }
}