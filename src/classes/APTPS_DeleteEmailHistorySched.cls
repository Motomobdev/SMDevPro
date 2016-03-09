/*************************************************************
  COMMENT: Schedulable class. Calls the batch class that deletes
           email history records that have been processed
  Testmethod: DeleteEmailHistoryTestClass
**************************************************************/  

global class APTPS_DeleteEmailHistorySched implements Schedulable {
   global void execute(SchedulableContext ctx) {
        String query = 'SELECT Id FROM Approval_Inbound_Email__c WHERE Processed__c = true';
        APTPS_DeleteEmailHistory d = new APTPS_DeleteEmailHistory ();
        d.query = query;
        Database.executeBatch(d);
   }
}