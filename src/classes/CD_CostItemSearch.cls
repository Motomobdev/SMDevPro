/*
*************************************************************************************************
Description:
This  Class is controller for page CostItem Download Page

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
public class CD_CostItemSearch {
public string url{get;set;}
public  CD_Categories__c cat{ 
get{if(cat == null) {
cat = new CD_Categories__c();}
return cat;  }
set;}
public string calledFromprev;
public CD_Items__c items{ 
get{if(items == null) {
items = new CD_Items__c();}
return items;  }
set;}
public Integer count = 1;

public CD_Item_categories__c itemCat{ 
get{if(itemCat == null) {
itemCat = new CD_Item_categories__c();}
return itemCat;  }
set;}
public Account acc{ 
get{if(acc == null) {
acc= new Account();}
return acc;  }
set;}
public CD_Item_Cost_Details__c costItem{
get{if(costItem == null) {
costItem = new CD_Item_Cost_Details__c();}
return costItem;  }
set;}
public string syear{ get;set; }
public string squarter{ get;set; }
public Integer eQuarter;
public Integer eYear;
public Integer fquat;
public Integer squat;
public Integer tquat;
public Integer fourquat;
public Integer fifthquat;
public Integer fyear;
public Integer secyear;
public Integer tyear;
public Integer fouryear;
public Integer fifthyear;
public Integer startYear=System.TODAY().YEAR();
public Integer month=SYSTEM.TODAY().MONTH();
public Integer firstQuarter;
Public Integer firstYear;
public string queryString{ get;set; }
public string queryString1{ get;set; }
public List<selectOption> Categories;
public List<String> selectedCats
{  get {return selectedCats;}set;}
public List<String> selectedSubCat1
{  get {return selectedSubCat1;}set;}
public List<String> selectedSubCat2
{  get {return selectedSubCat2;}set;}
public List<String> selectedSubCat3
{  get {return selectedSubCat3;}set;}
public List<String> selectedGCL
{  get {return selectedGCL;}set;}
public List<String> selectedCatMgr
{  get {return selectedCatMgr;}set;}
public List<String> selectedCostCat
{  get {return selectedCostCat;}set;}
Public List<CD_Item_Cost_Details__c> searchResult{ get;set; }
public CD_CostItemSearch(){
sYear = String.valueOf(System.Today().year());
Integer month=SYSTEM.TODAY().MONTH();
if(month==1 ||month==2 || month==3)
{
squarter='Q1';
}
if(month==4 ||month==5 || month==6)
{
squarter='Q2';
}
if(month==7 ||month==8 || month==9)
{
squarter='Q3';
}
if(month==10 ||month==11 || month==12)
{
squarter='Q4';
}
}

public List<selectOption> getCategories()
{  
      List<selectOption> options = new List<selectOption>();
     // options.add(new selectOption('', '- None -')); 
      Map<id,String> catMap = new Map<id,String>();

     
     string querys = 'Select CD_Category__c, CD_Category__r.Name FROM CD_Categories__c where CD_Category__c!=NUll' ;
       if(selectedGCL!=null && selectedGCL.size()>0 )
      {
         List<String> gclIds = new List<String>(); 
        for(string gclId : selectedGCL)
        {
          gclIds.add('\''+gclId+ '\'');
  
        }
        querys+=' AND  CD_GCL__c IN  '+ gclIds ;
      
      }
      if(selectedCatMgr!=null && selectedCatMgr.size()>0 )
      {
       List<String> catMgrIds = new List<String>(); 
       for(string catMgrId : selectedCatMgr)
       {
        catMgrIds.add('\''+catMgrId+ '\'');
       }
       
        querys+=' AND CD_Category_Managers__c  IN  ' + catMgrIds  ;
      
      }
      if(selectedSubCat1!=null && selectedSubCat1.size()>0 )
      {
         List<String> subCat1Ids = new List<String>();
         for(string subcat1Id : selectedSubCat1)
          {
            subCat1Ids.add('\''+subcat1Id+ '\'');
          } 
      
        querys+=' AND CD_Subcategory1__c IN  '+ subCat1Ids  ;
      
      }
      if(selectedSubCat2!=null && selectedSubCat2.size()>0 )
      {
         List<String> subCat2Ids = new List<String>();
         for(string subcat2Id : selectedSubCat2)
          {
            subCat2Ids.add('\''+subcat2Id+ '\'');
          } 
        
        
        querys+=' AND CD_Subcategory2__c  IN '+ subCat2Ids  ;
      
      }
      if(selectedSubCat3!=null && selectedSubCat3.size()>0 )
      {
         List<String> subCat3Ids = new List<String>();
         for(string subcat3Id : selectedSubCat3)
          {
            subCat3Ids.add('\''+subcat3Id+ '\'');
          } 
        querys+=' AND CD_Subcategory3__c  IN  '+ subCat3Ids  ;
      
      }   
      querys+=' ORDER BY CD_Category__c ASC ' ; 
       for (CD_Categories__c cats : Database.query(querys))
      {
         catMap.put(cats.CD_Category__c, cats.CD_Category__r.Name);
      }  
       
       if(catMap.size()>0)
     {  for(id catId :  catMap.keyset())
        {
         ////system.debug(catId + catMap.get(catId));
         options.add(new selectOption(catId, catMap.get(catId))); 
        }
     }
        return options; 
        
 }   
 
           
    
 public List<selectOption> getsubCat1()
 {  
      List<selectOption> options = new List<selectOption>();
     // options.add(new selectOption('', '- None -')); 
      Map<id,String> subCat1Map = new Map<id,String>();
   
      
      string querys = 'Select CD_Subcategory1__c, CD_Subcategory1__r.Name FROM CD_Categories__c where CD_Subcategory1__c!=null' ;
       
       if(selectedCatMgr!=null && selectedCatMgr.size()>0 )
      {
         List<String> catMgrIds = new List<String>(); 
         for(string catMgrId : selectedCatMgr)
         {
          catMgrIds.add('\''+catMgrId+ '\'');
         }
        querys+=' AND CD_Category_Managers__c IN  '+ catMgrIds ;
      
      }
      if(selectedGCL!=null && selectedGCL.size()>0 )
      {
         List<String> gclIds = new List<String>(); 
        for(string gclId : selectedGCL)
        {
          gclIds.add('\''+gclId+ '\'');
  
        }
        
        querys+=' AND CD_GCL__c  IN  '+ gclIds ;
      
      }
      if(selectedCats!=null && selectedCats.size()>0 )
      {
       List<String> catIds = new List<String>();
       for(string catId :selectedCats)
       {
        catIds.add('\''+catId+ '\'');
       } 
         
        querys+=' AND CD_Category__c  IN  '+ catIds  ;
      
      }
      if(selectedSubCat2!=null && selectedSubCat2.size()>0 )
      {
        List<String> subCat2Ids = new List<String>();
         for(string subcat2Id : selectedSubCat2)
          {
            subCat2Ids.add('\''+subcat2Id+ '\'');
          } 
        querys+=' AND CD_Subcategory2__c IN  '+  subCat2Ids ;
      
      }
      if(selectedSubCat3!=null && selectedSubCat3.size()>0 )
      {
       List<String> subCat3Ids = new List<String>();
         for(string subcat3Id : selectedSubCat3)
          {
            subCat3Ids.add('\''+subcat3Id+ '\'');
          } 
       
       
        querys+=' AND CD_Subcategory3__c  IN '+ subCat3Ids ;
      
      }
      querys+=' ORDER BY CD_Subcategory1__c ASC ' ; 
      for (CD_Categories__c cats : Database.query(querys))
      {
       subCat1Map.put(cats.CD_Subcategory1__c, cats.CD_Subcategory1__r.Name);
      
      }
      
       if(subCat1Map.size()>0)
     {
     
      for(id catId :  subCat1Map.keyset())
        {
         ////system.debug(catId + catMap.get(catId));
         options.add(new selectOption(catId, subCat1Map.get(catId))); 
        }
        }
   
        return options; 
     }   
  public List<selectOption> getsubCat2()
    {  
      List<selectOption> options = new List<selectOption>();
      Map<id,String> subCat2Map = new Map<id,String>();
      string querys = 'Select CD_Subcategory2__c, CD_Subcategory2__r.Name FROM CD_Categories__c where CD_Subcategory2__c!=null' ;
         if(selectedCatMgr!=null && selectedCatMgr.size()>0 )
      {
         List<String> catMgrIds = new List<String>(); 
         for(string catMgrId : selectedCatMgr)
         {
          catMgrIds.add('\''+catMgrId+ '\'');
         }
        querys+=' AND CD_Category_Managers__c IN '+ catMgrIds ;
      
      }
      if(selectedGCL!=null && selectedGCL.size()>0 )
      {
         List<String> gclIds = new List<String>(); 
        for(string gclId : selectedGCL)
        {
          gclIds.add('\''+gclId+ '\'');
  
        }
        
        querys+=' AND CD_GCL__c  IN  '+ gclIds ;
      
      }
      if(selectedCats!=null && selectedCats.size()>0 )
      {
       List<String> catIds = new List<String>();
       for(string catId :selectedCats)
       {
        catIds.add('\''+catId+ '\'');
       } 
         
        querys+=' AND CD_Category__c  IN  '+ catIds  ;
      
      }
        if(selectedSubCat1!=null && selectedSubCat1.size()>0 )
      {
         List<String> subCat1Ids = new List<String>();
         for(string subcat1Id : selectedSubCat1)
          {
            subCat1Ids.add('\''+subcat1Id+ '\'');
          } 
      
        querys+=' AND CD_Subcategory1__c IN  '+ subCat1Ids  ;
      
      }
       if(selectedSubCat3!=null && selectedSubCat3.size()>0 )
      {
       List<String> subCat3Ids = new List<String>();
         for(string subcat3Id : selectedSubCat3)
          {
            subCat3Ids.add('\''+subcat3Id+ '\'');
          } 
       
       
        querys+=' AND CD_Subcategory3__c  IN '+ subCat3Ids ;
      
      }
       querys+=' ORDER BY CD_Subcategory2__c ASC ' ; 
      for (CD_Categories__c cats : Database.query(querys))
      {
       subCat2Map.put(cats.CD_Subcategory2__c, cats.CD_Subcategory2__r.Name);
      
      }
       if(subCat2Map.size()>0)
     {
     
      for(id catId :  subCat2Map.keyset())
        {
         ////system.debug(catId + catMap.get(catId));
         options.add(new selectOption(catId, subCat2Map.get(catId))); 
        }
        }
       return options;
   }  
     public List<selectOption> getsubCat3()
    {  
      List<selectOption> options = new List<selectOption>();
     // options.add(new selectOption('', '- None -')); 
     Map<id,String> subCat3Map = new Map<id,String>();
     string querys = 'Select CD_Subcategory3__c, CD_Subcategory3__r.Name FROM CD_Categories__c where CD_Subcategory3__c!=NUll' ; 
        if(selectedCatMgr!=null && selectedCatMgr.size()>0 )
      {
         List<String> catMgrIds = new List<String>(); 
         for(string catMgrId : selectedCatMgr)
         {
          catMgrIds.add('\''+catMgrId+ '\'');
         }
        querys+=' AND CD_Category_Managers__c IN '+ catMgrIds ;
      
      }
      
         if(selectedGCL!=null && selectedGCL.size()>0 )
      {
         List<String> gclIds = new List<String>(); 
        for(string gclId : selectedGCL)
        {
          gclIds.add('\''+gclId+ '\'');
  
        }
        
        querys+=' AND CD_GCL__c  IN  '+ gclIds ;
      
      }
          if(selectedSubCat1!=null && selectedSubCat1.size()>0 )
      {
         List<String> subCat1Ids = new List<String>();
         for(string subcat1Id : selectedSubCat1)
          {
            subCat1Ids.add('\''+subcat1Id+ '\'');
          } 
      
        querys+=' AND CD_Subcategory1__c IN  '+ subCat1Ids  ;
      
      }
     if(selectedSubCat2!=null && selectedSubCat2.size()>0 )
      {
        List<String> subCat2Ids = new List<String>();
         for(string subcat2Id : selectedSubCat2)
          {
            subCat2Ids.add('\''+subcat2Id+ '\'');
          } 
        querys+=' AND CD_Subcategory2__c IN  '+  subCat2Ids ;
      
      }
      
       if(selectedCats!=null && selectedCats.size()>0 )
      {
       List<String> catIds = new List<String>();
       for(string catId :selectedCats)
       {
        catIds.add('\''+catId+ '\'');
       } 
         
        querys+=' AND CD_Category__c  IN  '+ catIds  ;
      
      }
      querys+=' ORDER BY CD_Subcategory3__c ASC ' ; 
      for (CD_Categories__c cats : Database.query(querys))
      {
       subCat3Map.put(cats.CD_Subcategory3__c, cats.CD_Subcategory3__r.Name);
      
      }
       if(subCat3Map.size()>0)
     {
     
      for(id catId :  subCat3Map.keyset())
        {
         ////system.debug(catId + catMap.get(catId));
         options.add(new selectOption(catId, subCat3Map.get(catId))); 
        }
        }
      
        return options; 
     } 
        public List<selectOption> getGCL()
     {  
      List<selectOption> options = new List<selectOption>();
      Map<id,String> gclMap = new Map<id,String>();
      string querys = 'Select CD_GCL__c, CD_GCL__r.Name FROM CD_Categories__c where CD_GCL__c!=NUll' ;
        if(selectedCatMgr!=null && selectedCatMgr.size()>0 )
      {
         List<String> catMgrIds = new List<String>(); 
         for(string catMgrId : selectedCatMgr)
         {
          catMgrIds.add('\''+catMgrId+ '\'');
         }
        querys+=' AND CD_Category_Managers__c IN  '+ catMgrIds ;
      
      }
       if(selectedSubCat3!=null && selectedSubCat3.size()>0 )
      {
       List<String> subCat3Ids = new List<String>();
         for(string subcat3Id : selectedSubCat3)
          {
            subCat3Ids.add('\''+subcat3Id+ '\'');
          } 
       
       
        querys+=' AND CD_Subcategory3__c  IN '+ subCat3Ids ;
      
      }
       if(selectedCats!=null && selectedCats.size()>0 )
      {
       List<String> catIds = new List<String>();
       for(string catId :selectedCats)
       {
        catIds.add('\''+catId+ '\'');
       } 
         
        querys+=' AND CD_Category__c  IN  '+ catIds  ;
      
      }
        if(selectedSubCat1!=null && selectedSubCat1.size()>0 )
      {
         List<String> subCat1Ids = new List<String>();
         for(string subcat1Id : selectedSubCat1)
          {
            subCat1Ids.add('\''+subcat1Id+ '\'');
          } 
      
        querys+=' AND CD_Subcategory1__c IN  '+ subCat1Ids  ;
      
      }
        if(selectedSubCat2!=null && selectedSubCat2.size()>0 )
      {
        List<String> subCat2Ids = new List<String>();
         for(string subcat2Id : selectedSubCat2)
          {
            subCat2Ids.add('\''+subcat2Id+ '\'');
          } 
        querys+=' AND CD_Subcategory2__c IN  '+  subCat2Ids ;
      
      }
      querys+=' ORDER BY CD_GCL__c ASC ' ; 
      for (CD_Categories__c cats : Database.query(querys))
      {
       gclMap.put(cats.CD_GCL__c, cats.CD_GCL__r.Name);
      
      }
       if(gclMap.size()>0)
     {
     
      for(id catId :  gclMap.keyset())
        {
         ////system.debug(catId + catMap.get(catId));
         options.add(new selectOption(catId, gclMap.get(catId))); 
        }
        }
      
             
     
        return options; 
     } 
     public List<selectOption> getCatMgr()
      {  
      List<selectOption> options = new List<selectOption>();
     // options.add(new selectOption('', '- None -')); 
      Map<id,String> catMgrMap = new Map<id,String>();
       string querys = 'Select CD_Category_Managers__c, CD_Category_Managers__r.Name FROM CD_Categories__c where CD_Category_Managers__c!=NUll' ;
         if(selectedGCL!=null && selectedGCL.size()>0 )
      {
         List<String> gclIds = new List<String>(); 
        for(string gclId : selectedGCL)
        {
          gclIds.add('\''+gclId+ '\'');
  
        }
        
        querys+=' AND CD_GCL__c  IN  '+ gclIds ;
      
      }
        if(selectedSubCat3!=null && selectedSubCat3.size()>0 )
      {
       List<String> subCat3Ids = new List<String>();
         for(string subcat3Id : selectedSubCat3)
          {
            subCat3Ids.add('\''+subcat3Id+ '\'');
          } 
       
       
        querys+=' AND CD_Subcategory3__c  IN '+ subCat3Ids ;
      
      }
       if(selectedCats!=null && selectedCats.size()>0 )
      {
       List<String> catIds = new List<String>();
       for(string catId :selectedCats)
       {
        catIds.add('\''+catId+ '\'');
       } 
         
        querys+=' AND CD_Category__c  IN  '+ catIds  ;
      
      }
       if(selectedSubCat1!=null && selectedSubCat1.size()>0 )
      {
         List<String> subCat1Ids = new List<String>();
         for(string subcat1Id : selectedSubCat1)
          {
            subCat1Ids.add('\''+subcat1Id+ '\'');
          } 
      
        querys+=' AND CD_Subcategory1__c IN  '+ subCat1Ids  ;
      
      }
      if(selectedSubCat2!=null && selectedSubCat2.size()>0 )
      {
        List<String> subCat2Ids = new List<String>();
         for(string subcat2Id : selectedSubCat2)
          {
            subCat2Ids.add('\''+subcat2Id+ '\'');
          } 
        querys+=' AND CD_Subcategory2__c IN  '+  subCat2Ids ;
      
      }
       querys+=' ORDER BY CD_Category_Managers__c ASC ' ; 
      for (CD_Categories__c cats : Database.query(querys))
      {
       catMgrMap.put(cats.CD_Category_Managers__c, cats.CD_Category_Managers__r.Name);
      
      }
       if(catMgrMap.size()>0)
     {
     
      for(id catId :  catMgrMap.keyset())
        {
         ////system.debug(catId + catMap.get(catId));
         options.add(new selectOption(catId, catMgrMap.get(catId))); 
        }
        }
        return options; 
     }   
 
   /*      public List<selectOption> getCostCat()
    {  
      List<selectOption> options = new List<selectOption>();
     // options.add(new selectOption('', '- None -')); 
      for (CD_Cost_Category__c costCat : [SELECT Id, Name FROM CD_Cost_Category__c]) {
            options.add(new selectOption(costCat.Id, costCat.Name)); 
        }
        return options; 
     }   
  */
      
             
    

