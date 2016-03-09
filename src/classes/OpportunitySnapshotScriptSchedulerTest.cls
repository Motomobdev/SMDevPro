@isTest
private class OpportunitySnapshotScriptSchedulerTest 
{

    static testMethod void myUnitTest() 
    {
        Test.startTest();
        
        String jobId = System.Schedule('testBasicScheduledApex', '0 0 0 * * ?', new OpportunitySnapshotScriptScheduler());
        
        Test.stopTest();
    }
}