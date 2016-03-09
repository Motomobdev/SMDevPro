/*
***********************************************************************
Description:
This Batch Class is for populating commodity code Id's in Organization_Code__c 
field using Organization_Code_IOD_IN__c field in ItemCategories object.

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
Kalyan              Created                7/31/2014
Sivani             Optimized code          8/12/2104




***********************************************************************
*/



global class CD_IOD_OrgCode_ItemCategories implements Database.Batchable<sObject>
 { 
 global List<CD_Item_Categories__c > b = new list<CD_Item_Categories__c >();
 global List <CD_APC__c> lstAccount = new list<CD_APC__c>();
 global List<CD_Organizations__c> d = new list<CD_Organizations__c>();
 global List<Key_Account__c> c = new list<Key_Account__c>();
global final String Query;


global Database.QueryLocator start(Database.BatchableContext BC)
   {
       
     String query = 'select Organization_Code_IOD_IN__c,Organization_Code__c from CD_Item_Categories__c  WHERE Organization_Code_IOD_IN__c!=NULL and Organization_Code__c =null';
     system.debug(query + 'query');
   string msgBody;
                //Send an email to the User after your batch completes

           /*     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Started CD_IOD_OrgCode_ItemCategories');

mail.setPlainTextBody('Process Started CD_IOD_OrgCode_ItemCategories');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  */


     return Database.getQueryLocator(query);
     }
  
   global void execute(Database.BatchableContext BC, List<CD_Item_Categories__c  > scope)
    {
     
    
//b=Database.query('select CD_APC_CODE_IOD_IN__c,CD_APC_CODE__c from CD_Item_Categories__c  WHERE CD_APC_CODE_IOD_IN__c!=NULL');
//c=Database.query('');
d=Database.Query('select id,name from CD_Organizations__c');
/*for(CD_Item_Categories__c temp: b){

for(integer i =0;i<scope.size();i++){
if(temp.CD_APC_CODE_IOD_IN__c== scope[i].APC_Code__c){
temp.CD_APC_CODE__c= scope[i].id;
}
}

}
*/

for(CD_Item_Categories__c  temp: scope){


for(integer i =0;i<d.size();i++){
if(temp.Organization_Code_IOD_IN__c== d[i].name){
temp.Organization_Code__c = d[i].id;
}
}

}
//upsert b;
upsert scope;
 
   } 
    global void finish(Database.BatchableContext BC)
    {
    string msgBody;
                //Send an email to the User after your batch completes

       /*         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {UserInfo.getUserEmail()});
mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed CD_IOD_OrgCode_ItemCategories' );

mail.setPlainTextBody('Process completed CD_IOD_OrgCode_ItemCategories');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  */

  }
  }