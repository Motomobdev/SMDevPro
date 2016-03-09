trigger TechTeam on Tech_Team__c (before insert) {
	// tested by TechTeamMethodsTest
	if(trigger.isBefore && trigger.isInsert){
		TechTeam_Insert.beforeInsert(trigger.new);
	}
}