/*
*************************************************************************************************
Description:
This  Class is test calss  for page CD_Master class

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
@isTest
public class CD_Master_test {
static testMethod void testCD_master(){
CD_Master tests = new CD_Master();
tests.typea='Category';
cd_category__c test1=new cd_category__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getcategories();
tests.save();
tests.data();
//tests.setcategories();
tests.saveScore();
tests.deletes();
tests.reset();


}
static testMethod void testCD_master2(){
CD_Master tests = new CD_Master();
tests.typea='Sub Category1';
CD_Subcategory1__c test1=new CD_Subcategory1__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getsubcateogries();
tests.save();
tests.data();
tests.saveScore();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master3(){
CD_Master tests = new CD_Master();
tests.typea='Sub Category2';
CD_Subcategory2__c test1=new CD_Subcategory2__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getsubcateogries2();
tests.save();
tests.data();
tests.saveScore();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master4(){
CD_Master tests = new CD_Master();
tests.typea='Sub Category3';
CD_Subcategory3__c test1=new CD_Subcategory3__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getsubcateogries3();
tests.save();
tests.data();
tests.saveScore();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master5(){
CD_Master tests = new CD_Master();
tests.typea='GCL';
cd_gcl__c test1=new cd_gcl__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getGCLvalues();
tests.save();
tests.data();
tests.saveScore();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master6(){
CD_Master tests = new CD_Master();
tests.typea='Category Manager';
CD_Category_Managers__c test1=new CD_Category_Managers__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getCMValues();
tests.save();
tests.data();
tests.saveScore();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master7(){
CD_Master tests = new CD_Master();
tests.typea='GMT category';
CD_GMT_Category__c test1=new CD_GMT_Category__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getgmtCateg();
tests.save();
tests.data();
tests.saveScore();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master8(){
CD_Master tests = new CD_Master();
tests.typea='GMT Subcategory1';
CD_GMT_Subcategory_1__c test1=new CD_GMT_Subcategory_1__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getgmtSubCat1();
tests.save();
tests.data();
tests.saveScore();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master9(){
CD_Master tests = new CD_Master();
tests.typea='GMT Subcategory2';
CD_GMT_Subcategory_2__c test1=new CD_GMT_Subcategory_2__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getgmtSubCat2();
tests.save();
tests.data();
tests.saveScore();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master10(){
CD_Master tests = new CD_Master();
tests.typea='GMT Subcategory3';
CD_GMT_Subcategory_3__c test1=new CD_GMT_Subcategory_3__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getgmtSubCat3();
tests.save();
tests.data();
tests.saveScore();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master11(){
CD_Master tests = new CD_Master();
tests.typea='Organization';
CD_Organizations__c test1=new CD_Organizations__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getorganiz();
tests.save();
tests.data();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master12(){
CD_Master tests = new CD_Master();
tests.typea='Cost Category';
CD_Cost_Category__c test1=new CD_Cost_Category__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getcostCat();
tests.save();
tests.data();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master13(){
CD_Master tests = new CD_Master();
tests.typea='Market';
CD_Market_Name__c test1=new CD_Market_Name__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getmarket();
tests.save();
tests.data();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master14(){
CD_Master tests = new CD_Master();
tests.typea='Segment';
CD_Segment__c test1=new CD_Segment__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
tests.newValue='test2';
tests.getsegment();
tests.save();
tests.data();
tests.deletes();
tests.reset();

}
static testMethod void testCD_master15(){
CD_Master tests = new CD_Master();
tests.typea='Select';
CD_Segment__c test1=new CD_Segment__c(name='test');
insert test1;
PageReference pgRef = Page.CD_MasterData;
Test.setCurrentPage(pgRef);
System.currentPageReference().getParameters().put('one', test1.id);
//Apexpages.currentPage().getParameters().put(test1.id,'one');
//tests.newValue='test2';

tests.typeset();

//tests.deletes();
//tests.reset();

}


}