/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 02/13/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/18/2014
//
// Description:
// Scheduler class that runs the code to import information
// from Emporium and save the data in the database.
// 
// Test Class: 
// 
/**********************************************************/
global class EmporiumScheduler implements Schedulable{
    global void execute(SchedulableContext SC) {
    	EmporiumDataHandler.pullAndSave();  
   }
}