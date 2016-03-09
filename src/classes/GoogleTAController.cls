public class GoogleTAController{
    
    
    /**************************************************/
    //				Trigger Methods					  //
    /**************************************************/			
    
    // filter list based on approvals
    public static List<Google_TA__c> getApprovedRecords(Map<ID,Google_TA__c> oldMap, List<Google_TA__c> updatedGoogleTAs){
        List<Google_TA__c> approved = new List<Google_TA__c>();
        
        for(Google_TA__c googleTA: updatedGoogleTAs){
            if(!oldMap.containsKey(googleTA.id)) continue;
            if(!oldMap.get(googleTA.id).approved__c && googleTA.Approved__c) approved.add(googleTA);
        }
        
        return approved;
    }
    
    // update SW Projects
    public static void updatedSWProjectsWithApprovalDate(List<Google_TA__c> approvedRecords){
        
        // Get Devices
        Map<ID,Device__c> devices = new Map<ID,Device__c>([Select id,White_listed_build_fingerprint__c, Google_TA_Approval_Status__c  From Device__c Where ID IN (Select Device__c From Google_TA__c Where id IN :approvedRecords)]);
    
    	// Update Devices
        for( Google_TA__c googleTA: approvedRecords){
            if(!devices.containsKey(googleTA.device__c)){
                //googleTA.addError('No Devices found from Device ID');
                continue;
            } 
            
            // fill in data
            devices.get(googleTA.Device__c).White_listed_build_fingerprint__c = googleTA.Name;
            devices.get(googleTA.Device__c).Google_TA_Approval_Status__c = 'Completed';
            devices.get(googleTA.Device__c).CTS_Submission_Status__c  = 'Sent to Google';
        }
        
        if(devices.size() > 0 ) update devices.values();
    }
}