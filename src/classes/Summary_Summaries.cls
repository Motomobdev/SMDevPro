@RestResource(urlMapping='/Summary_Summaries')
global class Summary_Summaries{

    @HttpPost
    global static String addAttachment(String Summary_Summaries){
        
        //return Summary_Summaries;
        
        List<Submission_Summary__c> summaries = (List<Submission_Summary__c>) JSON.deserialize(Summary_Summaries, List<Submission_Summary__c>.class);
        insert summaries;
        
        return JSON.serialize(summaries);
    }
    
}