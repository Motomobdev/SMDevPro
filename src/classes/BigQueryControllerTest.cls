@isTest(SeeAllData=true)
public class BigQueryControllerTest{
    public static String queryResponse = '{"kind":"bigquery#queryResponse","schema":{"fields":[{"name":"JIRAID__c","type":"STRING","mode":"NULLABLE"}]},"totalRows":"2","rows":[{"f":[{"v":"1234"}]},{"f":[{"v":"5678"}]}],"jobComplete":true,"cacheHit":true}';

    /**************************************/
    //      Functional Tests              // 
    /**************************************/

    
    public static testMethod void testConstructor(){
        BigQueryController bcQ;
        String query = '{"query":"SELECT ISSUE_TYPE as ISSUE_TYPE__C,JIRAID as JIRAID__C,PKEY as Name,TARGET_STABLE_RELEASE as TARGET_STABLE_RELEASE__c,RESOLUTION as Resolution__c,ISSUE_STATUS as ISSUE_STATUS__c,DESCRIPTION as Description__c FROM [motorola.com:ds-prod:jira_idart.idart] Where SFDC_PROJECT_ID != \'\' AND LEFT(SFDC_PROJECT_ID,3) = \'a0R\' limit 10"}'; 

        // insert document for OAuth JWT
        Folder f = [Select id From Folder where type='Document' limit 1];
        Document d = new Document(FolderId=f.id,Name='Test Doc',Body=blob.valueOf(query),DeveloperName = 'Test_Doc');
        insert d;
        
        Test.startTest();
            bcQ = new BigQueryController('Test_Doc');
        Test.stopTest();
            
        System.assertNotEquals(bcQ,null);
        System.assertEquals(bcQ.query,query);
    }
    
    public static testMethod void testQueryBQ(){
        
        // insert document for OAuth JWT
        Folder f = [Select id From Folder where type='Document' limit 1];
        Document d = new Document(FolderId=f.id,Name='Test Private Key',Body=blob.valueOf(''),DeveloperName = 'Test_Private_Key');//[Select id,Body From Document Where DeveloperName = 'Google_Console_Public_Key'];
        insert d;
        
        // insert document for Query
        String query = '{"query":"SELECT ISSUE_TYPE as ISSUE_TYPE__C,JIRAID as JIRAID__C,PKEY as Name,TARGET_STABLE_RELEASE as TARGET_STABLE_RELEASE__c,RESOLUTION as Resolution__c,ISSUE_STATUS as ISSUE_STATUS__c,DESCRIPTION as Description__c FROM [motorola.com:ds-prod:jira_idart.idart] Where SFDC_PROJECT_ID != \'\' AND LEFT(SFDC_PROJECT_ID,3) = \'a0R\' limit 10"}'; 
        Document doc = new Document(FolderId=f.id,Name='Test Doc',Body=blob.valueOf(query),DeveloperName = 'Test_Doc');
        insert doc;
        
        BigQueryController bcQ = new BigQueryController('Test_Doc');
        
        Test.startTest();
            bcQ.queryBQ();
        Test.stopTest();
            
        System.assertEquals(bcQ.response.totalRows,2);
    }
    
    public static testMethod void testretrieveConvertedIssues(){
        
        // insert document for Query
        String query = '{"query":"SELECT ISSUE_TYPE as ISSUE_TYPE__C,JIRAID as JIRAID__C,PKEY as Name,TARGET_STABLE_RELEASE as TARGET_STABLE_RELEASE__c,RESOLUTION as Resolution__c,ISSUE_STATUS as ISSUE_STATUS__c,DESCRIPTION as Description__c FROM [motorola.com:ds-prod:jira_idart.idart] Where SFDC_PROJECT_ID != \'\' AND LEFT(SFDC_PROJECT_ID,3) = \'a0R\' limit 10"}'; 

        Folder f = [Select id From Folder where type='Document' limit 1];
        Document d = new Document(FolderId=f.id,Name='Test Doc',Body=blob.valueOf(query),DeveloperName = 'Test_Doc');
        insert d;
        
        BigQueryController bcQ = new BigQueryController('Test_Doc');
        bcQ.response = new BigQueryController.QueryResponse();
        bcQ.response.schema = (BigQueryController.BQSchema)JSON.deserialize('{"fields":[{"name":"JIRAID__c","type":"STRING","mode":"NULLABLE"}]}', BigQueryController.BQSchema.class);
        bcq.response.rows = (List<BigQueryController.BQRow>)JSON.deserialize('[{"f":[{"v":"1234"}]},{"f":[{"v":"4567"}]}]',List<BigQueryController.BQRow>.class );
        
        List<JIRA_Issue__c> returnedIssues = new List<JIRA_Issue__c>();
        
        Test.startTest();
            returnedIssues = bcQ.retrieveConvertedIssues();
        Test.stopTest();
            
        System.assertEquals(returnedIssues.size(),2);
    }
}