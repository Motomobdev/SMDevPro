trigger Application_ReasonCode on Application__c (before update) 
{
    Map<Integer,Id> appIdsWithUpdates = new Map<Integer,Id>();
    List<Contract> contractsToUpdate = New List<Contract>();
    
    for(Integer i=0; i<trigger.new.size(); i++)
    { 
    	if(Trigger.New[i].Rev_Share_App__c != Trigger.Old[i].Rev_Share_App__c || 
    		Trigger.New[i].of_MOT_Legally_Shippable_Countries__c != Trigger.Old[i].of_MOT_Legally_Shippable_Countries__c ||
    		Trigger.New[i].Name != Trigger.Old[i].Name)
    	{
    		appIdsWithUpdates.put(i, trigger.new[i].Id);
    	}
    }
    
    if(!appIdsWithUpdates.isEmpty())
    {
    	DateTime now = DateTime.now();
    	Map<Id, List<Id>> appIdContractIdList = new Map<Id, List<Id>>();
    	
    	for(ContApplAssoc__c conApp : [SELECT Contract__c, Application__c FROM ContApplAssoc__c WHERE Application__c IN :appIdsWithUpdates.values()])
    	{
    		List<Id> tempList = appIdContractIdList.get(conApp.Application__c);
    		
			if(tempList == null)
			{
				tempList = new List<Id>{ conApp.Contract__c };
			} 
			else 
			{
				tempList.add(conApp.Contract__c);
			}
			
			appIdContractIdList.put(conApp.Application__c, tempList);
    	}
		
		for(Integer i : appIdsWithUpdates.keySet())
		{ 
    		if(Trigger.New[i].Rev_Share_App__c != Trigger.Old[i].Rev_Share_App__c)
    		{
    			if(appIdContractIdList.get(trigger.new[i].Id) != null)
    			{
    				for(Id contractId : appIdContractIdList.get(trigger.new[i].Id))
    				{
    					contractsToUpdate.add(new Contract(Id = contractId, Reason_Code__c = 'SA', Reason_Code_Last_Modified_Date__c = now));
    				}
    			}
    		}
    		else if(Trigger.New[i].of_MOT_Legally_Shippable_Countries__c != Trigger.Old[i].of_MOT_Legally_Shippable_Countries__c)
    		{
    			if(appIdContractIdList.get(trigger.new[i].Id) != null)
    			{
    				for(Id contractId : appIdContractIdList.get(trigger.new[i].Id))
    				{
    					contractsToUpdate.add(new Contract(Id = contractId, Reason_Code__c = 'LS', Reason_Code_Last_Modified_Date__c = now));
    				}
    			}
    		}
    		else if(Trigger.New[i].Name != Trigger.Old[i].Name)
    		{
    			if(appIdContractIdList.get(trigger.new[i].Id) != null)
    			{
    				for(Id contractId : appIdContractIdList.get(trigger.new[i].Id))
    				{
    					contractsToUpdate.add(new Contract(Id = contractId, Reason_Code__c = 'AN', Reason_Code_Last_Modified_Date__c = now));
    				}
    			}
    		}
		}
	    
	    update contractsToUpdate;
    }
}