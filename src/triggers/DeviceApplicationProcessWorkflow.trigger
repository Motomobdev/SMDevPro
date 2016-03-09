trigger DeviceApplicationProcessWorkflow on DeviceApplicationAssoc__c (after update) {
	// assume matrix already had Email Approver selected. So that when DevApp gets made Email Approver is placed in Approver field
	// then we need to check on each update what step the approval is on and who the approver is
	//if email approver lookup appropriate non-SFDC approver field and use to send email.
	
	/*
	ProcessInstance - represents the approval
	ProcessInstanceStep - history of each of the individual approval steps
	ProcessWorkItem - steps that are currently active in the queue.
	*/
	
	
	
	/* ***************** HOLLA!
	Start with checking if workflow submitted has been changed to true, if it has and lrb approver is dummer approver, send out email
	For every update check to see if workflow submitted is yes and the previous step's checkbox "Past..." has been checked"
		If old.Past_LRB== false and new.Past_LRB==true and SDS approver is dummy send email for SDS
		copy for remaining steps
		*/
		
	
	/*if(trigger.isUpdate){
		system.debug('username' + UserInfo.getFirstName());
		
		System.debug('THIS IS ID: ' + trigger.new[0].Id);
		if(trigger.isAfter){system.debug('THIS IS AFTER UPDATE');}
		
		// instantiate instance of DeviceApplicationApprovalProcess so we can find out what step the devapps are in
		DeviceApplicationApprovalProcess daap = new DeviceApplicationApprovalProcess(trigger.new);
				
		for(Integer i=0; i<trigger.size; i++){
			if(trigger.new[i].Approval_Status__c == 'In Progress'){
				// find what step the process is currently in
				
				if(trigger.old[i].Approval_Status__c == 'Not Submitted'){
					// We know this was just submitted so if LRB is not skipped we are in LRB
				}
				
				ProcessInstance pi = [SELECT id, Status, (SELECT Id, StepStatus, Comments, ActorId, IsPending, CreatedDate FROM StepsAndWorkitems) FROM ProcessInstance WHERE TargetObjectId =: trigger.new[i].Id];
					
					
					System.debug('THIS IS pi: ' + pi + ', ' + pi.status);
					System.debug('THIS IS pi.steps: ' + pi.StepsAndWorkitems);
					system.debug('THIS IS size: ' + pi.StepsAndWorkitems.size());
					
					for(Integer z=0; z<pi.StepsAndWorkitems.size(); z++){
						System.debug('THIS IS pi.steps[i].status: ' + pi.StepsAndWorkitems[z].StepStatus + ', ' + pi.StepsAndWorkitems[z].CreatedDate);
						// greatest createddate + status=pending will identify the current step
						
						// if pending and actorId is Non-SFDC Email Approver then use this
						if(pi.StepsAndWorkitems[z].StepStatus == 'Pending' && pi.StepsAndWorkitems[z].ActorId == '00540000001497X'){
							system.debug('FOUND the current pending workitem');
						}
						
					}
					
					/*for(ProcessInstanceWorkitem piwi : [SELECT ActorId, id FROM ProcessInstanceWorkitem WHERE ProcessInstanceId =: pi.Id]){
						// PIWI holds actorId = assigned approver
						System.debug('THIS IS piwi: ' + piwi);
						//piwi.ActorId = '00540000001497X'; 
						//update piwi;
					}
					
					for(ProcessInstanceStep pis : [SELECT ActorId, id, comments, stepstatus FROM ProcessInstanceStep WHERE ProcessInstanceId =: pi.Id]){
						System.debug('THIS IS pis: ' + pis + ', ' + pis.Comments + ', ' + pis.StepStatus);
					}	*/		
					
				//Once the proper processinstancestep/workitem is found
				//	1. Identify which approval step it is, so that we know which Non-SFDC email address field to look at
				//	2. Generate email and send out
				
											
			//}
		//}
		
	//}
	

}