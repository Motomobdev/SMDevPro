public with sharing class UserMethods {

	// Returns a Map of user's full name (ie 'John Smith') with User record
	public static Map<String, User> getNameUserMap(){
		Map<String, User> userMap = new Map<String, User>();
		
		for(User u : [SELECT id, name FROM User WHERE isActive = true]){
			userMap.put(u.name, u);
		}
		
		return userMap;
	}
	
	// Returns a Map of users based on CoreId
	// tested by TechTeamMethodsTest
	public static Map<String, User> getCoreIdUserMap(){
		Map<String, User> userMap = new Map<String, User>();
		
		for(User u : [SELECT id, name, User_External_Unique_ID__c FROM User WHERE isActive = true]){
			userMap.put(u.User_External_Unique_ID__c, u);
		}
		
		return userMap;
	}
	
	// Returns a Map of user's SFDC Id with User record
	public static Map<Id, User> getIdUserMap(){
		Map<Id, User> userMap = new Map<Id, User>([SELECT id, name, userName, email FROM User WHERE isActive = true]);
		
		return userMap;
	}

	/*private testmethod static void testGetNameUserMap() {
		Map<String, User> userMap = UserMethods.getNameUserMap();
		
		Test.startTest();
		System.assertEquals(userMap.get('Automated Data Feed').Id, '005400000013EXd');
		Test.stopTest();
	}

	private testmethod static void testGetIdUserMap() {
		Map<Id, User> userMap = UserMethods.getIdUserMap();
		
		Test.startTest();
		System.assertEquals(userMap.get('005400000013EXd').Name, 'Automated Data Feed');
		Test.stopTest();
	}*/

}