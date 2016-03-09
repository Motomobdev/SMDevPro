global class MeetingNotesReminderEmails implements Database.Batchable<sObject>,Database.Stateful {
    /*
     Author: Bineet Mishra
     Create Date: June 25, 2012 
     Description: Send email notifications to customer meetings owners if meeting notes not updated 
     * within 24 hours of the meeting start date.
    */ 
    
    static final string EmailTemplateName = 'Missing_Meeting_Notes_VF';
 
    public String query = 'SELECT Id, Name, Meeting_Start_Date__c, Meeting_End_Date__c, '
                        + 'Post_Meeting_Notes__c, Owner__c FROM Customer_Meeting__c';
 
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<sObject> scope) {
        Id EmailTemplateID = EmailUtility.FindEmailTemplateIDByDeveloperName(EmailTemplateName);
        for (SObject s : scope) {   
            Customer_Meeting__c CM = (Customer_Meeting__c)s;       
            
            if ((CM.Meeting_Start_Date__c.addDays(1) < date.today()) && CM.Post_Meeting_Notes__c == null) {
            
                Integer count = [SELECT count() from User WHERE isActive = true AND Id = :CM.Owner__c];
                if (count > 0)
                    EmailUtility.SendEmail(CM.Id, CM.Owner__c, EmailTemplateID);
            }
        }
    }
 
    global void finish(Database.BatchableContext info) {
    }
 
    static testmethod void TestMeetingNotesReminderEmails() {
    
        Account acct = new Account();
        acct.Name = 'CM test';
        insert acct;
         
        test.startTest();
        
        MeetingNotesReminderEmails MNRE = new MeetingNotesReminderEmails();
        MNRE.query = 'SELECT Id, Name, Meeting_Start_Date__c, Meeting_End_Date__c, Post_Meeting_Notes__c, Owner__c ' +
                     'FROM Customer_Meeting__c LIMIT 200';
        
        integer batchSize = 200;
        database.executebatch(MNRE, batchSize);   
              
        test.stopTest();
    } // end test method
}