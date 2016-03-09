/**
 * Schedules a DevApp contract bulk update.
 * @author: Jimens Lima - jimens@motorola.com
 * @since: 06/25/15
 */
public class BOMDevAppContractScheduler implements Schedulable {
    
    private Set<ID> setOfIDS;
    
    public BOMDevAppContractScheduler(Set<ID> setOfIDS){
    	this.setOfIDS = setOfIDS;
    }
    
    public void execute(SchedulableContext ctx) {
        boolean breakLoop = false;
        
        while(!breakLoop){
            try{
                //reuse the same method that invoked this.
               	DevAppsOnBomSDWithExecutedContracts.calculatePercentOfExecutedContractsOnBomOrSDCardFromDeviceId(setOfIDS);
                System.abortJob(ctx.getTriggerId());
                breakLoop = true;
            }catch(Exception ex){
                System.debug('BOMDevAppContractScheduler.execute error: '+BOMUtils.getStackTrace(ex));
            }
        }
    }
}