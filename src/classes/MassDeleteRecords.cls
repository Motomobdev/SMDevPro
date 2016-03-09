global class MassDeleteRecords implements Database.Batchable<sObject>, Database.stateful{

    global final String Query;
    global String errors;

    global MassDeleteRecords(String q){
        Query = q;
        errors = 'Id,Error\n';
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(query);
   }
   
   global void execute(Database.BatchableContext BC, List<sObject> scope){
        List<Database.DeleteResult> dsrs = Database.delete(scope, false);
        Integer i = 0;
        for(Database.DeleteResult dsr : dsrs){
            String errorMessages = '';
            if(!dsr.isSuccess()){
                for(Database.Error err: dsr.getErrors()){
                    errorMessages += err.getMessage() + '; ';
                }
                errors += dsr.id + ',' + errorMessages + '\n';
            }
            i++;
        }
   }
   
   global void finish(Database.BatchableContext BC){
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        String[] toAddresses = new String[] {'gram@motorola.com'};
        mail.setToAddresses(toAddresses);

        mail.setReplyTo('gram@motorola.com');
        mail.setSenderDisplayName('BatchApex');
        mail.setSubject( 'Mass Record Delete Batch' );
    
        mail.setPlainTextBody('\n\nBatch Run: ' + System.now() + '\n\nBy: ' + UserInfo.getName() + '\n\n');

        Blob errorb = blob.valueOf(errors.replaceAll('null',''));
        
        // Create the email attachment
        Messaging.EmailFileAttachment err = new Messaging.EmailFileAttachment();
        err.setFileName('Errors.csv');
        err.setBody(errorb);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {err});
    
        Messaging.sendEmail(new Messaging.Email[] { mail } );
   }
    
}