/*************************************************************
  COMMENT: Testmethod for the InboundApprovalEmailClass class
**************************************************************/ 

@isTest(SeeAllData = false)

public class APTPS_InboundApprovalEmailClassTest{
    
    static testmethod void InboundApprovalEmail(){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.plainTextBody = 'Testing Testing Approval Request ID: 1234567891011121314';
        Messaging.InboundEnvelope envelope = new Messaging.InboundEnvelope();
        
        //First run should not find the approval email id
        APTPS_InboundApprovalEmailClass ae = new APTPS_InboundApprovalEmailClass();
        ae.handleInboundEmail(email, envelope);
        
        Apttus_Approval__Approval_Request__c a = new Apttus_Approval__Approval_Request__c(Apttus_Approval__DateAssigned__c = Date.Today());
        insert a;
        
        System.assertNotEquals(null, a.Id);
        
        Test.startTest();
        email.fromAddress = 'testmethod@testmethod.com';
        email.fromName = 'Testmethod';
        email.plainTextBody = 'Approved \r\n \r\n Approval Request ID:' + a.Id + '\r\n Approver User ID:' + UserInfo.getUserId();
        ae.handleInboundEmail(email, envelope);
        email.plainTextBody = 'Approved \r\n \r\n Approval Request ID:' + a.Id + '\r\n Approver User ID:123456';
        ae.handleInboundEmail(email, envelope);
        Test.stopTest();
    }
}