@istest
public class CheckAutoApprovalTest {

    static testmethod void test() {
        Test.startTest();
        
        Device__c dev = new Device__c(Name='ELX UMTS - EMEA Germany Retail MR1-OS Upgrade', Device_ID__c='19732', Google_TA_Approval_Status__c='In Progress', GMS_Last_SW_Submitted__c='motorola/victara_retbr/victara:4.4.4/KXE21.187-54.1/2:user/release-keys');
        insert dev;

        CheckAutoApproval.PublicTestMethod('motorola/victara_retbr/victara:4.4.4/KXE21.187-54.1/2:user/release-keys');
        CheckAutoApproval.PublicTestMethod('');
        CheckAutoApproval.PublicTestMethod('abc');

        Test.stopTest();
    }
}