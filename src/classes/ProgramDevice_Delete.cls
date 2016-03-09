public with sharing class ProgramDevice_Delete {
	public static void beforeDelete(List<Program_Device__c> oldList){
		List<Program_Device__c> programDevices = new List<Program_Device__c>();
		
		for(Program_Device__c pd : oldList){
			if(pd.Source_Id__c != null){
				pd.addError('You cannot delete the junction between this Program and Device because it was created via the Source relationship.');
			} else if(pd.Source_Name__c == null) {
				programDevices.add(pd);
			}
		}	
		
		ProgramDeviceMethods.removeProgramAppsFromProgramsOldDevice(programDevices);
	}
}