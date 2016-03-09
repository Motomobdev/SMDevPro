/**
*Unit test for AutomateUserLicence_Scheduler
*/

@isTest
private class AutomateUserLicence_Scheduler_Test
{
     static testMethod void fnTest()
    {        
            test.startTest();
            SchedulableContext sc = null;
            AutomateUserLicence_Scheduler objpr = new AutomateUserLicence_Scheduler();
            objpr.execute(sc);
              
            test.stoptest();   
     }
 }