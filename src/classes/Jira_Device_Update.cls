/**
 * JIRA_Device Scheduler.
 * 
 * @since:  2/27/2015 
 * @author: Elias Queiroga - eliasq@motorola.com
 */
global class Jira_Device_Update implements Schedulable{
	global void execute(SchedulableContext ctx) {        
        try{
            JiraImporter jiraUpdate = new JiraImporter();
            jiraUpdate.pushJiraDevices();
            jiraUpdate.updateDevices();
        }catch(Exception e){
            System.debug('Jira_Device_Update exception:');
            System.debug(BOMUtils.getStackTrace(e));
        }
    }
}