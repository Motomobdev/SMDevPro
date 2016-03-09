/**
 * @author          Lipsa Mishra
 * @version         1.0 BETA
 * @date            10/3/2014
 * @description     This is a scheduler class which invokes the AutomateUserLicenceInactivation class.
*/
global with sharing class  AutomateUserLicence_Scheduler  implements schedulable
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
            AutomateUserLicenceInactivation objBatch = new AutomateUserLicenceInactivation();
            objBatch.process();
      }
      
}