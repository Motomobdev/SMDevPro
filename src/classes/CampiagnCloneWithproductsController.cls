public class CampiagnCloneWithproductsController {

    //added an instance varaible for the standard controller
    private ApexPages.StandardController controller {get; set;}
     // add the instance for the variables being passed by id on the url
    private Campaign po {get;set;}
    // set the id of the record that is created -- ONLY USED BY THE TEST CLASS
    public ID newRecordId {get;set;}

    // initialize the controller
    public CampiagnCloneWithproductsController(ApexPages.StandardController controller) {

        //initialize the stanrdard controller
        this.controller = controller;
        // load the current record
        po = (Campaign)controller.getRecord();

    }

    // method called from the VF's action attribute to clone the po
    public PageReference cloneWithProducts() {

         // setup the save point for rollback
         Savepoint sp = Database.setSavepoint();
         Campaign newPO;

         try {

              //copy the purchase order - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             po = [select Id, Name, OwnerId, Status, ParentId, Campaign_Description__c, Campaign_Review_Date__c, Account__c, Country__c, Is_Product_Campaign__c, City__c, Campaign_Review_Required__c,e_Commerce_Promotion_Code__c,Campaign_Analytics__c,Campaign_Analyzed__c,Analyzed_By__c,Type,Category__c,Funded_By__c,Sub_Category__c,Channel_Type__c,Target__c,Contract_Type__c,Functional_Owner__c,Description,StartDate,BudgetedCost,EndDate,ActualCost from Campaign where id = :po.id];
             newPO = po.clone(false);
             insert newPO;

             // set the id of the new po created for testing
               newRecordId = newPO.id;

             // copy over the line items - ONLY INCLUDE THE FIELDS YOU WANT TO CLONE
             List<Campaign_Product__c> items = new List<Campaign_Product__c>();
             for (Campaign_Product__c pi : [Select p.Campaign__c, p.CurrencyIsoCode, p.Product__c, p.Project_PMD__c, p.Program__c,p.Product_Campaign_Details__c,p.Communication_Method__c,p.Baseline_SO_wk__c,p.Price_Before_Campaign__c,p.Target_Lift__c,p.Price_During_Campaign__c,p.Incremental_Value__c,p.Bundled_with__c,p.Actual_Lift__c,p.Bundled_Product_Price_or_Discount__c,p.Bundled_Product_Discount__c,p.Campaign_Effectiveness__c,p.Campaign_Effectiveness_Detail__c From Campaign_Product__c p where Campaign__c = :po.id]) {
                  Campaign_Product__c newPI = pi.clone(false);
                  newPI.Campaign__c = newPO.id;
                  items.add(newPI);
             }
             insert items;
              List<Task> items1 = new List<Task>();
             for (Task pi1 :[Select pi1.Id,pi1.OwnerId, pi1.Subject, pi1.Status, pi1.WhatId, pi1.Priority, pi1.WhoId, pi1.ActivityDate, pi1.Business__c, pi1.Weekly_Report_Status__c, pi1.Priority_Scope__c, pi1.Description FROM Task pi1 where WhatId = :po.id]) { 
                   Task newPI1 = pi1.clone(false);
                  newPI1.WhatId= newPO.id;
                  items1.add(newPI1);
             }
             
             insert items1;
            List<Attachment> items2 = new List<Attachment>();
             for (Attachment pi2 :[SELECT pi2.Id,pi2.Name,pi2.ContentType,pi2.Body,pi2.ParentId FROM Attachment pi2 where ParentId = :po.id]) { 
                   Attachment newPI2 = pi2.clone(false);
                  newPI2.ParentId= newPO.id;
                  items2.add(newPI2);
             }
             
             insert items2;
             
             
         } catch (Exception e){
             // roll everything back in case of error
            Database.rollback(sp);
            ApexPages.addMessages(e);
            return null;
         }

        return new PageReference('/'+newPO.id+'/e?retURL=%2F'+newPO.id);
    }

}