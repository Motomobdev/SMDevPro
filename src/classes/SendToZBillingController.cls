public with sharing class SendToZBillingController {
	public zqu__Quote__c quote{get; set;}
	public final List<zqu.ZChargeGroup> chargeGroupList {get; set;}
    private final ApexPages.StandardController controller;
    private String quoteType;
    private boolean hasRun=false;
    private integer sendCounter = 0;
    private integer sendtozbillingcallcount = 0;
    public boolean sendCalled = false;
	//
	public SendToZBillingController(ApexPages.StandardController controller){
		System.Debug('Entered the Send to ZBilling Controller (custom)');
		this.controller = controller;
		this.quote = [SELECT zqu__Amendment_Name__c, zqu__AmendmentName__c, zqu__AutoRenew__c, 
						zqu__BillToContact__c, zqu__BillingCycleDay__c, zqu__CancellationDate__c, zqu__CancellationEffectiveDate__c, 
						ContractID__c, ContractName__c, CreatedById, CreatedDate, zqu__Currency__c, CurrencyIsoCode, zqu__Customer_Acceptance_Date__c, 
						IsDeleted, zqu__DeltaMRR__c, zqu__DeltaTCV__c, zqu__Description__c, zqu__ElectronicPaymentMethodId__c, zqu__ExistSubscriptionID__c, 
						zqu__GenerateInvoice__c, zqu__Hidden_Subscription_Name__c, zqu__InitialTerm__c, zqu__BillingMethod__c, zqu__InvoiceID__c, 
						zqu__InvoiceOwnerName__c, zqu__InvoiceOwnerId__c, zqu__InvoiceProcessingOption__c, zqu__InvoiceTargetDate__c, 
						zqu__Is_Parent_Quote__c, LastModifiedById, LastModifiedDate, zqu__MRR__c, zqu__Number__c, zqu__Opportunity__c, OwnerId, 
						zqu__ParentQuote__c, zqu__PaymentMethod__c, zqu__PaymentTerm__c, zqu__ProductSelectorVersion__c, Name, zqu__QuoteTemplate__c, 
						ConnectionReceivedId, Id, RecordTypeId, zqu__RecordReadOnly__c, zqu__RenewalTerm__c, ConnectionSentId, zqu__Service_Activation_Date__c, 
						zqu__SoldToContact__c, zqu__Terms__c, zqu__StartDate__c, zqu__Status__c, zqu__Subscription_Name__c, zqu__SubscriptionName__c, 
						zqu__SubscriptionTermEndDate__c, zqu__SubscriptionTermStartDate__c, zqu__Subscription_Term_Type__c, zqu__SubscriptionType__c, 
						zqu__SubscriptionVersion__c, SystemModstamp, zqu__TCV__c, zqu__Tax__c, zqu__TermStartDate__c, zqu__Total__c, zqu__ValidUntil__c, 
						zqu__ZuoraAccountID__c, zqu__Zuora_Account_Number__c, zqu__ZuoraConfig__c, zqu__ZuoraParentBillingAccountId__c, 
						zqu__ZuoraParentBillingAccountName__c, zqu__ZuoraPaymentID__c, zqu__ZuoraSubscriptionID__c       
					  FROM zqu__Quote__c 
                   	  WHERE Id = :this.controller.getRecord().Id ][0];	//(zqu__Quote__c)controller.getRecord();//
        
        system.debug('zqu__Zuora_Account_Number__c val: ' + this.quote.zqu__Zuora_Account_Number__c);
        
		if (this.validate()) {
           try {
           		System.debug('Validate called.');
           		zqu.GlobalCustomFieldDefinition.QUOTE_FIELDS = new Set<String> { 'ContractName__c', 'ContractNumber__c' };
				zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> { 'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'Prepaid__c','CumulativeTo__c','CumulativeFrom__c', 'EffectivePrice_Display__c'  };
	
                chargeGroupList = zqu.zQuoteUtil.getChargeGroups(this.controller.getRecord().Id);   
           } catch(Exception e) {
           		if(e.getMessage()!= null){
               		System.debug('Appending error message from validate: '+ e.getMessage());
               		appendMessage(ApexPages.Severity.ERROR, e.getMessage());
           		}
           }
        }
        system.debug('Send called value (constructor): '+this.sendCalled);
	}
	
	public zqu__Quote__c getquote(){
		return this.quote;
	}
	
	
	public void send() {
		System.Debug('Custom send to zbilling send called.');
		sendCounter++;
		System.Debug('Send Count at: '+sendCounter);
			try {
				zqu.GlobalCustomFieldDefinition.QUOTE_FIELDS = new Set<String> { 'ContractName__c', 'ContractNumber__c' };
				zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> { 'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'Prepaid__c','CumulativeTo__c','CumulativeFrom__c'};
		
				System.debug('Given Quote Type: '+ this.quote.zqu__SubscriptionType__c);
				System.debug('zqu__ZuoraAccountId__c : '+ quote.zqu__ZuoraAccountId__c);
				if(quote.zqu__ZuoraAccountId__c != null && quote.zqu__ZuoraAccountId__c != ''){
					quoteType = quote.zqu__ZuoraAccountId__c;
				} else {
					quoteType = 'New';
				}
				
	       	 	System.debug('QuoteType variable has been set to '+quoteType);
       	 		
				String resultString = '';
					
       	 		if(!hasRun){
       	 			sendtozbillingcallcount++;
					System.Debug('Send to zbilling count: '+sendtozbillingcallcount);
					system.debug('Quote Id to send: '+ this.quote.Id);
					system.debug('Quote Type to send: '+ quoteType);
					final Map<String, String> finalRes = zqu.zQuoteUtil.sendToZBilling(this.quote.Id ,quoteType, true, null, null);//quoteType
       	 			hasRun=true;
       	 			system.debug('Has Run value: '+hasRun);
       	 		
					System.debug('FinalRes size: '+finalRes.size());
		            for (String result : finalRes.values()) {
		                resultString += result;
		            }
		            
	            
       	 		}
	            
	            if(resultString != 'null' && resultString != ''){
               		System.debug('Appending result String: '+ resultString);
		            appendMessage(ApexPages.Severity.INFO, resultString);
	            }
	            
		            
	         } catch(Exception e) {
	               		System.debug('Appending error message: '+ e.getMessage());
	            appendMessage(ApexPages.Severity.ERROR, e.getMessage());
	        }
	        
	        appendMessage(ApexPages.Severity.INFO, 'Send processing complete.');
	        this.sendCalled = true;
	        system.debug('Send called value: '+this.sendCalled);
		
		//return null;
	}
	
	private Boolean validate() {
        if (null == this.controller.getRecord() || null == this.controller.getRecord().Id) {
            appendMessage(ApexPages.Severity.ERROR, 'Need to specify the id of quote for creating subscription.');
            return false;
        }
        return true;
    }
	
	private static void appendMessage(ApexPages.Severity messageType, String message) {
        ApexPages.addMessage(new ApexPages.Message(messageType, message));
    }
    
    public PageReference goToQuote(){
    	return new PageReference('/' + this.quote.Id);
    }
    
    public Boolean getSendCalled(){
    	return this.sendCalled;
    }
}