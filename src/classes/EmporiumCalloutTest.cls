/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This test class contains methods to test if the 
// EmporiumCallout class is able to send HTTP requests
// to an endpoint.
/**********************************************************/
@isTest
public class EmporiumCalloutTest{

    // Description:
	// This test case checks if callout class is able to
    // send HTTP request using GET method.
	//
	// Last Modified: 03/20/2014
    public static testMethod void testGetRequest(){
        // Setup
    	EmporiumCallout callout = new EmporiumCallout();
        Map<String, String> headers = new Map<String, String>();
        headers.put('header_param1', 'header_param1_value');
        
        // Execution
        Test.startTest();
        String urlFake = 'http://afakeurl.com';
        HttpResponse response = callout.getRequest(urlFake, headers);        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(response.getStatusCode(), 200);
        System.assertEquals(response.getBody(), 'OK - ' + urlFake); 
        System.assertEquals(response.getHeaderKeys().size(), 1);  
        System.assertEquals(response.getHeader('header_param1'), 'header_param1_value');  
    }
   
    // Description:
	// This test case checks if callout class is able to
    // send HTTP request using POST method.
	//
	// Last Modified: 03/20/2014    
    public static testMethod void testPostRequest(){
        // Setup
    	EmporiumCallout callout = new EmporiumCallout();
        Map<String, String> headers = new Map<String, String>();
        headers.put('header_param1', 'header_param1_value');
        
        // Execution
        Test.startTest();
        String bodyFake = '{body: "This is a test"';
        HttpResponse response = callout.postRequest('http://afakeurl.com', headers, bodyFake);        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(response.getStatusCode(), 200);
        System.assertEquals(response.getBody(), bodyFake); 
        System.assertEquals(response.getHeaderKeys().size(), 1);  
        System.assertEquals(response.getHeader('header_param1'), 'header_param1_value');  
    }    
}