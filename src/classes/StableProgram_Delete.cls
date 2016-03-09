public with sharing class StableProgram_Delete {
	public static void beforeDelete(List<Stable_Program__c> oldList){
		try{
			StableProgramMethods.removeAppsFromStableAndCoresAndDevices(oldList);
		} catch(System.DMLException e){
			for(Stable_Program__c sp : oldList){
				sp.addError('There was a problem removing this Program from this Stable.');
			}
		}
	}
	
	public static void afterDelete(List<Stable_Program__c> oldList){
		List<Id> stableIds = new List<Id>();
		List<Id> programIds = new List<Id>();		
		
		for(Stable_Program__c sp : oldList){
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
			
		StableProgramMethods.setStableFieldOnProgram(programIds, programIdStableIdListMap);
	}
}