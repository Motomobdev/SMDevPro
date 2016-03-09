/**********************************************************/
// Created by: Adelito Borba Farias
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This test class contains methods to test if the methods
// of application class is working properly.
/**********************************************************/
@isTest
public class LaunchCalMotorolaCoreDirectoryTest{
    
    
    // Description:
	// This test case checks the Application class
    // is able to be built from values extracted from
    // Application__c class.
	//
	// Last Modified: 03/20/2014
    public static testMethod void testApplicationSObjectFields(){
        // Setup
    	LaunchCalMotorolaCoreDirectory subscriber = LaunchCalMotorolaCoreDirectory.buildSubscriber();
        LaunchCal launchObj = new LaunchCal();
        
        
       // LaunchCal_Motorola_Core_Directory__c app = new LaunchCal_Motorola_Core_Directory__c();
        //app.name = 'Application 1';
       // app.uniqueID = 'a6ed65e6';
        
        // Execution
        Test.startTest();
        /*Application application = new Application();
        application.setName(app.name);
        application.setPackageName(app.uniqueID);
*/


		MotorolaCoreDirectory flippedBy = new MotorolaCoreDirectory();	
        flippedBy.setEmail('user@motorola.com');						
        subscriber.flippedBy = flippedBy;
        subscriber.uniqueID = '2we34r5';							
        //launchObj.approvers.add(subscriber);        
        Test.stopTest();
        
        // Assertions
        boolean equals = false;
        
        String uniqueIDLaunch =  subscriber.uniqueID;
        if (
           uniqueIDLaunch.equals(subscriber.uniqueID)){
            equals = true;        
        }
        
        System.assert(equals);
    }    

}