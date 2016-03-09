@RestResource(urlMapping='/encodedKey')
global class APFE_KEY{ 

    @HttpPost
    global static String encodedPrivateKey(String DevName){
        Document d = [Select id,Body,Name,DeveloperName From Document Where DeveloperName = :DevName];
        String filebody = EncodingUtil.base64Encode(d.body);
        return filebody;
    }
    
}