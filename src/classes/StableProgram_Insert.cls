public with sharing class StableProgram_Insert {
	public static void beforeInsert(List<Stable_Program__c> newList){
		List<Id> stableIds = new List<Id>();
		List<Id> programIds = new List<Id>();		
		
		for(Stable_Program__c sp : newList){
			stableIds.add(sp.Stable__c);
			programIds.add(sp.Program__c);
		}

		Map<Id, Set<Id>> programIdStableIdListMap = new Map<Id, Set<Id>>();
		for(Stable_Program__c sp : [SELECT Id, Stable__c, Program__c FROM Stable_Program__c WHERE Program__c IN : programIds]){
			Set<Id> tempList = programIdStableIdListMap.get(sp.Program__c);
			if(tempList == null){
				tempList = new Set<Id>{sp.Stable__c};
			} else {
				tempList.add(sp.Stable__c);
			}
			programIdStableIdListMap.put(sp.Program__c, tempList);
		}
		
		Map<Id, Program__c> programIdMap = new Map<Id, Program__c>([SELECT Id, Stable__c, Application_Cost_Current__c, Application_Cost_High__c, Application_Cost_Low__c, Reviewed_Approved__c, Type__c FROM Program__c WHERE Id IN : programIds]);
		
		StableProgramMethods.checkForExistingStableProgramsAndPopulateProgramFields(newList, programIdStableIdListMap, programIdMap);
	}
	
	public static void afterInsert(List<Stable_Program__c> newList){
		List<Id> stableIds = new List<Id>();
		List<Id> programIds = new List<Id>();		
		
		for(Stable_Program__c sp : newList){
			stableIds.add(sp.Stable__c);
			programIds.add(sp.Program__c);
		}
		
		Map<Id, List<Id>> programIdStableIdListMap = new Map<Id, List<Id>>();
		for(Stable_Program__c sp : [SELECT Id, Stable__c, Program__c FROM Stable_Program__c WHERE Program__c IN : programIds]){
			List<Id> tempList = programIdStableIdListMap.get(sp.Program__c);
			if(tempList == null){
				tempList = new List<Id>{sp.Stable__c};
			} else {
				tempList.add(sp.Stable__c);
			}
			programIdStableIdListMap.put(sp.Program__c, tempList);
		}
		
		Map<Id, Program__c> programIdMap = new Map<Id, Program__c>([SELECT Id, Stable__c, Application_Cost_Current__c, Application_Cost_High__c, Application_Cost_Low__c, Reviewed_Approved__c, Type__c FROM Program__c WHERE Id IN : programIds]);
		
		StableProgramMethods.setStableFieldOnProgram(programIds, programIdStableIdListMap);
		
		StableProgramMethods.addAppsToStableAndStableParentsAndStableDevices(newList, stableIds, programIds);
	}
}