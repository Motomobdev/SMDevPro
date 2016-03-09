/*
*************************************************************************************************
Description:
This trigger is for sending notification if categories are missing for categories

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
trigger CD_Missing_Category on CD_Categories__c (after insert,after update) {
Map<Id,CD_Categories__c> cdCategorys=  new Map<Id,CD_Categories__c>();
for(CD_Categories__c cdCats : trigger.new)
{
 if(cdCats.CD_Category__c==null && cdCats.CD_Category_Managers__c==null && cdCats.CD_Cost_Category__c==null && cdCats.CD_GCL__c==null && cdCats.CD_GMT_Category__c==null && cdCats.CD_GMT_Subcategory_1__c==null && cdCats.CD_GMT_Subcategory_2__c==null && cdCats.CD_GMT_Subcategory_3__c==null && cdCats.CD_Subcategory1__c==null && cdCats.CD_Subcategory2__c==null && cdCats.CD_Subcategory3__c==null)
 {
  cdCategorys.put(cdCats.Id,cdCats); 
 
 }

}
if(cdCategorys.size()>0)
{
  
        string datestring='Report Date:' + System.now().format('MMMM-dd-yyyy') + '\n' + '\n';  
        string messageBody='<br/><br/>' +'<html><body> Dear'+' ' + UserInfo.getName()+','+'</html></body>' + '<br/><html><body> The Following commodity Codes are interfaced from MotoPDM / MDW. Please update the Category details for the commodity Codes.</html></body>';
        string pdfContent;
        ////////system.debug(errordetails + 'errordetails######');
        pdfContent='<html><head><meta http-equiv=content-type content=text/html;charset=iso-8859-9></meta></head><body>';
        pdfContent=pdfContent+'<table border="1" bordercolor="#FFCC00" style="background-color:#FFFFFF; display: inline; width:25%"  cellpadding="3" cellspacing="5" >';
        pdfContent=pdfContent+'<tr><th>Commodity Code </th><th>Creation Date</th>';
        for(Id cats:cdCategorys.keySet())
        {  
             
              
             
               
                pdfContent += '<tr>';
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+cdCategorys.get(cats).Commodity_Code__c+'</td>'; 
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+cdCategorys.get(cats).CreatedDate+'</td>'; 
               
                pdfContent += '</tr>';
        
        
        }
       
        pdfContent = pdfContent + '</table>';
        pdfContent = pdfContent + '</BODY></HTML>';
      
      
        
       Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('Missing Category.pdf');
         efa.setBody(Blob.toPDF(pdfContent)); 
        //efa.setContentType('pdf');
        // message.setTargetObjectId(UserInfo.getUserId());
         string[] toadress = new string[]{};
         List<CD_EmailGroup__c> emailIds= new List<CD_EmailGroup__c>();
         emailIds=[select Id,name,Email_Ids__c from CD_EmailGroup__c where name='CD_Missing Category Information'];
         if(emailIds.size()>0)
         {
         toadress=String.Valueof(emailIds[0].Email_Ids__c).split(',');
         system.debug(toadress);
        message.setToAddresses( toadress);
         
         message.setSubject('Missing Category information for a new commodity code   ');
         message.setSaveAsActivity(false);
         message.setHtmlBody(datestring+messageBody);
         
       
         message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
       
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});  
         }
        }


}