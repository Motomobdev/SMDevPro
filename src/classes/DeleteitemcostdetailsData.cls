/*
*************************************************************************************************
Description:
This Batch class is for deleting  data from ItemCostDetails object

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Kalyan            Created             8/4/2104




*************************************************************************************************
*/

global class DeleteitemcostdetailsData implements Database.Batchable<sObject>
 { 
 global List<CD_Item_Cost_Details__c  > b = new list<CD_Item_Cost_Details__c  >();
 global List <CD_APC__c> lstAccount = new list<CD_APC__c>();

 global List<CD_Demand__c > d = new list<CD_Demand__c >();
 global List<Key_Account__c> c = new list<Key_Account__c>();
global final String Query;


global Database.QueryLocator start(Database.BatchableContext BC)

   {
       
     String query = 'Select id from CD_Item_Cost_Details__c  ';
     system.debug(query + 'query');
   string msgBody;
                //Send an email to the User after your batch completes


        /*        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {'gxn837@motorola.com'});
mail.setReplyTo('batch@acme.com');


mail.setSenderDisplayName('Batch Processing');
mail.setSubject(' Delete ITEM COST DETAILS  Batch Process Started');

mail.setPlainTextBody('Delete ITEM COST DETAILS Data Process Started');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   */



     return Database.getQueryLocator(query);
     }
  
   global void execute(Database.BatchableContext BC, List<CD_Item_Cost_Details__c  > scope)
    {
     
delete scope;
//upsert d;
 
   } 
    global void finish(Database.BatchableContext BC)
    {
    string msgBody;

                //Send an email to the User after your batch completes

     /*           Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {'gxn837@motorola.com'});

mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject(' Delete ITEM COST DETAILS Batch Process Completed');

mail.setPlainTextBody('Delete ITEM COST DETAILS completed');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  */

  }
  }