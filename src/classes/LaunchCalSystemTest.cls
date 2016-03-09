@isTest
public class LaunchCalSystemTest {
    // Description:  
	// Returns a JSON emulanting the information retrieved from 
	// LaunchCal tool with valid values in all fields. 
	//
	// Input: none
	//
	// Returns: Striung JSON emulanting the information retrieved from
	// LaunchCal 
    private static String getJson(String appVersion, String SFDCID, String email1, String email2, String email3){       
       	String unique_id = '100432';
        String projectId = '100432';
        String version = '8';            
        String status = 'LAUNCHED';
        String name = '100364 Xfon_NA_SPR_KK_MR3_Initial_LE';
        String description = 'This is our initial Lab Entry. We are planning a subsequent SW drop before TA';            
        Long created = 1389490672049L;
        Long updated = 1389577344381L;
        Date launchDate = Date.newInstance(2014,01,13);
        Boolean hardDeadline = false;
        String approvalStatus = 'APPROVED';
        String launchJustification = '';
        String subscribers = '"' + email2 + '","' + email3 + '"';
        Boolean partial = false;
        String calendarIds = '53001';
        String fyiCalendarIds = '[]';
        String attributes;
        if (SFDCID == null){
       		attributes = '{"17001":"User Manager"}'; 
        }else{
        	attributes = '{"83001":"' + SFDCID + '", "17001":"User Manager", "44001":"' + appVersion + '"}';
        }
        String approver58001 = '{"approverDefinitionId":"58001","approvalStatus":';
        approver58001 += '"APPROVED","flippedBy":"' + email3 + '","flippedOn":"';
        approver58001 += '1389571954154", "owners":["dschuster@motorola.com"], "notes":""}';
		String approvers = '{"58001":'+approver58001+'}';
        String filteredAttributes = '[]';
        String approverEmails = '"dschuster@motorola.com"';
        String approvalPendingEmails = '[]';
        Boolean inconsistent = false;
        Boolean incomplete = false;
        
		String jsonApp = '{"launches":[{"id":"' + unique_id + '","projectId":'+projectId+',';
        jsonApp += '"version":'+version+',"status":"'+status+'","name":"';
        jsonApp += name+'","description":"'+description+'","created":'+created+',';
        jsonApp += '"updated":'+updated+',"launchDate":"'+launchDate+'","hardDeadline":';
        jsonApp += hardDeadline+', "approvalStatus":"'+approvalStatus+'",';
        jsonApp += '"launchJustification":"'+launchJustification+'", "createdBy": "'+email1 +'",';
        jsonApp += '"subscribers": ['+subscribers+'],"partial":'+partial+', "calendarIds":';
        jsonApp += calendarIds+',"fyiCalendarIds": '+fyiCalendarIds+',"attributes": '+attributes+',';
        jsonApp += '"approvers": '+approvers+', "filteredAttributes":'+filteredAttributes+',';
        jsonApp += '"approverEmails": ['+approverEmails+'], "approvalPendingEmails":'+approvalPendingEmails+',';
		jsonApp += '"inconsistent": '+inconsistent+', "incomplete": '+incomplete+'}]}';
        
		return jsonApp;    
    }
    
    // Description:
    // This test case checks is the code is able to parse a valid json
    // and save it into salesforce database. The used json has a attribute
    // with SFDC ID and a valid email creator.
    //
	// Last Modified: 05/12/2014
    public static testMethod void testParseAndSaveData(){
        
        //Setup 
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
	    Database.SaveResult resultCore1 = Database.insert(core);
	    ID idCore = resultCore1.getId();
	    
	    //Creating another motorola contact in motorola core directory custom object. The idCore2 will contains its ID.
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult resultCore2 = Database.insert(core2);
	    ID idCore2 = resultCore2.getId();	   	    

	    Motorola_Core_Directory__c core3 = new Motorola_Core_Directory__c(); 
	    core3.Mail__c = 'user3@motorola.com';
	    Database.SaveResult resultCore3 = Database.insert(core3);
	    ID idCore3 = resultCore3.getId();
	    
        String appVersion = '4.2.02.1';
	    String jsonApp = getJson(appVersion, application_ID, core.Mail__c, core2.Mail__c, core3.Mail__c);       
           
        //Execution
        Test.startTest();
      	LaunchCalDataParser parser = new LaunchCalDataParser();
        List<LaunchCal> launches = parser.getLaunches(jsonApp); 
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
              
		Test.stopTest();

        //Getting the launchCal data by using the unique_ID 1413414 set manually.
       	String launchCalQuery = 'select ID, Application__c, Status__c, Description__c,';
        launchCalQuery += 'Product_Manager__c, Unique_Id__c, Version__c  from LaunchCal__c where ';
        launchCalQuery += 'Unique_ID__c = \''+ 100432 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);
	    
