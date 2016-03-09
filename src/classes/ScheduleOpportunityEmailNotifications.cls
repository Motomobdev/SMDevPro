global class ScheduleOpportunityEmailNotifications implements Schedulable {
/**
Author: Bineet Mishra
Create Date: Nov 22, 2013 
Description: Schedule Email Notification for Opportunity.
 */
	global void execute(SchedulableContext ctx) {     
    	OpportunityEmailNotifications OEN = new OpportunityEmailNotifications();
    	integer batchSize = 10;
    	database.executebatch(OEN, batchSize);   
  }
}