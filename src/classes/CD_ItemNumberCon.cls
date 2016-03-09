/*
*************************************************************************************************
Description: 
This  Btch Class is called from itemcostloader1 class controller for page item cost upload page
to create itemnumber and itemcat keys.

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
global class CD_ItemNumberCon implements Database.Batchable<sObject>,Database.Stateful
{
    
   //List<CD_Item_categories__c> itemList =  new List<CD_Item_categories__c>();
   List<CD_Item_categories__c> allitemLst =  new List<CD_Item_categories__c>();
  List<List<String>> csvLine = new List<List<String>>();
   Map<string,Id> allitemMap = new Map<string,Id>();
   Map<Id,String> itemNumId = new Map<Id,String>();
  public CD_ItemNumberCon(List<List<String>> csvLines)
  {
   csvLine=csvLines;
  }
  global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'select id,Name,Item_Number__r.Item_Number__c from CD_Item_categories__c where Organization_Code__r.Name=\'GSO\' ';
      system.debug(query + 'query');
      return Database.getQueryLocator(query);
   }
  global void execute(Database.BatchableContext BC, List<CD_Item_categories__c> scope)
  {
 
   allitemLst.addAll(scope);
   system.debug(allitemLst.size()+'in exec method');
  } 
   global void finish(Database.BatchableContext BC)
    {
     system.debug(allitemLst.size() + 'in finish method');
     
     for(CD_Item_categories__c itemCat : allitemLst)
    {
    
     allitemMap.put(itemCat.Item_Number__r.Item_Number__c,itemCat.id);
     itemNumId.put(itemCat.id,itemCat.Item_Number__r.Item_Number__c);
    
    }
     system.debug(allitemMap.size() + 'in finish method');
     ItemCostLoader1 classmap = new ItemCostLoader1();
      classmap.createItemMap(allitemMap,csvLine,itemNumId);
    }
 }