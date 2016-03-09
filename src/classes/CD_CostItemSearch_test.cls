/*
*************************************************************************************************
Description:
This is the test class for CD_CostItemSearch class and CD_Itemcostexporter classes

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
@isTest
public class CD_CostItemSearch_test {
static testMethod void testCD_CostItemSearch(){
CD_CostItemSearch test = new CD_CostItemSearch();
//CD_Category__c cat=[SELECT Id,Name FROM CD_Category__c limit 1];
CD_Category__c cat = new CD_Category__c(name='test');
insert cat;
string name=cat.Id;
List<string> cats= new List<string>();
cats.add(Name);
test.selectedCats = cats ;
test.squarter='Q3';
test.syear=string.valueof(System.TODAY().YEAR());
test.search();
test.getCategories();
test.getsubCat1();
test.getsubCat2();
test.getsubCat3();
test.getGCL();
test.getCatMgr();
test.exportToExcel();
test.getYears();
test.reset();


}
static testMethod void testCD_CostItemSearch2(){
CD_CostItemSearch test = new CD_CostItemSearch();
CD_Subcategory1__c  cat=new CD_Subcategory1__c(name='test');
insert cat;
string name=cat.Id;
List<string> cats= new List<string>();
cats.add(Name);
test.selectedsubCat1 = cats ;
test.squarter='Q3';
test.syear=string.valueof(System.TODAY().YEAR());
test.search();
test.getCategories();
test.getsubCat1();
test.getsubCat2();
test.getsubCat3();
test.getGCL();
test.getCatMgr();
test.exportToExcel();
test.getYears();
test.reset();


}

static testMethod void testCD_CostItemSearch3(){
CD_CostItemSearch test = new CD_CostItemSearch();
CD_Subcategory2__c  cat=new CD_Subcategory2__c(name='test');
insert cat;

string name=cat.Id;
List<string> cats= new List<string>();
cats.add(Name);
test.selectedsubCat2 = cats ;
test.squarter='Q3';
test.syear=string.valueof(System.TODAY().YEAR());
test.search();
test.getCategories();
test.getsubCat1();
test.getsubCat2();
test.getsubCat3();
test.getGCL();
test.getCatMgr();
test.exportToExcel();
test.getYears();
test.reset();


}
static testMethod void testCD_CostItemSearch4(){
CD_CostItemSearch test = new CD_CostItemSearch();
CD_Subcategory3__c  cat=new CD_Subcategory3__c(name='test');
insert cat;
string name=cat.Id;
List<string> cats= new List<string>();
cats.add(Name);
test.selectedsubCat3 = cats ;
test.squarter='Q3';
test.syear=string.valueof(System.TODAY().YEAR());
test.search();
test.getCategories();
test.getsubCat1();
test.getsubCat2();
test.getsubCat3();
test.getGCL();
test.getCatMgr();
test.exportToExcel();
test.getYears();
test.reset();


}
static testMethod void testCD_CostItemSearch5(){
CD_CostItemSearch test = new CD_CostItemSearch();
CD_Category_Managers__c  cat=new CD_Category_Managers__c(name='test');
insert cat;

string name=cat.Id;
List<string> cats= new List<string>();
cats.add(Name);
test.selectedCatMgr = cats ;
test.squarter='Q3';
test.syear=string.valueof(System.TODAY().YEAR());
test.search();
test.getCategories();
test.getsubCat1();
test.getsubCat2();
test.getsubCat3();
test.getGCL();
test.getCatMgr();
test.exportToExcel();
test.getYears();
test.reset();


}
static testMethod void testCD_CostItemSearch6(){
CD_CostItemSearch test = new CD_CostItemSearch();
CD_GCL__c  cat=new CD_GCL__c(name='test');
insert cat;

string name=cat.Id;
List<string> cats= new List<string>();
cats.add(Name);
test.selectedGCL = cats ;
test.squarter='Q3';
test.syear=string.valueof(System.TODAY().YEAR());
test.search();
test.getCategories();
test.getsubCat1();
test.getsubCat2();
test.getsubCat3();
test.getGCL();
test.getCatMgr();
test.exportToExcel();
test.getYears();
test.reset();


}
static testMethod void testCD_CostItemSearch7(){
CD_CostItemSearch test = new CD_CostItemSearch();
CD_Cost_Category__c  cat=new CD_Cost_Category__c(name='test');
insert cat;
string name=cat.Id;
List<string> cats= new List<string>();
cats.add(Name);
test.selectedCostCat = cats ;
test.squarter='Q3';
test.syear=string.valueof(System.TODAY().YEAR());
test.search();
test.getCategories();
test.getsubCat1();
test.getsubCat2();
test.getsubCat3();
test.getGCL();
test.getCatMgr();
test.exportToExcel();
test.getYears();
test.reset();


}
static testMethod void testCD_CostItemSearch8(){
CD_CostItemSearch test = new CD_CostItemSearch();
CD_APC__c  apc=new CD_APC__c(name='test',APC_Code__c='test1',APC_Description__c='test2');
insert apc;
cd_items__c items = new cd_items__c(name='test',CD_APC__c=apc.id, item_number__c='56natt',APC_Description__c='test2',Item_Description__c='test3');
insert items;
test.items=items;

test.squarter='Q3';
test.syear=string.valueof(System.TODAY().YEAR());
test.search();
test.getCategories();
test.getsubCat1();
test.getsubCat2();
test.getsubCat3();
test.getGCL();
test.getCatMgr();
test.exportToExcel();
test.getYears();
test.reset();


}
static testMethod void testCD_CostItemSearch9(){
CD_CostItemSearch test = new CD_CostItemSearch();
Account acc = new Account(name='test',Oracle_Customer_Number__c='tesr123');
insert acc;
CD_APC__c  apc=new CD_APC__c(name='test',APC_Code__c='test1',APC_Description__c='test2');
insert apc;
cd_items__c items = new cd_items__c(name='test',CD_APC__c=apc.id, item_number__c='56natt',APC_Description__c='test2',Item_Description__c='test3');
insert items;
CD_Category__c cat = new CD_Category__c(name='test');
insert cat;
CD_Subcategory1__c  cat1=new CD_Subcategory1__c(name='test');
insert cat1;
CD_Subcategory2__c  cat2=new CD_Subcategory2__c(name='test');
insert cat2;
CD_Subcategory3__c  cat3=new CD_Subcategory3__c(name='test');
insert cat3;
CD_Organizations__c org = new CD_Organizations__c(name='test');
insert org;

CD_Category_Managers__c  catmgr=new CD_Category_Managers__c(name='test');
insert catmgr;
CD_GCL__c  gcl=new CD_GCL__c(name='test');
insert gcl;
CD_Cost_Category__c  costcat=new CD_Cost_Category__c(name='test');
insert costcat;
CD_Categories__c categs = new CD_Categories__c(name='test',CD_Category__c=cat.id,CD_Category_Managers__c=catmgr.id,CD_Cost_Category__c=costcat.id,CD_GCL__c=gcl.id,CD_Subcategory1__c=cat1.id,CD_Subcategory2__c=cat2.id,CD_Subcategory3__c=cat3.id,Commodity_Code__c='testcomcode');
insert categs;
CD_Item_Categories__c itemcat = new CD_Item_Categories__c(name='test',Commodity_Code__c=categs.id,Item_Category_ID__c='test1234',Item_Number__c=items.id,Item_Status__c='48-test',Make_Buy_Flag__c='Y',Organization_Code__c=org.id);
insert itemcat;
CD_Item_Cost_Details__c itemcostdet= new CD_Item_Cost_Details__c(name='test',Award__c=100,CD_Item_categories__c=itemcat.id,Cost_Category__c=costcat.id,Cost_Type__c='LOS',Item_Number__c=items.id,Price__c=56.0,Quarter__c=3,Year__c=2014,Supplier_del__c=acc.id);
insert itemcostdet;
test.itemCat= itemCat;
test.acc=acc;
test.cat=categs;
test.items=items;
test.costItem=itemcostdet;
test.squarter='Q3';
test.syear=string.valueof(System.TODAY().YEAR());
test.search();
test.getCategories();
test.getsubCat1();
test.getsubCat2();
test.getsubCat3();
test.getGCL();
test.getCatMgr();
test.exportToExcel();
test.getYears();
test.reset();


}
static testMethod void testCD_itemcostexporter(){
CD_Itemcostexporter test1 = new CD_Itemcostexporter();
//CD_Cost_Category__c  cat=[SELECT Id,Name FROM  CD_Cost_Category__c  limit 1];

//string name=cat.Id;
CD_Cost_Category__c  cat=new CD_Cost_Category__c(name='test');
insert cat;
CD_Items__c  item=new CD_Items__c(name='test',item_number__c='0058NATT');
insert item;
Account acc= new Account(name='test',Oracle_Customer_Number__c='985678');
insert acc;
List<CD_Item_Cost_Details__c> cstList = new List<CD_Item_Cost_Details__c>(); 
CD_Item_Cost_Details__c cst1= new CD_Item_Cost_Details__c(name='test',Award__c=100,Cost_Assy_Name__c='test1',Cost_Category__c=cat.id,Cost_Type__c='LOS',Item_Number__c=item.id,Price__c=10,Quarter__c=3,Supplier_del__c=acc.id,Year__c=2014,CurrencyIsoCode='USD');

CD_Item_Cost_Details__c cst2= new CD_Item_Cost_Details__c(name='test',Award__c=100,Cost_Assy_Name__c='test1',Cost_Category__c=cat.id,Cost_Type__c='LOS',Item_Number__c=item.id,Price__c=10,Quarter__c=4,Supplier_del__c=acc.id,Year__c=2014,CurrencyIsoCode='USD');
CD_Item_Cost_Details__c cst3= new CD_Item_Cost_Details__c(name='test',Award__c=100,Cost_Assy_Name__c='test1',Cost_Category__c=cat.id,Cost_Type__c='LOS',Item_Number__c=item.id,Price__c=10,Quarter__c=1,Supplier_del__c=acc.id,Year__c=2015,CurrencyIsoCode='USD');
CD_Item_Cost_Details__c cst4= new CD_Item_Cost_Details__c(name='test',Award__c=100,Cost_Assy_Name__c='test1',Cost_Category__c=cat.id,Cost_Type__c='LOS',Item_Number__c=item.id,Price__c=10,Quarter__c=2,Supplier_del__c=acc.id,Year__c=2015,CurrencyIsoCode='USD');
CD_Item_Cost_Details__c cst5= new CD_Item_Cost_Details__c(name='test',Award__c=100,Cost_Assy_Name__c='test1',Cost_Category__c=cat.id,Cost_Type__c='LOS',Item_Number__c=item.id,Price__c=10,Quarter__c=3,Supplier_del__c=acc.id,Year__c=2015,CurrencyIsoCode='USD');
CD_Item_Cost_Details__c cst6= new CD_Item_Cost_Details__c(name='test',Award__c=100,Cost_Assy_Name__c='test1',Cost_Category__c=cat.id,Cost_Type__c='LOS',Item_Number__c=item.id,Price__c=10,Quarter__c=4,Supplier_del__c=acc.id,Year__c=2015,CurrencyIsoCode='USD');
cstList.add(cst1);
cstList.add(cst2);
cstList.add(cst3);
cstList.add(cst4);
cstList.add(cst5);
cstList.add(cst6);
//cstList.add(cst1);
insert cstList;
PageReference pgRef = Page.CD_CSVsheet;
Test.setCurrentPage(pgRef);
//System.currentPageReference().getParameters().put('select Id,Name,Item_number__c,Price__c,Quarter__c,Year__c,Cost_Type__c,CurrencyIsoCode,Award__c,CD_Item_categories__c,SupplierName__c,Supplier_del__c from CD_Item_Cost_Details__c where Name=\'test\' ','Name');
//System.currentPageReference().getParameters().put('name', assy.name);
System.currentPageReference().getParameters().put('Q1','fquat');
 System.currentPageReference().getParameters().put('2014','fyear');
 System.currentPageReference().getParameters().put('Q2','squat');
 System.currentPageReference().getParameters().put('2014','syear');
System.currentPageReference().getParameters().put('Q3','tquat');
 System.currentPageReference().getParameters().put('2014','tyear');
System.currentPageReference().getParameters().put('Q4','foquat');
 System.currentPageReference().getParameters().put('2014','foyear');
 System.currentPageReference().getParameters().put('Q1','fiquat');
 System.currentPageReference().getParameters().put('2015','fiyear');
 System.currentPageReference().getParameters().put('Q2','siquat');
 System.currentPageReference().getParameters().put('2015','siyear');
 //System.currentPageReference().getParameters().put('select Id,Name,Item_number__c,Price__c,Quarter__c,Year__c,Cost_Type__c,CurrencyIsoCode,Award__c,CD_Item_categories__c,SupplierName__c,Supplier_del__c from CD_Item_Cost_Details__c limit 1 ','Name');
 //test1.searchText='select Id,Name,Item_number__c,Price__c,Quarter__c,Year__c,Cost_Type__c,CurrencyIsoCode,Award__c,CD_Item_categories__c,SupplierName__c,Supplier_del__c from CD_Item_Cost_Details__c ';
string itemNo='testitem';
string supNum='testsup';
string Catgry='testcat';
string SupName='testsupName';
string cate='testcate';
string cat1='testcat1';
string cat2='testcat2';
string cat3='testcat3';
string mgr='testmgr';
string gclName='testgcl';
string iDesc='testidesc';
string cType='testctype';
string Curr='INR';
Decimal q1p=23.0;
Decimal q2p=33.0;
Decimal q3p=43.0;
Decimal q4p=53.0;
Decimal q5p=63.0;
Decimal q6p=73.0;
Decimal q1a=100.0;
Decimal q2a=100.0;
Decimal q3a=100.0;
Decimal q4a=100.0;
Decimal q5a=100.0;
Decimal q6a=100.0;
//CD_Itemcostexporter.excelWrapper wrap= new CD_Itemcostexporter.excelWrapper('45678NATT','985645','testcat','tessupname','testcate','testsubcat1','testsubcat2','testsubcat3','testcatmgr','testgcl','testidesc','testctype','INR',23.0,33.0,43.0,53.0,63.0,73.0,100.0,100.0,100.0,100.0,100.0,100.0);
//CD_Itemcostexporter.excelWrapper wrap= new CD_Itemcostexporter.excelWrapper(itemNo,supNum,Catgry,SupName,cate,cat1,cat2,cat3,mgr,gclName,iDesc,cType,Curr,q1p,q2p,q3p,q4p,q5p,q6p,q1a,q2a,q3a,q4a,q5a,q6a );
CD_Itemcostexporter wrap= new CD_Itemcostexporter();
CD_Itemcostexporter.excelWrapper wrapper = new CD_Itemcostexporter.excelWrapper();
//insert wrap;
 wrapper.excelWrapper(itemNo,supNum,Catgry,SupName,cate,cat1,cat2,cat3,mgr,gclName,iDesc,cType,Curr,q1p,q2p,q3p,q4p,q5p,q6p,q1a,q2a,q3a,q4a,q5a,q6a );
 test1.Exporttocsv();


} 






}