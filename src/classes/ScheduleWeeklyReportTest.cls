@isTest
private class ScheduleWeeklyReportTest {

    static testMethod void myUnitTest() {
       Test.startTest();
       string exp = '';
       date curDate = date.today();
       exp = exp + '59 59 23 '+ curDate.day()+ ' ' + curDate.month() + ' ? ' + curDate.year();
       String jobId = System.schedule('ScheduleWeeklyReport',
                exp,
                new ScheduleWeeklyReport());
                  
       CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime
           				 FROM CronTrigger 
           				 WHERE id = :jobId];
   
       System.assertEquals(exp,
       ct.CronExpression);
   
       System.assertEquals(0, ct.TimesTriggered);
         
       Test.stopTest();
    }
}