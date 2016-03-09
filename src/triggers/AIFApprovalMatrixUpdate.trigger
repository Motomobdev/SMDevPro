trigger AIFApprovalMatrixUpdate on AIF_Approval_Matrix__c (after update) {
	Set<ID> records = new Set<ID>();
	for(AIF_Approval_Matrix__c aam : trigger.new){
		records.add(aam.Id);
	}
	AIFApprovalMatrixUpdate.updateRecords(records);
}