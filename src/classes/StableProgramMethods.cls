public with sharing class StableProgramMethods {
	public static void checkForExistingStableProgramsAndPopulateProgramFields(List<Stable_Program__c> newList, Map<Id, Set<Id>> programIdStableIdListMap, Map<Id, Program__c> programIdMap){
	
		if(!programIdStableIdListMap.isEmpty()){
			for(Stable_Program__c sp : newList){
				if(programIdStableIdListMap.containsKey(sp.Program__c)){
					Set<Id> stableIdsOnProgram = programIdStableIdListMap.get(sp.Program__c);
					if(stableIdsOnProgram.contains(sp.Stable__c)){
						sp.addError('This program is already being used by this Stable.');
					}
				}
			}
		}
		
		for(Stable_Program__c sp : newList){
			sp.Program_Cost_Current__c = programIdMap.get(sp.Program__c).Application_Cost_Current__c;
			sp.Program_Cost_High__c = programIdMap.get(sp.Program__c).Application_Cost_High__c;
			sp.Program_Cost_Low__c = programIdMap.get(sp.Program__c).Application_Cost_Low__c;
			sp.Program_Type__c = programIdMap.get(sp.Program__c).Type__c;
			if(programIdMap.get(sp.Program__c).Reviewed_Approved__c == 'Yes'){
				sp.Program_Status__c = 'Approved';
			} else {
				sp.Program_Status__c = 'Not Approved';
			}
		}
	}
	
	public static void setStableFieldOnProgram(List<Id> programIds, Map<Id, List<Id>> programIdStableIdListMap){	
	
		List<Program__c> programsToUpdate = new List<Program__c>();
		
		for(Program__c p : [SELECT Id, Stable__c FROM Program__c WHERE Id IN : programIds]){
			if(programIdStableIdListMap.get(p.Id) != null && programIdStableIdListMap.get(p.Id).size() == 1){
				p.Stable__c = programIdStableIdListMap.get(p.Id)[0];
				programsToUpdate.add(p);
			} else if(p.Stable__c != null){
				p.Stable__c = null;
				programsToUpdate.add(p);
			}
		}
		
		update programsToUpdate;
	}
	
	public static void addAppsToStableAndStableParentsAndStableDevices(List<Stable_Program__c> newList, List<Id> stableIds, List<Id> programIds){
		Map<Id, List<Id>> programIdAppIdListMap = new Map<Id, List<Id>>();
		Map<Id, String> programIdNameMap = new Map<Id, String>();
		Map<String, String> programAppIdStatusMap = new Map<String, String>();
		
		// setup Map's to be used when creating new records
		for(Program_Application__c pa : [SELECT Program__c, Application__c, Program__r.Name, Status__c FROM Program_Application__c WHERE Program__c IN : programIds]){
			programIdNameMap.put(pa.Program__c, pa.Program__r.Name);
			programAppIdStatusMap.put(pa.Program__c + '' + pa.Application__c, pa.Status__c);
			
			if(programIdAppIdListMap.containsKey(pa.Program__c)){
				List<Id> tempList = programIdAppIdListMap.get(pa.Program__c);
				tempList.add(pa.Application__c);
				programIdAppIdListMap.put(pa.Program__c, tempList);
			} else {
				List<Id> tempList = new List<Id>{pa.Application__c};
				programIdAppIdListMap.put(pa.Program__c, tempList);
			}
		}
		
		Map<Id, List<Id>> stableIdProgramIdListMap = new Map<Id, List<Id>>();
		List<Stable_Application__c> stableAppsToInsert = new List<Stable_Application__c>();
		
		// setup map to know what programs go with what stables
		for(Stable_Program__c sp : newList){
			List<Id> tempList = stableIdProgramIdListMap.get(sp.Stable__c);
			if(tempList == null){
				tempList = new List<Id>{sp.Program__c};
			} else {
				tempList.add(sp.Program__c);
			}
			stableIdProgramIdListMap.put(sp.Stable__c, tempList);
		}
				
		// create stable-apps to insert
		for(Id stableId : stableIdProgramIdListMap.keySet()){
			for(Id programId : stableIdProgramIdListMap.get(stableId)){
				String applicationSourceId = programId;
				if(applicationSourceId.length() == 18){
					applicationSourceId = applicationSourceId.substring(0,15);
				}
				
				if(programIdAppIdListMap.containsKey(programId)){
					for(Id appId : programIdAppIdListMap.get(programId)){
						stableAppsToInsert.add(new Stable_Application__c(Stable__c = stableId, Application__c = appId, Source_Id__c = programId, Source_Name__c = programIdNameMap.get(programId), Stable_App_Status__c = programAppIdStatusMap.get(programId + '' + appId), Application_Source_Id__c = applicationSourceId));
					}
				}
			}
		}
		
		// find cores that use any stable that uses program
		// use that to create core-programs and core-apps to insert
		List<Core_Device_Package_Program__c> cdpProgramsToInsert = new List<Core_Device_Package_Program__c>();
		List<Core_Device_Package_Application__c> cdpAppsToInsert = new List<Core_Device_Package_Application__c>();
		
		for(Core_Device_Package__c cdp : [SELECT Id, Stable__c, Stable__r.Name FROM Core_Device_Package__c WHERE Stable__c IN : stableIds]){
			if(stableIdProgramIdListMap.containsKey(cdp.Stable__c)){
				for(Id programId : stableIdProgramIdListMap.get(cdp.Stable__c)){
					// create core-progam to insert
					cdpProgramsToInsert.add(new Core_Device_Package_Program__c(Core_Device_Package__c = cdp.Id, Program__c = programId, Source_Id__c = cdp.Stable__c, Source_Name__c = cdp.Stable__r.Name));
					
					// create core-apps to insert
					String applicationSourceId = programId;
					if(applicationSourceId.length() == 18){
						applicationSourceId = applicationSourceId.substring(0,15);
					}
					
					if(programIdAppIdListMap.containsKey(programId)){
						for(Id appId : programIdAppIdListMap.get(programId)){
							cdpAppsToInsert.add(new Core_Device_Package_Application__c(Core_Device_Package__c = cdp.Id, Application__c = appId, Source_Id__c = cdp.Stable__c, Source_Name__c = cdp.Stable__r.Name, Application_Source_Id__c = applicationSourceId));
						}
					}
				}	
			}
		}
		
		// find devices that use stable direct or stable through a core
		// use that to create program-devices and dev-apps to be inserted
		List<Program_Device__c> programDevicesToInsert = new List<Program_Device__c>();
		List<DeviceApplicationAssoc__c> devAppsToInsert = new List<DeviceApplicationAssoc__c>();
		for(Device__c d : [SELECT Id, Stable__c, Stable__r.Name, Core_Device_Package__c, Core_Device_Package__r.Name, SWBOM_Reviewed_and_Approved__c FROM Device__c WHERE Stable__c IN : stableIds]){
			if(d.Core_Device_Package__c == null){
				// we know stable was not added via a core, so source should be stable
				if(stableIdProgramIdListMap.containsKey(d.Stable__c)){
					for(Id programId : stableIdProgramIdListMap.get(d.Stable__c)){
						// create programdevice to insert
						programDevicesToInsert.add(new Program_Device__c(Program__c = programId, Device__c = d.Id, Source_Id__c = d.Stable__c, Source_Name__c = d.Stable__r.Name));
						
						// create devapps to insert
						String applicationSourceId = programId;
						if(applicationSourceId.length() == 18){
							applicationSourceId = applicationSourceId.substring(0,15);
						}
						
						if(programIdAppIdListMap.containsKey(programId)){
							for(Id appId : programIdAppIdListMap.get(programId)){
								devAppsToInsert.add(new DeviceApplicationAssoc__c(Device__c = d.Id, Application__c = appId, Source_Id__c = d.Stable__c, Source_Name__c = d.Stable__r.Name, Application_Source_Id__c = applicationSourceId));
							}
						}
					}
				}
			} else {
				// stable was added via a core so source should be core
				if(stableIdProgramIdListMap.containsKey(d.Stable__c)){
					for(Id programId : stableIdProgramIdListMap.get(d.Stable__c)){
						// create programdevice to insert
						programDevicesToInsert.add(new Program_Device__c(Program__c = programId, Device__c = d.Id, Source_Id__c = d.Core_Device_Package__c, Source_Name__c = d.Core_Device_Package__r.Name));
						
						// create devapps to insert
						String applicationSourceId = programId;
						if(applicationSourceId.length() == 18){
							applicationSourceId = applicationSourceId.substring(0,15);
						}
						
						if(programIdAppIdListMap.containsKey(programId)){
							for(Id appId : programIdAppIdListMap.get(programId)){
								devAppsToInsert.add(new DeviceApplicationAssoc__c(Device__c = d.Id, Application__c = appId, Source_Id__c = d.Core_Device_Package__c, Source_Name__c = d.Core_Device_Package__r.Name, Application_Source_Id__c = applicationSourceId));
							}
						}
					}
				}
			}
		}
		
		insert stableAppsToInsert;
		insert cdpProgramsToInsert;	
		insert cdpAppsToInsert;
		insert programDevicesToInsert;
		insert devAppsToInsert;
	}
	
	
	public static void removeAppsFromStableAndCoresAndDevices(List<Stable_Program__c> newList){
		List<Id> stableIds = new List<Id>();
		List<Id> programIds = new List<Id>();		
		/*Map<Id, List<Id>> programIdAppIdListMap = new Map<Id, List<Id>>();*/
		Set<String> applicationSourceIds = new Set<String>();
				
		for(Stable_Program__c sp : newList){
			stableIds.add(sp.Stable__c);
			programIds.add(sp.Program__c);
			
			String applicationSourceId = sp.Program__c;
			if(applicationSourceId.length() == 18){
				applicationSourceId = applicationSourceId.substring(0,15);
			}
			applicationSourceIds.add(applicationSourceId);
		}
		
		// find stable-apps to remove
		List<Stable_Application__c> stableAppsToDelete = [SELECT Id, Source_Id__c FROM Stable_Application__c WHERE Stable__c IN : stableIds AND Source_Id__c IN : programIds AND Application_Source_Id__c IN : applicationSourceIds];
		for(Stable_Application__c sa : stableAppsToDelete){
			sa.Source_Id__c = null;
		}
		
		// find core-programs that came from stables 
		List<Id> coreIdThatUseStables = new List<Id>();
		for(Core_Device_Package__c cdp : [SELECT Id FROM Core_Device_Package__c WHERE Stable__c IN : stableIds]){
			coreIdThatUseStables.add(cdp.Id);
		}

		List<Core_Device_Package_Program__c> cdpProgramsToDelete = [SELECT Id, Core_Device_Package__c FROM Core_Device_Package_Program__c WHERE Core_Device_Package__c IN : coreIdThatUseStables AND Program__c IN : programIds AND Source_Id__c IN: stableIds];
		for(Core_Device_Package_Program__c cdpp : cdpProgramsToDelete){
			cdpp.Source_Id__c = null;
		}
		
		// find core-apps that came from stables that use program
		List<Core_Device_Package_Application__c> cdpAppsToDelete  = [SELECT Id FROM Core_Device_Package_Application__c WHERE Core_Device_Package__c IN : coreIdThatUseStables AND Source_Id__c IN : stableIds AND Application_Source_Id__c IN : applicationSourceIds];
		for(Core_Device_Package_Application__c cdpa : cdpAppsToDelete){
			cdpa.Source_Id__c = null;
		}
		// find program-devices that came from stables or core that use stables to remove
		List<Program_Device__c> programDevicesToDelete = [SELECT Id FROM Program_Device__c WHERE Program__c IN : programIds AND (Source_Id__c IN : stableIds OR Source_Id__c IN : coreIdThatUseStables)];
		for(Program_Device__c pg : programDevicesToDelete){
			pg.Source_Id__c = null;
		}
		
		// find dev-apps that came from stable directly or core that uses stable
		List<DeviceApplicationAssoc__c> devAppsToDelete = [SELECT Id FROM DeviceApplicationAssoc__c WHERE (Source_Id__c IN : StableIds OR Source_Id__c IN : coreIdThatUseStables) AND Application_Source_Id__c IN : applicationSourceIds];
		for(DeviceApplicationAssoc__c da : devAppsToDelete){
			da.Source_Id__c = null;
		}
				
		update stableAppsToDelete;
		delete stableAppsToDelete;
		update cdpProgramsToDelete;
		delete cdpProgramsToDelete;
		update cdpAppsToDelete;
		delete cdpAppsToDelete;
		update programDevicesToDelete;	
		delete programDevicesToDelete;
		update devAppsToDelete;	
		delete devAppsToDelete;
	}	
	
	public static testmethod void StableProgramMethodsTest(){
		Program__c p = new Program__c(Name='testProgram', Reviewed_Approved__c = 'No');
		insert p;
		Program__c p2 = new Program__c(Name='testProgram', Reviewed_Approved__c = 'No');
		insert p2;
		
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Application__c app2 = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app2;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app2.Id, Governing_End_Date__c=true);
		insert new List<ContApplAssoc__c>{ca1, ca2};
		
		Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=app.Id);
		insert pa;
		Program_Application__c pa2 = new Program_Application__c(Program__c=p.Id, Application__c=app2.Id);
		insert pa2;
		
		Stable__c s = new Stable__c(Name='testStable');
		insert s;
		Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp', Stable__c = s.Id);
		insert cdp;
		
		
		Device__c d = new Device__c(Name='testDevice');
		insert d;
		d.Stable__c = s.Id;
		update d;
		Stable_Program__c sp = new Stable_Program__c(Stable__c=s.Id, Program__c=p.Id);
		
		Stable_Program__c sp2 = new Stable_Program__c(Stable__c=s.Id, Program__c=p.Id);
		Stable_Program__c sp3 = new Stable_Program__c(Stable__c=s.Id, Program__c=p2.Id);
		
		Stable_Program__c spDuplicate = new Stable_Program__c(Stable__c=s.Id, Program__c=p.Id);
		
		Test.startTest();
			insert new List<Stable_Program__c>{sp, sp2, sp3};
			try{
				insert spDuplicate;
			} catch(System.DMLException e){
				system.debug('THIS IS MESSAGE ' + e.getMessage());
				System.assert(e.getMessage().contains('This program is already being used by this Stable.'));
			}
			
			delete sp;
		Test.stopTest();
	}
}