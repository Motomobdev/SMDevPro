trigger DeviceJIRAProjectTrigger on Device_JIRA_Project__c (before insert,after insert,before update,after update,before delete,after delete) {

    if(Trigger.isInsert && Trigger.isAfter){
    	JIRAProjectcontroller.getDeviceDates([Select id,LE_Date__c,SA_Date__c,TA_Date__c From JIRA_Project__c Where id IN (Select JIRA_Project__c From Device_JIRA_Project__c Where Id IN :Trigger.new)]);
    }
    
}