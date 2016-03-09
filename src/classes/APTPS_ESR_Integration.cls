public with sharing class APTPS_ESR_Integration {

    /*
     * Author: Rajesh Krishnaiah
     * Created Date: 6-Nov-2012
     * Description:
     * Creates an Apttus agreement for an external spend request (ESR).
     * The ESR to Agreement relation is 1:1 (programtically enforced)
     * The ESR must be assocaited with an account prior to conversion.
     */
    public External_Spend_Request__c esr {get;set;}
    public boolean hasErrors {get; set;}
    public Id selectedRecordTypeId {get; set;}

    public Map<Id, RecordType> agreementRecTypes = null;

    public APTPS_ESR_Integration(ApexPages.StandardController controller) {
        esr = (External_Spend_Request__c)controller.getRecord();

        if (esr != null) {
            // Retrieve other fields on the ESR record
            esr  = [select id, name, Account__c, Agreement__c, Total_Cost__c,
                    Convert_this_to_master_agreement__c, Deal_Description__c,
                    currencyIsoCode, contract_status__c,
                    contract_start_date__c, contract_end_date__c
                   from External_Spend_Request__c
                   where id = :esr.Id];
        }

        agreementRecTypes = new Map<id, RecordType>(
                    [SELECT Id, Name, Description
                     FROM RecordType
                     WHERE SobjectType = 'Apttus__APTS_Agreement__c'
                     AND IsActive = true]);
    }


    public List<selectOption> getAgreementTypes() {
        List<selectOption> options = new List<selectOption>();
        List<RecordType> rts = agreementRecTypes.values();
        for (RecordType recType : rts)
            options.add(new selectOption(recType.Id, recType.Name));

        return options;
    }

    public List<RecordType> getAgreementRecTypes() {
        List<RecordType> rts = agreementRecTypes.values();
        return rts;
    }

    // Saves the agreement record and takes the user to the agreement screen
    public PageReference myCreate() {
        PageReference returnPage = null;

        // Find the "selected record type ID" record

        RecordType selectedRecordType = agreementRecTypes.get(selectedRecordTypeId);

        Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c(
            RecordTypeId = selectedRecordTypeId,
            Name = selectedRecordType.name,
            external_spend_request__c = esr.id,
            Apttus__Account__c = esr.account__c,
            Apttus__Total_Contract_Value__c = esr.Total_Cost__c,
            currencyIsoCode = esr.currencyIsoCode,
            APTPS_Master_Agreement__c = esr.Convert_this_to_master_agreement__c,
            Apttus__Description__c = esr.Deal_Description__c,
            Apttus__Contract_End_Date__c = esr.contract_end_date__c,
            Apttus__Contract_Start_Date__c = esr.contract_start_date__c);
        insert agreement;

        // Update ESR record with the agreement ID
        esr.agreement__c = agreement.id;
        update esr;

        // Open the agreement in edit mode so the user can fill in the required fields
        returnPage = new PageReference('/' + agreement.id + '/e');

        // return the user to the ESR page after the agreement has been saved
        returnPage.getParameters().put('retURL', '/' + esr.id);

        returnPage.setRedirect(false);
        return returnPage;
    }

    static testmethod void test() {

        // Create an account
        Account a = new Account(name = 'Test');
        insert a;

        // Create an ESR without an account (expect the conversion to fail)
        External_Spend_Request__c esr = new External_Spend_Request__c(name = 'Test');
        insert esr;

        // Create an ESR cost record
        External_Spend_Request_Cost__c esrCost =
            new External_Spend_Request_Cost__c(
                External_Spend_Request__c = esr.id,
                name = 'Cost-1',
                Funding_Organization__c = 'IT',
                department__c = 'DEPT-1',
                Capital_Amount__c = 100,
                Expense_Amount__c = 100,
                Non_Labor_Expense_Amount__c = 50,
                Construction_In_Progress__c = 'CIP1',
                SAR__c = 'SAR1'
            );
        insert esrCost;

        Test.setCurrentPage(Page.APTPS_ESR_Integration);
        ApexPages.StandardController sc = new ApexPages.StandardController(esr);
        APTPS_ESR_Integration controller = new APTPS_ESR_Integration(sc);

        // Update ESR to have an account
        esr.account__c = a.id;
        esr.contract_status__c = 'Pre-Approved: Procurement Negotiation in Progress';
        update esr;

        sc = new ApexPages.StandardController(esr);
        controller = new APTPS_ESR_Integration(sc);

        controller.getAgreementTypes();
        List<RecordType> rts = controller.getAgreementRecTypes();
        controller.selectedRecordTypeId = rts[0].id;
        controller.myCreate();

        // ESR now has an agreement. The call to check status should fail
        sc = new ApexPages.StandardController(esr);
        controller = new APTPS_ESR_Integration(sc);

        // Change one of the costs for UpdateAgreementTotal trigger to run
        esrCost.Expense_Amount__c = 101;
        update esrCost;
    }
}