public with sharing class Calendar_Events_Edit_Ext {
	
	public List<Calendar_Event__c> events {get;set;}
	public List<SelectOption> patents {get;set;}
	public Legal_Case__c legal_case {get;set;}
	
	private List<Calendar_Event__c> events_to_delete;
	
	public Calendar_Events_Edit_Ext(ApexPages.StandardController controller) {
		events = new List<Calendar_Event__c>();
		patents = new List<SelectOption>();
		events_to_delete = new List<Calendar_Event__c>();
	}
	
	public void doAction() {
		String legal_case_Id = ApexPages.currentPage().getParameters().get('legal_case_id');
		
		if (legal_case_Id == null) {
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Missing legal case ID. Unable to display calendar.'));
			return;
		}
		
		try {
			getLegalCase(legal_case_Id);
		}
		catch(QueryException e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Unable to find legal case information for provided ID: ' + legal_case_Id));
			return;
		}
		
		getPatentOptions();
		getRecords();
	}
	
	public void getLegalCase(String legal_case_Id){
		legal_case = [SELECT Id, Name, Case_Name__c, Jurisdiction__c FROM Legal_Case__c WHERE Id =: legal_case_Id];
	}
	
	public List<Schema.FieldSetMember> getCalendarEventFields(){
     	return SObjectType.Calendar_Event__c.FieldSets.Calendar_Events_Edit_Page.getFields();
     }
	
	public void getRecords(){
		String query = 'SELECT ';
     	
     	for (Schema.FieldSetMember f : this.getCalendarEventFields()){
     		query += f.getFieldPath() + ', ';
     	}
     	
     	query += 'Id, Patent__c FROM Calendar_Event__c WHERE Legal_Case__c = \'' + legal_case.Id + '\' ORDER BY Date__c DESC';
     	
     	events = Database.query(query);
	}
	
	public void getPatentOptions(){
		patents.add(new SelectOption('', '--None--'));
		for (Patent__c patent : [SELECT Id, Name FROM Patent__c WHERE Legal_Case__c =: legal_case.Id]){
			patents.add(new SelectOption(patent.Id, patent.Name));
		}
	}
	
	public PageReference addEvent(){
		events.add(new Calendar_Event__c(Legal_Case__c = legal_case.Id));
		return null;
	}
	
	public PageReference removeEvent(){
		Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
		
		Calendar_Event__c event = events.remove(index);
		
		if (event.Id != null){
			events_to_delete.add(event);
		}
		
		return null;
	}
	
	public PageReference cloneEvent(){
		Integer index = Integer.valueOf(ApexPages.currentPage().getParameters().get('index'));
		events.add(events.get(index).clone(false, true));
		return null;
	}
	
	public PageReference save(){
		try{
			delete events_to_delete;
			upsert events;
			return cancel();
		}
		catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while saving: ' + e));
		}
		return null;
	}
	
	public PageReference cancel(){
		return new PageReference('/' + legal_case.Id);
	}
}