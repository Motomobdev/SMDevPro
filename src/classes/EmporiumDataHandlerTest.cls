/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/19/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description: 
// This test class contains methods to test the features
// implemented in EmporiumDataHandler class.
/**********************************************************/
@isTest(SeeAllData=true)
public class EmporiumDataHandlerTest{
    
    // Description:  
    // Create a new entry in the EmporiumGoogleAccount 
    // custom setting. Its name is TestGoogleAccount
    // and is used only during the tests.
    //
    // Input: none
    //
    // Returns: none  
    private static void createGoogleAccountTest(){
        boolean hasTestAccount = false;
    	Map<String, EmporiumGoogleAccount__c> accounts = EmporiumGoogleAccount__c.getAll();
		List<String> accountsNames = new List<String>();
		accountsNames.addAll(accounts.keySet());        
		for (String accountName : accountsNames) {
			EmporiumGoogleAccount__c account = accounts.get(accountName);
		    if (account.Name.equals('TestAccount')){
				hasTestAccount = true;
                break;
            }
		}         
        
        if (!hasTestAccount){
        	EmporiumGoogleAccount__c googleAccount = new EmporiumGoogleAccount__c();
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
    // Delete an entry in the EmporiumGoogleAccount
    // custom setting called TestGoogleAccount.
    // It is used only during the tests.
    //
    // Input: none
    //
    // Returns: none     
    private static void deleteGoogleAccountTest(){
    	Map<String, EmporiumGoogleAccount__c> accounts = EmporiumGoogleAccount__c.getAll();
		List<String> accountsNames = new List<String>();
		accountsNames.addAll(accounts.keySet());        
		for (String accountName : accountsNames) {
			EmporiumGoogleAccount__c account = accounts.get(accountName);
		    if (account.Name.equals('TestAccount')){
				delete account;
		        break;
            }
		}  
    }
   
    // Description:
	// This test case checks if the class
    // throws a exception when error happens
    // during authentication.
	//
	// Last Modified: 03/20/2014
    public static testMethod void testWrongAuthentication(){
		// Setup
        EmporiumCalloutStub.useValidData(false);   
		createGoogleAccountTest();

        // Execution
        Test.startTest();        
        boolean error = false;
        try{
	        EmporiumDataHandler handler = new EmporiumDataHandler();
        }catch(EmporiumException e){
         	error = true;
        }
        Test.stopTest();  
        
        deleteGoogleAccountTest();
        
        // Assertions
        System.assert(error);       
    }


    // Description:
	// This test case checks if the  contructor method
    // of EmporiumDataHandler class is able to be invoked.
    // 
	//
	// Last Modified: 03/20/2014    
    public static testMethod void testClassConstruction(){
        
        // Setup
		createGoogleAccountTest();        
        
        // Execution
        Test.startTest();        
        boolean created = false;
        try{
	        EmporiumDataHandler handler = new EmporiumDataHandler();
            if (handler != null){
                created = true;
            }
        }catch(EmporiumException e){
         	  //Do nothing. 
        }
        Test.stopTest();
        
        deleteGoogleAccountTest();        
        
        // Assertions
        System.assertEquals(created, true);
    }
    
    // Description:
	// This test case checks if the handler class is able
    // to get the list os application IDs from and then
    // parse it to a set IDs.
    // 
	//
	// Last Modified: 03/20/2014     
    public static testMethod void testApplicationNameList(){        
        //Setup
		createGoogleAccountTest();          
        Integer numOfApplication = 3;
        EmporiumDataHandler handler = new EmporiumDataHandler();
		EmporiumCalloutStub.defineNumberOfApplications(numOfApplication, true);        
        
        // Execution
        Test.startTest();
        List<String> resp = handler.getApplicationNames();
        Test.stopTest();
        
        deleteGoogleAccountTest();        
        
        // Assertions
        System.assertEquals(numOfApplication, resp.size());
    }

    // Description:
	// This test case checks if the handler class is able
    // to get an invalid list of application IDs from Emporium,
    // but it is not able to parse it.
    // 
	//
	// Last Modified: 03/20/2014      
    public static testMethod void testApplicationNameListWithInvalidData(){
        // Setup
		createGoogleAccountTest();          
        Integer numOfApplication = 3;
        EmporiumDataHandler handler = new EmporiumDataHandler();
        
        // Execution
        Test.startTest();
        EmporiumCalloutStub.defineNumberOfApplications(numOfApplication, false);
        boolean exceptionThrown = false;
        List<String> resp = handler.getApplicationNames();            
        Test.stopTest();
        
        deleteGoogleAccountTest();        
        
        // Assertions
        System.assertEquals(0, resp.size());        
    }

    // Description:
	// This test case checks if the handler class is able
    // to get valid list applications from Emporium and
    // then parse this list to a set of objects.
    // 
	//
	// Last Modified: 03/20/2014     
    public static testMethod void testApplicationDetails(){
        // Setup
		createGoogleAccountTest();          
        Integer numOfApplication = 3;
        EmporiumCalloutStub.defineNumberOfApplications(numOfApplication, true);        
        EmporiumDataHandler handler = new EmporiumDataHandler();
        List<String> resp = handler.getApplicationNames();
        
        // Execution
        Test.startTest();        
        List<EmporiumApplicationDownloadStats> apps = handler.getApplicationDetails(resp);
 
        boolean pulledAllApps = true;
        for(Integer i=0; i < resp.size(); i++){
            boolean found = false;        
            for(Integer j=0; j < apps.size(); j++){
                if (resp.get(i).equals(apps.get(j).getUniqueID())){
                    found = true;
                    break;
                }
            }

            if (!found){
                pulledAllApps = false;
                break;
            }
        }
		Test.stopTest();     

        deleteGoogleAccountTest();        
        
        // Assertions 
        System.assertEquals(resp.size(), apps.size());  
        System.assertEquals(pulledAllApps, true);  

    }

    // Description:
	// This test case checks if the handler class is able
    // to get an invalid list of applications from Emporium,
    // but it is not able to parse it.
    // 
	//
	// Last Modified: 03/20/2014     
    public static testMethod void testApplationDetailsWithInvalidData(){
        // Setup
		createGoogleAccountTest();          
        Integer numOfApplication = 3;
        EmporiumDataHandler handler = new EmporiumDataHandler();
        
        // Execution
        Test.startTest();        
        EmporiumCalloutStub.defineNumberOfApplications(numOfApplication, false);                
        List<String> resp = handler.getApplicationNames();
        boolean exceptionThrown = false;
        try{
        	List<EmporiumApplicationDownloadStats> apps = handler.getApplicationDetails(resp);
        }catch(EmporiumException e){
            exceptionThrown = true;
        }
            
		Test.stopTest();   
        
        deleteGoogleAccountTest();        
        
        // Assertions
        System.assertEquals(exceptionThrown, true);          
    }

}