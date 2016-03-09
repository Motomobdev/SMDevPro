/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/18/2014
// Last Modified: José Elias Araújo
// Last Modified by: 09/01/2014
//
// Description:
// This test class contains methods to test the parser
// that converts the data Emporium (in json format) to
// object.
/**********************************************************/
@isTest
public class EmporiumDataParserTest{

    // Description:
	// This test case checks if the parser is able to create
    // more than one record when they are using the same application
    // package.
	//
	// Last Modified: 04/08/2014
    public static testMethod void testParseTwoRecordToSamePackage(){
        // Setup
        Application__c customApp = new Application__c();
        customApp.Name = 'App1';
        customApp.Package_Name__c = 'com.motorola.package1';        
        insert customApp;
        
        Motorola_Core_Directory__c customCore = new Motorola_Core_Directory__c();
        customCore.Mail__c = 'user1@motorola.com';
        insert customCore;
        
        String json = '[{"Name":"AAA Train","UploadedOn":"Unknown","DateLastDownloaded":1396996535755,';
        json += '"NumberOfDownloads":246,"Id":"012eb522-9cfe-4987-a5ca-769a542a1d63","Category":"Fishfood"';
        json += ',"Package":"com.motorola.pack1","UploadedBy":"user1@motorola.com","Version":1,';
        json += '"ActiveUsersByVersion":[{"Version" : "1","NumberOfDownloads": 245}]},{"UploadedOn":1396994722209, "Category":"Fishfood", "Name":"';
        json += 'Active Display v1.3.4 (signed)","DateLastDownloaded":1396994722209,"NumberOfDownloads":432,';
        json += '"Id":"6c8da1fa-d583-4e13-ad28-5b3f4bb1394e","Package":"com.motorola.pack1","UploadedBy":';
        json += '"user1@motorola.com","Version":1030004, "ActiveUsersByVersion":[{"Version":"10", "NumberOfDownloads":500}]}]';
        
        // Execution
        Test.startTest();
  		EmporiumPersistence model = new EmporiumPersistence();
		List<EmporiumApplicationDownloadStats> appDownloadStatsList = EmporiumDataParser.parse(json);
        Test.stopTest();   

        // Assertions
        System.assertEquals(2, appDownloadStatsList.size());
        System.assertEquals(1, appDownloadStatsList[0].getActiveUsersByVersion().size());
        System.assertEquals(1, appDownloadStatsList[1].getActiveUsersByVersion().size());
    }

    
	// Description:
	// This test case checks the parser is not able to parse
    // a invalid list of application names.
    //
    // Last Modified: 03/20/2014
    public static testMethod void testApplicationNamesParserWithInvalidData(){
        // Setup
        EmporiumCalloutStub stub = new EmporiumCalloutStub();
        EmporiumCalloutStub.defineNumberOfApplications(5, false);
        
        // Execution
        Test.startTest();
        HttpResponse response = stub.getRequest(EmporiumCalloutStub.API_SALESFORCE_LIST_URL, new Map<String, String>());
        String invalidJson = response.getBody();
        List<String> names = EmporiumDataParser.parseApplicationNames(invalidJson);
        
        // Assertions
        System.assertEquals(0, names.size());            
    }
            
    // Description:
    // This test case checks the parser is able to parse
    // a invalid list of application names.
    //
    // Last Modified: 03/20/2014               
    public static testMethod void testApplicationNamesParser(){
        // Setup
        String name = 'Fake Application 1';
        String uid = 'ae3e46a8-322c-4dbc-8bb2';  
        String jsonApp = '[{"Name":"' + name + '", "Id": "'+ uid + '"}]';
        
        // Execution
        Test.startTest();
        List<String> appNames = EmporiumDataParser.parseApplicationNames(jsonApp);
        System.assertEquals(1,appNames.size());
        
        String appName = appNames.get(0);
        boolean assertion = true;
        if (!appName.equals(uid)){
            assertion = false;
        }
        
        // Assertions
        System.assertEquals(true, assertion);            
        
    }
    
