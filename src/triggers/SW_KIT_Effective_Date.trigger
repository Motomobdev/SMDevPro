/*
	Modified By: Neel Desai
	Modified On: 17-Oct-2012
	Reason     : VHD Ticket #90428
	
	Purpose of this trigger is to update 'SW_Kit__c.System_Calculated_Effective_Date__c' 
	value to Min of 'Device__c.SA_Date__c' of all the devies for that SW Kit
*/

trigger SW_KIT_Effective_Date on Device__c (after insert, after update, after delete, after undelete)
{
	//get list of affected SW Kits
	//and update system generated date with min of SA date
	if(Trigger.isDelete)
	{
		Set<Id> swKitIds = new Set<Id>();
		
		for(Device__c device : Trigger.Old)
		{
			if(device.SW_Kit__c != null)
				swKitIds.add(device.SW_Kit__c);
		}
		
		if(!swKitIds.isEmpty())
			SWKitMethods.updateSWKitEffectiveDate(swKitIds);
	}
	
	if(Trigger.isInsert || trigger.isUnDelete)
	{
		Set<Id> swKitIds = new Set<Id>();
		
		for(Device__c device : Trigger.new)
		{
			if(device.SW_Kit__c != null)
				swKitIds.add(device.SW_Kit__c);
		}
		
		if(!swKitIds.isEmpty())
			SWKitMethods.updateSWKitEffectiveDate(swKitIds);
	}
	
	if(Trigger.isUpdate)
	{
		Set<Id> swKitIds = New Set<Id>();
		
		for(Integer i=0; i<Trigger.New.size(); i++)
		{
			// SW Kit has changed for device, need to update both SW Kit
			if(Trigger.New[i].SW_KIT__c != Trigger.Old[i].SW_KIT__c)
			{
				if(Trigger.New[i].SW_KIT__c != null)
					swKitIds.add(Trigger.New[i].SW_KIT__c);
				if(Trigger.Old[i].SW_KIT__c != null)
					swKitIds.add(Trigger.Old[i].SW_KIT__c);
			}
			// SW Kit not changed, check if SA Date or Canceled is changed
			else if (((Trigger.New[i].SA_Date__c != Trigger.Old[i].SA_Date__c) || (Trigger.New[i].Cancelled__c != Trigger.Old[i].Cancelled__c)) 
					&& (Trigger.New[i].SW_KIT__c != NULL))
			{
				swKitIds.add(Trigger.New[i].SW_KIT__c);
			}
		}
		
		if(!swKitIds.isEmpty())
			SWKitMethods.updateSWKitEffectiveDate(swKitIds);
	}
/* 
    Set<ID> swkits = New Set<ID>();   
    List<Device__c> devices = New List<Device__c>(); 
    List<SW_KIT__c> newkits = New List<SW_KIT__c>();            

    for(Integer i=0; i<trigger.new.size(); i++){ 
    	system.debug('THIS IS NEW/OLD kit: ' + trigger.new[i].SW_KIT__c + ' / ' + trigger.old[i].SW_KIT__c);
        if((Trigger.New[i].SW_KIT__c != Trigger.Old[i].SW_KIT__c) || ((Trigger.New[i].SA_Date__c != Trigger.Old[i].SA_Date__c) && (Trigger.New[i].SW_KIT__c != NULL))){
          	if((Trigger.New[i].SW_Kit__c != NULL) || (Trigger.New[i].SA_Date__c != Trigger.Old[i].SA_Date__c)){              
                swkits.add(Trigger.New[i].SW_KIT__c);
          	}
          	if((Trigger.Old[i].SW_KIT__c != NULL) && (Trigger.New[i].SW_KIT__c != Trigger.Old[i].SW_KIT__c)){
                swkits.add(Trigger.Old[i].SW_KIT__c);
          	}
        }
    }
    
    System.debug(swkits + 'swkit debug');
    if(!swKits.isEmpty()){ SWKitMethods.updateSWKitEffectiveDate(swkits); }
*/
}