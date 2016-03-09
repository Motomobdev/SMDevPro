public class DealStopLightController {
/*
* Created by: Swetha Mandva
* Creation date: 24-Sep-2014
* Test Class: 
* Description: This class is used as a Controller for VF page DealStopLight. This class will create/update the DealStopLight record.
*/

     public Deal_Stoplight_Deviation__c objDealDeviation {get; set;}
     public Deal_Stoplight_Standard__c objDealStandard {get; set;}
     public String quoteId {get; set;}   
     public String deviationId {get; set;} 
     public Boolean boolIsSummary {get; set;}  
     public Boolean boolShowHeader {get; set;} 
     public Boolean boolSidebar {get; set;}        
     
     public DealStopLightController(ApexPages.StandardController stdController){           
           quoteId = ApexPages.currentPage().getParameters().get('quoteid');     
           deviationId = ApexPages.currentPage().getParameters().get('id');             
           boolIsSummary = false;
           boolShowHeader = true;
           boolSidebar = true;
          
           if(deviationId != null && deviationId != '') {
               objDealDeviation = Database.query(fnAllColumnsById('Deal_Stoplight_Deviation__c',deviationId));
               boolIsSummary = true;
               boolShowHeader = true;
               boolSidebar = true;
           } else {
                if (quoteId != null && quoteId != '') {
                      List<Deal_Stoplight_Deviation__c> dev = [select id, Deal__c from Deal_Stoplight_Deviation__c where Deal__c = :quoteId];
                   if(!dev.isEmpty()) {
                        boolIsSummary = true; 
                        objDealDeviation = Database.query(fnAllColumnsByQuoteId('Deal_Stoplight_Deviation__c',quoteId));
                        objDealDeviation.Deal__c = quoteId; 
                        boolShowHeader = false;
                        boolSidebar = false;   
                      } else {
                          objDealDeviation = (Deal_Stoplight_Deviation__c) stdController.getRecord();
                          objDealDeviation.Deal__c = quoteId; 
                          boolShowHeader = false;
                          boolSidebar = false; 
                      }
                 } else {
                   objDealDeviation = (Deal_Stoplight_Deviation__c) stdController.getRecord();                    
                }
           }
     }
     
     public Pagereference fnAction() { 
         objDealStandard = Database.query(fnAllColumnsByObject('Deal_Stoplight_Standard__c'));    
         return null;
    }
    
    public Pagereference fnEdit() { 
        PageReference pageRef=Page.DealStopLight;
        pageRef.getParameters().put('id', objDealDeviation.id);
        pageRef.getParameters().put('quoteid', quoteId);
        pageRef.getParameters().put('nooverride', '1');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
   public Pagereference fnCreate() {     
      
        if (!boolIsSummary) {
            // set defaults for insert
            if (quoteId != null && quoteId != '') {
                objDealDeviation.Deal__c = quoteId;  
            }
            
            objDealDeviation.Carrier_Branding_Standard__c = objDealStandard.Carrier_Branding_Standard__c; 
            objDealDeviation.Channel_Fill_Standard__c = objDealStandard.Channel_Fill_Standard__c; 
            objDealDeviation.Charger_Accessories_Standard__c = objDealStandard.Charger_Accessories_Standard__c; 
            objDealDeviation.Core_Device_Specifications_Std__c = objDealStandard.Core_Device_Specifications_Std__c; 
            objDealDeviation.CP_Attach_Standard__c = objDealStandard.CP_Attach_Standard__c; 
            objDealDeviation.ELX_Prepaid_Standard__c = objDealStandard.ELX_Prepaid_Standard__c; 
            objDealDeviation.Forecasting_Standard__c = objDealStandard.Forecasting_Standard__c; 
            objDealDeviation.Incoterms_Standard__c = objDealStandard.Incoterms_Standard__c; 
            objDealDeviation.IPP_Standard__c = objDealStandard.IPP_Standard__c; 
            objDealDeviation.Late_Delivery_Penalty_Standard__c = objDealStandard.Late_Delivery_Penalty_Standard__c;        
            objDealDeviation.MDF_Standard__c = objDealStandard.MDF_Standard__c;        
            objDealDeviation.MFN_Standard__c = objDealStandard.MFN_Standard__c; 
            objDealDeviation.Not_to_Exceed_Retail_Price_Standard__c = objDealStandard.Not_to_Exceed_Retail_Price_Standard__c; 
            objDealDeviation.Payment_Terms_Standard__c = objDealStandard.Payment_Terms_Standard__c;        
            objDealDeviation.Product_Exclusivity_Standard__c = objDealStandard.Product_Exclusivity_Standard__c;         
            objDealDeviation.Seeding_Demo_Units_Std__c = objDealStandard.Seeding_Demo_Units_Std__c;        
            objDealDeviation.Sell_Through_Plan_Standard__c = objDealStandard.Sell_Through_Plan_Standard__c; 
            objDealDeviation.Shipping_and_Handling_Standard__c = objDealStandard.Shipping_and_Handling_Standard__c; 
            objDealDeviation.Software_PreLoads_Std__c = objDealStandard.Software_PreLoads_Std__c;        
            objDealDeviation.SW_Updates_Standard__c = objDealStandard.SW_Updates_Standard__c;        
            objDealDeviation.Volume_Commitment_Standard__c = objDealStandard.Volume_Commitment_Standard__c;        
            objDealDeviation.Warranty_Service_Repair_Std__c = objDealStandard.Warranty_Service_Repair_Std__c; 
            objDealDeviation.Warranty_Term_Standard__c = objDealStandard.Warranty_Term_Standard__c; 
            
            objDealDeviation.Carrier_Branding_Approver__c = objDealStandard.Carrier_Branding_Approver__c; 
            objDealDeviation.Channel_Fill_Approver__c = objDealStandard.Channel_Fill_Approver__c; 
            objDealDeviation.Charger_Accessories_Approver__c = objDealStandard.Charger_Accessories_Approver__c; 
            objDealDeviation.Core_Device_Specifications_App__c = objDealStandard.Core_Device_Specifications_App__c; 
            objDealDeviation.CP_Attach_Approver__c = objDealStandard.CP_Attach_Approver__c; 
            objDealDeviation.ELX_Prepaid_Approver__c = objDealStandard.ELX_Prepaid_Approver__c; 
            objDealDeviation.Forecasting_Approver__c = objDealStandard.Forecasting_Approver__c; 
            objDealDeviation.Incoterms_Approver__c = objDealStandard.Incoterms_Approver__c; 
            objDealDeviation.IPP_Approver__c = objDealStandard.IPP_Approver__c; 
            objDealDeviation.Late_Delivery_Penalty_Approver__c = objDealStandard.Late_Delivery_Penalty_Approver__c;        
            objDealDeviation.MDF_Approver__c = objDealStandard.MDF_Approver__c;        
            objDealDeviation.MFN_Approver__c = objDealStandard.MFN_Approver__c; 
            objDealDeviation.Not_to_Exceed_Retail_Price_Approver__c = objDealStandard.Not_to_Exceed_Retail_Price_Approver__c; 
            objDealDeviation.Payment_Terms_Approver__c = objDealStandard.Payment_Terms_Approver__c;        
            objDealDeviation.Product_Exclusivity_Approver__c = objDealStandard.Product_Exclusivity_Approver__c;         
            objDealDeviation.Seeding_Demo_Units_Approver__c = objDealStandard.Seeding_Demo_Units_Approver__c;        
            objDealDeviation.Sell_Through_Plan_Approver__c = objDealStandard.Sell_Through_Plan_Approver__c; 
            objDealDeviation.Shipping_and_Handling_Approver__c = objDealStandard.Shipping_and_Handling_Approver__c; 
            objDealDeviation.Software_PreLoads_Approver__c = objDealStandard.Software_PreLoads_Approver__c;        
            objDealDeviation.SW_Updates_Approver__c = objDealStandard.SW_Updates_Approver__c;        
            objDealDeviation.Volume_Commitment_Approver__c = objDealStandard.Volume_Commitment_Approver__c;        
            objDealDeviation.Warranty_Service_Repair_Approver__c = objDealStandard.Warranty_Service_Repair_Approver__c; 
            objDealDeviation.Warranty_Term_Approver__c = objDealStandard.Warranty_Term_Approver__c; 
            try {      
                insert objDealDeviation;
            } catch(Exception e){
                 ApexPages.addMessages(e);
                 return null;
            }
            } else {
                update objDealDeviation;           
            }   
    
            PageReference pageRef=Page.DealStopLightView;
            pageRef.getParameters().put('id', objDealDeviation.id);
            pageRef.getParameters().put('quoteid', quoteId);
            pageRef.getParameters().put('nooverride', '1');
            pageRef.setRedirect(true);
            return pageRef;        
        } 
     
     //Return query to retrieve all the columns of the specified object filtered by ID
    public String fnAllColumnsById(String sObj, String objectId){
        map<String, schema.sobjecttype> mapAllSObjects = schema.getglobaldescribe();
        schema.sobjecttype sObjType = mapAllSObjects.get(sObj);
        schema.describesobjectresult sObjectDecription = sObjType.getdescribe();
        map<String, schema.sobjectfield> sObjectFieldMap = sObjectDecription.fields.getmap();
        set<String> sObjetFieldsSet = sObjectFieldMap.keyset();
        String strQuery = '';
        for(String strFieldName : sObjetFieldsSet){
            strQuery = strQuery+strFieldName+', ';
        }
        strQuery = strQuery.substring(0,strQuery.length()-2);
        return ('SELECT ' + strQuery + ' FROM ' + sObj + ' WHERE ID=\'' + objectId + '\'');
    }
    //Return query to retrieve all the columns of the specified object filtered by QuoteID
    public String fnAllColumnsByQuoteId(String sObj, String fieldId){
        map<String, schema.sobjecttype> mapAllSObjects = schema.getglobaldescribe();
        schema.sobjecttype sObjType = mapAllSObjects.get(sObj);
        schema.describesobjectresult sObjectDecription = sObjType.getdescribe();
        map<String, schema.sobjectfield> sObjectFieldMap = sObjectDecription.fields.getmap();
        set<String> sObjetFieldsSet = sObjectFieldMap.keyset();
        String strQuery = '';
        for(String strFieldName : sObjetFieldsSet){
            strQuery = strQuery+strFieldName+', ';
        }
        strQuery = strQuery.substring(0,strQuery.length()-2);
        return ('SELECT ' + strQuery + ' FROM ' + sObj + ' WHERE Deal__c=\'' + fieldId + '\' LIMIT 1');
    }
    //Return query to retrieve all the columns of the specified object filtered by ID
    public static String fnAllColumnsByObject(String sObj){
        map<String, schema.sobjecttype> mapAllSObjects = schema.getglobaldescribe();
        schema.sobjecttype sObjType = mapAllSObjects.get(sObj);
        schema.describesobjectresult sObjectDecription = sObjType.getdescribe();
        map<String, schema.sobjectfield> sObjectFieldMap = sObjectDecription.fields.getmap();
        set<String> sObjetFieldsSet = sObjectFieldMap.keyset();
        String strQuery = '';
        for(String strFieldName : sObjetFieldsSet){
            strQuery = strQuery+strFieldName+', ';
        }
        strQuery = strQuery.substring(0,strQuery.length()-2);
        return ('SELECT ' + strQuery + ' FROM ' + sObj + ' LIMIT 1');
    }
 }