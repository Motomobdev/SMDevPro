trigger Application_ItemState on Application__c (after update) {
	Set<ID> ids = New Set<ID>();
		for(Integer i=0; i<trigger.new.size(); i++){  
			if((Trigger.New[i].Application_Contract_Governing_End_Date__c != Trigger.Old[i].Application_Contract_Governing_End_Date__c) ||
          	(Trigger.New[i].Application_Contract_Status__c != Trigger.Old[i].Application_Contract_Status__c) ||
          	(Trigger.New[i].Royalty_Current__c != Trigger.Old[i].Royalty_Current__c) ||
          	(Trigger.New[i].ENC_License_Category__c != Trigger.Old[i].ENC_License_Category__c) ||
          	(Trigger.New[i].ECCN_subECCN_Value__c != Trigger.Old[i].ECCN_subECCN_Value__c))	{
				ids.add(Trigger.New[i].id);
          	}   
          
		}
         
		if(!ids.isEmpty()) { AppItemState.AppItemState(ids); }
		
}