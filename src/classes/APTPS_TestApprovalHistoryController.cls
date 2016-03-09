@isTest
public with sharing class APTPS_TestApprovalHistoryController {

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
                                            Apttus__Account__c = acct.id
                                           // Apttus__Requestor__c = user1.id
                                            );
                                            
        insert newagmt;
        
        // STEP 8 - Create the controller
        PageReference currPage = Page.APTPS_ApprovalAction;
        
           Test.setCurrentPage(currPage);
           currPage.getParameters().put('ProposalID', newagmt.id);
           
           APTPS_ApprovalHistoryController controller1 = new APTPS_ApprovalHistoryController();
           
            // Test preview mode of the controller
      //  Public List<Apttus_Approval__Approval_Request__c> ListOfApprovalLineItems=new List<Apttus_Approval__Approval_Request__c>();
        
       // ListOfApprovalLineItems = 
        controller1.GetApprovalHistory();
        
    
    
    }
    
}