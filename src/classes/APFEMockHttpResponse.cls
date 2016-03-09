@isTest
global class APFEMockHttpResponse implements HttpCalloutMock {
    
    global String responseMessage;
    global Integer statusCode;
    global Map<String,String> headers;
    
    global APFEMockHttpResponse(Integer statusCode, String body, Map<String,String> headers){
        this.responseMessage = body;
        this.statusCode = statusCode;
        this.headers = headers;
    }
    
    global HTTPResponse respond(HTTPRequest req) {    	
        // Create a fake response
        HttpResponse res = new HttpResponse();
        for(String header: headers.keySet()) res.setHeader(header, headers.get(header));
        res.setBody(responseMessage);
        res.setStatusCode(statusCode);
        return res;
    }

}