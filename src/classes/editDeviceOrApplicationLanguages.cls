public with sharing class editDeviceOrApplicationLanguages {
    public String targetId {get; set;}
    List<Language_Device__c> devLanguages;
    List<Language_Application__c> appLanguages;
    Set<Id> preselectedLanguages;
    Boolean allSelected = false;  
    public List<cLanguages> languages {get; set;}   
    
    Map<String,String> keyPrefixMap = SystemMethods.getPrefixNameObjectMap();
       
    public editDeviceOrApplicationLanguages(){
    	
	             
        targetId = ApexPages.currentPage().getParameters().get('Id');
        languages = new List<cLanguages>();
        preselectedLanguages = new Set<Id>();
        
        if(keyPrefixMap.get(targetId.subString(0,3)) == 'Device__c'){
        	devLanguages = [SELECT id, Language__c, Language__r.Name FROM Language_Device__c WHERE device__c =: targetId];
        	for(Language_Device__c deviceLanguage : devLanguages){
	            preselectedLanguages.add(deviceLanguage.Language__c);
	        }
	        
	        for(Language__c l : [SELECT Id, Name FROM Language__c WHERE Name != 'Not Applicable (No language requirement)' ORDER BY Name ASC]){
	            if(preselectedLanguages.contains(l.Id)){
     	           languages.add(new cLanguages(true, l.Id, l.Name));	
	            }
	            else{
 		       	   languages.add(new cLanguages(false, l.Id, l.Name));	            
	            }
	    	}	                	
        }
        else if(keyPrefixMap.get(targetId.subString(0,3)) == 'Application__c'){
        	appLanguages = [SELECT id, Language__c, Language__r.Name FROM Language_Application__c WHERE application__c =: targetId];
        	for(Language_Application__c applicationLanguage : appLanguages){
        		preselectedLanguages.add(applicationLanguage.Language__c);
        	}
        	
			if([SELECT Id, Application_Type__c FROM Application__c WHERE Id =: targetId].Application_Type__c == 'Preload'){
        		// app is type preload so Not Applicable is not a choice
        		for(Language__c l : [SELECT Id, Name FROM Language__c WHERE Name != 'Not Applicable (No language requirement)' ORDER BY Name ASC]){
		            if(preselectedLanguages.contains(l.Id)){
	     	           languages.add(new cLanguages(true, l.Id, l.Name));	
		            }
		            else{
	 		       	   languages.add(new cLanguages(false, l.Id, l.Name));	            
		            }
	    		}		
        	}
        	else{
        		for(Language__c l : [SELECT Id, Name FROM Language__c ORDER BY Name ASC]){
		            if(preselectedLanguages.contains(l.Id)){
	     	           languages.add(new cLanguages(true, l.Id, l.Name));	
		            }
		            else{
	 		       	   languages.add(new cLanguages(false, l.Id, l.Name));	            
		            }
	    		}        		
        	}        	
        }        
    }
    
    public void selectAll(){
        for(Integer i=0; i<languages.size(); i++){
            if(!allSelected){
                languages[i].selected = true;
            }
            else {
                languages[i].selected = false;
            }
            
            if(languages[i].languageName == 'Not Applicable (No language requirement)'){
            	languages[i].selected = false;
            }
        }
        allSelected = !allSelected;
    }
                        
    public void save(){
    	if(keyPrefixMap.get(targetId.subString(0,3)) == 'Device__c'){
	        List<Language_Device__c> newLanguages = new List<Language_Device__c>();
	        List<Language_Device__c> LanguagesToDelete = new List<Language_Device__c>();
	    
	        for(Integer i=0; i<languages.size(); i++){
	            if(languages[i].selected == true && !preselectedLanguages.contains(languages[i].languageId)){
	                newLanguages.add(new Language_Device__c(Device__c=targetId, language__c=languages[i].languageId));
	            }
	            else if(languages[i].selected == false && preselectedLanguages.contains(languages[i].languageId)){
	                for(Integer k=0; k<devLanguages.size(); k++){
	                    if(devLanguages[k].language__c == languages[i].languageId){
	                        LanguagesToDelete.add(devLanguages[k]);
	                    }
	                }
	            }
	        }
	        insert newLanguages;
	        delete LanguagesToDelete;
	        
	        devLanguages = [SELECT id, Language__c, Language__r.Name FROM Language_Device__c WHERE device__c =: targetId];    		
    	}
    	else if(keyPrefixMap.get(targetId.subString(0,3)) == 'Application__c'){
	        List<Language_Application__c> newLanguages = new List<Language_Application__c>();
	        List<Language_Application__c> LanguagesToDelete = new List<Language_Application__c>();
	    
	        for(Integer i=0; i<languages.size(); i++){
	            if(languages[i].selected == true && !preselectedLanguages.contains(languages[i].languageId)){
	                newLanguages.add(new Language_Application__c(Application__c=targetId, language__c=languages[i].languageId));
	            }
	            else if(languages[i].selected == false && preselectedLanguages.contains(languages[i].languageId)){
	                for(Integer k=0; k<appLanguages.size(); k++){
	                    if(appLanguages[k].language__c == languages[i].languageId){
	                        LanguagesToDelete.add(appLanguages[k]);
	                    }
	                }
	            }
	        }
	        
	        insert newLanguages;
	        delete LanguagesToDelete;    		
	        
	        appLanguages = [SELECT id, Language__c, Language__r.Name FROM Language_Application__c WHERE application__c =: targetId];
    	}
    	
    	
    }
    
    public class cLanguages{
        public Boolean selected {get; set;}
        public Id languageId {get; set;}
        public String languageName {get; set;}
        
        public cLanguages(Boolean selected, Id languageId, String languageName){
            this.selected = selected;
            this.languageId = languageId;
            this.languageName = languageName;
        }
    }
    
    public static testMethod void testeditDeviceOrApplicationLanguages(){
		Device__c d = new Device__c(Name='testD');
		insert d;
		List<Language_Device__c> deviceLanguages = new List<Language_Device__c>();
		for(Language__c language: [SELECT Id, Name FROM Language__c LIMIT 1]){
			deviceLanguages.add(new Language_Device__c(device__c=d.Id, Language__c=language.Id));
		}
		insert deviceLanguages;
		
		Account acc = new Account(Name='account');
		insert acc;
				
		Application__c a = new Application__c(Name='testA', Application_Type__c='Embedded', Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert a;
		Application__c b = new Application__c(Name='testB', Application_Type__c='Preload', Account__c=acc.Id, Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);	
		insert b;		
		List<Language_Application__c> appLanguages = new List<Language_Application__c>();
		for(Language__c language: [SELECT Id, Name FROM Language__c LIMIT 1]){
			appLanguages.add(new Language_Application__c(application__c=a.Id, Language__c=language.Id));
		}
		insert appLanguages;
		Language__c germanfake = new Language__c(Name='germanfake');
		insert germanfake;
		Language_Application__c GermanLanguage2 = new Language_Application__c(application__c=b.Id, Language__c=germanfake.Id);
		insert GermanLanguage2;
		
        PageReference pr = Page.editDeviceOrApplicationLanguages;
        pr.getParameters().put('id', d.id);
        test.setCurrentPage(pr);
        
        Test.startTest();
		editDeviceOrApplicationLanguages edoal = new editDeviceOrApplicationLanguages();
		edoal.selectAll();
		edoal.save();		
		edoal.selectAll();
		edoal.save();
		
        pr = Page.editDeviceOrApplicationLanguages;
        pr.getParameters().put('id', a.id);
        test.setCurrentPage(pr);
		edoal = new editDeviceOrApplicationLanguages();
		edoal.selectAll();
		edoal.save();
		edoal.selectAll();
		edoal.save();
		
        pr.getParameters().put('id', b.id);
        test.setCurrentPage(pr);
		edoal = new editDeviceOrApplicationLanguages();
		edoal.selectAll();
		edoal.save();
		edoal.selectAll();
		edoal.save();		
		
		Test.stopTest();
    }  
}