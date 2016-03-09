/*REVISION HISTORY
@Class Name     : PMD_ListProgramsWithAttachments_Test
@Author         : Indumathi_v
@Date           : July-2014
@Objective      : TestClass to test the apex controller class 'PMD_ListProgramsWithAttachments'.
                  Test class creates PMD_Program__c records,Attachments and Googledoc records and tests two scenarios:
                  1.Program(PMD) with attachments and GoogleDocs. 
                  2.Program(PMD) without attachments and GoogleDocs.  
--------------------------------------------------------------------------------------------------------------------------
MODIFIED BY       MODIFIED DATE          DESCRIPTION  OF THE MODIFICATION 

--------------------------------------------------------------------------------------------------------------------------*/

//This class annotation denotes that the particular class contains code which are required for testing the application.
@isTest
public class PMD_ListProgramsWithAttachments_Test{

//OBJECTIVE
//This method checks the functionality of the Controller:PMD_ListProgramsWithAttachments, by creating Programs(PMD)
//with Attachments and also without Attachments. 
//OBJECTIVE

static TestMethod void buildHtmlTable_Test(){
    
    //This denotes the starting of Test method
    Test.startTest();
    
    //instantiating Custom Setting, to fetch the Program and Attachment Urls.
    PMD_ProgramWithAttachments__c custsett= PMD_DataFactory_Utility.getUrls();  
    
    //Creating a Program(PMD) with Name 'TestProgram01'which has no attachments          
    PMD_Program__c prgrmWithoutAttach = PMD_DataFactory_Utility.insertProgram('TestProgram01'); 
    
    //Creating a Program(PMD) with Name 'TestProgram02' which has Attachments and googleDocs
    PMD_Program__c prgrmWithAttach = PMD_DataFactory_Utility.insertProgram('TestProgram02');
    
    //Creating an Attachment 'TestAttachment01' and attaching it to 'TestProgram02'
    Attachment createAttach1 = PMD_DataFactory_Utility.insertAttachment(prgrmWithAttach.Id,'TestAttachment01');
    
    //Creating an Attachment 'TestAttachment02' and attaching it to 'TestProgram02'
    Attachment createAttach2 = PMD_DataFactory_Utility.insertAttachment(prgrmWithAttach.Id,'TestAttachment02');
    
    //Creating an GoogleDoc 'GoogleDoc1' and attaching it to 'TestProgram02'
    GoogleDoc gDoc1 = PMD_DataFactory_Utility.insertGoogleDoc(prgrmWithAttach.Id,'GoogleDoc1',
    'https://docs.google.com/a/motorola.com/#folders/0B_V-LRM6tCTZMWYxM2NjMzItOWRiMy00YzIxLWJlZGMtMjdmZmIxN2JiYWI1');
  
    //Creating an GoogleDoc 'GoogleDoc2' and attaching it to 'TestProgram02'
    GoogleDoc gDoc2 = PMD_DataFactory_Utility.insertGoogleDoc(prgrmWithAttach.Id,'GoogleDoc2',
    'https://docs.google.com/a/motorola.com/spreadsheet/ccc?key=0AjqlKcfosR4TdHI2d3JrcGFqZ3RXLXNKTmtUVXVJNnc');
 
    //Instantiating the controller, which is going to fetch the List of Programs and Attachments.
    //The constructor will call the buildHtmlTable method, which will build the HTML table
    //with the Program(PMD) and their respective Attachments, to display in the UI.
    PMD_ListProgramsWithAttachments objLstPrgmsAttach = new PMD_ListProgramsWithAttachments();
    
         
    //Checking whether htmlBody string contains TestProgram01 
    System.assertEquals(objLstPrgmsAttach.htmlBody.contains('TestProgram01'),false);
    
    //Checking whether htmlBody string contains TestProgram02 
    System.assert(objLstPrgmsAttach.htmlBody.contains('TestProgram02'),false);
    
    //Checking whether htmlBody string contains TestAttachment01 
    System.assertEquals(objLstPrgmsAttach.htmlBody.contains('TestAttachment01'),true);
    
    //Checking whether htmlBody string contains TestAttachment02 
    System.assertEquals(objLstPrgmsAttach.htmlBody.contains('TestAttachment02'),true);
    
    //Checking whether htmlBody string contains GoogleDoc1 
    System.assertEquals(objLstPrgmsAttach.htmlBody.contains('GoogleDoc1'),true);
    
    //Checking whether htmlBody string contains GoogleDoc2 
    System.assertEquals(objLstPrgmsAttach.htmlBody.contains('GoogleDoc2'),true);
    
    //Checking whether the htmlBody contains url for GoogleDoc1
    system.assertEquals(objLstPrgmsAttach.htmlBody.contains
    ('https://docs.google.com/a/motorola.com/#folders/0B_V-LRM6tCTZMWYxM2NjMzItOWRiMy00YzIxLWJlZGMtMjdmZmIxN2JiYWI1'),true);
    
    //Checking whether the htmlBody contains url for GoogleDoc2
    system.assertEquals(objLstPrgmsAttach.htmlBody.contains
    ('https://docs.google.com/a/motorola.com/spreadsheet/ccc?key=0AjqlKcfosR4TdHI2d3JrcGFqZ3RXLXNKTmtUVXVJNnc'),true);
    
    //End of Test Method
    Test.stopTest();
     } 
}