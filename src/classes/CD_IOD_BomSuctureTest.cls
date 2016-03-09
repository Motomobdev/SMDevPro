/*
*************************************************************************************************
Description:
This is the test class for CD_IOD_childitems,CD_IOD_TopLevelAssembly,CD_IOD_ParentAssembly 
batch classes

Revision History:
Author/Reviewer     Created/Revised Date   Change Description
 Sivani                     9/22/2104          Created   




*************************************************************************************************
*/
@isTest
public class CD_IOD_BomSuctureTest {
static testMethod void testchilditems() {
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_BOM_Structure__c> bomList = new List<CD_BOM_Structure__c>();

//String query1 =  'select Child_Item_IOD_IN__c,Child_Item__c from CD_BOM_Structure__c  WHERE Child_Item_IOD_IN__c!=NULL and child_item__c=null';

      
  
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
       /*
       Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext())
        {
            Account Acc = (Account)QIT.next();            
            System.debug(Acc);
            AcctList.add(Acc);
        }        
        */
       CD_IOD_childitems batch = new CD_IOD_childitems();
       QL = batch.start(BC);
       batch.execute(BC, bomList);
       batch.finish(BC); 
      /* test.startTest();
       CD_IOD_TopLevelAssembly batch1 = new CD_IOD_TopLevelAssembly();
       QL = batch1.start(BC);
       batch1.execute(BC, bomList);
       batch1.finish(BC);
       CD_IOD_ParentAssembly batch2 = new CD_IOD_ParentAssembly();
       QL = batch2.start(BC);
       batch2.execute(BC, bomList);
       batch2.finish(BC);
       CD_IOD_OrgCodeBOMStructure batch3 = new CD_IOD_OrgCodeBOMStructure();
       QL = batch3.start(BC);
       batch3.execute(BC, bomList);
       batch3.finish(BC);
       test.stopTest();*/


 

}
static testMethod void testtopLevel() {
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_BOM_Structure__c> bomList = new List<CD_BOM_Structure__c>();

//String query1 =  'select Child_Item_IOD_IN__c,Child_Item__c from CD_BOM_Structure__c  WHERE Child_Item_IOD_IN__c!=NULL and child_item__c=null';

      
  
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
       /*
       Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext())
        {
            Account Acc = (Account)QIT.next();            
            System.debug(Acc);
            AcctList.add(Acc);
        }        
        */
      /* CD_IOD_childitems batch = new CD_IOD_childitems();
       QL = batch.start(BC);
       batch.execute(BC, bomList);
       batch.finish(BC); 
       test.startTest(); */
       CD_IOD_TopLevelAssembly batch1 = new CD_IOD_TopLevelAssembly();
       QL = batch1.start(BC);
       batch1.execute(BC, bomList);
       batch1.finish(BC);
     /*  CD_IOD_ParentAssembly batch2 = new CD_IOD_ParentAssembly();
       QL = batch2.start(BC);
       batch2.execute(BC, bomList);
       batch2.finish(BC); 
       CD_IOD_OrgCodeBOMStructure batch3 = new CD_IOD_OrgCodeBOMStructure();
       QL = batch3.start(BC);
       batch3.execute(BC, bomList);
       batch3.finish(BC);
       test.stopTest(); */


 

}
static testMethod void testparentLevel() {
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_BOM_Structure__c> bomList = new List<CD_BOM_Structure__c>();

//String query1 =  'select Child_Item_IOD_IN__c,Child_Item__c from CD_BOM_Structure__c  WHERE Child_Item_IOD_IN__c!=NULL and child_item__c=null';

      
  
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
       /*
       Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext())
        {
            Account Acc = (Account)QIT.next();            
            System.debug(Acc);
            AcctList.add(Acc);
        }        
        */
      /* CD_IOD_childitems batch = new CD_IOD_childitems();
       QL = batch.start(BC);
       batch.execute(BC, bomList);
       batch.finish(BC); 
       test.startTest(); 
       CD_IOD_TopLevelAssembly batch1 = new CD_IOD_TopLevelAssembly();
       QL = batch1.start(BC);
       batch1.execute(BC, bomList);
       batch1.finish(BC);*/
      CD_IOD_ParentAssembly batch2 = new CD_IOD_ParentAssembly();
       QL = batch2.start(BC);
       batch2.execute(BC, bomList);
       batch2.finish(BC); 
      /* CD_IOD_OrgCodeBOMStructure batch3 = new CD_IOD_OrgCodeBOMStructure();
       QL = batch3.start(BC);
       batch3.execute(BC, bomList);
       batch3.finish(BC);
       test.stopTest(); */


 

}
static testMethod void testorgCode() {
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_BOM_Structure__c> bomList = new List<CD_BOM_Structure__c>();

//String query1 =  'select Child_Item_IOD_IN__c,Child_Item__c from CD_BOM_Structure__c  WHERE Child_Item_IOD_IN__c!=NULL and child_item__c=null';

      
  
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
       /*
       Database.QueryLocatorIterator QIT =  QL.iterator();
        while (QIT.hasNext())
        {
            Account Acc = (Account)QIT.next();            
            System.debug(Acc);
            AcctList.add(Acc);
        }        
        */
      /* CD_IOD_childitems batch = new CD_IOD_childitems();
       QL = batch.start(BC);
       batch.execute(BC, bomList);
       batch.finish(BC); 
       test.startTest(); 
       CD_IOD_TopLevelAssembly batch1 = new CD_IOD_TopLevelAssembly();
       QL = batch1.start(BC);
       batch1.execute(BC, bomList);
       batch1.finish(BC);
      CD_IOD_ParentAssembly batch2 = new CD_IOD_ParentAssembly();
       QL = batch2.start(BC);
       batch2.execute(BC, bomList);
       batch2.finish(BC); */
       CD_IOD_OrgCodeBOMStructure batch3 = new CD_IOD_OrgCodeBOMStructure();
       QL = batch3.start(BC);
       batch3.execute(BC, bomList);
       batch3.finish(BC);
       //test.stopTest(); 


 

}
}