/*************************************************************
  COMMENT: Trigger to process Approver and Comment when the 
           approval request record is updated
  Testmethod: InboundApprovalEmailClassTest
**************************************************************/  

trigger APTPS_ApproverandCommentTrigger on Apttus_Approval__Approval_Request__c (before update) {

    List<Apttus_Approval__Approval_Request__c> updateRequestList = new List<Apttus_Approval__Approval_Request__c>();
    
    for(Apttus_Approval__Approval_Request__c aa: trigger.new){
        if(aa.Apttus_Approval__Approval_Status__c != trigger.oldMap.get(aa.Id).Apttus_Approval__Approval_Status__c && aa.Apttus_Approval__Approval_Status__c != null && aa.Apttus_Approval__ApprovalFromEmail__c){
            updateRequestList.add(aa);
        }
    }
    
    if(!updateRequestList.isEmpty()){
        APTPS_ApproverandCommentClass.CheckApproverComment(updateRequestList);
    }
}