public without sharing class ContractApplication_Update {
	
	public static void beforeUpdate(List<ContApplAssoc__c> newConApps, List<ContApplAssoc__c> oldConApps){
		for(Integer i=0; i<newConApps.size(); i++){
			if(newConApps[i].Governing_End_Date__c != oldConApps[i].Governing_End_Date__c){
				if(newConApps[i].Governing_End_Date__c == true){
					if([SELECT count() FROM ContApplAssoc__c WHERE Application__c =: newConApps[i].Application__c AND Governing_End_Date__c = true] > 0){
						newConApps[i].addError('There is already a Governing Contract for this Application. To switch please un-check that one first.');
					}
				}
			}
		}	
	}	
	
	public static void afterUpdate(List<ContApplAssoc__c> newConApps, List<ContApplAssoc__c> oldConApps){
		Set<Id> appIdsWithChangedGoverningContract = new Set<Id>();
		Set<Id> rateBasedRoyaltyRules = new Set<Id>();
		
		for(Integer i=0; i<newConApps.size(); i++){
			if(newConApps[i].Governing_End_Date__c != oldConApps[i].Governing_End_Date__c){
				appIdsWithChangedGoverningContract.add(newConApps[i].Application__c);
			}
			
			if(newConApps[i].Contract_Rate_Based_Royalty_Table__c != oldConApps[i].Contract_Rate_Based_Royalty_Table__c){
				if(newConApps[i].Contract_Rate_Based_Royalty_Table__c != null && oldConApps[i].Contract_Rate_Based_Royalty_Table__c == null){
					// Table added to CA
					rateBasedRoyaltyRules.add(newConApps[i].Contract_Rate_Based_Royalty_Table__c);
				} else if(newConApps[i].Contract_Rate_Based_Royalty_Table__c != null && oldConApps[i].Contract_Rate_Based_Royalty_Table__c != null){
					// Table changed to new one
					rateBasedRoyaltyRules.add(newConApps[i].Contract_Rate_Based_Royalty_Table__c);
					rateBasedRoyaltyRules.add(oldConApps[i].Contract_Rate_Based_Royalty_Table__c);
				} else if(newConApps[i].Contract_Rate_Based_Royalty_Table__c == null && oldConApps[i].Contract_Rate_Based_Royalty_Table__c != null){
					// Table removed from CA
					rateBasedRoyaltyRules.add(oldConApps[i].Contract_Rate_Based_Royalty_Table__c);
				}
			}
		}	
		system.debug('THIS IS appIdsWithChangedGoverningContract: ' + appIdsWithChangedGoverningContract);
		GoverningContractApplication.contractApplicationUpdate(appIdsWithChangedGoverningContract);
		
		if(!rateBasedRoyaltyRules.isEmpty()){ ContractRateBasedRoyaltyRuleMethods.setListOfApplications(rateBasedRoyaltyRules); }
	}
	
	public static testmethod void ContractApplicationUpdateInsertTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription');
        insert app;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today());
        insert c;
        Contract_Rate_Based_Royalty__c crbrt = new Contract_Rate_Based_Royalty__c(Name='faketable', Contract__c=c.Id);
        insert crbrt;
        Contract_Rate_Based_Royalty__c crbrt2 = new Contract_Rate_Based_Royalty__c(Name='faketable', Contract__c=c.Id);
        insert crbrt2;
        
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
        insert ca;
        
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=false);
        insert ca2;
        
        try{
        	ca2.Governing_End_Date__c = true;
        	update ca2;
        } catch(System.DMLException e){
			//System.assert(e.getMessage().contains('There is already a Governing Contract for this Application. To switch please un-check that one first.'));
		}
		
		ca.Governing_End_Date__c = false;
		update ca;
		
		ca.Contract_Rate_Based_Royalty_Table__c=crbrt.id;
		update ca;
		
		ca.Contract_Rate_Based_Royalty_Table__c = crbrt2.Id;
		update ca;
		
		ca.Contract_Rate_Based_Royalty_Table__c = null;
		update ca;
    	
	}

}