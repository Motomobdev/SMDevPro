public with sharing class LRBInitialDealController{ 

    private ApexPages.StandardController controller {get; set;}
    
    /******************************************************************************************
                Class Variables
    ******************************************************************************************/  
    
    public Boolean Flag {get; set;}
    public Device__c device { get; set; }
    public Contract contract { get; set; }

    public Contract_Bundling_Contract__c bundlingContract { get; set; }
    public Contract_Apply_Rules_Contract__c applyRulesContract { get; set; }

    public boolean controllerBoolTrueVar { get; set; }
    public ContApplAssoc__c varLQA1 { get; set; }    
    public List<String> aNames{get;set;}
    public List<ContApplAssoc__c> appNameList{get;set;}
    public Application__c appName;
    public List<ContApplAssoc__c> contractApp = new List<ContApplAssoc__c>{};
    public List<ContApplAssoc__c> contractAppExisting = new List<ContApplAssoc__c>{};
    public Contract_Platform__c varContPlat { get; set; }
    public List<Contract_Platform__c> contractPlatform = new List<Contract_Platform__c> {};
    public Platform__c platformName;
    public List<String> pNames{get;set;}
    public Contract_Stable__c varContStab { get; set; }
    public List<Contract_Stable__c> contractStable = new List<Contract_Stable__c> {};
    public Stable__c stableName;
    public List<String> sNames{get;set;}       
    public Application_Country__c varAppCountry { get; set; }
    public List<Application_Country__c> applicationCountry = new List<Application_Country__c> {};
    public Country__c countryName;
    public List<String> cNames{get;set;}
    public boolean errFlag {get; set;}
    public String errorMessageDate {get; set;}
    public String errorMessageApp {get; set;}
    public String errorMessagePlatform {get; set;}
    public String errorMessageStable {get; set;}
    public String errorMessageCountry {get; set;}
    public String errorMessageRateBasedRoyalty {get; set;}
    public String errorMessageBundlingDiscount {get; set;}
    public String errorMessageOtherDiscount {get; set;}
    public String errorMessageLicenseFee {get; set;}
    public String errorMessageMinGuarantee {get; set;}
    public String errorMessageNonRoyaltyCostRule {get; set;}
    public String errorMessageSubmit {get; set;}
    public String errorMessageDevice {get; set;}
    public String errorRevShare {get; set;}
    
    
    public String errorBusNeed {get; set;}
    public String errorBusOwner {get; set;}
    public String errorBusModel {get; set;}
    public String errorRequestCoverage {get; set;}
    public String errorIntendedUse {get; set;}
    public String errorSWstable {get; set;}
    public String errorBusUnit {get; set;}
    public String errorMotoEntity {get; set;}
    public String errorFinApproval {get; set;}
    public String errorCostCenter {get; set;}
    public String errorMultiDevDetail {get; set;}
    public String errorMainMessage {get; set;}
    public String errorNoRowsEntered {get; set;}
    public String errorLeadDevice {get; set;}
    
    public boolean countryFlag {get; set;}
    public Map<String, String> AppNameMap {get;set;}    
    public String ContId {get;set;}
    
    public static Integer toDelIdent {get; set;}
    
    public String businessModelHelpText;
    
    public List<wrapRateBasedRoyalty> wrapRateList {get;set;}
    public Contract_Rate_Based_Royalty__c rateBasedRoyalty { get; set; }      
    private Integer nextRateId=0;
    public List<Contract_Rate_Based_Royalty__c> deleteRateList = new List<Contract_Rate_Based_Royalty__c>();
    
    public List<wrapRateBasedRoyaltyRow> wrapRateRowList {get;set;}
    public Contract_Rate_Based_Royalty_Row__c rateBasedRoyaltyRow { get; set; }      
    private Integer nextRateRowId=0;
    public List<Contract_Rate_Based_Royalty_Row__c> deleteRateRowList = new List<Contract_Rate_Based_Royalty_Row__c>();
    
    public List<wrapBundlingDiscount> wrapBundlingDiscountList {get;set;}
    public Contract_Bundling_Discount__c bundlingDiscount { get; set; }
    private Integer nextBundlingDiscountId=0;
    public List<Contract_Bundling_Discount__c> deleteBundlingDiscountList = new List<Contract_Bundling_Discount__c>();
    
    public List<wrapOtherDiscount> wrapOtherDiscountList {get;set;}
    public Contract_Royalty_Rule_Other_Discount__c otherDiscount { get; set; }
    private Integer nextOtherDiscountId=0;
     public List<Contract_Royalty_Rule_Other_Discount__c> deleteOtherDiscountList = new List<Contract_Royalty_Rule_Other_Discount__c>();
    
    public List<wrapLicenseFee> wrapLicenseFeeList {get;set;}
    public Contract_Non_Rate_Based_License_Fee__c licenseFee { get; set; }
    private Integer nextLicenseFeeId=0;
     public List<Contract_Non_Rate_Based_License_Fee__c> deleteLicenseFeeList = new List<Contract_Non_Rate_Based_License_Fee__c>();
    
    public List<wrapMinGuarantee> wrapMinGuaranteeList {get;set;}
    public Contract_NonRate_Based_Minimum_Guarantee__c minGuarantee { get; set; }
    private Integer nextMinGuaranteeId=0;
     public List<Contract_NonRate_Based_Minimum_Guarantee__c> deleteMinGuaranteeList = new List<Contract_NonRate_Based_Minimum_Guarantee__c>();
    
    public List<wrapNonRoyaltyCostRule> wrapNonRoyaltyCostRuleList {get;set;}
    public Contract_Non_Royalty_Cost_Rule__c nonRoyaltyCostRule { get; set; }      
    private Integer nextRoyaltyCostRuleId=0;
     public List<Contract_Non_Royalty_Cost_Rule__c> deleteNonRoyaltyCostRuleList = new List<Contract_Non_Royalty_Cost_Rule__c>();
    
    public List<wrapLeadDevice> wrapLeadDeviceList {get;set;}
    public List<ContractDeviceAssoc__c> contractDeviceList;
    public ContractDeviceAssoc__c contractDevice {get;set;}
    public List<wrapApplicationName> wrapApplicationNameList {get; set;} 
    
    public List<ContApplAssoc__c> conAppsWithExistingRateTables {get; set;} 

        /******************************************************************************************
                Contstructor
    ******************************************************************************************/  
    
    public LRBInitialDealController(ApexPages.StandardController controller) {
        contract = new Contract();
        this.controller = controller;
        this.contract = (Contract)controller.getRecord();
        ContId = contract.Id;
        //ContId=ApexPages.currentPage().getParameters().get('id');
        device = new Device__c();
        rateBasedRoyalty = new Contract_Rate_Based_Royalty__c ();
        rateBasedRoyalty.Contract__c = contract.Id;
        rateBasedRoyaltyRow = new Contract_Rate_Based_Royalty_Row__c ();
        bundlingDiscount = new Contract_Bundling_Discount__c();
        otherDiscount = new Contract_Royalty_Rule_Other_Discount__c();
        nonRoyaltyCostRule = new Contract_Non_Royalty_Cost_Rule__c();
        licenseFee = new Contract_Non_Rate_Based_License_Fee__c();       
        minGuarantee = new Contract_NonRate_Based_Minimum_Guarantee__c();       
        bundlingContract = new Contract_Bundling_Contract__c();
        applyRulesContract = new Contract_Apply_Rules_Contract__c();
        varLQA1 = new ContApplAssoc__c();        
        aNames= new List<String>();  
        appNameList = new List<ContApplAssoc__c>();                    
        varContPlat = new Contract_Platform__c(); 
        pNames= new List<String>();
        varContStab = new Contract_Stable__c();
        sNames = new List<String>();
        varAppCountry = new Application_Country__c(); 
        cNames= new List<String>();    
        countryFlag = True;
        Flag=false;
        AppNameMap = new Map<String, String>();
        wrapRateList = new List<wrapRateBasedRoyalty> ();
        wrapRateRowList = new List<wrapRateBasedRoyaltyRow> ();
        wrapNonRoyaltyCostRuleList = new List<wrapNonRoyaltyCostRule> ();
        wrapBundlingDiscountList = new List<wrapBundlingDiscount> ();
        wrapOtherDiscountList = new List<wrapOtherDiscount> ();
        wrapLicenseFeeList = new List<wrapLicenseFee> ();
        wrapMinGuaranteeList = new List<wrapMinGuarantee> ();
        contractDeviceList = new List<ContractDeviceAssoc__c>();
        contractDevice = new ContractDeviceAssoc__c();
        wrapLeadDeviceList = new List<wrapLeadDevice> ();
        wrapApplicationNameList = new List<wrapApplicationName>();
        conAppsWithExistingRateTables = new List<ContApplAssoc__c>();
        
        businessModelHelpText = 'What revenue model is the partner using for this specific product      license (zero cost, rev share, freemium, one time buyout, in-kind marketing, etc.) \n Edit prepoulated text data and add free text at the end to add any additional business model details.  Minimum guarantee should reflect payments in the future (as opposed to a prepay).';
                
        //Get list of exixting Applications for the Contract
       /* appNameList = [SELECT Id, Application__c, Application__r.Name, Contract__c, Governing_End_Date__c, Contract_Rate_Based_Royalty_Table__c FROM ContApplAssoc__c WHERE Contract__c=:contract.Id];
        for(Integer i=0;i<appNameList.size();i++){
            Application__c tempApp = [Select Id, Name From Application__c Where Id=:appNameList[i].Application__c];                     
            aNames.add(tempApp.Name); 
            AppNameMap.put(tempApp.Id,tempApp.Name);
            if(appNameList[i].Contract_Rate_Based_Royalty_Table__c == null){
                wrapApplicationNameList.add(new wrapApplicationName(tempApp.Name, ca.Application__c, false));
            }             
        }*/
        appNameList = [SELECT Id, Application__c,Application__r.Name, Contract__c, Governing_End_Date__c, Contract_Rate_Based_Royalty_Table__c, Contract_Rate_Based_Royalty_Table__r.Name FROM ContApplAssoc__c WHERE Contract__c=:contract.Id];
        for(ContApplAssoc__c ca : appNameList){
                contractApp.add(ca);
                aNames.add(ca.Application__r.Name); 
            AppNameMap.put(ca.Application__c,ca.Application__r.Name);
            if(ca.Contract_Rate_Based_Royalty_Table__c == null){
                wrapApplicationNameList.add(new wrapApplicationName(ca.Application__r.Name, ca.Application__c, false));
            } else {
                conAppsWithExistingRateTables.add(ca);
            }
        }
        
        //Get list of exixting Platforms for the Contract
        contractPlatform = [SELECT Id, Platform__c, Contract__c FROM Contract_Platform__c WHERE Contract__c=:contract.Id];
        for(Integer i=0;i<contractPlatform.size();i++){
            Platform__c tempPlatform = [Select Id, Name From Platform__c Where Id=:contractPlatform[i].Platform__c];                     
            pNames.add(tempPlatform.Name);                
        }
        
        //Get list of exixting Stables for the Contract
        contractStable = [SELECT Id, Stable__c, Contract__c FROM Contract_Stable__c WHERE Contract__c=:contract.Id];
        for(Integer i=0;i<contractStable .size();i++){
            Stable__c tempStable = [Select Id, Name From Stable__c Where Id=:contractStable [i].Stable__c];                     
            sNames.add(tempStable.Name);                
        }
        
        String objectName = 'Contract_Rate_Based_Royalty__c';
        buildQuery(objectName, ContId);
        
        objectName = 'Contract_Bundling_Discount__c';
        buildQuery(objectName, ContId);
        
        objectName = 'Contract_Royalty_Rule_Other_Discount__c';
        buildQuery(objectName, ContId);
        
        objectName = 'Contract_Non_Rate_Based_License_Fee__c';
        buildQuery(objectName, ContId);
        
        objectName = 'Contract_NonRate_Based_Minimum_Guarantee__c';
        buildQuery(objectName, ContId);
        
        objectName = 'Contract_Non_Royalty_Cost_Rule__c';
        buildQuery(objectName, ContId);       
    }
    
    public String getbusinessModelHelpText(){
        businessModelHelpText = businessModelHelpText.replaceAll('\n', '<br/>');
        return businessModelHelpText;
    }
    
    /******************************************************************************************
                Fill in Royalty Rule
    ******************************************************************************************/  
    private void buildQuery(String oName, String contractId){
        String objectName = oName;
        String ContId = contractId;  
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

        for(String s : objectFields.keySet()) {
           query += ' ' + s + ',';
        }

        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        }       

        query += ' FROM ' + objectName;
        query += ' WHERE Contract__c=\''+ContId+'\''; 
        
        If (objectName == 'Contract_Rate_Based_Royalty__c'){
            List<Contract_Rate_Based_Royalty__c> tempFinRule = new List<Contract_Rate_Based_Royalty__c>();       
            try {
                tempFinRule = database.query(query);                
            } catch (QueryException e){ }
        
            for (Integer i=0;i<tempFinRule.size();i++){        
                wrapRateList.add(new wrapRateBasedRoyalty (tempFinRule[i], nextRateId++));
            }
        }
        
        If (objectName == 'Contract_Bundling_Discount__c'){
            List<Contract_Bundling_Discount__c> tempFinRule = new List<Contract_Bundling_Discount__c>();       
            try {
                tempFinRule = database.query(query);                
            } catch (QueryException e){ }
        
            for (Integer i=0;i<tempFinRule.size();i++){        
                wrapBundlingDiscountList.add(new wrapBundlingDiscount (tempFinRule[i], nextBundlingDiscountId++));
            }
        }
        
        If (objectName == 'Contract_Royalty_Rule_Other_Discount__c'){
            List<Contract_Royalty_Rule_Other_Discount__c> tempFinRule = new List<Contract_Royalty_Rule_Other_Discount__c>();       
            try {
                tempFinRule = database.query(query);                
            } catch (QueryException e){ }
        
            for (Integer i=0;i<tempFinRule.size();i++){        
                wrapOtherDiscountList.add(new wrapOtherDiscount (tempFinRule[i], nextOtherDiscountId++));
            }
        }
        
        If (objectName == 'Contract_Non_Rate_Based_License_Fee__c'){
            List<Contract_Non_Rate_Based_License_Fee__c> tempFinRule = new List<Contract_Non_Rate_Based_License_Fee__c>();       
            try {
                tempFinRule = database.query(query);                
            } catch (QueryException e){ }
        
            for (Integer i=0;i<tempFinRule.size();i++){        
                wrapLicenseFeeList.add(new wrapLicenseFee (tempFinRule[i], nextLicenseFeeId++));
            }
        }
        
        If (objectName == 'Contract_NonRate_Based_Minimum_Guarantee__c'){
            List<Contract_NonRate_Based_Minimum_Guarantee__c> tempFinRule = new List<Contract_NonRate_Based_Minimum_Guarantee__c>();       
            try {
                tempFinRule = database.query(query);                
            } catch (QueryException e){ }
        
            for (Integer i=0;i<tempFinRule.size();i++){        
                wrapMinGuaranteeList.add(new wrapMinGuarantee (tempFinRule[i], nextMinGuaranteeId++)); 
            }
        }
        
        If (objectName == 'Contract_Non_Royalty_Cost_Rule__c'){
            List<Contract_Non_Royalty_Cost_Rule__c> tempFinRule = new List<Contract_Non_Royalty_Cost_Rule__c>();       
            try {
                tempFinRule = database.query(query);                
            } catch (QueryException e){ }
        
            for (Integer i=0;i<tempFinRule.size();i++){        
                wrapNonRoyaltyCostRuleList.add(new wrapNonRoyaltyCostRule (tempFinRule[i], nextRoyaltyCostRuleId++));
            }
        }

    }
    
    /****************************************************************************************************************************************************
                Methods for next/previous buttons
    ****************************************************************************************************************************************************/  
    public PageReference nextAppLegalCountries() {
        errorMainMessage=null;
        errFlag = false;
        
        errorBusNeed=null;
        errorMessageApp = null;
        errorMessageDate=null;
        errorBusOwner=null;
        errorBusModel=null;
        errorRequestCoverage=null;
        errorIntendedUse=null;
        errorSWstable=null;
        errorBusUnit=null;
        errorMotoEntity=null;
        errorFinApproval=null;
        errorCostCenter=null;
        errorMultiDevDetail=null;
        errorMessagePlatform=null;
        errorMessageStable = null;
        errorRevShare=null;
        errorMessageApp=null;
        errorNoRowsEntered=null;
        errorLeadDevice=null;
        
        if(contract.Business_Need__c == null) {
            errorBusNeed='Must enter a value for Business Need';
            errFlag = true;
        }
        
        if(anames.size() <= 0){
            errorMessageApp='Must select atleast one Application';
            errFlag = true;
        }
        
        if(contract.Requested_LRB_Initial_Deal_Present_Date__c == null){
            Date d = contract.Requested_LRB_Initial_Deal_Present_Date__c;
            If ((d == null)){         
               errorMessageDate='Must enter a value for Date';
               errFlag = true;
               //return null;
            }        
            
         } else {
             Date d = contract.Requested_LRB_Initial_Deal_Present_Date__c;
             Datetime dt = DateTime.newInstance(d.year(), d.month(), d.day());
             String day = dt.format('EEEE');        
             If ((d != null) && (day != 'Tuesday') && (day != 'Thursday') ){         
                 errorMessageDate='Date should either be a Tuesday or Thursday';
                 errFlag = true;
                 //return null;
             }
         }
        
        If(contract.Business_Owner__c == null) {
            errorBusOwner='Must enter a value for Business Owner';
            errFlag = true;
        }
        
        if(contract.Business_Model__c == null) {
            errorBusModel='Must enter a value for Business Model';
            errFlag = true;
        }
        
        if(contract.Request_covers_1_or_more_devices__c == null) {
            errorRequestCoverage='Must answer question';
            errFlag = true;
        }
        
        If(contract.Intended_Use_in_Motorola_products__c == null) {
            errorIntendedUse='Must enter a value for Intended Use in Motorola Products';
            errFlag = true;
        } 
        
        If(contract.Software_planned_to_be_part_of_stable__c == null) {
            errorSWstable='Must answer question';
            errFlag = true;
        }
        
        if((contract.Software_planned_to_be_part_of_stable__c == 'Yes') && (contractStable.size()==0)){
            errorMessageStable='Must enter a value for Stable';
            errFlag = true;
        }
        
        if((contract.Software_planned_to_be_part_of_stable__c == 'No') && (contractPlatform.size()==0)){
            errorMessagePlatform='Must enter a value for Platform';
            errFlag = true;
        } 
        
        If((contract.Rev_Share__c == true) && (contract.Rev_Share_Details__c==null)){
            errorRevShare='Must enter a value for Revenue Share Details';
            errFlag = true;
        }
        
        If(contract.BusinessUnit__c == null) {
            errorBusUnit='Must enter a value for Business Unit';
            errFlag = true;
        }              
        
        If(contract.Motorola_Entity__c == null) {
            errorMotoEntity='Must enter a value for Motorola Entity';
            errFlag = true;
        }
        
        if(contract.Motorola_Entity__c != null && contract.Motorola_Entity__c != 'Motorola Mobility Inc' && contract.Tax_Approval_For_Non_MMI_Entity__c == null) {
            errorMotoEntity='Must answer if tax approval been given for this non MMI entity?';
            errFlag = true;
        }
        
        if(contract.Business_Unit_Type__c == null) {
            errorFinApproval='Must select a value for Business Unit Type/Secondary Finance Approver';
            errFlag = true;
        }
        
        If((contract.Is_There_NRE__c=='Yes')&&(contract.Cost_Center__c == null)) {
            errorCostCenter='Must enter a value for Cost Center';
            errFlag = true;
        }
        
        if(contract.Lead_Device__c == null){
                errorLeadDevice='Select a Lead Device or select the Device named "None" if there is no Lead Device.';
                errFlag = true;
        }
        
        //If((contract.Request_covers_1_or_more_devices__c=='Multiple Devices')&&(contract.Request_covers_1_or_more_devices_Detail__c == null)) {
        //    errorMultiDevDetail='Must enter a value';
        //    errFlag = true;
        //}
        
        If(errFlag == true) {
            errorMainMessage='Check the errors';
            return null;
        }
        
        errorMainMessage=null;
        errFlag = false;
        errorMessageDate=null;
        errorBusNeed=null;
        errorBusModel=null;
        errorIntendedUse=null;
        errorSWstable=null;
        errorBusUnit=null;
        errorMotoEntity=null;
        errorFinApproval=null;
        errorCostCenter=null;
        errorMultiDevDetail=null;
        errorMessagePlatform=null;
        errorMessageStable=null;        
        errorRevShare=null;
        errorMessageApp=null;
        errorNoRowsEntered=null;
        errorLeadDevice=null;
          
        //PageReference pr = new PageReference('/apex/LRBAddAppLegalCountries?id=' + contract.Id);
        //return pr.setRedirect(false);      
        if(wrapApplicationNameList.size() == 1 && wrapApplicationNameList[0].appName == 'None'){
                return Page.LRBAccountingMemo;
        }
        return Page.LRBAddAppLegalCountries;
    }
    
    public PageReference nextAppAvailCountries() {        
        return Page.LRBAddAppCountries;
        //PageReference pr = new PageReference('/apex/LRBAddAppCountries?id=' + contract.Id);
        //return pr.setRedirect(false);  
    }
        
    public PageReference nextCreateRateTableForSelectedApps1(){
        return Page.LRBCreateRateBasedRoyaltyRule1;
        /*if(!wrapApplicationNameList.isEmpty()){
                        return Page.LRBCreateRateBasedRoyaltyRule1;
        }
        return Page.LRBAccountingMemo;*/
                /*PageReference pr = new PageReference('/apex/LRBCreateRateBasedRoyaltyRule1?id=' + contract.Id);
        return pr.setRedirect(false);*/  
    }
    
    public PageReference nextCreateRateTableForSelectedApps2(){
        return Page.LRBCreateRateBasedRoyaltyRule2;
        //PageReference pr = new PageReference('/apex/LRBCreateRateBasedRoyaltyRule2?id=' + contract.Id);
        //return pr.setRedirect(false);  
    }
       
    public PageReference nextAccMemo() { 
        errorMessageRateBasedRoyalty = null;    
        return Page.LRBAccountingMemo;
        //PageReference pr = new PageReference('/apex/LRBAccountingMemo?id=' + contract.Id);
        //return pr.setRedirect(false);  
    }

    public PageReference mainform() {
        errorMessageRateBasedRoyalty = null;
        return Page.LRBInitialDealRequest;
        //PageReference pr = new PageReference('/apex/LRBInitialDealRequest?id=' + contract.Id);
        //return pr.setRedirect(false);
    }
    
    public PageReference previousAppLegalCountries() {
        errorMessageRateBasedRoyalty = null;        
        return Page.LRBAddAppLegalCountries;
    }
    
    public PageReference previousAppAvailableCountries() {
        errorMessageRateBasedRoyalty = null;
                
        return Page.LRBAddAppCountries;
    }
    
    public pageReference previousCreateRateTableForSelectedApps1(){
        if(wrapApplicationNameList.size() == 1 && wrapApplicationNameList[0].appName == 'None'){
                return Page.LRBInitialDealRequest;
        }
                //if(!wrapApplicationNameList.isEmpty()){
                        return Page.LRBCreateRateBasedRoyaltyRule1;
        //}
        //return Page.LRBAddAppCountries;
    }
    
    public Boolean getareThereMoreAppsToAddRateTables(){
        if(!wrapApplicationNameList.isEmpty()){
                return false;
        }
        return true;
    }
    
    public PageReference cancelmainform() {
         return new PageReference('/' + contract.Id);
    }
    /*public PageReference home() {       
        return controller.view();
    }

    public PageReference previousAccMemo() {      
        return Page.LRBAccountingMemo;        
    }    
    */

     

    /****************************************************************************************************************************************************
                Methods for Submit button
    ****************************************************************************************************************************************************/  
    public PageReference submit() {
        try {        
        controllerBoolTrueVar = False;
        update contract;
        
        bundlingContract.Contract_Master__c = contract.Id;
        
        If(wrapRateList.size() > 0) {
            List<Contract_Rate_Based_Royalty__c> saveRateBasedRoyaltyList = new List<Contract_Rate_Based_Royalty__c> {};
            for (wrapRateBasedRoyalty wrap : wrapRateList){
                saveRateBasedRoyaltyList.add(wrap.rateBasedRoyaltyList );
            }
            upsert saveRateBasedRoyaltyList;
        }                
        
        If(wrapBundlingDiscountList.size() > 0) {
            List<Contract_Bundling_Discount__c> saveBundlingDiscountList = new List<Contract_Bundling_Discount__c> {};
            for (wrapBundlingDiscount wrap : wrapBundlingDiscountList){
                saveBundlingDiscountList.add(wrap.bundlingDiscountList);
            }
            upsert saveBundlingDiscountList;
        }
        
        If(wrapOtherDiscountList.size() > 0) {
            List<Contract_Royalty_Rule_Other_Discount__c> saveOtherDiscountList = new List<Contract_Royalty_Rule_Other_Discount__c> {};
            for (wrapOtherDiscount wrap : wrapOtherDiscountList){
                saveOtherDiscountList.add(wrap.otherDiscountList);
            }
            upsert saveOtherDiscountList;
        }
        
        If(wrapLicenseFeeList.size() > 0) {
            List<Contract_Non_Rate_Based_License_Fee__c> saveLicenseFeeList = new List<Contract_Non_Rate_Based_License_Fee__c> {};
            for (wrapLicenseFee wrap : wrapLicenseFeeList){
                saveLicenseFeeList.add(wrap.licenseFeeList);
            }
            upsert saveLicenseFeeList;
        } 
        
        If(wrapMinGuaranteeList.size() > 0) {
            List<Contract_NonRate_Based_Minimum_Guarantee__c> saveMinGuaranteeList = new List<Contract_NonRate_Based_Minimum_Guarantee__c> {};
            for (wrapMinGuarantee wrap : wrapMinGuaranteeList){
                saveMinGuaranteeList.add(wrap.minGuaranteeList);
            }
            upsert saveMinGuaranteeList;
        }                
                        
        If(wrapNonRoyaltyCostRuleList.size() > 0) {
            List<Contract_Non_Royalty_Cost_Rule__c> saveNonRoyaltyCostRuleList = new List<Contract_Non_Royalty_Cost_Rule__c> {};
            for (wrapNonRoyaltyCostRule wrap : wrapNonRoyaltyCostRuleList){
                saveNonRoyaltyCostRuleList.add(wrap.nonRoyaltyCostRuleList);
            }
            upsert saveNonRoyaltyCostRuleList;
        }
        
        If(deleteRateList.size() > 0) {
            delete deleteRateList;            
        }
        
        If(deleteBundlingDiscountList.size() > 0) {
            delete deleteBundlingDiscountList;            
        }
        
        If(deleteOtherDiscountList.size() > 0) {
            delete deleteOtherDiscountList;            
        }
        
        If(deleteLicenseFeeList.size() > 0) {
            delete deleteLicenseFeeList;            
        }
        
        If(deleteMinGuaranteeList.size() > 0) {
            delete deleteMinGuaranteeList;            
        }
        
        If(deleteNonRoyaltyCostRuleList.size() > 0) {
            delete deleteNonRoyaltyCostRuleList;            
        }
        
        If(bundlingContract.Contract_Related__c != null) {
            upsert bundlingContract;
        }
        
        If(applyRulesContract.Contract_Related__c != null) {
            applyRulesContract.Contract_Master__c = contract.Id;
            upsert applyRulesContract;
        }
                
        If(contractApp.size() > 0) {
            upsert contractApp;
        }
        
        If(contractPlatform.size() > 0) {
            upsert contractPlatform;
        }
        
        If(contractStable.size() > 0) {
            upsert contractStable;
        }
        
        If(applicationCountry.size() > 0) {
            upsert applicationCountry;
        }
        
        } catch (System.Exception e){            
            errorMessageSubmit = 'Error submitting the Form';
            return null;        
        }
        errorMessageSubmit = '';
        //return Page.LRBInitialDealRequestSuccess;
        //PageReference pageRef = new PageReference('/apex/LRBInitialDealRequestSuccess');
        //pageRef.setRedirect(true);
        //return pageRef;
        return new PageReference('/' + contract.Id);
    }
    
        /****************************************************************************************************************************************************
                Rate Based Royalty Rule Table methods
    ****************************************************************************************************************************************************/
    
    Boolean wrapApplicationNameAllSelected = false;
    public void selectAllAppsInWrapAppNameList(){
        if(!wrapApplicationNameList.isEmpty()){
                if(wrapApplicationNameAllSelected == false){
                        for(wrapApplicationName wan : wrapApplicationNameList){
                                wan.selected = true;
                        }
                        wrapApplicationNameAllSelected = true;
                } else {
                        for(wrapApplicationName wan : wrapApplicationNameList){
                                wan.selected = false;
                        }
                        wrapApplicationNameAllSelected = false;
                }
        }
    }
    
        /****************************************************************************************************************************************************
                Save Royalty Rule methods
    ****************************************************************************************************************************************************/  
    
    public void saveRateBasedRoyaltyRow() { 
        errorMessageRateBasedRoyalty = null;
               
        Boolean checkNewTierFlag = false;
        for(Integer i=0; i<wrapRateRowList.size(); i++){
            if (rateBasedRoyaltyRow.Tier__c == wrapRateRowList[i].rateBasedRoyaltyRowList.Tier__c){
                checkNewTierFlag = true;
                break;
            }
        }
            
        If (checkNewTierFlag == false) {                
            Contract_Rate_Based_Royalty_Row__c tempRoyaltyRow = new Contract_Rate_Based_Royalty_Row__c ();
            tempRoyaltyRow.High_Volume__c = rateBasedRoyaltyRow.High_Volume__c;
            tempRoyaltyRow.Low_Volume__c = rateBasedRoyaltyRow.Low_Volume__c;
            tempRoyaltyRow.Rate_per_Unit__c = rateBasedRoyaltyRow.Rate_per_Unit__c;
            tempRoyaltyRow.Tier__c = rateBasedRoyaltyRow.Tier__c;

            wrapRateRowList.add(new wrapRateBasedRoyaltyRow (tempRoyaltyRow, nextRateRowId++));
        } else {
            errorMessageRateBasedRoyalty = 'Tier:  ' + rateBasedRoyaltyRow.Tier__c + ' already exists';
        }
       
        rateBasedRoyaltyRow = new Contract_Rate_Based_Royalty_Row__c ();
    }
    
    public PageReference addRateTableToContractAppAndSaveAtCurrentLocation(){
        addRateTableToContractApp();
        return submit();
    }
    
    public PageReference addRateTableToContractAppAndGoToNextScreen(){
        addRateTableToContractApp();
        if(wrapApplicationNameList.size() > 0){
                system.debug('TRY TO SEND BACK TO SELECT MORE APPS');
                return nextCreateRateTableForSelectedApps1();
        } 

                system.debug('TRY TO SEND FORWARD TO ACCTMEMO');
                return nextAccMemo();
    }
    
    public PageReference addRateTableToContractApp(){
        if(wrapRateRowList.isEmpty()){
                errorNoRowsEntered = 'There must be at least one row entered.';
                errFlag = true;
                return null;
        }
        errFlag = false;
        errorNoRowsEntered = null;
        
        //pull all existing Rate Tables so that you can find what to number the new one
                system.debug('TABLE NAME: ' + rateBasedRoyalty.Name);
                try{
                        system.debug('QUERY FOR ALL TABLES');
                List<Contract_Rate_Based_Royalty__c> existingTables = [SELECT Id, Name FROM Contract_Rate_Based_Royalty__c WHERE Contract__c =: rateBasedRoyalty.Contract__c ORDER BY Name];
                //Integer size = existingTables.size() + 1;
                String Stringsize = String.valueOf(existingTables.size() + 1);
                system.debug('stringsize ' + stringsize);
                if(stringsize.length() == 1){
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT000' + stringsize;
                } else if(stringsize.length() == 2){
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT00' + stringsize;
                } else if(stringsize.length() == 3){
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT0' + stringsize;
                } else {
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT' + stringsize;
                } 
                } catch (System.Queryexception e){
                        // there are no existing tables, so make this the first one
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT0001';
                }       
                system.debug('TABLE NAME: ' + rateBasedRoyalty.Name);
        
        insert rateBasedRoyalty;
        system.debug('rateBasedRoyalty.id: ' + rateBasedRoyalty.id);
        
        List<Contract_Rate_Based_Royalty_Row__c> crrbrToInsert = new List<Contract_Rate_Based_Royalty_Row__c>();
        for(wrapRateBasedRoyaltyRow wrbrr : wrapRateRowList){
                wrbrr.rateBasedRoyaltyRowList.Contract_Rate_Based_Royalty__c = rateBasedRoyalty.Id;
                crrbrToInsert.add(wrbrr.rateBasedRoyaltyRowList);
        }
        
        insert crrbrToInsert;
        system.debug('wrapAppNameList: ' + wrapApplicationNameList);
        for(Integer i=0; i<wrapApplicationNameList.size(); i++){
                if(wrapApplicationNameList[i].selected == true){
                        system.debug('selected appName: ' + wrapApplicationNameList[i].appName);
                        for(ContApplAssoc__c caa : contractApp){
                                system.debug('ConApp.appId / wrapAppId: ' + caa.Application__c + ' / ' + wrapApplicationNameList[i].appId);
                                if(caa.Application__c == wrapApplicationNameList[i].appId){
                                        caa.Contract_Rate_Based_Royalty_Table__c = rateBasedRoyalty.Id; 
                                        conAppsWithExistingRateTables.add(caa);
                                }
                        }
                        wrapApplicationNameList.remove(i);
                        i--;
                }
        }
        upsert contractApp;
        conAppsWithExistingRateTables = [SELECT Id, Application__c,Application__r.Name, Contract__c, Governing_End_Date__c, Contract_Rate_Based_Royalty_Table__c, Contract_Rate_Based_Royalty_Table__r.Name FROM ContApplAssoc__c WHERE Id IN : conAppsWithExistingRateTables AND Contract_Rate_Based_Royalty_Table__c != null];
        
        rateBasedRoyalty = new Contract_Rate_Based_Royalty__c();
        rateBasedRoyalty.Contract__c = contract.Id;
        wrapRateRowList = new List<wrapRateBasedRoyaltyRow>();
        nextRateRowId = 0;
        return null;
    }
    
    public PageReference createBlankRateTableForSelectedApps(){
        errFlag = false;
        errorNoRowsEntered = null;
        //pull all existing Rate Tables so that you can find what to number the new one
                system.debug('TABLE NAME: ' + rateBasedRoyalty.Name);
                try{
                        system.debug('QUERY FOR ALL TABLES');
                List<Contract_Rate_Based_Royalty__c> existingTables = [SELECT Id, Name FROM Contract_Rate_Based_Royalty__c WHERE Contract__c =: rateBasedRoyalty.Contract__c ORDER BY Name];
                //Integer size = existingTables.size() + 1;
                String Stringsize = String.valueOf(existingTables.size() + 1);
                system.debug('stringsize ' + stringsize);
                if(stringsize.length() == 1){
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT000' + stringsize;
                } else if(stringsize.length() == 2){
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT00' + stringsize;
                } else if(stringsize.length() == 3){
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT0' + stringsize;
                } else {
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT' + stringsize;
                } 
                } catch (System.Queryexception e){
                        // there are no existing tables, so make this the first one
                        rateBasedRoyalty.Name = 'Contract_' + contract.ContractNumber + '_RT0001';
                }       
                system.debug('TABLE NAME: ' + rateBasedRoyalty.Name);
        insert rateBasedRoyalty;
        system.debug('rateBasedRoyalty.id: ' + rateBasedRoyalty.id);
        
        List<Contract_Rate_Based_Royalty_Row__c> crrbrToInsert = new List<Contract_Rate_Based_Royalty_Row__c>();
                crrbrToInsert.add(new Contract_Rate_Based_Royalty_Row__c(Contract_Rate_Based_Royalty__c=rateBasedRoyalty.Id, Low_Volume__c=0, High_Volume__c=999999999999.00, Rate_Per_Unit__c=0, Tier__c=1));          
        insert crrbrToInsert;
        
        system.debug('wrapAppNameList: ' + wrapApplicationNameList);
        for(Integer i=0; i<wrapApplicationNameList.size(); i++){
                if(wrapApplicationNameList[i].selected == true){
                        system.debug('selected appName: ' + wrapApplicationNameList[i].appName);
                        for(ContApplAssoc__c caa : contractApp){
                                system.debug('ConApp.appId / wrapAppId: ' + caa.Application__c + ' / ' + wrapApplicationNameList[i].appId);
                                if(caa.Application__c == wrapApplicationNameList[i].appId){
                                        caa.Contract_Rate_Based_Royalty_Table__c = rateBasedRoyalty.Id; 
                                        conAppsWithExistingRateTables.add(caa);
                                }
                        }
                        wrapApplicationNameList.remove(i);
                        i--;
                }
        }
        upsert contractApp;
        conAppsWithExistingRateTables = [SELECT Id, Application__c,Application__r.Name, Contract__c, Governing_End_Date__c, Contract_Rate_Based_Royalty_Table__c, Contract_Rate_Based_Royalty_Table__r.Name FROM ContApplAssoc__c WHERE Id IN : conAppsWithExistingRateTables AND Contract_Rate_Based_Royalty_Table__c != null];
        
        rateBasedRoyalty = new Contract_Rate_Based_Royalty__c();
        rateBasedRoyalty.Contract__c = contract.Id;
        wrapRateRowList = new List<wrapRateBasedRoyaltyRow>();
        nextRateRowId = 0;
        
        
        if(wrapApplicationNameList.size() > 0){
                system.debug('TRY TO SEND BACK TO SELECT MORE APPS');
                return nextCreateRateTableForSelectedApps1();
        } 

                system.debug('TRY TO SEND FORWARD TO ACCTMEMO');
                return nextAccMemo();
    }
    
    public void saveBundlingDiscount() {
        Contract_Bundling_Discount__c tempBundlingDisc = new Contract_Bundling_Discount__c();        
        bundlingDiscount.Contract__c = contract.Id;  
        tempBundlingDisc.Discount__c = bundlingDiscount.Discount__c;  
        tempBundlingDisc.Details__c = bundlingDiscount.Details__c;
        tempBundlingDisc.No_of_Apps__c = bundlingDiscount.No_of_Apps__c;  
        tempBundlingDisc.Contract__c = contract.Id;  

        wrapBundlingDiscountList.add(new wrapBundlingDiscount (tempBundlingDisc, nextBundlingDiscountId++)); 

        bundlingDiscount = new Contract_Bundling_Discount__c();
    }  
    
    public void saveOtherDiscount() {
        Contract_Royalty_Rule_Other_Discount__c tempOtherDisc = new Contract_Royalty_Rule_Other_Discount__c();
        otherDiscount.Contract__c = contract.Id;    
        tempOtherDisc.Discount__c = otherDiscount.Discount__c;  
        tempOtherDisc.Discount_Criteria_Type__c = otherDiscount.Discount_Criteria_Type__c;  
        tempOtherDisc.Discount_Level__c = otherDiscount.Discount_Level__c;  
        tempOtherDisc.Discount_1_Trigger__c = otherDiscount.Discount_1_Trigger__c;
        tempOtherDisc.Trigger_Details__c = otherDiscount.Trigger_Details__c;        
        tempOtherDisc.Effective_Date__c = otherDiscount.Effective_Date__c; 
        tempOtherDisc.Expiration_Date__c = otherDiscount.Expiration_Date__c;
        tempOtherDisc.Specify_Application_if_applicable__c = otherDiscount.Specify_Application_if_applicable__c; 
        tempOtherDisc.Contract__c = contract.Id;    

        wrapOtherDiscountList.add(new wrapOtherDiscount (tempOtherDisc, nextOtherDiscountId++)); 

        otherDiscount = new Contract_Royalty_Rule_Other_Discount__c();
    }  
            
    public void saveLicenseFee() {
        Contract_Non_Rate_Based_License_Fee__c tempLicense = new Contract_Non_Rate_Based_License_Fee__c ();
        tempLicense.Payment_Trigger__c = licenseFee.Payment_Trigger__c;
        tempLicense.P_L_Treatment__c = licenseFee.P_L_Treatment__c;
        tempLicense.Payment_Due__c = licenseFee.Payment_Due__c;
        tempLicense.License_Fee_or_Prepay_Amount__c = licenseFee.License_Fee_or_Prepay_Amount__c;
        tempLicense.Due_After_SA__c = licenseFee.Due_After_SA__c;
        tempLicense.Recoverable__c = licenseFee.Recoverable__c;
        tempLicense.Beginning_Period__c = licenseFee.Beginning_Period__c;
        tempLicense.Ending_Period__c = licenseFee.Ending_Period__c;
        tempLicense.Contract__c = contract.Id;
        tempLicense.Units__c = licenseFee.Units__c;

        wrapLicenseFeeList.add(new wrapLicenseFee (tempLicense, nextLicenseFeeId++)); 

        licenseFee = new Contract_Non_Rate_Based_License_Fee__c ();
    }  
    
    public void saveMinGuarantee() {
        Contract_NonRate_Based_Minimum_Guarantee__c tempMinGuar = new Contract_NonRate_Based_Minimum_Guarantee__c();

        tempMinGuar.Amount_of_Guarantee__c = minGuarantee.Amount_of_Guarantee__c;
        tempMinGuar.Basis__c = minGuarantee.Basis__c;
        tempMinGuar.P_L_Treatment__c = minGuarantee.P_L_Treatment__c;
        tempMinGuar.Minimum_Guarantee_requested__c = minGuarantee.Minimum_Guarantee_requested__c;
        tempMinGuar.Meeting_SA__c = minGuarantee.Meeting_SA__c;
        tempMinGuar.From_When__c = minGuarantee.From_When__c;
        tempMinGuar.To_When__c = minGuarantee.To_When__c;
        tempMinGuar.Contract__c = contract.Id;

        wrapMinGuaranteeList.add(new wrapMinGuarantee (tempMinGuar, nextMinGuaranteeId++)); 

        minGuarantee = new Contract_NonRate_Based_Minimum_Guarantee__c();
    }  
    
    public void saveNonRoyaltyRules() {
        Contract_Non_Royalty_Cost_Rule__c tempCostRule = new Contract_Non_Royalty_Cost_Rule__c();

        tempCostRule.Type__c = nonRoyaltyCostRule.Type__c;
        tempCostRule.Charge_Department__c = nonRoyaltyCostRule.Charge_Department__c;
        tempCostRule.Cost_Name__c = nonRoyaltyCostRule.Cost_Name__c;
        tempCostRule.Amount__c = nonRoyaltyCostRule.Amount__c;
        tempCostRule.Payment_Due__c = nonRoyaltyCostRule.Payment_Due__c;
        tempCostRule.Contract__c = contract.Id;
        tempCostRule.Forecasted_Completion_Date__c = nonRoyaltyCostRule.Forecasted_Completion_Date__c;
        tempCostRule.Actual_Completion_Date__c = nonRoyaltyCostRule.Actual_Completion_Date__c;
        tempCostRule.Maintenance_Period_Start__c = nonRoyaltyCostRule.Maintenance_Period_Start__c;
        tempCostRule.Maintenance_Period_End__c = nonRoyaltyCostRule.Maintenance_Period_End__c;
        RecordType rt = new RecordType();
        try {
            rt = [select Id from RecordType where RecordType.SobjectType = 'Contract_Non_Royalty_Cost_Rule__c' AND RecordType.Name=:nonRoyaltyCostRule.Type__c];
        } catch(QueryException e){}
        tempCostRule.RecordTypeId = rt.Id;
        
        wrapNonRoyaltyCostRuleList.add(new wrapNonRoyaltyCostRule (tempCostRule, nextRoyaltyCostRuleId++));

        nonRoyaltyCostRule = new Contract_Non_Royalty_Cost_Rule__c();
    }          
        
    /****************************************************************************************************************************************************
                Delete Royalty Rule methods
    ****************************************************************************************************************************************************/
    public void delRateBasedRoyalty() {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrapRateList.size(); idx++)
        {
            if (wrapRateList[idx].rateId==toDelIdent)
            {
                toDelPos=idx;
                If (wrapRateList[idx].rateBasedRoyaltyList.Id != null)
                    deleteRateList.add(wrapRateList[idx].rateBasedRoyaltyList);
            }
        }
   
        if (-1!=toDelPos)
        {
            wrapRateList.remove(toDelPos);
        }
    }
    
    public void delBundlingDiscount() {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrapBundlingDiscountList.size(); idx++)
        {
            if (wrapBundlingDiscountList[idx].bundlingDiscountId==toDelIdent)
            {
                toDelPos=idx;
                If (wrapBundlingDiscountList[idx].bundlingDiscountList.Id != null)
                    deleteBundlingDiscountList.add(wrapBundlingDiscountList[idx].bundlingDiscountList);
            }
        }
   
        if (-1!=toDelPos)
        {
            wrapBundlingDiscountList.remove(toDelPos);
        }
    }
    
    public void delOtherDiscount() {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrapOtherDiscountList.size(); idx++)
        {
            if (wrapOtherDiscountList[idx].otherDiscountId==toDelIdent)
            {
                toDelPos=idx;
                If (wrapOtherDiscountList[idx].otherDiscountList.Id != null)
                    deleteOtherDiscountList.add(wrapOtherDiscountList[idx].otherDiscountList);
            }
        }
   
        if (-1!=toDelPos)
        {
            wrapOtherDiscountList.remove(toDelPos);
        }
    }
    
    public void delLicenseFee() {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrapLicenseFeeList.size(); idx++)
        {
            if (wrapLicenseFeeList[idx].licenseFeeId==toDelIdent)
            {
                toDelPos=idx;
                If (wrapLicenseFeeList[idx].licenseFeeList.Id != null)
                    deleteLicenseFeeList.add(wrapLicenseFeeList[idx].licenseFeeList);
            }
        }
   
        if (-1!=toDelPos)
        {
            wrapLicenseFeeList.remove(toDelPos);
        }
    }
    
    public void delMinGuarantee() {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrapMinGuaranteeList.size(); idx++)
        {
            if (wrapMinGuaranteeList[idx].minGuaranteeId==toDelIdent)
            {
                toDelPos=idx;
                If (wrapMinGuaranteeList[idx].minGuaranteeList.Id != null)
                    deleteMinGuaranteeList.add(wrapMinGuaranteeList[idx].minGuaranteeList);
            }
        }
   
        if (-1!=toDelPos)
        {
            wrapMinGuaranteeList.remove(toDelPos);
        }
    }
    
    public void delNonRoyaltyCostRule() {
        Integer toDelPos=-1;
        for (Integer idx=0; idx<wrapNonRoyaltyCostRuleList.size(); idx++)
        {
            if (wrapNonRoyaltyCostRuleList[idx].royaltyCostRuleId==toDelIdent)
            {
                toDelPos=idx;
                If (wrapNonRoyaltyCostRuleList[idx].nonRoyaltyCostRuleList.Id != null)
                    deleteNonRoyaltyCostRuleList.add(wrapNonRoyaltyCostRuleList[idx].nonRoyaltyCostRuleList);
            }
        }
   
        if (-1!=toDelPos)
        {
            wrapNonRoyaltyCostRuleList.remove(toDelPos);
        }
    }
    
    
    /****************************************************************************************************************************************************
                Methods to select Application, Platform, Stable
    ****************************************************************************************************************************************************/
    public void DynamicRow(){
        system.debug('dynamicRow to add app');
        If ((varLQA1.Application__c == null)){         
           errorMessageApp='Must enter a value for Application';
           system.debug('No app selected');
           //return null;
        } else if(([SELECT Id, Account__c FROM Application__c WHERE Id =: varLQA1.Application__c].Account__c != contract.AccountId) && ([SELECT Name FROM Application__c WHERE Id =: varLQA1.Application__c].Name != 'None')){     
                system.debug('Account ID Does not match');      
                errorMessageApp='Application must be from the same Account that Contract is under.';
        }
        else {
                errorMessageApp='';
                //for(Integer i=0;i<1;i++){
                    ContApplAssoc__c caa = new ContApplAssoc__c();
                    caa.Contract__c = contract.Id;
                    caa.Application__c = varLQA1.Application__c;
                    caa.Governing_End_Date__c = false;
                    contractApp.add(caa);
                    appNameList.add(caa);
                    appName = [Select Name From Application__c Where Id=:varLQA1.Application__c];                     
                    aNames.add(appName.Name);  
                    AppNameMap.put(varLQA1.Application__c,appName.Name); 
                    //AppNameMap1.put((Integer)(varLQA1.Application__c),appName.Name);           
                    wrapApplicationNameList.add(new wrapApplicationName(appName.Name, varLQA1.Application__c, false));             
                //}
                varLQA1.clear();
                countryFlag = False;
        }
        //return null;
    }
    
    public void DynamicRowPlatform(){
        If ((varContPlat.Platform__c == null)){         
           errorMessagePlatform='Must enter a value for Software Platform';
           //return null;
        }
        else {
        errorMessagePlatform='';
        for(Integer i=0;i<1;i++){
            Contract_Platform__c cp = new Contract_Platform__c();
            cp.Contract__c = contract.Id;
            cp.Platform__c = varContPlat.Platform__c;
            contractPlatform.add(cp);
            platformName = [Select Name From Platform__c Where Id=:varContPlat.Platform__c];                     
            pNames.add(platformName.Name);                  
        }
        varContPlat.clear();
        //return null;
        }
    }
    
   public void DynamicRowStable(){
        If ((varContStab.Stable__c == null)){         
           errorMessageStable='Must enter a value for Stable';
           //return null;
        }
        else {
        errorMessageStable='';
        for(Integer i=0;i<1;i++){
            Contract_Stable__c sp = new Contract_Stable__c ();
            sp.Contract__c = contract.Id;
            sp.Stable__c = varContStab.Stable__c;
            contractStable.add(sp);
            stableName = [Select Name From Stable__c Where Id=:varContStab.Stable__c];                     
            sNames.add(stableName.Name);                  
        }
        varContStab.clear();
        //return null;
        }
    }
    
    
    public void getSADate(){                         
        try{
            device = [Select SA_Date__c From Device__c Where Id=:contract.Lead_Device__c];  
            contract.Lead_Device_SA_Date__c = device.SA_Date__c;
        } catch (System.QueryException qe){
            device.clear();
            contract.Lead_Device_SA_Date__c = null;            
        }                                        
    }
    



    /****************************************************************************************************************************************************
                Wrapper Classes
    ****************************************************************************************************************************************************/  
    
    public class wrapRateBasedRoyalty {
        public Contract_Rate_Based_Royalty__c rateBasedRoyaltyList { get; set; }
        public Integer rateId {get; set;}
        
        public wrapRateBasedRoyalty (Contract_Rate_Based_Royalty__c TempRate, Integer i) {
            rateBasedRoyaltyList = TempRate;
            rateId = i;
        }
        }
        
        public class wrapRateBasedRoyaltyRow {
        public Contract_Rate_Based_Royalty_Row__c rateBasedRoyaltyRowList { get; set; }
        public Integer rateId {get; set;}
        
        public wrapRateBasedRoyaltyRow (Contract_Rate_Based_Royalty_Row__c TempRate, Integer i) {
            rateBasedRoyaltyRowList = TempRate;
            rateId = i;
        }
    }
     
    public class wrapBundlingDiscount {
                public Contract_Bundling_Discount__c bundlingDiscountList { get; set; }
        public Integer bundlingDiscountId {get; set;}
        
        public wrapBundlingDiscount (Contract_Bundling_Discount__c TempBundlingDiscount, Integer i) {
            bundlingDiscountList = TempBundlingDiscount;
            bundlingDiscountId = i;
        }
    }
     
    public class wrapOtherDiscount {
        public Contract_Royalty_Rule_Other_Discount__c otherDiscountList { get; set; }
        public Integer otherDiscountId {get; set;}
        
        public wrapOtherDiscount (Contract_Royalty_Rule_Other_Discount__c TempOtherDiscount, Integer i) {
            otherDiscountList = TempOtherDiscount;
            otherDiscountId = i;
        }
    }
     
    public class wrapLicenseFee {
        public Contract_Non_Rate_Based_License_Fee__c licenseFeeList { get; set; }
        public Integer licenseFeeId {get; set;}
        
        public wrapLicenseFee (Contract_Non_Rate_Based_License_Fee__c TempLicenseFee, Integer i) {
            licenseFeeList = TempLicenseFee;
            licenseFeeId = i;
        }
    }
     
    public class wrapMinGuarantee {
        public Contract_NonRate_Based_Minimum_Guarantee__c minGuaranteeList { get; set; }
        public Integer minGuaranteeId {get; set;}
        
        public wrapMinGuarantee (Contract_NonRate_Based_Minimum_Guarantee__c TempMinGuarantee, Integer i) {
            minGuaranteeList = TempMinGuarantee;
            minGuaranteeId = i;
        }
    }
     
    public class wrapNonRoyaltyCostRule {
        public Contract_Non_Royalty_Cost_Rule__c nonRoyaltyCostRuleList { get; set; }
        public Integer royaltyCostRuleId {get; set;}
        
        public wrapNonRoyaltyCostRule (Contract_Non_Royalty_Cost_Rule__c TempRoyaltyCostRule, Integer i) {
            nonRoyaltyCostRuleList = TempRoyaltyCostRule;
            royaltyCostRuleId = i;
        }
    }
     
    public class wrapLeadDevice {
        public String deviceName { get; set; }
        public Datetime SAdate {get; set;}
        
        public wrapLeadDevice (String dName, Datetime sadate) {
            deviceName = dName;
            SAdate = saDate;
            //SAdate = null;
        }
        
        public wrapLeadDevice () {
            deviceName = null;
            SAdate = null;
            //SAdate = null;
        }
    }
     
    public class wrapApplicationName {
        public String appName {get; set;}
        public Id appId {get; set;}
        public Boolean selected {get; set;}
        
        public wrapApplicationName (String aName, Id aId, Boolean s){
                appName = aName;
                appId = aId;
                selected = s;
        }
    }


    /****************************************************************************************************************************************************
                Unit Test
    ****************************************************************************************************************************************************/  
    public static testMethod void LBInitialDealController_Test()
    {
        //Test converage for the myPage visualforce page
        PageReference pageRef = Page.LRBInitialDealRequest;
        //Test.setCurrentPageReference(pageRef);
        
       
                Account a = new Account(Name='LRBInitialfake', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='testAppLRBInitial', Account__c=a.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription');
        insert app;
        Application__c app2 = new Application__c(Name='testAppLRBInitial2', Account__c=a.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription');
        insert app2;
        Contract testContract = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today());
        insert testContract;
        Contract_Rate_Based_Royalty__c crbrt = new Contract_Rate_Based_Royalty__c(Name='faketable', Contract__c=testContract.Id);
        insert crbrt;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=testContract.Id, Application__c=app.Id, Contract_Rate_Based_Royalty_Table__c=crbrt.Id);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=testContract.Id, Application__c=app2.Id);
        insert new List<ContApplAssoc__c>{ca, ca2};
        
        Platform__c fakePlatform = new Platform__c(Name='fakePlatform');
        insert fakePlatform;
        Contract_Platform__c conPlatform = new Contract_Platform__c(Contract__c=testContract.Id, Platform__c=fakePlatform.Id);
        insert conPlatform;
        
        
        Stable__c fakeStable = new Stable__c(Name='fakeStable');
        insert fakeStable;
        Contract_Stable__c conStable = new Contract_Stable__c(Contract__c=testContract.Id, Stable__c=fakeStable.Id);
        insert conStable;
        
       /* String objectName = 'Contract';  // modify as needed
        String query = 'SELECT';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();

        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
           query += ' ' + s + ',';
        }        
        
        if (query.subString(query.Length()-1,query.Length()) == ','){
            query = query.subString(0,query.Length()-1);
        } 
        
        query += ' FROM ' + objectName;

        // Add on a WHERE/ORDER/LIMIT statement as needed
        //query += ' WHERE Id=\'800Q0000000JAfx\' LIMIT 1'; 
        query += ' WHERE Id=:' + testContract.Id + ' LIMIT 1';
        //Contract testContract = new Contract();
  
        //try {
            testContract = database.query(query);
        //} catch (QueryException e){
            //perform exception handling
        //}
        
        
        //Contract testContract = [SELECT * FROM Contract WHERE Id='800Q0000000JAfx' LIMIT 1];
        */
        // create an instance of the controller
        //LRBInitialDealController myPageCon = new LRBInitialDealController();
        Apexpages.StandardController LBInitDealController = new Apexpages.standardController(testContract);
        
        pageRef.getParameters().put('id', testContract.id);

        test.setCurrentPage(pageRef);
        
        LRBInitialDealController myPageCon = new LRBInitialDealController(LBInitDealController);
        
        testContract.Business_Need__c='Test';
        testContract.Business_Model__c='Test';
        testContract.Comparison_of_Current_situation_with_new__c='Test';
        testContract.Alternative_Source__c='Test';
        testContract.Request_covers_1_or_more_devices__c='Test';
        testContract.Intended_Use_in_Motorola_products__c='Test';
        testContract.Software_planned_to_be_part_of_stable__c='No';
        testContract.BusinessUnit__c='Mobile Devices';
        testContract.Motorola_Entity__c='Motorola Mobility Inc';
        testContract.Rate_is_Competitive__c='Test';
        testContract.Business_Unit_Type__c='China - Lina Yang';
        testContract.Is_There_NRE__c='No';
        testContract.Category_Commodity__c='Other';
        update testContract;   
        
        //Contract testContractUpdate = new Contract ();
        Contract testContractUpdate = [SELECT Id, Business_Need__c, Business_Model__c, Comparison_of_Current_situation_with_new__c, Alternative_Source__c, 
        Request_covers_1_or_more_devices__c, Intended_Use_in_Motorola_products__c, Software_planned_to_be_part_of_stable__c, BusinessUnit__c,
         Motorola_Entity__c, Rate_is_Competitive__c, Business_Unit_Type__c, Is_There_NRE__c, Category_Commodity__c FROM Contract WHERE Id=:testContract.Id];
        //testContractUpdate = database.query(query);
        System.assertEquals(testContractUpdate.Business_Need__c, 'Test');
        System.assertEquals(testContractUpdate.Business_Model__c, 'Test');
        System.assertEquals(testContractUpdate.Comparison_of_Current_situation_with_new__c, 'Test');
        System.assertEquals(testContractUpdate.Alternative_Source__c, 'Test');
        System.assertEquals(testContractUpdate.Request_covers_1_or_more_devices__c, 'Test');
        System.assertEquals(testContractUpdate.Intended_Use_in_Motorola_products__c, 'Test');
        System.assertEquals(testContractUpdate.Software_planned_to_be_part_of_stable__c, 'No');
        System.assertEquals(testContractUpdate.BusinessUnit__c, 'Mobile Devices');
        System.assertEquals(testContractUpdate.Motorola_Entity__c, 'Motorola Mobility Inc');
        System.assertEquals(testContractUpdate.Rate_is_Competitive__c, 'Test');
        System.assertEquals(testContractUpdate.Business_Unit_Type__c, 'China - Lina Yang');
        System.assertEquals(testContractUpdate.Is_There_NRE__c, 'No');
        System.assertEquals(testContractUpdate.Category_Commodity__c, 'Other');
        
        ContApplAssoc__c testContApp = new ContApplAssoc__c();
        testContApp.Application__c = 'a07Q00000069ZH2';
        testContApp.Contract__c = '800Q0000000JAfx';
        myPageCon.DynamicRow();
        
        Contract_Platform__c testContPlat = new Contract_Platform__c();
        testContPlat.Platform__c = 'a2AQ000000016HO';
        testContPlat.Contract__c = '800Q0000000JAfx';
        myPageCon.DynamicRowPlatform();
        
        myPageCon.nextAccMemo();
        
        PageReference pageRef1 = Page.LRBAccountingMemo;
        pageRef1.getParameters().put('id', testContract.id);

        test.setCurrentPage(pageRef1);
        
        List<wrapRateBasedRoyalty> testwrapRateList = new List<wrapRateBasedRoyalty> ();
        Contract_Rate_Based_Royalty__c testrateBasedRoyalty = new Contract_Rate_Based_Royalty__c ();
        Integer testnextRateId=0;
        List<Contract_Rate_Based_Royalty__c> testdeleteRateList = new List<Contract_Rate_Based_Royalty__c>();
        
        /*
        testrateBasedRoyalty.Contract__c = '800Q0000000JAfx';
        testwrapRateList.add(new wrapRateBasedRoyalty(testrateBasedRoyalty, testnextRateId++));
        myPageCon.saveRateBasedRoyaltyRow();
        */
        

        testrateBasedRoyalty.Contract__c = '800Q0000000JAfx';
        testwrapRateList.add(new wrapRateBasedRoyalty(testrateBasedRoyalty, testnextRateId++));
        myPageCon.saveRateBasedRoyaltyRow();
        myPageCon.delRateBasedRoyalty();
        
        List<wrapBundlingDiscount> wrapBundlingDiscountList = new List<wrapBundlingDiscount> ();
        Contract_Bundling_Discount__c bundlingDiscount = new Contract_Bundling_Discount__c ();
        Integer nextBundlingDiscountId=0;
        
        bundlingDiscount.No_of_Apps__c = 10;
        bundlingDiscount.Discount__c = 20;
        bundlingDiscount.Details__c = 'Test';
        bundlingDiscount.Contract__c = '800Q0000000JAfx';
        myPageCon.saveBundlingDiscount();
        
        bundlingDiscount.No_of_Apps__c = 44;
        bundlingDiscount.Discount__c = 33;
        bundlingDiscount.Details__c = 'Test';
        bundlingDiscount.Contract__c = '800Q0000000JAfx';
        myPageCon.saveBundlingDiscount();
        myPageCon.delBundlingDiscount();
        
        List<wrapOtherDiscount> wrapOtherDiscountList = new List<wrapOtherDiscount>();
        Contract_Royalty_Rule_Other_Discount__c otherDiscount = new Contract_Royalty_Rule_Other_Discount__c();
        Integer nextOtherDiscountId=0;
        
        otherDiscount.Discount_Level__c = 'App';
        otherDiscount.Specify_Application_if_applicable__c = 'Arrow Head';
        otherDiscount.Discount_1_Trigger__c = 'Test';
        otherDiscount.Trigger_Details__c = 'test';
        otherDiscount.Discount_Criteria_Type__c = '%';
        otherDiscount.Discount__c = '5';
        otherDiscount.Contract__c = '800Q0000000JAfx';
        myPageCon.saveOtherDiscount();
        
        otherDiscount.Discount_Level__c = 'Contract';
        otherDiscount.Discount_1_Trigger__c = 'Test';
        otherDiscount.Trigger_Details__c = 'test';
        otherDiscount.Discount_Criteria_Type__c = '$';
        otherDiscount.Discount__c = '10';
        otherDiscount.Contract__c = '800Q0000000JAfx';
        myPageCon.saveOtherDiscount();
        myPageCon.delOtherDiscount();
        
        List<wrapLicenseFee> wrapLicenseFeeList = new List<wrapLicenseFee>();
        Contract_Non_Rate_Based_License_Fee__c licenseFee = new Contract_Non_Rate_Based_License_Fee__c();
        Integer nextLicenseFeeId=0;
        
        licenseFee.License_Fee_or_Prepay_Amount__c = 100;
        licenseFee.Payment_Trigger__c= 'Test';
        licenseFee.P_L_Treatment__c = 'Test';
        licenseFee.Payment_Due__c = 'Test';
        licenseFee.Contract__c = '800Q0000000JAfx';
        licenseFee.Units__c = 50000;
        myPageCon.saveLicenseFee();
        myPageCon.delLicenseFee();
        
        List<wrapMinGuarantee> wrapMinGuaranteeList = new List<wrapMinGuarantee>();
        Contract_NonRate_Based_Minimum_Guarantee__c minGuarantee = new Contract_NonRate_Based_Minimum_Guarantee__c();
        Integer nextMinGuaranteeId=0;
        
        minGuarantee.Amount_of_Guarantee__c = 100;
        minGuarantee.Basis__c = 'Test';
        minGuarantee.P_L_Treatment__c = 'Test';
        minGuarantee.Minimum_Guarantee_requested__c = 'Test';
        minGuarantee.Contract__c = '800Q0000000JAfx';
        myPageCon.saveMinGuarantee();
        myPageCon.delMinGuarantee();
    
        List<wrapNonRoyaltyCostRule> wrapNonRoyaltyCostRuleList = new List<wrapNonRoyaltyCostRule>();
        Contract_Non_Royalty_Cost_Rule__c nonRoyaltyCostRule = new Contract_Non_Royalty_Cost_Rule__c();      
        Integer nextRoyaltyCostRuleId=0;
        nonRoyaltyCostRule.Type__c = 'NRE';
        nonRoyaltyCostRule.Amount__c = 100;
        nonRoyaltyCostRule.Charge_Department__c = 'Test';
        nonRoyaltyCostRule.Cost_Name__c = 'Test';
        nonRoyaltyCostRule.Payment_Due__c = 'Test';
        nonRoyaltyCostRule.Contract__c = '800Q0000000JAfx';
        myPageCon.saveNonRoyaltyRules();
        myPageCon.delNonRoyaltyCostRule();
        
        myPageCon.nextAppLegalCountries();
        myPageCon.mainform();
        
        PageReference pageRef2 = Page.LRBAddAppLegalCountries;
        pageRef2.getParameters().put('id', testContract.id);
        test.setCurrentPage(pageRef2);
        
        myPageCon.nextAppAvailCountries();
        
        PageReference pageRef3 = Page.LRBAddAppCountries;
        pageRef3.getParameters().put('id', testContract.id);
        test.setCurrentPage(pageRef3);
        
        myPageCon.nextAppAvailCountries();
        myPageCon.previousAppLegalCountries();
        
        myPageCon.submit();
        myPageCon.cancelmainform();
        
              
    }        

}