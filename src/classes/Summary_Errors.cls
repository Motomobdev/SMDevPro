@RestResource(urlMapping='/Summary_Errors')
global class Summary_Errors{

    @HttpPost
    global static String addAttachment(String Submission_Errors){
        
        List<Submission_Error__c> errors = (List<Submission_Error__c>) JSON.deserialize(Submission_Errors, List<Submission_Error__c>.class);
        insert errors;
        
        return JSON.serialize(errors);
    }
    
}