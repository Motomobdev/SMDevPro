@isTest
public class testMassDeleteRecords{

    public static testMethod void testBatch() {

    // Create 200 test accounts - this simulates one execute.   

        List <Account> accns = new List<Account>();
        for(integer i = 0; i<200; i++){
             Account a = new Account(Name='testAccount'+i); 
             accns.add(a);
        }

        insert accns;

    // Important - the Salesforce.com test framework only allows you to   
    // test one execute.   

       Test.StartTest();
       Database.executeBatch(new MassDeleteRecords('Select id from Account Where Name like \'testAccount%\''));
       Test.StopTest();
       
       accns = [Select id From Account];
       
       System.assertEquals(0,accns.size());

   }      
    
}