/**
 * @author          Lipsa Mishra
 * @version         1.0 BETA
 * @date            11/25/2014
 * @description     This is a scheduler class which invokes the AutomateUserCreationFromCoreDirectory class.
*/
global with sharing class  AutomateUserFromCoreDir_Scheduler  implements schedulable
{
    /**
     * @description      The execute method instantiates the class that we want to schedule.
     * <p>               This method executes the specified scheduled job and processes 
     *                   the specified number of records.
     * </p>
     * @param            Schedulable Context
     */
   
      global void execute(SchedulableContext SC) 
      {
             AutomateUserCreationFromCoreDirectory objpr = new AutomateUserCreationFromCoreDirectory();
             objpr.process();
      }
      
}