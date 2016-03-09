trigger JIRAPlanTrigger on JIRA_Plan__c (before insert,after insert,before update,after update,before delete,after delete) {

    if(Trigger.isBefore && Trigger.isUpdate){
        JIRAPlanController.checkFeatureIDHasBeenChanged(Trigger.oldMap,Trigger.new);
    }

    if(Trigger.isBefore && Trigger.isInsert){
        JIRAPlanController.transferFeatureProjectToPlan(Trigger.new);
    }

}