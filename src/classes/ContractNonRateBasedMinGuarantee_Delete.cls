public with sharing class ContractNonRateBasedMinGuarantee_Delete {
	public static void afterDelete(List<Contract_NonRate_Based_Minimum_Guarantee__c> oldList){
		Set<Id> contractIds = new Set<Id>();
		for(Contract_NonRate_Based_Minimum_Guarantee__c cnbmg : oldList){
			contractIds.add(cnbmg.Contract__c);
		}
		
		Map<Id, Contract> contractIdMap = new Map<Id, Contract>([SELECT Id FROM Contract WHERE Id IN : contractIds AND Is_there_Minimum_Guarantee__c = 'Yes']);
				
		Map<Id, List<Contract_NonRate_Based_Minimum_Guarantee__c>> contractIdFeesMap = new Map<Id, List<Contract_NonRate_Based_Minimum_Guarantee__c>>();
		for(Contract_NonRate_Based_Minimum_Guarantee__c fee : [SELECT Id, Contract__c FROM Contract_NonRate_Based_Minimum_Guarantee__c WHERE Contract__c IN : contractIds]){
			List<Contract_NonRate_Based_Minimum_Guarantee__c> tempList = contractIdFeesMap.get(fee.Contract__c);
			if(tempList == null){
				tempList = new List<Contract_NonRate_Based_Minimum_Guarantee__c>{fee};
			} else {
				tempList.add(fee);				
			}
			contractIdFeesMap.put(fee.Contract__c, tempList);			
		}
		
		List<Contract> contractsToUpdate = new List<Contract>();
		
		for(Id contractId : contractIds){
			if(!contractIdFeesMap.containsKey(contractId)){
				system.debug('CONTRACT ID DID not have any matching minimum guarantees');
				Contract c = new Contract(Id=contractId, Is_there_Minimum_Guarantee__c='No');
				contractsToUpdate.add(c);
			} 		
		}
		
		if(!contractsToUpdate.isEmpty()) { update contractsToUpdate; }
	}
	
	public static testmethod void ContractNonRateBasedMinGuarantee_DeleteTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today(), Is_there_Minimum_Guarantee__c='Yes');
        insert c;
        
        Contract_NonRate_Based_Minimum_Guarantee__c cnbmg = new Contract_NonRate_Based_Minimum_Guarantee__c(Contract__c=c.Id);
        Contract_NonRate_Based_Minimum_Guarantee__c cnbmg2 = new Contract_NonRate_Based_Minimum_Guarantee__c(Contract__c=c.Id);
        Contract_NonRate_Based_Minimum_Guarantee__c cnbmg3 = new Contract_NonRate_Based_Minimum_Guarantee__c(Contract__c=c.Id);
        insert new List<Contract_NonRate_Based_Minimum_Guarantee__c>{cnbmg, cnbmg2, cnbmg3};
        
        Test.startTest();
        	delete cnbmg;
        	
        	delete cnbmg2;
        	
        	delete cnbmg3;
    	Test.stopTest();
        
	}
}