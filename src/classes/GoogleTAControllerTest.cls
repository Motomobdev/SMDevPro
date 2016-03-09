@isTest
public class GoogleTAControllerTest{

    
    public static testMethod void testUpdateRecordsWithAllApproved(){
        List<Device__c> devices = new List<Device__c>();
        Integer numOfDevices = 1;
        for( Integer count=0; count < numOfDevices; count++ ) devices.add(new Device__c(Name='Test Device - '+count));
        insert devices;
        
        List<Google_TA__c> googleTAs = new List<Google_TA__c>();
        for( Integer count=0; count < numOfDevices; count++ ) googleTAs.add(new Google_TA__c(Device__c=devices.get(count).Id));
        insert googleTAs;
        
        Test.startTest();
            for(Google_TA__c googleTA: googleTAs) googleTA.Approved__c = True;
            update googleTAs;
        Test.stopTest();
        
        devices = [Select id,Name,Date_of_Google_TA_Approval_by_Google__c,CTS_Submission_Status__c,Google_TA_Approval_Status__c From Device__c Where ID IN :devices];
        for(Device__c dev: devices){
            //System.assertEquals(dev.Date_of_Google_TA_Approval_by_Google__c,Null);
            System.assertEquals(dev.CTS_Submission_Status__c ,'Sent to Google');
            System.assertEquals(dev.Google_TA_Approval_Status__c ,'Completed');
        } 
    }
    
}