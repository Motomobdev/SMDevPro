public class Create_Apttus_Deal {

    String productFamily;

    // Local account fields
    public String billingAddress {get; set;}

    public Account channelPartner {get; set;}
    public Account motorolaAccount {get; set;}

    // Local contact fields
    String originalEmail;
    public String email {get; set;}
    public String phone {get; set;}
    private Contact localContact;

    ApexPages.StandardController controller;

    public Create_Apttus_Deal(ApexPages.StandardController controller) {
        this.controller = controller;

        productFamily = ApexPages.currentPage().getParameters().get('productFamily');
        Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        Integer thisYear = System.today().year();

        if (ag.id == null) {

            // Select Deal record type
            List<Recordtype> rts = [SELECT Id,IsActive,Name,SobjectType
                                    FROM RecordType
                                    WHERE SobjectType = 'Apttus__APTS_Agreement__c'
                                    AND Name = 'Deal'
                                    AND IsActive = true];

            if (rts.isEmpty()) {

                ApexPages.Message myMsg =
                    new ApexPages.Message(ApexPages.Severity.FATAL,
                        'Deal record type is missing. Contact your business admin.');
                ApexPages.addMessage(myMsg);
                return;
            }

            ag.currencyIsoCode = 'USD';
            ag.APTPS_Product_Family__c = productFamily;
            ag.RecordtypeId = rts[0].Id;
            ag.APTPS_subtype__c = 'Term Sheet';
            ag.APT_Region__c = 'North America';
            ag.APTPS_Sub_Region__c = 'North America';
            ag.APTPS_Country__c = 'US';
            ag.APTPS_Type_of_Work__c = 'Carrier';
            ag.Apttus__Contract_Start_Date__c = System.today();

            //ag.Apttus__Contract_End_Date__c = Date.newInstance(thisYear + 1, 12, 31);

            //ag.APTPS_Ready_to_generate_executive_sumary__c = true; // Allow exec summary to be generated
            ag.APTPS_MMI_Products__c = productFamily;
            ag.APTPS_Assignability_without_consent__c = 'No';
            ag.APTPS_New_Product_Introduced__c = 'Yes';
            ag.APTPS_Terms_Accepted__c = 'No';
            ag.Apttus__Term_Months__c = 12;
            ag.APTPS_New_Product_Summary__c = productFamily;
            ag.APTPS_Offline_Document_Imported__c = true;
            ag.APTPS_Practice_Area__c = 'GTM'; // Revenue generating agreement
            ag.Internal_Business_Owner__c = UserInfo.getUserId();
            ag.Legal_Owner__c = UserInfo.getUserId();

            // These two fields are required to activate the agreement
            ag.APT_Business_Unit__c = 'Mobile Devices';
            ag.APT_Product_Category__c = 'MD Products';

            // Make agreement ready for approval submission
            ag.Apttus__Status_Category__c = 'In Authoring';
        } else {

            // Edit Mode -- Populate channel partner, contact and Moto Account details
            populateChannelPartnerInfo();
            populateContactInfo();
            populateMotorolaAccountInfo();
        }
    }

    public PageReference mySave() {

        PageReference returnToPage = null;
        boolean newAgreement = false;

        Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        Savepoint sp = Database.setSavepoint();
        Date startDate = ag.Apttus__Contract_Start_Date__c;

        // Check if the contact belongs to the selected account or not
        //System.debug('AG A/C ID: ' + ag.Apttus__Account__c);
        //System.debug('AG Contact A/C ID: ' + localContact.accountId);

        if (localContact != null && localContact.accountId != ag.Apttus__Account__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                'Incorrect contact selected. This contact belongs to account: [' +
                localContact.account.name + ']'));
            return null;
        }

        // The approver 2 and the legal owner are the same
        // Legal Owner is a required field for the GTM practice area
        //ag.Legal_Owner__c = ag.Business_Unit_Finance_Approver__c;

        try {
            if (ag.id == null) {
                // This step is to force the agreement name to be generated
                ag.Apttus__Contract_Start_Date__c = null;
                insert ag;
                newAgreement = true;

                // Forces a workflow rule to generate the agreement name
                ag.Apttus__Contract_Start_Date__c = startDate;
                ag.Apttus__Term_Months__c = 0;
                //ag.APTPS_Agreement_EndDate__c = startDate;
                update ag;
            }
        } catch (Exception e) {
            system.debug('Rajesh - ' + e.getMessage());
            ag.Apttus__Contract_Start_Date__c = startDate;
            Database.rollback(sp);
            throw e;
            //return null;
        }

        // Update contact's email address
        if (email != originalEmail) {
            Contact c = new Contact(id = ag.Apttus__Primary_Contact__c, email = email);
            Update c;
        }


        if (! newAgreement) {
            update ag;
            return new PageReference('/' + ag.id);
        }

        newAgreement = false;
        returnToPage = Page.Edit_Apttus_Deal_Lines;
        returnToPage.getParameters().put('id', ag.id);
        returnToPage.getParameters().put('showAccessories', 'true');
        return returnToPage;
    }

    public void populateChannelPartnerInfo() {
        Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();

        system.debug('Account ID (CP): ' + ag.Apttus__Account__c);
        if (channelPartner != null && channelPartner.id == ag.Apttus__Account__c)
            return;

        List<Account> accounts = [select id, name,
                    BillingStreet, BillingCity, BillingState, BillingCountry,
                    BillingPostalCode, region__c, Business_Entity_Type__c,
                    Entity_Established_State_Country__c
                    from Account where id = :ag.Apttus__Account__c];

        if (!accounts.isEmpty()) {
            channelPartner = accounts[0];
            ag.APT_Region__c = channelPartner.region__c;
            ag.APTPS_Entity_Established_State_Country__c =
                channelPartner.Entity_Established_State_Country__c;
            ag.APTPS_Type_of_Entity__c = channelPartner.Business_Entity_Type__c;
        }
    }

    public void populateMotorolaAccountInfo() {
        Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();

        if (motorolaAccount != null && motorolaAccount.Id == ag.APTPS_Motorola_Legal_Entity__c)
            return;
        List<Account> accounts = [select id, name,
                    BillingStreet, BillingCity, BillingState, BillingCountry,
                    BillingPostalCode, region__c, Business_Entity_Type__c,
                    Entity_Established_State_Country__c
                    from Account where id = :ag.APTPS_Motorola_Legal_Entity__c];

        if (!accounts.isEmpty()) {
            Account a = accounts[0];
            motorolaAccount = a;
            System.debug('Address: ' + motorolaAccount.BillingStreet);
        }
    }

    public void populateContactInfo() {
        Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();

        system.debug('Email: ' + email);

        if (localContact != null && localContact.Id == ag.Apttus__Primary_Contact__c)
            return;

        List<Contact> contacts =  [select id, email, phone, accountid, account.name
                        from Contact
                        where id = :ag.Apttus__Primary_Contact__c];

        if (!contacts.isEmpty()) {
            localContact = contacts[0];
            email = localContact.email;
            originalEmail = email; // Used to check if the user changed email address or not
            phone = localContact.phone;
        }
    }
}