/*
*************************************************************************************************
Description:
This is the test class for ItemCostLoader1 class

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
@isTest
public class CD_ItemcostLoader1_test {
static testMethod void testcostLoader(){
string csvrec='Report Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';

ItemCostLoader1 test = new ItemCostLoader1();
test.csvFile=blob.valueof(csvrec);
test.ReadFile();
}

static testMethod void testcostLoader2(){
string csvrec='Report Date:October-20-2014\n';                                            
csvrec+='Instructions to follow before Uploading CSV into the system:\n'  ;                                                                                             
csvrec+='Please make sure that the file is in .CSV format before upload.\n';                                                                                             
csvrec+='Please note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\n'   ;                                                                                         
csvrec+='Please do not enter comma in any of the editable i.e. columns from A to Q columns.\n'    ;                                                                                         
csvrec+='Please do not use formulas in any of the editable columns.\n';                                                                                              
csvrec+='put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\n';                                                                                             
csvrec+='Award(%)-Cost are number columns.Rest of the fields are text fields.\n';                                                                                               
csvrec+='Do not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\n';                                                                                               
csvrec+='Do not delete the headers of the columns.\n';                                                                                            
csvrec+='Q4-2014,Q1-2015,Q2-2015,Q3-2015,Q4-2015,Q1-2016\n';                                 
csvrec+='Cost Type,Item,Supplier Number,Cost Category,Currency,Cost,Award(%),Cost,Award(%),Cost,Award(%),Cost,Award(%),Cost,Award(%),Cost,Award(%),Supplier Name,Item Description,GCL,Category Manger,Category,Subcategory 1,Subcategory 2,Subcategory 3';
csvrec+='LOS,82PA00000006,0452459,Software,USD, 0.8951,100,0.8951,100,0.8951,100,0.8951,100,0.8951,100,0.8951,100,FLEXTRONICS INTERNATIONAL USA INC,"CONT,USER DIGITAL PRINTING,XFO",Masumi Reynders,Tim Goodall,Software,Software';       
ItemCostLoader1 test = new ItemCostLoader1();
test.csvfile=blob.valueof(csvrec);
test.ReadFile();
//List<List<string>> csv= new List<List<string>>('LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100');
//string cs='LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100';
/*List<string> csv= new List<string>();
csv.add(csvrec);
List<List<string>> csvs = new List<List<string>>();
csvs.add(csv);
ItemCostLoader1 test = new ItemCostLoader1();
test.csvFile=blob.valueof(csvrec);
test.createmaps(csvs); */
 Iterable<String> QL;
Database.BatchableContext BC;
CD_DataConstructor batch = new CD_DataConstructor(csvrec);
 QL = batch.start(BC);
 //batch.execute(BC, csvrec);
