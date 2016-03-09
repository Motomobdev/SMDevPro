@isTest
public with sharing class APTPS_TestGenerate_StatustoAuthor {

    static testMethod void myUnitTest() {
    
            // 3. Create Account
        Account acct = new Account(Name='Test Account');
        insert acct; 
    
        // 6. Create Agreement
        Apttus__APTS_Agreement__c newagmt = new Apttus__APTS_Agreement__c 
                                            (Name = 'Test Agreement #1', 
                                            //APTPS_Practice_Area__c=,
                                            //subtype__c,
                                            //APTPS_Type_of_Work__c,
                                            APTPS_Practice_Area__c='Indirect Supply Chain',
                                            Apttus__Status_Category__c = 'Request',
                                            Apttus__Status__c = 'Request',
                                            Apttus__Account__c = acct.id,
                                            APTPS_Executive_Summary_Generated__c = false
                                            );
                                            
        insert newagmt;
        
        // STEP 8 - Create the controller
        PageReference currPage = Page.APTPS_ApprovalAction;
        
           Test.setCurrentPage(currPage);
           //currPage.getParameters().put('ProposalID', newagmt.id);
           
           APTPS_Generate_StatustoAuthorContract controller1 = new APTPS_Generate_StatustoAuthorContract(new ApexPages.StandardController(newagmt));
           
            // Test preview mode of the controller
        
        
         PageReference newPage1 = controller1.UpdateStatus();
        
    
    
    }
    
}