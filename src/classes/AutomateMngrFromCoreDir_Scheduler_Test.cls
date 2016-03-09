/**
*Unit test for AutomateManagerFromCoreDir_Scheduler
*/

@isTest
private class AutomateMngrFromCoreDir_Scheduler_Test
{
     static testMethod void fnTest()
    {        
            test.startTest();
            SchedulableContext sc = null;
            AutomateManagerFromCoreDir_Scheduler objpr = new AutomateManagerFromCoreDir_Scheduler();
            objpr.execute(sc);
              
            test.stoptest();   
     }
 }