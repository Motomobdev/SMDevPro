/*
*************************************************************************************************
Description:
This is the test class for CD_BPA_Cost_Update class,CD_Copy_BPA_LOS and CD_BPA_Cost_Update_LOS classes

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
@isTest
public class CD_Copy_BPA_LOS_test {
static testMethod void testCD_copy(){
CD_Copy_BPA_LOS test = new CD_Copy_BPA_LOS();
test.costNotif();

}
static testMethod void testCD_copyBPA(){
Database.QueryLocator QL;
Database.BatchableContext BC;
CD_Category__c cat=new CD_Category__c(name='test');
insert cat;
CD_Category_Managers__c catmgr=new CD_Category_Managers__c(name='test');
insert catmgr;
CD_Items__c items = new CD_Items__c(name='test',Item_number__c='88697');
insert items;
CD_SubCategory1__c cat1 = new CD_SubCategory1__c(name='test');
insert cat1;
CD_Subcategory2__c cat2 = new CD_Subcategory2__c(name='test');
insert cat2;
CD_Subcategory3__c cat3 = new CD_Subcategory3__c(name='test');
insert cat3;
CD_GCL__c gcl = new CD_GCL__c(name='test');
insert gcl;

CD_Cost_TakeDown__c tkDn = new CD_Cost_TakeDown__c(CD_Category__c=cat.id,TD_Criteria__c='By Amount',TD_Value__c='90');
CD_Cost_TakeDown__c tkDn1 = new CD_Cost_TakeDown__c(CD_Category_Manager__c=catmgr.id,TD_Criteria__c='By Amount',TD_Value__c='100');
CD_Cost_TakeDown__c tkDn2 = new CD_Cost_TakeDown__c(CD_Items__c=items.id,TD_Criteria__c='By Amount',TD_Value__c='-10');
CD_Cost_TakeDown__c tkDn3 = new CD_Cost_TakeDown__c(CD_SubCategory1__c=cat1.id,TD_Criteria__c='By Percentage',TD_Value__c='10');
CD_Cost_TakeDown__c tkDn4 = new CD_Cost_TakeDown__c(CD_Subcategory2__c=cat2.id,TD_Criteria__c='By Percentage',TD_Value__c='90');
CD_Cost_TakeDown__c tkDn5 = new CD_Cost_TakeDown__c(CD_Subcategory3__c=cat3.id,TD_Criteria__c='By Percentage',TD_Value__c='-40');
CD_Cost_TakeDown__c tkDn6 = new CD_Cost_TakeDown__c(CD_GCL__c=gcl.id,TD_Criteria__c='By Percentage',TD_Value__c='7');
List<CD_Cost_TakeDown__c> tkDnList = new List<CD_Cost_TakeDown__c>();
tkDnList.add(tkDn);
tkDnList.add(tkDn1);
tkDnList.add(tkDn2);
tkDnList.add(tkDn3);
tkDnList.add(tkDn4);
tkDnList.add(tkDn5);
tkDnList.add(tkDn6);
insert tkDnList;
 CD_CostTakeDown_Batch batch = new CD_CostTakeDown_Batch(); 
    QL = batch.start(BC);
       batch.execute(BC, tkDnList);
       batch.finish(BC); 
}
static testMethod void testCD_copyBPA1(){
Integer startYear=System.TODAY().YEAR();
Integer month=SYSTEM.TODAY().MONTH();

Integer eQuarter;
Integer eYear;
Integer fquat;
Integer squat;
Integer tquat;
Integer fourquat;
Integer fifthquat;
Integer sixthquat;
Integer fyear;
Integer secyear;
Integer tyear;
Integer fouryear;
Integer fifthyear;
Integer sixthyear;
     {
      fquat=1;
      squat=2;
      tquat=3;
      fourquat=4;
      fifthquat=1;
      sixthquat=2;
      fyear=startYear;
      secyear=startYear;
      tyear=startYear;
      fouryear=startYear;
      fifthyear=startYear+1;
      sixthyear=startYear+1;      
      
     }
     if(month==4 ||month==5 || month==6)
     {
      fquat=2;
      squat=3;
      tquat=4;
      fourquat=1;
      fifthquat=2;
      sixthquat=3;
      fyear=startYear;
      secyear=startYear;
      tyear=startYear;
      fouryear=startYear+1;
      fifthyear=startYear+1;
      sixthyear=startYear+1;           
     }
      if(month==7 ||month==8 || month==9)
     {
      fquat=3;
      squat=4;
      tquat=1;
      fourquat=2;
      fifthquat=3;
      sixthquat=4;
      fyear=startYear;
      secyear=startYear;
      tyear=startYear+1;
      fouryear=startYear+1;
      fifthyear=startYear+1;
      sixthyear=startYear+1;      
     }
       if(month==10 ||month==11 || month==12)
     {
      fquat=4;
      squat=1;
      tquat=2;
      fourquat=3;
      fifthquat=4;
      sixthquat=1;
      fyear=startYear;
      secyear=startYear+1;
      tyear=startYear+1;
      fouryear=startYear+1;
      fifthyear=startYear+1;
      sixthyear=startYear+2;      
     } 
Database.QueryLocator QL;
Database.BatchableContext BC;
CD_Category__c cat=new CD_Category__c(name='test');
insert cat;
CD_Category_Managers__c catmgr=new CD_Category_Managers__c(name='test');
insert catmgr;
List<CD_Items__c> itemList = new List<CD_Items__c>();
CD_Items__c items = new CD_Items__c(name='test',Item_number__c='88697');
CD_Items__c items1 = new CD_Items__c(name='test',Item_number__c='886989');
itemList.add(items);
itemList.add(items1);
insert itemList;
CD_SubCategory1__c cat1 = new CD_SubCategory1__c(name='test');
insert cat1;
CD_Subcategory2__c cat2 = new CD_Subcategory2__c(name='test');
insert cat2;
CD_Subcategory3__c cat3 = new CD_Subcategory3__c(name='test');
insert cat3;
CD_Cost_Category__c costCat = new CD_Cost_Category__c(name='test');
insert costCat;
CD_GCL__c gcl = new CD_GCL__c(name='test');
insert gcl;
Account acc = new Account(name='test');
insert acc;
CD_Categories__c cdcats = new CD_Categories__c(CD_Category__c=cat.id,CD_Category_Managers__c=catmgr.id,CD_Cost_Category__c=costCat.id,CD_GCL__c=gcl.id,CD_Subcategory1__c=cat1.id,
                                                   CD_Subcategory2__c=cat2.id,CD_Subcategory3__c=cat3.id,Commodity_Code__c='sow.ext');
insert cdcats;
CD_Cost_TakeDown__c tkDn = new CD_Cost_TakeDown__c(CD_Category__c=cat.id,TD_Criteria__c='By Amount',TD_Value__c='90');
CD_Cost_TakeDown__c tkDn1 = new CD_Cost_TakeDown__c(CD_Category_Manager__c=catmgr.id,TD_Criteria__c='By Amount',TD_Value__c='100');
CD_Cost_TakeDown__c tkDn2 = new CD_Cost_TakeDown__c(CD_Items__c=items.id,TD_Criteria__c='By Amount',TD_Value__c='-10');
CD_Cost_TakeDown__c tkDn3 = new CD_Cost_TakeDown__c(CD_SubCategory1__c=cat1.id,TD_Criteria__c='By Percentage',TD_Value__c='10');
CD_Cost_TakeDown__c tkDn4 = new CD_Cost_TakeDown__c(CD_Subcategory2__c=cat2.id,TD_Criteria__c='By Percentage',TD_Value__c='90');
CD_Cost_TakeDown__c tkDn5 = new CD_Cost_TakeDown__c(CD_Subcategory3__c=cat3.id,TD_Criteria__c='By Percentage',TD_Value__c='-40');
CD_Cost_TakeDown__c tkDn6 = new CD_Cost_TakeDown__c(CD_GCL__c=gcl.id,TD_Criteria__c='By Percentage',TD_Value__c='7');
List<CD_Cost_TakeDown__c> tkDnList = new List<CD_Cost_TakeDown__c>();
tkDnList.add(tkDn);
tkDnList.add(tkDn1);
tkDnList.add(tkDn2);
tkDnList.add(tkDn3);
tkDnList.add(tkDn4);
tkDnList.add(tkDn5);
tkDnList.add(tkDn6);
insert tkDnList; 
Map<string,CD_Cost_TakeDown__c> itemmap = new Map<string,CD_Cost_TakeDown__c>();
itemmap.put('88697',tkDn2);
Map<string,CD_Cost_TakeDown__c> subcat3map = new Map<string,CD_Cost_TakeDown__c>();
itemmap.put('test',tkDn5);
Map<string,CD_Cost_TakeDown__c> subcat2map = new Map<string,CD_Cost_TakeDown__c>();
itemmap.put('test',tkDn4);
Map<string,CD_Cost_TakeDown__c> subcat1map = new Map<string,CD_Cost_TakeDown__c>();
itemmap.put('test',tkDn3);
Map<string,CD_Cost_TakeDown__c> catmap = new Map<string,CD_Cost_TakeDown__c>();
itemmap.put('test',tkDn);
Map<string,CD_Cost_TakeDown__c> catmgrmap = new Map<string,CD_Cost_TakeDown__c>();
itemmap.put('test',tkDn1);
Map<string,CD_Cost_TakeDown__c> gclmap = new Map<string,CD_Cost_TakeDown__c>();
itemmap.put('test',tkDn6);
CD_Organizations__c org = new CD_Organizations__c(name='GSO');
insert org;
List<CD_Item_Categories__c> itemcats = new List<CD_Item_Categories__c>();
CD_Item_Categories__c testitem = new CD_Item_Categories__c(name='test',Commodity_Code__c=cdcats.id,CurrencyIsoCode='INR',Item_Status__c='89-new',Organization_Code__c=org.id,Item_number__c=items.id);
 CD_Item_Categories__c testitem1 = new CD_Item_Categories__c(name='test',Commodity_Code__c=cdcats.id,CurrencyIsoCode='INR',Item_Status__c='89-new',Organization_Code__c=org.id,Item_number__c=items1.id);
 itemcats.add(testitem);
 itemcats.add(testitem1);
 insert itemcats;

CD_BPA_Cost__c bpa = new CD_BPA_Cost__c(Award__c=100,BPA_Created_By__c='testuser',BPA_Creation_Date__c=system.today(),BPA_RFQ_No__c='testnum',BPA_Updated_By__c='testuser',BPA_Updated_Date__c=system.today(),
                                         BPA_Cost_Id__c='testcostId',Cost_Type__c='LOS',Effective_End_Date__c=system.today()+1,Effective_Start_Date__c=system.today(),Item_Number__c=items.id,Price__c=90.0,Quarter__c=3,Supplier_Number__c=acc.id,
                                         Year__c=system.today().year());
CD_BPA_Cost__c bpa1 = new CD_BPA_Cost__c(Award__c=100,BPA_Created_By__c='testuser',BPA_Creation_Date__c=system.today(),BPA_RFQ_No__c='testnum',BPA_Updated_By__c='testuser',BPA_Updated_Date__c=system.today(),
                                         BPA_Cost_Id__c='testcostId1',Cost_Type__c='LOS',Effective_End_Date__c=system.today()+1,Effective_Start_Date__c=system.today(),Item_Number__c=items1.id,Price__c=90.0,Quarter__c=3,Supplier_Number__c=acc.id,
                                         Year__c=system.today().year());
  

 List<CD_Item_Cost_Details__c> insertitemCost = new List<CD_Item_Cost_Details__c>();
CD_Item_Cost_Details__c itemCost1= new CD_Item_Cost_Details__c(name='test',Price__c=100,Quarter__c=fquat,Year__c=fyear,Award__c=100,CD_Item_categories__c=testitem1.id,Item_Number__c=items1.id);
CD_Item_Cost_Details__c itemCost2= new CD_Item_Cost_Details__c(name='test1',Price__c=100,Quarter__c=squat,Year__c=secyear,Award__c=100,CD_Item_categories__c=testitem1.id,Item_Number__c=items1.id);
CD_Item_Cost_Details__c itemCost3= new CD_Item_Cost_Details__c(name='test12',Price__c=100,Quarter__c=tquat,Year__c=tyear,Award__c=100,CD_Item_categories__c=testitem1.id,Item_Number__c=items1.id);
CD_Item_Cost_Details__c itemCost4= new CD_Item_Cost_Details__c(name='test13',Price__c=100,Quarter__c=fourquat,Year__c=fouryear,Award__c=100,CD_Item_categories__c=testitem1.id,Item_Number__c=items1.id);
CD_Item_Cost_Details__c itemCost5= new CD_Item_Cost_Details__c(name='test14',Price__c=100,Quarter__c=fifthquat,Year__c=fifthyear,Award__c=100,CD_Item_categories__c=testitem1.id,Item_Number__c=items1.id);
CD_Item_Cost_Details__c itemCost6= new CD_Item_Cost_Details__c(name='test15',Price__c=100,Quarter__c=sixthquat,Year__c=sixthyear,Award__c=100,CD_Item_categories__c=testitem1.id,Item_Number__c=items1.id);
insertitemCost.add(itemCost1);
insertitemCost.add(itemCost2);
insertitemCost.add(itemCost3);
insertitemCost.add(itemCost4);
insertitemCost.add(itemCost5);
insertitemCost.add(itemCost6);
insert insertitemCost;


 
 List<CD_BPA_Cost__c> bpacost = new List<CD_BPA_Cost__c>();
 bpacost.add(bpa); 
 bpacost.add(bpa1);
 insert bpacost;     
CD_BPA_Cost_Update batch3 = new CD_BPA_Cost_Update(itemmap,subcat3map,subcat2map,subcat1map,catmap,catmgrmap,gclmap);
QL = batch3.start(BC);
       batch3.execute(BC, bpacost);
       batch3.finish(BC); 
                        
}
}