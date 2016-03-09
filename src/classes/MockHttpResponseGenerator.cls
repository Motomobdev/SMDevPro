@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://app.informaticaondemand.com/saas/api/1/runjob',
             req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/xml');
        res.setBody('<RunJobResponse>' +
               '<errorCode>NO_ERROR</errorCode>' +
               '<errorMsg/>' +
               '<success>true</success> ' +
               '</RunJobResponse>');
        res.setStatusCode(200);
        return res;
    }
}