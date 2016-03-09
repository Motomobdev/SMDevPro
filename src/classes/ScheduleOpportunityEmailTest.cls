/**
Author: Bineet Mishra
 Create Date: Nov 22, 2013 
 Description: Test class for ScheduleOpportunityEmailNotifications
 */
@isTest
private class ScheduleOpportunityEmailTest {

	static testmethod void TestScheduleOpportunityEmail() {
       Test.startTest();
       string exp = '';
       date curDate = date.today();
       exp = exp + '59 59 23 '+ curDate.day()+ ' ' + curDate.month() + ' ? ' + curDate.year();
       String jobId = System.schedule('ScheduleOpportunityEmailNotifications',
                exp,
                new ScheduleOpportunityEmailNotifications());
                  
       CronTrigger ct = [SELECT id, CronExpression, TimesTriggered, NextFireTime
           				 FROM CronTrigger 
           				 WHERE id = :jobId];
   
       System.assertEquals(exp,
       ct.CronExpression);
   
       System.assertEquals(0, ct.TimesTriggered);
         
       Test.stopTest();   
	} 
}