public with sharing class viewContractCountries {
    public List<Country__c> includedCountries {get; set;}
    public List<Country__c> excludedCountries {get; set;}
    public Id targetId {get; set;}

    public viewContractCountries(ApexPages.StandardController controller) {
        includedCountries = new List<Country__c>();  
        excludedCountries = new List<Country__c>();       
        targetId = ApexPages.currentPage().getParameters().get('Id');
        List<ContCountryAssoc__c> contractCountries = [SELECT id, Contract__c, country__c FROM ContCountryAssoc__c WHERE Contract__c =: targetId];
        
        Set<Id> includedCountryIds = new Set<Id>();
        for(Integer i=0; i<contractCountries.size(); i++){
            includedCountryIds.add(contractCountries[i].country__c);
        }

        for(Country__c c : [SELECT Id, Name FROM Country__c WHERE Region__c != '' ORDER BY NAME ASC]){
            if(includedCountryIds.contains(c.Id)){
                includedCountries.add(c);
            }
            else{
                excludedCountries.add(c);
            }
        }
    }
    
    public Boolean getnoCountriesSelected(){
    	if(includedCountries.size() == 0){
    		return true;
    	}
    	return false;
    }
    
    public Boolean getallCountriesSelected(){
    	if(excludedCountries.size() == 0){
    		return true;
    	}
    	return false;
    }
    
	public static testMethod void testViewContractCountries(){
		Account a = new Account(Name='testA');
		insert a;
		
		Contract c = new Contract(Name='testC', AccountId=a.Id, StartDate=date.today());
		insert c;
		
		List<ContCountryAssoc__c> contractCountries = new List<ContCountryAssoc__c>();
		for(Country__c country: [SELECT Id, Name, Region__c FROM Country__c WHERE Region__c != '']){
			contractCountries.add(new ContCountryAssoc__c(contract__c=c.Id, country__c=country.Id));
		}		
				
		Apexpages.StandardController stanCon = new Apexpages.standardController(c);      
        PageReference pr = Page.viewContractCountries;
        pr.getParameters().put('id', c.id);
        test.setCurrentPage(pr);
        
        Test.startTest();
        // test with no ContractCountry
		viewContractCountries vcc = new viewContractCountries(stanCon);
		vcc.getallCountriesSelected();
		vcc.getnoCountriesSelected();
				
		// test with ContractCountry
		insert contractCountries;
		vcc = new viewContractCountries(stanCon);
		vcc.getallCountriesSelected();
		vcc.getnoCountriesSelected();
		
		Test.stopTest();
	}             
}