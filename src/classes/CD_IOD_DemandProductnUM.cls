global class CD_IOD_DemandProductnUM  implements Database.Batchable<sObject>
 { 
 global List<CD_Demand__c > b = new list<CD_Demand__c >();
 global List <CD_APC__c> lstAccount = new list<CD_APC__c>();
 global List<CD_Demand__c > d = new list<CD_Demand__c >();
 global List<Key_Account__c> c = new list<Key_Account__c>();
global final String Query;


global Database.QueryLocator start(Database.BatchableContext BC)
   {
       
      String query = 'select id,name,Product_Num_IOD_IN__c,Product_Num__c from CD_Demand__c  WHERE Product_Num_IOD_IN__c!=NULL AND Product_Num__c=NULL ';
     system.debug(query + 'query');
   string msgBody;
                //Send an email to the User after your batch completes

   /*             Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {'gxn837@motorola.com'});
mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Started');

mail.setPlainTextBody('Process Started');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  */


     return Database.getQueryLocator(query);
     }
  
   global void execute(Database.BatchableContext BC, List<CD_Demand__c> scope)
    {
     
    
//b=Database.query('select Product_Num_IOD_IN__c,Product_Num__c from CD_Demand__c  WHERE Product_Num_IOD_IN__c!=NULL LIMIT 10000');
//c=Database.query('select id,name from Key_Account__c');
//d=Database.Query('select Key_Account_IOD_IN__c,Key_Account__c   from CD_Demand__c  WHERE Key_Account_IOD_IN__c!=NULL');
for(CD_Demand__c temp: scope){
List<CD_items__c>  items = [select id,name,Item_number__c from CD_items__c where Item_number__c =:temp.Product_Num_IOD_IN__c];
/*for(integer i =0;i<scope.size();i++){
if(temp.Product_Num_IOD_IN__c== scope[i].Item_Number__c  ){
temp.Product_Num__c = scope[i].id;
}
} */
if(items!=null && items.size()>0)
{
temp.Product_Num__c = items[0].id;
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

           /*     Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {'gxn837@motorola.com'});
mail.setReplyTo('batch@acme.com');

mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed');

mail.setPlainTextBody('Process completed');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); */

  }
  }