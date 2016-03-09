@isTest
public class AndroidSubmissionControllerTest{
/*
    public static testMethod void testConstructor(){
    
        Device__c testDevice = new Device__C(Name='Test Device', SWBOM_Reviewed_and_Approved__c='Yes',SW_BOM_List_Approver__c=UserInfo.getUserId());
        insert testDevice;
        Google_TA__c testGoogleTA = new Google_TA__c(Device__c=testDevice.id);
        insert testGoogleTA;
        Android_Submission__c testSubmission = new Android_Submission__c(Google_TA__c=testGoogleTA.id);
        insert testSubmission;
        
        List<Attachment> attachments = new List<Attachment>();
        for(Integer count = 0; count < 1; count++){
        	attachments.add(new Attachment(ParentId=testSubmission.id,Body=Blob.valueOf('Test Body'),Name='Test Attachmet['+count+'].zip'));
        }
 		insert attachments;       
        Test.startTest();
        	ApexPages.StandardController stdController = new ApexPages.StandardController(testSubmission);
        	AndroidSubmissionController testasc = new AndroidSubmissionController(stdController);
        Test.stopTest();
        
    }
    
    public static testMethod void testSubmitFiles(){
    
        Device__c testDevice = new Device__C(Name='Test Device', SWBOM_Reviewed_and_Approved__c='Yes',SW_BOM_List_Approver__c=UserInfo.getUserId());
        insert testDevice;
        Google_TA__c testGoogleTA = new Google_TA__c(Device__c=testDevice.id);
        insert testGoogleTA;
        Android_Submission__c testSubmission = new Android_Submission__c(Google_TA__c=testGoogleTA.id);
        insert testSubmission;
        
        List<Attachment> attachments = new List<Attachment>();
        for(Integer count = 0; count < 1; count++){
        	attachments.add(new Attachment(ParentId=testSubmission.id,Body=Blob.valueOf('Test Body'),Name='Test Attachmet['+count+'].zip'));
        }
 		insert attachments;   
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testSubmission);
        AndroidSubmissionController testasc = new AndroidSubmissionController(stdController);
        Test.startTest();
        	testasc.submitFiles();
        Test.stopTest();
        
        System.assertNotEquals(null,testasc);
        System.assertEquals(1,testasc.results.size());
        
    }
    
    public static testMethod void testSubmitSingleFile(){
    
        Device__c testDevice = new Device__C(Name='Test Device', SWBOM_Reviewed_and_Approved__c='Yes',SW_BOM_List_Approver__c=UserInfo.getUserId());
        insert testDevice;
        Google_TA__c testGoogleTA = new Google_TA__c(Device__c=testDevice.id);
        insert testGoogleTA;
        Android_Submission__c testSubmission = new Android_Submission__c(Google_TA__c=testGoogleTA.id);
        insert testSubmission;
        
        List<Attachment> attachments = new List<Attachment>();
        for(Integer count = 0; count < 1; count++){
        	attachments.add(new Attachment(ParentId=testSubmission.id,Body=Blob.valueOf('Test Body'),Name='Test Attachmet['+count+'].zip'));
        }
 		insert attachments;   
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testSubmission);
        AndroidSubmissionController testasc = new AndroidSubmissionController(stdController);
        testasc.submitFiles();
        
        Test.startTest();
        	testasc.attachmentId = testasc.results.get(0).attchID;
        	testasc.submitSingleFile();
        Test.stopTest();
        
    }
    
    public static testMethod void testDone(){
    
        Device__c testDevice = new Device__C(Name='Test Device', SWBOM_Reviewed_and_Approved__c='Yes',SW_BOM_List_Approver__c=UserInfo.getUserId());
        insert testDevice;
        Google_TA__c testGoogleTA = new Google_TA__c(Device__c=testDevice.id);
        insert testGoogleTA;
        Android_Submission__c testSubmission = new Android_Submission__c(Google_TA__c=testGoogleTA.id);
        insert testSubmission;
        
        List<Attachment> attachments = new List<Attachment>();
        for(Integer count = 0; count < 1; count++){
        	attachments.add(new Attachment(ParentId=testSubmission.id,Body=Blob.valueOf('Test Body'),Name='Test Attachmet['+count+'].zip'));
        }
 		insert attachments;       
        Test.startTest();
        	ApexPages.StandardController stdController = new ApexPages.StandardController(testSubmission);
        	Test.setCurrentPage(new PageReference('/apex/APFESubmission?id='+testSubmission.id+'&retUrl=%2F'+testSubmission.id));
        	AndroidSubmissionController testasc = new AndroidSubmissionController(stdController);
        	testasc.done();
        Test.stopTest();
        
    }
    */
}