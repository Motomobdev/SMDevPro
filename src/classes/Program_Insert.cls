public with sharing class Program_Insert {
	public static void beforeInsert(List<Program__c> newList){
		ProgramMethods.validateInsertAndsetTypeToDeltaForDatafeedEnteredPrograms(newList);
		ProgramMethods.associateProgramToTechTeam(newList);
	}
	
	public static void afterInsert(List<Program__c> newList){
		ProgramMethods.associateProgramToStable(newList);
	}
	
	
}