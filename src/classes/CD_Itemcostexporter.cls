/*
*************************************************************************************************
Description:
This  Class is controller for page CDCSVsheet for item cost download

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
public class CD_Itemcostexporter{
public string header{get; set;}
public List<CD_Item_Cost_Details__c> SearchResults {get; set;}
public string searchText {get; set;}
//public  Map<string,CD_Item_Cost_Details__c> qtrRecMap {get; set;}
public Map<string,List<CD_Item_Cost_Details__c>>  itemSupMap{get; set;}
public string fQuat = System.currentPageReference().getParameters().get('fquat');
public string fyear = System.currentPageReference().getParameters().get('fyear');
public string sQuat = System.currentPageReference().getParameters().get('squat');
public string syear = System.currentPageReference().getParameters().get('syear');
public string tQuat = System.currentPageReference().getParameters().get('tquat');
public string tyear = System.currentPageReference().getParameters().get('tyear');
public string foQuat = System.currentPageReference().getParameters().get('foquat');
public string foyear = System.currentPageReference().getParameters().get('foyear');
public string fiQuat = System.currentPageReference().getParameters().get('fiquat');
public string fiyear = System.currentPageReference().getParameters().get('fiyear');
public string siQuat = System.currentPageReference().getParameters().get('siquat');
public string siyear = System.currentPageReference().getParameters().get('siyear');
public List<excelWrapper> excelList{get; set;} 
public Class excelWrapper{
public string ItemNum{get; set;} 
public string Supplier{get; set;} 
public string Category{get; set;} 
public string costType{get; set;} 
public string currencyCode{get; set;} 
public Decimal Q1Price{get; set;} 
public Decimal Q2Price{get; set;} 
public Decimal Q3Price{get; set;} 
Public Decimal Q4Price{get; set;} 
Public Decimal Q5Price{get; set;} 
Public Decimal Q6Price{get; set;} 
public Decimal Q1Award{get; set;} 
public Decimal Q2Award{get; set;} 
public Decimal Q3Award{get; set;} 
Public Decimal Q4Award{get; set;} 
Public Decimal Q5Award{get; set;} 
Public Decimal Q6Award{get; set;} 
public String  SupplierName{get; set;} 
public String itemDesc{get; set;}
public string gcl{get; set;}
public string catMgr{get; set;}
public string subCat1{get; set;}
public string subCat2{get; set;}
public string subCat3{get; set;}
public string cat{get; set;}

public void excelWrapper(string itemNo,string supNum,string Cat,string SupName,string cate,string cat1,string cat2,string cat3,string mgr,string gclName,string iDesc, string cType,string Curr,Decimal q1p,Decimal q2p,Decimal q3p,Decimal q4p,Decimal q5p,Decimal q6p,Decimal q1a,Decimal q2a,Decimal q3a,Decimal q4a,Decimal q5a,Decimal q6a )
{
ItemNum=itemNo;
Supplier=supNum;
Category=Cat;
costType=cType;
currencyCode=Curr;
SupplierName=SupName;
itemDesc=iDesc;
gcl=gclName;
catMgr=mgr;
cat=cate;
subCat1=cat1;
subCat2=cat2;
subCat3=cat3;
Q1Price=q1p;
Q2Price=q2p;
Q3Price=q3p;
Q4Price=q4p;
Q5Price=q5p;
Q6Price=q6p;
Q1Award=q1a;
Q2Award=q2a;
Q3Award=q3a;
Q4Award=q4a;
Q5Award=q5a;
Q6Award=q6a;

}

}
public  PageReference Exporttocsv(){
header= 'Report Date:' + System.now().format('MMMM-dd-yyyy');
header+='\r\n';
header+='\r\n';
header+='Instructions to follow before Uploading CSV into the system:';
header+='\r\n';
header+='Please make sure that the file is in .CSV format before upload.';
header+='\r\n';
header+='Please note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.';
header+='\r\n';
header+='Please do not enter comma in any of the editable i.e. columns from A to Q columns.';
header+='\r\n';
header+='Please do not use formulas in any of the editable columns.';
header+='\r\n';
header+='Please put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.';
header+='\r\n';
header+='Award(%)-Cost are number columns.Rest of the fields are text fields.';
header+='\r\n';
header+='Do not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.';
header+='\r\n';
header+='Do not delete the headers of the columns.';
header+='\r\n';
header+=',,,,,';
header+='Q'+fQuat+'-'+fyear+',,'+ 'Q'+sQuat+'-'+syear+',,'+'Q'+tQuat+'-'+tyear+',,'+ 'Q'+foQuat+'-'+foyear+',,'+'Q'+fiQuat+'-'+fiyear+',,'+'Q'+ siQuat+'-'+siyear;
header+='\r\n';
header+='Cost Type,Item,Supplier Number,Cost Category, Currency,Cost,Award(%),Cost,Award(%),Cost,Award(%),Cost,Award(%),Cost,Award(%),Cost,Award(%),Supplier Name,Item Description,GCL, Category Manger, Category, Subcategory 1, Subcategory 2, Subcategory 3' ;
string searchText = System.currentPageReference().getParameters().get('Name');
system.debug(fQuat+fyear+','+ sQuat+syear+','+tQuat+tyear+','+ foQuat+foyear+','+fiQuat+fiyear+','+ siQuat+siyear);

system.debug(searchText);
string queryString=searchText+' ' +'LIMIT 7500';
if(Test.isRunningtest())
{
queryString='select Id,Name,Item_number__c,Price__c,CD_Item_categories__r.Commodity_Code__r.CD_Subcategory3__r.Name,CD_Item_categories__r.Commodity_Code__r.CD_Subcategory2__r.Name,CD_Item_categories__r.Commodity_Code__r.CD_Subcategory1__r.Name,CD_Item_categories__r.Commodity_Code__r.CD_Category__r.Name,CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__r.Name,Quarter__c,Year__c,Cost_Type__c,CD_Item_categories__r.Commodity_Code__r.CD_GCL__r.Name,CD_Item_categories__r.Item_Number__r.Item_Description__c,Supplier_Number_IOD__c,Item_Number_IOD__c,Cost_Category_IOD__c,CurrencyIsoCode,Award__c,CD_Item_categories__c,SupplierName__c,Supplier_del__c from CD_Item_Cost_Details__c where name=\'test\'  ';
} 
SearchResults = Database.query(queryString);
itemSupMap= new Map<string,List<CD_Item_Cost_Details__c>>();
if(SearchResults.size()>0){
for(CD_Item_Cost_Details__c costDet : SearchResults)
{

string mapKey=costDet.Cost_Type__c+costDet.Item_Number_IOD__c+costDet.Supplier_Number_IOD__c+costDet.Cost_Category_IOD__c;
if(itemSupMap.containsKey(mapKey))
{
itemSupMap.get(mapKey).add(costDet);
}
else
{
List<CD_Item_Cost_Details__c> listCats = new List<CD_Item_Cost_Details__c>();
listCats.add(costDet);
itemSupMap.put(mapKey,listCats);

}
system.debug(itemSupMap.size() + 'size' +  itemSupMap);
}
}
if(itemSupMap.size()>0)
{
excelList=new List<excelWrapper>();
for(string str : itemSupMap.Keyset())
{
 excelWrapper exl = new excelWrapper();
 if(itemSupMap.get(str).size()>0)
 {
   exl.ItemNum=itemSupMap.get(str)[0].Item_Number_IOD__c;
   exl.supplier = itemSupMap.get(str)[0].Supplier_Number_IOD__c;
   exl.Category = itemSupMap.get(str)[0].Cost_Category_IOD__c;
   exl.costType = itemSupMap.get(str)[0].Cost_Type__c;
   exl.currencyCode = itemSupMap.get(str)[0].CurrencyIsoCode;
   exl.itemDesc = itemSupMap.get(str)[0].CD_Item_categories__r.Item_Number__r.Item_Description__c;   
   exl.SupplierName=itemSupMap.get(str)[0].SupplierName__c;
   exl.gcl = itemSupMap.get(str)[0].CD_Item_categories__r.Commodity_Code__r.CD_GCL__r.Name;
   exl.catMgr=itemSupMap.get(str)[0].CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__r.Name;
   exl.cat=itemSupMap.get(str)[0].CD_Item_categories__r.Commodity_Code__r.CD_Category__r.Name;
   exl.subCat1=itemSupMap.get(str)[0].CD_Item_categories__r.Commodity_Code__r.CD_Subcategory1__r.Name;
   exl.subCat2=itemSupMap.get(str)[0].CD_Item_categories__r.Commodity_Code__r.CD_Subcategory2__r.Name;
   exl.subCat3=itemSupMap.get(str)[0].CD_Item_categories__r.Commodity_Code__r.CD_Subcategory3__r.Name;
   exl.Q1Price = itemSupMap.get(str)[0].Price__c;
   exl.Q1Award = itemSupMap.get(str)[0].Award__c;
  
   
 }
 if(itemSupMap.get(str).size()>1)
 {
  exl.Q2Price = itemSupMap.get(str)[1].Price__c;
   exl.Q2Award = itemSupMap.get(str)[1].Award__c;
  }
 
 if(itemSupMap.get(str).size()>2)
 {
   exl.Q3Price = itemSupMap.get(str)[2].Price__c;
   exl.Q3Award = itemSupMap.get(str)[2].Award__c;
  } 

 if(itemSupMap.get(str).size()>3) 
 {
  exl.Q4Price = itemSupMap.get(str)[3].Price__c;
  exl.Q4Award = itemSupMap.get(str)[3].Award__c;
  }
 
 
 if(itemSupMap.get(str).size()>4) 
 { 
 exl.Q5Price = itemSupMap.get(str)[4].Price__c;
 exl.Q5Award = itemSupMap.get(str)[4].Award__c;
 }
 
  if(itemSupMap.get(str).size()>5) 
 {
  exl.Q6Price = itemSupMap.get(str)[5].Price__c;
  exl.Q6Award = itemSupMap.get(str)[5].Award__c;
 }
 
 excelList.add(exl);
}


}
return null;
}
}