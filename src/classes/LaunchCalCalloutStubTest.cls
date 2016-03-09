/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 04/01/2014
// Last Modified: José Elias Araújo
// Last Modified by: 04/03/2014
//
// Description:
// This test class contains methods to test if the methods
// of LaunchCalCalloutStub class is working properly.
/**********************************************************/
@isTest
public class LaunchCalCalloutStubTest {
	
    // Description:
	// This test case checks if the stub returns the right
	// content when requesting with a invalid endpoint.
	//
	// Last Modified: 04/03/2014	
	@isTest
	public static void testGetRequestInvalidURL(){
		// Setup
		CalloutClass callout = new LaunchCalCalloutStub();
		
		// Execution
		Test.startTest();
		HttpResponse getResponse = callout.getRequest('http://fakeurl.com', new Map<String, String>());
		HttpResponse postResponse = callout.postRequest('http://fakeurl.com', new Map<String, String>(), '');
		boolean response = getResponse.getStatusCode() == 500 && postResponse.getStatusCode() == 500;
		Test.stopTest();
		
		// Assetion
		System.assert(response);
	}

    // Description:
	// This test case checks if the stub returns the right
	// content when requesting with a valid endpoint.
	//
	// Last Modified: 04/03/2014	
	@isTest
	public static void testGetRequest(){
		// Setup
		LaunchCalCalloutStub.defineNumberOfLaunches(1, true);
		CalloutClass callout = new LaunchCalCalloutStub();
		
		// Execution
		Test.startTest();
		HttpResponse response = callout.getRequest(LaunchCalCalloutStub.GOOGLE_STATE_LOGIN_URL, new Map<String, String>());
		boolean google1Response = response.getStatusCode() == 200;
		google1Response = google1Response && (response.getHeader('Set-Cookie') != null);
		
		response = callout.getRequest(LaunchCalCalloutStub.GOOGLE_CONFIRM_LOGIN_URL, new Map<String, String>());
		boolean google2Response = response.getStatusCode() == 200;
		google2Response = google2Response && (response.getHeader('Location') != null);
		
		response = callout.getRequest(LaunchCalCalloutStub.API_ARIANE_GET_LAUNCHES_URL, new Map<String, String>());
		boolean arianeResponse = response.getStatusCode() == 200;
		Test.stopTest();
		
		// Assetion
		System.assert(google1Response && google2Response && arianeResponse);
	}
	
    // Description:
	// This test case checks if the stub returns the right
	// content when requesting POST with a valid endpoint.
	//
	// Last Modified: 04/03/2014		
	@isTest
	public static void testPostRequest(){
		// Setup
		CalloutClass callout = new LaunchCalCalloutStub();
		
		// Execution
		Test.startTest();
		HttpResponse response = callout.postRequest(LaunchCalCalloutStub.GOOGLE_CLIENT_LOGIN_URL, new Map<String, String>(), '');
		// Assetion
		System.assertEquals(200, response.getStatusCode());
	}	
	
    // Description:
	// This test case checks if the stub returns the right
	// content when requesting with a valid endpoint, but invalid response.
	//
	// Last Modified: 04/03/2014		
    @isTest
	public static void testRequestsInvalidData(){
		// Setup
		CalloutClass callout = new LaunchCalCalloutStub();
		
		// Execution
		Test.startTest();
		LaunchCalCalloutStub.defineNumberOfLaunches(1, false);
		HttpResponse response = callout.getRequest(LaunchCalCalloutStub.API_ARIANE_GET_LAUNCHES_URL, new Map<String, String>());

		// Assetion
		System.assertEquals(500, response.getStatusCode());
	}
	
    // Description:
	// This test case checks if the stub returns the right
	// content when requesting with a valid endpoint and valid response.
	//
	// Last Modified: 04/03/2014		
	@isTest
	public static void testRequestsValidData(){
		// Setup
		CalloutClass callout = new LaunchCalCalloutStub();
		
		// Execution
		Test.startTest();
		LaunchCalCalloutStub.defineNumberOfLaunches(1, true);
		HttpResponse response = callout.getRequest(LaunchCalCalloutStub.API_ARIANE_GET_LAUNCHES_URL, new Map<String, String>());
    	LaunchCalDataParser parser = new LaunchCalDataParser();
    	System.debug(response.getBody());
    	List<LaunchCal> launches = parser.getLaunches(response.getBody());

		// Assetion
		System.assertEquals(1, launches.size());
	}	

}