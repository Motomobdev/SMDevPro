public class ScheduleJIRAProjectDeviceUpdate implements Database.Batchable<sObject>,Schedulable{

    public String query;
    
    public ScheduleJIRAProjectDeviceUpdate(){
    	query = 'Select id,LE_Date__c,SA_Date__c,TA_Date__c From JIRA_Project__c';
    }
    
    public ScheduleJIRAProjectDeviceUpdate(String inputQuery){
    	query = inputQuery;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext info, List<sObject> scope){
    	JIRAProjectcontroller.getDeviceDates((List<JIRA_Project__c>)scope);
    }
    
    public void execute(SchedulableContext sc) {
      Database.executeBatch(this, 200);
    }
    
    public void finish(Database.BatchableContext BC){

    }
}