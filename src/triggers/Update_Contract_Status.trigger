trigger Update_Contract_Status on Apttus__APTS_Agreement__c (after update) {
 /*
     * Author: Swetha Mandava
     * Creation Date: 22-Aug-2013
     * Related Test Class:
     * Description:
     *     The Contract tied to the agreement is updated bring signed copy to Contract
     *     when the agreement is Fully Executed.
     */
// if(Recursionblocker.UpdateContractStatusflag){
 
//      Recursionblocker.UpdateContractStatusflag = false;
      
      Set<Apttus__APTS_Agreement__c> agreementsWithContracts =
        new Set<Apttus__APTS_Agreement__c>();

      Map<Id, Apttus__APTS_Agreement__c> contractMap =
        new Map<Id, Apttus__APTS_Agreement__c>();
        
      for (Integer i = 0; i < Trigger.new.size(); ++i)
      {
        Apttus__APTS_Agreement__c oldAg = Trigger.old[i];
        Apttus__APTS_Agreement__c newAg = Trigger.new[i];

        if (newAg.Contract__c != null &&
           ((oldAg.Apttus__Status__c != 'Activated' && newAg.Apttus__Status__c == 'Activated') ||
             (oldAg.Apttus__Status__c != 'Approved' && newAg.Apttus__Status__c == 'Approved')) )
           {
            agreementsWithContracts.add(newAg);
            contractMap.put(newAg.Contract__c, newAg);
           }
      }

        if (!contractMap.isEmpty()) {

        List<Contract> contracts =
            [select id, Contract_Status__c,Contract_Phase__c,Status
            from Contract where id in :contractMap.keySet()];
        
        List<Attachment> insertingAttachments = new List<Attachment>();

        for (Contract contract: contracts) {
            Apttus__APTS_Agreement__c ag = contractMap.get(contract.id);

            if (ag.Apttus__Status__c == 'Approved')
            {
                  contract.Contract_Status__c = 'Approvals';
            }
            else if (ag.Apttus__Status__c == 'Activated')
            {
                contract.EndDate = ag.Apttus__Contract_End_Date__c;
                contract.ContractTerm = integer.valueOf(ag.Apttus__Term_Months__c);
                contract.CompanySignedDate = ag.Apttus__Company_Signed_Date__c;
                contract.CustomerSignedDate = ag.Apttus__Other_Party_Signed_Date__c;

                contract.Contract_Status__c = 'Fully Executed';
                contract.Contract_Phase__c = 'Execution and Processing';

                for(Attachment atch :  [select id,name,body from Attachment where name like '%signed%' and parentid = :ag.Id]){
              
                   Attachment  newattch = new Attachment();
                   newattch = atch.clone(false);
                   newattch.body = atch.body; // required field
                   newattch.name = contract.id + atch.name;// required field
                   newattch.parentId = contract.id;

                   insertingAttachments.add(newattch);
               }
            }
        }
        if (!insertingAttachments.isEmpty())
          insert insertingAttachments;

        if (!contracts.isEmpty())
            update contracts;
    }
   //}
}