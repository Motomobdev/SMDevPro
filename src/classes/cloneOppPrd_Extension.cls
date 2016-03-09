public class cloneOppPrd_Extension {

    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // add the instance for the variables being passed by id on the url
    private OpportunityLineItem po {get;set;}
    // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
    public ID newRecordId {get;set;}

    // initialize the controller
    public cloneOppPrd_Extension(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        po = (OpportunityLineItem)controller.getRecord();

    }

    // method called from the VF's action attribute to clone the po
    public PageReference cloneWithProducts() {

         // setup the save point for rollback
         Savepoint sp = Database.setSavepoint();
         OpportunityLineItem newPO;

         try {

              //copy the purchase order - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             po = [SELECT OpportunityId,Id,TotalPrice,Quantity,PricebookEntryId,ListPrice,Invoice_Price__c,LCV_Price__c,Business_Unit__c,Product_Forecast_Category__c,Forecast_Overridden__c,Reason_for_Current_Forecast_Category__c,Opportunity_Line_Number__c,Include_in_R_O__c,End_Customer_Account__c,ServiceDate,Fiscal_Month__c,Description FROM OpportunityLineItem where id = :po.id];
             newPO = po.clone(false);
             insert newPO;

             // set the id of the new po created for testing
               newRecordId = newPO.id;

             
             
         } catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
         }

        return new PageReference('/'+newPO.id+'/e?retURL=%2F'+newPO.id);
    }

}