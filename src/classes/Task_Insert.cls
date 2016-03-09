public without sharing class Task_Insert {
	public static void afterInsert(List<Task> newList){
		List<Task> byAssigned = new List<Task>();
		List<Task> byCreated = new List<Task>();
	
		for(Integer i=0; i<newList.size(); i++){
			system.debug('THIS IS OWNER ID: ' + newList[i].OwnerId);
			if(newList[i].OwnerId != '005400000012v9NAAQ' && newList[i].CreatedById != '005400000012v9NAAQ'){
				if(newList[i].OwnerId != newList[i].CreatedById){
					byAssigned.add(newList[i]);
					byCreated.add(newList[i]);
				} else {
					byAssigned.add(newList[i]);
				}
			}
			
		}
		
		FollowRecords.followNewRecordByAssignedUser(byAssigned);
		FollowRecords.followNewRecordByCreatedUser(byCreated);
	}
}