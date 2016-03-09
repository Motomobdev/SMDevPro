global class CD_IOD_APCidItems implements Database.Batchable<sObject>
{
global List<CD_Items__c> b = new list<CD_Items__c >();
global  String query;

global Database.QueryLocator start(Database.BatchableContext BC)
{
query='Select id,Name,APC_IOD_IN__c,CD_APC__c from CD_Items__c where APC_IOD_IN__c!=null and CD_APC__c=null';
return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext BC,list<CD_Items__c> scope)
{
List <CD_APC__c> lstAccount = new list<CD_APC__c>();
//lstAccount =[Select id,APC_Code__c from CD_APC__c LIMIT 2];

//b=[select CD_APC_CODE_IOD_IN__c,CD_APC_CODE__c from CD_Demand__c  ];

for(CD_Items__c temp: scope){

/*for(integer i =0;i<lstaccount.size();i++){
if(temp.CD_APC_CODE_IOD_IN__c== lstaccount[i].APC_Code__c){
temp.CD_APC_CODE__c= lstaccount[i].id;
}*/
lstAccount =[select id,name from CD_APC__c where name=:temp.APC_IOD_IN__c limit 1];
if(lstAccount!=null && lstAccount.size()>0)
temp.CD_APC__c=lstAccount[0].id;
//}
}


upsert scope;
//Delete lstAccount;
}

global void finish(Database.BatchableContext BC)
{  string msgBody;
                //Send an email to the User after your batch completes
      /*          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
mail.setToAddresses(new String[] {'gxn837@motorola.com'});
mail.setReplyTo('batch@acme.com');
mail.setSenderDisplayName('Batch Processing');
mail.setSubject('Batch Process Completed');

mail.setPlainTextBody('Process completed');
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });  */
}
}