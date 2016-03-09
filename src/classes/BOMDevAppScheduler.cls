/**
 * Schedules a DevApp records insertion.
 * @author: Jimens Lima - jimens@motorola.com
 * @since: 01/19/15
 */
public class BOMDevAppScheduler implements Schedulable {
    
    private List<DeviceApplicationAssoc__c> devApps;

    public BOMDevAppScheduler(List<DeviceApplicationAssoc__c> devApps){
        this.devApps = devApps;
    }
    
	/**
	 * Insert a sublist of DevApp's.
	 */    
    public void execute(SchedulableContext ctx) {
        boolean breakLoop = false;
        
        while(!breakLoop){
            try{
                insert this.devApps;
                System.abortJob(ctx.getTriggerId());
                breakLoop = true;
            }catch(Exception ex){
                System.debug('BOMDevAppScheduler.execute error: '+BOMUtils.getStackTrace(ex));
                //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()); 
                //ApexPages.addMessage(msg);
            }
        }
    }
}