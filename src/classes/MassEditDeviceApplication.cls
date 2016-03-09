public with sharing class MassEditDeviceApplication {
	public List<DeviceApplicationAssoc__c> devApps {get; set;}
	public Map<Id, Boolean> originalDevAppIncludeInBOMMap;
	public Map<Id, String> originalDevAppSpecRequirmentsMap;
	
	public MassEditDeviceApplication(ApexPages.StandardSetController controller) {
		devApps = new List<DeviceApplicationAssoc__c>();
		originalDevAppIncludeInBOMMap = new Map<Id, Boolean>();
		originalDevAppSpecRequirmentsMap = new Map<Id, String>();
		String id = ApexPages.currentPage().getParameters().get('Id');
		if(id.startsWith('a06')){
			// id is a device
			for(DeviceApplicationAssoc__c da : [SELECT Id, Device__c, Application__c, Include_in_BOM__c, Approval_Status__c, Source__c, Source_Name__c, Specific_Requirements__c FROM DeviceApplicationAssoc__c WHERE Device__c =: ApexPages.currentPage().getParameters().get('Id') AND Approval_Status__c != 'In Progress' ORDER BY Application__r.Name ASC]){
				devApps.add(da);
				originalDevAppIncludeInBOMMap.put(da.Id, da.Include_in_BOM__c);
				originalDevAppSpecRequirmentsMap.put(da.Id, da.Specific_Requirements__c);
			}
		} else if (id.startsWith('a07')){
			// id is an application
			for(DeviceApplicationAssoc__c da : [SELECT Id, Device__c, Application__c, Include_in_BOM__c, Approval_Status__c, Source__c, Source_Name__c, Specific_Requirements__c FROM DeviceApplicationAssoc__c WHERE Application__c =: ApexPages.currentPage().getParameters().get('Id') AND Approval_Status__c != 'In Progress' ORDER BY Application__r.Name ASC]){
				devApps.add(da);
				originalDevAppIncludeInBOMMap.put(da.Id, da.Include_in_BOM__c);
				originalDevAppSpecRequirmentsMap.put(da.Id, da.Specific_Requirements__c);
			}
		}
		
		
    }
    
    public PageReference saveChanges(){
    	List<DeviceApplicationAssoc__c> devAppsToUpdate = new List<DeviceApplicationAssoc__c>();
    	for(DeviceApplicationAssoc__c da : devApps){
    		if((da.Include_in_BOM__c != originalDevAppIncludeInBOMMap.get(da.Id)) || (da.Specific_Requirements__c != originalDevAppSpecRequirmentsMap.get(da.Id))){
    			devAppsToUpdate.add(da);
    		}
    	}
    	
    	if(!devAppsToUpdate.isEmpty()){ update devAppsToUpdate; }
    	
    	PageReference pr = new PageReference('/' + ApexPages.currentPage().getParameters().get('Id'));
        pr.setRedirect(true);
        return pr;
    }
    
    private static testmethod void MassEditCoreDevicePackageApplicationTest(){
    	Device__c d = new Device__c(Name='d');
		insert d;
		
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		
		DeviceApplicationAssoc__c da = new DeviceApplicationAssoc__c(Device__c=d.Id, Application__c=app.Id);
		insert da;
		
    	ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(new List<DeviceApplicationAssoc__c>{da});
        ApexPages.currentPage().getParameters().put('Id', d.Id);
        MassEditDeviceApplication instance = new MassEditDeviceApplication(setCon);
        
        instance.devApps[0].Include_in_BOM__c = false;
        PageReference pr = instance.saveChanges();
    }
}