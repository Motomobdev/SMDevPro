public without sharing class RelateRecords {
	public static void paymentToApplication(List<Payment__c> newPayments){
		List<Payment_Application_Assoc__c> appPayments = new List<Payment_Application_Assoc__c>();
		Map<string, Id> appMotIdMap = getApplicationMotIdMap(newPayments);
		
		for(Payment__c p : newPayments){			
			if(p.Tigers_Project_Application__c != null){
				system.debug('THIS IS Tigers_Project_Application__c: ' + p.Tigers_Project_Application__c);
				for(string appMotId : getApplicationMotIds(p.Tigers_Project_Application__c)){
					if(appMotIdMap.get(appMotId) != null){
						appPayments.add(new Payment_Application_Assoc__c(Payment__c=p.Id, Application__c=appMotIdMap.get(appMotId)));
					}
				}
			}		
		}
		insert appPayments;
	}
	
	private static Map<String, Id> getApplicationMotIdMap(List<Payment__c> payments){
		List<String> appMotIds = new List<String>();
		Map<String, Id> appMotIdMap = new Map<String, Id>();
		for(Payment__c p : payments){
			if(p.Tigers_Project_Application__c != null){ appMotIds.addAll(getApplicationMotIds(p.Tigers_Project_Application__c)); }
		}
		
		for(Application__c app : [SELECT Id, Application_ID__c FROM Application__c WHERE Application_ID__c IN : appMotIds]){
			appMotIdMap.put(app.Application_ID__c, app.Id);
		}
		return appMotIdMap;
	}
	
	public static void updatePaymentToApplication(List<Payment__c> updatedPayments){
		system.debug('UPDATE PAYMENTTOAPP');
		Map<Id, Payment__c> paymentIdMap = new Map<Id, Payment__c>(updatedPayments);

		delete [SELECT Id FROM Payment_Application_Assoc__c WHERE Payment__c IN : paymentIdMap.keySet()];

		paymentToApplication(updatedPayments);
	}
	
	private static List<String> getApplicationMotIds(String Tigers_Project_Application){
		List<String> applicationMOTIds = new List<String>();
		applicationMOTIds = Tigers_Project_Application.split(',');
		system.debug('THIS IS applicationMOTIds' + applicationMOTIds);
		return applicationMOTIds;
	}	
	
	public static void paymentToContract(List<Payment__c> newPayments){
		List<ContPaymentAssoc__c> contractPayments = new List<ContPaymentAssoc__c>();
		Map<String, Id> contractNumberIdMap = getContractNumberIdMap(newPayments);
		
		for(Payment__c p : newPayments){			
			if(p.Tigers_Task_Contract__c != null){
				system.debug('THIS IS Tigers_Task_Contract__c: ' + p.Tigers_Task_Contract__c);
				for(string contractNumber : getContractNumbers(p.Tigers_Task_Contract__c)){
					if(contractNumberIdMap.get(contractNumber) != null){
						contractPayments.add(new ContPaymentAssoc__c(Payment__c=p.Id, Contract__c=contractNumberIdMap.get(contractNumber)));
					}
				}
			}		
		}

		insert contractPayments;
	}
	
	private static Map<String, Id> getContractNumberIdMap(List<Payment__c> payments){
		List<String> contractNumbers = new List<String>();
		Map<String, Id> contractNumberIdMap = new Map<String, Id>();
		for(Payment__c p : payments){
			if(p.Tigers_Task_Contract__c != null){ contractNumbers.addAll(getContractNumbers(p.Tigers_Task_Contract__c)); }
		}
		
		for(Contract contract : [SELECT Id, ContractNumber FROM Contract WHERE ContractNumber IN : contractNumbers]){
			contractNumberIdMap.put(contract.ContractNumber, contract.Id);
		}
		return contractNumberIdMap;
	}
	
	public static void updatePaymentToContract(List<Payment__c> updatedPayments){
		system.debug('UPDATE PAYMENTTOCONTRACT');
		Map<Id, Payment__c> paymentIdMap = new Map<Id, Payment__c>(updatedPayments);

		delete [SELECT Id FROM ContPaymentAssoc__c WHERE Payment__c IN : paymentIdMap.keySet()];

		paymentToContract(updatedPayments);
	}
	

	private static List<String> getContractNumbers(String Tigers_Task_Contract){
		List<String> contractNumbers = new List<String>();
		contractNumbers = Tigers_Task_Contract.split(',');
		system.debug('THIS IS contractNumbers' + contractNumbers);
		return contractNumbers;
	}
	
	public static void addLeadingZerosToContractNumbers(Payment__c p){
		List<String> contractNumbers = p.Tigers_Task_Contract__c.split(',');
		p.Tigers_Task_Contract__c = '';		
		for(Integer i=0; i<contractNumbers.size(); i++){
			if(contractNumbers[i].length() < 8){
				Integer difference = 8 - contractNumbers[i].length();
				for(Integer k=0; k<difference; k++){
					contractNumbers[i] = '0' + contractNumbers[i]; 
				}
			}
			if(i == 0){
				p.Tigers_Task_Contract__c = contractNumbers[i]; 
			} else {
				p.Tigers_Task_Contract__c = p.Tigers_Task_Contract__c + ',' + contractNumbers[i]; 
			}
		}		
	}
	
	private testmethod static void paymentToApplicationAndContractTest(){
		Account acc = new Account(Name='account', Tier__c ='1');
		insert acc;
				
		Application__c a1 = new Application__c(Name='app1', Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert a1;
		a1 = [SELECT Application_ID__c FROM Application__c WHERE id =: a1.Id];
		
		Application__c a2 = new Application__c(Name='app2', Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert a2;
		a2 = [SELECT Application_ID__c FROM Application__c WHERE id =: a2.Id];
				
		Contract c1 = new Contract(Name='contract1', AccountId=acc.Id);
		insert c1;
		c1 = [SELECT ContractNumber FROM Contract WHERE id =: c1.Id];
		
		Contract c2 = new Contract(Name='contract2', AccountId=acc.Id);
		insert c2;
		c2 = [SELECT ContractNumber FROM Contract WHERE id =: c2.Id];	
		
		Payment__c p = new Payment__c(Name='payment0');
		Test.startTest();
			insert p;
			p.Tigers_Task_Contract__c = c1.ContractNumber + ',' + c2.ContractNumber.subString(4);
			p.Tigers_Project_Application__c = a1.Application_ID__c + ',' + a2.Application_ID__c;
			update p;
		Test.stopTest();
		
		//System.assertEquals(2, [SELECT count() FROM Payment_Application_Assoc__c WHERE Payment__c =: p.Id]);
		//System.assertEquals(2, [SELECT count() FROM ContPaymentAssoc__c WHERE Payment__c =: p.Id]);
	}
}