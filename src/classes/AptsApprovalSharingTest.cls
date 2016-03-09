public with sharing class AptsApprovalSharingTest {
     static testMethod void testApprovalSharingTriggers(){
        Apttus__APTS_Agreement__c agmt = new Apttus__APTS_Agreement__c();
        insert agmt;
        Apttus_Approval__Approval_Process__c aProc = new Apttus_Approval__Approval_Process__c ();
        insert aproc;
        
        Apttus_Approval__ApprovalProcessInstance__c pInstance = new Apttus_Approval__ApprovalProcessInstance__c();
        pInstance.Apttus_Approval__ApprovalProcessId__c = aproc.id;
        pInstance.Apttus_Approval__BusinessObjectId__c = agmt.id;
        pInstance.Apttus_Approval__Status__c = 'Not Submitted';
        pInstance.Apttus_Approval__BusinessObjectType__c = 'Apttus__APTS_Agreement__c';
        insert pInstance;
        
        Apttus_Approval__Approval_Request__c areq = new Apttus_Approval__Approval_Request__c();
        areq.Apttus_Approval__ProcessInstanceId__c = pInstance.id;
        areq.Apttus_Approval__Assigned_To_Type__c= 'User';
        areq.Apttus_Approval__Assigned_To_Id__c = UserInfo.getUserId();
        areq.Apttus_Approval__Approval_Status__c = 'Not Submitted';
        areq.Apttus_Approval__Related_Agreement__c = agmt.id;
        insert areq;
        
        areq.Apttus_Approval__Approval_Status__c = 'Assigned';
        update areq; 

        pInstance.Apttus_Approval__Status__c = 'Submitted';
        update pInstance;
        areq.Apttus_Approval__Approval_Status__c = 'Reassigned';
        update areq; 
    }
    

}