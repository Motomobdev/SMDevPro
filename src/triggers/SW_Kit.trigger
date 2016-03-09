trigger SW_Kit on SW_Kit__c (after update) 
{
	Map<Id, SW_Kit__c> swkitMap = new Map<Id, SW_Kit__c>(); 
	Set<Id> swKitIds = new Set<Id>();
	
	for(Integer i=0; i<trigger.new.size(); i++)
	{
		if(trigger.new[i].Manually_Entered_Effective_Date__c != trigger.old[i].Manually_Entered_Effective_Date__c)
		{
			swkitMap.put(trigger.new[i].Id, trigger.new[i]);
		}
		if(Trigger.New[i].Effective_Date__c != Trigger.Old[i].Effective_Date__c)
		{
			swKitIds.add(Trigger.New[i].Id);
		}
	}
	if(!swkitMap.isEmpty())
	{
		List<DeviceApplicationAssoc__c> devapps = [SELECT Id, DevApp_Item_Effective_Date__c, Device__r.SW_Kit__c FROM DeviceApplicationAssoc__c WHERE Device__r.SW_Kit__c IN : swkitMap.keySet()];
		for(DeviceApplicationAssoc__c da : devapps){
			da.DevApp_Item_Effective_Date__c = swkitMap.get(da.Device__r.SW_Kit__c).Effective_Date__c;
		}
		
		if(!devapps.isEmpty()){ update devapps; }
	}
	if(!swKitIds.isEmpty())
	{
		// Below block to update Reason code on Devices manually 
		List<Device__c> devices = [SELECT Id FROM Device__c WHERE SW_Kit__c IN :swKitIds];
		
		for(Device__c device : devices)
		{
			device.Reason_Code__c = 'EF';
			device.Reason_Code_Date__c = DateTime.now();
		}
		
		update devices;
		
	}
}