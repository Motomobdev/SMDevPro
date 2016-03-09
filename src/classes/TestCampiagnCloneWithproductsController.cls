@isTest
private class TestCampiagnCloneWithproductsController {

    static testMethod void testCampiagnCloneController() {

       // setup a reference to the page the controller is expecting with the parameters
        
    PageReference pref = Page.ClonewithProducts;
        Test.setCurrentPage(pref);
        // setup a ship to account
       Account ac1 = new Account(name = 'CampaignProductMethodsTest');

        // create new po record
        Campaign campaigns = new Campaign();
         campaigns.Name = 'CampaignMethodsTest';
        campaigns.Account__c=ac1.Id;
        campaigns.Is_Product_Campaign__c ='yes';
        campaigns.Status = 'Planned';
         campaigns.e_Commerce_Promotion_Code__c = '1230';  
        campaigns.Type='Advertisement';
        campaigns.Channel_Type__c='B2B';
        campaigns.Funded_By__c='Carrier';
        campaigns.Category__c='Media';
        campaigns.Description='test';
        campaigns.StartDate=system.today()+1;
   campaigns.EndDate=system.today()+91;
        campaigns.BudgetedCost=69 ;
        campaigns.RecordTypeId='01240000000DuXb';
        
        insert campaigns;
              

        PMD_Program__c program1 = new PMD_Program__c(name = 'Test Program');
      
        insert program1;
        PMD_Project__c project1 = new PMD_Project__c(name = 'Test Project', Program_ID__c = program1.id);
       insert project1;
        
        PMD_Product__c product1 = new PMD_Product__c(name = 'Test Product', Project_ID__c = project1.id);
        insert product1;

        Product2 sfProduct1 = new Product2(name = 'Test Product', PMD_Product__c = product1.id,
                                         business_unit__c = 'Mobile Device', isactive = true);
        
        insert sfProduct1;
        Campaign_Product__c cp1 = new Campaign_Product__c(Product__c = sfProduct1.id, 
                                Project_PMD__c = project1.id, Campaign__c = campaigns.id);
                                
            insert cp1;
       
        Attachment pi4 = new Attachment();
        pi4.Name = 'Testing1';
         Blob bodyBlob = Blob.valueOf('PROCESS DOCS');
        pi4.body = bodyBlob;
        pi4.ParentId = campaigns.id; 
                      
        insert pi4;
        // Construct the standard controller
      ApexPages.StandardController con = new ApexPages.StandardController(campaigns);

        // create the controller
        CampiagnCloneWithproductsController ext = new CampiagnCloneWithproductsController(con);

        // Switch to test context
        Test.startTest();
             
        PageReference ref = ext.ClonewithProducts();
        // create the matching page reference
        PageReference redir = new PageReference('/'+ext.newRecordId+'/e?retURL=%2F'+ext.newRecordId);

        // check that the new po was created successfully
         Campaign  newco  = [select id from Campaign where id = :ext.newRecordId];
        System.assertNotEquals(newco, null);
         List<Campaign_Product__c> newItems = [Select p.Id From Campaign_Product__c p where Campaign__c= :newco.id];
        System.assertEquals(newItems.size(),1);
        List<Task> newItems1 = [Select Id From Task  where WhatId = :newco.id];
        System.assertEquals(newItems1.size(),0);
         List<Attachment> newItems3 = [Select Id,ParentId  From Attachment  where ParentId  = :newco.id];
        System.assertEquals(newItems3.size(),1);
      

        // Switch back to runtime context
        Test.stopTest();

    }

}