/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/19/2014
// Last Modified: José Elias Araújo
// Last Modified by: 05/07/2014
//
// Description:
// This class is a stub for EmporiumCallout class and it is
// able to simulate requests to LaunchCal. It generates
// fake results to be used in some test cases.
// 
// Test Class: 
// LaunchCalCalloutStubTest.cls 
/**********************************************************/
public with sharing class LaunchCalCalloutStub  implements CalloutClass{
    private static String googleAuthToken = 'fake_token_123kj4123kj4123kjkjbkjh4123hjv421jhg421jhg42_h421jh241';
    private static String googleStateToken = 'fake_state_AJKiYcHSluWSAxCVllQHbBe4Zs5gU';    
    private static String googleSACSIDCookie = 'SACSID=fake_AJKiYcHuJtx1VLxqWBaQmu5Vi8WcCl';
    @TestVisible static String GOOGLE_CLIENT_LOGIN_URL = 'https://www.google.com/accounts/ClientLogin';
    @TestVisible static String GOOGLE_CONFIRM_LOGIN_URL = 'https://appengine.google.com/_ah/conflogin?continue=';
    @TestVisible static String GOOGLE_STATE_LOGIN_URL = 'https://moto-emporium.appspot.com/_ah/conflogin?state=';
    @TestVisible static String API_ARIANE_GET_LAUNCHES_URL = 'http://ariane.motorola.com/api/launches';
    
    private static String launchesJson;
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
        if (endpoint.contains(GOOGLE_STATE_LOGIN_URL)){
            //if (useValidData){            
	        	response.setHeader('Set-Cookie', googleSACSIDCookie);
            //}else{
	        //	response.setBody('The authentication token is not valid');                
            //}
    	    response.setStatusCode(200);                        
        }else if (endpoint.contains(GOOGLE_CONFIRM_LOGIN_URL)){
        	response.setHeader('Location', GOOGLE_STATE_LOGIN_URL);
            response.setStatusCode(200);                                    
        }else if (endpoint.contains(API_ARIANE_GET_LAUNCHES_URL)){
        	if (useValidData){   
        		response.setBody(launchesJson);
           		response.setStatusCode(200);
        	}else{
        		response.setStatusCode(500); 
        	}                                    
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
        
        if (endpoint.equals(GOOGLE_CLIENT_LOGIN_URL)){
            //if (!useValidData){
	        //	response.setBody('This user is not a google account');
            //}else{              
                String resBody = 'Auth=fake_token_123kj4123kj4123kjkjbkjh4';
                body += '123hjv421jhg421jhg42_h421jh241';
                response.setBody(resBody);
            //}
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
    @TestVisible static void defineNumberOfLaunches(Integer numberOfLaunches, boolean validData){
    	
    	String stubJson = '{"id":"0","projectId":"100432","version":"8","status":"LAUNCHED",';
    	stubJson += '"name":"This is a fake launch","description":"Description fake", "created":"1389490672049","updated":';
    	stubJson += '"1389577344381","launchDate":"2014-01-13","hardDeadline":false,"approvalStatus":"APPROVED",';
    	stubJson += '"launchJustification" : "","createdBy":"user1@motorola.com","subscribers":';
    	stubJson += '["user2@motorola.com"],"partial":false,"calendarIds":["53001"],"fyiCalendarIds":';
    	stubJson += '[],"attributes":{"56001":"3"},"approvers":{"49003":{"approverDefinitionId"';
    	stubJson += ':"49003","approvalStatus":"APPROVED","flippedBy":"user3@motorola.com","flippedOn":';
    	stubJson += '"1389568968973","owners":["user4@motorola.com"],"notes":""}},"filteredAttributes":[],"';
    	stubJson += 'approverEmails":["user3@motorola.com"],"approvalPendingEmails":[],"inconsistent":false,"incomplete":false}';
    	
    	
        useValidData = validData;
        launchesJson = '{ "launches" : [';
        for(Integer i=0; i < numberOfLaunches; i++){            
            if (useValidData){
        		launchesJson += stubJson.replace('"id":"0"', '"id":"' + (i + 1) + '"');
		    }
            
            if((i + 1) < numberOfLaunches){
                stubJson += ',';  
            }
        }
        
        launchesJson += '],"totalCount":null,"continuationToken":null,"warnings":[],"errors":[]}';   
    }
}