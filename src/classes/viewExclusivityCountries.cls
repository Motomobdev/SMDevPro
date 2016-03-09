public with sharing class viewExclusivityCountries {
    public List<Apttus_Country__c> includedCountries {get; set;}
    public List<Apttus_Country__c> excludedCountries {get; set;}
    public Id targetId {get; set;}

    public viewExclusivityCountries(ApexPages.StandardController controller) {
        includedCountries = new List<Apttus_Country__c>();  
        excludedCountries = new List<Apttus_Country__c>();       
        targetId = ApexPages.currentPage().getParameters().get('Id');
        List<Agreement_Exclusivity_Assoc__c> exclusivityCountries = [SELECT id, Agreement__c, Country__c FROM Agreement_Exclusivity_Assoc__c WHERE Agreement__c =: targetId];
        
        Set<Id> includedCountryIds = new Set<Id>();
        for(Integer i=0; i<exclusivityCountries.size(); i++){
            includedCountryIds.add(exclusivityCountries[i].Country__c);
        }

        for(Apttus_Country__c c : [SELECT Id, Name FROM Apttus_Country__c WHERE Region__c != '' ORDER BY NAME ASC]){
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
    
    public static testMethod void testViewExclusivityCountries(){

    
    Apttus__APTS_Agreement__c ag = new Apttus__APTS_Agreement__c();
    insert ag;
    
    List<Agreement_Exclusivity_Assoc__c> exclusivityCountries = new List<Agreement_Exclusivity_Assoc__c>();
    for(Apttus_Country__c country: [SELECT Id, Name, Region__c FROM Apttus_Country__c WHERE Region__c != '']){
      exclusivityCountries.add(new Agreement_Exclusivity_Assoc__c(Agreement__c=ag.Id, Country__c=country.Id));
    }    
        
    Apexpages.StandardController stanCon = new Apexpages.standardController(ag);      
        PageReference pr = Page.viewExclusivityCountries;
        pr.getParameters().put('id', ag.id);
        test.setCurrentPage(pr);
        
        Test.startTest();
        // test with no ContractCountry
    viewExclusivityCountries vcc = new viewExclusivityCountries(stanCon);
    vcc.getallCountriesSelected();
    vcc.getnoCountriesSelected();
        
    // test with ContractCountry
    insert exclusivityCountries;
    vcc = new viewExclusivityCountries(stanCon);
    vcc.getallCountriesSelected();
    vcc.getnoCountriesSelected();
    
    Test.stopTest();
  }            
}