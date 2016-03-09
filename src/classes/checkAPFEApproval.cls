public class checkAPFEApproval implements Schedulable, Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{

    public String query;
    public ID batchprocessid;
    public Map<Id,String> errors;
    public static Boolean Test_Approve_Value;


    public checkAPFEApproval(){
        query = 'Select id,Name,Approved__c From Google_TA__c Where Approved__c = False';
        errors = new Map<Id,String>();
    }
    
    public void execute(SchedulableContext context){
    	batchprocessid = Database.executeBatch(this,8);
    }
    
    public void execute(Database.BatchableContext BC,List<sObject> batch) {
    	
		// Get Token
		APFE_Utility.TokenResponse token;
        if(Test.isRunningTest()) token = (APFE_Utility.TokenResponse)JSON.deserialize('{"access_token":"token","expires_in":3600}',APFE_Utility.TokenResponse.class);
        else token = APFE_Utility.createToken();
        
        // Get status of all records using name
        List<Google_TA__c> googleTAs = (List<Google_TA__c>) batch;
        for(Google_TA__c googleTA: googleTAs){
            
            String response;
            
            
            if(!Test.isRunningTest()) response = APFE_Utility.getBuildStatus(googleTA.Name,token);
            else if(Test_Approve_Value){
                response = '{ "kind": "androidpartner#build_status","approvalStatus": "APPROVED"}';
            }
            else{
               response = '{"error":{"errors": [{"domain": "global","reason": "invalid","message": "Unable to query fingerprint status"}],"code": 400,"message": "Unable to query fingerprint status"}}'; 
            }
            APFE_Utility.APFE_SubmitFile_Response responseRecord = (APFE_Utility.APFE_SubmitFile_Response) JSON.deserialize(response, APFE_Utility.APFE_SubmitFile_Response.class);
            
            
            if(responseRecord.error != null){
                errors.put(googleTA.id,responseRecord.error.message);
            } 
            else if(responseRecord.approvalStatus != null && responseRecord.approvalStatus.toLowerCase() == 'approved'){
                googleTA.Approved__c = true;
            }
        }
  	
    	// update Google TAs
    	update googleTAs;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
    	// Get Token for APFE use and updateToken
        if(!Test.isRunningTest()){
            APFE_Utility.TokenResponse token = APFE_Utility.createToken();
            APFE_Utility.updateToken(token);
    	}
        
        return Database.getQueryLocator(query);
  	}
    
    public void finish(Database.BatchableContext BC) {
    // Access initialState here 
        
    }
    
}