/**********************************************************/
// Created by: João Gabriel Monteiro
// Created Date: 04/02/2014
// Last Modified: José Elias Araújo
// Last Modified by: 04/03/2014
//
// Description: 
// This test class contains methods to test if the methods
// for persistence of LaunchCal data are working properly.
/**********************************************************/
@isTest
public class LaunchCalPersistenceTest{


	// Description:
	// This test verifies if a LaunchCal information is saved properly.
	//
	// Last Modified: 04/03/2014
	public static testMethod void testSaveLaunchCalProperly(){
        // Setup        	    
	    //Inserting an applicaiton on database and recovering it to get its ID
	    Application__c app1 = new Application__c();
	    app1.Name = 'Test App';
	    app1.Package_Name__c = 'com.motorola.fakepackage';
	    Database.SaveResult result1 = Database.insert(app1);
	    
	    //Gettingthe ID and Application_ID of inserted application
	    ID id1 = result1.getId();
	    String query = 'select ID, Application_ID__c from Application__c where ID = \''+ id1 + '\'';
	    Application__c[] applications = Database.query(query);
	    String application_ID = applications.get(0).Application_ID__c;
	    
	    //Creating a motorola contact in motorola core directory custom object. The idCore will contains its ID.
	    Motorola_Core_Directory__c core = new Motorola_Core_Directory__c(); 
	    core.Mail__c = 'user@motorola.com';
	    Database.SaveResult result2 = Database.insert(core);
	    ID idCore = result2.getId();
	    
	    //Creating another motorola contact in motorola core directory custom object. The idCore2 will contains its ID.
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult result3 = Database.insert(core2);
	    ID idCore2 = result3.getId();	    
	    
	    //Creating an instance of Application with data already inserted in Application__c
	    Application application = new Application();
	    application.setName('Test AppTest App');
	    application.setPackageName('com.motorola.fakepackage');
	    application.setApplicationID(application_ID);
	    
	    //Creating instances of MotorolaCoreDirectory with data already inserted in Motorola_Core_Directory__c
	    MotorolaCoreDirectory core1 = new MotorolaCoreDirectory();
	    core1.setEmail('user@motorola.com'); 	    
	    MotorolaCoreDirectory core3 = new MotorolaCoreDirectory();
	    core3.setEmail('user2@motorola.com');
	    
	    //Create a subscriber with core3 information
	    LaunchCalMotorolaCoreDirectory subscriber = LaunchCalMotorolaCoreDirectory.buildSubscriber();
	    subscriber.flippedBy = core1;
	    subscriber.uniqueID = '10';
	    
	    LaunchCalMotorolaCoreDirectory approver = LaunchCalMotorolaCoreDirectory.buildApprover();
	    approver.approvalStatus = 'APPROVED';
	    approver.flippedBy = core3;
	    approver.flippedOn = Date.today();
	    approver.uniqueID = '20'; 
	 
	    //Creating a launchCal object. The createdBy field contains information of core3 instance.
	    LaunchCal launchCal = new LaunchCal();
       	launchCal.version = '1';
       	launchCal.createdBy = core3;
       	launchCal.created = Date.today();
       	launchCal.description = 'Fake Description';
       	launchCal.launchDate = Date.today();
       	launchCal.name = 'Fake Launch';
       	launchCal.productManager = 'Product manager name';
       	launchCal.status = 'APPROVED';
       	launchCal.uniqueId = '1413414';
       	launchCal.application = application;
       	launchCal.approvers.add(subscriber);
       	launchCal.approvers.add(approver);
       	
       	List<launchCal> launches = new List<launchCal>();
       	launches.add(launchCal); 
        
        //Execution
        Test.startTest();
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
        Test.stopTest();
        
        //Getting the launchCal data by using the unique_ID 1413414 set manually.
       	String launchCalQuery = 'select ID, Application__c, Status__c, Description__c,Product_Manager__c, Unique_Id__c, Version__c  from LaunchCal__c where Unique_ID__c = \''+ 1413414 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);

