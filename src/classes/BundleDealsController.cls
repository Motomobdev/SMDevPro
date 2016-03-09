public without sharing class BundleDealsController {

  public Account filterAcct {get; set;}
  public String mainQuery{get;set;}
  public List<acctWrapper> mainAccounts{get; set;}

  //New Deal Variables
  public Account acct {get;set;}
  public List<Account> accts {get; set;}
  public Opportunity oppt {get;set;}
  public List<Opportunity> bundleOpps {get;set;}
  public List<Quote> bundleQuots {get;set;}
  public Quote qt {get; set;}
  public Boolean pageIsValid {get;set;}
  
  public Boolean OpportunityCreation {get; set;}
  public String oppId {get; set;}
  public String associatedAccount {get; set;}
  public List<Account> accountObj = null;
  public List<Opportunity> oppObj {get; set;}
  public String updatedYear {get; set;}
  public String updatedQuarter {get; set;}
  
  public Note execNote {get; set;} 
  public Id opptId = null;
  
  public Boolean readOnlyAccount {get; set;}
  public Boolean fromOpportunity {get; set;}
  public String opptYear {get; set;}
  public String opptQuarter {get; set;}
  public String parentAccountId {get; set;}
  public String parentOppId {get; set;}
  public String parentQuotId {get; set;}

  
  public BundleDealsController(){
      filterAcct = new Account();
      mainAccounts = new List<acctWrapper>();
      execNote =  new Note();
      oppt = new Opportunity();
      qt = new Quote();
      //List<Account> listAct = [SELECT Id, Name FROM account];
      //ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, JSON.serializePretty(listAct)));
      try{
        initializeDependentMaps();
      }
      catch(Exception e){
        System.debug(e);
      }
  }
  
  Map<String,List<String>> subTypeMap {get;set;}
  Map<String,List<String>> subRegionMap {get;set;}
  Map<String,List<String>> countryMap {get;set;}
  
  private void initializeDependentMaps(){
    subTypeMap = PicklistUtils.GetDependentOptions('Account','Type','Account_Subtype__c');
    subRegionMap = PicklistUtils.GetDependentOptions('Account','Region__c','Sub_Region__c');
    countryMap = PicklistUtils.GetDependentOptions('Account','Sub_Region__c','Country__c');
    
    System.debug(subTypeMap);
    System.debug(subRegionMap);
    System.debug(countryMap);
  }
  
  public void resetRegionValues(){
    selectedSubRegion = '';
    selectedAccountCountry = '';
  }
  
  public Boolean getHasNoValuesAccountSubType(){
    if(getAccountSubTypeValues().size() == 1)
        return true;
    return false;
  }
  
  public Boolean getHasNoValuesAccountSubRegion(){
    if(getAccountSubRegionValues().size() == 1)
        return true;
    return false;
  }
  
  public Boolean getHasNoValuesAccountCountry(){
    if(getAccountCountryValues().size() == 1)
        return true;
    return false;
  }
  
  public String selectedAccountType {get;set;}
  
  public List<SelectOption> getAccountTypeValues(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--None--'));
        
        for(Schema.PicklistEntry p : Account.Type.getDescribe().getPicklistValues()){
            options.add(new SelectOption(p.getValue(),p.getValue()));
        }
        
        return options;
  }
  
  public String selectedAccountSubType {get;set;}
  
  public List<SelectOption> getAccountSubTypeValues(){
        List<SelectOption> options = new List<SelectOption>();
        
        if(selectedAccountType == null || selectedAccountType == '')
            options.add(new SelectOption('','--None--',true));
        else
            options.add(new SelectOption('','--None--'));
            
        for(String s : subTypeMap.get(selectedAccountType)){
            options.add(new SelectOption(s,s));
        }
        
        return options;
  }
  
  public String selectedAccountRegion {get;set;}
  
  public List<SelectOption> getAccountRegionValues(){
        List<SelectOption> options = new List<SelectOption>();
        
        options.add(new SelectOption('','--None--'));
        
        for(Schema.PicklistEntry p : Account.Region__c.getDescribe().getPicklistValues()){
            options.add(new SelectOption(p.getValue(),p.getValue()));
        }
        
        return options;
  }
  
  public String selectedSubRegion {get;set;}
  
  public List<SelectOption> getAccountSubRegionValues(){
        List<SelectOption> options = new List<SelectOption>();
        
        if(selectedAccountRegion == null || selectedAccountRegion == '')
            options.add(new SelectOption('','--None--',true));
        else
            options.add(new SelectOption('','--None--'));
        
        for(String s : subRegionMap.get(selectedAccountRegion)){
            options.add(new SelectOption(s,s));
        }
        
        return options;
  }
  
  public String selectedAccountCountry {get;set;}
  
  public List<SelectOption> getAccountCountryValues(){
        List<SelectOption> options = new List<SelectOption>();
        
        if(selectedSubRegion == null || selectedSubRegion == '')
            options.add(new SelectOption('','--None--',true));
        else
            options.add(new SelectOption('','--None--'));
        
        for(String s : countryMap.get(selectedSubRegion)){
            options.add(new SelectOption(s,s));
        }
        
        return options;
  }
    
  public PageReference initPage() {
      return null;
  }

  
  public PageReference searchAccounts() {
      mainQuery = 'SELECT Id, Name, Region__c, Sub_Region__c, Type,  Account_Subtype__c, Country__c FROM account WHERE name != null AND Active__c=True AND Allow_Opportunities__c=True';
      
      if (selectedAccountType != null && selectedAccountType != '')
        mainQuery += ' AND Type= \'' + selectedAccountType+ '\'';
      if (selectedAccountSubType != null && selectedAccountSubType != '')
        mainQuery += ' AND Account_Subtype__c= \'' + selectedAccountSubType+ '\'';
      if (selectedSubRegion != null && selectedSubRegion != '')
        mainQuery += ' AND Sub_Region__c= \'' + selectedSubRegion+ '\'';
      if (selectedAccountCountry != null && selectedAccountCountry != '')
        mainQuery += ' AND Country__c LIKE \'' + selectedAccountCountry + '%\'';
      if (selectedAccountRegion != null && selectedAccountRegion != '')
        mainQuery += ' AND Region__c= \'' + selectedAccountRegion+ '\'';
        
      //Limit the query
      mainQuery += ' limit 100 ';
      try{
        
        List<Account> accts = Database.query(mainQuery);         

        mainAccounts = new List<acctWrapper>();
        for(Account acct : accts){
            mainAccounts.add(new acctWrapper(acct));
        }   
        
        System.debug('############### mainAccounts:' + mainAccounts);
      } catch (Exception e) {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
      }
    return null;
  }
  
  //Check for valid information and redirect the user to the NewBundleDealPage, which has this same controller.
  public PageReference createBundle() {
    if(!validateSelectedAccounts()){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Select at least two accounts in order to create Bundle'));
      return null;
    }

    if(parentAccountId == null){
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Specify Parent Account'));
      return null;
    }


    System.debug('############### mainAccounts:' + mainAccounts);
    PageReference pageRef = Page.NewBundleDeal;  
    return pageRef;
  }

  public pageReference cancelCreate(){
    PageReference pageRef = Page.BundleDeals;  
    return pageRef;
  }

  public pageReference createDeal(){
     //FIRST CREATE THE PARENT DEAL
     for(acctWrapper mainAccount : mainAccounts){ 
        if(mainAccount.checked != true)
          continue; //skip if its not marked as bundle.

        if(mainAccount.acct.Id == parentAccountId){ //PARENT ACCOUNT
          //CREATE A PARENT DEAL (OPP AND QUOTE)
          Id parentOppId = createOppt(mainAccount.acct, true);
          Id parentQuotId = createQuote(parentOppId,  true);
          //CREATE A CHILD DEAL (QUOTE)
          Id parentChildOppId = createOppt(mainAccount.acct, false);
          Id parentChildQuotId = createQuote(parentChildOppId,  false);
        }
      }

      //Now Create the Children Deals
      for(acctWrapper mainAccount : mainAccounts){
        if(mainAccount.checked != true)
          continue; //skip if its not marked as bundle.
      if(mainAccount.acct.Id == parentAccountId)
            continue; //Also Skip the Parent

          //CREATE A CHILD OPP DEAL
          Id childOppId = createOppt(mainAccount.acct, false);
          //CREATE A CHILD QUOT DEAL
          Id childQuoteId = createQuote(childOppId,  false);
      }
      

      PageReference pageRef = new pageReference('/apex/DealView?qId=' + parentQuotId); 
      pageRef.setRedirect(true);
      return pageRef;
  }

  public void addExecutiveNote(Id quoteId){
      try
      {
        execNote.IsPrivate = false;
        execNote.Title = 'Executive Summary';
         if(execNote.parentId != null)
         {
              update execNote;
            }
            else
            {
              execNote.parentId = quoteId;
              execNote.OwnerId = UserInfo.getUserId();
              insert execNote; //insert the record
          }
      }
      catch(Exception ex)
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, ex.getMessage()));
         system.debug('ERROR ADD NOTE ' + ex.getMessage());
      }
  }

  public PageReference setParentAccountId(){
    if(Apexpages.currentPage().getParameters().get('accountId') != null){
      parentAccountId = Apexpages.currentPage().getParameters().get('accountId');
      for(acctWrapper mainAccount : mainAccounts){
        if(mainAccount.acct.Id == parentAccountId){
          mainAccount.parent = true;
          mainAccount.checked = true;
        }else{
          mainAccount.parent = false;
        }
      }
    }
    
    return null;
  }


    
    /////////////////// UTILITY ///////////////////////////
    
    //Make sure we have at least 2 or more selected accounts in order to proceed to create the bundle.
    @TestVisible private Boolean validateSelectedAccounts(){
      Integer counter = 0;
        for(acctWrapper mainAccount : mainAccounts){
          if(mainAccount.checked){
            counter++;
          }
        }

        if(counter >= 2){
          return true;
        }else{
          return false;
        }
    }

    @TestVisible private Id createOppt(Account acct, Boolean parentOpp){
        System.debug('############### oppt:' + oppt);
        Id rtid = [select id from RecordType where sobjecttype = 'Opportunity' and DeveloperName = 'BundleDeal' limit 1].Id;
        Opportunity singleOppt = new Opportunity();
        singleOppt.RecordTypeId = rtid;
        singleOppt.AccountId = acct.Id;
        singleOppt.CloseDate = Date.today().AddYears(1);
        singleOppt.StageName = '1. Prospecting';
        Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];
        singleOppt.Pricebook2Id = standardPb.Id;
        singleOppt.Year__c = oppt.Year__c;
        singleOppt.Quarter__c = oppt.Quarter__c;
    
    	//awilkinson@levementum.com Added Default to USD for new opps
    	singleOppt.CurrencyISOCode = 'USD';
        if(!parentOpp && parentOppId != null){
          singleOppt.ParentOpportunity__c = parentOppId;
          singleOppt.Name = 'CHILD - ' + oppt.Name;
        }else{
          singleOppt.Name = 'PARENT - ' + oppt.Name;
        }

        try{
            insert singleOppt;
            if(parentOpp){
              parentOppId = singleOppt.Id;
            }

            return singleOppt.Id;
        }
        catch(exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, e.getMessage()));
              system.debug(e.getMessage() + 'createOppt()');
            return null;
        }

    }
      
    @TestVisible private Id createQuote(Id opptId, Boolean parent){
      Id quoteId = null;
      try
      {
          Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];
          Id rtid = [select id from RecordType where sobjecttype = 'Quote' and DeveloperName = 'BundleDeal' limit 1].Id;
          Quote singleQuote = new Quote();
          singleQuote.Pricebook2Id = standardPb.Id;
          singleQuote.ExecutiveSummary__c = execNote.body;
          singleQuote.Deal_Review_Date__c = Date.today();
          singleQuote.OpportunityId = opptId;
          singleQuote.IsASPFloor__c = qt.IsASPFloor__c;
          singleQuote.IsNSBD25M__c = qt.IsNSBD25M__c;
          singleQuote.HasMDFSDFDiscount__c = qt.HasMDFSDFDiscount__c;
          singleQuote.IsMDFSDFDiscount500k__c = qt.IsMDFSDFDiscount500k__c;
          singleQuote.Deal_Review_Date__c = qt.Deal_Review_Date__c;
          singleQuote.IsTotalDiscount100K__c = qt.IsTotalDiscount100K__c;
          singleQuote.RecordTypeId  = rtid;
          singleQuote.Portfolio_Segment__c = qt.Portfolio_Segment__c; 

          if(!parent){
            singleQuote.ParentQuote__c = parentQuotId;
            singleQuote.Name = 'CHILD - ' + oppt.name;
          }else{
            singleQuote.Name = 'PARENT - ' + oppt.name;
          }

          try{
              insert singleQuote;
              if(parent){
                parentQuotId = singleQuote.Id;
              }
              quoteId = singleQuote.Id;

          }catch(exception e){
              system.debug(e.getMessage() + ' createQuote()');
          }
      }
      catch(Exception e)
      {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.INFO, e.getMessage()));
        system.debug(e.getMessage() + 'createQuote()');
        return null;
      }
        return quoteId;
    }

    public class acctWrapper{
        public Boolean checked {get; set;}
        public Boolean parent {get; set;}
        public Account acct {get; set;}
        public Opportunity parentOpp {get; set;}
        public Opportunity opp {get; set;}
        public Quote quot {get; set;}

        
        public acctWrapper(Account incomingAcct){
            checked = false;
            parent = false;
            acct = incomingAcct;
            parentOpp = new Opportunity();
            opp = new Opportunity();
            quot = new Quote();
        }
    }

}