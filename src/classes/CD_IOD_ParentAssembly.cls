/*
************************************************************************
Description:
This Batch Class is for populating Item Id's in Parent_Assembly__c field 
using Parent_Assembly_IOD_IN__c field in BOM structure object.

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
Kalyan              Created                7/31/2014
Sivani             Optimized code          8/12/2104




**************************************************************************
*/


global class CD_IOD_ParentAssembly implements Database.Batchable<sObject>
 { 
 global List<CD_BOM_Structure__c  > b = new list<CD_BOM_Structure__c  >();
 global List <CD_APC__c> lstAccount = new list<CD_APC__c>();

 global List<CD_Demand__c > d = new list<CD_Demand__c >();
 global List<Key_Account__c> c = new list<Key_Account__c>();
global final String Query;


global Database.QueryLocator start(Database.BatchableContext BC)

   {
       
     String query = 'select Parent_Assembly_IOD_IN__c,Parent_Assembly__c from CD_BOM_Structure__c  WHERE Parent_Assembly_IOD_IN__c!=NULL and Parent_Assembly__c=null  ';
     system.debug(query + 'query');
   string msgBody;
                //Send an email to the User after your batch completes


       /*         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
mail.setReplyTo('batch@acme.com');


mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Started');

mail.setPlainTextBody('Process Started');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });   */



     return Database.getQueryLocator(query);
     }
  
   global void execute(Database.BatchableContext BC, List<CD_BOM_Structure__c  > scope)
    {
     
    

/*
c=Database.query('select id,name from Key_Account__c');
d=Database.Query('select Key_Account_IOD_IN__c,Key_Account__c   from CD_Demand__c  WHERE Key_Account_IOD_IN__c!=NULL');*/
for(CD_BOM_Structure__c   temp: scope){
string item= temp.Parent_Assembly_IOD_IN__c;
list<cd_items__c> a =[select id from cd_items__c where item_number__c=:item];

if(a.size()>0  ){
temp.Parent_Assembly__c = a[0].id;
}
}



/*
for(CD_Demand__c temp: d){


for(integer i =0;i<c.size();i++){

if(temp.Key_Account_IOD_IN__c == c[i].name){
temp.Key_Account__c= c[i].id;
}
}

}*/
upsert scope;
//upsert d;
 
   } 
    global void finish(Database.BatchableContext BC)
    {
    string msgBody;

                //Send an email to the User after your batch completes

/*                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});

mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed');

mail.setPlainTextBody('Process completed');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  */

  }
  }