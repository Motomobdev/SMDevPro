/**
 * @author           Gangadhar Rachakonda
 * @version          1.0 
 * @date             8/03/2014
 * @Status           Developed
 * @description      The Purpose of the Class is to Test the PR_Batch                  
 *
 */
@isTest
public  class PR_Batch_Test
{
   // <OBJECTIVE>
   //     This method is to test the PR_Batch class and the required test data is prepared in this Method  
   // </OBJECTIVE>   
   // <RETURNS>
   //    Void
   // </RETURNS>     
   static testmethod void sendRangingRecords_Test()
   {
       Profile p = PR_DataFactory_Utility_Test.getProfile();

       User usr = PR_DataFactory_Utility_Test.createTestUser('usertest','usr@testorg.com','UTF-8','Testing','en_US','en_US',
                                                    p.Id,'United States','America/Los_Angeles','sendRanging_user_test@testorg.com');
                                                    
       User usr1 = PR_DataFactory_Utility_Test.createTestUser('usr1test','usr1@testorg.com','UTF-8','Testing1','en_US','en_US',
                                                    p.Id,'United States','America/Los_Angeles','sendRanging_user_name@testorg.com');
                                                    
       User usr2 = PR_DataFactory_Utility_Test.createTestUserhavingManager('usr2test','usr2@testorg.com','UTF-8','Testing2','en_US','en_US',
                                                    p.Id,'United States','America/Los_Angeles','sendRanging_u2@testorg.com',usr.Id);
      
       User usr3 = PR_DataFactory_Utility_Test.createTestUserhavingManager('usr3test','usr3@testorg.com','UTF-8','Testing3','en_US','en_US',
                                                    p.Id,'United States','America/Los_Angeles','sendRanging_u3@testorg.com',usr.Id);
                           
       User usr4 = PR_DataFactory_Utility_Test.createTestUserhavingManager('usr4test','usr4@testorg.com','UTF-8','Testing4','en_US','en_US',
                                                    p.Id,'United States','America/Los_Angeles','sendRanging_u4@testorg.com',usr1.Id);

       Account acc = PR_DataFactory_Utility_Test.createTestAccount('Test1','North America','Test','Test','Test','Test','Test',
                                                              'Centralized','LTD.','Test','CDMA');
                  
       Account acc1 = PR_DataFactory_Utility_Test.createTestAccount('Test2','North America','Test','Test','Test','Test','Test',
                                                              'Centralized','LTD.','Test','CDMA');
       Account acc2 = PR_DataFactory_Utility_Test.createTestAccount('Test3','North America','Test','Test','Test','Test','Test',
                                                              'Centralized','LTD.','Test','CDMA');
       Account acc3 = PR_DataFactory_Utility_Test.createTestAccount('Test4','North America','Test','Test','Test','Test','Test',
                                                              'Centralized','LTD.','Test','CDMA');
       Account acc4 = PR_DataFactory_Utility_Test.createTestAccount('Test5','North America','Test','Test','Test','Test','Test',
                                                              'Centralized','LTD.','Test','CDMA');
       Account acc5 = PR_DataFactory_Utility_Test.createTestAccount('Test6','North America','Test','Test','Test','Test','Test',
                                                              'Centralized','LTD.','Test','CDMA');
                                                                         
       PMD_Program__c prgm = PR_DataFactory_Utility_Test.createProgramrecord( 'TEST');    
    
       PMD_Project__c prj = PR_DataFactory_Utility_Test.createProjectrecord('Test',prgm.id); 
                        
       List<Project_Ranging__c> lstProjectRanging = new List<Project_Ranging__c>();                         
       Project_Ranging__c pr = PR_DataFactory_Utility_Test.createProjectRangingNoOwner( acc.id,prj.Id,'Ranged',date.today());
       lstProjectRanging.add(pr);   
       Project_Ranging__c pr1 = PR_DataFactory_Utility_Test.createProjectRanging( acc1.id, usr.id,prj.Id,'Do Not Present',(date.today()-2));
       lstProjectRanging.add(pr1);
       Project_Ranging__c pr2 = PR_DataFactory_Utility_Test.createProjectRanging( acc2.id, usr2.id,prj.Id,'Not Pursued',(date.today()+1));
       lstProjectRanging.add(pr2);
       Project_Ranging__c pr3 = PR_DataFactory_Utility_Test.createProjectRanging( acc3.id, usr3.id,prj.Id,'Not Ranged',(date.today()+2));
       lstProjectRanging.add(pr3);
       Project_Ranging__c pr4 = PR_DataFactory_Utility_Test.createProjectRanging( acc4.id, usr4.id,prj.Id,'Very Low Portability',(date.today()-1));
       lstProjectRanging.add(pr4);
       Project_Ranging__c pr5 = PR_DataFactory_Utility_Test.createProjectRanging( acc5.id, usr2.id,prj.Id,'Very Low Portability',(date.today()-1));
       lstProjectRanging.add(pr5);
        
       List<string> listOfStatus = new List<string>();
       listOfStatus.add('Do Not Present');
       listOfStatus.add('Not Pursued');
       listOfStatus.add('Ranged');
    
       PR_DataFactory_Utility_Test.insertStatuses(listOfStatus);
        
       PR_Batch obj = new PR_Batch();
    
       // Test.StartTest();
       obj.sendRangingRecords();
       system.assertEquals(4, obj.lstEmailMessages.size());
       // Test.stopTest();
    
   }
 }