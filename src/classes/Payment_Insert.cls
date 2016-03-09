public without sharing class Payment_Insert {
	// tested by PopulateAccountOwner.populateAccountOwnerOnPaymentTest
	public static void beforeInsert(List<Payment__c> newList){
		Map<Id, List<Payment__c>> accountIdPaymentListMap = new Map<Id, List<Payment__c>>();
		for(Payment__c p : newList){
			if(p.Account__c != null){
				List<Payment__c> tempList = accountIdPaymentListMap.get(p.Account__c);
				if(tempList == null){
					tempList = new List<Payment__c>{p};
				} else {
					tempList.add(p);
				}
				accountIdPaymentListMap.put(p.Account__c, tempList);
			}
				
			if(p.Tigers_Task_Contract__c != null) { RelateRecords.addLeadingZerosToContractNumbers(p); }
		}
		
		if(!accountIdPaymentListMap.isEmpty()){ 
			PopulateAccountOwner.populateAccountOwnerOnPayment(accountIdPaymentListMap);
		}
	}
	
	public static void afterInsert(List<Payment__c> newList){
		RelateRecords.paymentToApplication(newList);
		RelateRecords.paymentToContract(newList);
	}
}