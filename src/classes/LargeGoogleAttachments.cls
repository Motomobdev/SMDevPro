@RestResource(urlMapping='/LargeAttachments')
global class LargeGoogleAttachments{

    @HttpPost
    global static String addAttachment(String attachmentID,String filename, String base64Encoded){
        
        Attachment oldAttachments = new Attachment(ParentID=attachmentID,NAme=filename,body=EncodingUtil.base64Decode(base64Encoded));
        insert oldAttachments;
        
        return '{"filename":"'+filename+'","Id":"'+oldAttachments.id+'"}';
    }
    
}