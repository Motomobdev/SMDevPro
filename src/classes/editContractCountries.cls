public with sharing class editContractCountries {
    public String targetId {get; set;}
    public String relationship {get; set;}
    
    // list of related countries (Legal_Application_Country__c)
    List<ContCountryAssoc__c> contractCountries;
    
    // list of all countries as cCountries
    public List<cCountry> allCountries {get; set;}
    
    public List<cCountry> asia {get; set;}
    public List<cCountry> australiaAndOceania {get; set;}
    public List<cCountry> centralAmericaAndTheCaribbean {get; set;}
    public List<cCountry> europe {get; set;}
    public List<cCountry> middleEastAndNorthAfrica {get; set;}
    public List<cCountry> northAmerica {get; set;}
    public List<cCountry> southAmerica {get; set;}
    public List<cCountry> subSaharanAfrica {get; set;}      
    
    Set<Id> preselectedCountries;
    
    Boolean allAsiaSelected = false;
    Boolean allAustraliaSelected = false;
    Boolean allcentralAmericaSelected = false;
    Boolean allEuropeSelected = false;
    Boolean allMiddleEastSelected = false;
    Boolean allNorthAmericaSelected = false;
    Boolean allSouthAmericaSelected = false;
    Boolean allSubAfricaSelected = false;   

    public editContractCountries(){
    
        allCountries = new List<cCountry>();
        
        asia = new List<cCountry>();
        australiaAndOceania = new List<cCountry>();
        centralAmericaAndTheCaribbean = new List<cCountry>();
        europe = new List<cCountry>();
        middleEastAndNorthAfrica = new List<cCountry>();
        northAmerica = new List<cCountry>();
        southAmerica = new List<cCountry>();
        subSaharanAfrica = new List<cCountry>();     
        
        // get target record Id from URL
        targetId = ApexPages.currentPage().getParameters().get('Id');
        
        // get list of existing Legal_Application_Country__c and update allCountriesMap with selected=true versions 
        preselectedCountries = new Set<Id>();
        contractCountries = [SELECT id, country__c, country__r.Name FROM ContCountryAssoc__c WHERE contract__c =: targetId];
        for(ContCountryAssoc__c conC : contractCountries){
            preselectedCountries.add(conC.Country__c);                
        }
        
        List<Country__c> cList = [SELECT Id, Name, Region__c FROM Country__c WHERE region__c != '' ORDER BY Name ASC];
        
        system.debug('SIZE clist / preselected: ' + cList.size() + ' / ' + preselectedCountries.size());
        
        if(cList.size() == preselectedCountries.size()){
			allAsiaSelected = true;
		    allAustraliaSelected = true;
		    allcentralAmericaSelected = true;
		    allEuropeSelected = true;
		    allMiddleEastSelected = true;
		    allNorthAmericaSelected = true;
		    allSouthAmericaSelected = true;
		    allSubAfricaSelected = true;          	
        }        
     
        for(Country__c c : cList){
            if(c.Region__c == 'Asia'){
                if(preselectedCountries.contains(c.Id)){
                    asia.add(new cCountry(true, c.Id, c.Name));
                }
                else {
                    asia.add(new cCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Australia and Oceania'){
                if(preselectedCountries.contains(c.Id)){
                    australiaAndOceania.add(new cCountry(true, c.Id, c.Name));
                }
                else {
                    australiaAndOceania.add(new cCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Central America and the Caribbean'){
                if(preselectedCountries.contains(c.Id)){
                    centralAmericaAndTheCaribbean.add(new cCountry(true, c.Id, c.Name));
                }
                else {
                    centralAmericaAndTheCaribbean.add(new cCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Europe'){
                if(preselectedCountries.contains(c.Id)){
                    europe.add(new cCountry(true, c.Id, c.Name));
                }
                else {
                    europe.add(new cCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Middle East and North Africa'){
                if(preselectedCountries.contains(c.Id)){
                    middleEastAndNorthAfrica.add(new cCountry(true, c.Id, c.Name));
                }
                else {
                    middleEastAndNorthAfrica.add(new cCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'North America'){
                if(preselectedCountries.contains(c.Id)){
                    northAmerica.add(new cCountry(true, c.Id, c.Name));
                }
                else {
                    northAmerica.add(new cCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'South America'){
                if(preselectedCountries.contains(c.Id)){
                    southAmerica.add(new cCountry(true, c.Id, c.Name));
                }
                else {
                    southAmerica.add(new cCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Sub-Saharan Africa'){
                if(preselectedCountries.contains(c.Id)){
                    subSaharanAfrica.add(new cCountry(true, c.Id, c.Name));
                }
                else {
                    subSaharanAfrica.add(new cCountry(false, c.Id, c.Name));
                }
            }
        }
    }
    
    public void selectAll(){
        selectAllAsia();
        selectAllAustralia();
        selectAllCentralAmerica();
        selectAllEurope();
        selectAllMiddleEast();
        selectAllNorthAmerica();
        selectAllSouthAmerica();
        selectAllSubAfrica();
    }    
    
    public void selectAllAsia(){
        for(Integer i=0; i<asia.size(); i++){
            if(!allAsiaSelected){
                asia[i].selected = true;
            }
            else {
                asia[i].selected = false;
            }
        }
        allAsiaSelected = !allAsiaSelected;
    }
    
    public void selectAllAustralia(){
        for(Integer i=0; i<australiaAndOceania.size(); i++){
            if(!allAustraliaSelected){
                australiaAndOceania[i].selected = true;
            }
            else {
                australiaAndOceania[i].selected = false;
            }
        }
        allAustraliaSelected = !allAustraliaSelected;
    }
    
    public void selectAllCentralAmerica(){
        for(Integer i=0; i<centralAmericaAndTheCaribbean.size(); i++){
            if(!allcentralAmericaSelected){
                centralAmericaAndTheCaribbean[i].selected = true;
            }
            else {
                centralAmericaAndTheCaribbean[i].selected = false;
            }
        }
        allcentralAmericaSelected = !allcentralAmericaSelected;
    }
    
    public void selectAllEurope(){
        for(Integer i=0; i<europe.size(); i++){
            if(!allEuropeSelected){
                europe[i].selected = true;
            }
            else {
                europe[i].selected = false;
            }
        }
        allEuropeSelected = !allEuropeSelected;
    }
    
    public void selectAllMiddleEast(){
        for(Integer i=0; i<middleEastAndNorthAfrica.size(); i++){
            if(!allMiddleEastSelected){
                middleEastAndNorthAfrica[i].selected = true;
            }
            else {
                middleEastAndNorthAfrica[i].selected = false;
            }
        }
        allMiddleEastSelected= !allMiddleEastSelected;
    }
    
    public void selectAllNorthAmerica(){
        for(Integer i=0; i<northAmerica.size(); i++){
            if(!allNorthAmericaSelected){
                northAmerica[i].selected = true;
            }
            else {
                northAmerica[i].selected = false;
            }
        }
        allNorthAmericaSelected = !allNorthAmericaSelected;
    }
    
    public void selectAllSouthAmerica(){
        for(Integer i=0; i<southAmerica.size(); i++){
            if(!allSouthAmericaSelected){
                southAmerica[i].selected = true;
            }
            else {
                southAmerica[i].selected = false;
            }
        }
        allSouthAmericaSelected = !allSouthAmericaSelected;
    }
    
    public void selectAllSubAfrica(){
        for(Integer i=0; i<subSaharanAfrica.size(); i++){
            if(!allSubAfricaSelected){
                subSaharanAfrica[i].selected = true;
            }
            else {
                subSaharanAfrica[i].selected = false;
            }
        }
        allSubAfricaSelected = !allSubAfricaSelected;
    }                                
    
    public void save(){
        List<ContCountryAssoc__c> newCountries = new List<ContCountryAssoc__c>();
        List<ContCountryAssoc__c> CountriesToDelete = new List<ContCountryAssoc__c>();
    
        for(Integer i=0; i<northAmerica.size(); i++){
            if(northAmerica[i].selected == true && !preselectedCountries.contains(northAmerica[i].countryId)){
                newCountries.add(new ContCountryAssoc__c(Contract__c=targetId, country__c=northAmerica[i].countryId));
            }
            else if(northAmerica[i].selected == false && preselectedCountries.contains(northAmerica[i].countryId)){
                for(Integer k=0; k<contractCountries.size(); k++){
                    if(contractCountries[k].country__c == northAmerica[i].countryId){
                        CountriesToDelete.add(contractCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<southAmerica.size(); i++){
            if(southAmerica[i].selected == true && !preselectedCountries.contains(southAmerica[i].countryId)){
                newCountries.add(new ContCountryAssoc__c(Contract__c=targetId, country__c=southAmerica[i].countryId));
            }
            else if(southAmerica[i].selected == false && preselectedCountries.contains(southAmerica[i].countryId)){
                for(Integer k=0; k<contractCountries.size(); k++){
                    if(contractCountries[k].country__c == southAmerica[i].countryId){
                        CountriesToDelete.add(contractCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<asia.size(); i++){
            if(asia[i].selected == true && !preselectedCountries.contains(asia[i].countryId)){
                newCountries.add(new ContCountryAssoc__c(Contract__c=targetId, country__c=asia[i].countryId));
            }
            else if(asia[i].selected == false && preselectedCountries.contains(asia[i].countryId)){
                for(Integer k=0; k<contractCountries.size(); k++){
                    if(contractCountries[k].country__c == asia[i].countryId){
                        CountriesToDelete.add(contractCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<europe.size(); i++){
            if(europe[i].selected == true && !preselectedCountries.contains(europe[i].countryId)){
                newCountries.add(new ContCountryAssoc__c(Contract__c=targetId, country__c=europe[i].countryId));
            }
            else if(europe[i].selected == false && preselectedCountries.contains(europe[i].countryId)){
                for(Integer k=0; k<contractCountries.size(); k++){
                    if(contractCountries[k].country__c == europe[i].countryId){
                        CountriesToDelete.add(contractCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<subSaharanAfrica.size(); i++){
            if(subSaharanAfrica[i].selected == true && !preselectedCountries.contains(subSaharanAfrica[i].countryId)){
                newCountries.add(new ContCountryAssoc__c(Contract__c=targetId, country__c=subSaharanAfrica[i].countryId));
            }
            else if(subSaharanAfrica[i].selected == false && preselectedCountries.contains(subSaharanAfrica[i].countryId)){
                for(Integer k=0; k<contractCountries.size(); k++){
                    if(contractCountries[k].country__c == subSaharanAfrica[i].countryId){
                        CountriesToDelete.add(contractCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<centralAmericaAndTheCaribbean.size(); i++){
            if(centralAmericaAndTheCaribbean[i].selected == true && !preselectedCountries.contains(centralAmericaAndTheCaribbean[i].countryId)){
                newCountries.add(new ContCountryAssoc__c(Contract__c=targetId, country__c=centralAmericaAndTheCaribbean[i].countryId));
            }
            else if(centralAmericaAndTheCaribbean[i].selected == false && preselectedCountries.contains(centralAmericaAndTheCaribbean[i].countryId)){
                for(Integer k=0; k<contractCountries.size(); k++){
                    if(contractCountries[k].country__c == centralAmericaAndTheCaribbean[i].countryId){
                        CountriesToDelete.add(contractCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<australiaAndOceania.size(); i++){
            if(australiaAndOceania[i].selected == true && !preselectedCountries.contains(australiaAndOceania[i].countryId)){
                newCountries.add(new ContCountryAssoc__c(Contract__c=targetId, country__c=australiaAndOceania[i].countryId));
            }
            else if(australiaAndOceania[i].selected == false && preselectedCountries.contains(australiaAndOceania[i].countryId)){
                for(Integer k=0; k<contractCountries.size(); k++){
                    if(contractCountries[k].country__c == australiaAndOceania[i].countryId){
                        CountriesToDelete.add(contractCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<middleEastAndNorthAfrica.size(); i++){
            if(middleEastAndNorthAfrica[i].selected == true && !preselectedCountries.contains(middleEastAndNorthAfrica[i].countryId)){
                newCountries.add(new ContCountryAssoc__c(Contract__c=targetId, country__c=middleEastAndNorthAfrica[i].countryId));
            }
            else if(middleEastAndNorthAfrica[i].selected == false && preselectedCountries.contains(middleEastAndNorthAfrica[i].countryId)){
                for(Integer k=0; k<contractCountries.size(); k++){
                    if(contractCountries[k].country__c == middleEastAndNorthAfrica[i].countryId){
                        CountriesToDelete.add(contractCountries[k]);
                    }
                }
            }
        }                                                                    
        
        insert newCountries;
        delete CountriesToDelete;
    }
    
    public class cCountry{
        public Boolean selected {get; set;}
        public Id countryId {get; set;}
        public String countryName {get; set;}
        
        public cCountry(Boolean selected, Id countryId, String countryName){
            this.selected = selected;
            this.countryId = countryId;
            this.countryName = countryName;
        }
    }
    
	public static testMethod void testeditContractCountries(){
		Account a = new Account(Name='testA');
		insert a;
		
		Contract c = new Contract(Name='testC', AccountId=a.Id, StartDate=date.today());
		insert c;
				
		Apexpages.StandardController stanCon = new Apexpages.standardController(c);      
        PageReference pr = Page.editContractCountries;
        pr.getParameters().put('id', c.id);
        test.setCurrentPage(pr);
        
        Test.startTest();
        editContractCountries ecc = new editContractCountries();
        ecc.selectAll();
        ecc.save();
        ecc = new editContractCountries(); 
        ecc.selectAll();
        ecc.save();
        
        Test.stopTest();
	}
}