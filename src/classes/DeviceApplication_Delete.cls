public with sharing class DeviceApplication_Delete {
	public static void beforeDelete(List<DeviceApplicationAssoc__c> oldList)
	{		
		List<Id> deviceIds = new List<Id>();
		for(DeviceApplicationAssoc__c da : oldList)
		{
			deviceIds.add(da.Device__c);
			//system.debug('THIS IS DA.SOURCE IN METHOD: ' + da.Source_Id__c);
			if(da.Source_Id__c != null && da.Source_Id__c != '' 
			/***********************************************
			    BEGIN: VHD Ticket #106915 - Profile Bypass for Deleting DevApps
				Modified By: Neel Desai
				Modified On: 16/Nov/2012
			************************************************/
				&& UserInfo.getProfileId() != '00e40000000oqQ9AAI' // MotoDev - SysAdmin
				&& UserInfo.getProfileId() != '00e40000000oqznAAA') // MotoDev - MotoReady Admin
			/***********************************************
				END: VHD Ticket #106915 - Profile Bypass for Deleting DevApps
			************************************************/
			{
				da.addError('You cannot delete the junction between this Application and Device because it was created via the Source relationship.');
			} 
		}	
		
		Map<Id, Device__c> deviceIdMap = new Map<Id, Device__c>([SELECT Id, SWBOM_Reviewed_and_Approved__c FROM Device__c WHERE Id IN : deviceIds]);
		
		for(DeviceApplicationAssoc__c da : oldList)
		{
			//system.debug('USER PROFILE: ' + UserInfo.getProfileId());
			if(deviceIdMap.get(da.Device__c).SWBOM_Reviewed_and_Approved__c == 'Yes' 
				&& UserInfo.getProfileId() != '00e40000000oqQ9AAI' // MotoDev - SysAdmin
				&& UserInfo.getProfileId() != '00e40000000oqznAAA') // MotoDev - MotoReady Admin
			{
				da.addError('You cannot delete this Device Appplication because the Devices SW BOM has been reviewed and approved.');
			}
		}
	}
	
	public static void afterDelete(List<DeviceApplicationAssoc__c> oldList){
		Set<Id> deviceIdsForSADateCalculation = new Set<Id>();
		Set<Id> devIdsInludeBomOrSDCard = new Set<Id>();
		Set<Id> devIdsForRoyaltyCalculation = new Set<Id>(); // for Royalty High Calculation
		
		for(DeviceApplicationAssoc__c da : oldList){		
			deviceIdsForSADateCalculation.add(da.Device__c);
					
			if(da.Include_in_BOM__c == true || da.Include_on_SD_Card__c == true){
				devIdsInludeBomOrSDCard.add(da.Device__c); // for % executed contracts on BOM/SD
				devIdsForRoyaltyCalculation.add(da.Device__c);
			}
			
			if(da.Royalty_High__c != null || da.Royalty_Low__c != null){
				devIdsForRoyaltyCalculation.add(da.Device__c);
			}
		}
		
		// calculate device royalty high cost
		if(!devIdsForRoyaltyCalculation.isEmpty()){
			DeviceMethods.calculateEstimatedRoyaltyCost(devIdsForRoyaltyCalculation);
		}		
		
		// calculate earliest SA Date for related contracts , testing for this code is in SADateMethods.cls
		if(!deviceIdsForSADateCalculation.isEmpty()){
			SADateMethods.devAppDeletedOrDevCancelledOrLaterDate(deviceIdsForSADateCalculation);
		}		
			
		/*** Begin calculate % contracts executed & on BOM/SD ***/
		if(!devIdsInludeBomOrSDCard.isEmpty()){
			DevAppsOnBomSDWithExecutedContracts.calculatePercentOfExecutedContractsOnBomOrSDCardFromDeviceId(devIdsInludeBomOrSDCard);
		}
		/*** end calculate % ***/
	}
	
	private static testmethod void beforeDeleteTest(){
        
        User nonAdminUser = [Select id From User Where ProfileID IN 
                             (Select id From Profile Where Name like 'MotoDev%' 
                              AND Name NOT IN ('MotoDev - SysAdmin','MotoDev - MotoReady Admin'))
                             AND isactive = true
                             limit 1];
        
        Device__c d = new Device__c(Name='device');
		insert d;
		
		Account account = new Account(Name='Account', Tier__c ='1');
		insert account;
		Application__c app = new Application__c(Name='app', Account__c=account.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		
		DeviceApplicationAssoc__c da = new DeviceApplicationAssoc__c(Device__c=d.Id, Application__c=app.Id, Source_Id__c=app.Id);
		insert da;
		system.debug('THIS IS DA.SOURCE: ' + da.Source_Id__c);
		Test.startTest();
        System.runAs(nonAdminUser){
        	
            try{
				delete da;
			} catch(System.DMLException e){
				System.assert(e.getMessage().contains('You cannot delete the junction between this Application and Device because it was created via the Source relationship.'));
			}
			
			da.Source_Id__c = null;
			update da;
			
			delete da;
        }
        
		Test.stopTest();
	}

}