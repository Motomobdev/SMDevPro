/*
*************************************************************************************************
Description:
This is the test class for CD_IOD_CommodityCode_ItemCategories,CD_IOD_ItemNumber_ItemCategories,
CD_IOD_OrgCode_ItemCategories,CD_IOD_DemandProductnUM,CD_IOD_APCidItems,CD_IOD_APCcodeidDemand
batch classes

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/22/2104




*************************************************************************************************
*/
@isTest
public class CD_IOD_ItemCategories_test {
static testMethod void testcommCode(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Item_Categories__c> itemCatList = new List<CD_Item_Categories__c>();
 for (Integer i=0;i<10;i++) {
           CD_Item_Categories__c m = new CD_Item_Categories__c(
              Commodity_Code_IOD_IN__c='DOC.MISC.MISC'
              //Item_Number_IOD_IN__c='01017706001',
              //Organization_Code_IOD_IN__c='GSO'
               );
           itemCatList.add(m);
       }

 CD_IOD_CommodityCode_ItemCategories batch = new CD_IOD_CommodityCode_ItemCategories();
 QL = batch.start(BC);
 batch.execute(BC, itemCatList);
 batch.finish(BC); 
 

}
static testMethod void testitemNum(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Item_Categories__c> itemCatList = new List<CD_Item_Categories__c>();
 for (Integer i=0;i<10;i++) {
           CD_Item_Categories__c m = new CD_Item_Categories__c(
             // Commodity_Code_IOD_IN__c='DOC.MISC.MISC'
              Item_Number_IOD_IN__c='01017706001'
             // Organization_Code_IOD_IN__c='GSO'
               );
           itemCatList.add(m);
       }

 CD_IOD_ItemNumber_ItemCategories batch = new CD_IOD_ItemNumber_ItemCategories();
 QL = batch.start(BC);
 batch.execute(BC, itemCatList);
 batch.finish(BC); 
 

}
static testMethod void testOrgCode(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Item_Categories__c> itemCatList = new List<CD_Item_Categories__c>();
 for (Integer i=0;i<10;i++) {
           CD_Item_Categories__c m = new CD_Item_Categories__c(
             // Commodity_Code_IOD_IN__c='DOC.MISC.MISC'
              //Item_Number_IOD_IN__c='01017706001',
              Organization_Code_IOD_IN__c='GSO'
               );
           itemCatList.add(m);
       }

 CD_IOD_OrgCode_ItemCategories batch = new CD_IOD_OrgCode_ItemCategories();
 QL = batch.start(BC);
 batch.execute(BC, itemCatList);
 batch.finish(BC); 
 

}

/*static testMethod void testCD_IOD_DemandProductnUM(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Demand__c> itemCatList = new List<CD_Demand__c>();
// for (Integer i=0;i<10;i++) {
           CD_Demand__c  m = new CD_Demand__c (
           name='test',
             // Commodity_Code_IOD_IN__c='DOC.MISC.MISC'
              Product_Num_IOD_IN__c='01017706001',
              Demand_ID__c='test123'
              //Organization_Code_IOD_IN__c='GSO'
               );
           itemCatList.add(m);
     //  }

 CD_IOD_DemandProductnUM batch = new CD_IOD_DemandProductnUM();
 QL = batch.start(BC);
 batch.execute(BC, itemCatList);
 batch.finish(BC); 
 
}  */
static testMethod void testCD_IOD_APCidItems(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Items__c> itemCatList = new List<CD_Items__c>();
// for (Integer i=0;i<10;i++) {
           CD_Items__c   m = new CD_Items__c (
           name='test',
             // Commodity_Code_IOD_IN__c='DOC.MISC.MISC'
             // Product_Num_IOD_IN__c='01017706001',
              APC_IOD_IN__c='test123'
              //Organization_Code_IOD_IN__c='GSO'
               );
           itemCatList.add(m);
     //  }

 CD_IOD_APCidItems batch = new CD_IOD_APCidItems();
 QL = batch.start(BC);
 batch.execute(BC, itemCatList);
 batch.finish(BC); 
 

}

static testMethod void testCD_IOD_APCcodeidDemand(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Demand__c> itemCatList = new List<CD_Demand__c>();
// for (Integer i=0;i<10;i++) {
           CD_Demand__c  m = new CD_Demand__c (
           name='test',
             // Commodity_Code_IOD_IN__c='DOC.MISC.MISC'
              Product_Num_IOD_IN__c='01017706001',
              Demand_ID__c='test123',
               CD_APC_CODE_IOD_IN__c='test123'
              //Organization_Code_IOD_IN__c='GSO'
               );
           itemCatList.add(m);
     //  }

 CD_IOD_APCcodeidDemand batch = new CD_IOD_APCcodeidDemand();
 QL = batch.start(BC);
 batch.execute(BC, itemCatList);
 batch.finish(BC); 
 test.startTest();
 CD_IOD_DemandProductnUM batch1 = new CD_IOD_DemandProductnUM();
 QL = batch1.start(BC);
 batch1.execute(BC, itemCatList);
 batch1.finish(BC); 
 test.stopTest();
 
}



}