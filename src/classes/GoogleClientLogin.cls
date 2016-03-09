/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 02/26/2014
// Last Modified: José Elias Araújo
// Last Modified by: 09/10/2014
// 
// Description:
// This class is able to handle simple client login authentication 
// in google service to allow using Emporium API.
// 
// Test Class: 
// GoogleClientLoginTest.cls
/**********************************************************/
public class GoogleClientLogin{
    
    private CalloutClass callout;

    // Description:  
	// Constructor method
	//
	// Input: none
	//
	// Returns: none
    public GoogleClientLogin(){
        if (!Test.isRunningTest()){
            callout = new EmporiumCallout();
        }else{
            callout = new EmporiumCalloutStub();
        }
            
    }
    
    // Description:  
	// Extract the authentication token from a value passed as argument.
    // The value has to follow the pattern Auth=<token>, where the value
    // <token> is extracted.
	//
	// Input: responseValue (String value to extract the token.)
	//
	// Returns: String of token extracted from input value.
    @TestVisible static String getAuthToken(String responseValue){
        Pattern MyPattern = Pattern.compile('(Auth)+=(.*)');
        Matcher matcher = MyPattern.matcher(responseValue);
        String token = null;
        boolean hasToken = false;
        while (matcher.find() && !hasToken) {            
            if (matcher.group(1).equals('Auth')){
                token = matcher.group(2);
                hasToken = true;
            }
        }
        
        return token;
    }

    // Description:  
	// This method is able to access the google authentication
    // service and then to get the authentication token.
    //
    // If the google account used in this method is not valid,
    // an exception is thrown.
	//
	// Input: email (Google email account)
    //        password (Google account password)
    //        appEngineResource (Name of desired App Engine resource)
	//
	// Returns: String of authentication token.
    @TestVisible String googleClientLogin(String email, String password, String appEngineResource){
        String credentials = 'Email=' + email + '&Passwd=' + password + '&service=ah&';
        credentials += appEngineResource + '&accountType=GOOGLE_OR_HOSTED';
		String responseBody = '';
        String googleConfUrl = 'https://www.google.com/accounts/ClientLogin';
        HttpResponse res = callout.postRequest(googleConfUrl, new Map<String, String>(), credentials);

        if (res.getStatusCode() != 500){
            if (res.getBody().indexOf('Auth=') > -1){
                 responseBody = res.getBody();  
            }else{
                 throw new EmporiumException('The account is not a google account');   
            }
        }else{
        	throw new EmporiumException('It is not possible to request the google client login url');            
        }       
        
        return responseBody;
    }
    
    // Description:  
	// This method checks if the authentication token is valid.
    // If so, it retrieves the callback url to confirm the authentication.
    //
    // If the google account used in this method is not valid or the token 
    // id invalid, an exception is thrown.
	//
	// Input: authToken (Authentication token)
	//
	// Returns: String of url callback.
    @TestVisible String getTokenLocation(String authToken){
        String checkTokenUrl = 'https://appengine.google.com/_ah/conflogin?continue=';
        checkTokenUrl += 'https://moto-emporium.appspot.com/&authuser=0&auth=';
        HttpResponse res = callout.getRequest(checkTokenUrl + authToken, new Map<String, String>());
        String location = '';
        if (res.getStatusCode() != 500){
            if (res.getHeader('Location') != null){
                 location = res.getHeader('Location'); 
            }else{
                 throw new EmporiumException('The authentication token is not valid');   
            }
        }else{
        	throw new EmporiumException('It is not possible to request the google client login url');   
        } 
        
        return location;
    }       

    // Description:  
	// This method receives the callback url to send the request
    // and gets the cookie with authorization token to use the service.
    //
    // This authorization token shall be set in header.
    //
    // If the google account used in this method is not valid or the token 
    // id invalid, an exception is thrown.
	//
	// Input: location (url callback)
	//
	// Returns: String of authorization token.     
    @TestVisible String authenticate(String location){
        HttpResponse res = callout.getRequest(location, new Map<String, String>());
        
        String cookie;
        if (res.getStatusCode() != 500){
            if (res.getHeader('Set-Cookie') != null){
                 cookie = res.getHeader('Set-Cookie'); 
            }else{
                 throw new EmporiumException(res.getBody());   
            }
        }else{
        	throw new EmporiumException('It is not possible to request the google client login url');   
        } 
		return cookie;
    }

    
    // Description:  
	// This method authenticates in the google services.
	//
	// Input: email (Google email account)
    //        password (Google account password)
    //        appEngineResource (Name of desired App Engine resource)
	//
	// Returns: Map<String, String> of parameters retrived from authentication process.
    public Map<String, String> login(String email, String password, String appEngineResource){
        Map<String, String> authParameters = new Map<String, String>();
        
        try{
	        String body = googleClientLogin(email, password, appEngineResource);
    	    String auth = getAuthToken(body);
        
        	String locationHeader = getTokenLocation(auth);

	        String setCookieHeader = authenticate(locationHeader);
	        authParameters.put('cookie', setCookieHeader);
        }catch(Exception e){
        	throw new EmporiumException(e.getMessage());
        }
        return authParameters;
    }

}