/**
 * @author           Indhu
 * @version          1.0 
 * @date             8/26/2014
 * @Status           Developed
 * @description      This  class is  created  to get the Owner's records and Manager's Sub-ordinates  Records 
 *                    and then build them into a string and to send an email to all the Respective Users and their managers                    
 */
public class PR_Batch 
{

    public List<Messaging.SingleEmailMessage> lstEmailMessages = new List<Messaging.SingleEmailMessage>();
    
    // <OBJECTIVE>
    //This method is to get the status data from the custom settings and then using it in the Query 
    // </OBJECTIVE>
    // <RETURNS>
    //    List <String>
    // </RETURNS>
    private List<string> getNotInStatus()
    {
        // 'Do Not Present', 'Not Pursued', 'Ranged'
        List<PR_Status__c> lstPRStatus = PR_Status__c.getAll().values();
        //this list has  values of status 
        List<string> lstNotInStatus = new List<string>();
        for(PR_Status__c prStatus: lstPRStatus)
        {
            lstNotInStatus.add(prStatus.PR_FieldStatus__c);
        }        
        return lstNotInStatus;
    }
    
   // <OBJECTIVE>
   //     This method Managers the Ranging records based on the Owner selected and each owner records
   //     will bind in a list and then Managers  Subordinates Records into a list  
   // </OBJECTIVE>   
   // <RETURNS>
   //    Void
   // </RETURNS>  
    public void sendRangingRecords()
    {        
        List<Project_Ranging__c> lstProjRange = PR_Data_Utility.getAllRangingRecords(getNotInStatus());
        Map<id, List<Project_Ranging__c>> mapOwnerProjRange = new Map<id, List<Project_Ranging__c>>();
        Map<id, List<Project_Ranging__c>> mapManagerProjRange = new Map<id, List<Project_Ranging__c>>();
        
        for(Project_Ranging__c ProjRange:lstProjRange)
        {
            if(mapOwnerProjRange.containsKey(ProjRange.Owner__c))
            {
                (mapOwnerProjRange.get(ProjRange.Owner__c)).add(ProjRange);
            }
            else
            {
                mapOwnerProjRange.put(ProjRange.Owner__c, new List<Project_Ranging__c >{ProjRange});
            }
            system.debug('##mapOwnerProjRange:' + mapOwnerProjRange);
            if(ProjRange.Owner__r.ManagerId != null)
            {
                if(mapManagerProjRange.containsKey(ProjRange.Owner__r.ManagerId))
                {
                    (mapManagerProjRange.get(ProjRange.Owner__r.ManagerId)).add(ProjRange);
                }
                else
                {
                    mapManagerProjRange.put(ProjRange.Owner__r.ManagerId, new List<Project_Ranging__c >{ProjRange});
                }
                system.debug('##mapManagerProjRange:' +mapManagerProjRange);
            }
        }
        
        for(Id OwnerId: mapOwnerProjRange.keyset())
        {
             system.debug('###OwnerId:' + OwnerId);
             buildEmail(mapOwnerProjRange.get(OwnerId), mapOwnerProjRange.get(OwnerId)[0].Owner__r.email, false);
        }
        
        for(Id ManagerId: mapManagerProjRange.keyset())
        {
            system.debug('###ManagerId:' + ManagerId);
            buildEmail(mapManagerProjRange.get(ManagerId), mapManagerProjRange.get(ManagerId)[0].Owner__r.Manager.email, true);
        }
        if (lstEmailMessages != null && lstEmailMessages.size() > 0)
        {
            Messaging.sendEmail(lstEmailMessages);
        }    
    }
    
    // <OBJECTIVE>
    //     This method sends the list of records to each userId(Owner)
    // </OBJECTIVE>   
    private void buildEmail(List<Project_Ranging__c> lstRecordsToSend, string strUserEmail, Boolean isManagerEmail)
    {
        if(lstRecordsToSend != null && lstRecordsToSend.size() > 0 && strUserEmail != null)
        {
            system.debug('##strUserEmail' +strUserEmail);
            sendEmail(buildHtmlTable(lstRecordsToSend), strUserEmail, isManagerEmail);                  
        }  
    }
       
