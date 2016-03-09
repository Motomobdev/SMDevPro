public with sharing class ContractNonRateBasedLicenseFee_Delete {
	public static void afterDelete(List<Contract_Non_Rate_Based_License_Fee__c> oldList){
		Set<Id> contractIds = new Set<Id>();
		for(Contract_Non_Rate_Based_License_Fee__c cnrbl : oldList){
			contractIds.add(cnrbl.Contract__c);
		}
		
		Map<Id, Contract> contractIdMap = new Map<Id, Contract>([SELECT Id, Finance_Prepay_Minimum_Guarantees__c FROM Contract WHERE Id IN : contractIds]);
				
		Map<Id, List<Contract_Non_Rate_Based_License_Fee__c>> contractIdFeesMap = new Map<Id, List<Contract_Non_Rate_Based_License_Fee__c>>();
		for(Contract_Non_Rate_Based_License_Fee__c fee : [SELECT Id, Contract__c, Contract__r.Finance_Prepay_Minimum_Guarantees__c FROM Contract_Non_Rate_Based_License_Fee__c WHERE Contract__c IN : contractIds]){
			List<Contract_Non_Rate_Based_License_Fee__c> tempList = contractIdFeesMap.get(fee.Contract__c);
			if(tempList == null){
				tempList = new List<Contract_Non_Rate_Based_License_Fee__c>{fee};
			} else {
				tempList.add(fee);				
			}
			contractIdFeesMap.put(fee.Contract__c, tempList);			
		}
		
		List<Contract> contractsToUpdate = new List<Contract>();
		
		for(Id contractId : contractIds){
			if(!contractIdFeesMap.containsKey(contractId)){
				system.debug('CONTRACT ID DID not have any matching fees and field is not already approved');
				Contract c = new Contract(Id=contractId, Is_there_Prepay__c='No');
				if(contractIdMap.get(contractId).Finance_Prepay_Minimum_Guarantees__c != 'Approved'){
					c.Finance_Prepay_Minimum_Guarantees__c='Exempt/NA';
				}
				
				contractsToUpdate.add(c);
			} 		
		}
		
		if(!contractsToUpdate.isEmpty()) { update contractsToUpdate; }
	}
	
	public static testmethod void ContractNonRateBasedLicenseFee_DeleteTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today());
        insert c;
        
        Contract_Non_Rate_Based_License_Fee__c cnrbl = new Contract_Non_Rate_Based_License_Fee__c(Contract__c=c.Id);
        Contract_Non_Rate_Based_License_Fee__c cnrbl2 = new Contract_Non_Rate_Based_License_Fee__c(Contract__c=c.Id);
        Contract_Non_Rate_Based_License_Fee__c cnrbl3 = new Contract_Non_Rate_Based_License_Fee__c(Contract__c=c.Id);
        insert new List<Contract_Non_Rate_Based_License_Fee__c>{cnrbl, cnrbl2, cnrbl3};
        Test.startTest();
        	delete cnrbl;
        	
        	delete cnrbl2;
        	
        	delete cnrbl3;
    	Test.stopTest();
        
	}
}