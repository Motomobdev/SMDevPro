/*****************************************************
 COMMENT: Testmethod for the DeleteEmailHistory and 
          DeleteEmailHistorySched class 
*****************************************************/

@isTest(SeeAllData=false)

public class APTPS_DeleteEmailHistoryTestClass{
    
    static testmethod void DeleteEmailHistoryTest(){
        
        List<Approval_Inbound_Email__c> aieList = new List<Approval_Inbound_Email__c>();
        
        //Create Approval_Inbound_Email__c records
        for(Integer i=0; i<50; i++){
            Approval_Inbound_Email__c aie = new Approval_Inbound_Email__c(Processed__c = true);
            aieList.add(aie);
        }
        
        insert aieList;
        
        Test.startTest();
        /*String query = 'SELECT Id FROM Approval_Inbound_Email__c';
        DeleteEmailHistory d = new DeleteEmailHistory();
        d.query = query;
        Database.executeBatch(d);*/
        
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        String jobId = System.schedule('ScheduleApexClassTest',CRON_EXP, new APTPS_DeleteEmailHistorySched());
        Test.stopTest();
    }
}