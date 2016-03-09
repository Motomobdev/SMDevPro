/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This test class contains methods to test if the methods
// of application class is working properly.
/**********************************************************/
@isTest
public class EmporiumClassesTest{

    // Description:
	// This test case checks the Application class
    // is able to be built from values extracted from
    // Application__c class.
	//
	// Last Modified: 03/20/2014
    public static testMethod void testApplicationSObjectFields(){
        // Setup
    	Application__c app = new Application__c();
        app.Name = 'Application 1';
        app.Package_Name__c = 'com.motorola.package';
        // Execution
        Test.startTest();
        Application application = new Application();
        application.setName(app.Name);
        application.setPackageName(app.Package_Name__c);        
        Test.stopTest();
        
        // Assertions
        boolean equals = false;
        
        if (app.Name.equals(application.getName()) && 
            app.Package_Name__c.equals(application.getPackageName())){
            equals = true;        
        }
        
        System.assert(equals);
    }    
    
    // Description:
	// This test case checks if the Application class
    // is able to be created from an instance of 
    // Application__c class.
	//
	// Last Modified: 03/20/2014    
    public static testMethod void testApplicationFields(){
        // Setup
    	Application__c app = new Application__c();
        app.Name = 'Application 1';
        app.Package_Name__c = 'com.motorola.package';
        
        // Execution
        Test.startTest();
        Application application = new Application(app);
        Test.stopTest();
        
        // Assertions
        boolean equals = false;
        
        if (app.Name.equals(application.getName()) && 
            app.Package_Name__c.equals(application.getPackageName())){
            equals = true;        
        }
        
        System.assert(equals);
    }

    // Description:
	// This test case checks if the Application class
    // is able to be created from an instance of 
    // Application__c class and then generates a second
    // Application__c from Application.
	//
	// Last Modified: 03/20/2014       
    public static testMethod void testApplicationSObject(){
        // Setup
    	Application__c app = new Application__c();
        app.Name = 'Application 1';
        app.Package_Name__c = 'com.motorola.package';
        
        // Execution
        Test.startTest();
        Application application = new Application(app);
        Application__c appSObject = application.getSObject();
        Test.stopTest();
        
        // Assertions
        boolean equals = false;
        
        if (appSObject.Name.equals(app.Name) && 
            appSObject.Package_Name__c.equals(app.Package_Name__c)){
            equals = true;        
        }
        
        System.assert(equals);
    }
}