public with sharing class ContractNonRateBasedLicenseFee_Insert {
	public static void beforeInsert(List<Contract_Non_Rate_Based_License_Fee__c> newList){
		List<Id> contractIds = new List<Id>();
		for(Contract_Non_Rate_Based_License_Fee__c cnrbl : newList){
			contractIds.add(cnrbl.Contract__c);
		}
		
		List<Contract> contractsToUpdate = [SELECT Id, Finance_Prepay_Minimum_Guarantees__c FROM Contract WHERE Id IN : contractIds];
		
		for(Contract c : contractsToUpdate){
			if(c.Finance_Prepay_Minimum_Guarantees__c == 'Exempt/NA'){
				c.Finance_Prepay_Minimum_Guarantees__c = '';
			}
			
			c.Is_there_Prepay__c = 'Yes';
		}
		
		update contractsToUpdate;
	}
	
	public static testmethod void ContractNonRateBasedLicenseFee_InsertTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today());
        insert c;
        
        Contract_Non_Rate_Based_License_Fee__c cnrbl = new Contract_Non_Rate_Based_License_Fee__c(Contract__c=c.Id);
        
        Test.startTest();
        	insert cnrbl;
    	Test.stopTest();
	}
}