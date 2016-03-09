public without sharing class PaymentPhaseUpdate {
	// do not allow any phase changes if there is no Contract associated, unless new phase is cancelled
	public static void paymentContractValidation(List<Payment__c> paymentsWithUpdatedPhaseNew, List<Payment__c> paymentsWithUpdatedPhaseOld){
		for(Integer i=0; i<paymentsWithUpdatedPhaseNew.size(); i++){
			if(paymentsWithUpdatedPhaseNew[i].Payment_Phase__c != '0 - Cancelled'){
				if(Integer.valueOf(paymentsWithUpdatedPhaseNew[i].Payment_Phase__c.substring(0,1)) > Integer.valueOf(paymentsWithUpdatedPhaseOld[i].Payment_Phase__c.substring(0,1))){
					if([SELECT count() FROM ContPaymentAssoc__c WHERE Payment__c =: paymentsWithUpdatedPhaseNew[i].Id] == 0){
						paymentsWithUpdatedPhaseNew[i].addError(' You must connect this Payment to a Contract before progressing to the next phase.');
					}
				}
			}
		}
	}
	
	private testmethod static void paymentContractValidationTest() {
		Payment__c p = new Payment__c(Name='testPayment');
		insert p;
		
		Test.startTest();
			p.Payment_Phase__c = '2 - In Progress Phase';
			try{
				update p;
			} catch(System.DmlException e){				
			}
		Test.stopTest();
	}
}