trigger ApplicationManagerTrigger on DeviceapplicationAssoc__c  (before insert){

	ApplicationManager.setAppManagers (Trigger.new);  
}