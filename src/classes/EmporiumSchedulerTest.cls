/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This test class contains methods to test if the 
// scheduler class is able to schedule the Emporium data
// importing.
/**********************************************************/
@isTest
public class EmporiumSchedulerTest{

    // Description:
	// This test case submit a schedule to run the 
    // EmporiumScheduler class and then checks the job
    // has been created.
	//
	// Last Modified: 03/20/2014
    public static testMethod void testEmporiumScheduler(){
        
        // Execution
        Test.startTest();
        String cron = '0 5 * * 1-12 ? *';
		String jobId = System.schedule('testBasicScheduledApex', cron, new EmporiumScheduler());        
		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        Test.stopTest();        
        
        // Assertions
        System.assertEquals(cron, ct.CronExpression);
        
    }

}