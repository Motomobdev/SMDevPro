public with sharing class z_QuoteEnhancement {

	public String newQuoteUrl {get;set;}
	public String amendQuoteUrl {get;set;}
	
	
   // public String  selectedAccountType                 {get;set;}
    public String  selectedAccount                     {get;set;}
    public String  selectedSubscription                {get;set;}
   // public String  selectedSubscriptionType            {get;set;}
   // public String  selectedAmendmentType               {get;set;}
	
    public List<SelectOption> billingAccountList       {get;set;}
    public List<SelectOption> subscriptionList         {get;set;}
	
	
	public z_QuoteEnhancement () {
		newQuoteUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + Page.z_CreateQuote.getUrl();
		
		Pagereference amendPageRef = Page.z_CreateQuote;
		
		amendPageRef.getParameters().put('quoteType','Amendment');
		amendPageRef.getParameters().put('subscriptionId',this.selectedAccount);
		amendPageRef.getParameters().put('billingAccountId',this.selectedSubscription);
		amendQuoteUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + amendPageRef.getUrl();
		
		Pagereference newPageRef = Page.z_CreateQuote;
		newPageRef.getParameters().put('quoteType','New');
		newPageRef.getParameters().put('billingAccountId',this.selectedSubscription);
		
		newQuoteUrl = System.URL.getSalesforceBaseUrl().toExternalForm() + amendPageRef.getUrl();
	}
}