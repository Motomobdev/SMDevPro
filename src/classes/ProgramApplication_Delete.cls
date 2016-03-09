public with sharing class ProgramApplication_Delete {
	public static void beforeDelete(List<Program_Application__c> oldList){
		Set<Program_Application__c> programsNotReviewedApproved = ProgramApplicationDeleteMethods.checkProgramBeforeDeleteProgramApplications(oldList);
		
		List<Id> programIds = new List<Id>();
		List<Id> appIds = new List<Id>();
		List<String> applicationSourceIds = new List<String>();
		for(Program_Application__c pa : programsNotReviewedApproved){
			programIds.add(pa.Program__c);
			appIds.add(pa.Application__c);
			
			String applicationSourceId = pa.Program__c;
			if(applicationSourceId.length() == 18){
				applicationSourceId = applicationSourceId.substring(0,15);
			}
			applicationSourceIds.add(applicationSourceId);
		}
		
		try{
			ProgramApplicationDeleteMethods.removeAppsFromProgramDevices(programsNotReviewedApproved, programIds, appIds, applicationSourceIds);
			ProgramApplicationDeleteMethods.removeAppsFromProgramParents(programsNotReviewedApproved, programIds, appIds, applicationSourceIds);
		} catch (System.DMLException e){
			for(Program_Application__c pa : oldList){
				pa.addError('There was an Error removing Application from Stables, Cores and Devices that use Program.');
			}
		}
	}
}