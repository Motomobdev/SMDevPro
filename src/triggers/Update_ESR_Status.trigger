trigger Update_ESR_Status on Apttus__APTS_Agreement__c (after update) {
    /*
     * Author: Rajesh Krishnaiah
     * Creation Date: 27-Nov-2012
     * Related Test Class: APTPS_Test_Util
     * Description:
     *     The External Spend Request (ESR) tied to the agreement is updated
     *     when the agreement steps thru its approval life cycle.
     */
     
    Set<Apttus__APTS_Agreement__c> agreementsWithESRs = 
        new Set<Apttus__APTS_Agreement__c>();
    Map<Id, Apttus__APTS_Agreement__c> esrMap = 
        new Map<Id, Apttus__APTS_Agreement__c>();
    
    for (Integer i = 0; i < Trigger.new.size(); ++i) {
        Apttus__APTS_Agreement__c oldAg = Trigger.old[i];
        Apttus__APTS_Agreement__c newAg = Trigger.new[i];

        if (newAg.external_spend_request__c != null &&
           ( (oldAg.Apttus__Status__c != 'Pending Approval' && newAg.Apttus__Status__c == 'Pending Approval') ||
             (oldAg.Apttus__Status__c != 'Approved' && newAg.Apttus__Status__c == 'Approved') ||
             (oldAg.Apttus__Status__c != 'Fully Signed' && newAg.Apttus__Status__c == 'Fully Signed') 
           )) {
            agreementsWithESRs.add(newAg);
            esrMap.put(newAg.external_spend_request__c, newAg);
        }
    }
    
    if (!esrMap.isEmpty()) {
    
        List<External_Spend_Request__c> esrs = 
            [select id, contract_status__c 
            from External_Spend_Request__c
            where id in :esrMap.keySet()];
        
        for (External_Spend_Request__c esr: esrs) {
            Apttus__APTS_Agreement__c ag = esrMap.get(esr.id);
            
            if (ag.Apttus__Status__c == 'Pending Approval')
                esr.contract_status__c = 'Executive Summary Approvals In Progress';
            else if (ag.Apttus__Status__c == 'Approved')
                esr.contract_status__c = 'Contract Pending Final Signature';
            else if (ag.Apttus__Status__c == 'Fully Signed')
                esr.contract_status__c = 'Submitted for PR Creation';
        }
        
        if (!esrs.isEmpty())
            update esrs;
    }
}