public with sharing class TechTeam_Insert {
	// tested by TechTeamMethodsTest
	public static void beforeInsert(List<Tech_Team__c> newList){
		TechTeamMethods.setOwnerToTeamLeader(newList);
	}
}