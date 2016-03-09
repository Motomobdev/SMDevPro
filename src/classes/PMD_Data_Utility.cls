/*REVISION HISTORY
@Class Name     : PMD_Data_Utility
@Author         : Indumathi_v
@Date           : July-2014
@Objective      : Utility class which fetches all the necessary records required to display the List of Programs with their Attachments
--------------------------------------------------------------------------------------------------------------------------
MODIFIED BY       MODIFIED DATE          DESCRIPTION  OF THE MODIFICATION 

--------------------------------------------------------------------------------------------------------------------------*/
public with sharing class PMD_Data_Utility
{
    //Holds the list of Program(PMD) records
    public List<PMD_Program__c>programList {get;set;}
    //Holds the set of Program(PMD) Ids 
    Set<Id> prgrmIds = new Set<Id>();
   
    
    // <OBJECTIVE>
    // This is used to fetch the List of all the Program(PMD) records from Salesforce
    // </OBJECTIVE>
    // <RETURNS>
    // List of Program(PMD) records
    // </RETURNS>
    
    public List<PMD_Program__c> lstPrograms()
    {
     
        programList =  [Select Id, name, Program_Status__c 
                        from PMD_Program__c 
                        where Program_Status__c <> 'Canceled'
                        order by PMD_Program__c.Name ASC];  
        // If programList contains more than a record, then add program ids to the set.
        if(programList.size() > 0){
            for(PMD_Program__c p : programList){
                prgrmIds.add(p.Id);
                system.debug('prgrmIds----'+prgrmIds);
            }
        }
        return programList;
        
    }
    
    // <OBJECTIVE>
    // This is used to fetch the List of all the Attachment records from Salesforce
    // </OBJECTIVE>
    // <RETURNS>
    // List of Attachment records
    // </RETURNS>
    
    public List<Attachment> lstAttachment()
    {
        // return the list of attachments where the parentId matches with the program id.
        return [Select Id, Name, body, ParentId from Attachment where ParentId IN: prgrmIds];  
    }
    
    
    // <OBJECTIVE>
    // This is used to fetch the List of all the GoogleDoc records from Salesforce
    // </OBJECTIVE>
    // <RETURNS>
    // List of GoogleDoc records
    // </RETURNS>
    
    public List<GoogleDoc> lstgDoc()
    {
        // return the list of GoogleDoc where the parentId matches with the program id.
        return [Select Id,Name, ParentId, Url from GoogleDoc where ParentId IN: prgrmIds];  
    }
}