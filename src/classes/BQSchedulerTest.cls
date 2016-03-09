@isTest(SeeAllData=true)
public class BQSchedulerTest{

    public static testMethod void testConstructor(){
        
        // insert document for OAuth JWT
        Folder f = [Select id From Folder where type='Document' limit 1]; 
        Document d = new Document(FolderId=f.id,Name='Test Private Key',Body=blob.valueOf(''),DeveloperName = 'Test_Private_Key');//[Select id,Body From Document Where DeveloperName = 'Google_Console_Public_Key'];
        insert d;
        
        // insert document for Query
        String query = '{"query":"SELECT ISSUE_TYPE as ISSUE_TYPE__C,JIRAID as JIRAID__C,PKEY as Name,TARGET_STABLE_RELEASE as TARGET_STABLE_RELEASE__c,RESOLUTION as Resolution__c,ISSUE_STATUS as ISSUE_STATUS__c,DESCRIPTION as Description__c FROM [motorola.com:ds-prod:jira_idart.idart] Where SFDC_PROJECT_ID != \'\' AND LEFT(SFDC_PROJECT_ID,3) = \'a0R\' limit 10"}'; 
        Document doc = new Document(FolderId=f.id,Name='Test Doc',Body=blob.valueOf(query),DeveloperName = 'Test_Doc_Sched');
        insert doc;
        
        Test.startTest();
            BQScheduler bqS = new BQScheduler(doc.DeveloperName);
            String sch = '0 0 0 3 9 ? 2099';
            String jobID = system.schedule('Merge Job', sch, bqS);
        Test.stopTest();
    }
    
    public static testMethod void testConstructorWithQuery(){
        
        // insert document for OAuth JWT
        Folder f = [Select id From Folder where type='Document' limit 1];        
        Document d = new Document(FolderId=f.id,Name='Test Private Key',Body=blob.valueOf(''),DeveloperName = 'Test_Private_Key');//[Select id,Body From Document Where DeveloperName = 'Google_Console_Public_Key'];
        insert d;
        
        // query from BigQueryController
        String query = '{"query":"SELECT ISSUE_TYPE as ISSUE_TYPE__C,JIRAID as JIRAID__C,PKEY as Name,TARGET_STABLE_RELEASE as TARGET_STABLE_RELEASE__c,RESOLUTION as Resolution__c,ISSUE_STATUS as ISSUE_STATUS__c,DESCRIPTION as Description__c FROM [motorola.com:ds-prod:jira_idart.idart] Where SFDC_PROJECT_ID != \'\' AND LEFT(SFDC_PROJECT_ID,3) = \'a0R\' limit 10"}'; 
    
        // insert document for Query
        Document doc = new Document(FolderId=f.id,Name='Test Doc',Body=blob.valueOf(query),DeveloperName = 'Test_Doc_Sched');
        insert doc;
        
        Test.startTest();
            BQScheduler bqS = new BQScheduler(doc.DeveloperName);
            String sch = '0 0 0 3 9 ? 2099';
            String jobID = system.schedule('Merge Job', sch, bqS);
        Test.stopTest();
    }
    
    
}