    // Description:
    // This test case checks the parser is not able to parse
    // a invalid list of applications.
    //
    // Last Modified: 03/20/2014    
    public static testMethod void testApplicationParserWithInvalidData(){
        // Setup
        EmporiumCalloutStub stub = new EmporiumCalloutStub();
        EmporiumCalloutStub.defineNumberOfApplications(5, false);
        
        // Execution
        Test.startTest();
        HttpResponse response =  stub.postRequest(EmporiumCalloutStub.API_SALESFORCE_DETAILS_URL, new Map<String, String>(), '');
        String invalidJson =response.getBody();
        boolean exceptionThrown = false;
        
        try{
            List<EmporiumApplicationDownloadStats> appDownloadStatsList = EmporiumDataParser.parse(invalidJson);
        }catch(EmporiumException e){
            exceptionThrown = true;
        }
        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(exceptionThrown,true);
        
    }

    // Description:
    // This test case checks the parser is able to parse
    // a invalid list of applications.
    //
    // Last Modified: 03/20/2014
    public static testMethod void testApplicationParser(){
        // Setup
        String name = 'Fake Application 1';
        Long dateLastDownloaded =1392664860691L;
        Long uploadedOn =1392664860641L;  
        String category = 'Categ1';
        integer numberOfDownloads = 1;
        String unique_id = 'ae3e46a8-322c-4dbc-8bb2';
        String unique_package = 'com.motorola.fakepack';
        String uploadedBy = 'user234234@motorola.com';
        integer version = 1;
        Map<String, Integer> usersByVersion = new Map<String, Integer>();
        usersByVersion.put('10001', 24);
        usersByVersion.put('1010001', 2);
        usersByVersion.put('1010002', 3);            
        
        String jsonApp = '[{"Name":"' + name + '","DateLastDownloaded":'+dateLastDownloaded+',';
        jsonApp += '"NumberOfDownloads":'+numberOfDownloads+',"Id":"'+unique_id+'","Package":"';
        jsonApp += unique_package+'","UploadedBy":"'+uploadedBy+'","Version":'+version;
        jsonApp += ', "Category":"'+ category + '", "UploadedOn":'+ uploadedOn + ',';
        jsonApp += '"ActiveUsersByVersion":[{"Version": "10001", "NumberOfDownloads":24},';
        jsonApp += '{"Version":"1010001", "NumberOfDownloads":2},{"Version":"1010002",';
        jsonApp += '"NumberOfDownloads":3}]}]';
        boolean assertion = true;
        
        // Execution
        Test.startTest();
        List<EmporiumApplicationDownloadStats> appDownloadStatsList;
        appDownloadStatsList = EmporiumDataParser.parse(jsonApp);
        
        System.assertEquals(1, appDownloadStatsList.size());
        
        EmporiumApplicationDownloadStats applicationStats = appDownloadStatsList.get(0); 
        
        if (!applicationStats.getApplication().getName().equals(name)){
            assertion = assertion && false;
        }
        
        String value_str = String.valueOf(version);
        if (!applicationStats.getVersion().equals(value_str)){
            assertion = assertion && false;
        } 
        if (applicationStats.getNumberOfDownloads() != numberOfDownloads){
            assertion = assertion && false;
        } 
        
        Datetime dt = Datetime.newInstance(dateLastDownloaded);            
        
        if (applicationStats.getDateLastDownloaded() != dt.date()){
            assertion = assertion && false;
        }
        
        Datetime dt2 = Datetime.newInstance(dateLastDownloaded);
        
        if (applicationStats.getUploadedOn() != dt2.date()){
            assertion = assertion && false;
        }
        
        if (!applicationStats.getUploadedBy().getEmail().equals(uploadedBy)){
            assertion = assertion && false;
        }  
        
        if (!applicationStats.getPackageName().equals(unique_package)){
            assertion = assertion && false;
        } 
        
        if (!applicationStats.getUniqueID().equals(unique_id)){
            assertion = assertion && false;
        } 
        
        if (!applicationStats.getCategory().equals(category)){
            assertion = assertion && false;
        } 
        
        if (applicationStats.getActiveUsersByVersion().size() == usersByVersion.size()){
            List<EmporiumActiveUserByApplicationVersion> versions;
            versions = applicationStats.getActiveUsersByVersion();
            
            for (String appVersion :  usersByVersion.keySet()){  
                boolean hasVersions = false; 
                for(EmporiumActiveUserByApplicationVersion activeUserByVersion : versions){
                    if (activeUserByVersion.numberOfDownloads == usersByVersion.get(appVersion) &&
                        activeUserByVersion.version == appVersion){
                            hasVersions = true;
                            break;
                        }
                }
                assertion = assertion && hasVersions;
            }               
        }
        
        Test.stopTest();
        
        // Assertions
        System.assertEquals(assertion,true);
    }
    
