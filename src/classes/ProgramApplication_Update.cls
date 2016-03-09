public with sharing class ProgramApplication_Update {
	public static void afterUpdate(List<Program_Application__c> newList, List<Program_Application__c> oldList){
		List<Program_Application__c> programAppsWithUpdatedStatus = new List<Program_Application__c>();
		List<Program_Application__c> programAppsWithUpdatedStatusForDevApps = new List<Program_Application__c>();
		List<Program_Application__c> programAppsWithUpdatedDescriptionOrInstructions = new List<Program_Application__c>();
		
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Status__c != oldList[i].Status__c){
				programAppsWithUpdatedStatus.add(newList[i]);
				
				if(newList[i].Status__c == 'Candidate' || oldList[i].Status__c == 'Candidate'){
					programAppsWithUpdatedStatusForDevApps.add(newList[i]);
				}
			}
			
			if(newList[i].Description__c != oldList[i].Description__c || newList[i].Instructions__c != oldList[i].Instructions__c){
				programAppsWithUpdatedDescriptionOrInstructions.add(newList[i]);
			}
		}
		
		ProgramApplicationUpdateMethods.updateStableAppsWhenProgramAppStatusIsUpdated(programAppsWithUpdatedStatus);
		ProgramApplicationUpdateMethods.updateProgramsDeviceAppsWhenProgramAppStatusIsUpdated(programAppsWithUpdatedStatusForDevApps);
		ProgramApplicationUpdateMethods.updateDescripionAndInstructionsOnDevApps(programAppsWithUpdatedDescriptionOrInstructions);
	}
}