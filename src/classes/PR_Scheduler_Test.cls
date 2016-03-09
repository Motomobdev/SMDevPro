/**
 * 
 * @author  : Gangadhar Rachakonda
 * Purpose  : Unit test for PR_Scheduler
 * @version : 0.1
 * @date    : 08/06/2014
 * @description :Unit test PR_Scheduler Class
 
 */
@isTest
private class PR_Scheduler_Test
{
     static testMethod void Execute()
    {
        
            Test.startTest();
            SchedulableContext sc = null;
            PR_Scheduler objpr = new PR_Scheduler();
            objpr.execute(sc);
              
            Test.stoptest();   
     }
 }