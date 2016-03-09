trigger CheckForDuplicateOOO on Out_Of_Office__c (before insert, before update) {
	Map<Id, Out_Of_Office__c> userId2OOO = new Map<Id, Out_Of_Office__c>();
	
	for (Out_Of_Office__c o : Trigger.new)
	{
		//First, find any duplicates within the bulk data(if applicable) being added/updated.
		
		if (userId2OOO.get(o.User__c) != null)
		{
			o.user__c.addError('An Out Of Office notification already exists for this user. Please update that record instead.');
		}
		else
		{
			userId2OOO.put(o.User__c, o);
		}
	}

	//Now we have to find if any duplicate Household records already exist in the DB.
	Set<Id> theseOOOs = new Set<Id> ();	
	if (Trigger.isUpdate)
	{
		theseOOOs = Trigger.newMap.keySet();
	}	
	
	//Look for any Household records with the same combination of Name and Phone No (with is what the unique_key__c formulat field is)
	for (Out_Of_Office__c[] hs : [	select user__c from Out_Of_Office__c 
							  		where user__c in :userId2OOO.keySet()
						  	  		and id not in :theseOOOs])
	{
		for (Out_Of_Office__c h : hs)
		{
			userId2OOO.get(h.user__c).user__c.addError('An Out Of Office notification already exists for this user. Please update that record instead.');
		}		   	
	}
}