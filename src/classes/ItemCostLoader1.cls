/*
*************************************************************************************************
Description:
This  Class is controller for page Itemcostupload page

Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
global class ItemCostLoader1
{ public String nameFile{get;set;}
  //public string setAttchBody{get;set;}
  public Blob csvFile{get;set;}  
  public boolean display{get;set;}
  public Integer eQuarter;
  public Integer eYear;
  public Integer fquat;
  public Integer squat;
  public Integer tquat;
  public Integer fourquat;
  public Integer  fifthquat;
  public Integer  sixthquat;
  public Integer fyear;
  public Integer secyear;
  public Integer tyear;
  public Integer fouryear;
  public Integer fifthyear;
  public Integer sixthyear;
 // public boolean records{get;set;}
  public string errMsgs{get;set;}
  
  Map<integer,CD_Item_Cost_Details__c> costItemMap = new Map<integer,CD_Item_Cost_Details__c>();
  
   List<CD_Item_Cost_Details__c> itemCostUpsert=new List<CD_Item_Cost_Details__c>();
   List<CD_Item_Cost_Details__c> itemCostUpsertFinal=new List<CD_Item_Cost_Details__c>();
   public  Map<string,Id> extKeyMap= new Map<string,Id>(); 
   public string  itemName ;
   public class errorwrapper{
    public CD_Item_Cost_Details__c costItem{get;set;}
    public string errorMsg{get;set;}
        public errorwrapper(CD_Item_Cost_Details__c costItemret,string errorMs )
        {
         
          this.costItem=costItemret;
          this.errorMsg=errorMs;
         
         }
         
     }
  public  List<errorwrapper> errordetails=new List<errorwrapper>();    
  public  void createmaps(List<List<String>> csvRecords){ 
  //system.debug('in createmaps');
  List<List<String>> csvrecs = new  List<List<String>>();
  csvrecs = csvRecords;
  CD_ItemNumberCon itembatch =  new CD_ItemNumberCon(csvrecs);
  Database.ExecuteBatch(itembatch,500);
  } 
  public  void  createItemMap(Map<string,Id> itemMapinput,List<List<String>> csvinput ,Map<Id,String> itemNumId)
  {
   List<List<String>> csvrec = new  List<List<String>>();  
   Map<string,Id> itemMap= new Map<string,Id>();
   Map<Id,string> itemIdMap= new Map<Id,string>();
   itemMap=itemMapinput;     
   csvrec=csvinput;
   itemIdMap=itemNumId;
   CD_SupplierNumberCon suppBatch = new CD_SupplierNumberCon(itemMap,csvrec,itemIdMap);
   Database.ExecuteBatch(suppBatch,500);
  }
  public  void  createSuppMap(Map<string,Id> suppMapinput,Map<string,Id> iteminput,List<List<String>> csvip,Map<Id,String> itemIdNum,Map<Id,String> suppIdnumMAp)
  {
    Map<string,Id> itemnum = new Map<string,Id>();
    List<List<String>> csvr1 = new  List<List<String>>();  
    Map<string,Id> suppMap= new Map<string,Id>();
    Map<Id,String> itemIdNumMAp = new Map<Id,String>();
    Map<Id,String> supIdNumMAp = new Map<Id,String>();
    suppMap=suppMapinput;     
    csvr1 =  csvip;   
    itemnum=iteminput;
    itemIdNumMAp=itemIdNum;
    supIdNumMAp=suppIdnumMAp;
   CD_ExtKeyNumberCon extkeyBatch =  new  CD_ExtKeyNumberCon(suppMap,itemnum,csvip,itemIdNumMAp,supIdNumMAp);
    Database.ExecuteBatch(extkeyBatch,500);   
  
  }
 
  public Pagereference ReadFile()
  {
   if(csvFile!=null && csvFile.size()>0  )
    {
      
      nameFile=csvFile.toString();  
      if(nameFile.contains('Instructions to follow before Uploading CSV into the system:') && nameFile.contains('Please note that only columns A to Q i.e. columns Cost Type to All the quarters costs and awards  are editable.') && nameFile.contains('Please do not enter comma in any of the editable i.e. columns from A to Q columns.') && nameFile.contains('Please do not use formulas in any of the editable columns.')&& nameFile.contains('Please put a zero in a number column which you do not wish to enter and a blank in the text field you do not wish to enter.')&& nameFile.contains('Award(%)-Cost are number columns.Rest of the fields are text fields.')&& nameFile.contains('Do not delete the above instructions before uploading into the system.If deleted file will be rejected by the system.') && nameFile.contains('Do not delete the headers of the columns.') && nameFile.contains('Cost Type') && nameFile.contains('Q3-'))
     {
      
       display=true;  
       CD_DataConstructor batch = new  CD_DataConstructor(nameFile);  
       database.executeBatch(batch,1000); 
     }
     else{
     ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'The file was not processed as the instructions part of the file was modified or deleted.Please follow the instructions given in the file and do not delete or modify them before upload...!');
     ApexPages.addMessage(errormsg);
     }
    } 
    else
    {
     ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'Please select a file to upload...!');
     ApexPages.addMessage(errormsg);
   
    }
   return null;    
  
  }
 public void createObjectData(List<List<String>> csvRows,Map<string,Id> suppinput,Map<string,Id> iteminput,Map<string,Id> extKey,Map<String ,Set<Decimal>> awardKey ,Map<Id,String> itemIdKey,Map<Id,String> suppIdNumMap){
  
  if(itemCostUpsert.size()>0)
   {
    itemCostUpsert.clear();
    errordetails.clear();
    
   }
   string itemNum;
   string SupplierNum;
   string itemNumber;
   string costCatgryName;
   

  //system.debug('csvRecords' + csvRows.size());
  //system.debug('itemMap' + iteminput.size());
  //system.debug('suppMap' + suppinput.size());
  //system.debug('extKeyMap' + extKey.size());
  List<List<String>> csvRecords = new List<List<String>>();
  Map<string,Id> suppNumMap =  new Map<string,Id>();
  Map<string,Id> itemNumMap = new Map<string,Id>();
  Map<string,Id> extKeyMap = new Map<string,Id>();
  Map<Id,String> itemIdNumMap = new Map<Id,String>();
  Map<Id,String> supIdNumMap = new Map<Id,String>();
  Map<String,Id> costCatName = new Map<String,id>();
  Map<Id,String> costCatIdNameMap = new Map<Id,String>();
  Map<String ,Set<Decimal>> awardMap = new Map<String ,Set<Decimal>>();
  List<CD_Cost_Category__c> costCat =new List<CD_Cost_Category__c>();
  costCat=[select id,Name from CD_Cost_Category__c ] ;    
    for(CD_Cost_Category__c ccat:costCat)
    {   
     costCatName.put(ccat.Name,ccat.id);
     costCatIdNameMap.put(ccat.id,ccat.Name);
    } 
   csvRecords=csvRows;
   suppNumMap=suppinput;  
   itemNumMap=iteminput;
   extKeyMap=extKey;
   awardMap=awardKey;
   itemIdNumMap=itemIdKey;
   supIdNumMap=suppIdNumMap;
   string header1;
   string header2;
   boolean flag=true;
 
 
    
 
  try{
  Set<CD_Item_Cost_Details__c> errorSet = new Set<CD_Item_Cost_Details__c>();
   for(integer i=0;i<csvRecords.size();i++)
   {
    ////system.debug(i+ 'value of i');
    List<String> rows = new List<String>();
   // CD_Item_Cost_Details__c cnt= new CD_Item_Cost_Details__c();
    //String[] rows = new String[]{};
    
    if(i<=12)
    {
     rows=csvRecords[i];
     if(i==11)
     {
      string q1y=rows[5];
      string q2y=rows[7];
      string q3y=rows[9];
      string q4y=rows[11];
      string q5y=rows[13];
      string q6y=rows[15];
      if(q1y!=null && q2y!=null && q3y!=null&& q4y!=null&& q5y!=null&& q6y!=null)
      {
       fquat =Integer.valueof(q1y.substring(1,2));
       fyear =Integer.valueof(q1y.substring(3)); 
       squat = Integer.valueof(q2y.substring(1,2));
       secyear =Integer.valueof(q2y.substring(3)); 
       tquat = Integer.valueof(q3y.substring(1,2));
       tyear =Integer.valueof(q3y.substring(3)); 
       fourquat = Integer.valueof(q4y.substring(1,2));
       fouryear =Integer.valueof(q4y.substring(3)); 
       fifthquat = Integer.valueof(q5y.substring(1,2));
       fifthyear =Integer.valueof(q5y.substring(3)); 
       sixthquat = Integer.valueof(q6y.substring(1,2));
       sixthyear =Integer.valueof(q6y.substring(3)); 
      
      
      
      }
     
     //system.debug('q1='+ fquat + 'y1='+ fyear + 'q2=' + squat + 'y2=' + secyear + 'q3=' + tquat + 'y3=' + tyear + 'q4=' + fourquat + 'y4=' + fouryear  );
     //system.debug('q5='+ fifthquat + 'y5='+ fifthyear + 'q6=' + sixthquat + 'y6=' + sixthyear );
     }
     //system.debug(rows + 'in headers');
    }
    
     
    else 
    {
    rows=csvRecords[i];
    //rows = rows.split(',');
    //system.debug('in else' + rows);
   
    for(integer j=0 ; j<=5 ;j++)
    {
     CD_Item_Cost_Details__c cnt= new CD_Item_Cost_Details__c();
    try{
   
    if( j==0)
    {
     //system.debug('in j=0' + fquat + fyear + rows[6].trim() + rows[5].trim());
     
     
     if(rows[6].trim()!=null && rows[6].trim()!='')
     {
       cnt.Award__c=integer.valueof(rows[6].trim());
       cnt.Quarter__c=fquat;
       cnt.Year__c=fyear ;
       if(rows[0].trim()!=null && rows[0].trim()!='' )
        cnt.Cost_Type__c= rows[0].trim();
        itemNumber='';
    
       if(rows[1].trim()!=null && rows[1].trim()!='')
       { itemNumber='';
        Id costItemId;
          itemnum=rows[1].trim();
        if(rows[1].trim().length()>1)
        {
         if(itemnum.contains('\''))
        {
          string [] itemsplitter = new string []{};
          itemsplitter=itemnum.split('\'');
          if(itemsplitter.size()==2)
          costItemId =itemNumMap.get(itemsplitter[1]);
          if(costItemId!=null)
          cnt.CD_Item_categories__c=costItemId;   
         itemNumber=itemsplitter[1];  
         }
         else
         {
           costItemId =itemNumMap.get(rows[1].trim());
            if(costItemId!=null)
          cnt.CD_Item_categories__c=costItemId;   
         itemNumber=rows[1].trim(); 
         }
        }
        }  
          SupplierNum='';
         if(rows[2].trim()!=null && rows[2].trim()!='')
       {
         SupplierNum='';
         Id accId;
         string supnum=rows[2].trim();
         if(rows[2].trim().length()>1)
         {
             if(supnum.contains('\''))
             {
                 string [] supsplitter = new string []{};
                 supsplitter=supnum.split('\'');
                 if(supsplitter.size()==2)
                 accId=suppNumMap.get(supsplitter[1]);
                 if(accId!=null)
                 cnt.Supplier_del__c=accId;
                 SupplierNum=supsplitter[1];
             }
             else
             {
              accId=suppNumMap.get(rows[2].trim());
              if(accId!=null)
                 cnt.Supplier_del__c=accId;
                 SupplierNum=rows[2].trim();
             
             }
         }
        }
       if( rows[3].trim()!=null && rows[3].trim()!='')
        {
         id costCatId= costCatName.get(rows[3].trim());
         if(costCatId!=null )
         cnt.Cost_Category__c=costCatId;
         costCatgryName=rows[3].trim();
        }
         if(rows[4].trim()!=null && rows[4].trim()!='')
        {
         cnt.CurrencyIsoCode=rows[4].trim();
        }
        }
         else
         {cnt=null;}
         
         if(rows[5].trim()!=null && rows[5].trim()!='')
         cnt.Price__c=decimal.valueOf(rows[5].trim());
         else
         {cnt=null;}
     
        } 
     if( j==1)
    {
     //system.debug('in j=1' + squat + secyear + rows[8].trim() + rows[7].trim());
    
     if(rows[8].trim()!=null && rows[8].trim()!='')
     {
      cnt.Award__c=integer.valueof(rows[8].trim());
      cnt.Quarter__c=squat;
      cnt.Year__c=secyear;
      if(rows[0].trim()!=null && rows[0].trim()!='' )
        cnt.Cost_Type__c= rows[0].trim();
        itemNumber='';
    
       if(rows[1].trim()!=null && rows[1].trim()!='')
       { itemNumber='';
        Id costItemId;
          itemnum=rows[1].trim();
        if(rows[1].trim().length()>1)
        {
         if(itemnum.contains('\''))
        {
          string [] itemsplitter = new string []{};
          itemsplitter=itemnum.split('\'');
          if(itemsplitter.size()==2)
          costItemId =itemNumMap.get(itemsplitter[1]);
          if(costItemId!=null)
          cnt.CD_Item_categories__c=costItemId;   
         itemNumber=itemsplitter[1];  
         }
        }
        }  
          SupplierNum='';
         if(rows[2].trim()!=null && rows[2].trim()!='')
       {
         SupplierNum='';
         Id accId;
         string supnum=rows[2].trim();
         if(rows[2].trim().length()>1)
         {
             if(supnum.contains('\''))
             {
                 string [] supsplitter = new string []{};
                 supsplitter=supnum.split('\'');
                 if(supsplitter.size()==2)
                 accId=suppNumMap.get(supsplitter[1]);
                 if(accId!=null)
                 cnt.Supplier_del__c=accId;
                 SupplierNum=supsplitter[1];
             }
         }
        }
       if( rows[3].trim()!=null && rows[3].trim()!='')
        {
         id costCatId= costCatName.get(rows[3].trim());
         if(costCatId!=null )
         cnt.Cost_Category__c=costCatId;
         costCatgryName=rows[3].trim();
        }
         if(rows[4].trim()!=null && rows[4].trim()!='')
        {
         cnt.CurrencyIsoCode=rows[4].trim();
        }
        }
     else
     {cnt=null;}
     if(rows[7].trim()!=null && rows[7].trim()!='')
     cnt.Price__c=decimal.valueOf(rows[7].trim());
     else
     {cnt=null;}
     
    }     
     if( j==2)
    {
      //system.debug('in j=2' + tquat + tyear + rows[10].trim() + rows[9].trim());
     
     if(rows[10].trim()!=null && rows[10].trim()!='')
     {
      cnt.Award__c=integer.valueof(rows[10].trim());
      cnt.Quarter__c=tquat;
      cnt.Year__c=tyear;
      if(rows[0].trim()!=null && rows[0].trim()!='' )
        cnt.Cost_Type__c= rows[0].trim();
        itemNumber='';
    
       if(rows[1].trim()!=null && rows[1].trim()!='')
       { itemNumber='';
        Id costItemId;
          itemnum=rows[1].trim();
        if(rows[1].trim().length()>1)
        {
         if(itemnum.contains('\''))
        {
          string [] itemsplitter = new string []{};
          itemsplitter=itemnum.split('\'');
          if(itemsplitter.size()==2)
          costItemId =itemNumMap.get(itemsplitter[1]);
          if(costItemId!=null)
          cnt.CD_Item_categories__c=costItemId;   
         itemNumber=itemsplitter[1];  
         }
        }
        }  
          SupplierNum='';
         if(rows[2].trim()!=null && rows[2].trim()!='')
       {
         SupplierNum='';
         Id accId;
         string supnum=rows[2].trim();
         if(rows[2].trim().length()>1)
         {
             if(supnum.contains('\''))
             {
                 string [] supsplitter = new string []{};
                 supsplitter=supnum.split('\'');
                 if(supsplitter.size()==2)
                 accId=suppNumMap.get(supsplitter[1]);
                 if(accId!=null)
                 cnt.Supplier_del__c=accId;
                 SupplierNum=supsplitter[1];
             }
         }
        }
       if( rows[3].trim()!=null && rows[3].trim()!='')
        {
         id costCatId= costCatName.get(rows[3].trim());
         if(costCatId!=null )
         cnt.Cost_Category__c=costCatId;
         costCatgryName=rows[3].trim();
        }
         if(rows[4].trim()!=null && rows[4].trim()!='')
        {
         cnt.CurrencyIsoCode=rows[4].trim();
        }
        }
     else
     {cnt=null;}
     if(rows[9].trim()!=null && rows[9].trim()!='')
     cnt.Price__c=decimal.valueOf(rows[9].trim());
     else
     {cnt=null;}
     
    }     
     if( j==3)
    {
     //system.debug('in j=3' + fourquat + fouryear + rows[11].trim() + rows[12].trim());
     
     if(rows[12].trim()!=null && rows[12].trim()!='')
    {
     cnt.Award__c=integer.valueof(rows[12].trim());
     cnt.Quarter__c=fourquat;
     cnt.Year__c=fouryear;
     if(rows[0].trim()!=null && rows[0].trim()!='' )
        cnt.Cost_Type__c= rows[0].trim();
        itemNumber='';
    
       if(rows[1].trim()!=null && rows[1].trim()!='')
       { itemNumber='';
        Id costItemId;
          itemnum=rows[1].trim();
        if(rows[1].trim().length()>1)
        {
         if(itemnum.contains('\''))
        {
          string [] itemsplitter = new string []{};
          itemsplitter=itemnum.split('\'');
          if(itemsplitter.size()==2)
          costItemId =itemNumMap.get(itemsplitter[1]);
          if(costItemId!=null)
          cnt.CD_Item_categories__c=costItemId;   
         itemNumber=itemsplitter[1];  
         }
        }
        }  
          SupplierNum='';
         if(rows[2].trim()!=null && rows[2].trim()!='')
       {
         SupplierNum='';
         Id accId;
         string supnum=rows[2].trim();
         if(rows[2].trim().length()>1)
         {
             if(supnum.contains('\''))
             {
                 string [] supsplitter = new string []{};
                 supsplitter=supnum.split('\'');
                 if(supsplitter.size()==2)
                 accId=suppNumMap.get(supsplitter[1]);
                 if(accId!=null)
                 cnt.Supplier_del__c=accId;
                 SupplierNum=supsplitter[1];
             }
         }
        }
       if( rows[3].trim()!=null && rows[3].trim()!='')
        {
         id costCatId= costCatName.get(rows[3].trim());
         if(costCatId!=null )
         cnt.Cost_Category__c=costCatId;
         costCatgryName=rows[3].trim();
        }
         if(rows[4].trim()!=null && rows[4].trim()!='')
        {
         cnt.CurrencyIsoCode=rows[4].trim();
        }
        }
     else
     {cnt=null;}
     if(rows[11].trim()!=null && rows[11].trim()!='')
     cnt.Price__c=decimal.valueOf(rows[11].trim());
     else
     {cnt=null;}
     
    } 
      if( j==4)
    {
     //system.debug('in j=4' + fifthquat + fifthyear + rows[14].trim() + rows[13].trim());
     
     if(rows[14].trim()!=null && rows[14].trim()!='')
    {
      cnt.Award__c=integer.valueof(rows[14].trim());
      cnt.Quarter__c=fifthquat;
      cnt.Year__c=fifthyear;
      if(rows[0].trim()!=null && rows[0].trim()!='' )
        cnt.Cost_Type__c= rows[0].trim();
        itemNumber='';
    
       if(rows[1].trim()!=null && rows[1].trim()!='')
       { itemNumber='';
        Id costItemId;
          itemnum=rows[1].trim();
        if(rows[1].trim().length()>1)
        {
         if(itemnum.contains('\''))
        {
          string [] itemsplitter = new string []{};
          itemsplitter=itemnum.split('\'');
          if(itemsplitter.size()==2)
          costItemId =itemNumMap.get(itemsplitter[1]);
          if(costItemId!=null)
          cnt.CD_Item_categories__c=costItemId;   
         itemNumber=itemsplitter[1];  
         }
        }
        }  
          SupplierNum='';
         if(rows[2].trim()!=null && rows[2].trim()!='')
       {
         SupplierNum='';
         Id accId;
         string supnum=rows[2].trim();
         if(rows[2].trim().length()>1)
         {
             if(supnum.contains('\''))
             {
                 string [] supsplitter = new string []{};
                 supsplitter=supnum.split('\'');
                 if(supsplitter.size()==2)
                 accId=suppNumMap.get(supsplitter[1]);
                 if(accId!=null)
                 cnt.Supplier_del__c=accId;
                 SupplierNum=supsplitter[1];
             }
         }
        }
       if( rows[3].trim()!=null && rows[3].trim()!='')
        {
         id costCatId= costCatName.get(rows[3].trim());
         if(costCatId!=null )
         cnt.Cost_Category__c=costCatId;
         costCatgryName=rows[3].trim();
        }
         if(rows[4].trim()!=null && rows[4].trim()!='')
        {
         cnt.CurrencyIsoCode=rows[4].trim();
        }
        }
     else
     {cnt=null;}
     if(rows[13].trim()!=null && rows[13].trim()!='')
     cnt.Price__c=decimal.valueOf(rows[13].trim());
     else
     {cnt=null;}
     
    }     
    
      if( j==5)
    {
      //system.debug('in j=5' + sixthquat + sixthyear + rows[16].trim() + rows[15].trim());
    
     if(rows[16].trim()!=null && rows[16].trim()!='')
    {  cnt.Quarter__c=sixthquat;
     cnt.Year__c=sixthyear;
     cnt.Award__c=integer.valueof(rows[16].trim());
     if(rows[0].trim()!=null && rows[0].trim()!='' )
        cnt.Cost_Type__c= rows[0].trim();
        itemNumber='';
    
       if(rows[1].trim()!=null && rows[1].trim()!='')
       { itemNumber='';
        Id costItemId;
          itemnum=rows[1].trim();
        if(rows[1].trim().length()>1)
        {
         if(itemnum.contains('\''))
        {
          string [] itemsplitter = new string []{};
          itemsplitter=itemnum.split('\'');
          if(itemsplitter.size()==2)
          costItemId =itemNumMap.get(itemsplitter[1]);
          if(costItemId!=null)
          cnt.CD_Item_categories__c=costItemId;   
         itemNumber=itemsplitter[1];  
         }
        }
        }  
          SupplierNum='';
         if(rows[2].trim()!=null && rows[2].trim()!='')
       {
         SupplierNum='';
         Id accId;
         string supnum=rows[2].trim();
         if(rows[2].trim().length()>1)
         {
             if(supnum.contains('\''))
             {
                 string [] supsplitter = new string []{};
                 supsplitter=supnum.split('\'');
                 if(supsplitter.size()==2)
                 accId=suppNumMap.get(supsplitter[1]);
                 if(accId!=null)
                 cnt.Supplier_del__c=accId;
                 SupplierNum=supsplitter[1];
             }
         }
        }
       if( rows[3].trim()!=null && rows[3].trim()!='')
        {
         id costCatId= costCatName.get(rows[3].trim());
         if(costCatId!=null )
         cnt.Cost_Category__c=costCatId;
         costCatgryName=rows[3].trim();
        }
         if(rows[4].trim()!=null && rows[4].trim()!='')
        {
         cnt.CurrencyIsoCode=rows[4].trim();
        }
        }
     else
     {cnt=null;}
     if(rows[15].trim()!=null && rows[15].trim()!='')
     cnt.Price__c=decimal.valueOf(rows[15].trim());
     else
     {cnt=null;}
     
    }         
    }
   catch(Exception e)
    {
        //system.debug('exception**********'+e);
        String excepMsg=String.Valueof(e);
        String[] errorMsgs =excepMsg.split(':'); 
        this.errordetails.add(new errorwrapper(cnt,'Please correct the value' +errorMsgs[2] ));
        continue;
    }  
   
  
 if(cnt!=null)
 {
      //system.debug('in validations cnt' + cnt);
      if((cnt.Cost_Type__c!='LOS' && cnt.Cost_Type__c!='Lenovo' && cnt.Cost_Type__c!='Should Be' && cnt.Cost_Type__c!='Market') || cnt.Cost_Type__c=='')
        {
         errordetails.add(new errorwrapper(cnt,'Please enter valid data in the Cost Type field.')); 
        
        }
      
        if(cnt.Year__c==null)
        {
         errordetails.add(new errorwrapper(cnt,'Please enter data in the Year field.'));   
        }   
        
          if(cnt.Quarter__c==null )
        {
         errordetails.add(new errorwrapper(cnt,'Please enter data in the Quarter field.'));   
        }   
      
     
       
        if( cnt.Cost_Type__c=='LOS' &&  cnt.CD_Item_categories__c==null )
        {
         ////////system.debug('in LOS');
         errordetails.add(new errorwrapper(cnt,'For Los Cost Type Item Number is Mandatory.'));   
        }
        if( cnt.Cost_Type__c=='LOS' &&  cnt.Supplier_del__c==null)
        {
         ////////system.debug('in LOS');
         errordetails.add(new errorwrapper(cnt,'For Los Cost Type Supplier Number is Mandatory.'));   
        }
        
        
        if( cnt.Cost_Type__c=='Lenovo' &&  cnt.CD_Item_categories__c==null && cnt.Supplier_del__c==null)
        { 
         ////////system.debug('in LOS');
         errordetails.add(new errorwrapper(cnt,'For LenovoCost Type Item Number or supplier Number is Mandatory.'));   
        }
        if(cnt.CD_Item_categories__c==null && rows[1].trim()!=null && rows[1].trim()!='' && rows[1].trim().length()>1)
        {
         errordetails.add(new errorwrapper(cnt,'Please enter valid Item Number')); 
        }
        if(cnt.Supplier_del__c==null && rows[2].trim()!=null && rows[2].trim()!='' && rows[2].trim().length()>1)
        {
         errordetails.add(new errorwrapper(cnt,'Please enter valid Supplier Number')); 
        }
        if((cnt.Cost_Type__c=='Should Be'||cnt.Cost_Type__c=='Market' ) && cnt.CD_Item_categories__c==null  && cnt.Cost_Category__c==null)
        {
         ////////system.debug('in should be');
         errordetails.add(new errorwrapper(cnt,'For Shoud Be or Market Cost Type Item Number or Cost Category is Mandatory.'));   
        }      
        if(cnt.Cost_Category__c==null && rows[3].trim()!='' && cnt.Cost_Type__c!='LOS' )
        {
         errordetails.add(new errorwrapper(cnt,'Please enter valid Cost Category'));   
        }   
        if(cnt.Quarter__c!=null && cnt.Quarter__c!=0 && cnt.Quarter__c>4)
        {
         errordetails.add(new errorwrapper(cnt,'Please enter valid Quarter Number <= 4'));   
        }
       
        if(cnt.CurrencyIsoCode==null || cnt.CurrencyIsoCode=='' )
        {
         errordetails.add(new errorwrapper(cnt,'Please enter valid Currency '));   
        }
       else{
        
       
     
        for(errorwrapper err: errordetails)
        {
         //system.debug(err + 'in adding to set of error');
         errorSet.add(err.costItem);
        } 
      try{
        if(!errorSet.contains(cnt))
        {
          List<CD_Item_Cost_Details__c> costItemDets = new List<CD_Item_Cost_Details__c>();
          String externalKey;
          
           string supNum3;
           string itemNum3;
        if(rows[1].trim()!='' && rows[1].trim()!=null)
        {
              string itemNo=rows[1].trim();
             if(itemNo.contains('\''))
             {
              string [] itemsplitter=itemNo.split('\'');  
              if(itemsplitter.size()>1 && itemsplitter[1]!=null && itemsplitter[1]!='')
              { itemNum3=itemsplitter[1];    }
              else 
              { itemNum3='';}
              //system.debug(  itemNum3 + 'itemNum3++++++');   
             
             }
          }   
           if(rows[2].trim()!='' && rows[2].trim()!=null)
           {
             //system.debug(rows[2].trim());
             string supnum1=rows[2].trim();
             if(supnum1.contains('\''))
            {
              string [] suplitter=supnum1.split('\'');  
              if(suplitter.size()>1 && suplitter[1]!=null && suplitter[1]!='')
              {
              supNum3= suplitter[1];  }
              else 
              {supNum3='';}
              //system.debug( supNum3 + 'supNum3++++++');   
             
             }
           }  
      if(cnt!=null)
      {
        if(itemNum3!=null && supNum3!=null && rows[3].trim()!=null)
        {
        externalKey=cnt.Cost_Type__c+'-'+itemNum3+'-'+ supNum3 +'-'+rows[3].trim()+'-'+cnt.Quarter__c+'-'+cnt.Year__c+'-'+cnt.CurrencyIsoCode;
        }
        if(itemNum3==null  && supNum3!=null && rows[3].trim()!=null)
        {
         externalKey=cnt.Cost_Type__c+'-'+'-'+ supNum3 +'-'+rows[3].trim()+'-'+cnt.Quarter__c+'-'+cnt.Year__c+'-'+cnt.CurrencyIsoCode;
        }
        if(itemNum3==null  && supNum3==null && rows[3].trim()!=null)
        {
         externalKey=cnt.Cost_Type__c+'-'+'-'+'-'+rows[3].trim()+'-'+cnt.Quarter__c+'-'+cnt.Year__c+'-'+cnt.CurrencyIsoCode;
        }
         if(itemNum3!=null  && supNum3==null && rows[3].trim()!=null)
        {
         externalKey=cnt.Cost_Type__c+'-'+itemNum3+'-'+'-'+rows[3].trim()+'-'+cnt.Quarter__c+'-'+cnt.Year__c+'-'+cnt.CurrencyIsoCode;
        }
         if(itemNum3!=null  && supNum3!=null && rows[3].trim()==null)
        {
         externalKey=cnt.Cost_Type__c+'-'+itemNum3+'-'+supNum3 +'-'+'-'+cnt.Quarter__c+'-'+cnt.Year__c+'-'+cnt.CurrencyIsoCode;
        }
         if(itemNum3==null  && supNum3!=null && rows[3].trim()==null)
        {
         externalKey=cnt.Cost_Type__c+'-'+'-'+supNum3 +'-'+'-'+cnt.Quarter__c+'-'+cnt.Year__c+'-'+cnt.CurrencyIsoCode;
        }
        //system.debug( externalKey + ' externalKey+++++');
          Id costItemId=extKeyMap.get(externalKey);
          //system.debug(costItemId + 'costItemId++++++');
          if( costItemId!=null  )
          cnt.Id=costItemId;
          itemCostUpsert.add(cnt);   
          //system.debug(itemCostUpsert + 'itemCostUpsert' + itemCostUpsert.size());
          costItemMap.put(i,cnt);     
        }
        }
        
        
        
       }    
        
       catch(Exception e)
       {
       
       //system.debug(e);
       this.errordetails.add(new errorwrapper(cnt,'duplicate Record in file'));
       
       }  
       }
       } 
      }     
    }  
   
   }
  Map<string,List<CD_Item_Cost_Details__c>> awardsMap = new Map<string,List<CD_Item_Cost_Details__c>>();
   if(itemCostUpsert.size()>0)
  {
   
   for(CD_Item_Cost_Details__c itemCost :itemCostUpsert)
   {
     system.debug('in creating awards map');
    if(itemCost.CD_Item_categories__c!=null)
    {
     string str = itemIdNumMap.get(itemCost.CD_Item_categories__c)+string.Valueof(itemCost.Quarter__c)+string.Valueof(itemCost.Year__c);
     if(awardsMap.ContainsKey(str))
     {
     
      awardsMap.get(str).add(itemCost);
     
     }
     else
     {
     List<CD_Item_Cost_Details__c> dec = new List<CD_Item_Cost_Details__c>();
     dec.add(itemCost);
     awardsMap.put(str,dec);
       }
   
    }
   
   }
   system.debug('after creating awardsMap' + awardsMap);
   }
   if(awardsMap.size()>0)
   {
   for(string item : awardsMap.keyset())
   {
    Decimal faward=0;
    List<CD_Item_Cost_Details__c> awards =  new List<CD_Item_Cost_Details__c>();
    awards =  awardsMap.get(item);
    for(CD_Item_Cost_Details__c awa : awards)
    {
     system.debug('in before for loop' +  faward + 'faward++++++++++++++++');
     faward+=awa.Award__c;
     system.debug('in after for loop' +  faward + 'faward++++++++++++++++');
    }
    system.debug(faward + 'faward++++++++++++++++');
    if(faward==100)
    {
      for(CD_Item_Cost_Details__c award : awards)
     {
      system.debug('in for equal to 100');
      itemCostUpsertFinal.add(award);
     }
     }
     else
      {
       for(CD_Item_Cost_Details__c awar : awards)
      {
       system.debug('in for not equal to 100');
       this.errordetails.add(new errorwrapper(awar,'The sum of award percentages should be equal to 100 for an item in any particular period'));
      }
     }
   
   }
   }
   
   
   } 
   catch (Exception e)
   {
     //system.debug(e);
       //this.errordetails.add(new errorwrapper(,'Please make sure the all the cells in uploaded file are in text format and qoutes are place beofre item and supplier numbers'));
   }  
      
 
   
   try{
         Database.UpsertResult[] srList = Database.Upsert(itemCostUpsertFinal, false);  
          for(integer z=1;z<srList.size();z++)
          {
            if (srList[z].Success)
              {}
            else{
                 CD_Item_Cost_Details__c eRR =  costItemMap.get(z+1);
                 errMsgs='Update Failed Please check whether all Required fields are provided in correct format';
                 this.errordetails.add(new errorwrapper(eRR,errMsgs));
                }
           }
        }
        catch(Exception e){
         //system.debug(e);
        }
        try{
        system.debug(errordetails.size() + '*******************');
        
        if(errordetails.size()>0 && errordetails!=null)
        { 
        Integer uploadedRec= (csvRecords.size()-13)*6;
        string datestring='Report Date:' + System.now().format('MMMM-dd-yyyy') + '\n' + '\n';  
        string messageBody='<br/><br/>' +'<html><body> Dear'+' ' + UserInfo.getName()+','+'</html></body>' + '<br/><html><body> The following records  ' +  errordetails.size() +  ' out of  ' + uploadedRec + ' are errored and the status is given below. All other records are uploaded successfully.</html></body>';
        string pdfContent;
        ////////system.debug(errordetails + 'errordetails######');
        pdfContent='<html><head><meta http-equiv=content-type content=text/html;charset=iso-8859-9></meta></head><body>';
        pdfContent=pdfContent+'<table border="1" bordercolor="#FFCC00" style="background-color:#FFFFFF; display: inline; width:25%"  cellpadding="3" cellspacing="5" >';
        pdfContent=pdfContent+'<tr><th>Cost Type </th><th>Item</th><th>Supplier Number</th><th>Cost Category</th><th>Quarter</th><th>Year</th><th>Award</th><th>Currency</th><th>Cost</th><th>Error Message</th></tr>';
        for(errorwrapper err:errordetails)
        {  
              system.debug(err+'ppppppppppppppppppp');
               string itemCats;
               List<Account> accName = new List<Account>();
             
              if(err.CostItem.CD_Item_categories__c!=null )
              {
               itemCats = itemName;
              }
            
              
             
                //////system.debug(err + 'err######');
                pdfContent += '<tr>';
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+err.CostItem.Cost_Type__c+'</td>'; 
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+itemIdNumMap.get(err.CostItem.CD_Item_categories__c)+'</td>'; 
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+supIdNumMap.get(err.CostItem.Supplier_del__c)+'</td>'; 
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+costCatIdNameMap.get(err.CostItem.Cost_Category__c)+'</td>';
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+err.CostItem.Quarter__c+'</td>'; 
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+err.CostItem.Year__c+'</td>';  
                pdfContent += '<td valign="top" style="width:125px;border-bottom:1px solid #f1f1f1;">'+err.CostItem.Award__c+'</td>';
                pdfContent += '<td valign="top" style="width:125px;border-bottom:1px solid #f1f1f1;">'+err.CostItem.CurrencyIsoCode+'</td>';
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+err.CostItem.Price__c+'</td>'; 
                pdfContent += '<td valign="top" style="border-bottom:1px solid #f1f1f1;">'+err.errorMsg+'</td>'; 
                pdfContent += '</tr>';
        
        
        }
       
        pdfContent = pdfContent + '</table>';
        pdfContent = pdfContent + '</BODY></HTML>';
      
      
        
       Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('ErrorRecords.pdf');
         efa.setBody(Blob.toPDF(pdfContent)); 
        //efa.setContentType('pdf');
        // message.setTargetObjectId(UserInfo.getUserId());
         
         message.setToAddresses(new String[] { UserInfo.getUserEmail()  });
         message.setSubject('Cost Maintenance - Upload Status ');
         message.setSaveAsActivity(false);
         message.setHtmlBody(datestring+messageBody);
         
       
         message.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
       
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});  
         
        }
        else
        {
         string datestring='Report Date:' + System.now().format('MMMM-dd-yyyy') + '\r\n' + '\r\n';  
         string messageBody='<html><body> Dear'+' ' + UserInfo.getName()+','+'</html></body>' + '<br/><html><body> Total records uploaded into the system are:</html></body>' + itemCostUpsertFinal.size();
         Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
         message.setToAddresses(new String[] { UserInfo.getUserEmail()  });
         message.setSubject('Cost Maintenance - Upload Status');
         message.setSaveAsActivity(false);
         message.setHtmlBody(datestring+messageBody);
         Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});
        }
        }
        catch(Exception e)
        {
         //system.debug(e);
        }
  
}
  public List<errorwrapper> geterrorrecords(){
     
       return errordetails;  
     }
     public pageReference refresh()
    {
       //redirect after pressed Go Back button
       PageReference pageRef= new PageReference('/apex/CD_ItemCostUpload');
       pageRef.setRedirect(true);
       return pageRef;
     }

}