public with sharing class viewDeviceCountries {
    public List<Country__c> includedCountries {get; set;}
    public Id targetId {get; set;}
     
    public viewDeviceCountries(ApexPages.StandardController controller) {
        includedCountries = new List<Country__c>();  
        targetId = ApexPages.currentPage().getParameters().get('Id');
        List<DeviceCountryAssoc__c> deviceCountries = [SELECT id, device__c, country__c FROM DeviceCountryAssoc__c WHERE device__c =: targetId ];
        
        Set<Id> includedCountryIds = new Set<Id>();
        for(Integer i=0; i<deviceCountries.size(); i++){
            includedCountryIds.add(deviceCountries[i].country__c);
        }

        for(Country__c c : [SELECT Id, Name FROM Country__c ORDER BY NAME ASC]){
            if(includedCountryIds.contains(c.Id)){
                includedCountries.add(c);
            }
        }
    }
    
	public static testMethod void testviewDeviceCountries(){
		Device__c d = new Device__c(Name='testD');
		insert d;
		
		d.Country__c='United States';
		update d;

		Apexpages.StandardController stanCon = new Apexpages.standardController(d);      
        PageReference pr = Page.viewDeviceCountries;
        pr.getParameters().put('id', d.id);
        test.setCurrentPage(pr);
        
        Test.startTest();
		viewDeviceCountries vdc = new viewDeviceCountries(stanCon);
		Test.stopTest();
		
	}     

}