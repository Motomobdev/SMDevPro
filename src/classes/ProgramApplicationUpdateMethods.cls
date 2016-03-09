public with sharing class ProgramApplicationUpdateMethods {
	public static void updateStableAppsWhenProgramAppStatusIsUpdated(List<Program_Application__c> programAppsWithUpdatedStatus){
		List<Id> programIds = new List<Id>();
		List<Id> appIds = new List<Id>();
		Map<String, String> progAppStringStatusMap = new Map<String, String>();
		
		for(Program_Application__c pa : programAppsWithUpdatedStatus){
			programIds.add(pa.Program__c);
			appIds.add(pa.Application__c);
			progAppStringStatusMap.put(pa.Program__c + '' + pa.Application__c, pa.Status__c);
		}
		
		List<Stable_Application__c> stableAppsToUpdate = new List<Stable_Application__c>();
		for(Stable_Application__c sa : [SELECT Id, Stable_App_Status__c, Source_Id__c, Application__c FROM Stable_Application__c WHERE Source_Id__c IN : programIds AND Application__c IN : appIds]){
			if(progAppStringStatusMap.containsKey(sa.Source_Id__c + '' + sa.Application__c)){			
				sa.Stable_App_Status__c = progAppStringStatusMap.get(sa.Source_Id__c + '' + sa.Application__c);
				stableAppsToUpdate.add(sa);			
			}
		} 
		
		update stableAppsToUpdate;
	}
	
	public static void updateProgramsDeviceAppsWhenProgramAppStatusIsUpdated(List<Program_Application__c> programAppsWithUpdatedStatus){
		List<Id> notSubmittedProgramIds = new List<Id>();
		List<Id> notSubmittedApplicationIds = new List<Id>();
		List<Id> notSubmitableProgramIds = new List<Id>();
		List<Id> notSubmitableApplicationIds = new List<Id>();
		
		List<Id> programApplicationSourceIds = new List<Id>();
		
		for(Program_Application__c pa : programAppsWithUpdatedStatus){
			if(pa.Status__c != 'Candidate'){
				// update all Program's Devices devApps to Not Submitted
				notSubmittedProgramIds.add(pa.Program__c);
				notSubmittedApplicationIds.add(pa.Application__c);
			} else {
				// update all Program's Devices devApps to Not Submitable
				notSubmitableProgramIds.add(pa.Program__c);
				notSubmitableApplicationIds.add(pa.Application__c);
			}
		}

		system.debug('notSubmittedProgramIds, notSubmittedApplicationIds: ' + notSubmittedProgramIds + ', ' + notSubmittedApplicationIds);
		List<DeviceApplicationAssoc__c> notSubmittedDevApps = [SELECT Id, Approval_Status__c FROM DeviceApplicationAssoc__c WHERE Source_Id__c IN : notSubmittedProgramIds AND Application__c IN : notSubmittedApplicationIds];
		system.debug('notSubmittedDevApps: ' + notSubmittedDevApps);
		for(DeviceApplicationAssoc__c da : notSubmittedDevApps){
			da.Approval_Status__c = 'Not Submitted';
		}
		update notSubmittedDevApps;
		
		system.debug('notSubmitableProgramIds, notSubmitableApplicationIds: ' + notSubmitableProgramIds + ', ' + notSubmitableApplicationIds);
		List<DeviceApplicationAssoc__c> notSubmitableDevApps = [SELECT Id, Approval_Status__c FROM DeviceApplicationAssoc__c WHERE Source_Id__c IN : notSubmitableProgramIds AND Application__c IN : notSubmitableApplicationIds];
		system.debug('notSubmitableDevApps: ' + notSubmitableDevApps);
		for(DeviceApplicationAssoc__c da : notSubmitableDevApps){
			da.Approval_Status__c = 'Not Submitable';
		}
		update notSubmitableDevApps;
	}
	
	public static void updateDescripionAndInstructionsOnDevApps(List<Program_Application__c> programAppsWithUpdatedDescriptionOrInstructions){
		List<DeviceApplicationAssoc__c> devAppsToUpdate = new List<DeviceApplicationAssoc__c>();
		Map<String, Program_Application__c> progIdAppIdMap = new Map<String, Program_Application__c>();
		Map<Id, Program_Application__c> appIdMap = new Map<Id, Program_Application__c>();
		Set<Id> programIds = new Set<Id>();
		Set<Id> appIds = new Set<Id>();
		
		for(Program_Application__c pa : programAppsWithUpdatedDescriptionOrInstructions){
			progIdAppIdMap.put(pa.Program__c + '' + pa.Application__c, pa);
			appIdMap.put(pa.Application__c, pa);
			programIds.add(pa.Program__c);
			appIds.add(pa.Application__c);
		}
		
		//find devapps that have Program as source
		for(DeviceApplicationAssoc__c da : [SELECT Id, Application__c, Source_Id__c, Program_Description__c, Program_Instructions__c FROM DeviceApplicationAssoc__c WHERE Application__c IN : appIds AND Source_Id__c IN : programIds]){
			if(progIdAppIdMap.get(da.Source_Id__c + '' + da.Application__c) != null){
				da.Program_Description__c = progIdAppIdMap.get(da.Source_Id__c + '' + da.Application__c).Description__c;
				da.Program_Instructions__c = progIdAppIdMap.get(da.Source_Id__c + '' + da.Application__c).Instructions__c;
				devAppsToUpdate.add(da);
			}
		}
		
		//find devapps that have a parent Stable as source
		List<Id> stableIds = new List<Id>();
		Map<String, Program_Application__c> stableIdAppIdMap = new Map<String, Program_Application__c>();
		for(Stable_Program__c sp : [SELECT Id, Stable__c, Program__c FROM Stable_Program__c WHERE Program__c IN : programIds]){
			stableIds.add(sp.Stable__c);
		}
		if(!stableIds.isEmpty()){
			for(DeviceApplicationAssoc__c da : [SELECT Id, Application__c, Source_Id__c, Program_Description__c, Program_Instructions__c FROM DeviceApplicationAssoc__c WHERE Application__c IN : appIds AND Source_Id__c IN : stableIds]){
				if(appIdMap.get(da.Application__c) != null){
					da.Program_Description__c = appIdMap.get(da.Application__c).Description__c;
					da.Program_Instructions__c = appIdMap.get(da.Application__c).Instructions__c;
					devAppsToUpdate.add(da);
				}
			}
		}
		
		//find devapps that have a grandparent Core, parent Stable as source
		//find devapps that have parent Core as source
		List<Id> coreIds = new List<Id>();
		for(Core_Device_Package__c cdp : [SELECT Id FROM Core_Device_Package__c WHERE Stable__c IN : stableIds]){
			coreIds.add(cdp.Id);
		}
		for(Core_Device_Package_Program__c cdpp : [SELECT Id, Core_Device_Package__c FROM Core_Device_Package_Program__c WHERE Program__c IN : programIds]){
			coreIds.add(cdpp.Id);
		}
		
		if(!coreIds.isEmpty()){
			for(DeviceApplicationAssoc__c da : [SELECT Id, Application__c, Source_Id__c, Program_Description__c, Program_Instructions__c FROM DeviceApplicationAssoc__c WHERE Application__c IN : appIds AND Source_Id__c IN : coreIds]){
				if(appIdMap.get(da.Application__c) != null){
					da.Program_Description__c = appIdMap.get(da.Application__c).Description__c;
					da.Program_Instructions__c = appIdMap.get(da.Application__c).Instructions__c;
					devAppsToUpdate.add(da);
				}
			}
		}
		
		if(!devAppsToUpdate.isEmpty()){ update devAppsToUpdate; }
	}
}