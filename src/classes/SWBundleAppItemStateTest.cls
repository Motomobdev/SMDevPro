@isTest
private class SWBundleAppItemStateTest 
{
    static testMethod void testBatchable() 
    {
        Application__c app1 = new Application__c(Name = 'Application 1');
        insert app1;
        
        SW_Bundle__c sb1 = new SW_Bundle__c(Name = 'SW Bundle 1');
        insert sb1;
        
        SW_Bundle_Application__c sba1 = new SW_Bundle_Application__c(Service_Type__c = sb1.Id, Application__c = app1.Id);
        insert sba1;
        
        Test.startTest();
        
        SWBundleAppItemState sb = new SWBundleAppItemState();
        Database.executeBatch(sb);
        
        Test.stopTest();
    }
            
    static testMethod void testSchedulable() 
    {
        final String CRON_EXP = '0 0 0 1 1 ? 2050';
        
        Test.startTest();
        
        // Schedule the test job

        String jobId = System.schedule('testScheduledApex', CRON_EXP, new SWBundleAppItemStateSchedule());
        
        // Get the information from the CronTrigger API object

        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger 
                          WHERE id = :jobId];

        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);

        // Verify the next time the job will run
        System.assertEquals('2050-01-01 00:00:00', String.valueOf(ct.NextFireTime));
        
        Test.stopTest();
    }
}