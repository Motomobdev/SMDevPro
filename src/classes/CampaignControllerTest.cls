@isTest
private class CampaignControllerTest {

    static testMethod void testUpdateRecordtype() {

       // setup a reference to the page the controller is expecting with the parameters
        PageReference pref = Page.CampaignEdit;
        Test.setCurrentPage(pref);

        Account ac1 = new Account(name = 'CampaignProductMethodsTest');
           

         Campaign campaigns = new Campaign();
         campaigns.Name = 'CampaignMethodsTest';
        campaigns.Account__c=ac1.Id;
        
        campaigns.Status = 'Planned';
         campaigns.e_Commerce_Promotion_Code__c = '1230';  
        campaigns.Type='Advertisement';
        campaigns.Channel_Type__c='B2B';
        campaigns.Funded_By__c='Carrier';
        campaigns.Category__c='Media';
        campaigns.Description='test';
        campaigns.StartDate=System.Today()+1;
        campaigns.EndDate=System.Today()+15;
        campaigns.BudgetedCost=69 ;
       campaigns.RecordTypeId='01240000000DuXb';
       insert campaigns;
      
         PageReference refreshAxnMgr = new PageReference('/701/e?retURL=%2F701%2Fo&RecordType='+campaigns.RecordTypeId+'&ent=Campaign&sfdc.override=0');
Test.setCurrentPage(refreshAxnMgr);

//Instantiate and construct the controller class.
ApexPages.StandardController imcCon1 = new ApexPages.StandardController(new Campaign());
//extend controller with extension, referencing base controller
CampaignController imcExt1 = new CampaignController(imcCon1);


PageReference saveAXNS = imcExt1.redirectToPage(); 

 imcExt1.Save();
campaigns.Is_Product_Campaign__c ='yes';

PageReference refreshAxnMgr1 = new PageReference('/a13/e?CF00N40000002X8D6='+campaigns.Name+'&CF00N40000002X8D6_lkid='+campaigns.Id+'&retURL=%2F'+campaigns.Id);
Test.setCurrentPage(refreshAxnMgr1);
imcExt1.cancel();

Campaign campaigns1 = new Campaign();
         campaigns1.Name = 'CampaignMethodsTest';
        campaigns1.Account__c=ac1.Id;
        
        campaigns1.Status = 'Planned';
         campaigns1.e_Commerce_Promotion_Code__c = '1230';  
        campaigns1.Type='Advertisement';
        campaigns1.Channel_Type__c='B2B';
        campaigns1.Funded_By__c='Carrier';
        campaigns1.Category__c='Media';
        campaigns1.Description='test';
        campaigns1.StartDate=System.Today()+1;
        campaigns1.EndDate=System.Today()+15;
        campaigns1.BudgetedCost=69 ;
       campaigns1.RecordTypeId='01240000000DwQF';
       insert campaigns1;
      
         PageReference refreshAxnMgr12 = new PageReference('/701/e?retURL=%2F701%2Fo&RecordType='+campaigns1.RecordTypeId+'&ent=Campaign&sfdc.override=0');
Test.setCurrentPage(refreshAxnMgr12);

//Instantiate and construct the controller class.
ApexPages.StandardController imcCon2 = new ApexPages.StandardController(new Campaign());
//extend controller with extension, referencing base controller
CampaignController imcExt2 = new CampaignController(imcCon2);


PageReference saveAXNS1= imcExt2.redirectToPage();
imcExt2.Save();
imcExt2.cancel();

Campaign campaigns2 = new Campaign();
         campaigns2.Name = 'CampaignMethodsTest';
        campaigns2.Account__c=ac1.Id;
        
        campaigns2.Status = 'Planned';
         campaigns2.e_Commerce_Promotion_Code__c = '1230';  
        campaigns2.Type='Advertisement';
        campaigns2.Channel_Type__c='B2B';
        campaigns2.Funded_By__c='Carrier';
        campaigns2.Category__c='Media';
        campaigns2.Description='test';
        campaigns2.StartDate=System.Today()+1;
        campaigns2.EndDate=System.Today()+15;
        campaigns2.BudgetedCost=69 ;
       campaigns2.RecordTypeId='01240000000DuXg';
       insert campaigns2;
      
         PageReference refreshAxnMgr123 = new PageReference('/701/e?retURL=%2F701%2Fo&RecordType='+campaigns2.RecordTypeId+'&ent=Campaign&sfdc.override=0');
Test.setCurrentPage(refreshAxnMgr123);

//Instantiate and construct the controller class.
ApexPages.StandardController imcCon23 = new ApexPages.StandardController(new Campaign());
//extend controller with extension, referencing base controller
CampaignController imcExt23 = new CampaignController(imcCon23);


PageReference saveAXNS12= imcExt23.redirectToPage();
imcExt23.Save();
imcExt23.cancel();

Campaign campaigns3 = new Campaign();
         campaigns3.Name = 'CampaignMethodsTest';
        campaigns3.Account__c=ac1.Id;
        
        campaigns3.Status = 'Planned';
         campaigns3.e_Commerce_Promotion_Code__c = '1230';  
        campaigns3.Type='Advertisement';
        campaigns3.Channel_Type__c='B2B';
        campaigns3.Funded_By__c='Carrier';
        campaigns3.Category__c='Media';
        campaigns3.Description='test';
        campaigns3.StartDate=System.Today()+1;
        campaigns3.EndDate=System.Today()+15;
        campaigns3.BudgetedCost=69 ;
       campaigns3.RecordTypeId='01240000000DuXW';
       insert campaigns3;
      
         PageReference refreshAxnMgrs = new PageReference('/701/e?retURL=%2F701%2Fo&RecordType='+campaigns3.RecordTypeId+'&ent=Campaign&sfdc.override=0');
Test.setCurrentPage(refreshAxnMgrs);

//Instantiate and construct the controller class.
ApexPages.StandardController imcCons = new ApexPages.StandardController(new Campaign());
//extend controller with extension, referencing base controller
CampaignController imcExts = new CampaignController(imcCons);


PageReference saveAXNSs= imcExts.redirectToPage();
imcExts.Save();
imcExts.cancel();
    }

}