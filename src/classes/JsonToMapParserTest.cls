/**********************************************************/
// Created by: Adelito Farias
// Created Date: 03/27/2014
// Last Modified: Adelito Farias
// Last Modified by: 03/28/2014
//
// Description:
// This class has methods to test if the conversions of JSONs to Map Objects are working properly
// 
// Test Class: 
// LaunchCalCalssesTest.cls
/**********************************************************/
@isTest
public class JsonToMapParserTest{
    
    
    // Description:
	// This Method returns a String in JSON format that is used by the the test methods
	//
	// Returns: String in JSON format . 
	// Last Modified: 03/28/2014
    private static String getJson(){        
        String unique_id = '100432';
        String projectId = '100432';
        Integer version = 8;
        String status = 'LAUNCHED';
        String name = '100364 Xfon_NA_SPR_KK_MR3_Initial_LE';
        String description = 'This is our initial Lab Entry. We are planning';
        description += 'a subsequent SW drop before TA';            
        Long created = 1389490672049L;
        Long updated = 1389577344381L;
        Date launchDate = Date.newInstance(2014,01,13);
        Boolean hardDeadline = false;
        String approvalStatus = 'APPROVED';
        String launchJustification = '';
        String createdBy = 'markrobbins@motorola.com';
        String subscribers = '"fkn006@motorola.com","e10330@motorola.com"';
        Boolean partial = false;
        String calendarIds = '53001';
        String fyiCalendarIds = '[]';
        String attributes = '{"56001":"3"}';
        String approver58001 = '{"approverDefinitionId":"58001","approvalStatus":';
        approver58001 += '"APPROVED","flippedBy":"dschuster@motorola.com","flippedOn":';
        approver58001 +='"1389571954154", "owners":["dschuster@motorola.com"], "notes":""}';
        String approvers = approver58001;
        String filteredAttributes = '[]';
        String approverEmails = '"dschuster@motorola.com"';
        String approvalPendingEmails = '[]';
        Boolean inconsistent = false;
        Boolean incomplete = false;
        
        String jsonApp = '[{"Id":"' + unique_id + '","ProjectId":'+projectId+',';
        jsonApp += '"Version":'+version+',"Status":"'+status+'","Name":"';
        jsonApp += name+'","Description":"'+description+'","Created":'+created+',';
        jsonApp += '"Updated":'+updated+',"LaunchDate":"'+launchDate+'","HardDeadline":';
        jsonApp += hardDeadline+', "ApprovalStatus":"'+approvalStatus+'",';
        jsonApp += '"LaunchJustification":"'+launchJustification+'", "CreatedBy": "'+createdBy+'",';
        jsonApp += '"Subscribers": ['+subscribers+'],"Partial":'+partial+', "CalendarIds":';
        jsonApp += calendarIds+',"FyiCalendarIds": '+fyiCalendarIds+',"Attributes": '+attributes+',';
        jsonApp += '"Approvers": '+approvers+', "FilteredAttributes":'+filteredAttributes+',';
        jsonApp += '"ApproverEmails": ['+approverEmails+'], "ApprovalPendingEmails":'+approvalPendingEmails+',';
        jsonApp += '"Inconsistent": '+inconsistent+', "Incomplete": '+incomplete+'}]';
        
		return jsonApp;
    
    }
    
    
    // Description:
	// This test case checks the parser is able to parse
    // a valid list of applications.
	//
	// Last Modified: 03/28/2014
    public static testMethod void testApplicationParser(){        
        // Setup           
        String jsonApp = getJson();

        boolean assertion = true;
           
        // Execution
        Test.startTest();
        JsonToMapParser model = new JsonToMapParser();
        Map<String, Object>  mapping = model.parse(jsonApp);       
        JsonObject jsonObject = new JsonObject(mapping);
        System.assertEquals('fkn006@motorola.com',jsonObject.getString('Subscribers[0]'));
        Test.stopTest();
        
        // Assertions
        System.assertEquals(assertion,true);
    }
    
    
    // Description:
    // This test case checks the parser is able to parse
    // a invalid list of applications.
    //
    // Last Modified: 03/31/2014
    public static testMethod void testApplicationParserObjectName(){
        
        // Setup
        String jsonApp = getJson();
        
        //Execution
        Test.startTest();
        JsonToMapParser model = new JsonToMapParser();
        Map<String, Object>  mapping = model.parse('Subscribers', jsonApp);       
        JsonObject jsonObject = new JsonObject(mapping);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(2,jsonObject.getList('Subscribers').size());        
    }
    
    
    // Description:
    // This test case checks the parser is able to parse
    // a list of objects.
    //
    // Last Modified: 03/31/2014
    public static testMethod void testApplicationParserListOfObjects(){
        
        //Setup
        String json = '{"name":"dsads", "objects": [{"id": 1, "name":';
        json += '"nameOne"},{"id": 2, "name": "nameTwo"},{"id": 3, ';
        json += '"name": "nameThree"}]}';
        
        //Execution
        Test.startTest();
        JsonToMapParser model = new JsonToMapParser();
        Map<String, Object>  mapping = model.parse(json);       
        JsonObject jsonObject = new JsonObject(mapping);
        Test.stopTest();
        
        // Assertions
        System.assertEquals(3,jsonObject.getList('objects').size());
    }
    
    // Description:
    // This test case checks the parser is able to parse
    // a invalid list of applications.
    //
    // Last Modified: 03/31/2014
    public static testMethod void testApplicationParserWithInvalidData(){       
        //Setup
        String jsonInvalid = '{"name""dsads", "objects": [{"id": 1, "name"';
        jsonInvalid += ': "nameOne"},{"id": 2, "name": "nameTwo"},{"id": 3,';
        jsonInvalid += '"name": "nameThree"}]}';
    	boolean launchCalThrown = false;
           
        //Execution
        try{
            JsonToMapParser model = new JsonToMapParser();
			Map<String, Object>  mapping = model.parse(jsonInvalid);
				
            }catch(JSONException e){
             	launchCalThrown = true;
            }
        
		// Assertions
        System.assertEquals(true,launchCalThrown);
    }
    
    
    // Description:
    // This test case checks the parser is able to parse
    // a invalid list of applications.
    //
    // Last Modified: 03/31/2014
    public static testMethod void testApplicationParserWithNullData(){       
        //Setup
        String jsonNull = '{"name": null, "objects": [{"id": 1, "name":';
        jsonNull += '"nameOne"},{"id": 2, "name": "nameTwo"},{"id": 3,';
        jsonNull += '"name": "nameThree"}]}';
    	boolean launchCalThrown = false;
           
        //Execution
        Test.startTest();
        JsonToMapParser model = new JsonToMapParser();
        Map<String, Object>  mapping = model.parse(jsonNull);       
        JsonObject jsonObject = new JsonObject(mapping);
        Test.stopTest();
        
		// Assertions
        System.assertEquals('null',jsonObject.getString('name'));		
    }
}