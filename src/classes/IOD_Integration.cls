public class IOD_Integration{

    /*
     * Test class: IOD_Integration_Test
     */
    
    public IOD_Integration() {

    }
    
    public PageReference init() {
        // Custom setting
        IOD_Integration_Account__c iod_account = IOD_Integration_Account__c.getInstance();
        
        if (iod_account == null) {
            ApexPages.Message myMsg =
                new ApexPages.Message(ApexPages.Severity.FATAL, 
                'Contact your administrator. [IOD_Integration_Account__c] custom setting is missing');
            ApexPages.addMessage(myMsg);
        } else {
            ApexPages.Message myMsg =
                new ApexPages.Message(ApexPages.Severity.INFO, 
                'Submitted job: ' + iod_account.job_name__c);
            ApexPages.addMessage(myMsg);
            
            runjob(iod_account.user_name__c, iod_account.password__c, iod_account.job_name__c,
            iod_account.job_type__c);
        }
        
        return null;
    }
    
    @future (callout=true)
    public static void runjob(String username, String password, String jobName, String jobType) {

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http(); 

        req.setEndpoint('https://app.informaticaondemand.com/saas/api/1/runjob');
        req.setMethod('POST');

        req.setBody('username='+EncodingUtil.urlEncode(username, 'UTF-8')+
                           '&password='+EncodingUtil.urlEncode(password, 'UTF-8')+
                           '&jobName='+EncodingUtil.urlEncode(jobName, 'UTF-8')+
                           '&jobType='+EncodingUtil.urlEncode(jobType, 'UTF-8')); 
        try {
            res = http.send(req);
        } catch(System.CalloutException e) {
            System.debug('Job Error: '+ e);
            System.debug(res.toString());
        }
    }
    
    
    
}