    // Description:
	// This test case checks if the parser is able to parse
	// an application with o versions or invalid versions.
	//
	// Last Modified: 04/08/2014
    public static testMethod void testParseWithInvalidVersions(){
        // Setup
        Application__c customApp = new Application__c();
        customApp.Name = 'App1';
        customApp.Package_Name__c = 'com.motorola.package1';        
        insert customApp;
        
        Motorola_Core_Directory__c customCore = new Motorola_Core_Directory__c();
        customCore.Mail__c = 'user1@motorola.com';
        insert customCore;
        
        String json = '[{"Name":"AAA Train","UploadedOn":"Unknown","DateLastDownloaded":1396996535755,';
        json += '"NumberOfDownloads":246,"Id":"012eb522-9cfe-4987-a5ca-769a542a1d63","Category":"Fishfood"';
        json += ',"Package":"com.motorola.pack1","UploadedBy":"user1@motorola.com","Version":1,';
        json += '"ActiveUsersByVersion":[{"Version" : "1","NumberOfDownloads": 245}]}]';

        String json2 = '[{"Name":"AAA Train","UploadedOn":1396996535755,"DateLastDownloaded":1396996535755,';
        json2 += '"NumberOfDownloads":246,"Id":"012eb522-9cfe-4987-a5ca-769a542a1d63","Category":"Fishfood"';
        json2 += ',"Package":"com.motorola.pack1","UploadedBy":"user1@motorola.com","Version":1,';
        json2 += '"ActiveUsersByVersion":[{"Version" : "","NumberOfDownloads": 245}]}]';

        String json3 = '[{"Name":"AAA Train","UploadedOn":"Unknown","DateLastDownloaded":1396996535755,';
        json3 += '"NumberOfDownloads":246,"Id":"012eb522-9cfe-4987-a5ca-769a542a1d63","Category":"Fishfood"';
        json3 += ',"Package":"com.motorola.pack1","UploadedBy":"user1@motorola.com","Version":1,';
        json3 += '"ActiveUsersByVersion":[{"NumberOfDownloads": 245}]}]';
        
        String json4 = '[{"Name":"AAA Train","UploadedOn":"Unknown","DateLastDownloaded":1396996535755,';
        json4 += '"NumberOfDownloads":246,"Id":"012eb522-9cfe-4987-a5ca-769a542a1d63","Category":"Fishfood"';
        json4 += ',"Package":"com.motorola.pack1","UploadedBy":"user1@motorola.com","Version":1,';
        json4 += '"ActiveUsersByVersion":[]}]';

        
        // Execution
        Test.startTest();
  		EmporiumPersistence model = new EmporiumPersistence();
		List<EmporiumApplicationDownloadStats> appDownloadStatsList = EmporiumDataParser.parse(json);
		List<EmporiumApplicationDownloadStats> appDownloadStatsList2 = EmporiumDataParser.parse(json2);
		List<EmporiumApplicationDownloadStats> appDownloadStatsList3 = EmporiumDataParser.parse(json3);
		List<EmporiumApplicationDownloadStats> appDownloadStatsList4 = EmporiumDataParser.parse(json4);        
        Test.stopTest();   

        // Assertions
        System.assertEquals(1, appDownloadStatsList.size());
        System.assertEquals(1, appDownloadStatsList[0].getActiveUsersByVersion().size());

        System.assertEquals(1, appDownloadStatsList.size());
        System.assertEquals(1, appDownloadStatsList2[0].getActiveUsersByVersion().size());

        System.assertEquals(1, appDownloadStatsList.size());
        System.assertEquals(1, appDownloadStatsList3[0].getActiveUsersByVersion().size());
    
        System.assertEquals(1, appDownloadStatsList.size());
        System.assertEquals(0, appDownloadStatsList4[0].getActiveUsersByVersion().size());

        
    }
}