public with sharing class Task_Update {
	public static void afterUpdate(List<Task> newList, List<Task> oldList){
		List<Task> newAssigned = new List<Task>();
		List<Id> featureIds = new List<Id>();
		
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].OwnerId != oldList[i].OwnerId){
				newAssigned.add(newList[i]);
			}
			
			if(newList[i].Status == 'Completed' && newList[i].Status != oldList[i].Status){
				String temp = newList[i].WhatId;
				// identify parent as a feature
				if(temp != null && temp.startsWith('a1Z')){
					featureIds.add(newList[i].WhatId);
				} 
			}
		}
		
		FollowRecords.followNewRecordByAssignedUser(newAssigned);
		
		FeatureMethods.autoCompleteFeatureIfAllTasksAreCompleted(featureIds);
	}
}