/*
*************************************************************************************************
Description:
This  Batch Class is called from controller of Itemcostloader page to create unique key of itemcostdetails
Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
global class CD_ExtKeyNumberCon implements Database.Batchable<sObject>,Database.Stateful
{
 // public List<CD_Item_Cost_Details__c> extKeyLst =  new List<CD_Item_Cost_Details__c>();
  public Map<String ,Set<Decimal>> awardMap = new Map<String ,Set<Decimal>>();
  public List<CD_Item_Cost_Details__c> allextKeyLst =  new List<CD_Item_Cost_Details__c>();
  public Map<String,Id> allextKeyMap =  new Map<String,Id>();
  public Map<String,Id> supplMap =  new Map<String,Id>();
  public Map<String,Id> itemMap =  new Map<String,Id>();
  public Map<Id,String> itemnumMap =  new Map<Id,String>();
  public Map<Id,String> supnumMap =  new Map<Id,String>();
  public List<List<String>> csvs = new List<List<String>>();
 public CD_ExtKeyNumberCon(Map<string,Id> suppMapinput,Map<string,Id> iteminput,List<List<String>> csvip , Map<Id,String> itemIdNumMap,Map<Id,String> suppIdNumMap)
  {
   supplMap=suppMapinput;
   itemMap=iteminput;
   csvs=csvip;  
   supnumMap=suppIdNumMap;
   itemnumMap=itemIdNumMap;
  }
  global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'select id,ExternalKey__c,Item_Number_IOD__c,Quarter__c,CreatedDate,Year__c,Award__c from CD_Item_Cost_Details__c where ExternalKey__c != null ORDER BY CreatedDate DESC LIMIT 50000';
      system.debug(query + 'query');
      return Database.getQueryLocator(query);
   }
  global void execute(Database.BatchableContext BC, List<CD_Item_Cost_Details__c> scope)
  {
   
   allextKeyLst.addAll(scope);
  }  
  global void finish(Database.BatchableContext BC)
    {
     for(CD_Item_Cost_Details__c itemcosts :allextKeyLst)
     {
     /* string awardSting = itemcosts.Item_Number_IOD__c+itemcosts.Quarter__c+itemcosts.Year__c;
      system.debug(awardSting + 'awardSting++++++');
      if(awardMap.containsKey(awardSting))
      { 
       awardMap.get(awardSting).add(itemcosts.Award__c);      
       
      }
      else
      {      
       set<decimal> awardNum = new set<decimal> ();
       awardNum.add(itemcosts.Award__c);
       awardMap.put(awardSting,awardNum);
      }*/
      allextKeyMap.put(itemCosts.ExternalKey__c,itemCosts.id);
      
     
     }
       
    ItemCostLoader1 classmap = new ItemCostLoader1();
    classmap.createObjectData(csvs,supplMap,itemMap,allextKeyMap,awardMap,itemnumMap,supnumMap);
    }
 }