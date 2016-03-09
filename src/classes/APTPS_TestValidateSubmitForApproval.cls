@isTest
private class APTPS_TestValidateSubmitForApproval {

    static testmethod void testIndirectSupplyChain()
    {
        Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c(
            name = 'ISC', APTPS_Practice_Area__c='Indirect Supply Chain',
            Business_Unit_Finance_Approver__c=UserInfo.getUserID(),
            Apttus__Requestor__c=UserInfo.getUserID(),
            APTPS_Business_VP__c=UserInfo.getUserID(),
        Apttus_Approval__Approval_Status__c='Not Submitted');
           
        insert agreement;
       
        ApexPages.currentPage().getParameters().put('sObjectId',agreement.Id);
        PageReference currPage = Page.APTPS_Validate_Submit_For_Approval;

        ApexPages.StandardController cont = new ApexPages.Standardcontroller(agreement); 
        APTPS_validateSubmitForApproval test = new APTPS_validateSubmitForApproval();
        test.checkApprovalProcessType();
        test.goBack();   
    }
    
    static testmethod void testGTM()
    {
        Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c(
            name = 'GTM', APTPS_Practice_Area__c='GTM',
            Business_Unit_Finance_Approver__c=UserInfo.getUserID(),
            Apttus__Requestor__c=UserInfo.getUserID(),
            APTPS_Business_VP__c=UserInfo.getUserID(),
            Internal_Business_Owner__c=UserInfo.getUserID(),
            Legal_Owner__c=UserInfo.getUserID(),
            APTPS_Type_of_Work__c='Carrier',
            Apttus_Approval__Approval_Status__c='Not Submitted');
           
        insert agreement;
       
        ApexPages.currentPage().getParameters().put('sObjectId',agreement.Id);
        PageReference currPage = Page.APTPS_Validate_Submit_For_Approval;

        ApexPages.StandardController cont = new ApexPages.Standardcontroller(agreement); 
        APTPS_validateSubmitForApproval test = new APTPS_validateSubmitForApproval();
        test.checkApprovalProcessType();
        test.goBack();   
    }
}