trigger AIFApprovalTrigger on DeviceApplicationAssoc__c (before insert) {
   AIFApproval.setAIFApprovers(Trigger.new);
}