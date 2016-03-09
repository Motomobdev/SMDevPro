public with sharing class DeviceApplication_Insert {	
	//public static boolean firstRun = true;
	
	public static void beforeInsert(List<DeviceApplicationAssoc__c> newList){
		/*if (firstRun) {
			firstRun = false;
		}
		else {
			System.debug('Already ran!');
			return;
		}*/
		
		Set<Id> appIds = new Set<Id>();
		Set<Id> devIds = new Set<Id>();
		
		for(Integer i=0; i<newList.size(); i++){
			// get list of related App Id's
			appIds.add(newList[i].Application__c);
			devIds.add(newList[i].Device__c);
		}
		system.debug('THIS IS NEWLIST BEFORE METHOD: ' + newList);
		DeviceApplicationMethods.checkForDuplicates(newList, devIds, appIds);
		system.debug('THIS IS NEWLIST AFTER METHOD: ' + newList);
		
		Map<Id, Application__c> appMap = new Map<Id, Application__c>([SELECT Id, X3rd_Party_Approval_Required__c, Account__r.OwnerId FROM Application__c WHERE Id IN : appIds]);
		
		Map<Id, Device__c> devicesMap = new Map<Id, Device__c>([SELECT Id, SW_Kit__c, SW_Kit__r.Effective_Date__c FROM Device__c WHERE Id IN : devIds]);
		
		if(!appMap.isEmpty()){
			//PopulateFieldsOnDevApp.populateContractOwner(trigger.new, appIds);
			
			// maintain 3rd party approval status field && set AcctOwner field
			for(Integer i=0; i<newList.size(); i++){
				if(appMap.containsKey(newList[i].Application__c)){
					newList[i].AcctOwner__c = appMap.get(newList[i].Application__c).Account__r.OwnerId;
						
					newList[i].X3rd_Party_Approval_Required__c = appMap.get(newList[i].Application__c).X3rd_Party_Approval_Required__c;					
					if(newList[i].X3rd_Party_Approval_Required__c == true){
		                newList[i].X3rd_Party_Approval_Status__c = 'In Progress';
		            }
		            else{
		                newList[i].X3rd_Party_Approval_Status__c = 'N/A';
		            }
				}			
			}
		}
		
		// Fill DevApp Item Effectife Date on new DevApp
		for(Integer i=0; i<newList.size(); i++){
			if(devicesMap.get(newList[i].Device__c) != null && devicesMap.get(newList[i].Device__c).SW_Kit__c != null && devicesMap.get(newList[i].Device__c).SW_Kit__r.Effective_Date__c != null){
				newList[i].DevApp_Item_Effective_Date__c = devicesMap.get(newList[i].Device__c).SW_Kit__r.Effective_Date__c;
			}
		}
	}
	
/*
 *
 * Royalty Cost code tested by CreateNewDevAppRecord.testSubmitDevAppsForApproval()
 */
	
	public static void afterInsert(List<DeviceApplicationAssoc__c> newList){
		Set<Id> deviceIdsForSADateCalculation = new Set<Id>(); //for SADateCalculation
		Set<Id> appIds = new Set<Id>();
		Set<Id> devIdsInludeBomOrSDCard = new Set<Id>();
		Set<Id> devIdsForRoyaltyCalculation = new Set<Id>(); // for Royalty High Calculation
		List<DeviceApplicationAssoc__c> coreDeviceApplications = new List<DeviceApplicationAssoc__c>();

		for(DeviceApplicationAssoc__c da : newList){
			if(da.SA_Date__c != null){ deviceIdsForSADateCalculation.add(da.Device__c); }
			appIds.add(da.Application__c); 
			
			// for % executed contracts on BOM/SD
			if((da.Include_in_BOM__c == true || da.Include_on_SD_Card__c == true)){
				devIdsInludeBomOrSDCard.add(da.Device__c); 
			}
			
			if((da.Royalty_High__c != null || da.Royalty_Low__c != null) && (da.Include_in_BOM__c == true || da.Include_on_SD_Card__c == true) && (da.Royalty_High__c != 0.0000 || da.Royalty_Low__c != 0.0000)){
				devIdsForRoyaltyCalculation.add(da.Device__c);
			}
		}
		
		// calculate device royalty high cost
		if(!devIdsForRoyaltyCalculation.isEmpty()){
			DeviceMethods.calculateEstimatedRoyaltyCost(devIdsForRoyaltyCalculation);
		}
		
		// calculate earliest SA Date for related contracts , testing for this code is in SADateMethods.cls
		if(!deviceIdsForSADateCalculation.isEmpty()){ SADateMethods.newDevAppOrEarlierDate(deviceIdsForSADateCalculation); }
		
		/*** Begin calculate % contracts executed & on BOM/SD ***/
		if(!devIdsInludeBomOrSDCard.isEmpty()){
			DevAppsOnBomSDWithExecutedContracts.calculatePercentOfExecutedContractsOnBomOrSDCardFromDeviceId(devIdsInludeBomOrSDCard);
		}
		/*** end calculate % ***/	
	}
}