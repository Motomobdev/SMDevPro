/*
*************************************************************************************************
Description:
This is the test class for  DeleteItemCategoriesata,DeleteItemCostAssyDetails,
DeleteitemcostdetailsData,DeleteItemsData,Deletepslsata batch classes

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/


@isTest
public class CD_del_Item_PSL_itemCat_itemCost_test {

//test method for DeleteItemCategoriesata
static testMethod void testitemCatDel(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Item_Categories__c > iteCatList = new List<CD_Item_Categories__c>();
 for (Integer i=0;i<10;i++) {
           CD_Item_Categories__c m = new CD_Item_Categories__c(
              Name=i+'test'
               );
           iteCatList.add(m);
       }
       insert iteCatList;
       
   DeleteItemCategoriesata batch = new DeleteItemCategoriesata(); 
    QL = batch.start(BC);
       batch.execute(BC, iteCatList);
       batch.finish(BC); 
       


}

//test method for DeleteItemCostAssyDetails
static testMethod void testitemAssyDel(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Item_Cost_Assy_details__c> iteCatList = new List<CD_Item_Cost_Assy_details__c>();
 for (Integer i=0;i<10;i++) {
           CD_Item_Cost_Assy_details__c m = new CD_Item_Cost_Assy_details__c(
              Name=i+'test'
               );
           iteCatList.add(m);
       }
       insert iteCatList;
       
   DeleteItemCostAssyDetails batch = new DeleteItemCostAssyDetails(); 
    QL = batch.start(BC);
       batch.execute(BC, iteCatList);
       batch.finish(BC); 
       


}

//test method for DeleteitemcostdetailsData
static testMethod void testitemCostDel(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Item_Cost_Details__c> iteCatList = new List<CD_Item_Cost_Details__c>();
// for (Integer i=0;i<10;i++) {
           CD_Item_Cost_Details__c m = new CD_Item_Cost_Details__c(
              Name='test',
              CurrencyIsoCode='USD',
              Price__c=1
               );
           iteCatList.add(m);
      // }
       insert iteCatList;
       
   DeleteitemcostdetailsData batch = new DeleteitemcostdetailsData(); 
    QL = batch.start(BC);
       batch.execute(BC, iteCatList);
       batch.finish(BC); 
       


}

//test method for DeleteItemsData
static testMethod void testitemDel(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<cd_items__c> iteCatList = new List<cd_items__c>();
 for (Integer i=0;i<10;i++) {
           cd_items__c m = new cd_items__c(
              Name=i+'test'
               );
           iteCatList.add(m);
       }
       insert iteCatList;
       
   DeleteItemsData batch = new DeleteItemsData(); 
    QL = batch.start(BC);
       batch.execute(BC, iteCatList);
       batch.finish(BC); 
       


}
//test method for Deletepslsata
static testMethod void testpslDel(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<cd_psl__c> iteCatList = new List<cd_psl__c>();
 for (Integer i=0;i<10;i++) {
           cd_psl__c m = new cd_psl__c(
              Suppliername__c=i+'test'
               );
           iteCatList.add(m);
       }
       insert iteCatList;
       
   Deletepslsata batch = new Deletepslsata(); 
    QL = batch.start(BC);
       batch.execute(BC, iteCatList);
       batch.finish(BC); 
       


}
}