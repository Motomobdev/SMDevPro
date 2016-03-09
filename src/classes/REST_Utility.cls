public with sharing class REST_Utility {

	public REST_Utility(){
		
	}

	/*	callAPI - return the API repsonse from a URL  
	 *	Parameters:
	 *		method - GET or POST
	 *		endpoint - URL for request
	 *		headers - Map of header name to header text
	 *		body - text to send in the body of the request
	 */
	public static String callAPI(String method,String endpoint, String body, Map<String, String> headers){

		HttpRequest req = new HttpRequest();
		req.setEndPoint(endpoint);
		req.setMethod(method);
        req.setTimeout(30000);

		if(method == 'PUT' || method == 'POST' || method == 'DELETE')	req.setBody(body);

		for(String headerName: headers.keySet()){
			req.setHeader(headerName, headers.get(headerName));
			System.debug(headerName+ ': ' + headers.get(headerName));
		}

		Http http = new Http();
        HTTPResponse res;
        
        if(Test.isRunningTest()) return '{}';
        res = http.send(req);
        
        //System.debug(res.getBody());
        
        return res.getBody(); 
	}
	
    /*	callAPI - return the API repsonse from a URL  
	 *	Parameters:
	 *		method - GET or POST
	 *		endpoint - URL for request
	 *		headers - Map of header name to header text
	 *		body - binary file to be sent over
	 */
	public static String callAPI(String method,String endpoint, Blob body, Map<String, String> headers){

		HttpRequest req = new HttpRequest();
		req.setEndPoint(endpoint);
		req.setMethod(method);

		if(method == 'PUT' || method == 'POST' || method == 'DELETE')	req.setBodyAsBlob(body);

		for(String headerName: headers.keySet()){
			req.setHeader(headerName, headers.get(headerName));
			System.debug(headerName+ ': ' + headers.get(headerName));
		}

		Http http = new Http();
        HTTPResponse res;
        
        if(Test.isRunningTest()) return '{}';
        res = http.send(req);
        
        //System.debug(res.getBody());
        
        return res.getBody(); 
	}
    
	/*	callAPI - return the API repsonse from a URL  
	 *	Parameters:
	 *		method - GET or POST
	 *		endpoint - URL for request
	 *		body - text to send in the body of the request
	 */
	public static String callAPI(String method,String endpoint, String body){

		HttpRequest req = new HttpRequest();
		req.setEndPoint(endpoint);
		req.setMethod(method);

		if(method == 'PUT' || method == 'POST' || method == 'DELETE')	req.setBody(body);

		Http http = new Http();
        HTTPResponse res;
        
        if(Test.isRunningTest()) return '{}';
        res = http.send(req);
        
        return res.getBody(); 
	}

}