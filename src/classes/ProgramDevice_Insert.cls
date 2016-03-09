public with sharing class ProgramDevice_Insert {
	public static void beforeInsert(List<Program_Device__c> newList){
		List<Program_Device__c> programDevicesToInsert = new List<Program_Device__c>();
		for(Program_Device__c pd : newList){
			if(pd.Source_Id__c == null && pd.Created_on_BOM__c==false){
				programDevicesToInsert.add(pd);
			}
		}
        
        if(!programDevicesToInsert.isEmpty()){
        	ProgramDeviceMethods.checkForExistingProgramDevice(programDevicesToInsert);    
        }
	}
}