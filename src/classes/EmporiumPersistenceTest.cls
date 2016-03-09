/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/20/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This test class contains methods to test the features
// implemented in EmporiumPersistence class.
/**********************************************************/
@isTest
public class EmporiumPersistenceTest{

    // Description:
	// This test case checks if persistence class
    // is able to handle and save more than one record on salesforce
    // database.
	//
	// Last Modified: 03/20/2014
    public static testMethod void testSaveMoreThanOneApplicationStats(){
        // Setup
        Application__c customApp = new Application__c();
        customApp.Name = 'App1';
        customApp.Package_Name__c = 'com.motorola.package1';        
        insert customApp;
        
        Motorola_Core_Directory__c customCore = new Motorola_Core_Directory__c();
        customCore.Mail__c = 'user1@motorola.com';
        insert customCore;
        
        EmporiumApplicationDownloadStats stats = new EmporiumApplicationDownloadStats();
        Datetime dt1 = Datetime.newInstance(1393871001111L);
        stats.setDateLastDownloaded(dt1.date());
        stats.setNumberOfDownloads(10);
        stats.setPackageName('com.motorola.package1');
        stats.setUniqueID('ae3e46a8-322c-4dbc-8bb2-111111111');
        stats.setVersion('1');
        
        Application app = new Application();
        app.setName('App1');
        app.setPackageName('com.motorola.package1');
		stats.setApplication(app);

        MotorolaCoreDirectory core = new MotorolaCoreDirectory();
        core.setEmail('user1@motorola.com');
        stats.setUploadedBy(core);
        
        EmporiumApplicationDownloadStats stats2 = new EmporiumApplicationDownloadStats();
        dt1 = Datetime.newInstance(1393871001111L);
        stats2.setDateLastDownloaded(dt1.date());
        stats2.setNumberOfDownloads(15);
        stats2.setPackageName('com.motorola.package1');
        stats2.setUniqueID('ae3e46a8-322c-4dbc-8bb2-2222222222');
        stats2.setVersion('2');
        stats2.setApplication(app);
        stats2.setUploadedBy(core);
        
  		EmporiumPersistence model = new EmporiumPersistence();
        List<EmporiumApplicationDownloadStats> statList = new List<EmporiumApplicationDownloadStats>();
        statList.add(stats);
        statList.add(stats2);
        
        // Execution
        Test.startTest();
        boolean error = false;
        try{
	        model.save(statList);
        }catch(EmporiumException e){
            error = true;
        }
        Test.stopTest();   
        
        //String queryStmt = 'select ID, Version__c, UniqueID__c from Application_Download_Stats__c where UniqueID__c = "ae3e46a8-322c-4dbc-8bb2-111111111"';
        
        Application_Download_Stats__c[] appStats = [select ID, Version__c, UniqueID__c, Package_Name__c from Application_Download_Stats__c];

		boolean isEqual;

        // Assertions
        System.assertEquals(2, appStats.size());
        
        if (appStats.size() == 2){
        	Application_Download_Stats__c savedStats = appStats.get(0);
        	isEqual = savedStats.Package_Name__c == stats.getPackageName();
        	isEqual &= savedStats.UniqueID__c == stats.getUniqueID();
        	isEqual &= savedStats.Version__c == stats.getVersion();
        	
        	Application_Download_Stats__c savedStats2 = appStats.get(1);
        	isEqual = savedStats2.Package_Name__c == stats2.getPackageName();
        	isEqual &= savedStats2.UniqueID__c == stats2.getUniqueID();
        	isEqual &= savedStats2.Version__c == stats2.getVersion();
        }
        
        System.assert(isEqual);
    }


    // Description:
	// This test case checks if persistence class
    // is able to handle and save a record on salesforce
    // database.
	//
	// Last Modified: 03/20/2014
    public static testMethod void testSave(){
        // Setup
        Application__c customApp = new Application__c();
        customApp.Name = 'App1';
        customApp.Package_Name__c = 'com.motorola.package1';        
        insert customApp;
        
        Motorola_Core_Directory__c customCore = new Motorola_Core_Directory__c();
        customCore.Mail__c = 'user1@motorola.com';
        insert customCore;
        
        EmporiumApplicationDownloadStats stats = new EmporiumApplicationDownloadStats();
        Datetime dt1 = Datetime.newInstance(1393871001111L);
        stats.setDateLastDownloaded(dt1.date());
        stats.setNumberOfDownloads(10);
        stats.setPackageName('com.motorola.package1');
        stats.setUniqueID('ae3e46a8-322c-4dbc-8bb2-111111111');
        stats.setVersion('1');
        
        Application app = new Application();
        app.setName('App1');
        app.setPackageName('com.motorola.package1');
		stats.setApplication(app);

        MotorolaCoreDirectory core = new MotorolaCoreDirectory();
        core.setEmail('user1@motorola.com');
        stats.setUploadedBy(core);
        
  		EmporiumPersistence model = new EmporiumPersistence();
        List<EmporiumApplicationDownloadStats> statList = new List<EmporiumApplicationDownloadStats>();
        statList.add(stats);
        
        // Execution
        Test.startTest();
        boolean error = false;
        try{
	        model.save(statList);
        }catch(EmporiumException e){
            error = true;
        }
        Test.stopTest();   
        
        //String queryStmt = 'select ID, Version__c, UniqueID__c from Application_Download_Stats__c where UniqueID__c = "ae3e46a8-322c-4dbc-8bb2-111111111"';
        
        Application_Download_Stats__c[] appStats = [select ID, Version__c, UniqueID__c, Package_Name__c from Application_Download_Stats__c where UniqueID__c = 'ae3e46a8-322c-4dbc-8bb2-111111111'];

		boolean isEqual;

        // Assertions
        System.assertEquals(1, appStats.size());
        
        if (appStats.size() > 0){
        	Application_Download_Stats__c savedStats = appStats.get(0);
        	isEqual = savedStats.Package_Name__c == stats.getPackageName();
        	isEqual &= savedStats.UniqueID__c == stats.getUniqueID();
        	isEqual &= savedStats.Version__c == stats.getVersion();
        }
        
        System.assert(isEqual);
    }

