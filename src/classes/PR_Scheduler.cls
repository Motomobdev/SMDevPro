/**
 * @author          Gangadhar Rachakonda
 * @version         1.0 BETA
 * @date            8/6/2014
 * @description     This is a scheduler class which invokes the PR_Batch class.
*/
global with sharing class  PR_Scheduler  implements schedulable
{
    /**
     * @author           Gangadhar Rachakonda 
     * @version          1.0 
     * @date             8/6/2014
     * @description      The execute method instantiates the class that we want to schedule.
     * <p>               This method executes the specified scheduled job and processes 
     *                   the specified number of records.
     * </p>
     * @param            Schedulable Context
     */
   
      global void execute(SchedulableContext SC) 
      {
            PR_Batch  objBatch = new PR_Batch ();
            objBatch.sendRangingRecords();
      }
      
}