    // <OBJECTIVE>
    //     This method generates a HTML table with the supplied list of ranging records.
    // </OBJECTIVE>   
    // <RETURNS>
    //     returns an HTML body which contains table of programs and attachments
    // </RETURNS>
    private string buildHtmlTable(List<Project_Ranging__c> lstPR)
    {        
        string htmlTableOfRangingRecords = '<table border="1" cellpadding="2" cellspacing="0" width="100%" style="border-collapse:collapse;"> '
                        + '<th>Record ID</th> <th>Owner</th> <th>Account</th> <th>Project</th> '
                        + '<th>Status</th> <th>Next Milestone Date</th>';                                        
        PR_Email__c objMailBody =  PR_Email__c.getValues('Info');        
        string strItemUrl = (objMailBody != null && objMailBody.Item_URL__c != null) ? objMailBody.Item_URL__c: '';
                        
        //Iterating the Ranging Records List and Building a Html Table
        for (Project_Ranging__C PR : lstPR) 
        { 
            htmlTableOfRangingRecords += '<tr>';
            //htmlTableOfRangingRecords += '<td><a target="_blank" href="https://mobility--mduat.cs7.my.salesforce.com/'+ PR.Id + '"><span>' + PR.Id + '</span></a></td>';
            htmlTableOfRangingRecords += '<td><a target="_blank" href="'+ strItemUrl + PR.Id + '"><span>' + PR.Id + '</span></a></td>';
        
            htmlTableOfRangingRecords += '<td>' + PR.Owner__r.name + '</td>';
            htmlTableOfRangingRecords += '<td>' + PR.Account__r.Name + '</td>';
            htmlTableOfRangingRecords += '<td>' + PR.Project__r.Name + '</td>';
            htmlTableOfRangingRecords += '<td>' + PR.Status__c + '</td>';
            if(PR.Next_Milestone_Date__c != null)
            {
                htmlTableOfRangingRecords += '<td>' + (PR.Next_Milestone_Date__c).format() + '</td>';
            }
            else
            {
                htmlTableOfRangingRecords += '<td> </td>';
            }
            htmlTableOfRangingRecords += '</tr>';
        }
        htmlTableOfRangingRecords += '</table>';
        
        return htmlTableOfRangingRecords ;
    }
    
    // <OBJECTIVE>
    //     This method is to send Email, passing the Parameters HTmlbody and the EmailId to send .
    // </OBJECTIVE>
    private void sendEmail(string htmlTableOfRangingRecords, string userEmail, boolean isManagerEmail)
    {
        if(!String.ISBLANK(userEmail))
        {
            PR_Email__c objMailBody =  PR_Email__c.getValues('Info');        
            string strMailBody;
            if (isManagerEmail)
            {
              strMailBody    = (objMailBody != null && objMailBody.Manager_Email_Body__c != null) ? objMailBody.Manager_Email_Body__c : '' ;
            }
            else
            {
              strMailBody    = (objMailBody != null && objMailBody.Email_Body__c != null) ? objMailBody.Email_Body__c : '' ;
            }  
            string strMailSubject = (objMailBody != null && objMailBody.Email_Subject__c != null) ? objMailBody.Email_Subject__c : '' ;
            string strShowAllUrl = (objMailBody != null && objMailBody.ShowAll_Url__c != null) ? objMailBody.ShowAll_Url__c : '' ; 
            string strShowAll = '<a href="' + strShowAllUrl + '">Show All</a>';
            
            String.format(strShowAll, new string[] {strShowAllUrl} );
            
            String[] toAddresses = new String[] {userEmail};
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(strMailSubject);
                   
            mail.setToAddresses(toAddresses);
            mail.setHtmlBody(        
                strMailBody 
                + '<br /><br />' 
                + strShowAll
                + '<br /><br />' 
                + htmlTableOfRangingRecords
                );
            lstEmailMessages.add(mail);    
        }     
    }
}