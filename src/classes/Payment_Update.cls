public without sharing class Payment_Update {
	
	// tested by PopulateAccountOwner.populateAccountOwnerOnPaymentTest
	public static void beforeUpdate(List<Payment__c> newList, List<Payment__c> oldList){
		Map<Id, List<Payment__c>> paymentsWithNewAccountSelectedAccountIdMap = new Map<Id, List<Payment__c>>();
		List<Payment__c> paymentsWithUpdatedPhaseNew = new List<Payment__c>();
		List<Payment__c> paymentsWithUpdatedPhaseOld = new List<Payment__c>();

		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Account__c != null && (newList[i].Account__c != oldList[i].Account__c)){
				List<Payment__c> tempList = paymentsWithNewAccountSelectedAccountIdMap.get(newList[i].Account__c);
				if(tempList == null){
					tempList = new List<Payment__c>{newList[i]};
				} else {
					tempList.add(newList[i]);
				}
				paymentsWithNewAccountSelectedAccountIdMap.put(newList[i].Account__c,tempList);
			}
			
			if(newList[i].Payment_Phase__c != oldList[i].Payment_Phase__c && newList[i].Payment_Phase__c != null && oldList[i].Payment_Phase__c != null){
				paymentsWithUpdatedPhaseNew.add(newList[i]);
				paymentsWithUpdatedPhaseOld.add(oldList[i]);
			}
			
			if(newList[i].Tigers_Task_Contract__c != null && newList[i].Tigers_Task_Contract__c != oldList[i].Tigers_Task_Contract__c) { 
				RelateRecords.addLeadingZerosToContractNumbers(newList[i]); 
			}
		}
		
		if(!paymentsWithNewAccountSelectedAccountIdMap.isEmpty()){ PopulateAccountOwner.populateAccountOwnerOnPayment(paymentsWithNewAccountSelectedAccountIdMap); }
		
		if(!paymentsWithUpdatedPhaseNew.isEmpty() && UserInfo.getUserId() != [SELECT Id FROM User WHERE username LIKE 'datafeed@motorola.com%'].Id){	PaymentPhaseUpdate.paymentContractValidation(paymentsWithUpdatedPhaseNew, paymentsWithUpdatedPhaseOld);	}
	}	
	
	public static void afterUpdate(List<Payment__c> newList, List<Payment__c> oldList){
		List<Payment__c> paymentWithUpdatedTigersApplicationfield = new List<Payment__c>();
		List<Payment__c> paymentWithUpdatedTigersContractfield = new List<Payment__c>();
		
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Tigers_Project_Application__c != null && newList[i].Tigers_Project_Application__c != 'NA'&& newList[i].Tigers_Project_Application__c != oldList[i].Tigers_Project_Application__c){
				paymentWithUpdatedTigersApplicationfield.add(newList[i]);
			}
			
			if(newList[i].Tigers_Task_Contract__c != null && newList[i].Tigers_Task_Contract__c != 'NA' && newList[i].Tigers_Task_Contract__c != oldList[i].Tigers_Task_Contract__c){
				paymentWithUpdatedTigersContractfield.add(newList[i]);
			}
		}
		
		if(!paymentWithUpdatedTigersApplicationfield.isEmpty()){ RelateRecords.updatePaymentToApplication(paymentWithUpdatedTigersApplicationfield); }
		
		if(!paymentWithUpdatedTigersContractfield.isEmpty()){ RelateRecords.updatePaymentToContract(paymentWithUpdatedTigersContractfield); }
	}
}