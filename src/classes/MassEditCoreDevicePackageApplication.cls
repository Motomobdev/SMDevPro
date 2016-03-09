/**
Mass edit on core device package application.

CHANGE LOG

Author: Big Kite Consulting - Andy Leung
Date: July 11, 2012
Description:
-  Updated dynamic query based on sort field and sort.
-  Updated corresponding visualforce page on supporting column sorting.

*/
public with sharing class MassEditCoreDevicePackageApplication {
	public List<Core_Device_Package_Application__c> coreApps {get; set;}
	public Map<Id, Boolean> originalCoreAppsMap;
	public String sortOrder{get;set;}
    public String sortField{get;set;}
    public String previousSortField {get; set;}
	public Id id{get;set;}
	public MassEditCoreDevicePackageApplication(ApexPages.StandardSetController controller) {
		coreApps = new List<Core_Device_Package_Application__c>();
		originalCoreAppsMap = new Map<Id, Boolean>();
		if(sortOrder==null){
			sortOrder='ASC';
		}
		if(sortField==null){
			sortField='Application__r.name';
		}
    	id=ApexPages.currentPage().getParameters().get('Id');
		loadApps();
    }
    public void loadApps(){
    	List<Core_Device_Package_Application__c> cas=Database.query('SELECT Id, Core_Device_Package__c, Application__c, Include_in_BOM__c, Application__r.Application_Type__c, Source__c, Source_Name__c, Application__r.Royalty_Current__c FROM Core_Device_Package_Application__c WHERE Core_Device_Package__c =:id ORDER BY '+sortField+' '+sortOrder);
		if(!coreApps.isEmpty()){
			coreApps.clear();
		}
		if(!originalCoreAppsMap.isEmpty()){
			originalCoreAppsMap.clear();
		}
		for(Core_Device_Package_Application__c ca:cas){
			coreApps.add(ca);
			originalCoreAppsMap.put(ca.Id, ca.Include_in_BOM__c);
		}
    }
    public PageReference saveChanges(){
    	List<Core_Device_Package_Application__c> coreAppsToUpdate = new List<Core_Device_Package_Application__c>();
    	for(Core_Device_Package_Application__c cdpa : coreApps){
    		if(cdpa.Include_in_BOM__c != originalCoreAppsMap.get(cdpa.Id)){
    			coreAppsToUpdate.add(cdpa);
    		}
    	}
    	
    	if(!coreAppsToUpdate.isEmpty()){ update coreAppsToUpdate; }
    	
    	PageReference pr = new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference doSort(){
        sortOrder='asc';
        if(previousSortField==sortField){
            sortOrder='desc';
            previousSortField=null;
        }else{
            previousSortField=sortField;
        }
		loadApps();
        return null;
    }
    private static testmethod void MassEditCoreDevicePackageApplicationTest(){
    	Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp');
		insert cdp;
		
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c appOnCore = new Application__c(Name='appOnProgram', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert appOnCore;
		
		Core_Device_Package_Application__c cdpa = new Core_Device_Package_Application__c(Core_Device_Package__c=cdp.Id, Application__c=appOnCore.Id);
		insert cdpa;
		
    	ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(new List<Core_Device_Package_Application__c>{cdpa});
        ApexPages.currentPage().getParameters().put('Id', cdp.Id);
        MassEditCoreDevicePackageApplication instance = new MassEditCoreDevicePackageApplication(setCon);
        
        instance.coreApps[0].Include_in_BOM__c = false;
        PageReference pr = instance.saveChanges();
    }
}