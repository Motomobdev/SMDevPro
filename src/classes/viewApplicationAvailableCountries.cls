public with sharing class viewApplicationAvailableCountries {
    public List<Country__c> includedCountries {get; set;}
    public List<Country__c> excludedCountries {get; set;}
    public Id targetId {get; set;}

    public viewApplicationAvailableCountries(ApexPages.StandardController controller) {
        includedCountries = new List<Country__c>();  
        excludedCountries = new List<Country__c>();       
        targetId = ApexPages.currentPage().getParameters().get('Id');
        List<Application_Country__c> appLegalCountries = [SELECT id, Application__c, country__c FROM Application_Country__c WHERE Application__c =: targetId AND relationship__c = 'Available'];
        
        Set<Id> includedCountryIds = new Set<Id>();
        for(Integer i=0; i<appLegalCountries.size(); i++){
            includedCountryIds.add(appLegalCountries[i].country__c);
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
    
	public static testMethod void testViewApplicationCountries(){
		Account acc = new Account(Name='account');
		insert acc;
		
		Application__c app = new Application__c(name='app', Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		
		List<Application_Country__c> appCountries = new List<Application_Country__c>();
		for(Country__c c: [SELECT Id, Name, Region__c FROM Country__c WHERE Region__c != '']){
			appCountries.add(new Application_Country__c(Application__c=app.Id, country__c=c.Id, relationship__c='Available'));
		}		
				
		Apexpages.StandardController stanCon = new Apexpages.standardController(app);      
        PageReference pr = Page.viewApplicationAvailableCountries;
        pr.getParameters().put('id', app.id);
        test.setCurrentPage(pr);
        
        Test.startTest();
        // test with no appAvailableCountry
		viewApplicationAvailableCountries vaac = new viewApplicationAvailableCountries(stanCon);
		vaac.getallCountriesSelected();
		vaac.getnoCountriesSelected();
		
		// test with appAvailableCountry

		insert appCountries;
		vaac = new viewApplicationAvailableCountries(stanCon);
		vaac.getallCountriesSelected();
		vaac.getnoCountriesSelected();
		Test.stopTest();
	}    
}