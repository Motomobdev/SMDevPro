@isTest
public class testGPSFileUpload{

    public static testMethod void testConstructor(){
        Test.startTest();
        	GPSFileUpload gfu = new GPSFileUpload();
        Test.stopTest();
    }
    
    public static testMethod void testEmptyApplicationDownloadStats(){
    	List<Application_Download_Stats__c> stats = new List<Application_Download_Stats__c>();
        GPSFileUpload gfu;
        Test.startTest();
        	 gfu = new GPSFileUpload();
        Test.stopTest();
        
        List<Application_Download_Stats__c> gfuStats = gfu.getApplication_Download_Stats();
        
        system.assertEquals(stats.size(),gfustats.size());
        
    }
    
    // needs updating
    public static testMethod void testNonEmptyApplicationDownloadStats(){
    	List<Application_Download_Stats__c> stats = new List<Application_Download_Stats__c>();
        GPSFileUpload gfu;
        Test.startTest();
        	 gfu = new GPSFileUpload();
        Test.stopTest();
        
        List<Application_Download_Stats__c> gfuStats = gfu.getApplication_Download_Stats();
        
        system.assertEquals(stats.size(),gfustats.size());
    }
    
    public static testMethod void assignApplication(){
    	GPSFileUpload gfu = new GPSFileUpload();
        Test.startTest();
        	 gfu.assignApplication();
        Test.stopTest();
    
    	System.assertEquals(true, gfu.hasApplication);
    }
    
    public static testMethod void testinsertOverallStats(){
        GPSFileUpload gfu = new GPSFileUpload();
        
        Test.startTest();
        	 gfu.insertOverallStats();
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages());
    }
    
    public static testMethod void testAddAppVersion(){
        GPSFileUpload gfu = new GPSFileUpload();
        
        Test.startTest();
        	 gfu.AddAppVersion();
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages());
    }
    
    public static testMethod void testAddCarrier(){
        GPSFileUpload gfu = new GPSFileUpload();
        
        Test.startTest();
        	 gfu.AddCarrier();
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages());
    }
    
    public static testMethod void testAddCountry(){
        GPSFileUpload gfu = new GPSFileUpload();
        
        Test.startTest();
        	 gfu.AddCountry();
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages());
    }
    
    public static testMethod void testAddDevice(){
        GPSFileUpload gfu = new GPSFileUpload();
        
        Test.startTest();
        	 gfu.AddDevice();
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages());
    }
    
    public static testMethod void testAddLanguage(){
        GPSFileUpload gfu = new GPSFileUpload();
        
        Test.startTest();
        	 gfu.AddLanguage();
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages());
    }
    
    public static testMethod void testAddFinalStats(){
        GPSFileUpload gfu = new GPSFileUpload();
        
        Test.startTest();
        	 gfu.AddFinalStats();
        Test.stopTest();
        
        System.assert(!ApexPages.hasMessages());
    }
    
    // unit test
    public static testMethod void unitTestConvertDate(){
    
        String[] dates = new List<String>();
        dates.add('20140301');
        dates.add('20120506');
        dates.add('20130301');
        dates.add('20120202');
        dates.add('20160907');
        dates.add('19831213');
        
        Set<Date> resultingDates = new Set<Date>();
        Test.startTest();
        	for(String d: dates){
        		resultingDates.add(GPSFileUpload.convertDate(d));
            }
        Test.stopTest();
        
    }
    
    public static testMethod void unitTestGetUniqueID(){
    	GPSFileUpload.GPSappVersion app = new GPSFileUpload.GPSappVersion();
        app.daily_avg_rating = 1;
        app.total_avg_rating = 1;
        app.dateString = '20130101';
        app.daily_user_installs = 1;
        app.total_user_installs = 1;
        app.current_user_installs = 1;
        app.daily_user_uninstalls = 1;
        app.current_device_installs = 1;
        app.daily_device_installs = 1;
        app.daily_device_upgrades = 1;
        app.daily_device_uninstalls = 1;
        
        app.app_version = 'version1';
        app.carrier = 'version1';
        app.country = 'version1';
        app.device = 'version1';
        app.language = 'version1';
        app.os_version = 'version1';
        
        String uniqueID;
        
        Test.startTest();
        	uniqueID = GPSFileUpload.getUniqueID(app,'1002039482093874');
        Test.stopTest();
        
        System.assertEquals('201301011002039482093874version1version1version1version1version1version1',uniqueID);
    }
    
     public static testMethod void testUpdateFields(){
     
        Application__c testApp = new Application__c(Name='TestApp');
        insert testApp; 
         
        Application_Download_Stats__c appDownload = new Application_Download_Stats__c(Application__c=testApp.id);
         insert appDownload;
        
        GPSFileUpload.GPSappVersion app = new GPSFileUpload.GPSappVersion();
        app.daily_avg_rating = 1;
        app.total_avg_rating = 1;
        app.dateString = '20130101';
        app.daily_user_installs = 1;
        app.total_user_installs = 1;
        app.current_user_installs = 1;
        app.daily_user_uninstalls = 1;
        app.current_device_installs = 1;
        app.daily_device_installs = 1;
        app.daily_device_upgrades = 1;
        app.daily_device_uninstalls = 1;
        
        app.app_version = 'version1';
        app.carrier = 'version1';
        app.country = 'version1';
        app.device = 'version1';
        app.language = 'version1';
        app.os_version = 'version1'; 
         
     	Test.startTest();
        	GPSFileUpload.updateFields(appDownload,app, null, null); 
        Test.stopTest();
     
     }
    
}