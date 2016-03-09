/*
************************************************************************
Description:
This Batch Class is for deleting data in BPA Cost Object

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
Sivani             Created              8/20/2014


***********************************************************************
*/
global class DeleteBPACost implements Database.Batchable<sObject>
 { 
 global List<CD_BPA_Cost__c> b = new list<CD_BPA_Cost__c>();


 global List<CD_GMT_Category__c > d = new list<CD_GMT_Category__c >();
 global List<Key_Account__c> c = new list<Key_Account__c>();
global final String Query;


global Database.QueryLocator start(Database.BatchableContext BC)

   {
       
     String query = 'Select id from CD_BPA_Cost__c';
     system.debug(query + 'query');
   string msgBody;
                //Send an email to the User after your batch completes


                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {userInfo.getUserEmail()});
mail.setReplyTo('batch@acme.com');


mail.setSenderDisplayName('Batch Processing');
mail.setSubject(' Delete CD_BPA_Cost__c DATA Batch Process Started');

mail.setPlainTextBody('Delete   CD_BPA_Cost__c DATA Process Started');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });



     return Database.getQueryLocator(query);
     }
  
   global void execute(Database.BatchableContext BC, List<CD_BPA_Cost__c> scope)
    {
     
delete scope;
//upsert d;
 
   } 
    global void finish(Database.BatchableContext BC)
    {
    string msgBody;

                //Send an email to the User after your batch completes

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {userInfo.getUserEmail()});

mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject(' Delete CD_BPA_Cost__c DATA Batch Process Completed');

mail.setPlainTextBody('Delete CD_BPA_Cost__c  Data  Process completed');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

  }
  }