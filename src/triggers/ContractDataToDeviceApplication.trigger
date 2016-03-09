/*
 * Test code for this trigger found in testDeviceApplicationApprovals
 */

trigger ContractDataToDeviceApplication on Contract (after update) {
	Map<Id, Contract> contractMap = new Map<Id, Contract>();
	for(Integer i=0; i<trigger.new.size(); i++){
		if((Trigger.New[i].EndDate != Trigger.old[i].EndDate)|| (Trigger.New[i].Contract_Phase__c != Trigger.old[i].Contract_Phase__c)|| (Trigger.New[i].Name != Trigger.old[i].Name)||
		(Trigger.New[i].Contract_Status__c != Trigger.old[i].Contract_Status__c) ||(Trigger.New[i].ContractNumber != Trigger.old[i].ContractNumber)||
		(Trigger.New[i].OwnerId != Trigger.old[i].OwnerId) ||(Trigger.New[i].LRB_Pipeline_ID__c != Trigger.old[i].LRB_Pipeline_ID__c)||
		(Trigger.New[i].Decision__c != Trigger.old[i].Decision__c) ||(Trigger.New[i].LRB_Approved_Region__c!= Trigger.old[i].LRB_Approved_Region__c)||
		(Trigger.New[i].LRB_Approved_Device__c != Trigger.old[i].LRB_Approved_Device__c) || (trigger.new[i].StartDate != trigger.old[i].StartDate) ||
		(trigger.new[i].Contract_Type__c != trigger.old[i].Contract_Type__c)){
			
			contractMap.put(trigger.new[i].Id, trigger.new[i]);	
		}
	}
		
	List<ContApplAssoc__c> contractApps = [SELECT Contract__c, Application__r.Application_Contract_Governing_End_Date__c, Application__r.Application_Contract_Phase__c,
	Application__r.Application_Contract_Status__c, Application__r.Application_Contract_Name__c, Application__r.Application_Contract_Number__c, 
	Application__r.Application_Contract_Owner__c, Application__r.Application_Contract_LRB_Pipeline_ID__c, Application__r.Application_Contract_Decision__c,
	Application__r.Application_Contract_LRB_Approved_Region__c, Application__r.Application_Contract_LRB_Approved_Device__c, Application__r.Application_Contract_Start_Date__c,
	Application__r.Application_Contract_Type__c
	FROM ContApplAssoc__c WHERE Contract__c IN : contractMap.keySet() AND Governing_End_Date__c = true];	
	
	List<Application__c> appListToUpdate = new List<Application__c>();
	for(ContApplAssoc__c conApp : contractApps){
		Application__c tempApp = new Application__c(Id=conApp.Application__c, 
		Application_Contract_Governing_End_Date__c = contractMap.get(conApp.Contract__c).EndDate,
		Application_Contract_Phase__c = contractMap.get(conApp.Contract__c).Contract_Phase__c ,
		Application_Contract_Status__c = contractMap.get(conApp.Contract__c).Contract_Status__c, 
		Application_Contract_Name__c = contractMap.get(conApp.Contract__c).Name,
		Application_Contract_Number__c = contractMap.get(conApp.Contract__c).ContractNumber, 
		Application_Contract_Owner__c = contractMap.get(conApp.Contract__c).OwnerId,
		Application_Contract_LRB_Pipeline_ID__c = contractMap.get(conApp.Contract__c).LRB_Pipeline_ID__c, 
		Application_Contract_Decision__c = contractMap.get(conApp.Contract__c).Decision__c, 
		Application_Contract_LRB_Approved_Region__c = contractMap.get(conApp.Contract__c).LRB_Approved_Region__c,
		Application_Contract_LRB_Approved_Device__c = contractMap.get(conApp.Contract__c).LRB_Approved_Device__c,
		Application_Contract_Start_Date__c = contractMap.get(conApp.Contract__c).StartDate,
		Application_Contract_Type__c = contractMap.get(conApp.Contract__c).Contract_Type__c);
		appListToUpdate.add(tempApp);
	}
	
	update appListToUpdate;
}