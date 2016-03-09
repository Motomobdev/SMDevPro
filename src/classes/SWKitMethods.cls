/*
	Modified By: Neel Desai
	Modified On: 17-Oct-2012
	Reason     : VHD Ticket #90428
	Change	   : Completely rewritten code; old code is commented below
*/
public with sharing class SWKitMethods 
{
	
	public static void updateSWKitEffectiveDate(Set<Id> swKitIds)
	{
		Map<Id,SW_Kit__c> swKitsToUpdate = new Map<Id,SW_Kit__c>();
		
		// Get list of SW Kit with minimum SA Date 
		// SW Kit's System Calculated Effective Date must have this minimum value
		List<AggregateResult> aggrResults = [SELECT SW_KIT__c, SW_KIT__r.System_Calculated_Effective_Date__c, MIN(SA_Date__c) Min_SA_Date
											 FROM   Device__c 
											 WHERE  SW_KIT__c IN :swKitIds
											 		AND Cancelled__c = false 
													AND SA_Date__c != null
											 GROUP BY SW_KIT__c, SW_KIT__r.System_Calculated_Effective_Date__c];

		for(AggregateResult aggrResult : aggrResults)
		{
			if(aggrResult.get('System_Calculated_Effective_Date__c') != (Date)aggrResult.get('Min_SA_Date'))
			{
				SW_Kit__c swKit = new SW_Kit__c(Id=(Id)aggrResult.get('SW_KIT__c'), System_Calculated_Effective_Date__c=(Date)aggrResult.get('Min_SA_Date'));
				swKitsToUpdate.put(swKit.Id, swKit);
			}
		}
		
		update swKitsToUpdate.values();
		
		
		
		// below block taken from old code (as it is)
		List<DeviceApplicationAssoc__c> devAppsToUpdate = [SELECT Id, DevApp_Item_Effective_Date__c, Device__r.SW_Kit__c 
														   FROM DeviceApplicationAssoc__c 
														   WHERE Device__r.SW_Kit__c IN :swKitsToUpdate.keySet()];

		for(DeviceApplicationAssoc__c da : devAppsToUpdate)
		{
			da.DevApp_Item_Effective_Date__c = ((SW_Kit__c)swKitsToUpdate.get(da.Device__r.SW_Kit__c)).System_Calculated_Effective_Date__c;			
		}
		
		update devAppsToUpdate;
	}
	
	public static testmethod void testUpdateSWKitEffectiveDate()
	{
		SW_Kit__c swKit1 = new SW_Kit__c(Name='SW0000001234');
		insert swKit1;
		Device__c dev1 = new Device__c(SA_Date__c=Date.newInstance(2012, 1, 1), SW_Kit__c=swKit1.Id);
		insert dev1;
		Application__c app1 = new Application__c(Name='Test App');
		insert app1;
		DeviceApplicationAssoc__c devApp1 = new DeviceApplicationAssoc__c(Device__c=dev1.Id, Application__c=app1.Id);
		insert devApp1;
		
		dev1.SA_Date__c = Date.newInstance(2012, 2, 1);
		update dev1;
		
		swKit1.Manually_Entered_Effective_Date__c = Date.newInstance(2012, 3, 1);
		update swKit1;
		
		Device__c dev2 = [SELECT Reason_Code__c FROM Device__c WHERE Id = :dev1.Id];
		System.assertEquals(dev2.Reason_Code__c, 'EF');
		}
		
/*
	public static boolean firstRun = true;
	
	public static void updateSWKitEffectiveDate(Set<Id> swKitIds){
		if (firstRun) {
			firstRun = false;
		}
		else {
			System.debug('Already ran!');
			return;
		}

		Map<Id, List<Device__c>> swKitIdDevices = new Map<Id, List<Device__c>>();
		for(Device__c d : [SELECT SW_KIT__c, SA_Date__c FROM Device__c WHERE SW_KIT__c IN: swKitIds AND Cancelled__c = false AND SA_Date__c != null ORDER BY SA_Date__c ASC]){
		    List<Device__c> temp = swKitIdDevices.get(d.SW_Kit__c);
		    if(temp == null){
		        temp = new List<Device__c>{d};
		    } else {
		        temp.add(d);
		    }
		    swKitIdDevices.put(d.SW_Kit__c, temp);
		}
		
		List<SW_Kit__c> swkits = new List<SW_Kit__c>([SELECT Id, System_Calculated_Effective_Date__c FROM SW_Kit__c WHERE Id IN : swKitIds]);
		Map<Id, SW_Kit__c> swKitsToUpdate = new Map<Id, SW_Kit__c>();
		
		for(SW_Kit__c swkit : swkits){
			if(swKitIdDevices.get(swKit.Id) != null){
				// there are devices using this SW Kit
				if(swKitIdDevices.get(swkit.Id)[0].SA_Date__c != null){
					if(swkit.System_Calculated_Effective_Date__c == null){
			    		swkit.System_Calculated_Effective_Date__c = swKitIdDevices.get(swkit.Id)[0].SA_Date__c;
			    		swKitsToUpdate.put(swkit.Id, swkit);
					}else if(swkit.System_Calculated_Effective_Date__c >= swKitIdDevices.get(swkit.Id)[0].SA_Date__c){
						swkit.System_Calculated_Effective_Date__c = swKitIdDevices.get(swkit.Id)[0].SA_Date__c;
			    		swKitsToUpdate.put(swkit.Id, swkit);
					}
				}
			} else {
				// there are no devices using this SW Kit
				swkit.System_Calculated_Effective_Date__c = null;
				swKitsToUpdate.put(swkit.Id, swkit);
			}
		}
		
		system.debug('swKitsToUpdate.keySet(): ' + swKitsToUpdate.keySet());
		List<DeviceApplicationAssoc__c> devAppsToUpdate = [SELECT Id, DevApp_Item_Effective_Date__c, Device__r.SW_Kit__c FROM DeviceApplicationAssoc__c WHERE Device__r.SW_Kit__c IN : swKitsToUpdate.keySet()];
		for(DeviceApplicationAssoc__c da : devAppsToUpdate){
			da.DevApp_Item_Effective_Date__c = swKitsToUpdate.get(da.Device__r.SW_Kit__c).System_Calculated_Effective_Date__c;			
		}
		
		update swKitsToUpdate.values();
		update devAppsToUpdate;
	}
*/
}