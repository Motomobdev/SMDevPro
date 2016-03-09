trigger UpdateAgreementTotal on External_Spend_Request__c (after update) {

    /*
     * Author: Rajesh Krishnaiah
     * Creation Date: 05-Nov-2012
     * Description: Update the related/generated agreement's total value
     *              anytime the total cost on the external spend request changes.
     * Change history:
     */
    Set<External_Spend_Request__c> esrsWithCostChanges = new Set<External_Spend_Request__c>();
    Set<Id> agreementIds = new Set<Id>();
    
    for (Integer i = 0; i < Trigger.new.size(); ++i) {
        
        External_Spend_Request__c esrNew = Trigger.new[i];
        External_Spend_Request__c esrOld = Trigger.old[i];
        
        // ESR is already converted to an agreement and there is change in cost
        if (esrNew.Agreement__c != null && esrNew.total_cost__c != esrOld.total_cost__c) {
            esrsWithCostChanges.add(esrNew);
            agreementIds.add(esrNew.Agreement__c);
        }
    }
    
    Map<Id, Apttus__APTS_Agreement__c> agrements = new Map<Id, Apttus__APTS_Agreement__c>(
        [select id, Apttus__Total_Contract_Value__c 
         from Apttus__APTS_Agreement__c
         where id in :agreementIds]);

    List<Apttus__APTS_Agreement__c> agreementsToUpdate = new List<Apttus__APTS_Agreement__c>();
    
    for (External_Spend_Request__c esr : esrsWithCostChanges) {
        Apttus__APTS_Agreement__c agreement = agrements.get(esr.agreement__c);
        
        if (agreement != null) {
            agreement.Apttus__Total_Contract_Value__c = esr.total_cost__c;
            agreementsToUpdate.add(agreement);
        }
    }
    
    if (!agreementsToUpdate.isEmpty())
        update agreementsToUpdate;
}