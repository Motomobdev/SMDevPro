public with sharing class ContractRateBasedRoyaltyRow_Insert {
	public static void afterInsert(List<Contract_Rate_Based_Royalty_Row__c> newList){
		List<Id> contractIdsThatHaveValidRoyaltyTable = new List<Id>();
		Set<Id> rateTableIds = new Set<Id>();
		Map<Id, List<Contract_Rate_Based_Royalty_Row__c>> rateTableRowsListMap = new Map<Id, List<Contract_Rate_Based_Royalty_Row__c>>();
		Map<Id, Id> tableIdContractIdMap = new Map<Id, Id>();
		
		for(Contract_Rate_Based_Royalty_Row__c crbr : newList){
			rateTableIds.add(crbr.Contract_Rate_Based_Royalty__c);
		}
		
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
		
		for(Id tableId : rateTableIds){
			if(rateTableRowsListMap.get(tableId) != null){
				Boolean hasARatePerUnitHigherThanZero = false;

				for(Contract_Rate_Based_Royalty_Row__c crbr : rateTableRowsListMap.get(tableId)){
					if(crbr.Rate_per_Unit__c > 0.0000){
						hasARatePerUnitHigherThanZero = true;
					}
				}

				if(hasARatePerUnitHigherThanZero){
					contractIdsThatHaveValidRoyaltyTable.add(tableIdContractIdMap.get(tableId));
				}
			}	
		}

		List<Contract> contractsToUpdate = [SELECT Id, Is_there_Royalty__c FROM Contract WHERE Id IN : contractIdsThatHaveValidRoyaltyTable AND Is_there_Royalty__c = 'No'];
		
		for(Contract c : contractsToUpdate){
			c.Is_there_Royalty__c = 'Yes';
		}
		
		if(!contractsToUpdate.isEmpty()){ update contractsToUpdate; }
	}
	
	public static testmethod void ContractRateBasedRoyaltyRow_InsertTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today(), Is_there_Royalty__c='No');
        insert c;
        
        Contract_Rate_Based_Royalty__c crbr = new Contract_Rate_Based_Royalty__c(Contract__c=c.Id);
        insert crbr;
        
        Contract_Rate_Based_Royalty_Row__c crbrr1 = new Contract_Rate_Based_Royalty_Row__c(Contract_Rate_Based_Royalty__c=crbr.Id, Rate_per_Unit__c=.6, Low_Volume__c=0, High_Volume__c=10);
        Contract_Rate_Based_Royalty_Row__c crbrr2 = new Contract_Rate_Based_Royalty_Row__c(Contract_Rate_Based_Royalty__c=crbr.Id, Rate_per_Unit__c=.5, Low_Volume__c=0, High_Volume__c=10);
        Contract_Rate_Based_Royalty_Row__c crbrr3 = new Contract_Rate_Based_Royalty_Row__c(Contract_Rate_Based_Royalty__c=crbr.Id, Rate_per_Unit__c=.0, Low_Volume__c=0, High_Volume__c=10);
        
        Test.startTest();
        	insert new List<Contract_Rate_Based_Royalty_Row__c>{crbrr1, crbrr2, crbrr3};
        	
        	delete crbrr1;
        	
        	delete crbrr2;
        	
        	delete crbrr3;
    	Test.stopTest();
	}
}