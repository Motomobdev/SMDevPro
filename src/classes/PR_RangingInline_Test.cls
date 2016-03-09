/**
 * @author           Gangadhar Rachakonda
 * @version          1.0 
 * @date             8/06/2014
 * @Status           Developed
 * @description      This  class is System  Test class for PR_RangingInline  Class                  
 */
@isTest
public Class PR_RangingInline_Test
{
  public static testmethod  void Inline_Test()
  {
     
      string Message = 'Testmessage';
      
      PR_Inline__c prInline = PR_DataFactory_Utility_Test.insertInlineBody(Message);
      
      Account acc = PR_DataFactory_Utility_Test.createTestAccount('Test Account','North America','Test1','Test2','Test3','Test4','Test5',
                                                              'Centralized','LTD.','Test9','GMT');
      
       
       PMD_Program__c prg = PR_DataFactory_Utility_Test.createProgramrecord('TESTProgram1');  
         
      
       PMD_Project__c prj = PR_DataFactory_Utility_Test.createProjectrecord('Test',prg.id); 
       
       
        Project_Ranging__c objProjectRanging = new Project_Ranging__c();
      objProjectRanging.Account__c = acc.id;
      objProjectRanging.Project__c = prj.Id;
      objProjectRanging.status__c = 'Not Ranged';
      
      insert objProjectRanging;
      
    PR_Ranginginline objPR = new PR_Ranginginline(new ApexPages.StandardController(objProjectRanging));
    objPR.strbody = prInline.Message__C;
  }
}