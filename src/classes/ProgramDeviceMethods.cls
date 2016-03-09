public with sharing class ProgramDeviceMethods {
	public static void checkForExistingProgramDevice(List<Program_Device__c> newList){
		List<Id> programIds = new List<Id>();
		List<Id> deviceIds = new List<Id>();
	
		List<Program_Device__c> validNewProgramDevices = new List<Program_Device__c>();
		
		for(Program_Device__c pd : newList){
			programIds.add(pd.Program__c);
			deviceIds.add(pd.Device__c);
		}
		
		Map<Id, Device__c> devicesAlreadyReviewedMap = new Map<Id, Device__c>([SELECT Id, SWBOM_Reviewed_and_Approved__c FROM Device__c WHERE Id IN : deviceIds AND SWBOM_Reviewed_and_Approved__c = 'Yes']);
		system.debug('DEVICESALREADYREVIEWED: ' + devicesAlreadyReviewedMap);
		
		for(Program_Device__c pd : newList){
			if(devicesAlreadyReviewedMap.containsKey(pd.Device__c)){
				pd.addError('Program cannot be added to Device since the SW BOM has already been Reviewed & Approved');
				return;
			}
		}
		
		Map<String, Program_Device__c> existingProgramDevices = new Map<String, Program_Device__c>();
		for(Program_Device__c pd : [SELECT Id, Program__c, Device__c, Source_Id__c FROM Program_Device__c WHERE Program__c IN : programIds AND Device__c IN : deviceIds AND Source_Id__c = null]){
			existingProgramDevices.put(pd.Program__c + '' + pd.Device__c, pd);
		}
		
		if(!existingProgramDevices.isEmpty()){
			validNewProgramDevices = new List<Program_Device__c>();
			for(Program_Device__c pd : newList){
				system.debug('PD.DEVICE__c: ' + pd.Device__c);
				if(existingProgramDevices.containsKey(pd.Program__c + '' + pd.Device__c)){
					pd.addError('This Program is already attached to this Device. Please select another Program or Device.');
				} else {
					validNewProgramDevices.add(pd);
				}
			}
			system.debug('VALID NEW PROGRAMDEVICES: ' + validNewProgramDevices);
			addProgramAppsToProgramsNewDevice(validNewProgramDevices);
		} else {
			addProgramAppsToProgramsNewDevice(newList);
		}	
	}
	
	public static void addProgramAppsToProgramsNewDevice(List<Program_Device__c> newList){
		List<Id> programIds = new List<Id>();
		Set<Id> deviceIds = new Set<Id>();
		Map<Id, String> sourceIdNameMap = new Map<Id, String>();
		
		for(Program_Device__c pd : newList){
			system.debug('THIS IS PD.PROGRAM: ' + pd.Program__c);
			programIds.add(pd.Program__c);
			sourceIdNameMap.put(pd.Source_Id__c, pd.Source_Name__c);
		}
		
		Id source;
		String sourceName;
		List<DeviceApplicationAssoc__c> devAppsToInsert = new List<DeviceApplicationAssoc__c>();
						
		List<Program_Application__c> existingProgramApplications = [SELECT Id, Program__c, Program__r.Name, Application__c, Status__c, Description__c, Instructions__c FROM Program_Application__c WHERE Program__c IN : programIds];
		system.debug('existingProgramApplications: ' + existingProgramApplications);
		for(Program_Device__c pd : newList){
			 //source will always be null when creating a new programdevice not from a stable or core
			if(pd.Source_Id__c != null){ 
				source = pd.Source_Id__c;
			} else { 
				source = pd.Program__c;
				
			}
			for(Program_Application__c pa : existingProgramApplications){
				String applicationSourceId = pa.Program__c;
				if(applicationSourceId.length() == 18){
					applicationSourceId = applicationSourceId.substring(0,15);
				}
				
				sourceIdNameMap.put(pa.Program__c, pa.Program__r.Name);
				if(pd.Program__c == pa.Program__c){
					if(pa.Status__c == 'Candidate'){
						devAppsToInsert.add(new DeviceApplicationAssoc__c(Device__c = pd.Device__c, Application__c = pa.Application__c, Source_Id__c = source, Source_Name__c = sourceIdNameMap.get(source), Program_Description__c = pa.Description__c, Program_Instructions__c = pa.Instructions__c, Application_Source_Id__c = applicationSourceId, Include_in_BOM__c = true, Approval_Status__c = 'Not Submitable'));
					} else {
						devAppsToInsert.add(new DeviceApplicationAssoc__c(Device__c = pd.Device__c, Application__c = pa.Application__c, Source_Id__c = source, Source_Name__c = sourceIdNameMap.get(source), Program_Description__c = pa.Description__c, Program_Instructions__c = pa.Instructions__c, Application_Source_Id__c = applicationSourceId, Include_in_BOM__c = true));
					}					
				}
			}
		}
		insert devAppsToInsert;
	}

	
	public static void removeProgramAppsFromProgramsOldDevice(List<Program_Device__c> oldList){
		List<Id> programIds = new List<Id>();
		Set<Id> deviceIds = new Set<Id>();
		Set<Id> sourceIds = new Set<Id>();
		for(Program_Device__c pd : oldList){
			programIds.add(pd.Program__c);
			deviceIds.add(pd.Device__c);
			sourceIds.add(pd.Program__c);
			system.debug('THIS IS PROGRAM.__C IN REMOVEPROGRAMAPPSFROM DEVICE: ' + pd.Program__c);
		}
		
		// get list of app Ids that are tied to program
		Set<Id> appIds = new Set<Id>();
		for(Program_Application__c existingProgramApplication : [SELECT Id, Program__c, Application__c, Status__c FROM Program_Application__c WHERE Program__c IN : programIds]){
			appids.add(existingProgramApplication.Application__c);
		}
		
		List<DeviceApplicationAssoc__c> devAppsToDelete = [SELECT Device__c, Application__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : deviceIds AND Application__c IN : appIds AND Source_Id__c IN : sourceIds];
		for(DeviceApplicationAssoc__c da : devAppsToDelete){
			da.Source_Id__c = null;
			da.Source_Name__c = null;
		}
		update devAppsToDelete;
		delete devAppsToDelete;
	}
	
	private static testmethod void ProgramDeviceMethodsTest(){
		Program__c p = new Program__c(Name='testProgram', Reviewed_Approved__c = 'No');
		insert p;
		Device__c d = new Device__c(Name='testDevice');
		insert d;
		Device__c d2 = new Device__c(Name='testDevice2');
		insert d2;
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Application__c app2 = new Application__c(Name='testApp2', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app2;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app2.Id, Governing_End_Date__c=true);
		insert new List<ContApplAssoc__c>{ca1, ca2};
		Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=app.Id, Status__c='Optional');
		insert pa;
		Program_Application__c pa2 = new Program_Application__c(Program__c=p.Id, Application__c=app2.Id);
		insert pa2;
		
		Program_Device__c pd = new Program_Device__c(Program__c=p.id, Device__c=d.Id);
		
		Program_Device__c pd2 = new Program_Device__c(Program__c=p.id, Device__c=d2.Id);
		
		Program_Device__c pdDuplicate = new Program_Device__c(Program__c=p.id, Device__c=d.Id);
		
		Program_Device__c pdDuplicate2 = new Program_Device__c(Program__c=p.id, Device__c=d.Id);
		
		User u = [SELECT Id FROM User WHERE lastName != 'Ahluwalia' AND isActive = true LIMIT 1];
				
		Test.startTest();
			System.runAs(u){
				insert pd;
				try{
					insert new List<Program_Device__c>{pd2, pdDuplicate};
				} catch(System.DMLException e){
					System.assert(e.getMessage().contains('This Program is already attached to this Device. Please select another Program or Device.'));
				}
	
				try{
					insert pdDuplicate2;
				} catch(System.DMLException e){
					System.assert(e.getMessage().contains('This Program is already attached to this Device. Please select another Program or Device.'));
				}
				
				pd.Source_Id__c = pa.Id;
				update pd;
				try{
					delete pd;
				} catch(System.DMLException e){
					System.assert(e.getMessage().contains('You cannot delete the junction between this Program and Device because it was created via the Source relationship.'));
				}
				pd.Source_Id__c = null;
				update pd;
				//delete pd;
				/*
				update pd2;
				pd2.Source_Id__c=null;
				update pd2;
				delete pd2;*/
			}
		Test.stopTest();
	}
}