/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 04/01/2014
// Last Modified: José Elias Araújo
// Last Modified by: 05/07/2014
//
// Description:
// Scheduler class that runs the code to import information
// from Emporium and save the data in the database.
// 
// Test Class: 
// 
/**********************************************************/
public class LaunchCalScheduler implements Schedulable{
	
	Integer initialPosition;
	
	public LaunchCalScheduler(Integer initialPosition){
		this.initialPosition = initialPosition;
	}
	
    public void execute(SchedulableContext SC) {
    	LaunchCalDataHandler.importData(initialPosition);
    	if (initialPosition > 0){
    		System.abortJob(sc.getTriggerId());
    	}  
   }
}