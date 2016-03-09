/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 05/28/2014
//
// Description:
// This class is able to send HTTP requests to a endpoint.
// It contains two methods to attend Get and Post methods.
// 
// Test Class: 
// EmporiumCalloutTest.cls
/**********************************************************/
public class EmporiumCallout implements CalloutClass{
    
    private static Http http = new Http();        
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
	// Make a request to a endpoint passed as argument
    // using GET method. 
	//
	// Input: endpoint (URL address to send the request)
    //        headers (A map with parameters to be sed in header)
	//
	// Returns: HttpResponse of request sent to the endpoint.    
    public HttpResponse getRequest(String endpoint, Map<String, String> headers){
        HttpRequest req = new HttpRequest();
        req.setTimeout(this.timeout);
        
	    HttpResponse res = new HttpResponse();       
            
    	req.setEndpoint(endpoint);
        Set<String> fields = headers.keySet();
        for(String field : fields){
	       req.setHeader(field, headers.get(field));            
        }
	    req.setMethod('GET');
    	req.setCompressed(true); 
        
        if(!Test.isRunningTest()){
		    res = http.send(req);
        }else{
            res.setBody('OK - ' + endpoint);
            res.setStatusCode(200);
        	for (String field : fields) {
	            res.setHeader(field, headers.get(field));            
        	}
        }

	    return res; 
    }

    // Description:  
	// Make a request to a endpoint passed as argument
    // using POST method. 
	//
	// Input: endpoint (URL address to send the request)
    //        headers (A map with parameters to be sed in header)
    //        body (Some object to send in the body of request)
	//
	// Returns: HttpResponse of request sent to the endpoint.      
    public HttpResponse postRequest(String endpoint, Map<String, String> headers, String body){
        HttpRequest req = new HttpRequest();
        req.setTimeout(this.timeout);
        
	    HttpResponse res = new HttpResponse();
             
    	req.setEndpoint(endpoint);
        Set<String> fields = headers.keySet();
        for(String field : fields){
	        req.setHeader(field, headers.get(field));            
        }
        req.setBody(body);
	    req.setMethod('POST');
    	req.setCompressed(true); 
		
        Integer attempts = 0;
        while (attempts < 3){
            try{
                if(!Test.isRunningTest()){
                    res = http.send(req);
                    attempts = 3;
                }else{
                    res.setBody(body);
                    res.setStatusCode(200);
                    for(String field : fields){
                        res.setHeader(field, headers.get(field));            
                    }
                    attempts = 3;
                }
            }catch(Exception e){
                attempts++;
                if (attempts == 3){
                    throw new EmporiumException('Emporium is not able to retrieve data.');
                }
            }
        }

	    return res;
    }

}