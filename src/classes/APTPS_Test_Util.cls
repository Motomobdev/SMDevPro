@IsTest
public class APTPS_Test_Util {
    /*
     * Author: Rajesh Krishnaiah
     * Creation Date: 27-Nov-2012
     * Description:
     *     Static test methods relating to the Apttus Agreement object
     */

    public static Account createTestAccount() {
       Account a = new Account(name = 'Apttus Test Account', type = 'Vendor');
       insert a;
       return a;
    }


    public static Apttus__APTS_Agreement__c createAgreement(Account a) {

        Apttus__APTS_Agreement__c agreement =
            new Apttus__APTS_Agreement__c(
                name = 'Test Agreement',
                Apttus__Account__c = a.id
            );
        insert agreement;

        return agreement;
    }

    // Test Trigger: Update_ESR_Status
    public static testmethod void testUpdate_ESR_Status() {

        Account a = createTestAccount();
        Apttus__APTS_Agreement__c agreement = createAgreement(a);

        system.assertNotEquals(agreement, null);

        // Create an ESR and relate it to the agreement
        External_Spend_Request__c esr = new External_Spend_Request__c(
            name = 'TEST-ESR-00000',
            external_id__c = 00000,

            contract_status__c = 'Pre-Approved: Procurement Negotiation in Progress',
            account__c = a.id
        );

        insert esr;

        // Add a cost record
        External_Spend_Request_Cost__c esrCost =
            new External_Spend_Request_Cost__c(
                External_Spend_Request__c = esr.id,
                Capital_Amount__c = 50,
                Non_Labor_Expense_Amount__c = 5,
                Expense_Amount__c = 25,
                Department__c = 'D1',
                Funding_Organization__c = 'IT',
                SAR__c = 'SAR1'
            );

        insert esrCost;

        // Update ESR cost before the ESR is related to the agreement
        esrCost.Non_Labor_Expense_Amount__c = 4;
        update esrCost;

        // Relate the ESR to the agreement
        esr.agreement__c = agreement.id;
        update esr;

        agreement.external_spend_request__c = esr.id;
        update agreement;

        // Scenario-0: Change a non cost field on the ESR and expect it to fail
        // because of the validation rule
        esr.name = 'TEST-ESR-00001';
        try {
            update esr;
        } catch (Exception e) {}

        // Scenario-1:
        agreement.Apttus__Status__c = 'Pending Approval';
        update agreement;

        // The ESR status should be "Executive Summary Approvals In Progress"
        esr = [select id, contract_status__c from external_spend_request__c where id = :esr.id][0];
        system.assertEquals(esr.contract_status__c, 'Executive Summary Approvals In Progress');

        // Scenario-2:
        agreement.Apttus__Status__c = 'Approved';
        update agreement;

        // The ESR status should be "Contract Pending Final Signature"
        esr = [select id, contract_status__c from external_spend_request__c where id = :esr.id][0];
        system.assertEquals(esr.contract_status__c, 'Contract Pending Final Signature');

        // Scenario-3:
        agreement.Apttus__Status__c = 'Fully Signed';
        update agreement;

        // The ESR status should be "Submitted for PR Creation"
        esr = [select id, contract_status__c from external_spend_request__c where id = :esr.id][0];
        system.assertEquals(esr.contract_status__c, 'Submitted for PR Creation');
    }
}