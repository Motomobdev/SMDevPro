/**
 * Email services are automated processes that use Apex classes
 * to process the contents, headers, and attachments of inbound
 * email.
 */
global class NonUserEmailApproval implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        
        /*String fromEmail = envelope.fromAddress;
        
        String fromName = email.fromName;
        
        String subject = email.subject;
		String body = email.plainTextBody;
        
        Integer marker1 = subject.LastIndexOf('Id: ');
        system.debug('THIS IS MARKER1: ' + marker1);
        String id = subject.substring(marker1+4, marker1+22);
        
        system.debug('THIS IS SUBJECT: ' + subject);
        system.debug('THIS IS id: ' + id);
        
        String Decision;
        */
        
/*
TEMP CODE FOR FIXING APPROVALS
List<String> piwiIDS = new List<String> {};
List<ProcessInstanceWorkitem> piwi = [SELECT Id, actorid FROM ProcessInstanceWorkitem WHERE id IN : piwiIDS];

system.debug('THIS IS SIZE of piwi' + piwi.size());
for(Integer i=0; i<piwi.size(); i++){
piwi[i].actorid = '005400000012DwZ';
}
update piwi;
*/
        
       /* system.debug('THIS IS EMAIL BODY: ' + body);
        
        if(body.startsWith('NOT APPROVED')){
        	Decision = 'Rejected';
        }
        else if(body.startsWith('APPROVED')){
        	Decision = 'Accepted';
        }
        
        system.debug('THIS IS DECISION: ' + Decision);
        
		ProcessInstance pi = [SELECT id, Status, (SELECT Id, StepStatus, Comments, ActorId, IsPending, CreatedDate FROM StepsAndWorkitems) FROM ProcessInstance WHERE TargetObjectId =: id];
		System.debug('THIS IS pi: ' + pi + ', ' + pi.status);
		System.debug('THIS IS pi.steps: ' + pi.StepsAndWorkitems);
		system.debug('THIS IS size: ' + pi.StepsAndWorkitems.size());
		
		
		
		//pi.StepsandWorkitems[0].ActorId = '00540000001497X'; 
		
		//ProcessInstanceWorkItem piwi = [SELECT id, ActorId FROM ProcessInstanceWorkItem WHERE ProcessInstanceId = pi.Id];
		
		//system.debug('THIS IS PIWI id, actorid: ' + piwi.id + ', ' + piwi.ActorId);
		
		for(Integer z=0; z<pi.StepsAndWorkitems.size(); z++){
			System.debug('THIS IS pi.steps[i].status: ' + pi.StepsAndWorkitems[z].StepStatus + ', ' + pi.StepsAndWorkitems[z].CreatedDate);
			// greatest createddate + status=pending will identify the current step
			
			if(pi.StepsAndWorkitems[z].StepStatus == 'Pending'){
				// Instantiate the new ProcessWorkitemRequest object and populate it 
				Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
				req.setComments('Email Approval by ' + fromName + ' - ' + fromEmail);
				req.setAction('Approve');
				req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
				
				// Use the ID from the newly created item to specify the item to be worked  				    
				req.setWorkitemId(pi.StepsAndWorkitems[z].Id);
				
				// Submit the request for approval  
				Approval.ProcessResult approvalResult =  Approval.process(req);
				
				// Verify the results  		    
				System.assert(approvalResult.isSuccess(), 'Result Status:'+approvalResult.isSuccess());
				
				// Send email to approver of success
				if(approvalResult.isSuccess()){				    
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();				    
					String[] toAddresses = new String[] {fromEmail}; 					    
					mail.setToAddresses(toAddresses);   
					    
					//mail.setReplyTo('support@acme.com');					
					mail.setSenderDisplayName('Approval Success');
					    
					mail.setSubject('Email Approval Successfull');
					mail.setPlainTextBody('Your recent email approval has been successfully recieved and accepted.');
					    
					Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

				}				
			}
		}
*/
        return result;
    }
}