/*
***********************************************************************
Description:
This Batch Class is for populating Item Id's in Item_Number__c field 
using  Item_Number_IOD_IN__c field in BPA Cost Object.

Revision History:
Author/Reviewer   Created/Revised Date      Change Description  
Sivani              6/23/2014               Created        




***********************************************************************
*/


global class CD_IOd_ItemNum_BPA implements Database.Batchable<sObject>
{
  public List<CD_BPA_Cost__c> updateBpaList = new List<CD_BPA_Cost__c>();
  global Database.QueryLocator start(Database.BatchableContext BC){
  String query = 'SELECT Id,Name,Award__c,BPA_Cost_Id__c,BPA_Created_By__c,BPA_Creation_Date__c,BPA_RFQ_No__c,BPA_Updated_By__c,BPA_Updated_Date__c,Cost_Type__c,Effective_End_Date__c,Effective_Start_Date__c,Item_Number__c,Item_Number_IOD_IN__c,Price__c,Quarter__c,Supplier_Number__c,Supplier_Number_IOD_IN__c,Year__c FROM CD_BPA_Cost__c Where Item_Number_IOD_IN__c!=null AND Item_Number__c=null ' ;        
     system.debug(query + 'query');
     return Database.getQueryLocator(query);
   }
  global void execute(Database.BatchableContext BC, List<CD_BPA_Cost__c> scope)
 {
   for(CD_BPA_Cost__c bpacost : scope)
   {
    List<CD_Items__c> itemId = new List<CD_Items__c>();
    itemId=[select Id,Name from CD_Items__c where Item_Number__c=:bpacost.Item_Number_IOD_IN__c];
    if(itemId.size()>0)
    {
     bpacost.Item_Number__c=itemId[0].Id;
     updateBpaList.add(bpacost);
    }
   
   }
   update updateBpaList;
 }
  global void finish(Database.BatchableContext BC)
    {
    }
}