public class AndroidSubmissionController{

    /*
    public class submissionResults{
        public String fileName {get;set;}
        public String response {get;set;}
        public Boolean status {get;set;}
        public ID attchId {get;set;}
        
        public submissionResults(){
        }
    }
    
    public Android_Submission__c submission;
    public List<submissionResults> results {get;set;}
    public String attachmentId {get;set;}
    
    public AndroidSubmissionController(ApexPages.StandardController stdController){
    	submission = (Android_Submission__c)stdController.getRecord();
        results = new List<submissionResults>();
    }
    
    public PageReference submitFiles(){
    	List<Attachment> attachemnts = [Select id,Name,Body From Attachment Where ParentId = :submission.id AND Name like '%.zip'];
        for(Attachment attch: attachemnts){
            // Filter main CTS file
            if(attch.Name.startsWith('CTS') && !attch.Name.toLowerCase().contains('verif')) continue;
        	submissionResults result = new submissionResults();
            result.fileName = attch.Name;
            result.attchId = attch.Id;
            if(Test.isRunningTest()) result.response = '{}';
        	else result.response = APFE_Utility.submitFile(attch.Body);
            results.add(result);
        }
        
        return null;
    }
    
    public void submitSingleFile(){
    	submissionResults result;
        System.debug(attachmentId);
        for(submissionResults res: results){
        	if(res.attchid == ID.valueOf(attachmentId)) result = res;
        }
  
        if(result == null){
        	// Add error 
            return;
        }
        Attachment attch = [Select id,Name,Body From Attachment Where Id = :result.attchId];
        if(Test.isRunningTest()) result.response = '{}';
        else result.response = APFE_Utility.submitFile(attch.Body);
    }
    
    public PageReference done(){
        String decodedRetUrl = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('retUrl'), 'UTF-8');
    	PageReference p = new PageReference(decodedRetUrl);
        
        // Send email of Submission info
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String emailAddr = 'gram@motorola.com';
        String[] toAddresses = new String[] {emailAddr};
        mail.setToAddresses(toAddresses);
        mail.setSubject('APFE Submission: ID - '+submission.id);
        mail.setPlainTextBody(JSON.serialize(results));
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        return p.setRedirect(true);
    }
    */
}