public class LRBFinalDealController {

    public Contract contract { get; set; }
    public String errorMessageDate {get; set;}
    public String controllerBoolTrueVar { get; set; }
    
    public Boolean errFlag {get; set;}
    public String errorMainMessage {get; set;}        
    
    public String errorContractTerm {get; set;}
    public String errorRenewalTerm {get; set;}
    public String errorContractVolume {get; set;}
    public String errorContractValue {get; set;}
    public String errorPaymentTerm {get; set;}
    public String errorPaymentTermsDays {get; set;}
    public String errorUnusualRisks {get; set;}
    public String errorUnusualRisk {get; set;}
    public String errorIPRiskSupplier {get; set;}    
    public String errorIpRiskDetails {get; set;}
    public String errorMOTIPRisk {get; set;}
    public String errorMOTIPRiskDetails {get; set;}
    public String errorMOTIPStamp {get; set;}
    public String errorLicenseGrant {get; set;}
    public String errorLicenseGrantDetails {get; set;}
    public String errorWarrantyChanges {get; set;}
    public String errorWarrantyChangesDetails {get; set;}
    public String errorIndemnityChanges {get; set;}
    public String errorIndemnityChangesDetails {get; set;}
    public String errorLimitationOfLiabilityChanges {get; set;}
    public String errorLimitationOfLiabilityChangesDetails {get; set;}
    public String errorMotorolaRestrictions {get; set;}
    public String errorMotorolaRestrictionsDetails {get; set;}
    public String errorFinanceApprover {get; set;}
    public String errorVP {get; set;}
    public String errorAssignabilityWithoutConsent {get; set;}

    private ApexPages.StandardController controller {get; set;}
    
    public String accountName;
    public String appNames;

    public LRBFinalDealController(ApexPages.StandardController controller) {
        contract = new Contract();
        this.controller = controller;
        this.contract = (Contract)controller.getRecord();
        if(contract.One_Sentence_Description__c == null){
            List<ContApplAssoc__c> contractApps = [SELECT Id, Application__r.Name, Application__r.Account__r.Name FROM ContApplAssoc__c WHERE Contract__c =: contract.Id];
            if(!contractApps.isEmpty()){
                String accountName = contractApps[0].Application__r.Account__r.Name;
                for(ContApplAssoc__c ca : contractApps){
                    if(appNames == null){
                        appNames = ca.Application__r.Name;
                    } else {
                        appNames = appNames + ', ' + ca.Application__r.Name;
                    }
                }
                contract.One_Sentence_Description__c = 'License of the ' + appNames + ' software from ' + accountName + '.';
            }
        }
        
        if(contract.Rev_Share__c == true && contract.Payment_Terms__c == 'Receipt of Invoice'){
            contract.Payment_Terms__c = 'N/A - Has Rev Share';
        }
    }


