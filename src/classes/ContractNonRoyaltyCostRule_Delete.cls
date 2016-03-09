public with sharing class ContractNonRoyaltyCostRule_Delete {
	public static void afterDelete(List<Contract_Non_Royalty_Cost_Rule__c> newList){
		Set<Id> contractIds = new Set<Id>();

		for(Contract_Non_Royalty_Cost_Rule__c cnrcr : newList){
			contractIds.add(cnrcr.Contract__c);
		}
		
		Map<Id, List<Contract_Non_Royalty_Cost_Rule__c>> contractIdMapMaintenance = new Map<Id, List<Contract_Non_Royalty_Cost_Rule__c>>();
		Map<Id, List<Contract_Non_Royalty_Cost_Rule__c>> contractIdMapService = new Map<Id, List<Contract_Non_Royalty_Cost_Rule__c>>();
		for(Contract_Non_Royalty_Cost_Rule__c rule : [SELECT Id, Contract__c, Type__c FROM Contract_Non_Royalty_Cost_Rule__c WHERE Contract__c IN : contractIds]){
			if(rule.Type__c == 'Maintenance'){
				List<Contract_Non_Royalty_Cost_Rule__c> tempList = contractIdMapMaintenance.get(rule.Contract__c);
				if(tempList == null){
					tempList = new List<Contract_Non_Royalty_Cost_Rule__c>{rule};
				} else {
					tempList.add(rule);
				}
				contractIdMapMaintenance.put(rule.Contract__c, tempList);
			} else if(rule.Type__c == 'Service'){
				List<Contract_Non_Royalty_Cost_Rule__c> tempList = contractIdMapService.get(rule.Contract__c);
				if(tempList == null){
					tempList = new List<Contract_Non_Royalty_Cost_Rule__c>{rule};
				} else {
					tempList.add(rule);
				}
				contractIdMapService.put(rule.Contract__c, tempList);
			}
		}
		
		List<Contract> contractsToUpdate = new List<Contract>();
		
		for(Id contractId : contractIds){
			Contract c = new Contract(Id=contractId);
			if(!contractIdMapMaintenance.containsKey(contractId) || !contractIdMapService.containsKey(contractId)){
				if(!contractIdMapMaintenance.containsKey(contractId)){
					system.debug('CONTRACT ID DID not have any maintenance rules');
					c.Is_there_Maintenance__c = 'No';				
				}
				
				if(!contractIdMapService.containsKey(contractId)){
					system.debug('CONTRACT ID DID not have any service rules');
					c.Is_there_Service__c = 'No';				
				}
				
				contractsToUpdate.add(c);
			}
		}
		
		if(!contractsToUpdate.isEmpty()) { update contractsToUpdate; }
	}
	
	public static testmethod void ContractNonRoyaltyCostRule_DeleteTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today(), Is_there_Maintenance__c='No');
        insert c;
        
        Contract_Non_Royalty_Cost_Rule__c cnrblM1 = new Contract_Non_Royalty_Cost_Rule__c(Contract__c=c.Id, Type__c='Maintenance');
        Contract_Non_Royalty_Cost_Rule__c cnrblM2 = new Contract_Non_Royalty_Cost_Rule__c(Contract__c=c.Id, Type__c='Maintenance');
        Contract_Non_Royalty_Cost_Rule__c cnrblM3 = new Contract_Non_Royalty_Cost_Rule__c(Contract__c=c.Id, Type__c='Maintenance');
        Contract_Non_Royalty_Cost_Rule__c cnrblS1 = new Contract_Non_Royalty_Cost_Rule__c(Contract__c=c.Id, Type__c='Service');
        Contract_Non_Royalty_Cost_Rule__c cnrblS2 = new Contract_Non_Royalty_Cost_Rule__c(Contract__c=c.Id, Type__c='Service');
        Contract_Non_Royalty_Cost_Rule__c cnrblS3 = new Contract_Non_Royalty_Cost_Rule__c(Contract__c=c.Id, Type__c='Service');
        insert new List<Contract_Non_Royalty_Cost_Rule__c>{cnrblM1, cnrblM2, cnrblM3, cnrblS1, cnrblS2, cnrblS3};
        
        Test.startTest();
        	delete new List<Contract_Non_Royalty_Cost_Rule__c>{cnrblM1, cnrblS1};
        	
        	delete new List<Contract_Non_Royalty_Cost_Rule__c>{cnrblM2, cnrblS2};
        	
        	delete new List<Contract_Non_Royalty_Cost_Rule__c>{cnrblM3, cnrblS3};
    	Test.stopTest();
	}
}