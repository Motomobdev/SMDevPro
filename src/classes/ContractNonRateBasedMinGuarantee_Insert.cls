public with sharing class ContractNonRateBasedMinGuarantee_Insert {
	public static void beforeInsert(List<Contract_NonRate_Based_Minimum_Guarantee__c> newList){
		List<Id> contractIds = new List<Id>();
		for(Contract_NonRate_Based_Minimum_Guarantee__c cnbmg : newList){
			contractIds.add(cnbmg.Contract__c);
		}
		
		List<Contract> contractsToUpdate = [SELECT Id FROM Contract WHERE Id IN : contractIds AND Is_there_Minimum_Guarantee__c = 'No'];
		
		for(Contract c : contractsToUpdate){			
			c.Is_there_Minimum_Guarantee__c = 'Yes';
		}
		
		update contractsToUpdate;
	}
	
	public static testmethod void ContractNonRateBasedMinGuarantee_InsertTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today(), Is_there_Minimum_Guarantee__c='No');
        insert c;
        
        Contract_NonRate_Based_Minimum_Guarantee__c cnbmg = new Contract_NonRate_Based_Minimum_Guarantee__c(Contract__c=c.Id);
        
        Test.startTest();
        	insert cnbmg;
    	Test.stopTest();
        
	}
}