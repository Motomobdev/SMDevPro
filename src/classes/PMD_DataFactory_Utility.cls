/*REVISION HISTORY
@Class Name     : PMD_DataFactory_Utility
@Author         : Indumathi_v
@Date           : July-2014
@Objective      : This is a DataFactory utility class which creates all the necessary records for testing the PMD_ListProgramsWithAttachments_Test class .
--------------------------------------------------------------------------------------------------------------------------
MODIFIED BY       MODIFIED DATE          DESCRIPTION  OF THE MODIFICATION 

--------------------------------------------------------------------------------------------------------------------------*/

public with sharing class PMD_DataFactory_Utility
{
    // <OBJECTIVE>
    // This is used to insert a Program(PMD) record
    // </OBJECTIVE>
    //<PARAMS> Takes the record name as parameter</PARAMS>
    // <RETURNS>
    // Program(PMD) record with whatever Name passed 
    // </RETURNS>
    
    public static PMD_Program__c insertProgram(String Name)
    {    
        PMD_Program__c program= new PMD_Program__c();
        program.Name = Name;
        program.Program_Status__c = 'No Longer Shipping';
        insert program;
        return program;
    }
    
  
    // <OBJECTIVE>
    // This is used to insert a Attachment record and attach it to a Program(PMD).
    // </OBJECTIVE>
    //<PARAMS> Takes the Program(PMD) Id and Attachment name as parameters</PARAMS>
    // <RETURNS>
    // Attachment record, with whatever Name passed and gets attached to the particular Program(PMD).
    // </RETURNS> 
    
    
    public static Attachment insertAttachment(string strPrgmId,String Name)
    {
        Attachment attach= new Attachment();
        attach.Name= Name;
        Blob objBlob = Blob.valueOf('Body of TestAttachment01');
        attach.body = objBlob;
        attach.ParentId = strPrgmId;
        insert attach;
        return attach;
     }
    
    // <OBJECTIVE>
    // This is used to insert a GoogleDoc record and attach it to a Program(PMD)
    // </OBJECTIVE>
    //<PARAMS> Takes the Program(PMD) Id and GoogleDoc name and Url as parameters</PARAMS>
    // <RETURNS>
    // GoogleDoc record, with whatever Name, url passed and gets attached to the particular Program(PMD.
    // </RETURNS>
      
        
    public static GoogleDoc insertGoogleDoc(string strPrgmId, string Name, string Url)
    {
        GoogleDoc gdoc= new GoogleDoc();
        gdoc.Name= Name;
        Blob objBlob = Blob.valueOf('Body of TestDoc02');
        gdoc.Url = Url;
        gdoc.ParentId = strPrgmId;
        insert gdoc;
        return gdoc;
    }
    
    
    // <OBJECTIVE>
    // This is used to insert a CustomSetting record to store the URL values of Attachment and googleDoc
    // </OBJECTIVE>
    // <RETURNS>
    // CustomSetting record, with Program(PMD) url and Attachment Url.
    // </RETURNS>
     
    public static PMD_ProgramWithAttachments__c getUrls()
    {        
    
        PMD_ProgramWithAttachments__c settingFields = new PMD_ProgramWithAttachments__c();
        settingFields.Name = 'PMD_ProgramWithAttachments';
        settingFields.Attachment_URL__c = 'https://mobility.my.salesforce.com/servlet/servlet.FileDownload?file=';
        settingFields.PMD_Program_URL__c = 'https://mobility--mduat.cs7.my.salesforce.com/';
        insert settingFields ;
        return settingFields ;
    }
}