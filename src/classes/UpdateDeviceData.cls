@RestResource(urlMapping='/UpdateDevice')
global class UpdateDeviceData
{
    @HttpPost
    global static void updDeviceData(String submissionID)
    {
        System.debug('submissionID: ' + submissionID);

        Android_Submission__c sub = [select Google_TA__c from android_submission__c where id = :submissionID];
        System.debug('sub.Google_TA__c: ' + sub.Google_TA__c);

        Google_TA__c goo = [select Name, Device__c from Google_TA__c where id = :sub.Google_TA__c];
        System.debug('goo.Google_TA__c: ' + goo.Device__c);

        Device__c dev = [select name from Device__c where id = :goo.Device__c for update];
        System.debug('dev.name: ' + dev.name);
        
        dev.GMS_Last_SW_Submitted__c = goo.Name;
        dev.GMS_Submission_Status__c = 'Sent to Google';
        dev.CTS_Submission_Status__c = 'Sent to Google';
        dev.Google_TA_Approval_Status__c = 'In Progress';
        dev.Date_GMS_SW_Checklist_Sent_to_Google__c = Date.today();
        dev.Date_CTS_SW_Checklist_Sent_to_Google__c = Date.today();
        dev.Date_of_Google_TA_Approval_by_Google__c = null;
        dev.White_Listed_Build_Fingerprint__c = null;
        
        update dev;
    }
}