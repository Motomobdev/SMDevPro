@isTest
public class ApplicationDownloadStatsTest{

    public static testMethod void testbulkUpload(){
        Application__c testApp = new Application__c(Name='Test App');
        insert testApp;

    	String jsonOverallString = '[{"Application__c":"'+testApp.id+'","daily_device_uninstalls__c": "1666", "current_device_installs__c": "557519", "daily_user_uninstalls__c": "1544", "daily_device_upgrades__c": "10", "total_user_installs__c": "557230", "current_user_installs__c": "553286", "daily_device_installs__c": "33543", "daily_user_installs__c": "42586", "uniqueID__c": "20131113a074000000GzwnAAAR", "date__c": "2013-11-13"}]';        
    	String jsonString = '[{"Application__c":"'+testApp.id+'","daily_device_uninstalls__c": "166", "current_device_installs__c": "357519", "daily_user_uninstalls__c": "154", "daily_device_upgrades__c": "0", "total_user_installs__c": "357230", "current_user_installs__c": "353286", "daily_device_installs__c": "13543", "daily_user_installs__c": "12586", "uniqueID__c": "20131113a074000000GzwnAAAR100205", "date__c": "2013-11-13", "Version__c": "100205"}]';
    	Map<ID,Application_Download_Stats__c> statMap;
        Map<ID,Application_Download_Stats__c> statOverallMap;
        
    	Test.startTest();
            String responseOverallString = ApplicationDownloadStats.bulkUpload('overall', jsonOverallString);
        	String responseString = ApplicationDownloadStats.bulkUpload('installs', jsonString);
			statOverallMap = (Map<ID,Application_Download_Stats__c>)JSON.deserialize(responseOverallString,Map<ID,Application_Download_Stats__c>.class);
        	statMap = (Map<ID,Application_Download_Stats__c>)JSON.deserialize(responseString,Map<ID,Application_Download_Stats__c>.class);
        Test.stopTest();
        
        System.assertEquals(1,statOverallMap.size());        
        System.assertEquals(1,statMap.size());
    }
    
}