// batch.finish(BC); 
 
}
static testMethod void testcostLoader3(){
string csvrec='Report Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';
//List<List<string>> csv= new List<List<string>>('LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100');
string cs='LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100';
List<string> csv= new List<string>();
csv.add(cs);
List<List<string>> csvs = new List<List<string>>();
csvs.add(csv);
ItemCostLoader1 test = new ItemCostLoader1();
test.csvFile=blob.valueof(csvrec);
Map<Id,String> inpu = new Map<Id,String>();
inpu.put('a7LL00000008PEbMAM','0613952W01');
Map<String,Id> input = new Map<String,Id>();
input.put('0613952W01','a7LL00000008PEbMAM');
test.createItemMap(input,csvs,inpu);
}
static testMethod void testcostLoader4(){
string csvrec='Report Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';
//List<List<string>> csv= new List<List<string>>('LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100');
string cs='LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100';
List<string> csv= new List<string>();
csv.add(cs);
List<List<string>> csvs = new List<List<string>>();
csvs.add(csv);
ItemCostLoader1 test = new ItemCostLoader1();
test.csvFile=blob.valueof(csvrec);
test.geterrorrecords();
test.refresh();
Map<Id,String> inpu = new Map<Id,String>();
inpu.put('a7LL00000008PEbMAM','0613952W01');
Map<String,Id> input = new Map<String,Id>();
input.put('0613952W01','a7LL00000008PEbMAM');
Map<Id,String> suinpu = new Map<Id,String>();
inpu.put('0014000000Hr1JoAAJ','98737404');
Map<String,Id> suinput = new Map<String,Id>();
input.put('98737404','0014000000Hr1JoAAJ');
test.createSuppMap(suinput,input,csvs,inpu,suinpu);
}
static testMethod void testcostLoader5(){
string csvrec='Report Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';
//List<List<string>> csv= new List<List<string>>('LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100');
string cs='LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100';
List<string> csv= new List<string>();
 for (Integer i=0;i<20;i++) {
csv.add(cs);
}
List<List<string>> csvs = new List<List<string>>();
csvs.add(csv);
ItemCostLoader1 test = new ItemCostLoader1();
test.csvFile=blob.valueof(csvrec);
Map<Id,String> inpu = new Map<Id,String>();
inpu.put('a7LL00000008PEbMAM','0613952W01');
Map<String,Id> input = new Map<String,Id>();
input.put('0613952W01','a7LL00000008PEbMAM');
Map<Id,String> suinpu = new Map<Id,String>();
inpu.put('0014000000Hr1JoAAJ','98737404');
Map<String,Id> suinput = new Map<String,Id>();
input.put('98737404','0014000000Hr1JoAAJ');
Map<String,Id> extinput = new Map<String,Id>();
input.put('LOS-678','0014000000Hr1JoAAJ');
Map<String ,Set<Decimal>> awardKey = new Map<String ,Set<Decimal>>();
decimal d=100;
set<decimal> ds = new set<decimal>();
ds.add(d);
awardKey.put('0613952W01',ds);
test.createObjectData(csvs,suinput,input,extinput,awardKey,inpu,suinpu);
}
static testMethod void testcostLoader6(){
string csvrec='Report Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';
//List<List<string>> csv= new List<List<string>>('LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100');
string cs='LOS,51016102001,1009152,,USD,4.5,100,4.56,100,4.5,100,4.5,100,4.5,100,4.5,100';
List<string> csv= new List<string>();
csv.add(cs);
List<List<string>> csvs = new List<List<string>>();
csvs.add(csv);
ItemCostLoader1 test = new ItemCostLoader1();
test.csvFile=blob.valueof(csvrec);
Map<Id,String> inpu = new Map<Id,String>();
inpu.put('a7LL00000008PEbMAM','0613952W01');
Map<String,Id> input = new Map<String,Id>();
input.put('0613952W01','a7LL00000008PEbMAM');
Map<Id,String> suinpu = new Map<Id,String>();
inpu.put('0014000000Hr1JoAAJ','98737404');
Map<String,Id> suinput = new Map<String,Id>();
input.put('98737404','0014000000Hr1JoAAJ');
Map<String,Id> extinput = new Map<String,Id>();
input.put('LOS-678','0014000000Hr1JoAAJ');
Map<String ,Set<Decimal>> awardKey = new Map<String ,Set<Decimal>>();
decimal d=100;
set<decimal> ds = new set<decimal>();
ds.add(d);
awardKey.put('0613952W01',ds);
//test.createObjectData(csvs,suinput,input,extinput,awardKey,inpu,suinpu);
Database.QueryLocator QL;
Database.BatchableContext BC;
List<Account> acc = new List<Account>();
 for (Integer i=0;i<10;i++) {
           Account m = new Account(
              name='test'
               );
           acc.add(m);
       }

 CD_SupplierNumberCon batch = new CD_SupplierNumberCon(input,csvs,inpu);
 QL = batch.start(BC);
 batch.execute(BC, acc);
 batch.finish(BC); 
 
}
static testMethod void testcostLoader7(){
string csvrec='Report Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';
//List<List<string>> csv= new List<List<string>>('LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100');
string cs='LOS,51016102001,1009152,,USD,4.5,100,4.56,100,4.5,100,4.5,100,4.5,100,4.5,100';
List<string> csv= new List<string>();
csv.add(cs);
List<List<string>> csvs = new List<List<string>>();
csvs.add(csv);
ItemCostLoader1 test = new ItemCostLoader1();
test.csvFile=blob.valueof(csvrec);

Map<Id,String> inpu = new Map<Id,String>();
inpu.put('a7LL00000008PEbMAM','0613952W01');
Map<String,Id> input = new Map<String,Id>();
input.put('0613952W01','a7LL00000008PEbMAM');
Map<Id,String> suinpu = new Map<Id,String>();
inpu.put('0014000000Hr1JoAAJ','98737404');
Map<String,Id> suinput = new Map<String,Id>();
input.put('98737404','0014000000Hr1JoAAJ');
Map<String,Id> extinput = new Map<String,Id>();
input.put('LOS-678','0014000000Hr1JoAAJ');
Map<String ,Set<Decimal>> awardKey = new Map<String ,Set<Decimal>>();
decimal d=100;
set<decimal> ds = new set<decimal>();
ds.add(d);
awardKey.put('0613952W01',ds);
//test.createObjectData(csvs,suinput,input,extinput,awardKey,inpu,suinpu);
 Iterable<String> QL;
Database.BatchableContext BC;
List<Account> acc = new List<Account>();
 for (Integer i=0;i<10;i++) {
           Account m = new Account(
              name='test'
               );
           acc.add(m);
       }

 CD_DataConstructor batch = new CD_DataConstructor(cs);
 QL = batch.start(BC);
 batch.execute(BC, csv);
 batch.finish(BC); 
 
}
static testMethod void testcostLoader8(){
string csvrec='Report Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';
//List<List<string>> csv= new List<List<string>>('LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100');
string cs='LOS,51016102001,1009152,,USD,4.5,100,4.56,100,4.5,100,4.5,100,4.5,100,4.5,100';
List<string> csv= new List<string>();
csv.add(cs);
List<List<string>> csvs = new List<List<string>>();
csvs.add(csv);
ItemCostLoader1 test = new ItemCostLoader1();
test.csvFile=blob.valueof(csvrec);
Map<Id,String> inpu = new Map<Id,String>();
inpu.put('a7LL00000008PEbMAM','0613952W01');
Map<String,Id> input = new Map<String,Id>();
input.put('0613952W01','a7LL00000008PEbMAM');
Map<Id,String> suinpu = new Map<Id,String>();
inpu.put('0014000000Hr1JoAAJ','98737404');
Map<String,Id> suinput = new Map<String,Id>();
input.put('98737404','0014000000Hr1JoAAJ');
Map<String,Id> extinput = new Map<String,Id>();
input.put('LOS-678','0014000000Hr1JoAAJ');
Map<String ,Set<Decimal>> awardKey = new Map<String ,Set<Decimal>>();
decimal d=100;
set<decimal> ds = new set<decimal>();
ds.add(d);
awardKey.put('0613952W01',ds);
//test.createObjectData(csvs,suinput,input,extinput,awardKey,inpu,suinpu);
Database.QueryLocator QL;
Database.BatchableContext BC;
CD_Cost_Category__c costcat = new CD_Cost_Category__c(name='test');
List<CD_Item_Cost_Details__c> acc = new List<CD_Item_Cost_Details__c>();
 for (Integer i=0;i<1;i++) {
           CD_Item_Cost_Details__c m = new CD_Item_Cost_Details__c(
              name='test'
               );
           acc.add(m);
       }

 ItemCostLoader1.errorwrapper error = new ItemCostLoader1.errorwrapper(acc[0],'no error');
 CD_ExtKeyNumberCon batch = new CD_ExtKeyNumberCon(suinput,input,csvs,inpu,suinpu);
 QL = batch.start(BC);
 batch.execute(BC, acc);
 batch.finish(BC); 
 
}

