global class ScheduleMeetingNotesReminderEmails implements Schedulable {
 
  global void execute(SchedulableContext ctx) {  
   
   MeetingNotesReminderEmails MNRE = new MeetingNotesReminderEmails();
   integer batchSize = 10;
   database.executebatch(MNRE, batchSize);
   
  } 
  
  static testmethod void TestScheduleMeetingNotesReminderEmails() {
      Test.startTest();
      string exp = '';
      date curDate = date.today();
      exp = exp + '59 59 23 '+ curDate.day()+ ' ' + curDate.month() + ' ? ' + curDate.year();
        String jobId = System.schedule('TestScheduleMeetingNotesReminderEmails',
                exp,
                 new ScheduleMeetingNotesReminderEmails());
                  
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered,
           NextFireTime
           FROM CronTrigger WHERE id = :jobId];
   
        System.assertEquals(exp,
           ct.CronExpression);
   
        System.assertEquals(0, ct.TimesTriggered);
         
     Test.stopTest();   
   }
}