       	String launchCalMotorolaCoreDirQuery = 'select ID, Unique_Id__c from LaunchCal_Motorola_core_Directory__c where Unique_ID__c in (\'141341410\', \'141341420\')';
	    LaunchCal_Motorola_core_Directory__c[] launchCalMotorolaCoreResult = Database.query(launchCalMotorolaCoreDirQuery);
       
        //Assertions        
        //We expected there is only one records in the launchCal custom object
        System.assertEquals(1, launchCalResult.size()); 
        System.assertEquals(2, launchCalMotorolaCoreResult.size());       
    }

	// Description:
	// This test verifies if the launchCals without a creator is not saved
	//
	// Last Modified: 04/03/2014
	public static testMethod void testSaveDataNoDirectory(){
        // Setup        
	    
	    //Inserting an applicaiton on database and recovering it to get its ID
	    Application__c app1 = new Application__c();
	    app1.Name = 'Test App';
	    app1.Package_Name__c = 'com.motorola.fakepackage';
	    
	    Database.SaveResult result1 = Database.insert(app1);
	    ID id1 = result1.getId();
	    String query = 'select ID, Application_ID__c from Application__c where ID = \''+ id1 + '\'';
	    Application__c[] applications = Database.query(query);
	    String application_ID = applications.get(0).Application_ID__c;
	    
	    Motorola_Core_Directory__c core = new Motorola_Core_Directory__c(); 
	    core.Mail__c = 'user@motorola.com';
	    Database.SaveResult result2 = Database.insert(core);
	    ID idCore = result2.getId();
	    
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult result3 = Database.insert(core2);
	    ID idCore2 = result3.getId();	    
	    
	    Application application = new Application();
	    application.setName('Test AppTest App');
	    application.setPackageName('com.motorola.fakepackage');
	    application.setApplicationID(application_ID);
	    
	    MotorolaCoreDirectory core1 = new MotorolaCoreDirectory();
	    core1.setEmail('user@motorola.com'); 	    
	    MotorolaCoreDirectory core3 = new MotorolaCoreDirectory();
	    core3.setEmail('anotheruser@motorola.com');
	    
	    LaunchCalMotorolaCoreDirectory subscriber = LaunchCalMotorolaCoreDirectory.buildSubscriber();
	    subscriber.flippedBy = core3;
	    subscriber.uniqueID = '10';
	    
	    LaunchCalMotorolaCoreDirectory approver = LaunchCalMotorolaCoreDirectory.buildApprover();
	    approver.flippedBy = core3; 
	    approver.approvalStatus = 'APPROVED';
	    approver.flippedOn = Date.today();
	    approver.uniqueID = '20'; 
	 
	    
	    LaunchCal launchCal = new LaunchCal();
       	launchCal.version = '1';
       	launchCal.createdBy = core3;
       	launchCal.created = Date.today();
       	launchCal.description = 'Fake Description';
       	launchCal.launchDate = Date.today();
       	launchCal.name = 'Fake Launch';
       	launchCal.productManager = 'Product manager name';
       	launchCal.status = 'APPROVED';
       	launchCal.uniqueId = '1413414';
       	launchCal.application = application;
       	launchCal.approvers.add(subscriber);
       	launchCal.approvers.add(approver);
       	
       	List<launchCal> launches = new List<launchCal>();
       	launches.add(launchCal); 
        
        //Execution
        Test.startTest();
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
        Test.stopTest();
        
       	String launchCalQuery = 'select ID, Application__c, Status__c, Description__c,Product_Manager__c, Unique_Id__c, Version__c  from LaunchCal__c where Unique_ID__c = \''+ 1413414 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);
       
       	String launchCalMotorolaCoreDirQuery = 'select ID, Unique_Id__c from LaunchCal_Motorola_core_Directory__c where Unique_ID__c in (\'141341410\', \'141341420\')';
	    LaunchCal_Motorola_core_Directory__c[] launchCalMotorolaCoreResult = Database.query(launchCalMotorolaCoreDirQuery);
              
        //Assertions        
        System.assertEquals(0, launchCalResult.size());       
        System.assertEquals(0, launchCalMotorolaCoreResult.size());  
    }

	// Description:
	// This test verifies if the launchCals without application SFDC ID is not saved
	//
	// Last Modified: 04/03/2014
	public static testMethod void testSaveDataNoApplication(){
        //Setup        
	    //Inserting an applicaiton on database and recovering it to get its ID
	    Application__c app1 = new Application__c();
	    app1.Name = 'Test App';
	    app1.Package_Name__c = 'com.motorola.fakepackage';	    
	    Database.SaveResult result1 = Database.insert(app1);
	    ID id1 = result1.getId();
	    String query = 'select ID, Application_ID__c from Application__c where ID = \''+ id1 + '\'';
	    Application__c[] applications = Database.query(query);
	    String application_ID = applications.get(0).Application_ID__c;
	    
	    //Creating a motorola core directory and save its ID in idCore variable
	    Motorola_Core_Directory__c core = new Motorola_Core_Directory__c(); 
	    core.Mail__c = 'user@motorola.com';
	    Database.SaveResult result2 = Database.insert(core);
	    ID idCore = result2.getId();

	    //Creating another motorola core directory and save its ID in idCore2 variable	    
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult result3 = Database.insert(core2);
	    ID idCore2 = result3.getId();	    
	    
	    //Create an instance of Application, but using another value in SFDC ID.
	    //It is necessary in order to associate a wrong application to a launchCal
	    //and checks if this launchCal is not saved.
	    Application application = new Application();
	    application.setName('Test AppTest App');
	    application.setPackageName('com.motorola.fakepackage');
	    application.setApplicationID('1234123');
	    
	    MotorolaCoreDirectory core1 = new MotorolaCoreDirectory();
	    core1.setEmail('user@motorola.com'); 	    
	    MotorolaCoreDirectory core3 = new MotorolaCoreDirectory();
	    core3.setEmail('user2@motorola.com');
	    
	    LaunchCalMotorolaCoreDirectory subscriber = LaunchCalMotorolaCoreDirectory.buildSubscriber();
	    subscriber.flippedBy = core3;
	    subscriber.uniqueID = '10';
	    
	    LaunchCalMotorolaCoreDirectory approver = LaunchCalMotorolaCoreDirectory.buildApprover();
	    approver.flippedBy = core3; 
	    approver.approvalStatus = 'APPROVED';
	    approver.flippedOn = Date.today();
	    approver.uniqueID = '20'; 
	 
	    
	    LaunchCal launchCal = new LaunchCal();
       	launchCal.version = '1';
       	launchCal.createdBy = core3;
       	launchCal.created = Date.today();
       	launchCal.description = 'Fake Description';
       	launchCal.launchDate = Date.today();
       	launchCal.name = 'Fake Launch';
       	launchCal.productManager = 'Product manager name';
       	launchCal.status = 'APPROVED';
       	launchCal.uniqueId = '1413414';
       	launchCal.application = application;
       	launchCal.approvers.add(subscriber);
       	launchCal.approvers.add(approver);
       	
       	List<launchCal> launches = new List<launchCal>();
       	launches.add(launchCal); 
        
        //Execution
        Test.startTest();
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
        Test.stopTest();
        
       	String launchCalQuery = 'select ID, Application__c, Status__c, Description__c,Product_Manager__c, Unique_Id__c, Version__c  from LaunchCal__c where Unique_ID__c = \''+ 1413414 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);
       
       	String launchCalMotorolaCoreDirQuery = 'select ID, Unique_Id__c from LaunchCal_Motorola_core_Directory__c where Unique_ID__c in (\'141341410\', \'141341420\')';
	    LaunchCal_Motorola_core_Directory__c[] launchCalMotorolaCoreResult = Database.query(launchCalMotorolaCoreDirQuery);
       
       
        //Assertions        
        //We expected thare is no entries for launchCal and LaunchCal_Motorola_Core_Directory
        //because it could not be saved if it is linked with a unexisting SFDC ID.
        System.assertEquals(0, launchCalResult.size()); 
        System.assertEquals(0, launchCalMotorolaCoreResult.size());               
    }

	// Description:
	// This test verifies if the launchCals and motorola core directories information are saved
	//
	// Last Modified: 04/03/2014
    public static testMethod void testSaveData(){
        //Setup        	    
	    //Inserting an applicaiton on database and recovering it to get its ID
	    Application__c app1 = new Application__c();
	    app1.Name = 'Test App';
	    app1.Package_Name__c = 'com.motorola.fakepackage';
	    
	    Database.SaveResult result1 = Database.insert(app1);
	    ID id1 = result1.getId();
	    String query = 'select ID, Application_ID__c from Application__c where ID = \''+ id1 + '\'';
	    Application__c[] applications = Database.query(query);
	    String application_ID = applications.get(0).Application_ID__c;
	    
	    Motorola_Core_Directory__c core = new Motorola_Core_Directory__c(); 
	    core.Mail__c = 'user@motorola.com';
	    Database.SaveResult result2 = Database.insert(core);
	    ID idCore = result2.getId();
	    
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult result3 = Database.insert(core2);
	    ID idCore2 = result3.getId();	    
	    
	    Application application = new Application();
	    application.setName('Test AppTest App');
	    application.setPackageName('com.motorola.fakepackage');
	    application.setApplicationID(application_ID);
	    
	    MotorolaCoreDirectory core1 = new MotorolaCoreDirectory();
	    core1.setEmail('user@motorola.com'); 	    
	    MotorolaCoreDirectory core3 = new MotorolaCoreDirectory();
	    core3.setEmail('user2@motorola.com');
	    
	    LaunchCalMotorolaCoreDirectory subscriber = LaunchCalMotorolaCoreDirectory.buildSubscriber();
	    subscriber.flippedBy = core3;
	    subscriber.uniqueID = '10';
	    
	    LaunchCalMotorolaCoreDirectory approver = LaunchCalMotorolaCoreDirectory.buildApprover();
	    approver.flippedBy = core1; 
	    approver.approvalStatus = 'APPROVED';
	    approver.flippedOn = Date.today();
	    approver.uniqueID = '20'; 
	 
	    
	    LaunchCal launchCal = new LaunchCal();
       	launchCal.version = '1';
       	launchCal.createdBy = core3;
       	launchCal.created = Date.today();
       	launchCal.description = 'Fake Description';
       	launchCal.launchDate = Date.today();
       	launchCal.name = 'Fake Launch';
       	launchCal.productManager = 'Product manager name';
       	launchCal.status = 'APPROVED';
       	launchCal.uniqueId = '1413414';
       	launchCal.application = application;
       	launchCal.approvers.add(subscriber);
       	launchCal.approvers.add(approver);
       	
       	List<launchCal> launches = new List<launchCal>();
       	launches.add(launchCal); 
        
        //Execution
        Test.startTest();
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
        Test.stopTest();
        
       	String launchCalQuery = 'select ID, Application__c, Status__c, Description__c,Product_Manager__c, Unique_Id__c, Version__c  from LaunchCal__c where Unique_ID__c = \''+ 1413414 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);
        boolean resultEquals = launchCalResult.get(0).Status__c == launchCal.status;
        resultEquals &= launchCalResult.get(0).Description__c == launchCal.description;
        resultEquals &= launchCalResult.get(0).Product_Manager__c == launchCal.productManager;
        resultEquals &= launchCalResult.get(0).Unique_Id__c == launchCal.uniqueId;
        resultEquals &= launchCalResult.get(0).Version__c == launchCal.version;      

        //Gets the subscriber
       	String launchCalSubscriberQuery = 'select ID, Flipped_By__c, Unique_ID__c from LaunchCal_Motorola_Core_Directory__c where Unique_ID__c = \'141341410\'';
	    LaunchCal_Motorola_Core_Directory__c[] launchCalSubscriberResult = Database.query(launchCalSubscriberQuery);
        boolean subscriberEquals = launchCalSubscriberResult.get(0).Unique_ID__c == subscriber.uniqueID;
        subscriberEquals &= launchCalSubscriberResult.get(0).Flipped_By__c == idCore2;
        
        //Gets the Approver
       	String launchCalApproverQuery = 'select ID, Approval_Status__c, Flipped_By__c, Flipped_On__c,LaunchCal__c, Notes__c, Unique_ID__c from LaunchCal_Motorola_Core_Directory__c where Unique_ID__c = \'141341420\'';
	    LaunchCal_Motorola_Core_Directory__c[] launchApproverResult = Database.query(launchCalApproverQuery);
        boolean approverEquals = launchApproverResult.get(0).Unique_ID__c == approver.uniqueID;
        approverEquals &= launchApproverResult.get(0).Flipped_By__c == idCore;
        approverEquals &= launchApproverResult.get(0).Approval_Status__c == approver.approvalStatus;
                
        //Assertions        
        System.assertEquals(launchCalResult.get(0).Application__c, id1); 
        System.assertEquals(launchCalResult.size(), 1);      
        System.assert(resultEquals);
        System.assert(subscriberEquals);
        System.assert(approverEquals);
    }
    
    // Description:
	// This test verifies if the launchCals without approvers are saved
	//
	// Last Modified: 04/03/2014
    public static testMethod void testSaveDataNoApprover(){
        //Setup        	    
	    //Inserting an applicaiton on database and recovering it to get its ID
	    Application__c app1 = new Application__c();
	    app1.Name = 'Test App';
	    app1.Package_Name__c = 'com.motorola.fakepackage';
	    
	    Database.SaveResult result1 = Database.insert(app1);
	    ID id1 = result1.getId();
	    String query = 'select ID, Application_ID__c from Application__c where ID = \''+ id1 + '\'';
	    Application__c[] applications = Database.query(query);
	    String application_ID = applications.get(0).Application_ID__c;
	    
	    Motorola_Core_Directory__c core = new Motorola_Core_Directory__c(); 
	    core.Mail__c = 'user@motorola.com';
	    Database.SaveResult result2 = Database.insert(core);
	    ID idCore = result2.getId();
	    
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult result3 = Database.insert(core2);
	    ID idCore2 = result3.getId();	    
	    
	    Application application = new Application();
	    application.setName('Test AppTest App');
	    application.setPackageName('com.motorola.fakepackage');
	    application.setApplicationID(application_ID);
	    
	    MotorolaCoreDirectory core1 = new MotorolaCoreDirectory();
	    core1.setEmail('user444@motorola.com'); 	    
	    MotorolaCoreDirectory core3 = new MotorolaCoreDirectory();
	    core3.setEmail('user2@motorola.com');
	    
	    LaunchCalMotorolaCoreDirectory subscriber = LaunchCalMotorolaCoreDirectory.buildSubscriber();
	    subscriber.flippedBy = core3;
	    subscriber.uniqueID = '10';
	    
	    LaunchCalMotorolaCoreDirectory approver = LaunchCalMotorolaCoreDirectory.buildApprover();
	    approver.flippedBy = core1; 
	    approver.approvalStatus = 'APPROVED';
	    approver.flippedOn = Date.today();
	    approver.uniqueID = '20'; 
	 
	    
	    LaunchCal launchCal = new LaunchCal();
       	launchCal.version = '1';
       	launchCal.createdBy = core3;
       	launchCal.created = Date.today();
       	launchCal.description = 'Fake Description';
       	launchCal.launchDate = Date.today();
       	launchCal.name = 'Fake Launch';
       	launchCal.productManager = 'Product manager name';
       	launchCal.status = 'APPROVED';
       	launchCal.uniqueId = '1413414';
       	launchCal.application = application;
       	launchCal.approvers.add(subscriber);
       	launchCal.approvers.add(approver);
       	
       	List<launchCal> launches = new List<launchCal>();
       	launches.add(launchCal); 
        
        //Execution
        Test.startTest();
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
        Test.stopTest();
        
       	String launchCalQuery = 'select ID, Application__c, Status__c, Description__c,Product_Manager__c, Unique_Id__c, Version__c  from LaunchCal__c where Unique_ID__c = \''+ 1413414 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);
        boolean resultEquals = launchCalResult.get(0).Status__c == launchCal.status;
        resultEquals &= launchCalResult.get(0).Description__c == launchCal.description;
        resultEquals &= launchCalResult.get(0).Product_Manager__c == launchCal.productManager;
        resultEquals &= launchCalResult.get(0).Unique_Id__c == launchCal.uniqueId;
        resultEquals &= launchCalResult.get(0).Version__c == launchCal.version;

        //Gets the subscriber
       	String launchCalSubscriberQuery = 'select ID, Approval_Status__c, Flipped_By__c, Flipped_On__c,LaunchCal__c, Notes__c, Unique_ID__c from LaunchCal_Motorola_Core_Directory__c where Unique_ID__c = \'141341410\'';
	    LaunchCal_Motorola_Core_Directory__c[] launchCalSubscriberResult = Database.query(launchCalSubscriberQuery);
        boolean subscriberEquals = launchCalSubscriberResult.get(0).Unique_ID__c == subscriber.uniqueID;
        subscriberEquals &= launchCalSubscriberResult.get(0).Flipped_By__c == idCore2;
        
        //Gets the Approver
       	String launchCalApproverQuery = 'select ID, Approval_Status__c, Flipped_By__c, Flipped_On__c,LaunchCal__c, Notes__c, Unique_ID__c from LaunchCal_Motorola_Core_Directory__c where Unique_ID__c = \'141341420\'';
	    LaunchCal_Motorola_Core_Directory__c[] launchApproverResult = Database.query(launchCalApproverQuery);
        
        //Assertions        
        System.assertEquals(launchCalResult.get(0).Application__c, id1);
        System.assertEquals(launchCalResult.size(), 1);
		System.assertEquals(launchCalSubscriberResult.size(), 1);
		System.assertEquals(launchApproverResult.size(), 0);        
        System.assert(resultEquals);
        System.assert(subscriberEquals);
    }
    
    // Description:
	// This test verifies if the query to search for Applications by ID is working properly
	//
	// Last Modified: 04/02/2014
    public static testMethod void testSearchApplications(){
        // Setup        
        Application__c app1 = new Application__c();
        Database.SaveResult result1 = Database.insert(app1);
        ID id1 = result1.getId();
        String query = 'select ID, Application_ID__c from Application__c where ID = \''+ id1 + '\'';
        Application__c[] applications = Database.query(query);
    
        List<LaunchCal> launchCals = new List<LaunchCal>();
        
        LaunchCal launchCal = new LaunchCal();
        launchCal.application = new Application();
        launchCal.application.setApplicationID(applications[0].Application_ID__c);
		launchCals.add(launchCal);

        LaunchCal launchCal2 = new LaunchCal();
        launchCal2.application = new Application();
        launchCal2.application.setApplicationID('xxxxxxx');
		launchCals.add(launchCal2);
        
        //Execution
        Test.startTest();
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        Application__c[] result = persistence.searchApplications(launchCals);
        Test.stopTest();        
        
        //Assertions
        System.assertEquals(result.size(), 1);
    }
}