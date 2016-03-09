/*
*********************************************************************************************************
Description:
This  Class is controller for page BPA to LOS COPY Page to copy BPA costs to LOS osts in itemcostdetails

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*********************************************************************************************************
*/
global class  CD_BPA_Cost_Update_LOS implements Database.Batchable<SObject>,Database.Stateful
{
 Public Map<String,CD_Cost_TakeDown__c> tkDnMap= new Map<String,CD_Cost_TakeDown__c>();
 Public Map<string,CD_BPA_Cost__c> latestBPA = new Map<string,CD_BPA_Cost__c>();
 Public Map<string,List<CD_BPA_Cost__c>> awardBPA = new Map<string,List<CD_BPA_Cost__c>>();
 public List<CD_BPA_Cost__c> insertList = new List<CD_BPA_Cost__c>();
 Public List<CD_Item_Cost_Details__c> insertitemCost = new List<CD_Item_Cost_Details__c>();
 Public List<CD_Item_Cost_Details__c> updateitemCost = new List<CD_Item_Cost_Details__c>();
 Public List<String> idList = new List<String>();
 public Decimal firstPrice;
 public Decimal secPrice;
 public Decimal thirdPrice;
 public Decimal fourthPrice;
 public Decimal fifthPrice;
 public Decimal sixthPrice;
 public Integer eQuarter;
 public Integer eYear;
 public Integer fquat;
 public Integer squat;
 public Integer tquat;
 public Integer fourquat;
 public Integer fifthquat;
 public Integer sixthquat;
 public Integer fyear;
 public Integer secyear;
 public Integer tyear;
 public Integer fouryear;
 public Integer fifthyear;
 public Integer sixthyear;
 public Integer startYear=System.TODAY().YEAR();
 public Integer month=SYSTEM.TODAY().MONTH();
 public Map<String,CD_Cost_TakeDown__c> itemMap= new Map<String,CD_Cost_TakeDown__c>() ;
public Map<String,CD_Cost_TakeDown__c> subCat3Map = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> subCat2Map = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> subCat1Map = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> catMap = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> catMgrMap = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> gclMap = new Map<String,CD_Cost_TakeDown__c>();
 
 
public  CD_BPA_Cost_Update_LOS(Map<String,CD_Cost_TakeDown__c> itemMaps,Map<String,CD_Cost_TakeDown__c> subCat3Maps,Map<String,CD_Cost_TakeDown__c> subCat2Maps,Map<String,CD_Cost_TakeDown__c> subCat1Maps,Map<String,CD_Cost_TakeDown__c> catMaps, Map<String,CD_Cost_TakeDown__c> catMgrMaps,Map<String,CD_Cost_TakeDown__c> gclMaps,Map<string,CD_BPA_Cost__c> lastModDateMap,Map<string,List<CD_BPA_Cost__c>> awardBPAs,List<CD_BPA_Cost__c> insertLists ){

//tkDnMap=tkDwnMap;
itemMap=itemMaps;
subCat3Map=subCat3Maps;
subCat2Map=subCat2Maps;
subCat1Map=subCat1Maps;
catMap=catMaps;
catMgrMap=catMgrMaps;
gclMap=gclMaps;
latestBPA=lastModDateMap;
awardBPA=awardBPAs;
insertList=insertLists;
}
global Database.QueryLocator start(Database.BatchableContext BC){
   system.debug(insertList.size() + 'insertList');
   //system.debug(tkDnMap.size() + 'tkdn');
   system.debug(latestBPA.size() + 'latestBpa');
    system.debug(awardBPA.size() + 'latestBpa');
   for(CD_BPA_Cost__c bpas:insertList)
   {
   
    idList.add(string.ValueOf(bpas.id));
   
   }
   system.debug(idList.size() + 'idList');
   String query = 'select Id,Name,Award__c,CurrencyIsoCode,Supplier_Number__r.Oracle_Customer_Number__c,Supplier_Number__c,BPA_Created_By__c,BPA_Creation_Date__c,BPA_RFQ_No__c,BPA_Updated_By__c,BPA_Updated_Date__c,Cost_Type__c,Effective_End_Date__c,Effective_Start_Date__c,Item_Number__c,Item_Number__r.Item_Number__c,Item_Number__r.Name,Item_Number_IOD_IN__c,Price__c,Quarter__c,Supplier_Number__r.Name,Supplier_Number_IOD_IN__c,Year__c from CD_BPA_Cost__c where ID IN:  idList';
   system.debug(idList);
    system.debug(query + 'query');
     return  Database.getQueryLocator(query);
  }
 
 global void execute(Database.BatchableContext BC, List<CD_BPA_Cost__c> scope)
 {
  insertitemCost = new List<CD_Item_Cost_Details__c>();
  updateitemCost = new List<CD_Item_Cost_Details__c>();
   string tkcrit;
   Decimal tkamount;
   if(month==1 ||month==2 || month==3)
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
   for(CD_BPA_Cost__c bpas : scope)
   {
    string tkDn;
    decimal tkDnAmt=0;
    
 /*   List<CD_Item_Cost_Details__c> costitems =  new List<CD_Item_Cost_Details__c>();
    costitems=[SELECT Id,Name,Award__c,CD_Item_categories__r.Item_Number__r.Item_Number__c,CD_Item_categories__c,CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__r.Name,Cost_Assy_Name__c,Cost_Category__c,Cost_Category_IOD__c,Cost_Type__c,ExternalKey__c,Item_Cost_ID__c,Item_Number__c,Item_Number_IOD__c,Price__c,Quarter__c,Supplier_del__c,SupplierName__c,Supplier_Number_IOD__c,WeightedAverage__c,Year__c FROM CD_Item_Cost_Details__c WHERE Cost_Type__c='LOS'  AND  Item_Number__c=:bpas.Item_Number__c AND Supplier_del__c=:bpas.Supplier_Number__c AND((Quarter__c =:fquat AND Year__c =:fyear) OR (Quarter__c =:squat AND Year__c =:secyear) OR (Quarter__c =:tquat AND Year__c =:tyear) OR (Quarter__c =:fourquat AND Year__c =:fouryear) OR (Quarter__c =:fifthquat AND Year__c =:fifthyear) OR (Quarter__c =:sixthquat AND Year__c =:sixthyear))];
   if(costitems.size()==0)
    { */
      List<CD_Item_Categories__c> itemCats = new List<CD_Item_Categories__c>();
      itemCats=[select Id,Name,Commodity_Code__c,Commodity_Code_IOD_IN__c,Item_Number__r.Item_Number__c,Item_Category_ID__c,Item_Number__c,Item_Number_IOC__c,Item_Number_IOD_IN__c,Item_Status__c,Item_Type__c,Make_Buy_Flag__c,Organization_Code__c,Organization_Code__r.Name,Commodity_Code__r.CD_Category__c,Commodity_Code__r.CD_Category__r.Name,Commodity_Code__r.CD_Category_IOD_OUT__c,Commodity_Code__r.CD_Cost_Category__c,Commodity_Code__r.CD_Cost_Category__r.Name,Commodity_Code__r.CD_Category_Managers__r.Name,Commodity_Code__r.CD_Category_Managers__c,Commodity_Code__r.CD_GCL__c,Commodity_Code__r.CD_GCL__r.Name,Commodity_Code__r.CD_Subcategory1__c,Commodity_Code__r.CD_Subcategory1__r.Name, Commodity_Code__r.CD_Subcategory1_IOD_OUT__c,Commodity_Code__r.CD_Subcategory2__c,Commodity_Code__r.CD_Subcategory2__r.Name,Commodity_Code__r.CD_Subcategory3__c,Commodity_Code__r.CD_Subcategory3__r.Name,Commodity_Code__r.Commodity_Code__c from CD_Item_Categories__c where Item_Number__c=:bpas.Item_Number__c AND Organization_Code__r.Name='GSO' AND Item_Status__c!= '55-Obsolete' LIMIT 1];
      if(itemMap.containsKey(bpas.Item_Number__r.Item_Number__c))
      {
       tkDn=itemMap.get(bpas.Item_Number__r.Item_Number__c).TD_Criteria__c;
       tkDnAmt=Integer.valueOf(itemMap.get(bpas.Item_Number__r.Item_Number__c).TD_Value__c);
      
      }
      if(itemCats[0].Commodity_Code__r.CD_Subcategory3__c!=null )
      {
        if(subCat3Map.containsKey(itemCats[0].Commodity_Code__r.CD_Subcategory3__r.Name) && tkDnAmt==0)
        {
         tkDn=subCat3Map.get(itemCats[0].Commodity_Code__r.CD_Subcategory3__r.Name).TD_Criteria__c;
         tkDnAmt=Integer.valueOf(subCat3Map.get(itemCats[0].Commodity_Code__r.CD_Subcategory3__r.Name).TD_Value__c);
         
        }
      
      
      }
      if(itemCats[0].Commodity_Code__r.CD_Subcategory2__c!=null)
      {
        if(subCat2Map.containsKey(itemCats[0].Commodity_Code__r.CD_Subcategory2__r.Name) && tkDnAmt==0)
        {
         tkDn=subCat2Map.get(itemCats[0].Commodity_Code__r.CD_Subcategory2__r.Name).TD_Criteria__c;
         tkDnAmt=Integer.valueOf(subCat2Map.get(itemCats[0].Commodity_Code__r.CD_Subcategory2__r.Name).TD_Value__c);
         
        }
      
      
      }
       if(itemCats[0].Commodity_Code__r.CD_Subcategory1__c!=null)
      {
        if(subCat1Map.containsKey(itemCats[0].Commodity_Code__r.CD_Subcategory1__r.Name) && tkDnAmt==0)
        {
         tkDn=subCat1Map.get(itemCats[0].Commodity_Code__r.CD_Subcategory1__r.Name).TD_Criteria__c;
         tkDnAmt=Integer.valueOf(subCat1Map.get(itemCats[0].Commodity_Code__r.CD_Subcategory1__r.Name).TD_Value__c);
         
        }
      
      
      }
      
        if(itemCats[0].Commodity_Code__r.CD_Category__c!=null)
      {
        if(catMap.containsKey(itemCats[0].Commodity_Code__r.CD_Category__r.Name) && tkDnAmt==0)
        {
         tkDn=catMap.get(itemCats[0].Commodity_Code__r.CD_Category__r.Name).TD_Criteria__c;
         tkDnAmt=Integer.valueOf(catMap.get(itemCats[0].Commodity_Code__r.CD_Category__r.Name).TD_Value__c);
         
        }
      
      
      }
        if(itemCats[0].Commodity_Code__r.CD_Category_Managers__c!=null)
      {
        if(catMgrMap.containsKey(itemCats[0].Commodity_Code__r.CD_Category_Managers__r.Name) && tkDnAmt==0)
        {
         tkDn=catMgrMap.get(itemCats[0].Commodity_Code__r.CD_Category_Managers__r.Name).TD_Criteria__c;
         tkDnAmt=Integer.valueOf(catMgrMap.get(itemCats[0].Commodity_Code__r.CD_Category_Managers__r.Name).TD_Value__c);
         
        }
      
      
      }
       if(itemCats[0].Commodity_Code__r.CD_GCL__c!=null)
      {
        if(gclMap.containsKey(itemCats[0].Commodity_Code__r.CD_GCL__r.Name) && tkDnAmt==0)
        {
         tkDn=gclMap.get(itemCats[0].Commodity_Code__r.CD_GCL__r.Name).TD_Criteria__c;
         tkDnAmt=Integer.valueOf(gclMap.get(itemCats[0].Commodity_Code__r.CD_GCL__r.Name).TD_Value__c);
         
        }
      
      
      }
      if(tkDn!=null && tkDnAmt!=0)
      {
        firstPrice=bpas.Price__c;
       if(tkDn=='By Amount')
        {
         secPrice=firstPrice+tkDnAmt;
         thirdPrice=secPrice+tkDnAmt;
         fourthPrice=thirdPrice+tkDnAmt;
         fifthPrice=fourthPrice+tkDnAmt;
         sixthPrice=fifthPrice+tkDnAmt;
        }
        if(tkDn=='By Percentage')
        {
         secPrice=firstPrice+((tkDnAmt*firstPrice)/100);
         thirdPrice=secPrice+((tkDnAmt*secPrice)/100);
         fourthPrice=thirdPrice+((tkDnAmt*thirdPrice)/100);
         fifthPrice=fourthPrice+((tkDnAmt*fourthPrice)/100);
         sixthPrice=fifthPrice+((tkDnAmt*fifthPrice)/100);
        }
       
      
      }
      if(tkDn==null || tkDnAmt==0)
      {
      
      firstPrice=bpas.Price__c;
      secPrice=bpas.Price__c;
      thirdPrice=bpas.Price__c;
      fourthPrice=bpas.Price__c;
      fifthPrice=bpas.Price__c;
      sixthPrice=bpas.Price__c;
       
      }
       List<CD_Item_Cost_Details__c> costitems =  new List<CD_Item_Cost_Details__c>();
    costitems=[SELECT Id,Name,Award__c,CD_Item_categories__r.Item_Number__r.Item_Number__c,CD_Item_categories__c,CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__r.Name,Cost_Assy_Name__c,Cost_Category__c,Cost_Category_IOD__c,Cost_Type__c,ExternalKey__c,Item_Cost_ID__c,Item_Number__c,Item_Number_IOD__c,Price__c,Quarter__c,Supplier_del__c,SupplierName__c,Supplier_Number_IOD__c,WeightedAverage__c,Year__c FROM CD_Item_Cost_Details__c WHERE Cost_Type__c='LOS'  AND  Item_Number__c=:bpas.Item_Number__c AND Supplier_del__c=:bpas.Supplier_Number__c AND((Quarter__c =:fquat AND Year__c =:fyear) OR (Quarter__c =:squat AND Year__c =:secyear) OR (Quarter__c =:tquat AND Year__c =:tyear) OR (Quarter__c =:fourquat AND Year__c =:fouryear) OR (Quarter__c =:fifthquat AND Year__c =:fifthyear) OR (Quarter__c =:sixthquat AND Year__c =:sixthyear))];
   if(costitems.size()==0)
    { 
      CD_Item_Cost_Details__c costs1 = new CD_Item_Cost_Details__c();
      CD_Item_Cost_Details__c costs2 = new CD_Item_Cost_Details__c();
      CD_Item_Cost_Details__c costs3 = new CD_Item_Cost_Details__c();
      CD_Item_Cost_Details__c costs4 = new CD_Item_Cost_Details__c();
      CD_Item_Cost_Details__c costs5 = new CD_Item_Cost_Details__c();
      CD_Item_Cost_Details__c costs6 = new CD_Item_Cost_Details__c();
      costs1.Price__c=bpas.Price__c;
         costs1.Quarter__c=fquat;
         costs1.Year__c=fyear;
         costs1.Item_Number__c=bpas.Item_Number__c;
         costs1.CD_Item_categories__c=itemCats[0].Id;
         costs1.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs1.Supplier_del__c=bpas.Supplier_Number__c;
         costs1.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs1.Award__c= bpas.Award__c;
         costs1.CurrencyIsoCode=bpas.CurrencyIsoCode;
         costs2.Price__c=secPrice;
         costs2.Quarter__c=squat;
         costs2.Year__c=secyear;
         costs2.Item_Number__c=bpas.Item_Number__c;
         costs2.CD_Item_categories__c=itemCats[0].Id;
         costs2.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs2.Supplier_del__c=bpas.Supplier_Number__c;
         costs2.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs2.Award__c= bpas.Award__c;
         costs2.CurrencyIsoCode=bpas.CurrencyIsoCode;
         costs3.Price__c=thirdPrice;
         costs3.Quarter__c=tquat;
         costs3.Year__c=tyear;
         costs3.Item_Number__c=bpas.Item_Number__c;
         costs3.CD_Item_categories__c=itemCats[0].Id;
         costs3.CurrencyIsoCode=bpas.CurrencyIsoCode;
         costs3.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs3.Supplier_del__c=bpas.Supplier_Number__c;
         costs3.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs3.Award__c= bpas.Award__c;
         costs4.Price__c=fourthPrice;
         costs4.Quarter__c=fourquat;
         costs4.Year__c=fouryear;
         costs4.Item_Number__c=bpas.Item_Number__c;
         costs4.CD_Item_categories__c=itemCats[0].Id;
         costs4.Cost_Type__c='LOS';
         costs4.CurrencyIsoCode=bpas.CurrencyIsoCode;
         if(bpas.Supplier_Number__c!=null)
         costs4.Supplier_del__c=bpas.Supplier_Number__c;
         costs4.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs4.Award__c= bpas.Award__c;
         costs5.Price__c=fifthPrice;
         costs5.Quarter__c=fifthquat;
         costs5.Year__c=fifthyear;
         costs5.Item_Number__c=bpas.Item_Number__c;
         costs5.CD_Item_categories__c=itemCats[0].Id;
         costs5.Cost_Type__c='LOS';
         costs5.CurrencyIsoCode=bpas.CurrencyIsoCode;
         if(bpas.Supplier_Number__c!=null)
         costs5.Supplier_del__c=bpas.Supplier_Number__c;
         costs5.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs5.Award__c= bpas.Award__c;
         costs6.Price__c=sixthPrice;
         costs6.Quarter__c=sixthquat;
         costs6.Year__c=sixthyear;
         costs6.CurrencyIsoCode=bpas.CurrencyIsoCode;
         costs6.Item_Number__c=bpas.Item_Number__c;
         costs6.CD_Item_categories__c=itemCats[0].Id;
         costs6.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs6.Supplier_del__c=bpas.Supplier_Number__c;
         costs6.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs6.Award__c= bpas.Award__c;
         insertitemCost.add(costs1);
         insertitemCost.add(costs2);
         insertitemCost.add(costs3);
         insertitemCost.add(costs4);
         insertitemCost.add(costs5);
         insertitemCost.add(costs6);
     
     } 
     else
     {
       //updateitemCost.add(bpas);
      if(costitems.size()==6)
      {
        for(CD_Item_Cost_Details__c cst :costitems)
        {
          if(cst.Price__c > bpas.Price__c || cst.Price__c==0)
          {
            cst.Price__c=bpas.Price__c;
            insertitemCost.add(cst);
           
          }
        
        }
       
       
       }
     
     
    }  
   
   }
   
  
   if(insertitemCost.size()>0)
   {
   
   database.upsert(insertitemCost);
   insertitemCost.clear();
   }
 
 
 
 }
  global void finish(Database.BatchableContext BC)
    {
    }
 
 
 
 
 
 
 
 
 }