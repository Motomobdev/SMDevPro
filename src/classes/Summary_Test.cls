@isTest
public class Summary_Test{

    public static testMethod void testSummaryErrors(){
    	
        Device__c testDevice = new Device__c(Name='Test Device');
        insert testDevice;
        
        Google_TA__c testGoogleTA = new Google_TA__c(Device__c=testDevice.id);
        insert testGoogleTA;
        
        Android_Submission__c testAndroidSubmission = new Android_Submission__c(Google_TA__c=testGoogleTA.id);
        insert testAndroidSubmission;
        
        String SubmissionErrorJSON = '[{"Android_Submission__c":"'+testAndroidSubmission.id+'","Name":"FakeTestName","Name__c":"FakeTestName","Suite__c":"FakeTestSuite"}]';
        List<Submission_Error__c> errors = new List<Submission_Error__c>();
        
        
        Test.startTest();
        	errors = (List<Submission_Error__c>) JSON.deserialize(Summary_Errors.addAttachment(SubmissionErrorJSON), List<Submission_Error__c>.class);
        Test.stopTest();
        
    }
    
    public static testMethod void testSummarySummaries(){
    	
        Device__c testDevice = new Device__c(Name='Test Device');
        insert testDevice;
        
        Google_TA__c testGoogleTA = new Google_TA__c(Device__c=testDevice.id);
        insert testGoogleTA;
        
        Android_Submission__c testAndroidSubmission = new Android_Submission__c(Google_TA__c=testGoogleTA.id);
        insert testAndroidSubmission;
        
        String SubmissionSummaryJSON = '[{"Android_Submission__c":"'+testAndroidSubmission.id+'","Name":"FakeTestName","Total_Tests__c":100,"Number_of_Errors__c":5}]';
        List<Submission_Summary__c> summaries = new List<Submission_Summary__c>();
        
        
        Test.startTest();
        	 summaries = (List<Submission_Summary__c>) JSON.deserialize(Summary_Summaries.addAttachment(SubmissionSummaryJSON), List<Submission_Summary__c>.class);
        Test.stopTest();
        
    }
    
}