/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/19/2014
// Last Modified: José Elias Araújo
// Last Modified by: 09/10/2014
//
// Description:
// This class is a stub for EmporiumCallout class and it is
// able to simulate requests to Emporium. It generates
// fake results to be used in some test cases.
// 
// Test Class: 
// 
/**********************************************************/
public class EmporiumCalloutStub implements CalloutClass{
    private static String googleAuthToken = 'fake_token_123kj4123kj4123kjkjbkjh4123hjv421jhg421jhg42_h421jh241';
    private static String googleStateToken = 'fake_state_AJKiYcHSluWSAxCVllQHbBe4Zs5gU';    
    private static String googleSACSIDCookie = 'SACSID=fake_AJKiYcHuJtx1VLxqWBaQmu5Vi8WcCl';
    @TestVisible static String GOOGLE_CLIENT_LOGIN_URL = 'https://www.google.com/accounts/ClientLogin';
    @TestVisible static String GOOGLE_CONFIRM_LOGIN_URL = 'https://appengine.google.com/_ah/conflogin?continue=';
    
    @TestVisible static String API_SALESFORCE_LIST_URL = 'https://moto-emporium.appspot.com/api/salesforce/list';
    @TestVisible static String API_SALESFORCE_DETAILS_URL = 'https://moto-emporium.appspot.com/api/salesforce/details';
    @TestVisible static String GOOGLE_STATE_LOGIN_URL = 'https://moto-emporium.appspot.com/_ah/conflogin?state=';

    private static String applicationNamesJson;
    private static String applicationJson;
    private static boolean useValidData = true;
    private Integer timeout = 10000;

    // Description:  
	// Set a timeout value to be used during callout.
	//
	// Input: timeourt (Timeout value in milliseconds)
	//
	// Returns: none.    
    public void setTimeout(Integer timeout){
        this.timeout = timeout;
    }
    
    // Description:  
	// Make a fake request to a endpoint passed as argument
    // using GET method. 
	//
	// Input: endpoint (URL address to send the request)
    //        headers (A map with parameters to be sed in header)
	//
	// Returns: HttpResponse of request sent to the endpoint.        
    public HttpResponse getRequest(String endpoint, Map<String, String> headers){
	    HttpResponse response = new HttpResponse();   
        if (endpoint.equals(API_SALESFORCE_LIST_URL)){
        	response.setBody(applicationNamesJson);
            response.setStatusCode(200);            
        }else if (endpoint.contains(GOOGLE_STATE_LOGIN_URL)){
            if (useValidData){            
	        	response.setHeader('Set-Cookie', googleSACSIDCookie);
            }else{
	        	response.setBody('The authentication token is not valid');                
            }
    	    response.setStatusCode(200);                        
        }else if (endpoint.contains(GOOGLE_CONFIRM_LOGIN_URL)){
        	response.setHeader('Location', GOOGLE_STATE_LOGIN_URL);
            response.setStatusCode(200);                                    
        }else{
            response.setStatusCode(500);   
        }
                
        return response;
    }

    // Description:  
	// Make a fake request to a endpoint passed as argument
    // using POST method. 
	//
	// Input: endpoint (URL address to send the request)
    //        headers (A map with parameters to be sed in header)
	//
	// Returns: HttpResponse of request sent to the endpoint.     
    public HttpResponse postRequest(String endpoint, Map<String, String> headers, String body){
	    HttpResponse response = new HttpResponse();   
        
        if (endpoint.equals(API_SALESFORCE_DETAILS_URL)){
            response.setBody(applicationJson);
            response.setStatusCode(200);
        }else if (endpoint.equals(GOOGLE_CLIENT_LOGIN_URL)){
            if (!useValidData){
	        	response.setBody('This user is not a google account');
            }else{              
                String resBody = 'Auth=fake_token_123kj4123kj4123kjkjbkjh4';
                body += '123hjv421jhg421jhg42_h421jh241';
                response.setBody(resBody);
            }
            response.setStatusCode(200);                                    
        }else{
            response.setStatusCode(500);   
        }

        
        
        return response; 
    }

    // Description:  
	// This is a method to be used only during tests.
    // It allows configure if the data retrieved from
    // postRequest and getRequest methods will valid
    // or not.
	//
	// Input: validData (Define if the data is valid ot not)
	//
	// Returns: none
    @TestVisible static void useValidData(boolean validData){
        useValidData = validData;        
    }

    // Description:  
	// This is a method to be used only during tests.
    // It allows configure the number of applications need
    // to be created by methods when they receive the 
    // Emporium URL as endpoint.
	//
	// Input: numberOfApps (Number of apps to be generated)
    //        validData (Define if the data is valid ot not)
	//
	// Returns: none
    @TestVisible static void defineNumberOfApplications(Integer numberOfApps, boolean validData){
        useValidData = validData;
        applicationNamesJson = '[';
        applicationJson = '[';
        for(Integer i=0; i < numberOfApps; i++){            
            String uid = 'ae3e46a8-322c-4dbc-8bb2-f55e' + (1000*i);
            String name = 'Application ' + (i+1);
            Long lastDownloaded = Datetime.now().millisecond();            
            Long uploadedOn = Datetime.now().millisecond();
            Integer downloads = math.round(math.random());
            String uploadedBy = 'user'+ i + '@motorola.com';
            String packageName = 'com.motorola.fakepack';
            Integer version = math.round(math.random());

            if (useValidData){
        		applicationNamesJson += '{"Name":"'+ name + '", "Id":"'+ uid + '"}';
        
                applicationJson += '{"Name":"' + name + '","DateLastDownloaded":';
                applicationJson += lastDownloaded + ',';
                applicationJson += '"UploadedOn":'+ uploadedOn + ',"NumberOfDownloads":';                
                applicationJson += downloads + ',"Id":"'+ uid +'","Package":"';
                applicationJson += packageName + '","UploadedBy":"' + uploadedBy;
                applicationJson += '","Category": "category1","Version":"';
                applicationJson += version + '", "ActiveUsersByVersion":[{"Version":';
                applicationJson += '"1", "NumberOfDownloads":245}]}';               
		    }else{
        		applicationNamesJson += '{"uniqueIdentificationAndName":"';
                applicationNamesJson += uid + '"}';
                
                applicationJson += '{"CreationDate":'+ lastDownloaded;    
                applicationJson += ',"downloads":'+ downloads + ',"Identification":"';
                applicationJson += uid +'","PackageName":"';
                applicationJson += packageName + '","UploadedBy":"' + uploadedBy;
            }
            
            if((i + 1) < numberOfApps){
                applicationNamesJson += ',';   
                applicationJson += ',';  
            }
        }
        
        applicationNamesJson += ']';
        applicationJson += ']';    
    }
}