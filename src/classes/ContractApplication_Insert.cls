public without sharing class ContractApplication_Insert {
	public static void beforeInsert(List<ContApplAssoc__c> newList){
		Set<Id> appIds = new Set<Id>();
		Map<Id, List<ContApplAssoc__c>> appIdContractAppListMap = new Map<Id, List<ContApplAssoc__c>>(); 
		
		for(ContApplAssoc__c ca : newList){
			if(!appIds.contains(ca.Application__c)){ appIds.add(ca.Application__c); }
			
			List<ContApplAssoc__c> tempList = appIdContractAppListMap.get(ca.Application__c);
			if(tempList == null){
				tempList = new List<ContApplAssoc__c>{ca};
			} else {
				tempList.add(ca);
			}
			appIdContractAppListMap.put(ca.Application__c, tempList);
		}
		
		for(Application__c app : [SELECT Id, Legally_Shippable__c FROM Application__c WHERE Id IN : appIds]){
			if(appIdContractAppListMap.get(app.Id) != null){
				for(ContApplAssoc__c ca : appIdContractAppListMap.get(app.Id)){
					system.debug('THIS IS LEGALLY SHIPPABLE: ' + app.Legally_Shippable__c);
					ca.Legally_Shippable__c = app.Legally_Shippable__c;
				}
			}
		}
	}
		
	public static void afterInsert(List<ContApplAssoc__c> newConApps){
		Set<Id> contractIds = new Set<Id>(); // list of all contract Id's in the trigger
		Set<Id> appIdsToCalculatePercentageOnDevice = new Set<Id>(); // for % executed contracts on BOM/SD		
		Set<Id> contractIdsForSADateCalculation = new Set<Id>();
		Set<Id> contractIdsOfGoverningContractApps = new Set<Id>();
		Set<ContApplAssoc__c> governingContractApps = new Set<ContApplAssoc__c>();
		Set<Id> rateBasedRoyaltyRules = new Set<Id>();
		
		for(ContApplAssoc__c ca : newConApps){
			contractIds.add(ca.Contract__c);
						
			appIdsToCalculatePercentageOnDevice.add(ca.Application__c);
			
			if(ca.Governing_End_Date__c == true){
				governingContractApps.add(ca);					
				contractIdsOfGoverningContractApps.add(ca.Contract__c);	
			}			
			
			if(ca.Contract_Rate_Based_Royalty_Table__c != null){ rateBasedRoyaltyRules.add(ca.Contract_Rate_Based_Royalty_Table__c); }
		}
				
		for(Contract c : [SELECT Id, Contract_Status__c, Contract_Type__c FROM Contract WHERE Id IN : contractIds]){		
			if(c.Contract_Type__c != 'DEA - Device Evaluation Agreement' && c.Contract_Type__c != 'MNDA - Multiparty NDA' && c.Contract_Type__c != 'NDA - Non-Disclosure Agreement' && c.Contract_Type__c != 'PUM - Prototype Unit Agreement' && c.Contract_Type__c != 'TLA - Tools Licensing Agreement'){
				contractIdsForSADateCalculation.add(c.Id);
			}
		}
		
		// Governing conApps, update related applications with contract info
		GoverningContractApplication.contractApplicationInsert(governingContractApps, contractIdsOfGoverningContractApps);
		
		// calculate % executed contraced on BOM or SD 
		if(!appIdsToCalculatePercentageOnDevice.isEmpty()){
			DevAppsOnBomSDWithExecutedContracts.calculatePercentOfExecutedContractsOnBomOrSDCardFromAppId(appIdsToCalculatePercentageOnDevice);
		}
		
		// calculate earliest SA Date for contract
		if(!contractIdsForSADateCalculation.isEmpty()){
			SADateMethods.conAppsCreatedOrDeleted(contractIdsForSADateCalculation);
		}		
		
		// update App Names field on Contracts
		ContractMethods.updateAppNamesField(contractIds);
		
		if(!rateBasedRoyaltyRules.isEmpty()){ ContractRateBasedRoyaltyRuleMethods.setListOfApplications(rateBasedRoyaltyRules); }
	}
	
	public static testmethod void ContractApplicationAfterInsertTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription');
        insert app;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today());
        insert c;
        Contract_Rate_Based_Royalty__c crbrt = new Contract_Rate_Based_Royalty__c(Name='faketable', Contract__c=c.Id);
        insert crbrt;
        
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Contract_Rate_Based_Royalty_Table__c=crbrt.Id);
        Test.startTest();
        	insert ca;
    	Test.stopTest();
	}
}