public pageReference Search()
{
 system.debug('in search method' );
  try{ 
     if(SearchResult == null)
    {
     SearchResult = new List<CD_Item_Cost_Details__c>();
    }
   else
   {
     SearchResult.Clear();
   }
  queryString='Select Id,Name,Cost_Type__c,Cost_Category_IOD__c,WeightedAverage__c,Supplier_Number_IOD__c,LastModified__c,Item_Cost_ID__c,SupplierName__c,Item_Number_IOD__c,CD_Item_categories__r.Item_Number__r.Item_Number__c,CD_Item_categories__r.Item_Number__r.Item_Description__c,Supplier_del__r.Name,Supplier_del__r.Oracle_Customer_Number__c,Cost_Category__c,Cost_Category__r.Name,Quarter__c,Year__c,Award__c,CurrencyIsoCode,Price__c, CD_Item_categories__r.Commodity_Code__r.CD_GCL__r.Name,CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__r.Name,CD_Item_categories__r.Commodity_Code__r.CD_Subcategory1__r.Name,CD_Item_categories__r.Commodity_Code__r.CD_Category__r.Name,CD_Item_categories__r.Commodity_Code__r.CD_Subcategory2__r.Name,CD_Item_categories__r.Commodity_Code__r.CD_Subcategory3__r.Name FROM CD_Item_Cost_Details__c WHERE CurrencyIsoCode!=NULL' ; 
  if(selectedCats!=null && selectedCats.size()>0 )
 {
  List<String> catIds = new List<String>();
  for(string catId :selectedCats)
  {
   catIds.add('\''+catId+ '\'');
   system.debug(catId);
  
  } 
  system.debug(catIds+ 'catIds');
 // transient string category = cat.CD_Category__c;
 // queryString=queryString+' ' + 'AND  CD_Item_categories__r.Commodity_Code__r.CD_Category__c =  \''+ String.escapeSingleQuotes(category) + '\'' ;
   queryString=queryString+' ' + 'AND  CD_Item_categories__r.Commodity_Code__r.CD_Category__c IN  ' + catIds  ;
 }
 if(selectedSubCat1!=null && selectedSubCat1.size()>0)
 {
  //transient string subCategory1 = cat.CD_Subcategory1__c;
 // queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_Subcategory1__c =  \''+ String.escapeSingleQuotes(subCategory1)+ '\'' ;
  List<String> subCat1Ids = new List<String>();
  for(string subcat1Id : selectedSubCat1)
  {
   subCat1Ids.add('\''+subcat1Id+ '\'');
  } 
   queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_Subcategory1__c IN '+ subCat1Ids ;
 }
 if(selectedSubCat2!=null && selectedSubCat2.size()>0)
 {
  //transient string subCategory2 = cat.CD_Subcategory2__c;
  //queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_Subcategory2__c =  \''+ String.escapeSingleQuotes(subCategory2)+ '\'' ;
  List<String> subCat2Ids = new List<String>(); 
  for(string subcat2Id : selectedSubCat2)
  {
   subCat2Ids.add('\''+subcat2Id+ '\'');
  } 
  queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_Subcategory2__c IN '+ subCat2Ids  ;
  
  
 }
 if(selectedSubCat3!=null && selectedSubCat3.size()>0 )
 {
 // transient string subCategory3 = cat.CD_Subcategory3__c;
 // queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_Subcategory3__c =  \''+ String.escapeSingleQuotes(subCategory3)+ '\'' ;
 
 List<String> subCat3Ids = new List<String>(); 
  for(string subcat3Id : selectedSubCat3)
  {
   subCat3Ids.add('\''+subcat3Id+ '\'');
  } 
  queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_Subcategory3__c IN '+ subCat3Ids  ;
 
 }
 if(selectedGCL!=null && selectedGCL.size()>0)
 {
  //transient string GCL = cat.CD_GCL__c;
  //queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_GCL__c =  \''+ String.escapeSingleQuotes(GCL)+ '\'' ;
  List<String> gclIds = new List<String>(); 
  for(string gclId : selectedGCL)
  {
   gclIds.add('\''+gclId+ '\'');
  
  }
  queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_GCL__c IN  ' + gclIds  ;
 }
  if(selectedCatMgr!=null && selectedCatMgr.size()>0)
 {
 // transient string catMgr = cat.CD_Category_Managers__c;
 // queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__c = \''+ String.escapeSingleQuotes(catMgr) + '\'';
  List<String> catMgrIds = new List<String>(); 
  for(string catMgrId : selectedCatMgr)
  {
   catMgrIds.add('\''+catMgrId+ '\'');
  }
  queryString=queryString+' '+'AND CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__c IN  ' + catMgrIds ;
 }
 
 if(items.CD_APC__c!=null)
 {
  system.debug(items.CD_APC__c + 'apccccccccc');
  transient string APC=items.CD_APC__c;
  queryString=queryString+' '+'AND CD_Item_categories__r.Item_Number__r.CD_APC__c =  \''+ String.escapeSingleQuotes(APC)+ '\'' ;

 }
 system.debug(items.Item_Number__c + 'items.Item_Number__c+++++');
 if(costItem.Item_Number__c!=null )
 {
  transient string itemNum=costItem.Item_Number__c;
  transient string mar='Market';
  transient string shd = 'Should Be';
  
   CD_Item_Categories__c iteCat = [select Id,Name,Commodity_Code__c,Item_Number__c,Item_Number_IOC__c,Commodity_Code__r.CD_Cost_Category__c,Commodity_Code__r.CD_Subcategory1__r.Name,Commodity_Code__r.CD_Subcategory1__c from CD_Item_Categories__c where Item_Number__c=:itemNum LIMIT 1 ];
  transient string costCategory = iteCat.Commodity_Code__r.CD_Cost_Category__c;
  system.debug(iteCat.Commodity_Code__c + 'costCategory+++++++++');
  if(costCategory!=null)
  {
  queryString=queryString+' '+'AND (( CD_Item_categories__r.Item_Number__c =  \''+ String.escapeSingleQuotes(itemNum)+ '\'' ;
   queryString=queryString+' ' + 'OR Item_Number__c =  \''+ String.escapeSingleQuotes(itemNum)+ '\'' ;
   queryString=queryString+ ')' ;
  queryString=queryString+' '+'OR ( Cost_Category__c=\'' + String.escapeSingleQuotes(costCategory) + '\'' ;
  queryString=queryString+' ' + 'AND ( Cost_Type__c=\'' + String.escapeSingleQuotes(mar) + '\'' ;
  queryString=queryString+' ' + 'OR Cost_Type__c=\'' +  String.escapeSingleQuotes(shd) + '\'' ;
  queryString=queryString+ ')' ; 
  queryString=queryString+ ')' ; 
  queryString=queryString+ ')' ; 
  }
  else
  {
   queryString=queryString+' '+'AND ( CD_Item_categories__r.Item_Number__c =  \''+ String.escapeSingleQuotes(itemNum)+ '\'' ;
   queryString=queryString+' ' + 'OR Item_Number__c =  \''+ String.escapeSingleQuotes(itemNum)+ '\'' ;
   queryString=queryString+ ')' ;
 
  }
 }
  if(items.Item_Description__c!='' && items.Item_Description__c!=null)
 {
  transient string itemDesc=items.Item_Description__c;
  queryString=queryString+' '+'AND (CD_Item_categories__r.Item_Number__r.Item_Description__c LIKE  \''+ String.escapeSingleQuotes(itemDesc)+ '\'';
  queryString=queryString+' ' + 'OR Item_Number__r.Item_Description__c= \''+ String.escapeSingleQuotes(itemDesc)+ '\'' ;
   queryString=queryString+ ')' ;
  
 }
 
if(cat.CD_Cost_Category__c!=null )
 {
 transient string costCat=cat.CD_Cost_Category__c;
 system.debug(costCat + 'acc.Name+++++++++');
 queryString=queryString+' '+'AND Cost_Category__c =  \''+ String.escapeSingleQuotes(costCat) + '\'';
  
 }
 if(costItem.Supplier_del__c!=null )
 {
 transient string supName=costItem.Supplier_del__c;
 system.debug(supName + 'acc.Name+++++++++');
 queryString=queryString+' '+'AND Supplier_del__c =  \''+ String.escapeSingleQuotes(supName) + '\'';
  
 }
 
 if((squarter!='' && syear!='') )
 {
 transient string squarterNum=squarter.substring(1);
 firstQuarter=Integer.valueOf(squarterNum);
 system.debug(squarterNum + 'squarterNum545464----');
 string syearNum =syear; 
 firstYear=Integer.valueOf(syear);
 queryString=queryString+' '+'AND ((Quarter__c = '+Integer.valueOf(squarterNum) + ' AND Year__c= ' + Integer.valueOf(syearNum) +')' ;
 }
if(firstQuarter==1)
 {
  eQuarter=2;
  fquat=1;
  squat=2;
  tquat=3;
  fourquat=4;
  fifthquat=1;
  fyear=firstYear;
  secyear=firstYear;
  tyear=firstYear;
  fouryear=firstYear;
  fifthyear=firstYear+1;
  eYear=firstYear+1;
  }
 if(firstQuarter==2)
  {
   eQuarter=3;
  fquat=2;
  squat=3;
  tquat=4;
  fourquat=1;
  fifthquat=2;
  fyear=firstYear;
  secyear=firstYear;
  tyear=firstYear;
  fouryear=firstYear+1;
  fifthyear=firstYear+1;
   eYear=firstYear+1;      
  }
if(firstQuarter==3)
  {
   eQuarter=4;
   fquat=3;
  squat=4;
  tquat=1;
  fourquat=2;
  fifthquat=3;
  fyear=firstYear;
  secyear=firstYear;
  tyear=firstYear+1;
  fouryear=firstYear+1;
  fifthyear=firstYear+1;
   eYear=firstYear+1;  
  }
if(firstQuarter==4)
 {
   eQuarter=1;
    fquat=4;
  squat=1;
  tquat=2;
  fourquat=3;
  fifthquat=4;
  fyear=firstYear;
  secyear=firstYear+1;
  tyear=firstYear+1;
  fouryear=firstYear+1;
  fifthyear=firstYear+1;
   eYear=firstYear+2;  
 }

 queryString=queryString+' '+' OR  (Quarter__c = '+ eQuarter +' '+ 'AND Year__c = ' + eYear + ')'   ;
 queryString=queryString+' '+' OR  (Quarter__c = '+ fquat +' '+ 'AND Year__c = ' + fyear + ')'   ;
 queryString=queryString+' '+' OR  (Quarter__c = '+ squat +' '+ 'AND Year__c = ' + secyear + ')'   ;
 queryString=queryString+' '+' OR  (Quarter__c = '+ tquat +' '+ 'AND Year__c = ' + tyear + ')'   ;
 queryString=queryString+' '+' OR  (Quarter__c = '+ fourquat +' '+ 'AND Year__c = ' + fouryear + ')'   ;
 queryString=queryString+' '+' OR  (Quarter__c = '+ fifthquat +' '+ 'AND Year__c = ' + fifthyear + ')' +')'  ;
 
 system.debug(queryString + 'queryString9888888');
 queryString1=queryString;
 queryString=queryString+ ' ' +'LIMIT 100';
 
  searchResult=Database.query(queryString);

}
catch(Exception e)
{
 system.debug(e);
}
 
 
 return null;
 }
