public with sharing class ProgramApplication_Insert {
	public static void beforeInsert(List<Program_Application__c> newList){
		List<Id> programIds = new List<Id>();
		List<Id> appIds = new List<Id>();		
		for(Program_Application__c pa : newList){
			programIds.add(pa.Program__c);
			appIds.add(pa.Application__c);
		}		
		
		Map<Id, Program__c> programMap = new Map<Id, Program__c>([SELECT Id, Reviewed_Approved__c FROM Program__c WHERE Id IN : programIds]);
		Map<Id, Application__c> appMap = new Map<Id, Application__c>([SELECT Id, Description__c, Application_Instructions__c FROM Application__c WHERE Id IN : appIds]);
				
		Map<String, Program_Application__c> existingProgramAppMap = new Map<String, Program_Application__c>();
		for(Program_Application__c pa : [SELECT Id, Program__c, Application__c, Program__r.Reviewed_Approved__c FROM Program_Application__c WHERE Id IN : programIds]){
			existingProgramAppMap.put(pa.Program__c + '' + pa.Application__c, pa);
		}
		
		ProgramApplicationInsertMethods.checkProgramStatusAndDuplicates(newList, programMap, existingProgramAppMap);
		
		/***** temporarily removed per Keith's request, he said not all apps with have contracts, should be verified some other time
		ProgramApplicationInsertMethods.checkForApplictionContract(newList);
		*/

		ProgramApplicationInsertMethods.fillInApplicationDescriptionAndInstructions(newList, appMap);
		
		ProgramApplicationInsertMethods.populateApplicationCost(newList, appIds);
	}
	
	public static void afterInsert(List<Program_Application__c> newList, List<Program_Application__c> oldList){
		List<Id> programIds = new List<Id>();
		Map<Id, List<Id>> programIdAppIdListMap = new Map<Id, List<Id>>();
		Map<String, String> programAppIdStatusMap = new Map<String, String>();
		for(Program_Application__c pa : newList){
			programAppIdStatusMap.put(pa.Program__c + '' + pa.Application__c, pa.Status__c);
			programIds.add(pa.Program__c);
			
			List<Id> tempList = programIdAppIdListMap.get(pa.Program__c);
			if(tempList == null){
				tempList = new List<Id>{pa.Application__c};
			} else {
				tempList.add(pa.Application__c);
			}
			programIdAppIdListMap.put(pa.Program__c, tempList);
		}
		
		try{
			ProgramApplicationInsertMethods.addAppToProgramParentsAndProgramDevices(programIdAppIdListMap, programAppIdStatusMap, programIds);
		} catch(System.DMLException e){
			for(Program_Application__c pa : newList){
				pa.addError('There was an Error adding Application to Stables, Cores and Devices that use Program.');
			}
		}		
	}
}