static testMethod void testcostLoader9(){
string csvrec='Report Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';
//List<List<string>> csv= new List<List<string>>('LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100');
string cs='LOS,51016102001,1009152,,USD,4.5,100,4.56,100,4.5,100,4.5,100,4.5,100,4.5,100';
List<string> csv= new List<string>();
csv.add(cs);
List<List<string>> csvs = new List<List<string>>();
csvs.add(csv);
ItemCostLoader1 test = new ItemCostLoader1();
test.csvFile=blob.valueof(csvrec);
Map<Id,String> inpu = new Map<Id,String>();
inpu.put('a7LL00000008PEbMAM','0613952W01');
Map<String,Id> input = new Map<String,Id>();
input.put('0613952W01','a7LL00000008PEbMAM');
Map<Id,String> suinpu = new Map<Id,String>();
inpu.put('0014000000Hr1JoAAJ','98737404');
Map<String,Id> suinput = new Map<String,Id>();
input.put('98737404','0014000000Hr1JoAAJ');
Map<String,Id> extinput = new Map<String,Id>();
input.put('LOS-678','0014000000Hr1JoAAJ');
Map<String ,Set<Decimal>> awardKey = new Map<String ,Set<Decimal>>();
decimal d=100;
set<decimal> ds = new set<decimal>();
ds.add(d);
awardKey.put('0613952W01',ds);
//test.createObjectData(csvs,suinput,input,extinput,awardKey,inpu,suinpu);
Database.QueryLocator QL;
Database.BatchableContext BC;
List<CD_Item_categories__c> acc = new List<CD_Item_categories__c>();
 for (Integer i=0;i<1;i++) {
           CD_Item_categories__c m = new CD_Item_categories__c(
              name='test'
               );
           acc.add(m);
       }

 CD_ItemNumberCon batch = new CD_ItemNumberCon(csvs);
 QL = batch.start(BC);
 batch.execute(BC, acc);
 batch.finish(BC); 
 
}

