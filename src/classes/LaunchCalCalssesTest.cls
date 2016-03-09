/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 04/01/2014
// Last Modified: José Elias Araújo
// Last Modified by: 04/03/2014
//
// Description:
// This test class contains methods to test if the methods
// of LaunchCal and LaunchCal_Motorola_Core_Directory classes
// are working properly.
/**********************************************************/
@isTest
public class LaunchCalCalssesTest {
	
	// Description:
	// This test case checks the LaunchCal class
    // is able to define values of all properties and 
    // create a Custom object representation by using
    // getSObject() method.
	//
	// Last Modified: 04/03/2014
    public static testMethod void testLaunchCalSObjectFields(){
        // Setup 
		Application app = new Application();
        app.setName('App1');
        app.setPackageName('com.motorola.pack');
        LaunchCalMotorolaCoreDirectory subscriber = LaunchCalMotorolaCoreDirectory.buildSubscriber();
        LaunchCalMotorolaCoreDirectory approver = LaunchCalMotorolaCoreDirectory.buildApprover();
		MotorolaCoreDirectory core = new MotorolaCoreDirectory();
		core.setEmail('user@motorola.com');

        // Execution
        Test.startTest();        
    	LaunchCal launchCal = new LaunchCal();
    	launchCal.status = 'APPROVED';
    	launchCal.created = Date.today();
    	launchCal.description = 'This is a launchCal';
    	launchCal.launchDate = Date.today();
    	LaunchCal.productManager = 'Product manager';
    	LaunchCal.uniqueId = '123233';
    	LaunchCal.version = '10'; 
    	LaunchCal.name = 'App with more than 80 letters';
    	LaunchCal.name = LaunchCal.name +  'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
    	launchCal.approvers.add(subscriber);
    	launchCal.approvers.add(approver);   
    	launchCal.application = app;
    	launchCal.createdBy = core;
    	
    	LaunchCal__c customLaunch = launchCal.getSObject();  	
        
        boolean okFields = false;
        
        okFields = LaunchCal.status.equals(customLaunch.Status__c);
        okFields &= LaunchCal.created == customLaunch.created_Date__c;
        okFields &= LaunchCal.description.equals(customLaunch.Description__c);
        okFields &= LaunchCal.launchDate == customLaunch.Launch_Date__c;
        okFields &= LaunchCal.productManager.equals(customLaunch.Product_Manager__c);
        okFields &= LaunchCal.uniqueId.equals(customLaunch.Unique_Id__c);
        okFields &= LaunchCal.version.equals(customLaunch.Version__c);
        
        Test.stopTest();
        
        // Assertion        
        System.assert(okFields);
        System.assertEquals(launchCal.name.length(), 80);
    } 
    
	// Description:
	// This test case checks the LaunchCalMotorolaCoreDirectory class
    // is able to create a subscriber using builder method. It also
    // creates the custom object representation and compare all values.
	//
	// Last Modified: 04/03/2014
    public static testMethod void testLaunchCalMotorolaCoreDirectorySubscriber(){
        
        // Setup
    	LaunchCalMotorolaCoreDirectory subscriber = LaunchCalMotorolaCoreDirectory.buildSubscriber();
        LaunchCal launchObj = new LaunchCal();
        MotorolaCoreDirectory flippedBy = new MotorolaCoreDirectory();

        // Execution
        Test.startTest();
       	flippedBy.setEmail('user@motorola.com');						
        subscriber.flippedBy = flippedBy;
        subscriber.uniqueID = '2we34r5';							
        launchObj.approvers.add(subscriber);   
        Motorola_Core_Directory__c customLaunchCalMoto =  flippedBy.getSObject();    
        Test.stopTest();
        
        // Assertions
        System.assertEquals(subscriber.uniqueID, launchObj.approvers.get(0).uniqueID);
        
    }    
    
    
	// Description:
	// This test case checks the LaunchCalMotorolaCoreDirectory class
    // is able to create a approver using builder method. It also
    // creates the custom object representation and compare all values.
	//
	// Last Modified: 04/03/2014
    public static testMethod void testLaunchCalMotorolaCoreDirectoryApprover(){
      	
        // Setup
    	LaunchCalMotorolaCoreDirectory subscriber = LaunchCalMotorolaCoreDirectory.buildApprover();
        LaunchCal launchObj = new LaunchCal();

        // Execution
        Test.startTest();
        subscriber.notes = 'NOTAS';
        subscriber.approvalStatus = 'APPROVED'; 
        subscriber.name = 'Name';   
        launchObj.approvers.add(subscriber);        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(subscriber.notes, launchObj.approvers.get(0).notes);
        System.assertEquals(subscriber.approvalStatus, launchObj.approvers.get(0).approvalStatus);
        System.assertEquals(subscriber.name, launchObj.approvers.get(0).name);

    }    
	
}