public List<SelectOption> getYears() {
        List<SelectOption> options = new List<SelectOption>();
       
        for (Integer i = System.Today().year() - 2; i < System.Today().year() + 3; i++) {
          
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return options;
    }
    
public pageReference exportToExcel()
{
    PageReference csvfile =Page.CD_CSVsheet;
    csvfile.getParameters().put('Name', queryString1);
    csvfile.getParameters().put('fquat', string.valueof(fquat));
    csvfile.getParameters().put('fyear', string.valueof(fyear));
    csvfile.getParameters().put('squat', string.valueof(squat));
    csvfile.getParameters().put('syear', string.valueof(secyear));
    csvfile.getParameters().put('tquat', string.valueof(tquat));
    csvfile.getParameters().put('tyear', string.valueof(tyear));
    csvfile.getParameters().put('foquat', string.valueof(fourquat));
    csvfile.getParameters().put('foyear', string.valueof(fouryear));
    csvfile.getParameters().put('fiquat', string.valueof(fifthquat));
    csvfile.getParameters().put('fiyear', string.valueof(fifthyear));
    csvfile.getParameters().put('siquat', string.valueof(eQuarter));
    csvfile.getParameters().put('siyear', string.valueof(eYear));

    csvfile.setRedirect(true);
    return csvfile;

}

  
Public PageReference Reset(){
       
        PageReference onReset = new PageReference('/apex/CD_CostitemSearchPage' );
        onReset.setRedirect(true);
        return onReset;
    }
}