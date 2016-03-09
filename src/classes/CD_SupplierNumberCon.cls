/*
*************************************************************************************************
Description:
This  Btach Class is called from ItemCostLoader1 controller for page ItemCostUpload Page to
create unique supplier number and ids.

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
global class CD_SupplierNumberCon implements Database.Batchable<sObject>,Database.Stateful
{
  //public List<Account> supplList =  new List<Account>();
  public List<Account> allsupplList =  new List<Account>();
  public Map<String,Id> allsupplMap =  new Map<String,Id>();
  public Map<String,Id> itemMap=  new Map<String,Id>();
  public Map<Id,String> itemIdMap=  new Map<Id,String>();
  public List<List<String>> csv1 = new List<List<String>>();
  public Map<Id,String> supplIdMap = new Map<Id,String>();
  public CD_SupplierNumberCon(Map<String,Id> items , List<List<String>> csvs , Map<Id,String> itemid)
  {
      
   itemMap=items;
   csv1=csvs;
   itemIdMap=itemid;
  
  }
  global Database.QueryLocator start(Database.BatchableContext BC){
      system.debug( itemMap.size());
      system.debug(csv1.size());
      
      String query = 'select id,Name,Oracle_Customer_Number__c from Account where Type = \'Vendor\' AND Oracle_Customer_Number__c != null ';
      system.debug(query + 'query');
      return Database.getQueryLocator(query);
   }
  global void execute(Database.BatchableContext BC, List<Account> scope)
  {
   
   allsupplList.addAll(scope);
  } 
  global void finish(Database.BatchableContext BC)
    {
      for(Account acct : allsupplList)
      {
        allsupplMap.put(acct.Oracle_Customer_Number__c,acct.id);
        supplIdMap.put(acct.id,acct.Oracle_Customer_Number__c);
      }
      system.debug( itemMap.size());
      system.debug(csv1.size());
      system.debug(allsupplMap.size());
     ItemCostLoader1 classmap = new ItemCostLoader1();
     classmap.createSuppMap(allsupplMap,itemMap,csv1,itemIdMap,supplIdMap);
    }
 }