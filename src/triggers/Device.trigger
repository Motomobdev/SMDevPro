/*
 *Test code for devCountries insert is found in testviewDeviceCountries
*/

trigger Device on Device__c (after insert, before update, after update) {
	if(trigger.isAfter && trigger.isInsert){
	    // add default IP App's to new Devices
	    //IPApplications.addDefaultIPApplicationsToNewDevice(trigger.new);	    
  	}
	
	if(trigger.isBefore && trigger.isUpdate){
		Device_Update.beforeUpdate(trigger.new, trigger.old);
	}
	
	if(trigger.isAfter && trigger.isUpdate){
		Device_Update.afterUpdate(trigger.new, trigger.old);		
	}
}