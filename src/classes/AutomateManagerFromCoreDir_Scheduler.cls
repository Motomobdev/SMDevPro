/**
 * @author          Lipsa Mishra
 * @version         1.0 BETA
 * @date            1/5/2015
 * @description     This is a scheduler class which invokes the AutomateManagerUpdateFromCoreDirectory class.
*/
global with sharing class  AutomateManagerFromCoreDir_Scheduler  implements schedulable
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
            AutomateManagerUpdateFromCoreDirectory objBatch = new AutomateManagerUpdateFromCoreDirectory();
            objBatch.process();
      }
      
}