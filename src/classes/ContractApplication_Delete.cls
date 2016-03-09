public without sharing class ContractApplication_Delete {
	public static void afterDelete(List<ContApplAssoc__c> oldConApps){
		Set<Id> contractIds = new Set<Id>(); // list of all contract Id's in the trigger
		Set<Id> contractIdsForSADateCalculation = new Set<Id>();
		List<String> contractTypesNotToInclude = new List<String>{'DEA - Device Evaluation Agreement','MNDA - Multiparty NDA', 'NDA - Non-Disclosure Agreement', 'PUM - Prototype Unit Agreement', 'TLA - Tools Licensing Agreement'};
		Set<Id> appIdsToCalculatePercentageOnDevice = new Set<Id>(); // for % executed contracts on BOM/SD
		Set<Id> appIdsOfGoverningConApps = new Set<Id>();
		Set<Id> rateBasedRoyaltyRules = new Set<Id>();
		
		for(ContApplAssoc__c ca : oldConApps){
			contractIds.add(ca.Contract__c);
			appIdsToCalculatePercentageOnDevice.add(ca.Application__c);
			
			if(ca.Governing_End_Date__c == true){
				appIdsOfGoverningConApps.add(ca.Application__c);
			}

			if(ca.Contract_Rate_Based_Royalty_Table__c != null){ rateBasedRoyaltyRules.add(ca.Contract_Rate_Based_Royalty_Table__c); }
		}
		
		for(Contract c : [SELECT Id, Contract_Status__c, Contract_Type__c FROM Contract WHERE Id IN : contractIds AND Contract_Type__c NOT IN : contractTypesNotToInclude]){
			contractIdsForSADateCalculation.add(c.Id);
		}		
		
		// calculate earliest SA Date for contract
		if(!contractIdsForSADateCalculation.isEmpty()){
			SADateMethods.conAppsCreatedOrDeleted(contractIdsForSADateCalculation);
		}
		
		// calculate % of executed contracts on BOM or SD Card apps
		if(!appIdsToCalculatePercentageOnDevice.isEmpty()){
			DevAppsOnBomSDWithExecutedContracts.calculatePercentOfExecutedContractsOnBomOrSDCardFromAppId(appIdsToCalculatePercentageOnDevice);
		}		
		
		// update Applications of governing ConApps
		if(!appIdsofGoverningConApps.isEmpty()){
			GoverningContractApplication.contractApplicationUpdate(appIdsOfGoverningConApps);
		}
		
		// update App Names field on Contracts
		ContractMethods.updateAppNamesField(contractIds);
		
		if(!rateBasedRoyaltyRules.isEmpty()){ ContractRateBasedRoyaltyRuleMethods.setListOfApplications(rateBasedRoyaltyRules); }
	}

}