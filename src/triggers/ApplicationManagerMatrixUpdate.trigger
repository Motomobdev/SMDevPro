trigger ApplicationManagerMatrixUpdate on Application_Manager_Selection_Matrix__c (after update) {
	Set<ID> records = new Set<ID>();
	for(Application_Manager_Selection_Matrix__c amm : trigger.new){
		records.add(amm.Id);
	}
	ApplicationManagerMatrixUpdate.updateRecords(records);	

}