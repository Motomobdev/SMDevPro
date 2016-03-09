/*
*************************************************************************************************
Description:
This  Class is controller for page BPA to LOS COPY Page to create maps of takedown batch for input
bpa to los copy

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/




global class CD_CostTakeDown_Batch implements Database.Batchable<sObject>,Database.Stateful
{
public Map<String,CD_Cost_TakeDown__c> tkDnMap = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> subCat3Map = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> subCat2Map = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> subCat1Map = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> catMap = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> catMgrMap = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> gclMap = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> itemMap = new Map<String,CD_Cost_TakeDown__c>();

global Database.QueryLocator start(Database.BatchableContext BC){
 String query = 'select Id,Name,CD_Category__c,CD_Category__r.Name,CD_Category_Manager__c,CD_Category_Manager__r.Name,CD_ExternalKey__c,CD_Item_categories__c,CD_Items__c,CD_Items__r.Item_Number__c,CD_SubCategory1__c,CD_SubCategory1__r.Name,CD_Subcategory2__c,CD_Subcategory2__r.Name,CD_Subcategory3__c,CD_Subcategory3__r.Name,CD_GCL__c,CD_GCL__r.Name,TD_Criteria__c,TD_Value__c from CD_Cost_TakeDown__c';
 system.debug(query + 'query');
     return Database.getQueryLocator(query);
  }
 global void execute(Database.BatchableContext BC, List<CD_Cost_TakeDown__c> scope)
 {
   for(CD_Cost_TakeDown__c tk :scope)
   {
     //tkDnMap.put(tk.CD_ExternalKey__c,tk);
     if(tk.CD_Items__c!=null)
     {
       itemMap.put(tk.CD_Items__r.Item_Number__c,tk);
     }
     if(tk.CD_Subcategory3__c!=null && !(itemMap.containsKey(tk.CD_Items__r.Item_Number__c) ))
     {
       subCat3Map.put(tk.CD_Subcategory3__r.Name,tk);
     }
     if(tk.CD_Subcategory2__c!=null && !(subCat3Map.containsKey(tk.CD_Subcategory3__r.Name) && !(itemMap.containsKey(tk.CD_Items__r.Item_Number__c) ) ))
     {
       subCat2Map.put(tk.CD_Subcategory2__r.Name,tk);
     }
     if(tk.CD_Subcategory1__c!=null && !(subCat2Map.containsKey(tk.CD_Subcategory2__r.Name) )&& !(subCat3Map.containsKey(tk.CD_Subcategory3__r.Name) && !(itemMap.containsKey(tk.CD_Items__r.Item_Number__c) ) ))
     {
       subCat1Map.put(tk.CD_Subcategory1__r.Name,tk);
     }
     if(tk.CD_Category__c!=null && !(subCat1Map.containsKey(tk.CD_Subcategory1__r.Name) ) && !(subCat2Map.containsKey(tk.CD_Subcategory2__r.Name) )&& !(subCat3Map.containsKey(tk.CD_Subcategory3__r.Name) && !(itemMap.containsKey(tk.CD_Items__r.Item_Number__c) ) ))
     {
       catMap.put(tk.CD_Category__r.Name,tk);
     }
      if(tk.CD_Category_Manager__c!=null && !(catMap.containsKey(tk.CD_Category__r.Name) ) && !(subCat1Map.containsKey(tk.CD_Subcategory1__r.Name) ) && !(subCat2Map.containsKey(tk.CD_Subcategory2__r.Name) )&& !(subCat3Map.containsKey(tk.CD_Subcategory3__r.Name) && !(itemMap.containsKey(tk.CD_Items__r.Item_Number__c) ) ))
     {
       catMgrMap.put(tk.CD_Category_Manager__r.Name,tk);
     }
      if(tk.CD_GCL__c!=null && !(catMgrMap.containsKey(tk.CD_Category_Manager__r.Name) )&& !(catMap.containsKey(tk.CD_Category__r.Name) ) && !(subCat1Map.containsKey(tk.CD_Subcategory1__r.Name) ) && !(subCat2Map.containsKey(tk.CD_Subcategory2__r.Name) )&& !(subCat3Map.containsKey(tk.CD_Subcategory3__r.Name) && !(itemMap.containsKey(tk.CD_Items__r.Item_Number__c) ) ))
     {
       gclMap.put(tk.CD_GCL__r.Name,tk);
     }
     
   
   }
 /* system.debug(itemMap.size() + 'itemMap' +itemMap);
  system.debug(subCat3Map.size() + 'subCat3Map' +subCat3Map);
  system.debug(subCat2Map.size() + 'subCat2Map' +subCat2Map);
  system.debug(subCat1Map.size() + 'subCat1Map' +subCat1Map);
  system.debug(catMap.size() + 'catMap' +catMap);
  system.debug(catMgrMap.size() + 'catMgrMap' +catMgrMap);
  system.debug(gclMap.size() + 'gclMap' +gclMap); */
   
 
 }
 global void finish(Database.BatchableContext BC)
    {
    
       CD_BPA_Cost_Update batch = new CD_BPA_Cost_Update(itemMap,subCat3Map,subCat2Map,subCat1Map,catMap,catMgrMap,gclMap);
       database.executeBatch(batch,100);
    
    }

}