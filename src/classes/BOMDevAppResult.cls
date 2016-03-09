/**
 * This is an abstraction of DevApp result.
 * After DevApp bulk insertion, the number of inserted records, 
 * should be the same of selected device's times selected apps.
 * 
 * @author: Jimens Lima - jimens@motorola.com
 * @since: 21/01/2015
 */
public class BOMDevAppResult {

    public Set<ID> devIDs 		  {get;set;}
    public Set<ID> appIDs 		  {get;set;}
    public List<String> jobIDS 	  {get;set;}
    public Datetime scheduledTime {get;set;}
    public Decimal numberOfJobs   {get;set;}
    
    public BOMDevAppResult(){
        devIDs = new Set<ID>();
        appIDs = new Set<ID>();
    }
    
    public Integer getCount(){
		return devIDs.size() * appIDs.size();
    }
}