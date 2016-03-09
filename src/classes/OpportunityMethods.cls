public without sharing class OpportunityMethods 
{
    /**************************************************************************
    CREATED BY: Neel Desai
    CREATED ON: 31-Oct-2013
    REASON    : Requested by Brian Chiang VHD#
                
    **************************************************************************/
    public static void createZuoraOpportunity(List<Contract> contracts)
    {
        // get id of "Software Royalty" record type
        String recordTypeId = Schema.getGlobalDescribe().get('Opportunity').getDescribe().getRecordTypeInfosByName().get('Software Royalty').getRecordTypeId();
        
        Set<Id> contractIdsToSkip = new Set<Id>();
        List<Account> accountsToUpdate = new List<Account>();
        List<Opportunity> zuoraOpportunitiesToAdd = new List<Opportunity>();
        
        // Existing opportunities
        Opportunity[] oppList = [SELECT Contract__c FROM Opportunity WHERE Contract__c IN :contracts];
        // To check if Allow Opportunities is set on Account
        AggregateResult[] arList = [SELECT Account.Id accId, Account.Allow_Opportunities__c isAllowOpportunities, COUNT(Id) FROM Contract WHERE Id IN :contracts GROUP BY Account.Id, Account.Allow_Opportunities__c];
        
        for(Opportunity opp : oppList) {
            contractIdsToSkip.add(opp.Contract__c); // No need to create opportunity for these contracts
        }
        
        for(AggregateResult ar : arList) {
            if((Boolean)ar.get('isAllowOpportunities') == false) // Allow Opportunities flag is False
            {
                accountsToUpdate.add(new Account(Id = (Id)ar.get('accId'), Allow_Opportunities__c = true)); // set flag to True
            }
        }
        
        for(Contract contract : contracts) {
            if(!contractIdsToSkip.contains(contract.Id)) // Do not create opportunity if already exists 
                zuoraOpportunitiesToAdd.add(new Opportunity(RecordTypeId = RecordTypeId, 
                                                            Name = contract.Name, 
                                                            AccountId = contract.AccountId, 
                                                            Contract__c = contract.Id, 
                                                            StageName = '7. Closed Won', 
                                                            CloseDate = Date.today().addMonths(3)));
        }
        
        if(!accountsToUpdate.isEmpty())
            update accountsToUpdate; // update accounts

        if(!zuoraOpportunitiesToAdd.isEmpty())
            insert zuoraOpportunitiesToAdd; // create opportunities
    }
}