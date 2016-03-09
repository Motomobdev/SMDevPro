public with sharing class Z_CustomQuoteEdit extends zqu.PropertyComponentController.ParentController{
    
    
    public zqu.PropertyComponentOptions theOptions {get;set;}
    
    public zqu.LookupComponentOptions billToOptions {get; set;}
    public zqu.LookupComponentOptions soldToOptions {get; set;}
    public zqu.LookupComponentOptions invoiceOwnerOptions {get; set;}
    public zqu.LookupComponentOptions quoteTemplateOptions {get; set;}
    
    public zqu__Quote__c quote {get; private set;}
    
    /*Ceda's values*/
    
	public zqu.PropertyComponentOptions contractOptions {get;set;}
	private final List<Account> accounts;
	private List<Contract> contracts;
	private final List<Opportunity> opportunities;
	public ApexPages.StandardController stdCtrl {get; set;}
	public String chosenContract {get; set;}
	public String chosenContractName {get; set;}
	public String mode {get;set;}
	public String defaultContract, defaultContractName;
	public Boolean refreshPage {get; set;}
    
    /**
     *        Constructor
     */
    public Z_CustomQuoteEdit(apexPages.StandardController test) {
        
        theOptions = new zqu.PropertyComponentOptions();
        theOptions.objectName = 'Quote__c';
        theOptions.viewType = zqu.ViewConfigurationManager.VIEW_CONFIGURATION_VIEW_TYPE_EDIT;
        theOptions.parentController = this;
        
        quote = [SELECT recordtypeId, zqu__opportunity__c, zqu__Currency__c, zqu__BillingMethod__c, zqu__PaymentTerm__c, zqu__ZuoraParentBillingAccountName__c , zqu__InvoiceOwnerId__c, zqu__InvoiceOwnerName__c, zqu__QuoteTemplate__c, zqu__QuoteTemplate__r.Name, zqu__BillToContact__c, zqu__BillToContact__r.Name, zqu__SoldToContact__c, zqu__SoldToContact__r.Name FROM zqu__Quote__c WHERE Id = :test.getId()];
        
        theOptions.recordTypeId = quote.RecordTypeId;
        theOptions.objectId = quote.Id;
        theOptions.isEditMode = true;
        
        theOptions.updatePlugin = 'Z_CustomQuoteEdit.SavePlugin';
        theOptions.cancelPlugin = 'Z_CustomQuoteEdit.CancelPlugin';
        
        //Bill to contact lookup
        
        billToOptions = new zqu.LookupComponentOptions();
        billToOptions.objectName = 'Contact';
        billToOptions.Id = 'BillToContact';
        billToOptions.contextParameters = new Map < String, String > {
          'objectId' => quote.zqu__Opportunity__c
        };
        billToOptions.isRequired = true;
        billToOptions.isEditMode = true;
        billToOptions.lookupComponentControllerName = 'zqu.ContactLookupComponentController';
        billToOptions.recordTypeId = Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Master').getRecordTypeId();
        billToOptions.popupWindowTitle = 'Bill To Contact Lookup';
        if(quote.zqu__BillToContact__c != null) {
            billToOptions.targetId = quote.zqu__BillToContact__c;
            billToOptions.targetName = quote.zqu__BillToContact__r.Name;
        }
        
        //Sold to contact lookup
        
        soldToOptions = new zqu.LookupComponentOptions();
        soldToOptions.objectName = 'Contact';
        soldToOptions.Id = 'SoldToContact';
        soldToOptions.contextParameters = new Map<String, String> {
          'objectId' => quote.zqu__Opportunity__c
        };
        soldToOptions.isRequired = true;
        soldToOptions.isEditMode = true;
        soldToOptions.lookupComponentControllerName = 'zqu.ContactLookupComponentController';
        soldToOptions.recordTypeId = Contact.SObjectType.getDescribe().getRecordTypeInfosByName().get('Master').getRecordTypeId();
        soldToOptions.popupWindowTitle = 'Sold To Contact Lookup';
        if(quote.zqu__SoldToContact__c != null) {
            soldToOptions.targetId = quote.zqu__SoldToContact__c;
            soldToOptions.targetName = quote.zqu__SoldToContact__r.Name;
        }
        //Quote template lookup

        quoteTemplateOptions = new zqu.LookupComponentOptions();
        quoteTemplateOptions.objectName = 'Quote_Template__c';
        quoteTemplateOptions.Id = 'quoteTemplateLookup';
        quoteTemplateOptions.isEditMode = true;
        quoteTemplateOptions.lookupComponentControllerName = 'zqu.QuoteTemplateLookupController';
        quoteTemplateOptions.recordTypeId = zqu__Quote_Template__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Master').getRecordTypeId();
        quoteTemplateOptions.popupWindowTitle = zqu__Quote_Template__c.SObjectType.getDescribe().getLabel(); 
        
        if(quote.zqu__QuoteTemplate__c != null) {
            quoteTemplateOptions.targetId = quote.zqu__QuoteTemplate__c;
            quoteTemplateOptions.targetName = quote.zqu__QuoteTemplate__r.Name;
        }
        
        theOptions.lookupFields.put('zqu__BillToContact__c', billToOptions);
        theOptions.lookupFields.put('zqu__SoldToContact__c', soldToOptions);
        theOptions.lookupFields.put('zqu__QuoteTemplate__c', quoteTemplateOptions);
        
        
        //Invoice owner
        
        invoiceOwnerOptions = new zqu.LookupComponentOptions();
        invoiceOwnerOptions.objectName = 'Zuora__CustomerAccount__c';
        invoiceOwnerOptions.Id = 'invoiceOwnerLookup';
        invoiceOwnerOptions.isEditMode = true;
        invoiceOwnerOptions.lookupComponentControllerName = 'zqu.CustomerAccountLookupComponentController';
        invoiceOwnerOptions.recordTypeId = Zuora__CustomerAccount__c.SObjectType.getDescribe().getRecordTypeInfosByName().get('Master').getRecordTypeId();
        invoiceOwnerOptions.popupWindowTitle = 'Billing Account Lookup';
        
        if(quote.zqu__InvoiceOwnerId__c != null) {
            List<Zuora__CustomerAccount__c> billingAcctList = [SELECT Id, Name FROM Zuora__CustomerAccount__c WHERE Zuora__Zuora_Id__c = :quote.zqu__InvoiceOwnerId__c];
            if(billingAcctList.size() > 0) {
                invoiceOwnerOptions.targetId = billingAcctList[0].Id;
                invoiceOwnerOptions.targetName = billingAcctList[0].Name;
            }
        }
        
        theOptions.customRenderingFields = new Set<String>{'zqu__InvoiceOwnerName__c','ContractNumber__c', 'ContractName__c'};
        
        
        contractOptions = new zqu.PropertyComponentOptions();
		
		contractOptions.objectName = 'zqu__Quote__c';
		contractOptions.viewType = zqu.ViewConfigurationManager.VIEW_CONFIGURATION_VIEW_TYPE_EDIT;
		contractOptions.propertyPageTitle= 'Property Component Sample';
		contractOptions.isEditMode = true;
		contractOptions.parentController = this;
		contractOptions.instanceName = 'Create Quote';
		
		Schema.SObjectType objectType = zqu__Quote__c.sObjectType;
        Map<String, Schema.RecordTypeInfo> recordTypeInfoMap = objectType.getDescribe().getRecordTypeInfosByName();
        contractOptions.recordTypeId = recordTypeInfoMap.get('Default').getRecordTypeId();
		

		contractOptions.customRenderingFields = new set<String>{'ContractNumber__c', 'ContractName__c'};
		
		
		
		
		//get the contract list
		if(quote != null){
	        List<Opportunity> opps = [SELECT Id, AccountId, Contract__c From Opportunity WHERE Id =: quote.zqu__opportunity__c];
	        this.accounts = [SELECT Id, Name FROM Account WHERE Id =: opps[0].AccountId];
	        if(accounts.size()>0){
		        Account currentAccount = accounts[0];
		        this.contracts = [SELECT Id, ContractNumber, Name FROM Contract WHERE AccountId =: currentAccount.Id];
	        }
			//need to default list to contract from opportunity
	        if(opps.size()>0){
	        	List<Contract> oppContracts = [SELECT Id, ContractNumber, Name FROM Contract Where Id =: opps[0].Contract__c];
	        	if(oppContracts.size()>0){
	        		defaultContract = oppContracts[0].ContractNumber;
	        		defaultContractName = oppContracts[0].Name;
	        	}
	        }
	       
	        System.Debug('Opportunities size: '+opps.size());
	        System.Debug('Opportunities Id: '+opps[0].Id);
	        System.Debug('default Contract: '+ defaultContract);
	        System.Debug('default Contract Name '+ defaultContractName);
	         
			if (chosenContract == null){
				chosenContract = defaultContract;
				chosenContractName = defaultContractName;
	        }
		}
        
    }
    
    /**
     *        Save quote (edited or no)
     */
    
    public class SavePlugin implements IUpdatePlugin {
        public PageReference doUpdate(SObject Record, zqu.PropertyComponentController.ParentController pcc) {
            //Cast parent controller
            Z_CustomQuoteEdit qec = (Z_CustomQuoteEdit)pcc;
            if(qec == null) return null;
            
            //Retrieve invoice owner options object from parent controller
            zqu.LookupComponentOptions parentInvoiceOwnerOptions = qec.invoiceOwnerOptions;
            if(parentInvoiceOwnerOptions == null) return null;

            //Update the new value of the custom render invoice owner lookup field
            if(String.isNotBlank(parentInvoiceOwnerOptions.targetName) &&
               String.isNotBlank(parentInvoiceOwnerOptions.targetId)) {
                   List<Zuora__CustomerAccount__c> billingAcctList = [SELECT Id, Name, Zuora__Zuora_Id__c FROM Zuora__CustomerAccount__c WHERE Id = :parentInvoiceOwnerOptions.targetId];
                   if(billingAcctList.size() > 0) {
                       Record.put('zqu__InvoiceOwnerName__c', billingAcctList[0].Name);
                       Record.put('zqu__InvoiceOwnerId__c', billingAcctList[0].Zuora__Zuora_Id__c);
                   }
            }
            
            //make sure custom fields are updated
            Record.put('ContractNumber__c', qec.chosenContract);
			if([SELECT Name FROM Contract WHERE ContractNumber =: qec.chosenContract].size()> 0){
				 Record.put('ContractName__c', [SELECT Name From Contract WHERE ContractNumber =: qec.chosenContract][0].Name);
			}
        
            //Upsert quote
            try {
                upsert Record;
            }
            catch(DmlException ex) {
                ApexPages.addMessages(ex);
                return null;
            }
            return new PageReference('/' + Record.Id);
        }
    }
    
    /**
     *        Cancel edit quote
     */
    public class CancelPlugin implements ICancelPlugin {
        public PageReference doCancel(SObject Record, zqu.PropertyComponentController.ParentController pcc) {
            return new PageReference('/' + Record.Id);
        }
    }
    
    /**
     *        Create select list options for contract dropdown
     */    
    public List<selectOption> getcontracts() {
        List<selectOption> options = new List<selectOption>(); 

		options.add(new selectOption('','   - None -   '));
		for (Contract contract : this.contracts){
			options.add(new selectOption(contract.ContractNumber, contract.Name));
		}
		
		return options;
	}
	
    
    
}