    public PageReference submit() {
        User businesUnitReplacement = [SELECT Id FROM User WHERE firstName = 'Dan' AND lastName = 'Quicker'];

        errFlag = false;    
        errorMainMessage=null;
        
        errorContractTerm = null;
        errorRenewalTerm = null;
        errorContractVolume = null;
        errorContractValue = null;
        errorPaymentTerm = null;
        errorPaymentTermsDays = null;
        errorUnusualRisks = null;
        errorUnusualRisk = null;
        errorIPRiskSupplier = null;
        errorIpRiskDetails = null;
        errorMOTIPRisk = null;
        errorMOTIPRiskDetails = null;
        errorMOTIPStamp = null;
        errorLicenseGrant = null;
        errorLicenseGrantDetails = null; 
        errorWarrantyChanges = null;
        errorWarrantyChangesDetails = null; 
        errorIndemnityChanges = null;
        errorIndemnityChangesDetails = null;
        errorLimitationOfLiabilityChanges = null;
        errorLimitationOfLiabilityChangesDetails = null; 
        errorMotorolaRestrictions = null;
        errorMotorolaRestrictionsDetails = null;
        errorAssignabilityWithoutConsent = null; 
        errorFinanceApprover = null; 
        errorVP = null;   
        
        if(contract.ContractTerm == null){
            errorContractTerm = 'Contract Term is required.';
            errFlag = true;
        }
        
        if(contract.Renewal_Term__c == null){
            errorRenewalTerm = 'Renewal Term is required.';
            errFlag = true;
        }

        if(contract.Estimated_Lifetime_Volume__c == null){
            errorContractVolume = 'Estimated Contract Volume is required.';
            errFlag = true;
        }
        
        if(contract.Lifetime_Contract_Value__c == null){
            errorContractValue = 'Contract Value is required.';
            errFlag = true;
        }
        
        if(contract.Payment_Terms__c == null){
            errorPaymentTerm = 'Contract Value is required.';
            errFlag = true;
        }
        
        if(contract.Payment_Term_Number_of_Days__c == null){
            errorPaymentTermsDays = 'Contract Value is required.';
            errFlag = true;
        }
        
        if(contract.Any_Unusual_Risks__c == null){
            errorUnusualRisks = 'Question must be answered.';
            errFlag = true;
        }
        
        if((contract.Any_unusual_Risks__c=='Yes')&&(contract.Unusual_Risk_Details__c== null)) {
            errorUnusualRisk ='Must enter details of the unusual risks.';
            errFlag = true;
        }
        
        if((contract.Any_unusual_Risks__c=='Yes')&&(contract.Unusual_Risk_Amount__c == null)) {
            errorUnusualRisk ='Must enter the amount of the unusual risk.';
            errFlag = true;
        }
        
        if(contract.IP_Risk_Supplier_Indemnity__c == null){
            errorIPRiskSupplier = 'Question must be answered.';
            errFlag = true;
        }
        
        if((contract.IP_Risk_Supplier_Indemnity__c=='Yes')&&(contract.IP_Risk_Details__c == null)) {
            errorIpRiskDetails ='Must enter details of the IP risks.';
            errFlag = true;
        }
    
        if(contract.Risks_to_Motorola_IP__c == null){
            errorMOTIPRisk = 'Question must be answered.';
            errFlag = true;
        } 
  
        if((contract.Risks_to_Motorola_IP__c=='Yes')&&(contract.Risks_to_Motorola_IP_Details__c== null)) {
            errorMOTIPRiskDetails ='Must enter details of the risks to Motorola IP.';
            errFlag = true;
        }
        
        if((contract.Risks_to_Motorola_IP__c=='Yes')&&(contract.STAMP__c == null)) {
            errorMOTIPStamp ='Must enter STAMP approval # if there are risks to Motorola IP.';
            errFlag = true;
        }
        
        if(contract.Restrictions_on_License_Grant__c == null) {
            errorLicenseGrant ='Question must be answered.';
            errFlag = true;
        }
        
        if((contract.Restrictions_on_License_Grant__c=='Yes')&&(contract.Restrictions_on_License_Grant_Details__c== null)) {
            errorLicenseGrantDetails ='Must enter details of the restrictions on the license grant.';
            errFlag = true;
        }
        
        if(contract.Changes_to_Warranty__c == null) {
            errorWarrantyChanges ='Question must be answered.';
            errFlag = true;
        }
        
        if((contract.Changes_to_Warranty__c=='Yes')&&(contract.Changes_to_Warranty_Details__c== null)) {
            errorWarrantyChangesDetails='Must enter details of the changes to warranty.';
            errFlag = true;
        }
        
        if(contract.Changes_to_Indemnity__c == null) {
            errorIndemnityChanges ='Question must be answered.';
            errFlag = true;
        }
        
        if((contract.Changes_to_Indemnity__c=='Yes')&&(contract.Changes_to_Indemnity_Details__c== null)) {
            errorIndemnityChangesDetails='Must enter details of the changes to indemnity..';
            errFlag = true;
        }
        
        if(contract.Changes_to_Limitation_of_Liability__c == null) {
            errorLimitationOfLiabilityChanges ='Question must be answered.';
            errFlag = true;
        }
        
        if((contract.Changes_to_Limitation_of_Liability__c=='Yes')&&(contract.Change_to_Limitation_of_Liability_Detail__c== null)) {
            errorLimitationOfLiabilityChangesDetails = 'Must enter details of the changes to Limitations of Liabilities.';
            errFlag = true;
        }
        
        if(contract.Exclusivity_geography_non_compete_MFN__c == null) {
            errorMotorolaRestrictions ='Question must be answered.';
            errFlag = true;
        }
        
        if((contract.Exclusivity_geography_non_compete_MFN__c=='Yes')&&(contract.Exclusive_geo_non_compete_MFN_Detail__c== null)) {
            errorMotorolaRestrictionsDetails = 'Must enter details of the exclusivity, geographic restrictions, non-compete or MFN requirements that restricts Motorola.';
            errFlag = true;
        }
        
        if(contract.Assignability_Without_Consent__c == null) {
            errorAssignabilityWithoutConsent = 'Question must be answered.';
            errFlag = true;
        }
        
        if((contract.Business_Unit_VP_Officer__c == null)&&(contract.Business_Unit_VP_Officer_Free_Text__c == null)) {
            errorVP = 'Must select the Business Unit VP/Officer or if you cannot find the user, type the name in the alternate field to the right.';
            errFlag = true;
        }
        
        if((contract.Business_Unit_VP_Officer__c != null && contract.Business_Unit_VP_Officer__c != businesUnitReplacement.Id)&&(contract.Business_Unit_VP_Officer_Free_Text__c!= null)) {
            errorVP = 'If you have browsed for and selected a Business Unit VP/Officer do not type the name in the alternate field';
            errFlag = true;
        }
        
        
        if((contract.Business_Unit_VP_Officer__c == null)&&(contract.Business_Unit_VP_Officer_Free_Text__c != null)) {
            contract.Business_Unit_VP_Officer__c = businesUnitReplacement.Id;
        }
        
        if(contract.Requested_LRB_Final_Deal_Present_Date__c == null){         
           errorMessageDate='Must enter a value for Present Date';
           errFlag = true;
        } else {
            Datetime dt = DateTime.newInstance(contract.Requested_LRB_Final_Deal_Present_Date__c.year(), contract.Requested_LRB_Final_Deal_Present_Date__c.month(), contract.Requested_LRB_Final_Deal_Present_Date__c.day());
            String day = dt.format('EEEE');        
            if ((day != 'Tuesday') && (day != 'Thursday') ){          
               errorMessageDate='Date should either be a Tuesday or Thursday';
               errFlag = true;
            }
        }
        
        If(errFlag == true) {
            errorMainMessage='Check the errors';
            return null;
        }
        
        errorMainMessage=null;
        errFlag = false;
        errorUnusualRisk = null;
        
        update contract;
        //return Page.LRBFinalDealRequestSuccess;
        return new PageReference('/' + contract.Id);
    }
    
