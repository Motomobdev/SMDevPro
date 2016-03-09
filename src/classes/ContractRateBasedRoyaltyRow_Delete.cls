public with sharing class ContractRateBasedRoyaltyRow_Delete {
	
	// this class tested by ContractRateBasedRoyaltyRow_InsertTest
	public static void afterDelete(List<Contract_Rate_Based_Royalty_Row__c> newList){
		// get table Ids
		// get all rows for each table, put into map
		// evaluate rows
		// update necessary contracts
		List<Id> contractIdsThatDontHaveValidRoyaltyTable = new List<Id>();
		Set<Id> rateTableIds = new Set<Id>();
		Map<Id, List<Contract_Rate_Based_Royalty_Row__c>> rateTableRowsListMap = new Map<Id, List<Contract_Rate_Based_Royalty_Row__c>>();
		Map<Id, Id> tableIdContractIdMap = new Map<Id, Id>();
		
		for(Contract_Rate_Based_Royalty_Row__c crbr : newList){
			rateTableIds.add(crbr.Contract_Rate_Based_Royalty__c);
		}
		system.debug('THIS IS RATETABLEIDS: ' + rateTableIds);
		for(Contract_Rate_Based_Royalty_Row__c crbr : [SELECT Id, Contract_Rate_Based_Royalty__c, High_Volume__c, Low_Volume__c, Rate_per_Unit__c, Tier__c, Contract_Rate_Based_Royalty__r.Contract__c FROM Contract_Rate_Based_Royalty_Row__c WHERE Contract_Rate_Based_Royalty__c IN : rateTableIds]){
			List<Contract_Rate_Based_Royalty_Row__c> tempList = rateTableRowsListMap.get(crbr.Contract_Rate_Based_Royalty__c);
			if(tempList == null){
				tempList = new List<Contract_Rate_Based_Royalty_Row__c>{crbr};
			} else {
				tempList.add(crbr);
			}
			rateTableRowsListMap.put(crbr.Contract_Rate_Based_Royalty__c, tempList);
			
			tableIdContractIdMap.put(crbr.Contract_Rate_Based_Royalty__c, crbr.Contract_Rate_Based_Royalty__r.Contract__c);
		}
		system.debug('THIS IS rateTableRowsListMap: ' + rateTableRowsListMap);
		
		for(Id tableId : rateTableIds){
			if(rateTableRowsListMap.get(tableId) != null){
				Boolean hasARatePerUnitHigherThanZero = false;
				
				for(Contract_Rate_Based_Royalty_Row__c crbr : rateTableRowsListMap.get(tableId)){
					if(crbr.Rate_per_Unit__c > 0.0000){
						hasARatePerUnitHigherThanZero = true;
					}
				}
				
				if(!hasARatePerUnitHigherThanZero){
					contractIdsThatDontHaveValidRoyaltyTable.add(tableIdContractIdMap.get(tableId));
				}
			} else {
				for(Contract_Rate_Based_Royalty__c crbr : [SELECT Contract__c FROM Contract_Rate_Based_Royalty__c WHERE Id =: tableId]){
					contractIdsThatDontHaveValidRoyaltyTable.add(crbr.Contract__c);
				}
			}
			
		}
		
		List<Contract> contractsToUpdate = [SELECT Id, Is_there_Royalty__c FROM Contract WHERE Id IN : contractIdsThatDontHaveValidRoyaltyTable AND Is_there_Royalty__c = 'Yes'];
		
		for(Contract c : contractsToUpdate){
			c.Is_there_Royalty__c = 'No';
		}
		
		if(!contractsToUpdate.isEmpty()){ update contractsToUpdate; }
	}
}