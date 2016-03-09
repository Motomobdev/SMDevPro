/**
*Unit test for AutomateUserFromCoreDir_Scheduler
*/

@isTest
private class AutomateUserFromCoreDir_Scheduler_Test
{
     static testMethod void fnTest()
    {        
            test.startTest();
            SchedulableContext sc = null;
            AutomateUserFromCoreDir_Scheduler objpr = new AutomateUserFromCoreDir_Scheduler();
            objpr.execute(sc);
              
            test.stoptest();   
     }
 }