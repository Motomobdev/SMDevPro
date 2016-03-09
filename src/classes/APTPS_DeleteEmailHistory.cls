/***************************************************************************
  COMMENT: This batch class deletes all inbound emails history 
           that have been processed
  Entry point: DeleteEmailHistorySched (Schedulable class)
  Testmethod: DeleteEmailHistoryTestClass
***************************************************************************/  

global class APTPS_DeleteEmailHistory implements Database.Batchable<sObject> {
    global String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject>scope){
        List<Approval_Inbound_Email__c> deleteList = new List<Approval_Inbound_Email__c>();
        
        for(Sobject s: scope){
            Approval_Inbound_Email__c aie = (Approval_Inbound_Email__c)s;
            deleteList.add(aie);
        }
        try{
            delete deleteList;
        }catch(DmlException de){
            System.debug(de.getDmlMessage(0));
        }
    }
   
    global void finish(Database.BatchableContext BC){}
}