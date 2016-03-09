public with sharing class ContractRateBasedRoyaltyRuleMethods {
	public static void setListOfApplications(Set<Id> newList){
		Map<Id, List<ContApplAssoc__c>> rateRuleIdAppListMap = new Map<Id, List<ContApplAssoc__c>>();
		
		for(ContApplAssoc__c caa : [SELECT Id, Application__c, Application__r.Name, Contract__c, Contract_Rate_Based_Royalty_Table__c FROM ContApplAssoc__c WHERE Contract_Rate_Based_Royalty_Table__c IN : newList ORDER BY Application__r.Name ASC]){
			List<ContApplAssoc__c> tempList = rateRuleIdAppListMap.get(caa.Contract_Rate_Based_Royalty_Table__c);
			if(tempList == null){
				tempList = new List<ContApplAssoc__c>{caa};				
			} else {
				tempList.add(caa);
			}
			rateRuleIdAppListMap.put(caa.Contract_Rate_Based_Royalty_Table__c, tempList);
		} 
		
		String listOfAppNames;
		List<Contract_Rate_Based_Royalty__c> rulesToUpdate = new List<Contract_Rate_Based_Royalty__c>();
		
		for(Id ruleId : newList){
			if(!rateRuleIdAppListMap.containsKey(ruleId)){
				rulesToUpdate.add(new Contract_Rate_Based_Royalty__c(Id=ruleId, List_of_Applications_Using_This_Rule__c = null));
			} else {
				listOfAppNames = null;
				
				for(ContApplAssoc__c caa : rateRuleIdAppListMap.get(ruleId)){
					if(listOfAppNames == null){
						listOfAppNames = caa.Application__r.Name;						
					} else {
						listOfAppNames = listOfAppNames + ', ' + caa.Application__r.Name;
					}
				}
				rulesToUpdate.add(new Contract_Rate_Based_Royalty__c(Id=ruleId, List_of_Applications_Using_This_Rule__c = listOfAppNames));
			}
		}
		
		if(!rulesToUpdate.isEmpty()){ update rulesToUpdate; }
	}
	
	public static testmethod void setListOfApplicationsTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription');
        insert app;
        Application__c app2 = new Application__c(Name='testApp2', Account__c=a.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription');
        insert app2;
        Contract c = new Contract(Name='CATest', AccountId=a.Id, startDate=Date.today());
        insert c;
        Contract_Rate_Based_Royalty__c crbrt = new Contract_Rate_Based_Royalty__c(Name='faketable', Contract__c=c.Id);
        insert crbrt;
        
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Contract_Rate_Based_Royalty_Table__c=crbrt.Id);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app2.Id, Contract_Rate_Based_Royalty_Table__c=crbrt.Id);
        
        Test.startTest();
        	insert new List<ContApplAssoc__c>{ca, ca2};
        	
        	delete new List<ContApplAssoc__c>{ca, ca2};
    	Test.stopTest();
	}
}