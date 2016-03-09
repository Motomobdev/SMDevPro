/*************************************************************
  COMMENT: Testmethod for the UpdateAgreementTab batch class
**************************************************************/  

@isTest(SeeAllData = false)

public class APTPS_UpdateAgreementTabTestClass{
    
    static testmethod void UpdateAgreementTabTest(){
        
        List<Apttus__APTS_Agreement__c> agreementList = new List<Apttus__APTS_Agreement__c>();
        
        Apttus__APTS_Agreement__c a = new Apttus__APTS_Agreement__c(APTPS_Type_of_Work__c='Retailers');
        agreementList.add(a);
        
        Apttus__APTS_Agreement__c a1 = new Apttus__APTS_Agreement__c(APTPS_Type_of_Work__c='Retailers', Apttus__Status_Category__c = 'Request');
        agreementList.add(a1);
        
        Apttus__APTS_Agreement__c a2 = new Apttus__APTS_Agreement__c(APTPS_Type_of_Work__c='Retailers', Apttus__Status_Category__c = 'In Authoring', Apttus_Approval__Approval_Status__c = 'Not Submitted');
        agreementList.add(a2);
        
        Apttus__APTS_Agreement__c a3 = new Apttus__APTS_Agreement__c(APTPS_Type_of_Work__c='Retailers', Apttus__Status_Category__c = 'In Filing', Apttus_Approval__Approval_Status__c = 'Approved');
        agreementList.add(a3);
        
        Apttus__APTS_Agreement__c a4 = new Apttus__APTS_Agreement__c(APTPS_Type_of_Work__c='Retailers', Apttus__Status_Category__c = 'In Signatures', Apttus__Status__c = 'Fully Signed');
        agreementList.add(a4);
        
        Apttus__APTS_Agreement__c a5 = new Apttus__APTS_Agreement__c(APTPS_Type_of_Work__c='Retailers', Apttus__Status_Category__c = 'In Effect', Apttus__Contract_End_Date__c = Date.today().addDays(2));
        agreementList.add(a5);
        
        insert agreementList;
        
        a.Apttus__Status_Category__c = null;
        update a;
        
        test.StartTest();
        String query = 'SELECT Id, Apttus__Status_Category__c, Apttus_Approval__Approval_Status__c, Apttus__Status__c  from Apttus__APTS_Agreement__c';
        APTPS_UpdateAgreementTab u = new APTPS_UpdateAgreementTab();
        u.query = query;
        Database.executeBatch(u);
        test.stopTest();
    }
}