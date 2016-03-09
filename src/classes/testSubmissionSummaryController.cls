@isTest
public class testSubmissionSummaryController{
	
    public static testMethod void testGetSummaryJSONWithNoSummaryObjects(){
    	
        Device__c device = new Device__c(Name='Test Device');
        insert device;
        
        Google_TA__c testTA = new Google_TA__c(Name='Test TA',Device__c=device.id);
        insert testTA;
        
        Android_Submission__c testSubmission = new Android_Submission__c(Google_TA__c=testTA.id);
        insert testSubmission;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testSubmission);
        
        SubmissionSummaryController ctrlr = new SubmissionSummaryController(stdController);
        
        String json;
        Test.startTest();
        	json = ctrlr.getSummaryJSON();
        Test.stopTest();
    
    	System.assertEquals('[]', json);
    }
    
}