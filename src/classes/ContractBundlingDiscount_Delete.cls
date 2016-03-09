public with sharing class ContractBundlingDiscount_Delete {
	public static void afterDelete(List<Contract_Bundling_Discount__c> newList){
		Set<Id> contractIds = new Set<Id>();
		for(Contract_Bundling_Discount__c cbc : newList){
			contractIds.add(cbc.Contract__c);
		}
		
		Map<Id, List<Contract_Bundling_Discount__c>> contractIdRuleMap = new Map<Id, List<Contract_Bundling_Discount__c>>();
		for(Contract_Bundling_Discount__c fee : [SELECT Id, Contract__c FROM Contract_Bundling_Discount__c WHERE Contract__c IN : contractIds]){
			List<Contract_Bundling_Discount__c> tempList = contractIdRuleMap.get(fee.Contract__c);
			if(tempList == null){
				tempList = new List<Contract_Bundling_Discount__c>{fee};
			} else {
				tempList.add(fee);				
			}
			contractIdRuleMap.put(fee.Contract__c, tempList);			
		}
		
		List<Contract> contractsToUpdate = new List<Contract>();
		
		for(Id cId : contractIds){
			if(!contractIdRuleMap.containsKey(cId)){
				Contract c = new Contract(Id=cId, Is_there_Bundling_Discount__c = 'No');
				contractsToUpdate.add(c);
			}
		}
		
		if(!contractsToUpdate.isEmpty()){ update contractsToUpdate; }
	}
	
	public static testmethod void ContractBundlingDiscount_DeleteTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today(), Is_there_Bundling_Discount__c='No');
        insert c;
        
        Contract_Bundling_Discount__c cbc = new Contract_Bundling_Discount__c(Contract__c=c.Id);
        Contract_Bundling_Discount__c cbc2 = new Contract_Bundling_Discount__c(Contract__c=c.Id);
        Contract_Bundling_Discount__c cbc3 = new Contract_Bundling_Discount__c(Contract__c=c.Id);
        insert new List<Contract_Bundling_Discount__c>{cbc, cbc2, cbc3};
        
        Test.startTest();
        	delete cbc;
        	
        	delete cbc2;
        	
        	delete cbc3;
    	Test.stopTest();
	}
}