static testMethod void testcostLoader10(){
string csvrec='\nReport Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';
Database.QueryLocator QL;
Database.BatchableContext BC;
 CSVIterator batch = new CSVIterator(csvrec,'\n');
 batch.hasNext();
 batch.next();
 batch.Iterator();
 string data='"test,data"\n';

 CSVReader.readIETFRFC4180CSVValue(data);

 
}


static testMethod void testcostLoader11(){
//string csvrec='\nReport Date:October-17-2014\nInstructions to follow before Uploading CSV into the system:\nPlease make sure that the file is in .CSV format before upload.\nPlease note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.\nPlease do not enter comma in any of the editable i.e. columns from A to Q columns.\nPlease do not use formulas in any of the editable columns.\nPlease put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.\nAward(%)-Cost are number columns.Rest of the fields are text fields.\nDo not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.\nDo not delete the headers of the columns.\nCost Type\n\nLOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100\n';
//List<List<string>> csv= new List<List<string>>('LOS,51016102001,1009152,,USD,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100,4.5,100');

Account acc = new Account(name='test',Oracle_Customer_Number__c='test123');
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
CD_Organizations__c org = new CD_Organizations__c(name='GSO');
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
CD_Item_Cost_Details__c itemcostdet= new CD_Item_Cost_Details__c(name='test',Award__c=100,CD_Item_categories__c=itemcat.id,Cost_Category__c=costcat.id,Cost_Type__c='LOS',Item_Number__c=items.id,Price__c=56.0,Quarter__c=3,Year__c=2014,Supplier_del__c=acc.id,currencyIsoCode='USD');
insert itemcostdet;
string cs='Report Date:October-20-2014';
string cs1='Instructions to follow before Uploading CSV into the system:';
string cs2='Please make sure that the file is in .CSV format before upload.';
string cs3='Please note that only columns A to Q i.e. columns Cost Type';
string cs4='Please do not enter comma in any of the editable i.e. columns from A to Q columns.';
string cs5='Please do not use formulas in any of the editable columns.';                                                                                              
string cs6='put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.';                                                                                             
string cs7='Award(%)-Cost are number columns.Rest of the fields are text fields.';                                                                                               
string cs8='Do not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.';                                                                                               
string cs9='Do not delete the headers of the columns.\n';                                                                                            
string cs10='Q4-2014';
string cs11='Q1-2015';
string cs12='Q2-2015';
string cs13='Q3-2015';
string cs14='Q4-2015';
string cs15='Q1-2016';  
string cs16='Cost Type';
string cs17='Item';
string cs18='Supplier Number';
string cs19='Cost Category';
string cs20='Currency';
string cs21='Cost';
string cs22='Award(%)';
string cs23='Cost';
string cs24='Award(%)';
string cs25='Cost';
string cs26='Award(%)';
string cs27='Cost';
string cs28='Award(%)';
string cs29='Cost';
string cs30='Award(%)';
string cs31='Cost';
string cs32='Award(%)';
string cs33='Supplier Name';
string cs34='Item Description';
string cs35='GCL';
string cs36='Category Manger';
string cs37='Category';
string cs38='Subcategory 1';
string cs39='Subcategory 2';
string cs40='Subcategory 3';     
string cs41='LOS';
string cs42='56natt';
string cs43='test123';
string cs44='test';
string cs45='USD';
string cs46='0.8951';
string cs47='100';
string cs48='0.8951';
string cs49='100';
string cs50='0.8951';
string cs51='100';
string cs52='0.8951';
string cs53='100';
string cs54='0.8951';
string cs55='100';
string cs56='0.8951';
string cs57='100'; 

List<string> csv= new List<string>();
csv.add(cs);
List<string> csv1= new List<string>();
csv1.add(cs1);
List<string> csv2= new List<string>();
csv2.add(cs2);
List<string> csv3= new List<string>();
csv3.add(cs3);
List<string> csv4= new List<string>();
csv4.add(cs4);
List<string> csv5= new List<string>();
csv5.add(cs5);
List<string> csv6= new List<string>();
csv6.add(cs6);
List<string> csv7= new List<string>();
csv7.add(cs7);
List<string> csv8= new List<string>();
csv8.add(cs8);
List<string> csv9= new List<string>();
csv9.add(cs9);
List<string> csv10= new List<string>();
csv10.add(cs10);
List<string> csv11= new List<string>();
csv11.add(cs11);
List<string> csv12= new List<string>();
csv12.add(cs12);
List<string> csv13= new List<string>();
csv13.add(cs13);
List<string> csv14= new List<string>();
csv14.add(cs14);
List<string> csv15= new List<string>();
csv15.add(cs15);
List<string> csv16= new List<string>();
csv16.add(cs16);
List<string> csv17= new List<string>();
csv17.add(cs17);


List<string> csv18= new List<string>();
csv18.add(cs18);
List<string> csv19= new List<string>();
csv19.add(cs19);
List<string> csv20= new List<string>();
csv20.add(cs20);
List<string> csv21= new List<string>();
csv21.add(cs21);
List<string> csv22= new List<string>();
csv22.add(cs22);


List<string> csv23= new List<string>();
csv23.add(cs23);
List<string> csv24= new List<string>();
csv24.add(cs24);
List<string> csv25= new List<string>();
csv25.add(cs25);
List<string> csv26= new List<string>();
csv26.add(cs26);
List<string> csv27= new List<string>();
csv27.add(cs27);
List<string> csv28= new List<string>();
csv28.add(cs28);
List<string> csv29= new List<string>();
csv29.add(cs29);
List<string> csv30= new List<string>();
csv30.add(cs30);
List<string> csv31= new List<string>();
csv31.add(cs31);
List<string> csv32= new List<string>();
csv32.add(cs32);
List<string> csv33= new List<string>();
csv33.add(cs33);
List<string> csv34= new List<string>();
csv34.add(cs34);
List<string> csv35= new List<string>();
csv35.add(cs35);
List<string> csv36= new List<string>();
csv36.add(cs36);
List<string> csv37= new List<string>();
csv37.add(cs37);


List<string> csv38= new List<string>();
csv38.add(cs38);
List<string> csv39= new List<string>();
csv39.add(cs39);
List<string> csv40= new List<string>();
csv40.add(cs40);
List<string> csv41= new List<string>();
csv41.add(cs41);
List<string> csv42= new List<string>();
csv42.add(cs42);
List<string> csv43= new List<string>();
csv43.add(cs43);
List<string> csv44= new List<string>();
csv44.add(cs44);
List<string> csv45= new List<string>();
csv45.add(cs45);
List<string> csv46= new List<string>();
csv46.add(cs46);
List<string> csv47= new List<string>();
csv47.add(cs47);
List<string> csv48= new List<string>();
csv48.add(cs48);
List<string> csv49= new List<string>();
csv49.add(cs49);
List<string> csv50= new List<string>();
csv50.add(cs50);
List<string> csv51= new List<string>();
csv51.add(cs51);
List<string> csv52= new List<string>();
csv52.add(cs52);
List<string> csv53= new List<string>();
csv53.add(cs53);
List<string> csv54= new List<string>();
csv54.add(cs54);
List<string> csv55= new List<string>();
csv55.add(cs55);
List<string> csv56= new List<string>();
csv56.add(cs56);
List<string> csv57= new List<string>();
csv57.add(cs57);




//csv.add(cs10,cs11,cs12,cs13,cs14,cs15);
List<List<string>> csvs = new List<List<string>>();
csvs.add(csv);
csvs.add(csv1);
csvs.add(csv2);
csvs.add(csv3);
csvs.add(csv4);
csvs.add(csv5);
csvs.add(csv6);
csvs.add(csv7);
csvs.add(csv8);
csvs.add(csv9);
csvs.add(csv10);
csvs.add(csv11);
csvs.add(csv12);


csvs.add(csv13);
csvs.add(csv14);
csvs.add(csv15);
csvs.add(csv16);
csvs.add(csv17);
csvs.add(csv18);
csvs.add(csv19);
csvs.add(csv20);
csvs.add(csv21);
csvs.add(csv22);
csvs.add(csv23);
csvs.add(csv24);
csvs.add(csv25);


csvs.add(csv26);
csvs.add(csv27);
csvs.add(csv28);
csvs.add(csv29);
csvs.add(csv30);
csvs.add(csv31);
csvs.add(csv32);
csvs.add(csv33);
csvs.add(csv34);
csvs.add(csv35);
csvs.add(csv36);
csvs.add(csv37);


csvs.add(csv38);
csvs.add(csv39);
csvs.add(csv40);
csvs.add(csv41);
csvs.add(csv42);
csvs.add(csv43);
csvs.add(csv44);
csvs.add(csv45);
csvs.add(csv46);
csvs.add(csv47);
csvs.add(csv48);
csvs.add(csv49);
csvs.add(csv50);
csvs.add(csv51);
csvs.add(csv52);
csvs.add(csv53);
csvs.add(csv54);
csvs.add(csv55);
csvs.add(csv56);
csvs.add(csv57);



Map<string,Id> suppinput = new Map<string,Id>();
suppinput.put(acc.Oracle_Customer_Number__c,acc.id);
Map<string,Id> iteminput= new Map<string,Id>();
iteminput.put(items.Item_Number__c,itemcat.id);
Map<string,Id> extKey=new Map<string,Id>();
extKey.put(itemcostdet.ExternalKey__c,itemcostdet.id);
Map<String ,Set<Decimal>> awardKey= new Map<String ,Set<Decimal>>();
Set<Decimal> dec= new Set<Decimal>();
dec.add(100.0);
awardKey.put(items.Item_Number__c,dec);
Map<Id,String> itemIdKey = new Map<Id,String>();
itemIdKey.put(itemcat.id,itemcat.item_number__c);
Map<Id,String> suppIdNumMap =new Map<Id,String>();
suppIdNumMap.put(acc.id,acc.Oracle_Customer_Number__c);
ItemcostLoader1 test1  =new ItemcostLoader1();
system.debug(csvs.size()+'csvs************'+csvs);
test1.createObjectData(csvs,suppinput,iteminput,extKey,awardKey,itemIdKey,suppIdNumMap);




 
}








}