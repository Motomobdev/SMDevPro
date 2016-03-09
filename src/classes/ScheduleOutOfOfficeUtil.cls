global class ScheduleOutOfOfficeUtil implements Schedulable {
/*
Author: Bineet Mishra
Created Date: Nov 7, 2012
Description: Uses OutOfOfficeUtil class to process Out_of_Office records.
*/
    global void execute(SchedulableContext ctx) {  
        OutOfOfficeUtil outOfOffice = new OutOfOfficeUtil();
        integer batchSize = 10;
        Database.executeBatch(outOfOffice, batchSize);
    }
    
    static testmethod void TestScheduleOutOfOfficeUtil() {
      Test.startTest();
      string exp = '';
      date curDate = date.today();
      exp = exp + '59 59 23 '+ curDate.day()+ ' ' + curDate.month() + ' ? ' + curDate.year();
        String jobId = System.schedule('TestScheduleOutOfOfficeUtil',
                exp,
                 new ScheduleOutOfOfficeUtil());
                  
        CronTrigger ct = [SELECT id, CronExpression, TimesTriggered,
           NextFireTime
           FROM CronTrigger WHERE id = :jobId];
   
        System.assertEquals(exp,
           ct.CronExpression);
   
        System.assertEquals(0, ct.TimesTriggered);
         
     Test.stopTest();   
   }
}