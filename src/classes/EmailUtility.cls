global class EmailUtility {
 /*
 Author: Bineet Mishra
 Create Date: Nov 19, 2013 
 Description: Email utility class which has email related methods like sending emails, finding email templates etc.
 */ 
public static void SendEmail(Id TargetID, Id ActorID, id EmailTemplateID) {            

    Messaging.reserveSingleEmailCapacity(1);
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();     
        
    email.setSenderDisplayName('Salesforce Support');
     
    if (EmailTemplateID != null) {            
         email.setTemplateId(EmailTemplateID);
         email.saveAsActivity = false;
         email.setTargetObjectId(ActorID);
         email.setWhatId(TargetID);
    } 
         
    Messaging.SingleEmailMessage[] EmailsToSend = new Messaging.SingleEmailMessage[] { email };
    Messaging.sendEmail(EmailsToSend);
      
 }
 
 
 public static void SendEmail(Id TargetID, Id ActorID, string[] ToAddresses, string[] BccAddresses, Id EmailTemplateID) {            

    Messaging.reserveSingleEmailCapacity(1);
    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();     
        
    email.setSenderDisplayName('Salesforce Support');
     
    if (EmailTemplateID != null) {            
         email.setTemplateId(EmailTemplateID);
         email.saveAsActivity = false;
         email.setTargetObjectId(ActorID);
         email.setWhatId(TargetID);
         email.setToAddresses(ToAddresses);
         email.setBccAddresses(BccAddresses);
         email.setBccSender(true);
    } 
         
    Messaging.SingleEmailMessage[] EmailsToSend = new Messaging.SingleEmailMessage[] { email };
    Messaging.sendEmail(EmailsToSend);
      
 }
 
 public static ID FindEmailTemplateIDByDeveloperName(string DeveloperName) {
   
  id EmailTemplateID;
     
  List<EmailTemplate> EmailTemplateResults = new List<EmailTemplate>(); 
   
  if (DeveloperName != null) {
   EmailTemplateResults = [SELECT Id, Name, DeveloperName, IsActive FROM EmailTemplate WHERE DeveloperName = :DeveloperName];
   if (EmailTemplateResults.size() > 0) {
    if (EmailTemplateResults[0].IsActive == true) {
     EmailTemplateID = EmailTemplateResults[0].id;
    }
   }
  }
 
  return EmailTemplateID;
 }
}