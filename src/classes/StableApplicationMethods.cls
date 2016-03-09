public with sharing class StableApplicationMethods {
	public static void checkForExistingStableApplicationsAndPopulateFields(List<Stable_Application__c> newList, List<Id> appIds, List<Id> stableIds){
		
		for(Stable_Application__c sa : newList){
			sa.Owner__c = UserInfo.getUserId();
		}
		Map<Id, Application__c> appIdMap = new Map<Id, Application__c>([SELECT Id, Application_Type__c FROM Application__c WHERE Id IN : appIds]);
		for(Stable_Application__c sa : newList){
			if(appIdMap.get(sa.Application__c) != null){ sa.Application_Type__c =  appIdMap.get(sa.Application__c).Application_Type__c; }
		}
		
		Map<Id, List<Stable_Application__c>> existingStableIdStableAppListMap = new Map<Id, List<Stable_Application__c>>();
		
		for(Stable_Application__c existingStableApp : [SELECT Id, Application__c, Stable__c, Source_Id__c, Stable_App_Status__c FROM Stable_Application__c WHERE Application__c IN : appIds AND Stable__c IN : stableIds]){
			List<Stable_Application__c> tempList = existingStableIdStableAppListMap.get(existingStableApp.Stable__c);
			if(tempList == null){
				tempList = new List<Stable_Application__c>{existingStableApp};
			} else {
				tempList.add(existingStableApp);
			}
			existingStableIdStableAppListMap.put(existingStableApp.Stable__c, tempList);
		}
		
		String existingStatus;

		for(Stable_Application__c sa : newList){		
			if(existingStableIdStableAppListMap.get(sa.Stable__c) != null){
				for(Stable_Application__c existingSA : existingStableIdStableAppListMap.get(sa.Stable__c)){
					if(sa.Application__c == existingSA.Application__c){
						existingStatus = existingSA.Stable_App_Status__c;
						if(existingSA.Source_Id__c == sa.Source_Id__c){
							sa.addError('This Application is already attached to this Stable. Please select another Application or Stable');
						}
					}
				}
			}			
		}
	}
	
	public static void checkForApplictionContract(List<Stable_Application__c> newList, List<Id> appIds){

		Map<Id, ContApplAssoc__c> appIdContractAppMap = new Map<Id, ContApplAssoc__c>();
		for(ContApplAssoc__c ca : [SELECT Id, Application__c FROM ContApplAssoc__c WHERE Application__c IN : appIds AND Governing_End_Date__c = true]){
			appIdContractAppMap.put(ca.Application__c, ca);
		}
		
		for(Stable_Application__c sa : newList){
			if(!appIdContractAppMap.containsKey(sa.Application__c)){
				sa.addError('You cannot add this Application to a Stable because it does have have a Governing Contract.');
			}
		}
	}
	
	public static void normalizeStatusOfStableAppDuplicates(List<Id> stableIds, List<Id> appIds){	
		List<Id> programIds = new List<Id>();
		Map<String, String> programAppStatusMap = new Map<String, String>(); 
		List<Stable_Application__c> stableAppsToUpdateStatus = new List<Stable_Application__c>();
		
		List<Stable_Application__c> allSAList = [SELECT Id, Application__c, Stable__c, Stable_App_Status__c, Source_Id__c FROM Stable_Application__c WHERE Application__c IN : appIds AND Stable__c IN : stableIds];
		for(Stable_Application__c sa : allSAList){
			if(sa.Source_Id__c != null){
				programIds.add(sa.Source_Id__c);
			}
		}
		
		for(Program_Application__c pa : [SELECT Id, Program__c, Application__c, Status__c FROM Program_Application__c WHERE Program__c IN : programIds AND Application__c IN : appIds]){
			system.debug('this is progAPP Status: ' + pa.Status__c);
			programAppStatusMap.put(pa.Program__c + '' + pa.Application__c, pa.Status__c);
		}
		
		Map<Id, Map<Id, List<Stable_Application__c>>> stableIdAppIdStableAppMap = new Map<Id, Map<Id, List<Stable_Application__c>>>();
		for(Stable_Application__c sa : allSAList){
			if(sa.Source_Id__c != null && programAppStatusMap.get(sa.Source_Id__c + '' + sa.Application__c) != null){
				system.debug('SET SA STATUS TO: ' + programAppStatusMap.get(sa.Source_Id__c + '' + sa.Application__c));
				sa.Stable_App_Status__c = programAppStatusMap.get(sa.Source_Id__c + '' + sa.Application__c);
			}
			Map<Id, List<Stable_Application__c>> tempAppIdStableAppMap = stableIdAppIdStableAppMap.get(sa.Stable__c);
			if(tempAppIdStableAppMap == null){
				tempAppIdStableAppMap = new Map<Id, List<Stable_Application__c>>();
				tempAppIdStableAppMap.put(sa.Application__c, new List<Stable_Application__c>{sa});
			} else {
				List<Stable_Application__c> tempSAList = tempAppIdStableAppMap.get(sa.Application__c);
				if(tempSAList == null){
					tempSAList = new List<Stable_Application__c>{sa};
				} else {
					tempSAList.add(sa);
				}
				tempAppIdStableAppMap.put(sa.Application__c, tempSAList);
			}
			stableIdAppIdStableAppMap.put(sa.Stable__c, tempAppIdStableAppMap);
		}
		
		for(Id stableId : stableIdAppIdStableAppMap.keySet()){
			Map<Id, List<Stable_Application__c>> appIdStableAppMap = stableIdAppIdStableAppMap.get(stableId);
			for(Id appId : appIdStableAppMap.keySet()){
				if(appIdStableAppMap.get(appId).size() > 0){
					String highestStatus;
					for(Stable_Application__c sa : appIdStableAppMap.get(appId)){
						if(highestStatus == null){
							highestStatus = sa.Stable_App_Status__c;
						} else if(highestStatus != 'Mandatory'){
							if(highestStatus == 'Optional' && sa.Stable_App_Status__c == 'Mandatory'){
								highestStatus = 'Mandatory';
							} else if(highestStatus == 'Candidate' && (sa.Stable_App_Status__c == 'Optional' || sa.Stable_App_Status__c == 'Mandatory')){
								highestStatus = sa.Stable_App_Status__c;
							}
						}
					}
					for(Stable_Application__c sa : appIdStableAppMap.get(appId)){
						if(sa.Stable_App_Status__c != highestStatus){
							sa.Stable_App_Status__c = highestStatus;							
						}
						stableAppsToUpdateStatus.add(sa);
					}
				}
			}
		}
		
		update stableAppsToUpdateStatus;
	}
	
	public static void addAppToStableParents(List<Stable_Application__c> newList){
		List<Id> stableIds = new List<Id>();
		Map<Id, List<Id>> stableIdAppIdListMap = new Map<Id, List<Id>>();
		for(Stable_Application__c sa : newList){
			stableIds.add(sa.Stable__c);
			
			List<Id> tempList = stableIdAppIdListMap.get(sa.Stable__c);
			if(tempList == null){
				tempList = new List<Id>{sa.Application__c};
			} else {
				tempList.add(sa.Application__c);
			}
			stableIdAppIdListMap.put(sa.Stable__c, tempList);
		}
		
		/* add apps to Cores using Stables */
		List<Core_Device_Package_Application__c> cdpAppsToInsert = new List<Core_Device_Package_Application__c>();		
		List<Id> coreIds = new List<Id>();
		for(Core_Device_Package__c cdp : [SELECT Id, Stable__c, Stable__r.Name FROM Core_Device_Package__c WHERE Stable__c IN : stableIds]){
			coreIds.add(cdp.Id);
			if(stableIdAppIdListMap.containsKey(cdp.Stable__c)){
				String applicationSourceId = cdp.Stable__c;
				if(applicationSourceId.length() == 18){
					applicationSourceId = applicationSourceId.substring(0,15);
				}
				for(Id appId : stableIdAppIdListMap.get(cdp.Stable__c)){
					cdpAppsToInsert.add(new Core_Device_Package_Application__c(Core_Device_Package__c = cdp.Id, Application__c = appId, Source_Id__c = cdp.Stable__c, Source_Name__c = cdp.Stable__r.Name, Application_Source_Id__c = applicationSourceId));
				}
			}
		}
		
		/* add apps to Stable Devices */		
		List<DeviceApplicationAssoc__c> devAppsToInsert = new List<DeviceApplicationAssoc__c>();
		List<Blocked_Action__c> blockedActionsToInsert = new List<Blocked_Action__c>();
		for(Device__c d : [SELECT Id, Core_Device_Package__c, Core_Device_Package__r.Name, Core_Device_Package__r.Stable__c, Stable__c, Stable__r.Name, SWBOM_Reviewed_and_Approved__c FROM Device__c WHERE Stable__c IN : stableIdAppIdListMap.keySet()]){
			if(stableIdAppIdListMap.containsKey(d.Stable__c)){
				String applicationSourceId = d.Stable__c;
				if(applicationSourceId.length() == 18){
					applicationSourceId = applicationSourceId.substring(0,15);
				}		
				for(Id appId : stableIdAppIdListMap.get(d.Stable__c)){
					if(d.SWBOM_Reviewed_and_Approved__c == 'Yes'){
						// do not add apps to device, rather create Blocked Action records
						if(d.Core_Device_Package__c != null && d.Core_Device_Package__r.Stable__c == d.Stable__c){
							// source should be Core
							blockedActionsToInsert.add(new Blocked_Action__c(Action_Attempted__c = 'Insert', Application__c = appId, Application_Source_Id__c = applicationSourceId, Device__c = d.Id, Source_Id__c = d.Core_Device_Package__c, Source_Name__c = d.Core_Device_Package__r.Name));
						} else if((d.Core_Device_Package__c != null && d.Core_Device_Package__r.Stable__c != d.Stable__c) || (d.Core_Device_Package__c == null && d.Stable__c != null)){
							// source should be stable
							blockedActionsToInsert.add(new Blocked_Action__c(Action_Attempted__c = 'Insert', Application__c = appId, Application_Source_Id__c = applicationSourceId, Device__c = d.Id, Source_Id__c = d.Stable__c, Source_Name__c = d.Stable__r.Name));
						}
					} else {
						if(d.Core_Device_Package__c != null && d.Core_Device_Package__r.Stable__c == d.Stable__c){
							// source should be Core
							devAppsToInsert.add(new DeviceApplicationAssoc__c(Device__c = d.Id, Application__c = appId, Source_Id__c = d.Core_Device_Package__c, Source_Name__c = d.Core_Device_Package__r.Name, Application_Source_Id__c = applicationSourceId));
						} else if((d.Core_Device_Package__c != null && d.Core_Device_Package__r.Stable__c != d.Stable__c) || (d.Core_Device_Package__c == null && d.Stable__c != null)){
							// source should be stable
							devAppsToInsert.add(new DeviceApplicationAssoc__c(Device__c = d.Id, Application__c = appId, Source_Id__c = d.Stable__c, Source_Name__c = d.Stable__r.Name, Application_Source_Id__c = applicationSourceId));
						}
					}					
				}
			}
		}
		
		insert cdpAppsToInsert;
		insert devAppsToInsert;
		insert blockedActionsToInsert;
	}
	
	public static void checkSourceBeforeStableAppDelete(List<Stable_Application__c> oldList){
		for(Stable_Application__c sa : oldList){
			if(sa.Source_Id__c != null){
				sa.addError('You cannot delete this Application from this Stable because it was added via the Source');
			}
		}
	}
	
	public static void removeAppsFromStableParentsAndStableDevices(List<Id> appIds, List<Id> stableIds, List<String> applicationSourceIds){
		
		List<Id> coreIds = new List<Id>();
		for(Core_Device_Package__c cdp : [SELECT Id FROM Core_Device_Package__c WHERE Stable__c IN : stableIds]){
			coreIds.add(cdp.Id);
		}
		
		List<Core_Device_Package_Application__c> cdpAppsToDelete = [SELECT Id FROM Core_Device_Package_Application__c WHERE Core_Device_Package__c IN : coreIds AND Application__c IN : appIds AND Source_Id__c IN : stableIds AND Application_Source_Id__c IN : applicationSourceIds];
		for(Core_Device_Package_Application__c cdpa : cdpAppsToDelete){
			cdpa.Source_Id__c = null;
			cdpa.Source_Name__c = null;
		}
		
		List<Blocked_Action__c> blockedActionsToInsert = new List<Blocked_Action__c>();
		List<DeviceApplicationAssoc__c> devAppsToDelete = new List<DeviceApplicationAssoc__c>();		
		for(DeviceApplicationAssoc__c da : [SELECT Id, Device__c, Source_Id__c, Source_Name__c, Application__c, Device__r.SWBOM_Reviewed_and_Approved__c, Application_Source_Id__c FROM DeviceApplicationAssoc__c WHERE (Source_Id__c IN : stableIds OR Source_Id__c IN : coreIds) AND Application__c IN : appIds AND Application_Source_Id__c IN : applicationSourceIds]){
			if(da.Device__r.SWBOM_Reviewed_and_Approved__c == 'Yes'){
				blockedActionsToInsert.add(new Blocked_Action__c(Action_Attempted__c = 'Delete', Application__c = da.Application__c, Application_Source_Id__c = da.Application_Source_Id__c, Device__c = da.Device__c, Source_Id__c = da.Source_Id__c, Source_Name__c = da.Source_Name__c, Device_Application_if_delete__c = da.Id));
			} else {
				da.Source_Id__c = null;
				da.Source_Name__c = null;
				devAppsToDelete.add(da);
			}
		}
		
		update cdpAppsToDelete;
		delete cdpAppsToDelete;
		
		update devAppsToDelete;
		delete devAppsToDelete;
		
		insert blockedActionsToInsert;
	}
	
	private static testmethod void checkForApplictionContractTest(){
		Stable__c s = new Stable__c(Name='testStable');
		insert s;
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		
		Stable_Application__c sa = new Stable_Application__c(Stable__c = s.Id, Application__c = app.id, Stable_App_Status__c = 'Not Mandatory');
		try{
			insert sa;
		} catch(System.DmlException e){
			System.assert(e.getMessage().contains('You cannot add this Application to a Stable because it does have have a Governing Contract.'));
		}
	}
	
	private static testmethod void StableApplicationMethodsTest1(){
		Stable__c s = new Stable__c(Name='testStable');
		insert s;
		Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp', Stable__c = s.Id);
		insert cdp;
		Core_Device_Package__c cdp2 = new Core_Device_Package__c(Name='cdp', Stable__c = s.Id);
		insert cdp2;
		Device__c d = new Device__c(Name='testDevice', Stable__c=s.id, Core_Device_Package__c=cdp.Id);
		insert d;
		Device__c d2 = new Device__c(Name='testDevice2', Stable__c=s.id);
		insert d2;
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Application__c app2 = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app2;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app2.Id, Governing_End_Date__c=true);
		insert new List<ContApplAssoc__c>{ca, ca2};
		Stable_Application__c sa = new Stable_Application__c(Stable__c = s.Id, Application__c = app.id, Stable_App_Status__c = 'Not Mandatory');
		Stable_Application__c saDuplicate = new Stable_Application__c(Stable__c = s.Id, Application__c = app.id);
		Stable_Application__c sa2 = new Stable_Application__c(Stable__c = s.Id, Application__c = app2.id);
		
		Test.startTest();
			insert new List<Stable_Application__c>{sa, sa2};
			try{
				insert saDuplicate;
			} catch(System.DMLException e){
				System.assert(e.getMessage().contains('This Application is already attached to this Stable. Please select another Application or Stable'));
			}
			
			system.debug('UPDATE SA');
			sa2.Stable_App_Status__c = 'Mandatory';
			update sa2;
			
			List<DeviceApplicationAssoc__c> daList = [SELECT Id, Include_in_BOM__c FROM DeviceApplicationAssoc__c WHERE Device__c =: d.Id];
			for(DeviceApplicationAssoc__c da : daList){
				da.Include_in_BOM__c = false;
			}
			update daList;			

		Test.stopTest();
	}
	
	private static testmethod void StableApplicationMethodsTest2(){
		Stable__c s = new Stable__c(Name='testStable');
		insert s;
		Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp', Stable__c = s.Id);
		Core_Device_Package__c cdp2 = new Core_Device_Package__c(Name='cdp', Stable__c = s.Id);
		insert new List<Core_Device_Package__c>{cdp, cdp2};
		Device__c d = new Device__c(Name='testDevice', Stable__c=s.id, Core_Device_Package__c=cdp.Id);
		Device__c d2 = new Device__c(Name='testDevice2', Stable__c=s.id);
		insert new List<Device__c>{d, d2};
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		Application__c app2 = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert new List<Application__c>{app, app2};
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app2.Id, Governing_End_Date__c=true);
		insert new List<ContApplAssoc__c>{ca, ca2};
		Stable_Application__c sa = new Stable_Application__c(Stable__c = s.Id, Application__c = app.id, Stable_App_Status__c = 'Not Mandatory', Source_Id__c = app2.Id);
		Stable_Application__c sa2 = new Stable_Application__c(Stable__c = s.Id, Application__c = app2.id);
		
		Test.startTest();
			insert new List<Stable_Application__c>{sa, sa2};

			try{
				delete sa;
			}catch(System.DMLException e){
				System.assert(e.getMessage().contains('You cannot delete this Application from this Stable because it was added via the Source'));
			}
			sa.Source_Id__c = null;
			update sa;
			delete sa;
		Test.stopTest();
	}
	
	public static testmethod void normalizeStatusOfStableAppDuplicatesTest(){
		Program__c p1 = new Program__c(Name='testProgram1');
		Program__c p2 = new Program__c(Name='testProgram2');
		insert new List<Program__c>{p1, p2};
		Stable__c s = new Stable__c(Name='testStable');
		insert s;
		Stable_Program__c sp1 = new Stable_Program__c(Stable__c=s.Id, Program__c=p1.Id);
		Stable_Program__c sp2 = new Stable_Program__c(Stable__c=s.Id, Program__c=p2.Id);
		insert new List<Stable_Program__c>{sp1, sp2};
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Contract c = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		insert ca;
		Program_Application__c pa1 = new Program_Application__c(Program__c=p1.Id, Application__c=app.Id, Status__c = 'Optional');
		Program_Application__c pa2 = new Program_Application__c(Program__c=p2.Id, Application__c=app.Id, Status__c = 'Mandatory');
		insert new List<Program_Application__c>{pa1, pa2};
		
		Test.startTest();
			pa2.Status__c = 'Candidate';
			update pa2;
		Test.stopTest();		
	}
}