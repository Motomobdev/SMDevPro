public with sharing class CoreDeviceMethods {
	
	public static void addCoreElementsToDevice(Device__c device){

		Core_Device_Package__c core = [SELECT Id, Stable__c, Name FROM Core_Device_Package__c WHERE Id =: device.Core_Device_Package__c];
		system.debug('THIS IS CORE.Id: ' + core.Id);
		system.debug('THIS IS CORE.Name: ' + core.Name);
		List<Program_Device__c> programDevicesToInsert = new List<Program_Device__c>();
		Map<Id, List<DeviceApplicationAssoc__c>> appIdnewDevAppsListMap = new Map<Id, List<DeviceApplicationAssoc__c>>();
		
		// create list of DevApps to be inserted
		// if app is already in list, add as NOT include in BOM
		Set<Id> tempSetOfNewAppsForDevice = new Set<Id>();
		for(Core_Device_Package_Application__c cdpa : [SELECT Id, Application__c, Core_Device_Package__c, Include_in_BOM__c, Source_Id__c, Application_Source_Id__c FROM Core_Device_Package_Application__c WHERE Core_Device_Package__c =: core.Id]){
			String applicationSourceId = cdpa.Application_Source_Id__c;
			if(applicationSourceId == null){
				applicationSourceId = cdpa.Core_Device_Package__c;
				if(applicationSourceId.length() == 18){
					applicationSourceId = applicationSourceId.substring(0,15);
				}
			}
			
			if(!appIdnewDevAppsListMap.containsKey(cdpa.Application__c)){
				// this application is not yet in Map so you can add it as Include in BOM = true, if it is true on CDP
				if(cdpa.Include_in_BOM__c == true){
					appIdnewDevAppsListMap.put(cdpa.Application__c, new List<DeviceApplicationAssoc__c>{new DeviceApplicationAssoc__c(Device__c = device.Id, Application__c = cdpa.Application__c, Include_in_BOM__c = true, Source_Id__c = core.Id, Source_Name__c = core.Name, Application_Source_Id__c = applicationSourceId)});
				} else {
					appIdnewDevAppsListMap.put(cdpa.Application__c, new List<DeviceApplicationAssoc__c>{new DeviceApplicationAssoc__c(Device__c = device.Id, Application__c = cdpa.Application__c, Include_in_BOM__c = false, Source_Id__c = core.Id, Source_Name__c = core.Name, Application_Source_Id__c = applicationSourceId)});
				}
			} else {
				// this application is already in the Map, so add it as Incldue in BOM = false
				List<DeviceApplicationAssoc__c> tempList = appIdnewDevAppsListMap.get(cdpa.Application__c);
				Boolean isThereACheckedIncludeInBom = false;
				for(DeviceApplicationAssoc__c da : tempList){
					if(da.Include_in_BOM__c == true){ isThereACheckedIncludeInBom = true; }
				}
				if(isThereACheckedIncludeInBom){
					tempList.add(new DeviceApplicationAssoc__c(Device__c = device.Id, Application__c = cdpa.Application__c, Include_in_BOM__c = false, Source_Id__c = core.Id, Source_Name__c = core.Name, Application_Source_Id__c = applicationSourceId));
				} else if(!isThereACheckedIncludeInBom){
					tempList.add(new DeviceApplicationAssoc__c(Device__c = device.Id, Application__c = cdpa.Application__c, Include_in_BOM__c = cdpa.Include_in_BOM__c, Source_Id__c = core.Id, Source_Name__c = core.Name, Application_Source_Id__c = applicationSourceId));
				}
				appIdnewDevAppsListMap.put(cdpa.Application__c, tempList);
			}
		}
		
		// if app exists on device even once already then any new duplicates should be set as Include in BOM = false'
		//Set<Id> appIdsAlreadyOnDevice = new Set<Id>();
		for(DeviceApplicationAssoc__c existingDA : [SELECT Id, Application__c FROM DeviceApplicationAssoc__c WHERE Device__c =: device.Id]){
			//appIdsAlreadyOnDevice.add(da.Application__c);
			if(appIdnewDevAppsListMap.containsKey(existingDA.Application__c)){
				for(DeviceApplicationAssoc__c newDA : appIdnewDevAppsListMap.get(existingDA.Application__c)){
					newDA.Include_in_BOM__c = false;
				}
			}
		}
		
		// if core has stable, check for Stable Programs
		if(core.Stable__c != null){
			device.Stable__c = core.Stable__c;
			for(Stable_Program__c stableProgram : [SELECT Id, Program__c FROM Stable_Program__c WHERE Stable__c =: core.Stable__c]){
				programDevicesToInsert.add(new Program_Device__c(Program__c = stableProgram.Program__c, Device__c = device.Id, Source_Id__c = core.Id, Source_Name__c = core.Name));
			} 
		}
		
		// find corePrograms and create new programDevices		
		for(Core_Device_Package_Program__c coreProgram : [SELECT Id, Program__c, Core_Device_Package__c FROM Core_Device_Package_Program__c WHERE Core_Device_Package__c =: core.Id AND Source_Id__c = null]){
			programDevicesToInsert.add(new Program_Device__c(Program__c = coreProgram.Program__c, Device__c = device.Id, Source_Id__c = core.Id, Source_Name__c = core.Name));
		}
	
		List<DeviceApplicationAssoc__c> devAppsToInsert = new List<DeviceApplicationAssoc__c>();
		for(Id appId : appIdnewDevAppsListMap.keySet()){
			if(appIdnewDevAppsListMap.containsKey(appId)){
				for(DeviceApplicationAssoc__c da : appIdnewDevAppsListMap.get(appId)){
					devAppsToInsert.add(da);
				}
			}
		}

		try{

			
			insert devAppsToInsert;
			insert programDevicesToInsert;
		} catch (System.Dmlexception e){
			device.Core_Device_Package__c.addError('This Core could not be added to this Device at this time. Please try again later or if you have repeated trouble contact Brian Chiang, brian.chiang@motorola.com');
		}
	}
	
	public static void removeCoreDevicePackageElementsFromDevice(Device__c device, Core_Device_Package__c core){
		List<Id> deviceIds = new List<Id>();
		List<Id> coreDevicePackageIds = new List<Id>();
		system.debug('device.id, core.id: ' + device.Id + ', ' + core.Id);

		if(device.Stable__c != null && core.Stable__c != null && core.Stable__c == core.Stable__c){
			device.Stable__c = null;
		}
			
		List<Program_Device__c> existingProgramDevices = [SELECT Id FROM Program_Device__c WHERE Device__c =: device.Id AND Source_Id__c LIKE : core.Id];
		for(Program_Device__c pd : existingProgramDevices){
			pd.Source_Id__c = null;
			pd.Source_Name__c = null;
		}
		update existingProgramDevices;
		delete existingProgramDevices;
		
		List<DeviceApplicationAssoc__c> existingDeviceApplications = [SELECT Id FROM DeviceApplicationAssoc__c WHERE Device__c =: device.Id AND Source_Id__c LIKE : core.Id];
		for(DeviceApplicationAssoc__c da : existingDeviceApplications){
			da.Source_Id__c = null;
			da.Source_Name__c = null;
		}
		update existingDeviceApplications;
		delete existingDeviceApplications;
		
		update device;
	}	
	
	private static testmethod void CoreDeviceMethodsTest(){
		Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp');
		insert cdp;
		
		Stable__c s = new Stable__c(Name='s');
		insert s;

		Program__c programOnCore = new Program__c(Name='testProgram');
		insert programOnCore;
		Program__c programOnStable = new Program__c(Name='testProgram2');
		insert programOnStable;
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c appOnCore = new Application__c(Name='appOnCore', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert appOnCore;
		Application__c appOnStable = new Application__c(Name='appOnStable', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert appOnStable;
		Application__c appOnProgram = new Application__c(Name='appOnProgram', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert appOnProgram;
		
		cdp.Stable__c = s.Id;
		update cdp;
		
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=appOnProgram.Id, Governing_End_Date__c=true);
		ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=appOnStable.Id, Governing_End_Date__c=true);
		insert new List<ContApplAssoc__c>{ca, ca2};
		
		Program_Application__c pa = new Program_Application__c(Program__c=programOnCore.Id, Application__c=appOnProgram.Id);
		insert pa;
		
		Core_Device_Package_Program__c cdpp = new Core_Device_Package_Program__c(Core_Device_Package__c = cdp.Id, Program__c = programOnCore.Id);
		insert cdpp;
		Core_Device_Package_Application__c cdpa = new Core_Device_Package_Application__c(Core_Device_Package__c = cdp.Id, Application__c = appOnCore.Id, Include_in_BOM__c=false);
		insert cdpa;
		
		Stable_Application__c sa = new Stable_Application__c(Stable__c=s.Id, Application__c=appOnStable.Id);
		insert sa;
		
		Stable_Program__c sp = new Stable_Program__c(Stable__c=s.Id, Program__c=programOnStable.Id);
		insert sp;		
		

		User u = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
		Device__c d = new Device__c(Name='d', Core_Device_Package__c = null);
		System.runAs(u) {			
			insert d;
		}
		
		
		Test.startTest();
			d.Core_Device_Package__c = cdp.Id;
			update d;
			
			addCoreElementsToDevice(d);
			
			// test for CoreDevicePackageApplication_Update
			cdpa.Include_in_BOM__c = true;
			update cdpa;
			// end test for CoreDevicePackageApplication_Update
			
			removeCoreDevicePackageElementsFromDevice(d, cdp);
		Test.stopTest();
	}
}