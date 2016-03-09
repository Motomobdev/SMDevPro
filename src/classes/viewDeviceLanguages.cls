public with sharing class viewDeviceLanguages {
    public List<Language__c> includedLanguages {get; set;}
    public List<Language__c> excludedLanguages {get; set;}
    public String targetId {get; set;}  

    public viewDeviceLanguages(ApexPages.StandardController controller) {
        includedLanguages = new List<Language__c>();  
        excludedLanguages = new List<Language__c>();       
        targetId = ApexPages.currentPage().getParameters().get('Id');
                
        Set<Id> includedIds = new Set<Id>();
        
    	for(Language_Device__c deviceLanguage : [SELECT id, Language__c, Language__r.Name FROM Language_Device__c WHERE device__c =: targetId]){
            includedIds.add(deviceLanguage.Language__c);
        }
        
		for(Language__c c : [SELECT Id, Name FROM Language__c WHERE Name != 'Not Applicable (No language requirement)' ORDER BY NAME ASC]){
            if(includedIds.contains(c.Id)){
            	includedLanguages.add(c);
            }
            else{
            	excludedLanguages.add(c);
            }
    	}        
    }
    
    public Boolean getnoLanguagesSelected(){
    	if(includedLanguages.size() == 0){
    		return true;
    	}
    	return false;
    }
    
    public Boolean getnoLanguageRequired(){
    	if(includedLanguages.size() == 1 && includedLanguages[0].Name == 'Not Applicable (No language requirement)'){
    		return true;
    	}
    	return false;
    }    

    public Boolean getnoLanguageRequiredError(){
    	for(Integer i=0; i<includedLanguages.size(); i++){
    		if(includedLanguages[i].Name == 'Not Applicable (No language requirement)' && includedLanguages.size() > 1){
    			return true;
    		}
    	}    	
    	return false;
    }
    
    public Boolean getshowDetails(){
    	if(getnoLanguageRequired() || getnoLanguageRequiredError()){
    		return false;
    	}
    	return true;
    }
	public static testMethod void testviewDeviceLanguages(){
		Device__c d = new Device__c(Name='testD');
		insert d;
		List<Language_Device__c> deviceLanguages = new List<Language_Device__c>();
		for(Language__c language: [SELECT Id, Name FROM Language__c LIMIT 1]){
			deviceLanguages.add(new Language_Device__c(device__c=d.Id, Language__c=language.Id));
		}
		Account acc = new Account(Name='account');
		insert acc;
		Application__c a = new Application__c(Name='testA', Application_Type__c='Embedded', Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		Application__c b = new Application__c(Name='testB', Application_Type__c='Preload', Application_Sub_Type__c='faketype', Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert a;		
		insert b;
		List<Language_Application__c> appLanguages = new List<Language_Application__c>();
		for(Language__c language: [SELECT Id, Name FROM Language__c WHERE Name = 'Not Applicable (No language requirement)']){
			appLanguages.add(new Language_Application__c(application__c=a.Id, Language__c=language.Id));
		}
		
		Language__c germanfake = new Language__c(Name='germanfake');
		insert germanfake;
		Language_Application__c GermanLanguage = new Language_Application__c(application__c=a.Id, Language__c=germanfake.Id);
		Language_Application__c GermanLanguage2 = new Language_Application__c(application__c=b.Id, Language__c=germanfake.Id);
				
		Apexpages.StandardController stanCon = new Apexpages.standardController(d);      
        PageReference pr = Page.viewDeviceLanguages;
        pr.getParameters().put('id', d.id);
        test.setCurrentPage(pr);
        
        Test.startTest();
		viewDeviceLanguages vdoal = new viewDeviceLanguages(stanCon);
		vdoal.getnoLanguagesSelected();
		insert deviceLanguages;
		vdoal = new viewDeviceLanguages(stanCon);
		vdoal.getnoLanguagesSelected();
		vdoal.getnoLanguageRequired();
		vdoal.getshowDetails();
		
		Test.stopTest();
	}     
}