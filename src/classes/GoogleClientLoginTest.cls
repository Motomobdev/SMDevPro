/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/18/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This test class contains methods to test the features
// implemented in GoogleClientLogin class.
/**********************************************************/
@isTest
public class GoogleClientLoginTest{

    // Description:
	// This test case checks the GoogleLogin method.
	//
	// Last Modified: 03/20/2014
    public static testMethod void testGoogleLogin(){    	
        // Setup
        Map<String, String> params = new Map<String, String>();
        
        // Execution
        Test.startTest();
	    GoogleClientLogin googleLogin = new GoogleClientLogin();
    	params = googleLogin.login('user12134@motorola.com', '12345', 'moto-emporium');        
        Test.stopTest();        
        boolean validCookie = false;
        if (params.get('cookie') != null){
            validCookie = true;
        }

        // Assertions
        System.assert(validCookie);
        System.assertEquals(params.get('cookie'), 'SACSID=fake_AJKiYcHuJtx1VLxqWBaQmu5Vi8WcCl');
    }        

    // Description:
	// This test case checks if the authentication
    // token could be extracted properly.
	//
	// Last Modified: 03/20/2014    
    public static testMethod void testToken(){
        // Setup
        String token = 'fake_token_dwkhb2134khjbkjb13kb413j4v13k4b13k4jb32';
        
        // Execution
        Test.startTest();
    	String authToken = GoogleClientLogin.getAuthToken('Auth=' + token);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(authToken, token);
    }

    // Description:
	// This test case checks the authentication cookie
    // is not generated when using invalid data.
	//
	// Last Modified: 03/20/2014    
    public static testMethod void testAuthenticationCoockieWithInvalidData(){ 
        // Setup
        EmporiumCalloutStub.useValidData(false);        
        boolean error = false;        
	    String authenticationURL = 'https://moto-emporium.appspot.com/_ah/';
        authenticationURL += 'conflogin?state=invalid_Token_3k4mn34kjkh13jhg4';        
        
        // Execution
        Test.startTest();
        try{
            GoogleClientLogin googleLogin = new GoogleClientLogin();
    	    googleLogin.authenticate(authenticationURL);
        }catch(EmporiumException e){
            error = true;
        }
        Test.stopTest();
        
        // Assertions
        System.assert(error);
    }

    // Description:
	// This test case checks the authentication cookie
    // is generated when using valid data.
	//
	// Last Modified: 03/20/2014        
    public static testMethod void testAuthenticationCoockie(){
        // Setup
        boolean error = false;
        String cookie;
        String authenticationURL = 'https://moto-emporium.appspot.com/_ah/conflogin?state=3k4mn34kjkh13jhg4';

        // Execution
        Test.startTest();
        try{
            GoogleClientLogin googleLogin = new GoogleClientLogin();
    	    cookie = googleLogin.authenticate(authenticationURL);
        }catch(EmporiumException e){
            error = true;
        }
        Test.stopTest();
        
        // Assertions
        System.assert(!error);
        System.assertEquals(cookie, 'SACSID=fake_AJKiYcHuJtx1VLxqWBaQmu5Vi8WcCl');
    }        

    // Description:
	// This test case checks if callback url is
    // no retrieved when using invalid credentials.
	//
	// Last Modified: 03/20/2014        
    public static testMethod void testTokenLocationWithInvalidData(){
        // Setup
        EmporiumCalloutStub.useValidData(false);
        boolean error = false;
	    String token = 'jh32hg434hgjkhg314jh134jh134342kbj32k4b32k4b23';
        token += 'k4b_j3hv24jh32v4jv3_k13j4j321hv';
        
		// Execution
        Test.startTest();
        try{
            GoogleClientLogin googleLogin = new GoogleClientLogin();
    	    googleLogin.getTokenLocation(token);
        }catch(EmporiumException e){
            error = true;
        }
        Test.stopTest();
        
        // Assertions
        System.assert(!error);
    }

    // Description:
	// This test case checks the authentication cookie
    // is not generated when using invalid data.
	//
	// Last Modified: 03/20/2014        
    public static testMethod void testTokenLocation(){         
        // Setup
        boolean error = false;
        String location;
	    String token = 'jh32hg434hgjkhg314jh134jh134342kbj32k4b32k4b23k4b';
        token += '_j3hv24jh32v4jv3_k13j4j321hv';
        
        // Execution
        Test.startTest();
        try{
            GoogleClientLogin googleLogin = new GoogleClientLogin();
    	    location = googleLogin.getTokenLocation(token);
        }catch(EmporiumException e){
            error = true;
        }
        Test.stopTest();
        
        // Assertions
        System.assert(!error);
        System.assert(location.contains(EmporiumCalloutStub.GOOGLE_STATE_LOGIN_URL));
    }

    // Description:
	// This test case checks the authentication with
    // invalid credentials.
	//
	// Last Modified: 03/20/2014        
    public static testMethod void testLoginInvalidCreditials(){ 
        // Setup
        EmporiumCalloutStub.useValidData(false);
        boolean error = false;
        
        // Execution
        Test.startTest();
        try{
        	GoogleClientLogin googleLogin = new GoogleClientLogin();
        	googleLogin.googleClientLogin('user12134@motorola.com', '12345', 'moto-emporium');
        }catch(EmporiumException e){
            error = true;
        }        
        Test.stopTest();
        
        // Assertions
        System.assert(error);      
    }

    // Description:
	// This test case checks the authentication with
    // valid credentials.
	//
	// Last Modified: 03/20/2014       
    public static testMethod void testLogin(){ 
        // Setup
        String authToken;
        boolean error = false;        
        
        // Execution
        Test.startTest();
        try{
        	GoogleClientLogin googleLogin = new GoogleClientLogin();
        	authToken = googleLogin.googleClientLogin('user12134@motorola.com', '12345', 'moto-emporium');
        }catch(EmporiumException e){
            error = true;
        }        
        Test.stopTest();
        
        // Assertions
        System.assert(!error);
        System.assert(authToken.contains('Auth='));
    }
    
    
}