public with sharing class z_QuoteOption {
	
	public Id oppId {get;set;}
	public ApexPages.StandardController controller {get;set;}
	
	/** Used for testing **/
	public Boolean testCreateAccounts {get;set;}
	
	public z_QuoteOption(ApexPages.StandardController controller) {	
		this.controller = controller;
		this.testCreateAccounts = true;
		
		if (!validate()) {
			return;
		}
		
		this.oppId = controller.getId();	
	}
	
	public PageReference onload() {
		PageReference pref = null;
		
		if (String.isNotBlank(oppId)) {
			List<Opportunity> opps = [SELECT Id, AccountId FROM Opportunity WHERE Id =: oppId];
			if (opps.size() == 1) {
				Opportunity opp = opps.get(0);
				
				Zuora.zApi zApiInstance = new Zuora.zApi();
				try {
					if (!Test.isRunningTest()) {
						zApiInstance.zlogin();
					}
				} catch (Exception e) {
					
				}
				
				String accountQuery = 'Select Id From Account Where CrmId = \''+opp.AccountId+'\'';
				
				List<Zuora.zObject> accounts;
				
				if (!Test.isRunningTest()) {
				 	accounts = zApiInstance.zquery(accountQuery);
				} else {
					accounts = new List<Zuora.zObject> {new Zuora.zObject('Account') };
				}

				if (accounts.size() > 0 && testCreateAccounts) {
					pref = Page.z_QuoteEnhancement;
					pref.setRedirect(true);
					pref.getParameters().put('oppid', oppId);
				} else {
					pref = Page.z_CreateQuote;
					pref.setRedirect(true);
					pref.getParameters().put('oppid', oppid);
					pref.getParameters().put('quoteType', 'Subscription');
				}
			} 
		}
		
		return pref;
	}
	
	private Boolean validate() {
        if (null == this.controller || null == this.controller.getRecord() || null == this.controller.getRecord().Id) {
            return false;
        }
        return true;
    }
	
}