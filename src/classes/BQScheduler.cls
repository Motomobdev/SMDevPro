/**********************************************************/
// Created by: Gram Bischof
// Created Date: 05/21/2014
// Last Modified: Gram Bischof
// Last Modified by: 05/21/2014
//
// Description:
// A class to schedule the sync and upsert of JIRA Issue
// records parsed from Google Big Query.
// 
// Test Class:  
// BQSchedulerTest.cls
/**********************************************************/
public class BQScheduler implements Schedulable{
    
	public BigQueryController bqC;    
    
    public BQScheduler(String docName){
        bqC = new BigQueryController(docName);
    }
    
    public void upsertJIRAIssues(){
        bqC.queryBQ();
  		upsert bqC.retrieveConvertedIssues() JIRAID__c;
    }
    
    public void execute(SchedulableContext SC) {
  		upsertJIRAIssues();
  	}
}