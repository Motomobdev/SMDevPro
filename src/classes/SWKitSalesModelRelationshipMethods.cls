public with sharing class SWKitSalesModelRelationshipMethods {
	public static void fillInLookupFieldsOnNewRecords(List<SWKit_SalesModel_Relationship__c> newList){
		Set<String> swKitNames = new Set<String>();
		Set<String> salesModelNames = new Set<String>();
		
		for(SWKit_SalesModel_Relationship__c swsm : newList){
			swKitNames.add(swsm.SWKit_Name__c);
			salesModelNames.add(swsm.SalesModel_Name__c);
		}
		
		Map<String, SW_Kit__c> swKitMap = new Map<String, SW_Kit__c>();
		for(SW_Kit__c sw : [SELECT Id, Name FROM SW_Kit__c WHERE Name IN : swKitNames]){
			swKitMap.put(sw.Name, sw);
		}
		
		Map<String, Sales_Model__c> salesModelMap = new Map<String, Sales_Model__c>();
		for(Sales_Model__c sm : [SELECT Id, Name FROM Sales_Model__c WHERE Name IN : salesModelNames]){
			system.debug('THIS IS SM.NAME: ' + sm.Name);
			salesModelMap.put(sm.Name, sm);
		} 
		
		Map<String, Sales_Model__c> smToInsert = new Map<String, Sales_Model__c>();
		for(SWKit_SalesModel_Relationship__c swsm : newList){
			if(swKitMap.get(swsm.SWKit_Name__c) != null){ swsm.SW_Kit__c = swKitMap.get(swsm.SWKit_Name__c).Id; }
			if(salesModelMap.get(swsm.SalesModel_Name__c)!= null){ 
				swsm.Sales_Model__c = salesModelMap.get(swsm.SalesModel_Name__c).Id; 
			} else {
				smToInsert.put(swsm.SalesModel_Name__c, new Sales_Model__c(Name=swsm.SalesModel_Name__c));
			}
		}
		
		if(!smToInsert.isEmpty()){
			insert smToInsert.values();
			for(SWKit_SalesModel_Relationship__c swsm : newList){
				if(salesModelMap.get(swsm.SalesModel_Name__c)== null){
					swsm.Sales_Model__c = smToInsert.get(swsm.SalesModel_Name__c).Id;
				}
			}
		}
	}
	
	public static void syncSalesModelsToDevicesWithSWKits(List<SWKit_SalesModel_Relationship__c> newList){
		Map<Id, List<Id>> swKitIdSalesModelIdMap = new Map<Id, List<Id>>();
		Map<String, String> swkitSMActiveMap = new Map<String, String>(); 
		
		for(SWKit_SalesModel_Relationship__c swsm : newList){
			swkitSMActiveMap.put(swsm.SW_Kit__c + '' + swsm.Sales_Model__c, swsm.Current_SWKIT_SM_Mapping__c);
			if(swsm.SW_Kit__c != null && swsm.Sales_Model__c != null){
				List<Id> tempList = swKitIdSalesModelIdMap.get(swsm.SW_Kit__c);
				if(tempList == null){
					tempList = new List<Id>{swsm.Sales_Model__c};
				} else {
					tempList.add(swsm.Sales_Model__c);
				}				
				swKitIdSalesModelIdMap.put(swsm.SW_Kit__c, tempList);
			}
		}
		
		//Map<Id, Device__c> deviceIdMap = new Map<Id, Device__c>([SELECT Id, SW_Kit__c FROM Device__c WHERE SW_Kit__c IN : swKitIdSalesModelIdMap.keySet()]);
		List<Device__c> deviceList = [SELECT Id, SW_Kit__c FROM Device__c WHERE SW_Kit__c IN : swKitIdSalesModelIdMap.keySet()];
		
		/*List<SalesModel_Device__c> existingSMDsToUpdate = [SELECT Id FROM SalesModel_Device__c WHERE Device__c IN : deviceIdMap.keySet() AND Active__c = true];
		if(!existingSMDsToUpdate.isEmpty()) {
			for(SalesModel_Device__c smd : existingSMDsToUpdate){
				smd.Active__c = false;
			} 
			update existingSMDsToUpdate; 
		}*/
		
		List<SalesModel_Device__c> smDsToInsert = new List<SalesModel_Device__c>();
		for(Device__c d : deviceList){
			if(swKitIdSalesModelIdMap.get(d.SW_Kit__c) != null){
				for(Id smID : swKitIdSalesModelIdMap.get(d.SW_Kit__c)){
					if(swkitSMActiveMap.get(d.SW_Kit__c + '' + smId) == 'N'){
						smDsToInsert.add(new SalesModel_Device__c(Sales_Model__c = smID, Device__c = d.Id, Active__c = false));
					} else {
						smDsToInsert.add(new SalesModel_Device__c(Sales_Model__c = smID, Device__c = d.Id, Active__c = true));
					}
				}
			}
		}
		insert smDsToInsert;
	}
	
	public static void syncSalesModelsToDevicesWithSWKits(List<Device__c> newList, List<Device__c> oldList){
		Set<Id> deviceIdsToRemoveSalesModel = new Set<Id>();
		Map<Id, Id> deviceIdSWKitIdMap = new Map<Id, Id>();
		
		for(Integer i=0; i<newList.size(); i++){
			system.debug('THIS IS SKIT NEW/ SW KIT OLD: ' + newList[i].SW_Kit__c + ' / ' + oldList[i].SW_Kit__c);
			if(newList[i].SW_Kit__c == null && oldList[i].SW_Kit__c != null){
				// kit was removed from device, remove salesmodel from device
				deviceIdsToRemoveSalesModel.add(newList[i].Id);
			} else if(newList[i].SW_Kit__c != oldList[i].SW_Kit__c && newList[i].SW_Kit__c != null && oldList[i].SW_Kit__c != null){
				// kit on device changed, update salesmodel from device to not active and add new salesmodel
				deviceIdsToRemoveSalesModel.add(newList[i].Id);
				deviceIdSWKitIdMap.put(newList[i].Id, newList[i].SW_Kit__c);
			} else if(newList[i].SW_Kit__c != null && oldList[i].SW_Kit__c == null){
				// kit added to device, add new salesmodel
				deviceIdSWKitIdMap.put(newList[i].Id, newList[i].SW_Kit__c);
			}
		}
		
		if(!deviceIdsToRemoveSalesModel.isEmpty()){ 
			delete [SELECT Id FROM SalesModel_Device__c WHERE Device__c IN : deviceIdsToRemoveSalesModel];
			
			/*List<SalesModel_Device__c> existingSMDsToUpdate = [SELECT Id FROM SalesModel_Device__c WHERE Device__c IN : deviceIdsToRemoveSalesModel AND Active__c = true];
			if(!existingSMDsToUpdate.isEmpty()) {
				for(SalesModel_Device__c smd : existingSMDsToUpdate){
					smd.Active__c = false;
				} 
				update existingSMDsToUpdate; 
			}*/
			 
		}
		
		if(!deviceIdSWKitIdMap.isEmpty()){
			Set<String> existingDeviceIdSMIdMatches = new Set<String>();
			for(SalesModel_Device__c existingSMD : [SELECT Sales_Model__c, Device__c FROM SalesModel_Device__c WHERE Device__c IN : deviceIdSWKitIdMap.keySet()]){
				existingDeviceIdSMIdMatches.add(existingSMD.Device__c + '' + existingSMD.Sales_Model__c);
			}
			
			
			List<SalesModel_Device__c> SMDevicesToInsert = new List<SalesModel_Device__c>();
			Map<Id, List<Id>> SWKitIdSMIdMap = new Map<Id, List<Id>>();
			for(SWKit_SalesModel_Relationship__c swsm : [SELECT SW_Kit__c, Sales_Model__c FROM SWKit_SalesModel_Relationship__c WHERE SW_Kit__c IN : deviceIdSWKitIdMap.values()]){
				List<Id> tempList = SWKitIdSMIdMap.get(swsm.SW_Kit__c);
				if(tempList == null){
					tempList = new List<Id>{swsm.Sales_Model__c};
				} else {
					tempList.add(swsm.Sales_Model__c);
				}
				SWKitIdSMIdMap.put(swsm.SW_Kit__c, tempList);
			}
			
			for(Id deviceId : deviceIdSWKitIdMap.keySet()){
				if(SWKitIdSMIdMap.get(deviceIdSWKitIdMap.get(deviceId)) != null){
					for(Id smId : SWKitIdSMIdMap.get(deviceIdSWKitIdMap.get(deviceId))){
						if(!existingDeviceIdSMIdMatches.contains(deviceId + '' + smId)){
							SMDevicesToInsert.add(new SalesModel_Device__c(Sales_Model__c = smId, Device__c = deviceId));
						}
					}
				}
			}
			
			if(!SMDevicesToInsert.isEmpty()){ insert SMDevicesToInsert; }
		}
	}
	
	public static void updateSalesModelsFromDevicesWithSWKitsToNotActive(List<SWKit_SalesModel_Relationship__c> oldList){
		Set<Id> swKitIds = new Set<Id>();
		for(SWKit_SalesModel_Relationship__c swsm : oldList){
			swKitIds.add(swsm.SW_Kit__c);
		}
		
		List<SalesModel_Device__c> existingSMDsToUpdate = [SELECT Id FROM SalesModel_Device__c WHERE Device__c IN (SELECT Id FROM Device__c WHERE SW_Kit__c IN : swKitIds) AND Active__c = true];
		if(!existingSMDsToUpdate.isEmpty()) { 
			for(SalesModel_Device__c smd : existingSMDsToUpdate){
				smd.Active__c = false;
			} 
			update existingSMDsToUpdate;
		}
	}
	
	private static testmethod void SWKitSalesModelRelationshipMethodsTest(){
		SW_Kit__c sk1 = new SW_Kit__c(Name='sk1');
		insert sk1;
		Sales_Model__c sm1 = new Sales_Model__c(Name='sm1testmethod');
		insert sm1;
		Device__c d1 = new Device__c(Name='d1', SW_Kit__c=sk1.Id);
		insert d1;				
				
		
		Test.startTest();		
			SWKit_SalesModel_Relationship__c sksmr = new SWKit_SalesModel_Relationship__c(SWKit_Name__c = 'sk1', SalesModel_Name__c = 'sm1testmethod', Current_SWKIT_SM_Mapping__c='Y', PDM_External_ID__c='sk1sm1');

			SWKit_SalesModel_Relationship__c sksmr2 = new SWKit_SalesModel_Relationship__c(SWKit_Name__c = 'sk1', SalesModel_Name__c = 'sm2testmethod', Current_SWKIT_SM_Mapping__c='N', PDM_External_ID__c='sk1sm2');
			insert new List<SWKit_SalesModel_Relationship__c>{sksmr,sksmr2};
			sksmr.Current_SWKIT_SM_Mapping__c = 'N';
			update sksmr;				
		Test.stopTest();		
	}
	
	private static testmethod void syncSalesModelsToDevicesWithSWKitsTest(){
		Device__c d1 = new Device__c(Name='d1');
		insert d1;	
		
		SW_Kit__c sk1 = new SW_Kit__c(Name='sk1');
		insert sk1;
		SW_Kit__c sk2 = new SW_Kit__c(Name='sk2');
		insert sk2;
		Sales_Model__c sm1 = new Sales_Model__c(Name='sm1testmethod');
		insert sm1;
		Sales_Model__c sm2 = new Sales_Model__c(Name='sm2testmethod');
		insert sm2;	
		SWKit_SalesModel_Relationship__c sksmr = new SWKit_SalesModel_Relationship__c(SWKit_Name__c = 'sk1', SalesModel_Name__c = 'sm1testmethod', Current_SWKIT_SM_Mapping__c='Y', PDM_External_ID__c='sk1sm1');
		insert sksmr;
		SWKit_SalesModel_Relationship__c sksmr1 = new SWKit_SalesModel_Relationship__c(SWKit_Name__c = 'sk1', SalesModel_Name__c = 'sm2testmethod', Current_SWKIT_SM_Mapping__c='Y', PDM_External_ID__c='sk1sm2');
		insert sksmr1;
		SWKit_SalesModel_Relationship__c sksmr2 = new SWKit_SalesModel_Relationship__c(SWKit_Name__c = 'sk2', SalesModel_Name__c = 'sm2testmethod', Current_SWKIT_SM_Mapping__c='Y', PDM_External_ID__c='sk2sm2');
		insert sksmr2;
		
		Test.startTest();
			d1.SW_Kit__c = sk1.Id;
			update d1;
			
			d1.SW_Kit__c = sk2.Id;
			update d1;
			
			d1.SW_Kit__c = null;
			update d1;
		Test.stopTest();	
	}
}