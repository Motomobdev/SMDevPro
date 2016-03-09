/*
 * Test code for this trigger is in TriggerTest.cls
 */
trigger EIS on External_Idea_Submission__c (after insert, after update) {
	if(trigger.isUpdate){
		for(Integer i=0; i<trigger.new.size(); i++){
			if(trigger.old[i].Idea_Status__c == 'Submitted'){
				if(trigger.new[i].Idea_Status__c == 'Rejected'){
					Event event = new Event();
					event.Subject = 'Rejected Email Sent';
					event.StartDateTime = Date.today();
					event.EndDateTime = Date.today();
					event.ActivityDate = Date.today();
					event.WhatId = trigger.new[i].Id;
					event.Status__c = 'Completed';
					event.Percent_Complete__c = 100;
					insert event;					
				}
				else if(trigger.new[i].Idea_Status__c == 'Pursued'){
					Event event = new Event();
					event.Subject = 'Rejected Email Sent';
					event.StartDateTime = Date.today();
					event.EndDateTime = Date.today();
					event.ActivityDate = Date.today();
					event.WhatId = trigger.new[i].Id;
					event.Status__c = 'Completed';
					event.Percent_Complete__c = 100;
					insert event;					
				}
			}
			
			// check to see if eis has already been marked rejected or pursued
			if(trigger.old[i].Idea_Status__c != 'Submitted' && (trigger.old[i].Idea_Status__c != trigger.new[i].Idea_Status__c)){
				// the EIS was already pursued or rejected and a change to status has been attempted
				trigger.new[i].addError('You cannot change the status of an EIS once it has been Pursued or Rejected. Please Cancel your change.');				
			}		
		}
	}
}