public with sharing class Calendar_Events_Ext {
	
	public final Id legal_case_Id {get;set;}
	public List<Calendar_Event__c> events {get;set;}
	public String ParamId {get;set;}
	
	public Calendar_Events_Ext(ApexPages.StandardController controller) {
		legal_case_Id = controller.getId();
		system.debug('***Legal Case ID: ' + legal_case_Id);
		events = new List<Calendar_Event__c>();
	}
	
	public void doAction() {
		if (legal_case_Id != null){
			getRecords();
		}
	}
	
	public List<Schema.FieldSetMember> getCalendarEventFields(){
     	return SObjectType.Calendar_Event__c.FieldSets.Calendar_Events_Related_List.getFields();
    }
     
     public List<Calendar_Event__c> getRecords(){
     	String query = 'SELECT ';
     	
     	for (Schema.FieldSetMember f : this.getCalendarEventFields()){
     		query += f.getFieldPath() + ', ';
     	}
     	
     	query += 'Id, Event_Name__c FROM Calendar_Event__c WHERE Legal_Case__c = \'' + legal_case_Id + '\' ORDER BY Date__c DESC';
     	
     	system.debug('***Query: ' + query);
     	
     	events = Database.query(query);
     	
     	system.debug('***Events Found: ' + events);
     	
     	return events;
     }
     
    public PageReference deleteAction(){
    	try{
        	Calendar_Event__c objDel = [SELECT Id FROM Calendar_Event__c WHERE Id =:ParamID];
           	delete objDel;
        	getRecords();
    	}
    	catch (DMLException e){
    		system.debug('An error occurred while attempting to delete the calendar event record: ' + e);
    		ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while attempting to delete the calendar event record. Please contact your administrator for assistance.'));
    	}

        return null;
    }
}