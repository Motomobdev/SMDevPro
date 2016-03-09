@isTest(seealldata=true)
public class testRESTandAPFEUtility{
    
    public static testMethod void testRESTCallAPI(){
        
        // Create mock callout response
        Map<String,String> Mockheaders = new Map<String,String>();
        Mockheaders.put('Content-Type','application/json');
        String responseMessage = '{}';
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new APFEMockHttpResponse(200,responseMessage,Mockheaders));
        
        Blob testBlob = Blob.valueOf('some values');
        Map<String,String> headers = new Map<String,String>();
        headers.put('Key','Value');
        
        Test.startTest();
            REST_Utility rest = new REST_Utility(); // Test construstor
            REST_Utility.callAPI('GET', 'http://www.test.com', 'Body');
            REST_Utility.callAPI('GET', 'http://www.test.com', 'Body',headers);
            REST_Utility.callAPI('GET', 'http://www.test.com', testBlob,headers);
        Test.stopTest();
    }
    
    
    public static testMethod void testGetBuildStatusWithoutCustomSetting(){
        /*Google_API_Token__c gat = new Google_API_Token__c();
        insert gat;
        
        Folder testFolder = [Select id From Folder Where Type='Document' limit 1];
        Document d = new Document(Name='Test Name',
                            DeveloperName = 'Google_Console_Public_Key',
                            body=Blob.valueOf('Body'),
                            FolderId=testFolder.id);
        insert d;*/
        
        // Create error mock callout
        Map<String,String> headers = new Map<String,String>();
        headers.put('Content-Type','application/json');
        String responseMessage = '{"error": {"errors": [{    "domain": "global","reason": "invalid","message": "Unable to query fingerprint status"}],"code": 400,  "message": "Unable to query fingerprint status" }}';
        
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new APFEMockHttpResponse(400,responseMessage,headers));
        
        // insert document for OAuth JWT
        Folder f = [Select id From Folder where type='Document' limit 1];
        Document d = new Document(FolderId=f.id,Name='Test Private Key',Body=blob.valueOf(''),DeveloperName = 'Test_Private_Key');//[Select id,Body From Document Where DeveloperName = 'Google_Console_Public_Key'];
        insert d;
        
        String response;
        
        Test.startTest();
            APFE_Utility.TokenResponse token = APFE_Utility.getToken('https://www.googleapis.com/androidpartner/');
            response = APFE_Utility.getBuildStatus('Build',token);
        Test.stopTest();
        
        System.assertEquals(response,'{}');
    }
    
    public static testMethod void testLargeGoogleAttachments(){
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
        String ParentId = String.valueOf(testAccount.id);
        String filename = 'Test File.txt';
        String base64Encoded = EncodingUtil.base64Encode(Blob.valueOf('Hello World'));
        
        String attchId;
        
        Test.startTest();
            attchId = LargeGoogleAttachments.addAttachment(ParentId, filename, base64Encoded);
        Test.stopTest();
        
        List<Attachment> attchs = [Select id,Body From Attachment Where ParentId = :ParentId];
        System.assertEquals(1, attchs.size());
        System.assertNotEquals(null,attchs.get(0).Id);
        System.assertEquals('{"filename":"'+filename+'","Id":"'+attchs.get(0).Id+'"}',attchId);
        System.assertEquals(base64Encoded,EncodingUtil.base64Encode(attchs.get(0).Body));
    }   
    
    public static testMethod void testSubClassConstructors(){
        
        Integer numOfErrors = 1;
 
        List<APFE_Utility.APFE_SubmitFile_Errors> errors = new List<APFE_Utility.APFE_SubmitFile_Errors>();
        for(Integer count = 0; count < numOfErrors; count++){
            APFE_Utility.APFE_SubmitFile_Errors newError = new APFE_Utility.APFE_SubmitFile_Errors();
            newError.domain = 'domain';
            newError.message = 'error';
            newError.reason = 'becuase I said so';
            errors.add(newError);
        }
        
        APFE_Utility.APFE_SubmitFile_Error error = new APFE_Utility.APFE_SubmitFile_Error();
        error.errors = errors;
        error.code = 400;
        error.message = 'error';
        
        APFE_Utility.APFE_SubmitFile_Response response = new APFE_Utility.APFE_SubmitFile_Response();
        response.error = error;
        response.kind = 'submitfile';
        response.approvalStatus = 'Pending';
        
        APFE_Utility.TokenResponse token = new APFE_Utility.TokenResponse();
        token.access_token = 'token';
        token.expires_in = 3600;
        token.token_type = 'Bearer';
    }
}