	    Integer launchCalMotorolaSize = 0; 
		if (launchCalResult.size() > 0){
       		String launchCalMotorolaCoreDirQuery = 'select ID, Unique_Id__c from ';
            launchCalMotorolaCoreDirQuery += 'LaunchCal_Motorola_core_Directory__c ';
            launchCalMotorolaCoreDirQuery += 'where LaunchCal__c = \'' + launchCalResult.get(0).ID + '\'';
	    	LaunchCal_Motorola_core_Directory__c[] launchCalMotorolaCoreResult = Database.query(launchCalMotorolaCoreDirQuery);
	    	launchCalMotorolaSize = launchCalMotorolaCoreResult.size();
		}
        boolean resultEquals = launchCalResult.get(0).Status__c == launches.get(0).status;
        resultEquals &= launchCalResult.get(0).Description__c == launches.get(0).description;
        resultEquals &= launchCalResult.get(0).Product_Manager__c == launches.get(0).productManager;
        resultEquals &= launchCalResult.get(0).Unique_Id__c == launches.get(0).uniqueId;
        resultEquals &= launchCalResult.get(0).Version__c == launches.get(0).version;          
        resultEquals &= launchCalResult.get(0).Version__c == appVersion; 
		
        //Assertions        
        //We expected there is only one records in the launchCal custom object
        System.assertEquals(1, launchCalResult.size()); 
        System.assertEquals(3, launchCalMotorolaSize);  
        System.assertEquals(3, launchCalMotorolaSize);          
        System.assertEquals(id1, launchCalResult.get(0).Application__c);      
        System.assertEquals(appVersion, launchCalResult.get(0).Version__c);              
        System.assert(resultEquals);
    }

    // Description:
    // This test case checks is the code is able to parse a valid json
    // and save it into salesforce database. The used json has a attribute
    // with SFDC ID and a valid email creator.
    //
	// Last Modified: 05/12/2014
    public static testMethod void testParseAndSaveDataWithoutSFDC(){
        
        //Setup 
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
	    Database.SaveResult resultCore1 = Database.insert(core);
	    ID idCore = resultCore1.getId();
	    
	    //Creating another motorola contact in motorola core directory custom object. The idCore2 will contains its ID.
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult resultCore2 = Database.insert(core2);
	    ID idCore2 = resultCore2.getId();	   	    

	    Motorola_Core_Directory__c core3 = new Motorola_Core_Directory__c(); 
	    core3.Mail__c = 'user3@motorola.com';
	    Database.SaveResult resultCore3 = Database.insert(core3);
	    ID idCore3 = resultCore3.getId();
	    
        String appVersion = '4.2.02.1';
        
	    String jsonApp = getJson(appVersion, null, core.Mail__c, core2.Mail__c, core3.Mail__c);       
           
        //Execution
        Test.startTest();
      	LaunchCalDataParser parser = new LaunchCalDataParser();
        List<LaunchCal> launches = parser.getLaunches(jsonApp); 
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
              
		Test.stopTest();

        //Getting the launchCal data by using the unique_ID 1413414 set manually.
       	String launchCalQuery = 'select ID, Application__c, Status__c, ';
        launchCalQuery += 'Description__c,Product_Manager__c, Unique_Id__c, Version__c ';
        launchCalQuery += 'from LaunchCal__c where Unique_ID__c = \''+ 100432 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);
	    
	    Integer launchCalMotorolaSize = 0; 
		if (launchCalResult.size() > 0){
       		String launchCalMotorolaCoreDirQuery = 'select ID, Unique_Id__c from ';
            launchCalMotorolaCoreDirQuery += 'LaunchCal_Motorola_core_Directory__c ';
            launchCalMotorolaCoreDirQuery += 'where LaunchCal__c = \'' + launchCalResult.get(0).ID + '\'';
	    	LaunchCal_Motorola_core_Directory__c[] launchCalMotorolaCoreResult = Database.query(launchCalMotorolaCoreDirQuery);
	    	launchCalMotorolaSize = launchCalMotorolaCoreResult.size();
		}
	
		
        //Assertions        
        //We expected there is only one records in the launchCal custom object
        System.assertEquals(0, launchCalResult.size()); 
        System.assertEquals(0, launchCalMotorolaSize);  
    }

    // Description:
    // This test case checks is the code is able to parse a valid json
    // and save it into salesforce database. The used json has a attribute
    // with SFDC ID and a valid email creator.
    //
	// Last Modified: 05/12/2014
    public static testMethod void testParseAndSaveDataInvalidSFDC(){
        
        //Setup 
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
	    Database.SaveResult resultCore1 = Database.insert(core);
	    ID idCore = resultCore1.getId();
	    
	    //Creating another motorola contact in motorola core directory custom object. The idCore2 will contains its ID.
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult resultCore2 = Database.insert(core2);
	    ID idCore2 = resultCore2.getId();	   	    

	    Motorola_Core_Directory__c core3 = new Motorola_Core_Directory__c(); 
	    core3.Mail__c = 'user3@motorola.com';
	    Database.SaveResult resultCore3 = Database.insert(core3);
	    ID idCore3 = resultCore3.getId();
	    
        String appVersion = '4.2.02.1';
        
	    String jsonApp = getJson(appVersion, '8s234234234523a', core.Mail__c, core2.Mail__c, core3.Mail__c);       
           
        //Execution
        Test.startTest();
      	LaunchCalDataParser parser = new LaunchCalDataParser();
        List<LaunchCal> launches = parser.getLaunches(jsonApp); 
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
              
		Test.stopTest();

        //Getting the launchCal data by using the unique_ID 1413414 set manually.
       	String launchCalQuery = 'select ID, Application__c, Status__c, ';
        launchCalQuery += 'Description__c,Product_Manager__c, Unique_Id__c, Version__c ';
        launchCalQuery += 'from LaunchCal__c where Unique_ID__c = \''+ 100432 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);
	    
	    Integer launchCalMotorolaSize = 0; 
		if (launchCalResult.size() > 0){
       		String launchCalMotorolaCoreDirQuery = 'select ID, Unique_Id__c from ';
            launchCalMotorolaCoreDirQuery += 'LaunchCal_Motorola_core_Directory__c where ';
            launchCalMotorolaCoreDirQuery += 'LaunchCal__c = \'' + launchCalResult.get(0).ID + '\'';
	    	LaunchCal_Motorola_core_Directory__c[] launchCalMotorolaCoreResult = Database.query(launchCalMotorolaCoreDirQuery);
	    	launchCalMotorolaSize = launchCalMotorolaCoreResult.size();
		}
		
        //Assertions        
        //We expected there is only one records in the launchCal custom object
        System.assertEquals(0, launchCalResult.size()); 
        System.assertEquals(0, launchCalMotorolaSize);  
	
    }
    
    // Description:
    // This test case checks is the code is able to parse a valid json
    // and save it into salesforce database. The used json has a attribute
    // with SFDC ID and a valid email creator.
    //
	// Last Modified: 05/12/2014
    public static testMethod void testParseAndSaveDataWithoutCreatedBy(){
        
        //Setup 
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
	    Database.SaveResult resultCore1 = Database.insert(core);
	    ID idCore = resultCore1.getId();
	    
	    //Creating another motorola contact in motorola core directory custom object. The idCore2 will contains its ID.
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult resultCore2 = Database.insert(core2);
	    ID idCore2 = resultCore2.getId();	   	    

	    Motorola_Core_Directory__c core3 = new Motorola_Core_Directory__c(); 
	    core3.Mail__c = 'user3@motorola.com';
	    Database.SaveResult resultCore3 = Database.insert(core3);
	    ID idCore3 = resultCore3.getId();
	    
        String appVersion = '4.2.02.1';
        
	    String jsonApp = getJson(appVersion, application_ID, 'anotheruser@motorola.com', core2.Mail__c, core3.Mail__c);       
           
        //Execution
        Test.startTest();
      	LaunchCalDataParser parser = new LaunchCalDataParser();
        List<LaunchCal> launches = parser.getLaunches(jsonApp); 
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
              
		Test.stopTest();

        //Getting the launchCal data by using the unique_ID 1413414 set manually.
       	String launchCalQuery = 'select ID, Application__c, Status__c, ';
        launchCalQuery += 'Description__c,Product_Manager__c, Unique_Id__c, Version__c ';
        launchCalQuery += 'from LaunchCal__c where Unique_ID__c = \''+ 100432 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);
	    
	    Integer launchCalMotorolaSize = 0; 
		if (launchCalResult.size() > 0){
       		String launchCalMotorolaCoreDirQuery = 'select ID, Unique_Id__c from ';
            launchCalMotorolaCoreDirQuery += 'LaunchCal_Motorola_core_Directory__c '; 
            launchCalMotorolaCoreDirQuery += 'where LaunchCal__c = \'' + launchCalResult.get(0).ID + '\'';
	    	LaunchCal_Motorola_core_Directory__c[] launchCalMotorolaCoreResult = Database.query(launchCalMotorolaCoreDirQuery);
	    	launchCalMotorolaSize = launchCalMotorolaCoreResult.size();
		}
		
        //Assertions        
        //We expected there is only one records in the launchCal custom object
        System.assertEquals(0, launchCalResult.size()); 
        System.assertEquals(0, launchCalMotorolaSize);  
	
    }
    // Description:
    // This test case checks is the code is able to parse a valid json
    // and save it into salesforce database. The used json has a attribute
    // with SFDC ID and a valid email creator.
    //
	// Last Modified: 05/12/2014
    public static testMethod void testParseAndSaveDataWithoutApprover(){
        
        //Setup 
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
	    Database.SaveResult resultCore1 = Database.insert(core);
	    ID idCore = resultCore1.getId();
	    
	    //Creating another motorola contact in motorola core directory custom object. The idCore2 will contains its ID.
	    Motorola_Core_Directory__c core2 = new Motorola_Core_Directory__c(); 
	    core2.Mail__c = 'user2@motorola.com';
	    Database.SaveResult resultCore2 = Database.insert(core2);
	    ID idCore2 = resultCore2.getId();	   	    

	    Motorola_Core_Directory__c core3 = new Motorola_Core_Directory__c(); 
	    core3.Mail__c = 'user3@motorola.com';
	    Database.SaveResult resultCore3 = Database.insert(core3);
	    ID idCore3 = resultCore3.getId();
        
        String appVersion = '4.2.02.1';
	    
	    String jsonApp = getJson(appVersion, application_ID, core.Mail__c, core2.Mail__c, 'anotheruser@motorola.com');       
           
        //Execution
        Test.startTest();
      	LaunchCalDataParser parser = new LaunchCalDataParser();
        List<LaunchCal> launches = parser.getLaunches(jsonApp); 
        LaunchCalPersistence persistence = new LaunchCalPersistence();
        persistence.save(launches);
              
		Test.stopTest();

        //Getting the launchCal data by using the unique_ID 1413414 set manually.
       	String launchCalQuery = 'select ID, Application__c, Status__c, ';
        launchCalQuery += 'Description__c,Product_Manager__c, Unique_Id__c, Version__c ';
        launchCalQuery += 'from LaunchCal__c where Unique_ID__c = \''+ 100432 + '\'';
	    LaunchCal__c[] launchCalResult = Database.query(launchCalQuery);
	    
	    Integer launchCalMotorolaSize = 0; 
		if (launchCalResult.size() > 0){
       		String launchCalMotorolaCoreDirQuery = 'select ID, Unique_Id__c from ';
            launchCalMotorolaCoreDirQuery += 'LaunchCal_Motorola_core_Directory__c ';
            launchCalMotorolaCoreDirQuery += 'where LaunchCal__c = \'' + launchCalResult.get(0).ID + '\'';
	    	LaunchCal_Motorola_core_Directory__c[] launchCalMotorolaCoreResult = Database.query(launchCalMotorolaCoreDirQuery);
	    	launchCalMotorolaSize = launchCalMotorolaCoreResult.size();
		} 
		
        //Assertions        
        //We expected there is only one records in the launchCal custom object
        System.assertEquals(1, launchCalResult.size()); 
        System.assertEquals(1, launchCalMotorolaSize);  
        System.assertEquals(appVersion, launchCalResult.get(0).Version__c);                      
    }
}