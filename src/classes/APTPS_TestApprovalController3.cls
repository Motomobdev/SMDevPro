@isTest
public with sharing class APTPS_TestApprovalController3 {

    static testMethod void myUnitTest() {
    
    Apttus_Approval__Approval_Request__c newapprequest = new Apttus_Approval__Approval_Request__c(APTPS_Is_Suspended__c=false);
        
        // STEP 8 - Create the controller
        PageReference currPage = Page.APTPS_ApprovalAction;
        
           Test.setCurrentPage(currPage);
           
           APTPS_ApprovalController3 controller1 = new APTPS_ApprovalController3(new ApexPages.StandardController(newapprequest));
           
            // Test preview mode of the controller
        PageReference newPage1 = controller1.doSuspend();
        
    
    
    }
    
}