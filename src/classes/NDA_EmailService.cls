public class NDA_EmailService {
/*
* Created by: BigKite Consulting
* Creation date: 24-Oct-2013
* Test Class: NDA_EmailServiceTest
* Description: This class is used send emails.
*
* Change history:
* Changed on:
* Changed by:
* Description:
*/
    public String subject { get; set; }
    public static PageReference send(NDA__c objNDA, String strAttachName, set<String> setEmailID, String strSource) {
        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
        if(strSource == 'NotifierUpdate'){
            for(String strEmail: setEmailID){
                String addresses = strEmail;
                String[] toAddresses = addresses.split(':', 0);
                // Sets the paramaters of the email
                String strBody = 'Please be informed that the NDA status of File ID' +
                                + objNDA.NDAFileID__c + ' has been changed to ' + objNDA.NDAStatus__c + '.' ;
                                
                String strSubject = objNDA.NDAFileID__c + ' NDA Status Change';             
                email.setSubject(strSubject);
                email.setToAddresses( toAddresses );
                email.setPlainTextBody(strBody);
            }
        }
        // Sends the email
        Messaging.SendEmailResult [] r = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
        
        return null;
    }

}