    public PageReference submitWithoutChecks() {       
        update contract;
        //return Page.LRBFinalDealRequestSuccess;
        return new PageReference('/' + contract.Id);
    }
      

/*    public PageReference cancelmainform() {
        return new PageReference('/' + contract.Id);
    }
*/

    static testMethod void LBFinalDealControllerTest(){
        PageReference pageRef = Page.LRBFinalDealRequest;
        
        Account a = new Account(Name='a', Tier__c ='1');
        insert a;
        Application__c app1 = new Application__c(Name='app1', Account__c = a.Id);
        Application__c app2 = new Application__c(Name='app2', Account__c = a.Id);
        insert new List<Application__c>{app1, app2};
        Contract c = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today(),Rev_Share__c = true, Payment_Terms__c = 'Receipt of Invoice');
        insert c;
        ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c = c.Id, Application__c = app1.Id);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c = c.Id, Application__c = app2.Id);
        insert new List<ContApplAssoc__c>{ca1, ca2};
        
        Apexpages.StandardController finalDealController = new Apexpages.standardController(c);
        pageRef.getParameters().put('id', c.id);

        test.setCurrentPage(pageRef);
        
        LRBFinalDealController myPageCon = new LRBFinalDealController(finalDealController);
        
        PageReference pf = myPageCon.submitWithoutChecks();
        pf = myPageCon.submit();
        
        c.Business_Unit_VP_Officer_Free_Text__c = 'My Name';
        c.Business_Unit_VP_Officer__c = UserInfo.getUserId();
        pf = myPageCon.submit();
        
        c.Business_Unit_VP_Officer__c = null;
        c.Payment_Terms__c = null;
        c.Any_Unusual_Risks__c = 'Yes';
        c.IP_Risk_Supplier_Indemnity__c = 'Yes';
        c.Risks_to_Motorola_IP__c = 'Yes';
        c.Restrictions_on_License_Grant__c = 'Yes';
        c.Changes_to_Warranty__c = 'Yes';
        c.Changes_to_Indemnity__c = 'Yes';
        c.Changes_to_Limitation_of_Liability__c = 'Yes';
        c.Exclusivity_geography_non_compete_MFN__c = 'Yes';
        c.Requested_LRB_Final_Deal_Present_Date__c = Date.newInstance(2011, 12, 7);
        pf = myPageCon.submit();
        
        c.Business_Unit_VP_Officer_Free_Text__c = null;        
        c.Payment_Terms__c = 'Receipt of Invoice';
        c.Any_Unusual_Risks__c = 'No';
        c.IP_Risk_Supplier_Indemnity__c = 'No';
        c.Risks_to_Motorola_IP__c = 'No';
        c.Restrictions_on_License_Grant__c = 'No';
        c.Changes_to_Warranty__c = 'No';
        c.Changes_to_Indemnity__c = 'No';
        c.Changes_to_Limitation_of_Liability__c = 'No';
        c.Exclusivity_geography_non_compete_MFN__c = 'No';
        c.Requested_LRB_Final_Deal_Present_Date__c = Date.newInstance(2011, 12, 6);
        c.Assignability_Without_Consent__c = 'value';
        c.ContractTerm = 5;
        c.Renewal_Term__c = 10;
        c.Estimated_Lifetime_Volume__c = 10;
        c.Lifetime_Contract_Value__c = 100.00;
        c.Payment_Terms__c = 'value';
        c.Payment_Term_Number_of_Days__c = 5;
        pf = myPageCon.submit();
    }
}