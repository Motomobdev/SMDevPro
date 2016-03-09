/**********************************************************/
// Created by: José Elias Araújo
// Created Date: 03/17/2014
// Last Modified: José Elias Araújo
// Last Modified by: 03/20/2014
//
// Description:
// This class is able to send emails to an address configured
// in a custom setting named ErrorNotification.
// 
// Test Class: 
// EmailManagerTest.cls
/**********************************************************/
public class EmailManager{
    
    // Description:  
	// This method sends an email to a specific set of email
    // addresses configured ErrorNotification custom settings.
	//
	// Input: subject (Text to be used as subject)
    //        emailBody (Text to be used as body)
	//
	// Returns: none
    public static void send(String subject, String emailBody){ 
        try{
            Map<String, ErrorNotification__c> errorAddresses = ErrorNotification__c.getAll();
			List<String> emailList = new List<String>();
       
			for (String emailEntry : errorAddresses.keySet()) {
		    	ErrorNotification__c errorNotification = errorAddresses.get(emailEntry);
            	emailList.add(errorNotification.Email_Address__c);
			}        
        
        	Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            if (emailList.size() > 0){
				mail.setToAddresses(emailList);
				mail.setSubject(subject);
				mail.setPlainTextBody(emailBody);
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }catch(Exception e){
            throw new EmporiumException(e.getMessage());
        }
    }
}