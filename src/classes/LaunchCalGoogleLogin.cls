/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 04/04/2014
//
// Description:
// This class handles the google authentication. It allows to
// use a valid google account and authenticate in google account
// service. If the account is valid, it retrives the authorization
// token to be used in the cookie when accessing the launchCal
// tool.
//
// 
// Test Class: 
// LaunchCalGoogleLoginTest.cls 
/**********************************************************/
public class LaunchCalGoogleLogin extends GoogleLogin{
	
	// Description:  
    // Constructor method.
    //
    // Input: none
    //
    // Returns: none 
	public LaunchCalGoogleLogin(){
        if (!Test.isRunningTest()){
            callout = new EmporiumCallout();
        }else{
            callout = new LaunchCalCalloutStub();
        }            
    }
	
	// Description:  
    // Defines the endpoint of the service to be 
    // used in the authentication process.
    //
    // Input: none
    //
    // Returns: String of endpoinr URL. 
    String getAppEngineResourceURL(){
    	return 'http://ariane.motorola.com';
    }

}