    // Description:
	// This test case checks if the persistence class
    // converts a valid set of data to be used in 
    // data insertion process.
	//
	// Last Modified: 03/20/2014    
	public static testMethod void testConvertObjectsBeforeSave(){
				
        // Setup
        Application__c customApp = new Application__c();
        customApp.Name = 'App1';
        customApp.Package_Name__c = 'com.motorola.package1';        
        insert customApp;
        
        Motorola_Core_Directory__c customCore = new Motorola_Core_Directory__c();
        customCore.Mail__c = 'user1@motorola.com';
        insert customCore;        
        
        EmporiumApplicationDownloadStats stats = new EmporiumApplicationDownloadStats();
        Datetime dt1 = Datetime.newInstance(1393871001111L);
        stats.setDateLastDownloaded(dt1.date());
        stats.setNumberOfDownloads(10);
        stats.setPackageName('com.motorola.package1');
        stats.setUniqueID('ae3e46a8-322c-4dbc-8bb2-111111111');
        stats.setVersion('1');
        
        Application app = new Application();
        app.setName('App1');
        app.setPackageName('com.motorola.package1');
		stats.setApplication(app);

        MotorolaCoreDirectory core = new MotorolaCoreDirectory();
        core.setEmail('user1@motorola.com');
        stats.setUploadedBy(core);
        
  		EmporiumPersistence model = new EmporiumPersistence();
        List<EmporiumApplicationDownloadStats> statList = new List<EmporiumApplicationDownloadStats>();
        statList.add(stats);
        
        // Execution
        Test.startTest();
        List<Application_Download_Stats__c> sObjects = model.convert(statList);        
        Test.stopTest();        
        
        System.assertEquals(sObjects.size(), 1);
        Application_Download_Stats__c statsSObject = sObjects.get(0);
        boolean equals = true;
        
        if (stats.getDateLastDownloaded() != statsSObject.Date_last_download__c){
            equals &= false;
        }
        
        if (stats.getNumberOfDownloads() != statsSObject.Number_of_downloads__c){
            equals &= false;
        }
        
        if (!stats.getPackageName().equals(statsSObject.Package_Name__c)){
            equals &= false;
        }  
        
        if (!stats.getUniqueID().equals(statsSObject.UniqueID__c)){
            equals &= false;
        }     
        
        if (!stats.getVersion().equals(statsSObject.Version__c)){
            equals &= false;
        }      
        
        // Assertions
        System.assert(equals);
        
    }

    // Description:
	// This test case checks if the persistence class
    // does not convert a invalid set of data to be
    // used in data insertion process.
	//
	// Last Modified: 03/20/2014     
	public static testMethod void testConvertInvalidAppsBeforeSave(){
        // Setup
        EmporiumApplicationDownloadStats stats = new EmporiumApplicationDownloadStats();
        Datetime dt1 = Datetime.newInstance(1393871001111L);
        stats.setDateLastDownloaded(dt1.date());
        stats.setNumberOfDownloads(10);
        stats.setPackageName('com.motorola.package1000');
        stats.setUniqueID('ae3e46a8-322c-4dbc-8bb2-111111111');
        stats.setVersion('1');
        
        Application app = new Application();
        app.setName('App1');
        app.setPackageName('com.motorola.package1000');
		stats.setApplication(app);

        MotorolaCoreDirectory core = new MotorolaCoreDirectory();
        core.setEmail('user1000@motorola.com');
        stats.setUploadedBy(core);
        
  		EmporiumPersistence model = new EmporiumPersistence();
        List<EmporiumApplicationDownloadStats> statList = new List<EmporiumApplicationDownloadStats>();
        statList.add(stats);
        
        // Execution
        Test.startTest();
        List<Application_Download_Stats__c> sObjects = model.convert(statList);        
        Test.stopTest();        
        
        // Assertions
        System.assertEquals(sObjects.size(), 0);
    }    
   
    
}