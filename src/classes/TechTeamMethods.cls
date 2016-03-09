public with sharing class TechTeamMethods {
	public static void setOwnerToTeamLeader(List<Tech_Team__c> newList){
		Map<String, User> userMap = UserMethods.getCoreIdUserMap();
		
		for(Tech_Team__c tt : newList){
			if(tt.Team_Lead_Core_Id__c != null && userMap.get(tt.Team_Lead_Core_Id__c) != null){
				tt.OwnerId = userMap.get(tt.Team_Lead_Core_Id__c).Id;
			}
		}
	}
	
	private static testmethod void TechTeamMethodsTest(){
		Tech_Team__c tt = new Tech_Team__c(Name='tt', Team_Lead_Core_Id__c = 'MJQ764');
		
		Test.StartTest();
			insert tt;
		Test.StopTest();
	}
}