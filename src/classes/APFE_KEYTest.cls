@isTest
public class APFE_KEYTest{
	
    public static testMethod void testAPFE_KEY(){
        //Get Folder
        Folder f = [Select id From Folder Where Type='Document' limit 1];
        
        // Create Document
        Blob b = Blob.valueOf('Some text');
        Document d = new Document(Name='Google Private Key',DeveloperName='Google_Private_Key',Body=b,FolderId=f.Id);
        insert d;
        
        String returnValue;
        
        Test.startTest();
            returnValue = APFE_KEY.encodedPrivateKey('Google_Private_Key');
        Test.stopTest();
        
        System.assertEquals(EncodingUtil.base64Encode(b), returnValue);
    }
    
}