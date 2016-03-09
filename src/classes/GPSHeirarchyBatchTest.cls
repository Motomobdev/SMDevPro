@isTest
public class GPSHeirarchyBatchTest{
	
    public static testMethod void runBatchWithOverallRecordAndVersionRecords(){
        // create Application
        Application__c testApp = new Application__c(Name='Test App');
        insert testApp;
        
        // Create Application Download Stats
        // 
       	//
       	List<Application_Download_Stats__c> testAppDownloadStats = new List<Application_Download_Stats__c>();
        
        Integer numberOfOverallRecords = 1;
        Integer numberOfVersionRecordsPerOverall = 10;
        
        for(Integer OverallCount=0;OverallCount < numberOfOverallRecords; OverallCount++){
            String UniqueID = Date.today().year() + '01' + '01' + testApp.id;
            Application_Download_Stats__c overall = new Application_Download_Stats__c(Application__c=testApp.id,UniqueID__c=UniqueID,total_user_installs__c=OverallCount);
            testAppDownloadStats.add(overall);
            for(Integer versionCount=0;versionCount<numberOfVersionRecordsPerOverall;versionCount++) testAppDownloadStats.add(new Application_Download_Stats__c(Application__c=testApp.id,UniqueID__c=UniqueID+versionCount,total_user_installs__c=versionCount+OverallCount));
        }
        
        insert testAppDownloadStats;
        
        System.debug(testAppDownloadStats);
        
        // Run Batch
        Test.startTest();
        	Database.executeBatch(new GPSHeirarchyBatch());
        Test.stopTest();
        
       	testAppDownloadStats = [Select id,UniqueID__c,Application__c,Overall__c From Application_Download_Stats__c];
        for(Application_Download_Stats__c appStat: testAppDownloadStats){
            if(appStat.uniqueId__c.length() > 26) System.assertNotEquals(appStat.Overall__c, null);
            else System.assertEquals(appStat.Overall__c, null);
        }
    }
    
}