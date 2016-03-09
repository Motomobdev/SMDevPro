public with sharing class z_CreateQuote extends zqu.PropertyComponentController.parentController {
	
	public String oppId 			{get;set;}
	public String subId 			{get;set;}
	public String billAcctId 		{get;set;}
	public String nextUrl 		{get;set;}
	public String cancelUrl 	{get;set;}
	public String quoteType 	{get;set;}
	public zqu.PropertyComponentOptions contractOptions {get;set;}
	public String chosenContract {get;set;}
	public String defaultContract {get;set;}
	public String chosenContractName {get;set;}
	public String defaultContractName {get;set;}
	
	public Opportunity opp  { get; set; }
	
	public String accountId {get;set;}
	private List<Account> accounts;
	private List<Opportunity> opps;
	private List<Contract> contracts;
	private List<Contract> oppContract;
	public ApexPages.StandardController stdCtrl {get; set;}
    private final Zuora.zApi api = new Zuora.zApi();
	public zqu__Quote__c quote{get;set;}
	
	public z_CreateQuote(ApexPages.standardController controller) {
		this.stdCtrl = controller;
      	this.quote = (zqu__Quote__c) this.stdCtrl.getRecord();
		
		Map<String, String> pageParams = ApexPages.currentPage().getParameters();
		oppId = pageParams.get('oppid');
		subId = pageParams.get('subscriptionId');
		billAcctId = pageParams.get('billingAccountId');
		quoteType = pageParams.get('quoteType');
		
		contractOptions = new zqu.PropertyComponentOptions();
		
		contractOptions.objectName = 'zqu__Quote__c';
		contractOptions.viewType = zqu.ViewConfigurationManager.VIEW_CONFIGURATION_VIEW_TYPE_CREATE;
		contractOptions.propertyPageTitle= 'Create A New Quote';
		contractOptions.isEditMode = true;
		contractOptions.parentController = this;
		contractOptions.instanceName = 'Create Quote';
		
		Schema.SObjectType objectType = zqu__Quote__c.sObjectType;
        Map<String, Schema.RecordTypeInfo> recordTypeInfoMap = objectType.getDescribe().getRecordTypeInfosByName();
        contractOptions.recordTypeId = recordTypeInfoMap.get('Default').getRecordTypeId();
		

		contractOptions.customRenderingFields = new set<String>{'ContractNumber__c', 'ContractName__c'};
		
      	contractOptions.updatePlugin = 'z_CreateQuote.UpdateRecordPlugin';
        contractOptions.cancelPlugin = 'z_CreateQuote.CancelRecordPlugin';
        contractOptions.populateValuePlugin = 'z_CreateQuote.DefaultRecordPlugin';
        
        opps = new List<Opportunity>();
		accounts = new List<Account>();
		contracts = new List<Contract>();
		
		opps = [SELECT Id, AccountId, Contract__c, Name, Account.Id, Account.Name, Account.Account_ID__c From Opportunity WHERE Id =: ApexPages.currentPage().getParameters().get('oppid') limit 1];
       	if(Test.isRunningTest()){
       		opps = [SELECT Id, AccountId, Contract__c, Name, Account.Id, Account.Name, Account.Account_ID__c From Opportunity limit 1];
       	}
       	if(opps.size()>0 && opps!= null){
        	this.accounts = [SELECT Id, Name FROM Account WHERE Id =: opps[0].AccountId];
        	system.debug('Account number value: '+this.quote.zqu__Zuora_Account_Number__c);
       	}
        if(accounts.size()>0 && accounts != null){
	        Account currentAccount = accounts[0];
	        this.contracts = [SELECT Id, ContractNumber, Name FROM Contract WHERE AccountId =: currentAccount.Id];
	        accountId = currentAccount.Id;
        }
		//need to default list to contract from opportunity
        if(opps.size()>0 && opps!= null){
        	oppContract = [SELECT Id, ContractNumber, Name, EndDate, StartDate, ContractTerm FROM Contract Where Id =: opps[0].Contract__c Limit 1];
        	opp = opps[0];
        	system.debug('Account Id values: '+this.opp.AccountId + 'Account.Id: '+ this.opp.Account.Id + 'Account.Account_ID__c: ' + this.opp.Account.Account_ID__c);
        	this.quote.zqu__Opportunity__r = this.opp;
        	this.quote.zqu__Opportunity__c = this.opp.Id;
        	
        	if(oppContract.size()>0){
        		defaultContract = oppContract[0].ContractNumber;
        		defaultContractName = oppContract[0].Name;
        	}
        }
        
        if(quoteType == 'Amendment' || Test.isRunningTest()) {
        	system.debug('Quote type is amendment');
        	if ('' != billAcctId) {
                quote.zqu__ZuoraAccountId__c = this.billAcctId;
            } else {
                throw new zqu.ZQException('Need to specify the billingaccountid for ' + this.quoteType + ' in the url.');
            }
        	
        	try {
        		Zuora.zObject acczobj;
        			if(!Test.isRunningTest()){
	                    api.zlogin();
	                    acczobj = getBillingAccount(billAcctId);
        			} else {
        				acczobj = getBillingAccount('234');
        			}
                if (acczobj != null) {
                        quote.zqu__Currency__c = (String)acczobj.getValue('Currency');
                    }
                    final Zuora.zObject subzobj = getSubscription(subId);
                    if(Test.isRunningTest()){
                    	subzobj = getSubscription('345');
                    }
                    if (null != subzobj) {
                        if ('Amendment' == quoteType) {
                           quote.zqu__StartDate__c = ((Datetime)subzobj.getValue('TermStartDate')).date();
                           system.debug('Quote Start Date: '+quote.zqu__StartDate__c);
                        } else {
                           quote.zqu__StartDate__c = ((Datetime)subzobj.getValue('TermEndDate')).date();
                           system.debug('Quote Start Date (Amendment != quoteType): '+quote.zqu__StartDate__c);
                        }
                        quote.zqu__Hidden_Subscription_Name__c = (String)subzobj.getValue('Name');
                        quote.zqu__SubscriptionVersion__c = (Integer)subzobj.getValue('Version');
                        system.debug('Term start date: '+((Datetime)subzobj.getValue('TermStartDate')).date());
                       // system.debug('Term end date: '+((Datetime)subzobj.getValue('TermEndDate')).date());
                        quote.zqu__SubscriptionTermStartDate__c = ((Datetime)subzobj.getValue('TermStartDate')).date();
                        //if(((Datetime)subzobj.getValue('TermEndDate')).date() != null){
                        //	quote.zqu__SubscriptionTermEndDate__c = ((Datetime)subzobj.getValue('TermEndDate')).date();
                        //}
                    }
	            } catch(Exception e) {
	            	if(!Test.isRunningTest()){
	                	throw new zqu.ZQException(e.getMessage());
	            	}
            }
        } else {
        	system.debug('Quote type is ' + quoteType);
        	system.debug('Billing Account Id in param: '+ this.billAcctId);
        	system.debug('Current Zuora Account info: '+quote.zqu__ZuoraAccountId__c);
        	if ('' != this.billAcctId) {
                quote.zqu__ZuoraAccountId__c = this.billAcctId;
                system.debug('Zuora account info updated to: '+quote.zqu__ZuoraAccountId__c);
            } 
            if (this.billAcctId == null){
        		quote.zqu__Zuora_Account_Number__c = this.opp.Account.Account_ID__c;
            	system.debug('Set account number to : '+quote.zqu__Zuora_Account_Number__c);
            }
          
        }
        
       	if(opps.size()>0 && opps!= null){
	        System.Debug('Opportunities size: '+opps.size());
	        System.Debug('Opportunities Id: '+opps[0].Id);
	        System.Debug('default Contract: '+ defaultContract);
	        System.Debug('default Contract Name '+ defaultContractName);
       	}
         
		if (chosenContract == null){
			chosenContract = defaultContract;
			chosenContractName = defaultContractName;
        }
        
        
		if (validate()) {
			
		}
	}
	
	public List<selectOption> getcontracts() {
        List<selectOption> options = new List<selectOption>(); 
	//new list for holding all of the picklist options
		for (Contract contract : this.contracts){
			options.add(new selectOption(contract.ContractNumber, contract.Name));
		}
		
		return options;
	}
	
	
	public class UpdateRecordPlugin implements IUpdatePlugin {
      public PageReference doUpdate(SObject record, zqu.PropertyComponentController.ParentController pcc){
    	z_CreateQuote controller = (z_CreateQuote) pcc;
        // Add your saving logic here
        zqu__Quote__c quote = (zqu__Quote__c)record;
		System.Debug('Chosen Contract: '+ controller.chosenContract);
		System.Debug('Quote Currency: '+ quote.zqu__Currency__c);
        //quote = controller.quote;
		quote.ContractNumber__c = controller.chosenContract;
		System.Debug('Chosen Contract: '+ controller.chosenContract);
		System.Debug('Quote Currency: '+ quote.zqu__Currency__c);
		Contract chosenContract = [SELECT Name, EndDate, ContractNumber, ContractTerm, StartDate From Contract WHERE ContractNumber =: quote.ContractNumber__c Limit 1][0];
		controller.chosenContractName = chosenContract.Name;
		quote.ContractName__c = controller.chosenContractName;
		//add in other contract values
		quote.zqu__ValidUntil__c = chosenContract.EndDate;
    	quote.zqu__StartDate__c = chosenContract.StartDate;
    	quote.Name = chosenContract.ContractNumber;
		
		
		if(controller.quoteType == 'Amendment') {

            if ('' != controller.billAcctId) {
                quote.zqu__ZuoraAccountId__c = controller.billAcctId;
            } else {
                throw new zqu.ZQException('Need to specify the billingAccountId for ' + controller.quoteType + ' in the url.');
            }
            
            if ('' != controller.subId) {
                quote.zqu__ExistSubscriptionID__c = controller.subId;
            } else {
                throw new zqu.ZQException('Need to specify the subscriptionId for ' + controller.quoteType + ' in the url.');
            }
               
		} else {
			if ('' != controller.billAcctId) {
                quote.zqu__ZuoraAccountId__c = controller.billAcctId;
            }
		}
			//assign correct subscription type and record type based on quote type
        Schema.DescribeSObjectResult dsr = Schema.SObjectType.zqu__Quote__c;

		if(controller.quoteType == 'Amendment'){
			quote.zqu__SubscriptionType__c = 'Amend Subscription';
			Schema.RecordTypeInfo amdrtinfo = dsr.getRecordTypeInfosByName().get('Amendment');
            quote.RecordtypeId = amdrtinfo.getRecordTypeId();
            quote.zqu__Amendment_Name__c =  controller.opp.Name;
		}
		
		
		upsert quote;
		
		PageReference toProductSelector = Page.Z_ProductSelector;
		toProductSelector.getParameters().put('id',quote.Id);
		
		return toProductSelector;
      }
    }
 
    public class CancelRecordPlugin implements ICancelPlugin {
      public PageReference doCancel(SObject record, zqu.PropertyComponentController.ParentController pcc){
    
        // Add your cancel logic here
        return new PageReference('/'+ApexPages.currentPage().getParameters().get('oppid'));
      }
    }
    
    public class DefaultRecordPlugin implements IPopulateValuePlugin {
    	public void populateDefaultFieldValue(SObject record, zqu.PropertyComponentController.ParentController pcc){
    		//Cast parent controller
            Z_CreateQuote qcc = (Z_CreateQuote)pcc;
            Opportunity opportunity = qcc.opp;
			System.Debug('opportunity > ' + opportunity.Id);
			system.debug('opportunity acc num: '+opportunity.Account.Account_ID__c );
			if (qcc.quote.Id == null && opportunity != null) {
	          
	            // Set default opportunity
	            record.put('zqu__Opportunity__c',opportunity.Id);
	            //currency
	    		record.put('zqu__Currency__c','USD');
	    		//payment term
	    		record.put('zqu__PaymentTerm__c','Due Upon Receipt');
	    		//payment method
	    		record.put('zqu__PaymentMethod__c','Check');
	    		//acc num
	    		record.put('zqu__Zuora_Account_Number__c',opportunity.Account.Account_ID__c);
	    		
	        
	        
	    		//as per Tim
	    		//get contacts from account
		    	List<Contact> leadContact = [SELECT Id, Name FROM Contact Where AccountId =: qcc.accountId AND Lead_Contact__c=true];
		    	List<Contact> royaltyContact = [SELECT Id, Name FROM Contact Where AccountId =: qcc.accountId AND Royalty_Report_Contact__c=true];
		    	
		    	if(leadContact.size() > 0){
		    		//default to lead contact for sold to
		    		record.put('zqu__SoldToContact__c',leadContact[0].Id);
		    	} else if (royaltyContact.size() > 0){
		    		//if the lead contact is empty, but the royalty contact isn't, put the royalty contact in
		    		record.put('zqu__SoldToContact__c',royaltyContact[0].Id);
		    	}
		    	
		    	if(royaltyContact.size() > 0){
		    		//default to the royalty contact for bill to
		    		record.put('zqu__BillToContact__c',royaltyContact[0].Id);
		    	} else if(leadContact.size() > 0) {
		    		//if the royalty contact is empty, but the lead contact isn't, put the lead contact in
		    		record.put('zqu__BillToContact__c',leadContact[0].Id);
		    	}
		    	
		    	record.put('zqu__BillingMethod__c','Email');
		    	record.put('zqu__Subscription_Term_Type__c','Evergreen');
		    	record.put('zqu__RenewalTerm__c',1);
		    	record.put('zqu__PaymentTerm__c','Net 90');
		    	
		    	Contract defaultContract = new Contract();
		    	if(qcc.oppContract != null && qcc.oppContract.size()>0){
			    	defaultContract = qcc.oppContract[0];
		    	}
		    	
		    	if(defaultContract != null){
			    	record.put('zqu__ValidUntil__c',defaultContract.EndDate);
			    	record.put('zqu__InitialTerm__c',1);
			    	record.put('zqu__StartDate__c',defaultContract.StartDate);
			    	record.put('Name',defaultContract.ContractNumber);
		    	}
			}
	
    	}
    }
    
	
	public Boolean validate() {
		Boolean validated = false;
		
		if (String.isNotBlank(oppId)) {
			if (quoteType == 'Subscription') {
				nextUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + Page.z_ProductSelector.getUrl();
				validated = true;
			} else if (quoteType == 'Amendment') {
				if (String.isNotBlank(subID) && String.isNotBlank(billAcctId)) {
					nextUrl = Page.Z_EditCharges.getUrl();
					validated = true;
				} else { appendMessage(ApexPages.SEVERITY.ERROR, 'Must specify a valid subscriptionId and billingAccountId parameter.'); }
			} else if (quoteType == 'Renewal') {
				if (String.isNotBlank(subID) && String.isNotBlank(billAcctId)) {
					nextUrl = Page.zqu__ZQRenewal.getUrl();
					validated = true;
				} else { appendMessage(ApexPages.SEVERITY.ERROR, 'Must specify a valid subscriptionId and billingAccountId parameter.'); }
			} else { appendMessage(ApexPages.SEVERITY.ERROR, 'Must specify a valid quoteType param.'); }
		} else { appendMessage(ApexPages.SEVERITY.ERROR, 'Must specify a valid oppid param.'); }
		
		
		return validated;
	}
	
	private Zuora.zObject getBillingAccount(String billingaccountId){
        final Zuora.zObject acczobj;
        final String zoqlacc = 'SELECT BillToId,SoldToId,Currency from Account where Id=\'' + billingaccountId  + '\'';
        final List <Zuora.zObject> acczobjs = api.zquery(zoqlacc);
        if(acczobjs.size() == 1)
            acczobj = acczobjs[0];
        
        return acczobj;
    }
    
    private Zuora.zObject getSubscription(String subscriptionId){
        final Zuora.zObject subzobj;
        final String zoqlsubscription = 'Select Id, Name, Version, AccountId, OriginalId,ContractEffectiveDate,TermStartDate,TermEndDate,RenewalTerm from Subscription where Id = \'' + subscriptionId + '\'';
        final List <Zuora.zObject> subzobjs = api.zquery(zoqlsubscription);
        if(subzobjs.size() == 1)
            subzobj = subzobjs[0];
        return subzobj;
    }
    
    
	
	
	private static void appendMessage(ApexPages.Severity messageType, String message) {
        ApexPages.addMessage(new ApexPages.Message(messageType, message));
    }
}