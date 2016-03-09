/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 05/28/2014
//
// Description:
// This class specifies methods to send HTTP requests to a 
// endpoint.
// 
// Test Class: 
// 
/**********************************************************/
public interface CalloutClass{

    // Description:  
	// Set a timeout value to be used during callout.
	//
	// Input: timeourt (Timeout value in milliseconds)
	//
	// Returns: none.
    void setTimeout(Integer timeout);
    
    // Description:  
	// Make a request to a endpoint passed as argument
    // using GET method. 
	//
	// Input: endpoint (URL address to send the request)
    //        headers (A map with parameters to be sed in header)
	//
	// Returns: HttpResponse of request sent to the endpoint.     
    HttpResponse getRequest(String endpoint, Map<String, String> headers);
    
    // Description:  
	// Make a request to a endpoint passed as argument
    // using POST method. 
	//
	// Input: endpoint (URL address to send the request)
    //        headers (A map with parameters to be sed in header)
    //        body (Some object to send in the body of request)
	//
	// Returns: HttpResponse of request sent to the endpoint.    
    HttpResponse postRequest(String endpoint, Map<String, String> headers, String body);

}