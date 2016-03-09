public with sharing class FeatureMethods {
	public static void autoCompleteFeatureIfAllTasksAreCompleted(List<Id> featureIds){
		List<Task> allTasks = [SELECT Id, WhatId, Status FROM Task WHERE WhatId IN : featureIds];
		List<Feature__c> featuresToUpdate = new List<Feature__c>();		
		
		for(Id featureId : featureIds){
			Boolean isCompleted = true;
			for(Task task : allTasks){
				if(featureId == task.WhatId && task.Status != 'Completed'){
					isCompleted = false;
				}
			}
			
			if(isCompleted == true){
				featuresToUpdate.add(new Feature__c(Id = featureId, Phase__c = '5) Completed', Phase_5_Completion_Date__c = Date.today()));
			}
		}
		
		update featuresToUpdate;
	}
	
	private static testmethod void FeatureMethodsTest(){
		Feature__c f = new Feature__c(Name='feature');
		insert f;
		
		//Task t = [SELECT Id, Status FROM Task WHERE WhatId =: f.id];
		//Task t2 = new Task(Subject='task2', WhatId=f.Id);
		//insert t2;
		
		Test.startTest();
			//t.Status = 'Completed';
			//update t;
			
			//t2.Status = 'Completed';
			//update t2;
			
			//System.assertEquals('1) Requested', [SELECT Id, Phase__c FROM Feature__c WHERE Id =: f.Id].Phase__c);
		Test.stopTest();
	}
}