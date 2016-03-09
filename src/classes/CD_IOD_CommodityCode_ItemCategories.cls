/*
***********************************************************************
Description:
This Batch Class is for populating commodity code Id's in Commodity_Code__c 
field using Commodity_Code_IOD_IN__c field in ItemCategories object.

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
Kalyan              Created                7/31/2014
Sivani             Optimized code          8/12/2104




***********************************************************************
*/

global class CD_IOD_CommodityCode_ItemCategories implements Database.Batchable<sObject>
 { 
 global List<CD_Categories__c> cats = new list<CD_Categories__c>();
 public List<CD_Item_Categories__c> itemcats = new List<CD_Item_Categories__c>();
// global List <CD_APC__c> lstAccount = new list<CD_APC__c>();

 //global List<CD_Demand__c > d = new list<CD_Demand__c >();
 //global List<Key_Account__c> c = new list<Key_Account__c>();
global final String Query;


global Database.QueryLocator start(Database.BatchableContext BC)

   {
       
     String query = 'select Commodity_Code_IOD_IN__c,Commodity_Code__c  from CD_Item_Categories__c  WHERE Commodity_Code__c  =NULL AND Commodity_Code_IOD_IN__c!=NULL';
     system.debug(query + 'query');
   string msgBody;
                //Send an email to the User after your batch completes


/*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
mail.setReplyTo('batch@acme.com');


mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Started CD_IOD_ItemNumber_ItemCategories ');

mail.setPlainTextBody('Process Started CD_IOD_ItemNumber_ItemCategories ');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */



     return Database.getQueryLocator(query);
     }
  
global void execute(Database.BatchableContext BC, List<CD_Item_Categories__c  > scope)
{
     
itemcats = new List<CD_Item_Categories__c>();

for(CD_Item_Categories__c   temp: scope){
cats = new list<CD_Categories__c>();
cats=[Select id,Commodity_Code__c from CD_Categories__c where Commodity_Code__c=:temp.Commodity_Code_IOD_IN__c LIMIT 1];
if(cats.size()>0)
{
temp.Commodity_Code__c=cats[0].id;
itemcats.add(temp);
}

}


upsert itemcats;
} 
    global void finish(Database.BatchableContext BC)
    {
    string msgBody;

                //Send an email to the User after your batch completes

          /*      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});

mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed CD_IOD_ItemNumber_ItemCategories ');

mail.setPlainTextBody('Process completed CD_IOD_ItemNumber_ItemCategories ');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */

  }
  }