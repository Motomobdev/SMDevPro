public class APFE_Utility{

    // APFE scope "https://www.googleapis.com/auth/androidPartner"
    
    public static String DocumentName = 'Google_Console_Public_Key';
    
    public class TokenResponse{
        public String access_token;
  		public String token_type;
  		public Decimal expires_in;
    }
    
    public static TokenResponse getToken(String scope){
        if(Test.isRunningTest()) DocumentName = 'Test_Private_Key';
        Document d = [Select id,Body From Document Where DeveloperName = :DocumentName];
        String filebody = EncodingUtil.base64Encode(d.body);
        
        String jsonString = '{"base64encoded_Private_Key":"'+filebody+'","email":"501576318676-viea9qka844arsqntq021f0b6a1kicjd@developer.gserviceaccount.com","scope":"'+scope+'"}';
        system.debug(jsonString);
        
        // Set up HTTP callout objects
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        
        //Making the call out
        req.setEndpoint('http://sheltered-dawn-3577.herokuapp.com/api/v1.0/base64EncodedSignature');
        req.setMethod('POST');
        req.setHeader('Content-Type','application/json');
        req.setBody(jsonString);
        if(Test.isRunningTest()) return new TokenResponse();
        HTTPResponse res = http.send(req);
        system.debug('Response : '+res.getBody());
        
        String assertion = res.getBody();
        
        HttpRequest req2 = new HttpRequest();
        req2.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req2.setMethod('POST');
        //req2.setHeader('Content-Type','application/x-www-form-urlencoded');
        req2.setBody('grant_type='+EncodingUtil.urlEncode('urn:ietf:params:oauth:grant-type:jwt-bearer', 'UTF-8')+'&assertion='+assertion);
        System.debug(req2.getBody());
        res = http.send(req2);
        system.debug('Response : '+res.getBody());
  
        return (TokenResponse)JSON.deserialize(res.getBody(),TokenResponse.class);

    }
    
    public static String getBuildStatus(String Build, TokenResponse token){
        
        // Set up HTTP callout objects
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        
        req.setHeader('Authorization', 'Bearer '+token.access_token);
        req.setEndpoint('https://www.googleapis.com/androidpartner/v1/devices/build_status?buildFingerprint='+EncodingUtil.urlEncode(Build, 'UTF-8'));
        req.setMethod('GET');
		if(Test.isRunningTest()) return '{}';	
		HTTPResponse res = http.send(req);
        
        return res.getBody();
    }
    
    public static String submitFile(Blob file,TokenResponse responseToken){
    	
        Map<String, String> headers = new Map<String,String>();
        headers.put('Authorization','Bearer '+responseToken.access_token);
        headers.put('Content-Length', String.valueOf(file.size()));
        headers.put('Content-Type', 'application/octet-stream');
        //if(Test.isRunningTest()) return '{}';
        String result = REST_Utility.callAPI('POST', 'https://www.googleapis.com/upload/androidpartner/v1/devices?type=report',file,headers);
        
        return result;
    }
    
    public static TokenResponse createToken(){
        Google_API_Token__c gat = Google_API_Token__c.getInstance();
        if(gat.Expiration__c != null && gat.Expiration__c >= System.now()){
            return createTokenFromCustomSetting();
        }
        else return getToken('https://www.googleapis.com/auth/androidPartner');
    }
    
    public static void updateToken(TokenResponse responseToken){
    	Google_API_Token__c gat = [Select id,Name,Token__c,Expiration__c From Google_API_Token__c];
        system.debug(responseToken);
        gat.Token__c = responseToken.access_token;
       	if(responseToken.expires_in != null) gat.Expiration__c = System.now().addSeconds(Integer.valueOf(responseToken.expires_in) - 10); // 10 second buffer 
        System.debug(gat);
        update gat;    
    }
    
    public static TokenResponse createTokenFromCustomSetting(){
    	TokenResponse returnToken = new TokenResponse();
        Google_API_Token__c gat = Google_API_Token__c.getInstance();
        returnToken.access_token = gat.Token__c;
        return returnToken;
    }
    
    public class APFE_SubmitFile_Response{
        public String kind;
        public String approvalStatus;
        public APFE_SubmitFile_Error error;
    }
    
    public class APFE_SubmitFile_Error{
        public Integer code;
        public String message;
        public List<APFE_SubmitFile_Errors> errors;
    }
    
    public class APFE_SubmitFile_Errors{
        public String domain;
        public String reason;
        public String message;
    }
    
}