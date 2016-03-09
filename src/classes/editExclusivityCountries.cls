public with sharing class editExclusivityCountries {
    public String targetId {get; set;}
    public String relationship {get; set;}
    
    // list of related countries (Legal_Application_Country__c)
    List<Agreement_Exclusivity_Assoc__c> exclusivityCountries;
    
    // list of all countries as cCountries
    public List<eCountry> allCountries {get; set;}
    
    public List<eCountry> asia {get; set;}
    public List<eCountry> australiaAndOceania {get; set;}
    public List<eCountry> centralAmericaAndTheCaribbean {get; set;}
    public List<eCountry> europe {get; set;}
    public List<eCountry> middleEastAndNorthAfrica {get; set;}
    public List<eCountry> northAmerica {get; set;}
    public List<eCountry> southAmerica {get; set;}
    public List<eCountry> subSaharanAfrica {get; set;}      
    
    Set<Id> preselectedCountries;
    
    Boolean allAsiaSelected = false;
    Boolean allAustraliaSelected = false;
    Boolean allcentralAmericaSelected = false;
    Boolean allEuropeSelected = false;
    Boolean allMiddleEastSelected = false;
    Boolean allNorthAmericaSelected = false;
    Boolean allSouthAmericaSelected = false;
    Boolean allSubAfricaSelected = false;   

    public editExclusivityCountries(){
    
        allCountries = new List<eCountry>();
        
        asia = new List<eCountry>();
        australiaAndOceania = new List<eCountry>();
        centralAmericaAndTheCaribbean = new List<eCountry>();
        europe = new List<eCountry>();
        middleEastAndNorthAfrica = new List<eCountry>();
        northAmerica = new List<eCountry>();
        southAmerica = new List<eCountry>();
        subSaharanAfrica = new List<eCountry>();     
        
        // get target record Id from URL
        targetId = ApexPages.currentPage().getParameters().get('Id');
        
        // get list of existing Legal_Application_Country__c and update allCountriesMap with selected=true versions 
        preselectedCountries = new Set<Id>();
        exclusivityCountries = [SELECT id, Country__c, Country__r.Name FROM Agreement_Exclusivity_Assoc__c WHERE Agreement__c =: targetId];
        for(Agreement_Exclusivity_Assoc__c conC : exclusivityCountries){
            preselectedCountries.add(conC.Country__c);                
        }
        
        List<Apttus_Country__c> cList = [SELECT Id, Name, Region__c FROM Apttus_Country__c WHERE Region__c != '' ORDER BY Name ASC];
        
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
     
        for(Apttus_Country__c c : cList){
            if(c.Region__c == 'Asia'){
                if(preselectedCountries.contains(c.Id)){
                    asia.add(new eCountry(true, c.Id, c.Name));
                }
                else {
                    asia.add(new eCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Australia and Oceania'){
                if(preselectedCountries.contains(c.Id)){
                    australiaAndOceania.add(new eCountry(true, c.Id, c.Name));
                }
                else {
                    australiaAndOceania.add(new eCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Central America and the Caribbean'){
                if(preselectedCountries.contains(c.Id)){
                    centralAmericaAndTheCaribbean.add(new eCountry(true, c.Id, c.Name));
                }
                else {
                    centralAmericaAndTheCaribbean.add(new eCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Europe'){
                if(preselectedCountries.contains(c.Id)){
                    europe.add(new eCountry(true, c.Id, c.Name));
                }
                else {
                    europe.add(new eCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Middle East and North Africa'){
                if(preselectedCountries.contains(c.Id)){
                    middleEastAndNorthAfrica.add(new eCountry(true, c.Id, c.Name));
                }
                else {
                    middleEastAndNorthAfrica.add(new eCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'North America'){
                if(preselectedCountries.contains(c.Id)){
                    northAmerica.add(new eCountry(true, c.Id, c.Name));
                }
                else {
                    northAmerica.add(new eCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'South America'){
                if(preselectedCountries.contains(c.Id)){
                    southAmerica.add(new eCountry(true, c.Id, c.Name));
                }
                else {
                    southAmerica.add(new eCountry(false, c.Id, c.Name));
                }
            }
            
            if(c.Region__c == 'Sub-Saharan Africa'){
                if(preselectedCountries.contains(c.Id)){
                    subSaharanAfrica.add(new eCountry(true, c.Id, c.Name));
                }
                else {
                    subSaharanAfrica.add(new eCountry(false, c.Id, c.Name));
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
        List<Agreement_Exclusivity_Assoc__c> newCountries = new List<Agreement_Exclusivity_Assoc__c>();
        List<Agreement_Exclusivity_Assoc__c> CountriesToDelete = new List<Agreement_Exclusivity_Assoc__c>();
    
        for(Integer i=0; i<northAmerica.size(); i++){
            if(northAmerica[i].selected == true && !preselectedCountries.contains(northAmerica[i].countryId)){
                newCountries.add(new Agreement_Exclusivity_Assoc__c(Agreement__c=targetId, Country__c=northAmerica[i].countryId));
            }
            else if(northAmerica[i].selected == false && preselectedCountries.contains(northAmerica[i].countryId)){
                for(Integer k=0; k<exclusivityCountries.size(); k++){
                    if(exclusivityCountries[k].country__c == northAmerica[i].countryId){
                        CountriesToDelete.add(exclusivityCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<southAmerica.size(); i++){
            if(southAmerica[i].selected == true && !preselectedCountries.contains(southAmerica[i].countryId)){
                newCountries.add(new Agreement_Exclusivity_Assoc__c(Agreement__c=targetId, Country__c=southAmerica[i].countryId));
            }
            else if(southAmerica[i].selected == false && preselectedCountries.contains(southAmerica[i].countryId)){
                for(Integer k=0; k<exclusivityCountries.size(); k++){
                    if(exclusivityCountries[k].country__c == southAmerica[i].countryId){
                        CountriesToDelete.add(exclusivityCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<asia.size(); i++){
            if(asia[i].selected == true && !preselectedCountries.contains(asia[i].countryId)){
                newCountries.add(new Agreement_Exclusivity_Assoc__c(Agreement__c=targetId, Country__c=asia[i].countryId));
            }
            else if(asia[i].selected == false && preselectedCountries.contains(asia[i].countryId)){
                for(Integer k=0; k<exclusivityCountries.size(); k++){
                    if(exclusivityCountries[k].country__c == asia[i].countryId){
                        CountriesToDelete.add(exclusivityCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<europe.size(); i++){
            if(europe[i].selected == true && !preselectedCountries.contains(europe[i].countryId)){
                newCountries.add(new Agreement_Exclusivity_Assoc__c(Agreement__c=targetId, Country__c=europe[i].countryId));
            }
            else if(europe[i].selected == false && preselectedCountries.contains(europe[i].countryId)){
                for(Integer k=0; k<exclusivityCountries.size(); k++){
                    if(exclusivityCountries[k].country__c == europe[i].countryId){
                        CountriesToDelete.add(exclusivityCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<subSaharanAfrica.size(); i++){
            if(subSaharanAfrica[i].selected == true && !preselectedCountries.contains(subSaharanAfrica[i].countryId)){
                newCountries.add(new Agreement_Exclusivity_Assoc__c(Agreement__c=targetId, Country__c=subSaharanAfrica[i].countryId));
            }
            else if(subSaharanAfrica[i].selected == false && preselectedCountries.contains(subSaharanAfrica[i].countryId)){
                for(Integer k=0; k<exclusivityCountries.size(); k++){
                    if(exclusivityCountries[k].country__c == subSaharanAfrica[i].countryId){
                        CountriesToDelete.add(exclusivityCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<centralAmericaAndTheCaribbean.size(); i++){
            if(centralAmericaAndTheCaribbean[i].selected == true && !preselectedCountries.contains(centralAmericaAndTheCaribbean[i].countryId)){
                newCountries.add(new Agreement_Exclusivity_Assoc__c(Agreement__c=targetId, Country__c=centralAmericaAndTheCaribbean[i].countryId));
            }
            else if(centralAmericaAndTheCaribbean[i].selected == false && preselectedCountries.contains(centralAmericaAndTheCaribbean[i].countryId)){
                for(Integer k=0; k<exclusivityCountries.size(); k++){
                    if(exclusivityCountries[k].country__c == centralAmericaAndTheCaribbean[i].countryId){
                        CountriesToDelete.add(exclusivityCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<australiaAndOceania.size(); i++){
            if(australiaAndOceania[i].selected == true && !preselectedCountries.contains(australiaAndOceania[i].countryId)){
                newCountries.add(new Agreement_Exclusivity_Assoc__c(Agreement__c=targetId, Country__c=australiaAndOceania[i].countryId));
            }
            else if(australiaAndOceania[i].selected == false && preselectedCountries.contains(australiaAndOceania[i].countryId)){
                for(Integer k=0; k<exclusivityCountries.size(); k++){
                    if(exclusivityCountries[k].country__c == australiaAndOceania[i].countryId){
                        CountriesToDelete.add(exclusivityCountries[k]);
                    }
                }
            }
        }
        
        for(Integer i=0; i<middleEastAndNorthAfrica.size(); i++){
            if(middleEastAndNorthAfrica[i].selected == true && !preselectedCountries.contains(middleEastAndNorthAfrica[i].countryId)){
                newCountries.add(new Agreement_Exclusivity_Assoc__c(Agreement__c=targetId, Country__c=middleEastAndNorthAfrica[i].countryId));
            }
            else if(middleEastAndNorthAfrica[i].selected == false && preselectedCountries.contains(middleEastAndNorthAfrica[i].countryId)){
                for(Integer k=0; k<exclusivityCountries.size(); k++){
                    if(exclusivityCountries[k].country__c == middleEastAndNorthAfrica[i].countryId){
                        CountriesToDelete.add(exclusivityCountries[k]);
                    }
                }
            }
        }                                                                    
        
        insert newCountries;
        delete CountriesToDelete;
    }
    
    public class eCountry{
        public Boolean selected {get; set;}
        public Id countryId {get; set;}
        public String countryName {get; set;}
        
        public eCountry(Boolean selected, Id countryId, String countryName){
            this.selected = selected;
            this.countryId = countryId;
            this.countryName = countryName;
        }
    }
    public static testMethod void testeditExclusivityCountries(){
    
    Apttus__APTS_Agreement__c ag = new Apttus__APTS_Agreement__c();
    insert ag;
        
   // Apexpages.StandardController stanCon = new Apexpages.standardController(c);      
        PageReference pr = Page.editExclusivityCountries;
        pr.getParameters().put('id', ag.id);
        test.setCurrentPage(pr);
        
        Test.startTest();
        editExclusivityCountries ecc = new editExclusivityCountries();
        ecc.selectAll();
        ecc.save();
        ecc = new editExclusivityCountries(); 
        ecc.selectAll();
        ecc.save();
        
        Test.stopTest();
  }
}