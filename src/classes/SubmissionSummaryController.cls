public class SubmissionSummaryController{

    public Android_Submission__c parent {get;set;}
    
    public SubmissionSummaryController(ApexPages.StandardController currentPage){
    	parent = (Android_Submission__c)currentPAge.getRecord();
    }
    
    public String getSummaryJSON(){
    	return JSON.serialize([Select id,Name, Total_Tests__c, Number_of_Errors__c From Submission_Summary__c Where Android_Submission__c = :parent.id ORDER BY Total_Tests__c DESC]);
    }
}