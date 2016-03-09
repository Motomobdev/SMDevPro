/*
*************************************************************************************************
Description:
This is the test class for DeleteBomStructureData,DeleteDemandData,DeleteGMTCateogyr,
DeleteGMTCateogyrLevelDetails batch classes

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
@isTest
public class CD_delBom_Dem_GMTCat_test {
//test method for DeleteBomStructureData
static testMethod void testBomDel(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_BOM_Structure__c> bomList = new List<CD_BOM_Structure__c>();
 for (Integer i=0;i<10;i++) {
           CD_BOM_Structure__c m = new CD_BOM_Structure__c(
               Child_Item_IOD_IN__c='01017689016',
              Parent_Assembly_IOD_IN__c='01017706001',
              Top_Level_Assembly_IOD_IN__c='01017714001',
              OrganizationCode_IOD_IN__c='GSO'
               );
           bomList.add(m);
       }
       insert bomList;
       
   DeleteBomStructureData batch = new DeleteBomStructureData(); 
    QL = batch.start(BC);
       batch.execute(BC, bomList);
       batch.finish(BC); 
       
}
//test method for DeleteDemandData
static testMethod void testDemandDel(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Demand__c> demList = new List<CD_Demand__c>();
 for (Integer i=0;i<10;i++) {
          CD_Demand__c m = new CD_Demand__c(
               Name=i+'test',
               Demand_ID__c=i+'test'
               );
           demList.add(m);
       }
       insert demList;
       
   DeleteDemandData batch = new DeleteDemandData(); 
    QL = batch.start(BC);
       batch.execute(BC, demList);
       batch.finish(BC); 
       
}

//test method for DeleteGMTCateogyr
/*static testMethod void testGMTCateogyr(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_GMT_Category__c> catList = new List<CD_GMT_Category__c>();
 for (Integer i=0;i<10;i++) {
          CD_GMT_Category__c m = new CD_GMT_Category__c(
              Name=i+'test'
               );
           catList.add(m);
       }
       insert catList;
       
   DeleteGMTCateogyr batch = new DeleteGMTCateogyr(); 
    QL = batch.start(BC);
       batch.execute(BC, catList);
       batch.finish(BC); 
       
}


//test method for DeleteGMTCateogyrLevelDetails
static testMethod void testGMTCateogyrlevel(){
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_GMT_Category_Level_Details__c> catlevelList = new List<CD_GMT_Category_Level_Details__c>();
 for (Integer i=0;i<10;i++) {
          CD_GMT_Category_Level_Details__c m = new CD_GMT_Category_Level_Details__c(
              Name=i+'test'
               );
           catlevelList.add(m);
       }
       insert catlevelList;
       
   DeleteGMTCateogyrLevelDetails batch = new DeleteGMTCateogyrLevelDetails(); 
    QL = batch.start(BC);
       batch.execute(BC, catlevelList);
       batch.finish(BC); 
       
}  */

}