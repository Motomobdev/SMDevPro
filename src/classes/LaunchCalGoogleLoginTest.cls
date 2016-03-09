/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 04/01/2014
// Last Modified: José Elias Araújo
// Last Modified by: 04/03/2014
//
// Description:
// This test class contains methods to test if the methods
// of LaunchCalGoogleLogin class is working properly.
/**********************************************************/
@isTest
public class LaunchCalGoogleLoginTest{
    
    // Description:
    // This test case checks if LaunchCalGoogleLogin returns
    // a valid authorization token to be used as cookie.
    //
	// Last Modified: 04/03/2014    
    public static testMethod void testGoogleLogin(){
     	//Setup
       	Map<String, String> params = new Map<String, String>();
        
		// Execution
        Test.startTest();
	    GoogleLogin googleLogin = new LaunchCalGoogleLogin();
    	params = googleLogin.login('user12134@motorola.com', '12345');        
        Test.stopTest();        
        boolean validCookie = false;
        if (params.get('cookie') != null){
            validCookie = true;
        }
        
        //Assertions
        System.assert(validCookie);
        System.assertEquals(params.get('cookie'), 'SACSID=fake_AJKiYcHuJtx1VLxqWBaQmu5Vi8WcCl');
     }
}