/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 04/01/2014
// Last Modified: José Elias Araújo
// Last Modified by: 04/03/2014
//
// Description:
// This test class contains methods to test if the methods
// of LaunchCalDataParser class is working properly.
/**********************************************************/
@isTest
public class LaunchCalDataParserTest{
	
	private static String SFDCID = '82SF001007841';
	private static String createdBy = 'markrobbins@motorola.com';
    private static String appVersion = '4.2.02.1';    

    // Description:  
	// Returns a JSON emulanting the information retrieved from
	// LaunchCal tool with valid values in all fields. 
	//
	// Input: none
	//
	// Returns: Striung JSON emulanting the information retrieved from
	// LaunchCal 
    private static String getJson(){       
       	String unique_id = '100432';
        String projectId = '100432';
        String version = '8';
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
        String subscribers = '"fkn006@motorola.com","e10330@motorola.com"';
        Boolean partial = false;
        String calendarIds = '53001';
        String fyiCalendarIds = '[]';
        String attributes = '{"83001":"' + SFDCID + '", "44001":"' + appVersion + '"}';
        String approver58001 = '{"approverDefinitionId":"58001","approvalStatus":';
        approver58001 += '"APPROVED","flippedBy":"dschuster@motorola.com","flippedOn":';
        approver58001 += '"1389571954154", "owners":["dschuster@motorola.com"], "notes":""}';
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
        jsonApp += '"launchJustification":"'+launchJustification+'", "createdBy": "'+createdBy +'",';
        jsonApp += '"subscribers": ['+subscribers+'],"partial":'+partial+', "calendarIds":';
        jsonApp += calendarIds+',"fyiCalendarIds": '+fyiCalendarIds+',"attributes": '+attributes+',';
        jsonApp += '"approvers": '+approvers+', "filteredAttributes":'+filteredAttributes+',';
        jsonApp += '"approverEmails": ['+approverEmails+'], "approvalPendingEmails":'+approvalPendingEmails+',';
		jsonApp += '"inconsistent": '+inconsistent+', "incomplete": '+incomplete+'}]}';
        
		return jsonApp;    
    }

    // Description:  
	// Returns a JSON emulanting the information retrieved from
	// LaunchCal tool with invalid values in all fields. 
	//
	// Input: none
	//
	// Returns: Striung JSON emulanting the information retrieved from
	// LaunchCal     
    private static String getJsonInvalid(){
       	String unique_id = '100432';
        String projectId = '100432';
        String version = '8';
        String status = 'LAUNCHED';
        String name = '100364 Xfon_NA_SPR_KK_MR3_Initial_LE';
        String description = 'This is our initial Lab Entry. We are planning a subsequent';
        description += 'SW drop before TA';            
        Long created = 1389490672049L;
        Long updated = 1389577344381L;
        Date launchDate = Date.newInstance(2014,01,13);
        Boolean hardDeadline = false;
        String approvalStatus = 'APPROVED';
        String launchJustification = '';
        String subscribers = '"fkn006@motorola.com","e10330@motorola.com"';
        Boolean partial = false;
        String calendarIds = '53001';
        String fyiCalendarIds = '[]';
        String attributes = '{"83001":"' + SFDCID + ', "44001":"' + appVersion + '"}}';
        String approver58001 = '{"approverDefinitionId":"58001","approvalStatus":"APPROVED",';
        approver58001 += '"flippedBy":"dschuster@motorola.com","flippedOn":"1389571954154",';
        approver58001 += '"owners":["dschuster@motorola.com"], "notes":""}';
		String approvers = '{"58001":'+approver58001+'}';
        String filteredAttributes = '[]';
        String approverEmails = '"dschuster@motorola.com"';
        String approvalPendingEmails = '[]';
        Boolean inconsistent = false;
        Boolean incomplete = false;
        
		String jsonApp = '{"launches"[{"id":"' + unique_id + '","projectId":'+projectId+',';
        jsonApp += '"version":'+version+',"status":"'+status+'","name":"';
        jsonApp += name+'","description":"'+description+'","created":'+created+',';
        jsonApp += '"updated":'+updated+',"launchDate":"'+launchDate+'","hardDeadline":';
        jsonApp += hardDeadline+', "approvalStatus":"'+approvalStatus+'",';
        jsonApp += '"launchJustification":"'+launchJustification+'", "createdBy": "'+createdBy+'",';
        jsonApp += '"subscribers": ['+subscribers+'],"partial":'+partial+', "calendarIds":';
        jsonApp += calendarIds+',"fyiCalendarIds": '+fyiCalendarIds+',"attributes": '+attributes+',';
        jsonApp += '"approvers": '+approvers+', "filteredAttributes":'+filteredAttributes+',';
        jsonApp += '"approverEmails": ['+approverEmails+'], "approvalPendingEmails":'+approvalPendingEmails+',';
		jsonApp += '"inconsistent": '+inconsistent+', "incomplete": '+incomplete+'}]}';
        
		return jsonApp;   
    }
    
    // Description:
    // This test case checks the parser is able to parse
    // a valid list of launches.
    //
	// Last Modified: 04/03/2014
    public static testMethod void testApplicationParser(){
        
        //Setup
        String jsonApp = getJson();
           
        //Execution
        Test.startTest();
      	LaunchCalDataParser parser = new LaunchCalDataParser();
        List<LaunchCal>  listObjects = parser.getLaunches(jsonApp);       
		Test.stopTest();

		// Assertions
        System.assertEquals(SFDCID, listObjects.get(0).application.getApplicationID());
        System.assertEquals(appVersion, listObjects.get(0).version);        
        System.assertEquals(createdBy, listObjects.get(0).createdBy.getEmail());	
    }

    // Description:
    // This test case checks the parser is able to parse
    // a valid list of launches.
    //
	// Last Modified: 04/03/2014
    public static testMethod void testParseValidLaunchCals(){
     	//Setup
        String jsonApp = getJson();
           
        //Execution
        Test.startTest();
      	LaunchCalDataParser parser = new LaunchCalDataParser();
        List<LaunchCal>  listObjects = parser.getLaunches(jsonApp);       
		Test.stopTest();

		// Assertions
        System.assertEquals(1,listObjects.size());   
    }
    
    // Description:
    // This test case checks the parser is able to handle 
    // when receiving an invalid list of launches.
    //
	// Last Modified: 04/03/2014
    public static testMethod void testParseInvalidLaunchCals(){
        
        //Setup
        String jsonInvalid = getJsonInvalid();
    	boolean launchCalThrown = false;
           
        //Execution
        try{
          	LaunchCalDataParser parser = new LaunchCalDataParser();
        	List<LaunchCal>  listObjects = parser.getLaunches(jsonInvalid);       
				
        }catch(JSONException e){
            launchCalThrown = true;
        }
        
		// Assertions
        System.assertEquals(true,launchCalThrown);
    }
}