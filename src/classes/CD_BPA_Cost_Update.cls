/*
*************************************************************************************************
Description:
This  Class is controller for page BPA to LOS COPY Page to build baps award map

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
global class CD_BPA_Cost_Update implements Database.Batchable<sObject>,Database.Stateful
{
 public List<CD_BPA_Cost__c> bpaCost = new List<CD_BPA_Cost__c>();
// public Map<String,List<CD_Item_Cost_Details__c>> catMgrRec = new Map<String,List<CD_Item_Cost_Details__c>>();
// public Map<string,Decimal> bpaMap=new  Map<string,Decimal>();
// public Map<string,string> mgrEmail = new Map<string,string>();
// Public List<CD_Item_Cost_Details__c> updateList = new List<CD_Item_Cost_Details__c>();
// Public List<CD_Item_Cost_Details__c> insertList = new List<CD_Item_Cost_Details__c>();
 //public List<CD_Item_Cost_Details__c> upsertList = new List<CD_Item_Cost_Details__c>();
 //Map<CD_Item_Cost_Details__c,integer> costFlagMap = new Map<CD_Item_Cost_Details__c,integer>();
public Map<string,CD_BPA_Cost__c> lastModDateMap = new Map<string,CD_BPA_Cost__c>();
Public Map<string,List<CD_BPA_Cost__c>> awardBPA = new Map<string,List<CD_BPA_Cost__c>>();
public List<CD_BPA_Cost__c> insertList = new List<CD_BPA_Cost__c>();
 
//public string syear{ get;set; }
//public string squarter{ get;set; }
/*public Decimal firstPrice;
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
public Integer month=SYSTEM.TODAY().MONTH(); */
public Map<String,CD_Cost_TakeDown__c> itemMap= new Map<String,CD_Cost_TakeDown__c>() ;
public Map<String,CD_Cost_TakeDown__c> subCat3Map = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> subCat2Map = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> subCat1Map = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> catMap = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> catMgrMap = new Map<String,CD_Cost_TakeDown__c>();
public Map<String,CD_Cost_TakeDown__c> gclMap = new Map<String,CD_Cost_TakeDown__c>();

