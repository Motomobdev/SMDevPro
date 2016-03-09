public with sharing class WorkaroundRelatedListExt {

	public ID idPatent {get; set;}
	private final Patent__c objPatent;
	public list<Patent_Device__c> lstPatentDevices {get; set;}	
	public String ParamID { get; set; }
	
	public WorkaroundRelatedListExt(ApexPages.StandardController stdController) {
		this.objPatent = (Patent__c)stdController.getRecord();
		idPatent = stdController.getId();
	}	
	
	public void doAction(){
		if(idPatent!=null){
			// Get the Patent Devices related to the Patent Id 
 			getRecords();
		}
	}
	
	public List<Schema.FieldSetMember> getPatentDeviceFields(){
		return SObjectType.Patent_Device__c.FieldSets.Workaround.getFields();
	}
	
	public list<Patent_Device__c> getRecords(){
		String query = 'SELECT ';
		
		for (Schema.FieldSetMember f : this.getPatentDeviceFields()){
			query += f.getFieldPath() + ', ';
		}
		
		query += 'Id FROM Patent_Device__c WHERE Patent__c = \'' + idPatent + '\' AND RecordTypeId = \''
			+ Schema.SObjectType.Patent_Device__c.getRecordTypeInfosByName().get('Workaround').getRecordTypeId() + '\'';
		
		lstPatentDevices = Database.query(query);
		
		return lstPatentDevices;
	}
	
	// The method to delete an item from the list
	public PageReference deleteAction(){
		try{
			Patent_Device__c objDel = [SELECT id FROM Patent_Device__c WHERE id =:ParamID];
			delete objDel;
			getRecords();
		}
		catch (DMLException e){
			system.debug('An error occurred while attempting to delete the workaround record: ' + e);
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error occurred while attempting to delete the workaround record. Please contact your administrator for assistance.'));
		}

		return null;
	}
}