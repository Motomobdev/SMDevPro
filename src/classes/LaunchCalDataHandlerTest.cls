/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 04/01/2014
// Last Modified: José Elias Araújo
// Last Modified by: 05/07/2014
//
// Description:
// This test class contains methods to test if the methods
// of LaunchCalDataHandler class is working properly.
/**********************************************************/
@isTest
public class LaunchCalDataHandlerTest {

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
	// This test case checks if the parser is able to convert
	// the json retrieved from LaunchCal to a list of LaunchCal
	// objects.
	//
	// Last Modified: 04/03/2014
    @isTest(SeeAllData=true)
    public static void testGetLaunchesJSON(){
    	// Setup
    	createGoogleAccountTest();      
    	LaunchCalCalloutStub.defineNumberOfLaunches(1, true);
    	LaunchCalDataHandler handler = new LaunchCalDataHandler();
    	
    	// Execution 
    	Test.startTest();    
    	List<String> json = handler.getLaunchesJSON(0);
    	
    	LaunchCalDataParser parser = new LaunchCalDataParser();
    	List<LaunchCal> launches = parser.getLaunches(json.get(0));
    	Test.stopTest();  
    	
    	// Assertion
    	System.assertEquals(launches.size(), 1);
    	deleteGoogleAccountTest();       	
    }
    
    // Description:
	// This test case checks if the LaunchCal handler works properly when
	// received a invalid json from LaunchCal.
	//
	// Last Modified: 04/03/2014    
    @isTest(SeeAllData=true)
    public static  void testGetLaunchesJSONInvalidEndpoint(){
    	// Setup
    	createGoogleAccountTest();      
    	LaunchCalCalloutStub.defineNumberOfLaunches(1, false);
    	LaunchCalDataHandler handler = new LaunchCalDataHandler();
    	
    	// Execution
    	Test.startTest();
    	boolean error = false;
    	try{
    		List<String> json = handler.getLaunchesJSON(0);
    	}catch(LaunchCalException e){
    		error = true;
    	}    
    	Test.stopTest();  
    	
    	// Assertion
    	System.assert(error);
    	deleteGoogleAccountTest();       	
    }   
    
    // Description:
	// This test case checks if the LaunchCal handler works properly when
	// trying to authenticate on google service with a invalid google account. 
	//
	// Last Modified: 04/03/2014   
    @isTest(SeeAllData=false)
    public static  void testGetLaunchesJSONWithNoGAccount(){
    	// Setup 
    	deleteGoogleAccountTest();
    	LaunchCalCalloutStub.defineNumberOfLaunches(1, false);
    	
    	// Execution
    	Test.startTest();
    	boolean error = false;
    	try{
    		LaunchCalDataHandler handler = new LaunchCalDataHandler();
    	}catch(LaunchCalException e){
    		error = true;
    	}    
    	Test.stopTest();  
    	
    	// Assertion
    	System.assert(error);
    	deleteGoogleAccountTest();       	
    }    

}