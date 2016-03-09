/*
***********************************************************************
Description:
This Batch Class is for populating Item Id's in Supplier_Number__c field 
using  Supplier_Number_IOD_IN__c field in BPA Cost Object.

Revision History:
Author/Reviewer   Created/Revised Date      Change Description  
Kalyan              8/6/2014                 Created                
Sivani             8/12/2104               Optimized code          




***********************************************************************
*/


global class CD_IOD_supplier_BPA implements Database.Batchable<sObject>
 { 
 global List<CD_BPA_Cost__c> b = new list<CD_BPA_Cost__c  >();
 global List <CD_APC__c> lstAccount = new list<CD_APC__c>();

 global List<CD_Demand__c > d = new list<CD_Demand__c >();
 global List<Key_Account__c> c = new list<Key_Account__c>();
global final String Query;


global Database.QueryLocator start(Database.BatchableContext BC)

   {
      
     String query = 'select Supplier_Number_IOD_IN__c,Supplier_Number__c  from CD_BPA_Cost__c where Supplier_Number__c =null';
     system.debug(query + 'query');
   string msgBody;
                //Send an email to the User after your batch completes


                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
mail.setReplyTo('batch@acme.com');


mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Started CD_IOD_ItemNumber');

mail.setPlainTextBody('Process Started CD_IOD_ParentAssembly');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });



     return Database.getQueryLocator(query);
     }
  
   global void execute(Database.BatchableContext BC, List<CD_BPA_Cost__c  > scope)
    {
     
    

/*
c=Database.query('select id,name from Key_Account__c');
d=Database.Query('select Key_Account_IOD_IN__c,Key_Account__c   from CD_Demand__c  WHERE Key_Account_IOD_IN__c!=NULL');*/
for(CD_BPA_Cost__c   temp: scope){
string supp =temp.Supplier_Number_IOD_IN__c;
list<account> a=[select id from account where oracle_customer_number__c=:supp];
if(a.size()>0)
temp.Supplier_Number__c  =a[0].id;

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

                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});

mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed CD_IOD_ItemNumber');

mail.setPlainTextBody('Process completed CD_IOD_ParentAssembly');

Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

  }
  }