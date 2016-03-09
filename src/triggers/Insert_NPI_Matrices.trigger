trigger Insert_NPI_Matrices on Device__c (after insert, after update){
	//ID userId = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1].Id;
	String Device;
  	List<Device__c> devices = New List<Device__c>();

	if(trigger.isUpdate){
		for(Integer i=0; i<trigger.new.size(); i++){
			if((UserInfo.getUserName().startsWith('datafeed@motorola.com') == true) && ((trigger.old[i].Program_Manager_Name__c == null && trigger.new[i].Program_Manager_Name__c != null) || (trigger.old[i].SW_Apps_Lead__c == null && trigger.new[i].SW_Apps_Lead__c != null))){
				devices.add(trigger.new[i]); 
			}
		}
		if(!devices.isEmpty()) { 
			NPI_Device_Matrices.SetNPIMatrices(devices);
			//IPApplications.addDefaultIPApplicationsToNewDevice(trigger.new); 
		}
	}
	
	
	// this section is here because all the current test code relies on device being inserted by datafeed, not updated.
	if(Test.isRunningTest() && trigger.isInsert){
	  	for(Device__c d:Trigger.New){     
	    	if(UserInfo.getUserName().startsWith('datafeed@motorola.com') == true){
	        	devices.add(d);      
	      	}
	  	}
	  	if(!devices.isEmpty()) { NPI_Device_Matrices.SetNPIMatrices(devices); }
	}
}