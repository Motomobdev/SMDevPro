/*
Methods to set the Approvers on new Device Application records

*/

public with sharing class AIFApproval {
    
    //Define Variables 
    private static boolean isTestMode = false;
    public static Set<Id> deviceIds = NEW Set<Id>();
/*
 //Create a constant for the Device as well as the Matrix   
    private static Map<ID,AIF_Approval_Matrix__c> APPROVAL_MAP_CONST {
        get {
            if (APPROVAL_MAP_CONST == null) { APPROVAL_MAP_CONST = getAIFApprovalMap(); }
            return APPROVAL_MAP_CONST;
        }
        set;
    }
  
//Setup Approvals Map  
    private static Map<ID,AIF_Approval_Matrix__c> getAIFApprovalMap(){
       System.debug('Hello World 10');
       Map<ID,AIF_Approval_Matrix__c> results = new Map<ID,AIF_Approval_Matrix__c>();
       //List<AIF_Approval_Matrix__c> records = [select Device_Name__c,LRB_approver__c,DTS_approver__c, FMD_Status_Check_Approver__c, Confirmation_of_Budget_Royalties__c, Finance_Approver__c, Application_Requester__c from AIF_Approval_Matrix__c WHERE Device_name__c in : dev_apps_sfdc2 ];
        List<AIF_Approval_Matrix__c> records = [select Device_Name__c,LRB_approver__c,DTS_approver__c, FMD_Status_Check_Approver__c, Confirmation_of_Budget_Approver__c, Finance_Approver__c, Application_Requester__c from AIF_Approval_Matrix__c WHERE Device_name__c in : dev_apps_sfdc2 ]; 
        for(AIF_Approval_Matrix__c record : records){
           if (!results.containsKey(record.Device_name__c)){ results.put(record.Device_Name__c, record); }
        }
        return results;
 }

 */
 
 //Set the Approvers equal to its matching device in the map 
	public static void setAIFApprovers(DeviceApplicationAssoc__c[] device){
       
       	for (Deviceapplicationassoc__c d:device){ deviceIds.ADD(d.Device__c); }   
       	
       	Map<Id, AIF_Approval_Matrix__c>  deviceIdAIFMatrixMap = new Map<Id, AIF_Approval_Matrix__c>();
       	for(AIF_Approval_Matrix__c aifm : [select Device_Name__c,LRB_approver__c,DTS_approver__c, FMD_Status_Check_Approver__c, Confirmation_of_Budget_Approver__c, Finance_Approver__c, Application_Requester__c from AIF_Approval_Matrix__c WHERE Device_name__c in : deviceIds ]){
       		deviceIdAIFMatrixMap.put(aifm.Device_Name__c, aifm);
       	}
                          
       	for (DeviceApplicationAssoc__c d:device){ 
       		if(deviceIdAIFMatrixMap.containsKey(d.Device__c)){
       			d.LRB_Approver__c = deviceIdAIFMatrixMap.get(d.device__c).LRB_Approver__c;
       			d.DTS_Approver__c = deviceIdAIFMatrixMap.get(d.device__c).DTS_approver__c;
       			d.Confirmation_of_Budget_Approver__c = deviceIdAIFMatrixMap.get(d.device__c).Confirmation_of_Budget_Approver__c;
       			d.Finance_Approver__c = deviceIdAIFMatrixMap.get(d.device__c).Finance_Approver__c;
       			d.Requester__c = deviceIdAIFMatrixMap.get(d.device__c).Application_Requester__c;
       		}         
        	/*System.debug('Got Here 6 ' + d.device__c); System.debug('SFDC: APPROVAL_MAP_CONST: ' + APPROVAL_MAP_CONST); System.debug('SFDC: APPROVAL_MAP_CONST.get(d.device__c): ' + APPROVAL_MAP_CONST.get(d.device__c));
            if(APPROVAL_MAP_CONST.get(d.device__c) != null){
	            if(APPROVAL_MAP_CONST.get(d.device__c).LRB_Approver__c != null) {
	            	d.LRB_Approver__c= APPROVAL_MAP_CONST.get(d.device__c).LRB_Approver__c;
            	} 
            	
            	if(APPROVAL_MAP_CONST.get(d.device__c).DTS_approver__c != null) {
            		d.DTS_Approver__c= APPROVAL_MAP_CONST.get(d.device__c).DTS_approver__c;
        		} 
        		
        		if(APPROVAL_MAP_CONST.get(d.device__c).Confirmation_of_Budget_Approver__c != null) {
        			d.Confirmation_of_Budget_Approver__c= APPROVAL_MAP_CONST.get(d.device__c).Confirmation_of_Budget_Approver__c;
    			} 
    			
    			if(APPROVAL_MAP_CONST.get(d.device__c).Finance_Approver__c != null) {
    				d.Finance_Approver__c= APPROVAL_MAP_CONST.get(d.device__c).Finance_Approver__c;
				} 
				
				if(APPROVAL_MAP_CONST.get(d.device__c).Application_Requester__c != null) {
					d.Requester__c= APPROVAL_MAP_CONST.get(d.device__c).Application_Requester__c;
				}
	            //if(APPROVAL_MAP_CONST.get(d.device__c).FMD_Status_Check_Approver__c != null) {d.FMD_Status_Check_Approver__c = APPROVAL_MAP_CONST.get(d.device__c).FMD_Status_Check_Approver__c;}
            } */         
       	}
	}

	//TESING METHODS 
	
	private testmethod static void TestMethodA() {
	    isTestMode = true;
	    Device__c device = New Device__c(device_id__c='aiftest');
	    insert device;
	    Account acc = new Account(Name='account', Tier__c ='1');
		insert acc;
	    Application__c application = New Application__c(Name='app', Account__c=acc.Id);
	    insert application;
		User u = [SELECT ID FROM User WHERE isActive=true LIMIT 1];
		
		Aif_Approval_Matrix__c aam = New Aif_Approval_Matrix__c(Device_Name__c=device.id,LRB_approver__c=u.id,DTS_approver__c=u.id, FMD_Status_Check_Approver__c=u.id, Confirmation_of_Budget_Approver__c=u.id, Finance_Approver__c=u.id,Application_Requester__c=u.id);
		insert aam;
	
	    DeviceApplicationAssoc__c devapp = new DeviceApplicationAssoc__c(device__c=device.id,application__c=application.id);
	    
	    Test.startTest();
	    insert devapp;
	    Test.stopTest();
	
	}
}