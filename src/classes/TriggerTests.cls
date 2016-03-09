/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 */
@isTest
private class TriggerTests {

    static testMethod void eisTriggerTest() {
        External_Idea_Submission__c eis = new External_Idea_Submission__c();
        insert eis;
        eis.Idea_Status__c = 'Rejected';
        update eis;
        
		try{
			eis.Idea_Status__c = 'Submitted';
	        update eis;			
		}
		catch(System.DmlException e){
			
		}
        
        eis = new External_Idea_Submission__c();
        insert eis;
        eis.Idea_Status__c = 'Pursued';
        update eis;        
    }
}