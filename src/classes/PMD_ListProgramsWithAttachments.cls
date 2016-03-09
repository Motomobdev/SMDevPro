/*REVISION HISTORY
@Class Name     :     PMD_ListProgramsWithAttachments
@Author         :     Indumathi_v
@Date           :     July-2014
@Objective      :     This is an apex Controller Class for the visualforce page: PMD_ListProgramsWithAttachments which fetches and displays 
                      the list of Program(PMD)records along with their respective attachments(includes both file type as well as Google doc attachments) in a table.
                      If there is no attachment for the Program,then a message 'No Attachments' will be displayed under Attachments column.
                  
--------------------------------------------------------------------------------------------------------------------------
MODIFIED BY       MODIFIED DATE          DESCRIPTION  OF THE MODIFICATION 

--------------------------------------------------------------------------------------------------------------------------*/
public with sharing class PMD_ListProgramsWithAttachments
{
/*This will hold the html body generated in the controller class and passes it to the visualforce page, 
to display the list of Program(PMD) records along with thier attachments*/
public String htmlBody {get; set;}
//This will hold the URL for the Program(PMD) record from the custom setting
public String programUrl{get;set;}
//This will hold the URL for the Attachment record from the custom setting
public String attachmentUrl{get;set;}

//Creating instance for the Utility class
    public PMD_Data_Utility util  = new PMD_Data_Utility();
    //This is a map which holds the Ids of Programs(PMD)records
    public Map<ID, PMD_Program__c> prgrmMap = new Map<ID, PMD_Program__c>(util.lstPrograms());
    // This is a Map which holds the ids of Attachment records
    public Map<ID, List<String>> attachmentMap = new Map<ID, List<String>>();
    //This is a Map which holds the ids of GoogleDoc records
    public Map<ID, List<String>> gDocAttachmentMap = new Map<ID, List<String>>();


// <OBJECTIVE>
// Constructor which calls the method to fetch the list of Program(PMD)and Attachments
// </OBJECTIVE>

public PMD_ListProgramsWithAttachments()
{
    buildHtmlTable();
}


// <OBJECTIVE>
// This method fetches the list of Programs and their attachments and generates an HTML table.
// </OBJECTIVE>   
// <RETURNS>
// returns an HTML body which contains table of programs and attachments
// </RETURNS>

public void buildHtmlTable()
    { 
    //creating the instance for the Custom Setting, which holds the values for the Program and attachments URL link
    PMD_ProgramWithAttachments__c pwithAttach = PMD_ProgramWithAttachments__c.getValues('PMD_ProgramWithAttachments');
    //getting the program url from the custom setting
    programUrl = pwithAttach.PMD_Program_URL__c;
    //getting the attachment url from the custom setting
    attachmentUrl = pwithAttach.Attachment_URL__c;
  
   
    
   
        
        //Loops through all the Attachments and for every attachment records, generates the URL and updates the attachment map.
        for (Attachment a : util.lstAttachment()) {
            //Holds the url of Attachment record
            String aLink = '<a href="'+attachmentUrl+a.id + '"><span>' + a.name + '</span></a>';
            //list which holds the parentId of all the attachments
            List<String> attachmentIds = attachmentMap .get(a.parentid);
            
            //checks whether the attachmentId List has ParentID, if true, creates the Link for that attachment.
            //if false, gets the ID from the Attachment Map
            
                if (attachmentIds == null) 
                {
                    attachmentIds = new List<String>{aLink} ;
                    attachmentMap .put(a.parentid, attachmentIds );
            
                } else
                    attachmentIds .add(aLink);
        }
        
        //Loops through all the Attachments and for every attachment records, generates the URL and updates the gDocMap. 
       
        for (GoogleDoc g : util.lstgdoc()) {
            //Holds the url for GoogleDocs
            String gLink = '<a href="' + g.url+ '"><span>' + g.name + '</span></a>';
            //List which holds the ParentID of all the Google Docs
            List<String> gdocIds = gDocAttachmentMap.get(g.parentid);
            
            //checks whether the GoogleDocs has ParentID, if true, creates the GoogleDoc Link.
            //if false, gets the ID from the GoogleDocMap
            if (gdocIds == null)
             {
                gdocIds = new List<String>{gLink} ;
                gDocAttachmentMap.put(g.parentid, gdocIds);
              } else
                gdocIds.add(gLink);
        }
        
        
        
    //This generates the HTML body, to display the list of Programs(PMD) records with their attachments  
    htmlBody = '<table border="1" cellpadding="2" cellspacing="0" width="100%" style="border-collapse:collapse;"> '
                        + '<th>Program </th><th>Program Status</th> <th>Attachment(s)</th> ';
    //Loops through the Program List and gets the Name of each program to display in the table
        
    for (PMD_Program__c c : util.programList) {
        List<String> attParentId = attachmentMap.get(c.id);
        // List which contains the list of googleDocs for the particular Program(PMD) record
        List<String> gParentId = gDocAttachmentMap.get(c.id);
        //Only Programs with Attachments to be listed.
        if (attParentId  != null || 
            gParentId != null )  
        {             
            htmlBody += '<tr>';
            htmlBody += '<td><a target="_blank" href="'+programUrl+c.Id + '"><span>' + c.Name + '</span></a></td>';
            htmlBody += '<td><span>' + c.Program_Status__c + '</span></a></td>';    
            // List which contains the list of Attachments for the particular Program(PMD) record
            htmlBody += '<td' + ((attParentId  == null) && (gParentId == null ) ? ' style="background-color: yellow;"': '') +'>';
            
            //Checks whether the Program(PMD) contains Attachments, and displays the name of Attachment
                if (attParentId  != null) 
                {
                     for (String aLink  : attParentId ) {
                     htmlBody += aLink  + '<br/>';
                                        }
                } 
           
             //Checks whether the Program(PMD) contains GoogleDocs, and displays the name of the GoogleDocs
                if (gParentId != null) 
                {
                    for (String gLink : gParentId ) {
                    htmlBody += gLink + '<br/>';
                    }
                }
              
            htmlBody += '</td>';
            htmlBody += '</tr>';
            }
        }           
        htmlBody += '</table>';

    }  
}