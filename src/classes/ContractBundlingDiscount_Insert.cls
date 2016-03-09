public with sharing class ContractBundlingDiscount_Insert {
	public static void beforeInsert(List<Contract_Bundling_Discount__c> newList){
		List<Id> contractIds = new List<Id>();
		for(Contract_Bundling_Discount__c cbc : newList){
			contractIds.add(cbc.Contract__c);
		}
		
		List<Contract> contractsToUpdate = [SELECT Id, Is_there_Bundling_Discount__c FROM Contract WHERE Id IN : contractIds AND Is_there_Bundling_Discount__c = 'No'];
		
		for(Contract c : contractsToUpdate){
			c.Is_there_Bundling_Discount__c = 'Yes';
		}
		
		update contractsToUpdate;
	}
	
	public static testmethod void ContractBundlingDiscount_InsertTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today(), Is_there_Bundling_Discount__c='No');
        insert c;
        
        Contract_Bundling_Discount__c cbc = new Contract_Bundling_Discount__c(Contract__c=c.Id);
        
        Test.startTest();
        	insert cbc;
    	Test.stopTest();
	}
}