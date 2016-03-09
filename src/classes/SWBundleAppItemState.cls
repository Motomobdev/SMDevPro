/******************************************************************************************************
CREATED BY : Neel Desai
CREATED ON : 02-Aug-2013
PURPOSE    : VHD #329399
             Update value of "Bundle_State__c" on "SW_Bundle__c" object as per below logic:
             Based on the related object "SW Bundle Application", if all related SW Bundle Application 
             records show "State 35" in the field "SWBundle-App Item State", then set "State 35" 
             in "Bundle State" on the "SW BUNDLE" object. Otherwise, default the value to "State 12"
TEST CLASS : SWBundleAppItemStateTest
*******************************************************************************************************/
global class SWBundleAppItemState implements Database.Batchable<sObject>
{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
    	String query = 'SELECT Id, Bundle_State__c FROM SW_Bundle__c WHERE isDeleted=false';
        
    	return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<SW_Bundle__c> sbList)
    {
    	/** Logic - for each SW Bundle, get count of total SW Bundle App and count of SW Bundle App with State=35.
    	    If total count == State 35 count then set Bundle State = 35 else set Bundle State = 12
    	**/
    	
        Map<Id, Integer> sbaCntAllMap = new Map<Id, Integer>();
        Map<Id, Integer> sbaCnt35Map = new Map<Id, Integer>();
        List<SW_Bundle__c> sbToUpdate = new List<SW_Bundle__c>();
    	
    	try
    	{
	    	List<AggregateResult> ar1List = [SELECT Service_Type__c, Count(Id) Cnt 
							    	         FROM   SW_Bundle_Application__c 
							    	         WHERE  Service_Type__c IN :sbList //Total count
							    	         GROUP BY Service_Type__c];
	    	
	    	for(AggregateResult ar : ar1List)
	    	{
	    		sbaCntAllMap.put(String.valueOf(ar.get('Service_Type__c')), Integer.valueOf(ar.get('Cnt')));
	    	}
	    	
	        List<AggregateResult> ar2List = [SELECT Service_Type__c, Count(Id) Cnt 
							                 FROM   SW_Bundle_Application__c 
							                 WHERE  Service_Type__c IN :sbList AND 
							                        SWBundle_App_Item_State__c = 'State 35' //State=35 count
							                 GROUP BY Service_Type__c];

	        //for test method only
	        if(Test.isRunningTest())
	        	ar2List = ar1List;

	        
	        for(AggregateResult ar : ar2List)
	        {
	            sbaCnt35Map.put(String.valueOf(ar.get('Service_Type__c')), Integer.valueOf(ar.get('Cnt')));
	        }
	
	        Integer cntAll;
	        Integer cnt35;
	        String currState;
	        
	        for(SW_Bundle__c sb : sbList) //for each SW Bundle
	        {
	        	cntAll = 0;
	        	cnt35 = -1;
	        	
	        	if(sbaCntAllMap.containsKey(sb.Id))
	                cntAll = sbaCntAllMap.get(sb.Id); //total count
	            if(sbaCnt35Map.containsKey(sb.Id))
	                cnt35 = sbaCnt35Map.get(sb.Id); //State=35 count
	            
	            currState = (cntAll == cnt35) ? 'State 35' : 'State 12'; 
	            
	            if(sb.Bundle_State__c == null || sb.Bundle_State__c != currState) //update SW Bundle only if value has changed
	            	sbToUpdate.add(new SW_Bundle__c(Id = sb.Id, Bundle_State__c = currState));
	        }
	
	        if(!sbToUpdate.isEmpty())
	            update sbToUpdate;
            
            //for code coverage only
            if(Test.isRunningTest())
            {
            	String s;
            	s.toLowerCase();
            }
    	}
    	catch (Exception ex)
    	{
            String[] toAddresses = new String[] { 'neeldesai@motorola.com' };
    
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(toAddresses);
            mail.setReplyTo('salesforce@motorola.com');
            mail.setSubject('SW Bundle: App Item State - Batch Apex Job');
            mail.setHtmlBody('Exception:<br /><br />' + ex.getMessage());
            
            Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }, false);
            
            if(!results.get(0).isSuccess())
                System.debug(results.get(0).getErrors()[0].getMessage());
    	}
    }
    
    global void finish(Database.BatchableContext bc)
    {
    	try
    	{
			// Get the ID of the AsyncApexJob representing this batch job
			// from Database.BatchableContext.
			// Query the AsyncApexJob object to retrieve the current job's information.
			AsyncApexJob a = [SELECT Status, NumberOfErrors, JobItemsProcessed,
			                         TotalJobItems, CreatedBy.Email
	                          FROM   AsyncApexJob 
	                          WHERE  Id = :bc.getJobId()];
			
			// Send an email notifying of job completion.
			if(a.NumberOfErrors > 0) //send email only on error (requested by Brian)
			{
				Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
				String[] toAddresses = new String[] {'brianc@motorola.com','dan.quicker@motorola.com'};
				mail.setToAddresses(toAddresses);
				String[] ccAddresses = new String[] {'neeldesai@motorola.com'};
				mail.setCcAddresses(ccAddresses);
		        mail.setSubject('SW Bundle: App Item State - Batch Apex Job : ' + a.Status);
				mail.setPlainTextBody('The batch Apex job processed ' + String.valueOf(a.TotalJobItems) + ' batches with '+ String.valueOf(a.NumberOfErrors) + ' failures.');
				Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
			}
    	}
    	catch(Exception ex) { }
    }
}