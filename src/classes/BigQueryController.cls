/**********************************************************/
// Created by: Gram Bischof
// Created Date: 05/21/2014
// Last Modified: Gram Bischof
// Last Modified by: 05/21/2014
//
// Description:
// This creates a link between BQ through the APFESalesforce 
// Google App (located in Google Cloud console). This link 
// can perform synchronous queries through the API.
// 
// Test Class: 
// BigQueryControllerTest.cls
/**********************************************************/
 
public class BigQueryController{

    public String query {get;set;}
    public QueryResponse response {get;set;}
        
    public BigQueryController(String DocName){
       Document d = [Select id,Name,Body From Document Where DeveloperName = :DocName];
       query = d.Body.toString();//'{"query":"SELECT ISSUE_TYPE as ISSUE_TYPE__C,JIRAID as JIRAID__C,PKEY as Name,TARGET_STABLE_RELEASE as TARGET_STABLE_RELEASE__c,RESOLUTION as Resolution__c,ISSUE_STATUS as ISSUE_STATUS__c,DESCRIPTION as Description__c FROM [motorola.com:ds-prod:jira_idart.idart] Where SFDC_PROJECT_ID != \'\' AND LEFT(SFDC_PROJECT_ID,3) = \'a0R\' limit 10"}'; 
    }
     
    public void queryBQ(){
       APFE_Utility.TokenResponse token = APFE_Utility.getToken('https://www.googleapis.com/auth/bigquery');
        Map<String, String> headers = new Map<String, String>();
        headers.put('Authorization', 'Bearer '+token.access_token);
        headers.put('Content-Type', 'application/json');
        String res = REST_Utility.callAPI('POST','https://www.googleapis.com/bigquery/v2/projects/motorola.com%3Aapfesalesforce/queries', query, headers);
        if(Test.isRunningTest()) res = BigQueryControllerTest.queryResponse;
        response = (QueryResponse)JSON.deserialize(res, QueryResponse.class);
    }
    
    public List<JIRA_Issue__c> retrieveConvertedIssues(){
        List<JIRA_Issue__c> convertedIssues = new List<JIRA_Issue__c>();
        if(response == null) return convertedIssues;
        
        System.debug(response.rows.size());
        for(BQRow row: response.rows){
            // create JIRA_Issue__c as sObject
            sObject newIssue = (sObject)new JIRA_Issue__c();
            
            for(Integer itr=0;itr<row.f.size();itr++){
                newIssue.put(response.schema.fields[itr].name,row.f[itr].v);
            }
            
            convertedIssues.add((JIRA_Issue__c)newIssue);
        }
        
        return convertedIssues;
    }
    
    public class QueryResponse{
        public String kind {get;set;}
        public BQSchema schema {get;set;}
        public BQjobReference jobReference {get;set;}
        public Integer totalRows {get;set;}
        public List<BQRow> rows {get;set;}
        public Integer totalBytesProcessed {get;set;}
        public Boolean jobComplete {get;set;}
        public Boolean cacheHit {get;set;}
    }
    
    public class BQSchema{
        public List<BQFields> fields {get;set;}
    }
    
    public class BQFields{
        public String name {get;set;}
        public String type {get;set;}
        public String mode {get;set;}
    }
    
    public class BQjobReference{
        public String projectId {get;set;}
        public String jobId {get;set;}
    }
    
    public class BQRow{
        public List<BQValue> f {get;set;}
    }
    
    public class BQValue{
        public String v {get;set;}
    }
    
}