/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This test class contains methods to check if the method
// implemented in EmailManager to send emails works properly.
/**********************************************************/
@isTest(SeeAllData=true)
public class EmailManagerTest{
    
    // Description:
	// This test case checks if the EmailManager is able to 
    // compose and email before sending to the destination.
	//
	// Last Modified: 03/20/2014
    public static testMethod void testEmail(){
        // Execution
        Test.startTest();
        boolean error = false;
        try{
	        EmailManager.send('Email test', 'This is a email message');
        }catch(EmporiumException e){
            error = true;
        }
        Test.stopTest(); 
        
        // Assertions
        System.assert(!error);
    }

}