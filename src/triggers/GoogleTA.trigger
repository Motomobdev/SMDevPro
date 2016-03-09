trigger GoogleTA on Google_TA__c (before insert,after insert, before update, after update, before delete, after delete, after undelete) {

    if(Trigger.isUpdate && Trigger.isAfter){
        GoogleTAController.updatedSWProjectsWithApprovalDate(GoogleTAController.getApprovedRecords(Trigger.oldMap,Trigger.new));
    }
    
}