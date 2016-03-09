public without sharing class FollowRecords {
	public static void followNewRecordByAssignedUser(List<SObject> newList){
		List<EntitySubscription> follows = new List<EntitySubscription>();
		for(Integer i=0; i<newList.size(); i++){
			EntitySubscription follow = new EntitySubscription();
			follow.ParentId = newList[i].Id;
			follow.SubscriberId = (Id)newList[i].get('OwnerId');			
			follows.add(follow);
		}
		follows = removeDuplicates(follows);
		if(!follows.isEmpty()) {
			try{
				insert follows;
			} catch(System.DMLException e){
				// could not auto follow
			}
		}
	}

	public static void followNewRecordByCreatedUser(List<SObject> newList){
		List<EntitySubscription> follows = new List<EntitySubscription>();
		for(Integer i=0; i<newList.size(); i++){
			EntitySubscription follow = new EntitySubscription();
			follow.ParentId = newList[i].Id;
			follow.SubscriberId = (Id)newList[i].get('CreatedById');
			follows.add(follow);
		}		
		follows = removeDuplicates(follows);
		if(!follows.isEmpty()) {
			try{
				insert follows;
			} catch(System.DMLException e){
				// could not auto follow
			}
		}		
	}

	public static List<EntitySubscription> removeDuplicates(List<EntitySubscription> newFollows){
		List<Id> parentIds = new List<Id>();
		for(EntitySubscription es : newFollows){
			parentIds.add(es.ParentId);
		}
		
		List<EntitySubscription> existingFollows = [SELECT Id, ParentId, SubscriberId FROM EntitySubscription WHERE ParentId IN : parentIds];
		Integer i;
		for(EntitySubscription existingFollow : existingFollows){
			for(i=0; i<newFollows.size(); i++){
				if((newFollows[i].ParentId == existingFollow.ParentId) && (newFollows[i].SubscriberId == existingFollow.SubscriberId)){
					newFollows.remove(i);
				}
			}
		}
		
		return newFollows;
	} 
		
	private testmethod static void followRecordsTest(){
		User u = [SELECT Id FROM User WHERE Name = 'Automated Data Feed'];
		Task t1 = new Task(Subject='testTask');
		Task t2 = new Task(Subject='testTask2', OwnerId = [SELECT Id FROM User WHERE Name = 'Motorola Partnership Management'].Id);
		List<Task> tList = new List<Task>{t1,t2};
		Test.startTest();
			System.runAs(u){
				insert tList;
			}
			t1.OwnerId = [SELECT Id FROM User WHERE Name = 'Motorola Partnership Management'].Id;
			update t1;
			t1.OwnerId = u.Id;
			update t1;
		Test.stopTest();
	}	
}