public  CD_BPA_Cost_Update(Map<String,CD_Cost_TakeDown__c> itemMaps,Map<String,CD_Cost_TakeDown__c> subCat3Maps,Map<String,CD_Cost_TakeDown__c> subCat2Maps,Map<String,CD_Cost_TakeDown__c> subCat1Maps,Map<String,CD_Cost_TakeDown__c> catMaps, Map<String,CD_Cost_TakeDown__c> catMgrMaps,Map<String,CD_Cost_TakeDown__c> gclMaps ){
Map<String,CD_Cost_TakeDown__c> tkDwnMap= new Map<String,CD_Cost_TakeDown__c>();
itemMap=itemMaps;
subCat3Map=subCat3Maps;
subCat2Map=subCat2Maps;
subCat1Map=subCat1Maps;
catMap=catMaps;
catMgrMap=catMgrMaps;
gclMap=gclMaps;

}
/*public List<CD_Item_Cost_Details__c> upsertListFinal = new List<CD_Item_Cost_Details__c>();
 public class flagCostitem{
 public CD_Item_Cost_Details__c costItem;
 public integer flag;
 public flagCostitem(CD_Item_Cost_Details__c costItemret,integer flags ){
 this.costItem=costItemret;
 this.flag=flags;
 }  
 }*/
 //public List<flagCostitem> costFlagMap = new List<flagCostitem>();
 global Database.QueryLocator start(Database.BatchableContext BC){
 Date dt =  system.Today();
  //Datetime str = Datetime.newInstance(dt.year(),dt.month(),dt.day(),0, 0, 0);
// string str= dt.format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
   // String str = DateTime.now().format('yyyy-MM-dd\'T\'HH:mm:ss\'Z\''); 
     //system.debug('currentquarter= ' +  Quarter +'endQuarter= '+ endQuarter + 'endYear= '+ endYear  + 'quartersnyears');
    // String query = 'select Id,Name,Award__c,BPA_Created_By__c,BPA_Creation_Date__c,BPA_RFQ_No__c,BPA_Updated_By__c,BPA_Updated_Date__c,Cost_Type__c,Effective_End_Date__c,Effective_Start_Date__c,Item_Number__c,Item_Number__r.Name,Item_Number_IOD_IN__c,Price__c,Quarter__c,Supplier_Number__c,Supplier_Number__r.Name,Supplier_Number_IOD_IN__c,Year__c from CD_BPA_Cost__c where Cost_Type__c=\'BPA\'  AND Item_Number__c!=null AND Supplier_Number__c!=null AND Effective_End_Date__c=null AND Award__c=100';
      String query = 'select Id,Name,Award__c,CurrencyIsoCode,Supplier_Number__r.Oracle_Customer_Number__c,Supplier_Number__c,BPA_Created_By__c,BPA_Creation_Date__c,BPA_RFQ_No__c,BPA_Updated_By__c,BPA_Updated_Date__c,Cost_Type__c,Effective_End_Date__c,Effective_Start_Date__c,Item_Number__c,Item_Number__r.Item_Number__c,Item_Number__r.Name,Item_Number_IOD_IN__c,Price__c,Quarter__c,Supplier_Number__r.Name,Supplier_Number_IOD_IN__c,Year__c from CD_BPA_Cost__c where Cost_Type__c=\'BPA\'  AND Item_Number__c!=null AND Supplier_Number__c!=null AND (((Effective_Start_Date__c <  :dt) AND  (Effective_End_Date__c > :dt) )OR ((Effective_Start_Date__c <  :dt  ) AND (Effective_End_Date__c=null))) AND Award__c!=null AND Award__c!=1 AND Award__c!=99 AND Effective_Start_Date__c!=null ORDER BY Item_Number_IOD_IN__c';
     system.debug(query + 'query');
     return Database.getQueryLocator(query);
  } 
 global void execute(Database.BatchableContext BC, List<CD_BPA_Cost__c> scope)
 {
 
    
  /* if(month==1 ||month==2 || month==3)
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
    insertList.clear();
  updateList.clear();
  upsertList.clear();
   for(CD_BPA_Cost__c bpas:scope)
    {
     Map<Id , List<CD_BPA_Cost__c>> awardBpa = new Map<Id , List<CD_BPA_Cost__c>>();
     List<CD_Item_Cost_Details__c> costitems =  new List<CD_Item_Cost_Details__c>();
     costitems = [SELECT Id,Name,Award__c,CD_Item_categories__r.Item_Number__r.Item_Number__c,CD_Item_categories__c,CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__r.Name,Cost_Assy_Name__c,Cost_Category__c,Cost_Category_IOD__c,Cost_Type__c,ExternalKey__c,Item_Cost_ID__c,Item_Number__c,Item_Number_IOD__c,Price__c,Quarter__c,Supplier_del__c,SupplierName__c,Supplier_Number_IOD__c,WeightedAverage__c,Year__c FROM CD_Item_Cost_Details__c WHERE Cost_Type__c='LOS'  AND  Item_Number__c=:bpas.Item_Number__c AND Supplier_del__c=:bpas.Supplier_Number__c AND((Quarter__c =:fquat AND Year__c =:fyear) OR (Quarter__c =:squat AND Year__c =:secyear) OR (Quarter__c =:tquat AND Year__c =:tyear) OR (Quarter__c =:fourquat AND Year__c =:fouryear) OR (Quarter__c =:fifthquat AND Year__c =:fifthyear) OR (Quarter__c =:sixthquat AND Year__c =:sixthyear))];
     if(costitems.size()==0)
     {
      List<CD_Item_Categories__c> itemCats = new List<CD_Item_Categories__c>();
      itemCats=[select Id,Name,Commodity_Code__c,Commodity_Code_IOD_IN__c,Item_Category_ID__c,Item_Number__c,Item_Number_IOC__c,Item_Number_IOD_IN__c,Item_Status__c,Item_Type__c,Make_Buy_Flag__c,Organization_Code__c,Organization_Code_IOD_IN__c,Commodity_Code__r.CD_Category__c,Commodity_Code__r.CD_Category_IOD_OUT__c,Commodity_Code__r.CD_Cost_Category__c,Commodity_Code__r.CD_Cost_Category_IOD_OUT__c,Commodity_Code__r.CD_Category_Manager_IOD_OUT__c,Commodity_Code__r.CD_Category_Managers__c,Commodity_Code__r.CD_GCL__c,Commodity_Code__r.CD_GCL_IOD_OUT__c,Commodity_Code__r.CD_Subcategory1__c,Commodity_Code__r.CD_Subcategory1_IOD_OUT__c,Commodity_Code__r.CD_Subcategory2__c,Commodity_Code__r.CD_Subcategory2_IOD_OUT__c,Commodity_Code__r.CD_Subcategory3__c,Commodity_Code__r.CD_Subcategory3__r.Name,Commodity_Code__r.Commodity_Code__c from CD_Item_Categories__c where Item_Number__c=:bpas.Item_Number__c AND Organization_Code_IOD_IN__c='GSO' LIMIT 1];
      if(itemCats!=null && itemCats.size()>0)
      { 
        List<CD_Cost_TakeDown__c> tkDn =  new List<CD_Cost_TakeDown__c>();
        //tkDn=[select Id,Name,CD_Category__c,CD_Category_Manager__c,CD_ExternalKey__c,CD_Item_categories__c,CD_Items__c,CD_SubCategory1__c,CD_Subcategory2__c,CD_Subcategory3__c,CD_GCL__c,TD_Criteria__c,TD_Value__c from CD_Cost_TakeDown__c where CD_Items__c=:bpas.Item_Number__c];
        if(tkDn.size()==0)
        {
        // tkDn=[select Id,Name,CD_Category__c,CD_Category_Manager__c,CD_ExternalKey__c,CD_Item_categories__c,CD_Items__c,CD_SubCategory1__c,CD_Subcategory2__c,CD_Subcategory3__c,CD_GCL__c,TD_Criteria__c,TD_Value__c from CD_Cost_TakeDown__c where CD_Subcategory3__c=:itemCats[0].Commodity_Code__r.CD_Subcategory3__c];
        
        }
        if(tkDn.size()==0)
        {
        // tkDn=[select Id,Name,CD_Category__c,CD_Category_Manager__c,CD_ExternalKey__c,CD_Item_categories__c,CD_Items__c,CD_SubCategory1__c,CD_Subcategory2__c,CD_Subcategory3__c,CD_GCL__c,TD_Criteria__c,TD_Value__c from CD_Cost_TakeDown__c where CD_Subcategory2__c=:itemCats[0].Commodity_Code__r.CD_Subcategory2__c];
        
        }
         if(tkDn.size()==0)
        {
        // tkDn=[select Id,Name,CD_Category__c,CD_Category_Manager__c,CD_ExternalKey__c,CD_Item_categories__c,CD_Items__c,CD_SubCategory1__c,CD_Subcategory2__c,CD_Subcategory3__c,CD_GCL__c,TD_Criteria__c,TD_Value__c from CD_Cost_TakeDown__c where CD_Subcategory1__c=:itemCats[0].Commodity_Code__r.CD_Subcategory1__c];
        
        }
         if(tkDn.size()==0)
        {
        // tkDn=[select Id,Name,CD_Category__c,CD_Category_Manager__c,CD_ExternalKey__c,CD_Item_categories__c,CD_Items__c,CD_SubCategory1__c,CD_Subcategory2__c,CD_Subcategory3__c,CD_GCL__c,TD_Criteria__c,TD_Value__c from CD_Cost_TakeDown__c where CD_Category__c=:itemCats[0].Commodity_Code__r.CD_Category__c];
        
        }
         if(tkDn.size()==0)
        {
       //  tkDn=[select Id,Name,CD_Category__c,CD_Category_Manager__c,CD_ExternalKey__c,CD_Item_categories__c,CD_Items__c,CD_SubCategory1__c,CD_Subcategory2__c,CD_Subcategory3__c,CD_GCL__c,TD_Criteria__c,TD_Value__c from CD_Cost_TakeDown__c where CD_GCL__c=:itemCats[0].Commodity_Code__r.CD_GCL__c];
        
        }
         if(tkDn.size()==0)
        {
        // tkDn=[select Id,Name,CD_Category__c,CD_Category_Manager__c,CD_ExternalKey__c,CD_Item_categories__c,CD_Items__c,CD_SubCategory1__c,CD_Subcategory2__c,CD_Subcategory3__c,CD_GCL__c,TD_Criteria__c,TD_Value__c from CD_Cost_TakeDown__c where CD_Category_Manager__c=:itemCats[0].Commodity_Code__r.CD_Category_Managers__c];
        
        }
      
       if(tkDn.size()>0)
       {
         
         CD_Item_Cost_Details__c costs = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs1 = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs2 = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs3 = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs4 = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs5 = new CD_Item_Cost_Details__c();
         firstPrice=bpas.Price__c;
         costs.Price__c=bpas.Price__c;
         costs.Quarter__c=fquat;
         costs.Year__c=fyear;
         costs.Item_Number__c=bpas.Item_Number__c;
         costs.CD_Item_categories__c=itemCats[0].Id;
         costs.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs.Supplier_del__c=bpas.Supplier_Number__c;
         costs.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs.Award__c= bpas.Award__c;
         if(tkDn[0].TD_Criteria__c == 'By Amount')
         {
          secPrice=firstPrice+Integer.valueOf(tkDn[0].TD_Value__c);
          thirdPrice=secPrice+Integer.valueOf(tkDn[0].TD_Value__c);
          fourthPrice=thirdPrice+Integer.valueOf(tkDn[0].TD_Value__c);
          fifthPrice=fourthPrice+Integer.valueOf(tkDn[0].TD_Value__c);
          sixthPrice=fifthPrice+Integer.valueOf(tkDn[0].TD_Value__c);
         }
          if(tkDn[0].TD_Criteria__c == 'By Percentage')
         {
          secPrice=firstPrice+(Integer.valueOf(tkDn[0].TD_Value__c)*firstPrice/100);
          thirdPrice=secPrice+(Integer.valueOf(tkDn[0].TD_Value__c)*firstPrice/100);
          fourthPrice=thirdPrice+(Integer.valueOf(tkDn[0].TD_Value__c)*firstPrice/100);
          fifthPrice=fourthPrice+(Integer.valueOf(tkDn[0].TD_Value__c)*firstPrice/100);
          sixthPrice=fifthPrice+(Integer.valueOf(tkDn[0].TD_Value__c)*firstPrice/100);
         }
         costs1.Price__c=secPrice;
         costs1.Quarter__c=squat;
         costs1.Year__c=secyear;
         costs1.Item_Number__c=bpas.Item_Number__c;
         costs1.CD_Item_categories__c=itemCats[0].Id;
         costs1.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs1.Supplier_del__c=bpas.Supplier_Number__c;
         costs1.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs1.Award__c= bpas.Award__c;
         
         costs2.Price__c=thirdPrice;
         costs2.Quarter__c=tquat;
         costs2.Year__c=tyear;
         costs2.Item_Number__c=bpas.Item_Number__c;
         costs2.CD_Item_categories__c=itemCats[0].Id;
         costs2.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs2.Supplier_del__c=bpas.Supplier_Number__c;
         costs2.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs2.Award__c= bpas.Award__c;
         
         costs3.Price__c=fourthPrice;
         costs3.Quarter__c=fourquat;
         costs3.Year__c=fouryear;
         costs3.Item_Number__c=bpas.Item_Number__c;
         costs3.CD_Item_categories__c=itemCats[0].Id;
         costs3.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs3.Supplier_del__c=bpas.Supplier_Number__c;
         costs3.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs3.Award__c= bpas.Award__c;
         
         costs4.Price__c=fifthPrice;
         costs4.Quarter__c=fifthquat;
         costs4.Year__c=fifthyear;
         costs4.Item_Number__c=bpas.Item_Number__c;
         costs4.CD_Item_categories__c=itemCats[0].Id;
         costs4.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs4.Supplier_del__c=bpas.Supplier_Number__c;
         costs4.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs4.Award__c= bpas.Award__c;
         
         costs5.Price__c=sixthPrice;
         costs5.Quarter__c=sixthquat;
         costs5.Year__c=sixthyear;
         costs5.Item_Number__c=bpas.Item_Number__c;
         costs5.CD_Item_categories__c=itemCats[0].Id;
         costs5.Cost_Type__c='LOS';
         if(bpas.Supplier_Number__c!=null)
         costs5.Supplier_del__c=bpas.Supplier_Number__c;
         costs5.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs5.Award__c= bpas.Award__c;
         
         insertList.add(costs);
         insertList.add(costs1);
         insertList.add(costs2);
         insertList.add(costs3);
         insertList.add(costs4);
         insertList.add(costs5);
       }
       else
        {
         
         CD_Item_Cost_Details__c costs = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs1 = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs2 = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs3 = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs4 = new CD_Item_Cost_Details__c();
         CD_Item_Cost_Details__c costs5 = new CD_Item_Cost_Details__c();
         costs.Price__c=bpas.Price__c;
         costs.Quarter__c=fquat;
         costs.Year__c=fyear;
         costs.Item_Number__c=bpas.Item_Number__c;
         costs.CD_Item_categories__c=itemCats[0].Id;
         costs.Cost_Type__c='LOS';
          if(bpas.Supplier_Number__c!=null)
         costs.Supplier_del__c=bpas.Supplier_Number__c;
         costs.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs.Award__c= bpas.Award__c;
         
         costs1.Price__c=bpas.Price__c;
         costs1.Quarter__c=squat;
         costs1.Year__c=secyear;
         costs1.Item_Number__c=bpas.Item_Number__c;
         costs1.CD_Item_categories__c=itemCats[0].Id;
         costs1.Cost_Type__c='LOS';
          if(bpas.Supplier_Number__c!=null)
         costs1.Supplier_del__c=bpas.Supplier_Number__c;
         costs1.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs1.Award__c= bpas.Award__c;
        
         costs2.Price__c=bpas.Price__c;
         costs2.Quarter__c=tquat;
         costs2.Year__c=tyear;
         costs2.Item_Number__c=bpas.Item_Number__c;
         costs2.CD_Item_categories__c=itemCats[0].Id;
         costs2.Cost_Type__c='LOS';
          if(bpas.Supplier_Number__c!=null)
         costs2.Supplier_del__c=bpas.Supplier_Number__c;
         costs2.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs2.Award__c= bpas.Award__c;
      
         costs3.Price__c=bpas.Price__c;
         costs3.Quarter__c=fourquat;
         costs3.Year__c=fouryear;
         costs3.Item_Number__c=bpas.Item_Number__c;
         costs3.CD_Item_categories__c=itemCats[0].Id;
         costs3.Cost_Type__c='LOS';
          if(bpas.Supplier_Number__c!=null)
         costs3.Supplier_del__c=bpas.Supplier_Number__c;
         costs3.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs3.Award__c= bpas.Award__c;
         
         costs4.Price__c=bpas.Price__c;
         costs4.Quarter__c=fifthquat;
         costs4.Year__c=fifthyear;
         costs4.Item_Number__c=bpas.Item_Number__c;
         costs4.CD_Item_categories__c=itemCats[0].Id;
         costs4.Cost_Type__c='LOS';
          if(bpas.Supplier_Number__c!=null)
         costs4.Supplier_del__c=bpas.Supplier_Number__c;
         costs4.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs4.Award__c= bpas.Award__c;
         
         costs5.Price__c=bpas.Price__c;
         costs5.Quarter__c=sixthquat;
         costs5.Year__c=sixthyear;
         costs5.Item_Number__c=bpas.Item_Number__c;
         costs5.CD_Item_categories__c=itemCats[0].Id;
         costs5.Cost_Type__c='LOS';
          if(bpas.Supplier_Number__c!=null)
         costs5.Supplier_del__c=bpas.Supplier_Number__c;
         costs5.Cost_Category__c=itemCats[0].Commodity_Code__r.CD_Cost_Category__c;
         costs5.Award__c= bpas.Award__c;
         insertList.add(costs);
         insertList.add(costs1);
         insertList.add(costs2);
         insertList.add(costs3);
         insertList.add(costs4);
         insertList.add(costs5);
        
       
        
        }
      }
      
     }
    
    else
    {
     for(CD_Item_Cost_Details__c itemCost : costitems)
     {
      if(itemCost.Price__c > bpas.Price__c || itemCost.Price__c==0)
      {
       itemCost.Price__c=bpas.Price__c;
       updateList.add(itemCost);
      }
      
     
     }
    
    
    
    }
    
    
    }   
     
    
    if(updateList.size()>0)
    {       
    upsertList.addAll(updateList);
    }
    if(insertList.size()>0)
    {
     upsertList.addAll(insertList);
    
    }
    if(upsertList.size()>0)
    {
     Database.upsert(upsertList);    
    
    }
  upsertListFinal.clear();
  upsertListFinal.addAll(upsertList);
  insertList.clear();
  updateList.clear();
  upsertList.clear();  */
  
  //Date ReportDtae;
  for(CD_BPA_Cost__c bpaCost : scope)
  {
   system.debug(bpaCost + 'bpaCost scope');
   string uniquekey;
   uniqueKey=bpaCost.Item_Number__r.Item_Number__c+bpaCost.Supplier_Number__r.Oracle_Customer_Number__c+bpaCost.CurrencyIsoCode;
   system.debug(uniqueKey + 'uniqueKey in craeting map');
  //for(String bpa:lastModDateMap.keySet())
  //{
   if(lastModDateMap.containsKey(uniqueKey))
   {
     if(lastModDateMap.get(uniqueKey).BPA_Updated_Date__c < bpaCost.BPA_Updated_Date__c)
     {
       system.debug('if map contains unique key scope'+bpaCost);
       system.debug('if map contains uniquekey value , key' + lastModDateMap.get(uniqueKey)+'key' +uniqueKey);
       lastModDateMap.put(uniqueKey,bpaCost);
     
     }
   
   
   }
   
  else
  {
   system.debug('if map doe not contains unique key');
    lastModDateMap.put(uniqueKey,bpaCost);
  
  }
 
  //}
  
  }
  
  system.debug(lastModDateMap.size() +'in execute methodlast date modemap');
 }
 
 
  global void finish(Database.BatchableContext BC)
    {
    /* List<CD_Category_Managers__c> catMgrs=[select Id,Name from CD_Category_Managers__c];
     system.debug('in exceute method' + catMgrs);
     string[] mgrsplit = new string[]{};
     Messaging.SingleEmailMessage[] sendEmailList = new Messaging.SingleEmailMessage[]{};
     string msgBody;
     string salute;
     for(CD_Category_Managers__c mgr : catMgrs)
     {
       List<User> mgrUser = new List<User>();
       List<CD_Item_Cost_Details__c> mgrRec = new List<CD_Item_Cost_Details__c>();
       mgrsplit=mgr.Name.split(' ');
    
       if(mgrsplit.size()>1)
       mgrUser=[select id,Name,Email from User where FirstName LIKE :mgrsplit[0] AND LastName LIKE :mgrsplit[1]];
      if(mgrsplit.size()==1)
      mgrUser=[select id,Name,Email from User where FirstName LIKE :mgrsplit[0]];
      if (mgrUser==null  )
         mgrUser=[select id,Name,Email from User where FirstName LIKE :mgrsplit[1] AND LastName LIKE :mgrsplit[0]];
      if (mgrUser.size()>0)
          mgrEmail.put(mgr.Name,mgrUser[0].Email);
      for(CD_Item_Cost_Details__c costItems:upsertListFinal)
      {
     
        if(mgr.Name==costItems.CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__r.Name )
        {
         system.debug(costItems.CD_Item_categories__r.Commodity_Code__r.CD_Category_Managers__r.Name + 'in if itemcostmgr');
         mgrRec.add(costItems);
        
        }
        
      }
     
      
      if(mgrRec.size()>0)
       catMgrRec.put( mgr.Name, mgrRec);
       
     }   
     //system.debug(catMgrRec+'catMgrRec++++');
    
      
      if(catMgrRec.size()>0)
     { 
      for(string mgr : catMgrRec.keyset())
      { 
        string dateString = 'Report Date:' + System.now().format('EEEE, MMMM d, yyyy');
        salute='Dear'+' '+mgr+','+'<br/>'+'<br/>'+'<html><body>The following LOS Costs are updated with BPA Cost.</html></body>';
        string pdfContent;
    
       pdfContent='<table border="1px" border-collapse:collapse bordercolor="#000000" style="background-color:#FFFFFF; display: inline; width:25%"  cellpadding="3" cellspacing="5" >';
        pdfContent=pdfContent+'<tr><th>Cost Type</th><th>Item Number</th><th>Supplier Name</th><th>Cost Category</th><th>Quarter</th><th>Year</th><th>Price</th><th>Award</th></tr>';
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();  
        message.setSubject('Cost Maintenance - Updated LOS with BPA Cost Report');
        message.setSaveAsActivity(false);
        for(CD_Item_Cost_Details__c csems : catMgrRec.get(mgr))
        {
         //msgBody+=csems;
             
                pdfContent += '<tr>';
                pdfContent += '<td valign="top" >'+csems.Cost_Type__c+'</td>';
                pdfContent += '<td valign="top" >'+csems.Item_Number_IOD__c+'</td>'; 
                pdfContent += '<td valign="top" >'+csems.SupplierName__c+'</td>'; 
                pdfContent += '<td valign="top" >'+csems.Cost_Category_IOD__c+'</td>'; 
                pdfContent += '<td valign="top" >'+csems.Quarter__c+'</td>'; 
                pdfContent += '<td valign="top" >'+csems.Year__c+'</td>'; 
                pdfContent += '<td valign="top" >'+csems.Price__c+'</td>'; 
                pdfContent += '<td valign="top" >'+csems.Award__c+'</td>'; 
                pdfContent += '</tr>';        
        
       
        }
        pdfContent = pdfContent + '</table>';
       // pdfContent = pdfContent + '</BODY></HTML>';
        msgBody=pdfContent;
        system.debug(mgrEmail.get(mgr) + 'mgrEmail.get(mgr)+++');
        system.debug(msgBody);
        message.setHtmlBody(dateString+salute+msgBody);
        message.setToAddresses( new String[] {mgrEmail.get(mgr)});
        message.setTargetObjectId(UserInfo.getUserId());
        sendEmailList.add(message);     
          
      }
       Messaging.sendEmail(sendEmailList); 
     
     }  */
     
     system.debug(lastModDateMap.size() +'in finish method last date modemap');
     
        for(String bpas: lastModDateMap.keySet())
      {
         string extKey=lastModDateMap.get(bpas).Item_number__r.Item_number__c+lastModDateMap.get(bpas).CurrencyIsoCode;
         if(awardBPA.containsKey(extKey))
         {
           awardBPA.get(extKey).add(lastModDateMap.get(bpas));
                  
         }
         else
         {
          List<CD_BPA_Cost__c> bpaList= new List<CD_BPA_Cost__c>();
          bpaList.add(lastModDateMap.get(bpas));
          awardBPA.put((extKey),bpaList);
         
         
         }
      
      
      }
      
    for(string s:awardBPA.keySet())
    {
     List<CD_BPA_Cost__c> bpaLists= new List<CD_BPA_Cost__c>();
     bpaLists=awardBPA.get(s);
     decimal bpaAward=0;
     for(CD_BPA_Cost__c bpa:bpaLists)
     {
       bpaAward+=bpa.Award__c;
       
     
     }
      
      if(bpaAward==100)
      {
        insertList.addAll(bpaLists);
    
    
      }
    
    
    }
   
  system.debug(lastModDateMap.size() + 'before calling batch lastModDateMap');
  system.debug(awardBPA.size() + 'before calling batch awardBPA');
  system.debug(insertList.size() + 'before calling batch insertList');
  CD_BPA_Cost_Update_LOS batch = new CD_BPA_Cost_Update_LOS(itemMap,subCat3Map,subCat2Map,subCat1Map,catMap,catMgrMap,gclMap,lastModDateMap,awardBPA,insertList);
     Database.executeBatch(batch,50);
    
    }
}