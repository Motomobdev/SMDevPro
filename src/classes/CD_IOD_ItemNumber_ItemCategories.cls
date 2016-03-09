/*
***************************************************************************
Description:
This Batch Class is for populating commodity code Id's in Item_Number__c
field using Item_Number_IOD_IN__c field in ItemCategories object.

Revision History:
Author/Reviewer     Created/Revised Date  Change Description
Kalyan                  7/31/2014             Created
Sivani                  8/12/2104             Optimized code




****************************************************************************
*/

global class CD_IOD_ItemNumber_ItemCategories implements Database.Batchable<sObject>
 { 
 global List<CD_Item_Categories__c> itemCateg = new list<CD_Item_Categories__c  >();
 global List <CD_APC__c> lstAccount = new list<CD_APC__c>();

 global List<CD_Demand__c > d = new list<CD_Demand__c >();
 global List<Key_Account__c> c = new list<Key_Account__c>();
global final String Query;


global Database.QueryLocator start(Database.BatchableContext BC)

   {
       
     String query = 'select Id,Name ,Item_Number_IOD_IN__c,Item_Number__c from CD_Item_Categories__c  WHERE Item_Number_IOD_IN__c!=NULL and Item_Number__c =null';
     system.debug(query + 'query');
   string msgBody;
                //Send an email to the User after your batch completes

/*
Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
mail.setReplyTo('batch@acme.com');


mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Started CD_IOD_ItemNumber_ItemCategories ');

mail.setPlainTextBody('Process Started CD_IOD_ItemNumber_ItemCategories ');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
*/


     return Database.getQueryLocator(query);
     }
  
global void execute(Database.BatchableContext BC, List<CD_Item_Categories__c > scope)
{
     
for(CD_Item_Categories__c itemCats :scope ){
//string item =scope.Item_Number_IOD_IN__c;
list<cd_items__c> a=[select id from cd_items__c where item_number__c=:itemCats.Item_Number_IOD_IN__c];
if(a.size()>0)
{
itemCats.item_number__c=a[0].id;
itemCateg.add(itemCats);
}
}
if(itemCateg.size()>0)
{
upsert itemCateg;
}
}

global void finish(Database.BatchableContext BC)
    {
    string msgBody;

                //Send an email to the User after your batch completes

  /*              Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});

mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed CD_IOD_ItemNumber_ItemCategories ');

mail.setPlainTextBody('Process completed CD_IOD_ItemNumber_ItemCategories ');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  */

  }
  }