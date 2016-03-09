public with sharing class ContractNonRoyaltyCostRule_Insert {
	public static void beforeInsert(List<Contract_Non_Royalty_Cost_Rule__c> newList){
		Set<Id> contractIdsThatHaveTypeMaintenance = new Set<Id>();
		Set<Id> contractIdsThatHaveTypeService = new Set<Id>();
		for(Contract_Non_Royalty_Cost_Rule__c cnrcr : newList){
			if(cnrcr.Type__c == 'Maintenance'){
				contractIdsThatHaveTypeMaintenance.add(cnrcr.Contract__c);
			}
			
			if(cnrcr.Type__c == 'Service'){
				contractIdsThatHaveTypeService.add(cnrcr.Contract__c);
			}
		}
		
		List<Contract> contractsToUpdate = [SELECT Id FROM Contract WHERE (Id IN : contractIdsThatHaveTypeMaintenance AND Is_there_Maintenance__c = 'No') OR (Id IN : contractIdsThatHaveTypeService AND Is_there_Service__c = 'No')];
		
		for(Contract c : contractsToUpdate){		
			if(contractIdsThatHaveTypeMaintenance.contains(c.Id)){	
				c.Is_there_Maintenance__c = 'Yes';
			}
			
			if(contractIdsThatHaveTypeService.contains(c.Id)){	
				c.Is_there_Service__c = 'Yes';
			}
		}
		
		update contractsToUpdate;
	}
	
	public static testmethod void ContractNonRoyaltyCostRule_InsertTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today(), Is_there_Maintenance__c='No');
        Contract c2 = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today(), Is_there_Maintenance__c='No');
        insert new List<Contract>{c, c2};
        
        Contract_Non_Royalty_Cost_Rule__c cnrbl = new Contract_Non_Royalty_Cost_Rule__c(Contract__c=c.Id, Type__c='Maintenance');
        Contract_Non_Royalty_Cost_Rule__c cnrbl2 = new Contract_Non_Royalty_Cost_Rule__c(Contract__c=c.Id, Type__c='Service');
        
        Test.startTest();
        	insert new List<Contract_Non_Royalty_Cost_Rule__c>{cnrbl, cnrbl2};
    	Test.stopTest();
	}
}