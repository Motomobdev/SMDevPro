/*
Handler Class meant to be called by trigger and call appropriate methods
*/

public with sharing class Application_Update 
{
    public static void beforeUpdate(List<Application__c> newList, List<Application__c> oldList)
    {
        ApplicationMethods.setSkipLRBField(newList);
        ApplicationMethods.updateContractApplications(newList, oldList);

        // *** VHD Ticket #39089 | FR124104 | Neel Desai | 21/Aug/2012 ***
        ApplicationMethods.uncheckAutomatePartnerChecklistApproval(newList, oldList);
    }
    
    public static void afterUpdate(List<Application__c> newList, List<Application__c> oldList)
    {
        ApplicationMethods.checkAvailableForUseSettting(newList, oldList);
    }   
}