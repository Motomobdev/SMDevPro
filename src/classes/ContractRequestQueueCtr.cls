public with sharing class ContractRequestQueueCtr 
{
    public list<Contract_Request__c> pendingRequests {get; set;}
    
    public ContractRequestQueueCtr()
    {
        getPendingRequests();
    }
    
    private void getPendingRequests()
    {
        pendingRequests = [SELECT Name,
                          Requester__r.Name,
                          Date_Submitted__c,
                          Company_Name__r.Name,
                          Partner_Contact_Name__c,
                          What_Software_Requested__c,
                          Agreement_Type__c,
                          Request_Type__c,
                          Date_Required__c,
                          Urgency__c,
                          Which_Device__c,
                          Team__c
                   FROM   Contract_Request__c
                   WHERE  Request_Status__c = 'Submitted'
                   ORDER BY Name ASC];
    }
    
    public void refresh()
    {
        getPendingRequests();
    }
}