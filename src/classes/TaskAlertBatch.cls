global class TaskAlertBatch implements Database.Batchable<sObject> {
    public String query;
    public Date today;
    
    global TaskAlertBatch(String query, Date today) {
        this.query = query;
        this.today = today;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, list<Sobject> scope) {
        List<Task> tasks = (List<Task>)scope;
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Task task : tasks){
            if(task.ActivityDate.daysBetween(Date.today()) == -1){
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                email.setSubject('Task Email Reminder');
                email.setSaveAsActivity(false);
                email.setTargetObjectId(task.ownerId);
                String body = 'Dear ' + task.Owner.Name + ', <br /><br />Your task due date is approaching. Be sure to follow up on this task by updating the status or due date. <br />Subject: ' + task.Subject + '<br />Due Date: ' + task.ActivityDate + '<br />Status: ' + task.Status;
                email.setHtmlBody(body);
                emails.add(email);
            }
        }
        Messaging.sendEmail(emails);   
    }

    global void finish(Database.BatchableContext BC) {}
}