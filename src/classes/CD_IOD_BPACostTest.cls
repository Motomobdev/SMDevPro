/*
*************************************************************************************************
Description:
This is the test class for CD_IOd_ItemNum_BPA,CD_IOD_supplier_BPA,DeleteBPACost
batch classes

Revision History:
Author/Reviewer     Created/Revised Date   Change Description
 Sivani                     9/25/2104          Created   




*************************************************************************************************
*/
@isTest
public class CD_IOD_BPACostTest {
//for covering CD_IOd_ItemNum_BPA,DeleteBPACost
static testMethod void testitemNumnDel() {
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_BPA_Cost__c> bpaList = new List<CD_BPA_Cost__c>();
      // for (Integer i=0;i<10;i++) {
           CD_BPA_Cost__c m = new CD_BPA_Cost__c(
               Item_Number_IOD_IN__c='01017689016',
               BPA_Cost_Id__c='testclassItemi',
               Name='test567i'
              
               );
           bpaList.add(m);
      // }
       insert bpaList;
        test.startTest();
       CD_IOd_ItemNum_BPA batch = new CD_IOd_ItemNum_BPA();
       QL = batch.start(BC);
       batch.execute(BC, bpaList);
       batch.finish(BC); 
      
       DeleteBPACost batch1 = new DeleteBPACost();
       QL = batch1.start(BC);
       batch1.execute(BC, bpaList);
       batch1.finish(BC);
      
       test.stopTest();



}
//for covering CD_IOD_supplier_BPA
static testMethod void testsupNum() {
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_BPA_Cost__c> bpaList = new List<CD_BPA_Cost__c>();
 //for (Integer i=0;i<10;i++) {
           CD_BPA_Cost__c m = new CD_BPA_Cost__c(
               Supplier_Number_IOD_IN__c='1122511',
               BPA_Cost_Id__c='testclasssupplieri',
               Name='test5i'
              
               );
           bpaList.add(m);
      // }
        test.startTest();
        CD_IOD_supplier_BPA batch = new CD_IOD_supplier_BPA();
       QL = batch.start(BC);
       batch.execute(BC, bpaList);
       batch.finish(BC); 
       test.stopTest();



}

}