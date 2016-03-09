public with sharing class ProgramApplicationInsertMethods {
	public static void checkProgramStatusAndDuplicates(List<Program_Application__c> newList, Map<Id, Program__c> programMap, Map<String, Program_Application__c> existingProgramAppMap){
		Profile adminProfile = [SELECT Id FROM Profile WHERE Name = 'MotoDev - SysAdmin'];
		for(Program_Application__c pa : newList){
			if((UserInfo.getProfileId() != adminProfile.Id) && programMap.containsKey(pa.Program__c) && programMap.get(pa.Program__c).Reviewed_Approved__c == 'Yes'){
				pa.addError('You cannot add new Applications to this Program because it has been Reviewed and Approved.');
			}
			
	        if(existingProgramAppMap.containsKey(pa.Program__c + '' + pa.Application__c)){
	        	pa.addError('This application is already attached to this Program. Please select another Application.');
	        }			
		}		
	}
	
	public static void checkForApplictionContract(List<Program_Application__c> newList, List<Id> appIds){
		Map<Id, ContApplAssoc__c> appIdContractAppMap = new Map<Id, ContApplAssoc__c>();
		for(ContApplAssoc__c ca : [SELECT Id, Application__c FROM ContApplAssoc__c WHERE Application__c IN : appIds AND Governing_End_Date__c = true]){
			appIdContractAppMap.put(ca.Application__c, ca);
		}
		
		for(Program_Application__c pa : newList){
			if(!appIdContractAppMap.containsKey(pa.Application__c)){
				pa.addError('You cannot add this Application to a Program because it does have have a Governing Contract.');
			}
		}
	}

	public static void fillInApplicationDescriptionAndInstructions(List<Program_Application__c> newList, Map<Id, Application__c> appMap){
		for(Program_Application__c pa : newList){
			pa.Application_Description__c = appMap.get(pa.Application__c).Description__c;
			pa.Application_Instructions__c = appMap.get(pa.Application__c).Application_Instructions__c;
		}
	}
	
	public static void populateApplicationCost(List<Program_Application__c> newList, List<Id> appIds){		
		Map<Id, Application__c> appIdMap = ApplicationMethods.getCurrencyConvertedApplicationMap(appIds);
		
		for(Program_Application__c pa : newList){
			pa.Application_Cost_Current__c = appIdMap.get(pa.Application__c).Royalty_Current__c;
			pa.Application_Cost_High__c = appIdMap.get(pa.Application__c).Royalty_High__c;
			pa.Application_Cost_Low__c = appIdMap.get(pa.Application__c).Royalty_Low__c;
		}				
	}
	
	public static void addAppToProgramParentsAndProgramDevices(Map<Id, List<Id>> programIdAppIdListMap, Map<String, String> programAppIdStatusMap, List<Id> programIds){
		
		/* add Apps To Stables that use these programs */
		List<Stable_Application__c> stableAppsToInsert = new List<Stable_Application__c>();
		for(Stable_Program__c sp : [SELECT Stable__c, Program__c, Program__r.Name FROM Stable_Program__c WHERE Program__c IN : programIds]){
			if(programIdAppIdListMap.containsKey(sp.Program__c)){
				String applicationSourceId = sp.Program__c;
				if(applicationSourceId.length() == 18){
					applicationSourceId = applicationSourceId.substring(0,15);
				}
				for(Id appId : programIdAppIdListMap.get(sp.Program__c)){
					stableAppsToInsert.add(new Stable_Application__c(Stable__c = sp.Stable__c, Application__c = appId, Source_Id__c = sp.Program__c, Source_Name__c = sp.Program__r.Name, Stable_App_Status__c = programAppIdStatusMap.get(sp.Program__c + '' + appId), Application_Source_Id__c = applicationSourceId));
				}
			}
		}
		
		/* = */
		List<Core_Device_Package_Application__c> cdpAppsToInsert = new List<Core_Device_Package_Application__c>();
		for(Core_Device_Package_Program__c cdpp : [SELECT Core_Device_Package__c, Program__c, Program__r.Name, Source_Id__c, Source_Name__c FROM Core_Device_Package_Program__c WHERE Program__c IN : programIds]){
			if(programIdAppIdListMap.containsKey(cdpp.Program__c)){
				String applicationSourceId = cdpp.Program__c;
				if(applicationSourceId.length() == 18){
					applicationSourceId = applicationSourceId.substring(0,15);
				}
				for(Id appId : programIdAppIdListMap.get(cdpp.Program__c)){
					if(cdpp.Source_Id__c != null){
						cdpAppsToInsert.add(new Core_Device_Package_Application__c(Core_Device_Package__c = cdpp.Core_Device_Package__c, Application__c = appId, Source_Id__c = cdpp.Source_Id__c, Source_Name__c = cdpp.Source_Name__c, Application_Source_Id__c = applicationSourceId));
					} else {
						cdpAppsToInsert.add(new Core_Device_Package_Application__c(Core_Device_Package__c = cdpp.Core_Device_Package__c, Application__c = appId, Source_Id__c = cdpp.Program__c, Source_Name__c = cdpp.Program__r.Name, Application_Source_Id__c = applicationSourceId));
					}
				}
			}
		}
		
		/* add Apps to Devices that use any of these: Program through Stable; Program through Stable through Core; Program through Core */
		List<DeviceApplicationAssoc__c> devAppsToInsert = new List<DeviceApplicationAssoc__c>();
		
		Map<Id, String> devicesThatAreSWBOMApproved = new Map<Id, String>();
		List<Blocked_Action__c> blockedActionsToInsert = new List<Blocked_Action__c>();
		for(Program_Device__c pd : [SELECT Id, Program__c,Program__r.Name, Device__c, Device__r.SWBOM_Reviewed_and_Approved__c, Device__r.Name, Source_Id__c, Source_Name__c FROM Program_Device__c WHERE Program__c IN : programIdAppIdListMap.keySet()]){
			if(pd.Device__r.SWBOM_Reviewed_and_Approved__c == 'Yes'){
				system.debug('THIS DEVICE IS R&A');
				// cannot add apps to this device since it is reviewed & approved
				if(programIdAppIdListMap.containsKey(pd.Program__c)){
					String applicationSourceId = pd.Program__c;
					if(applicationSourceId.length() == 18){
						applicationSourceId = applicationSourceId.substring(0,15);
					}
					for(Id appId : programIdAppIdListMap.get(pd.Program__c)){
						if(pd.Source_Id__c != null){
							blockedActionsToInsert.add(new Blocked_Action__c(Action_Attempted__c = 'Insert', Application__c = appId, Application_Source_Id__c = applicationSourceId, Device__c = pd.Device__c, Source_Id__c = pd.Source_Id__c, Source_Name__c = pd.Source_Name__c));
						} else {
							blockedActionsToInsert.add(new Blocked_Action__c(Action_Attempted__c = 'Insert', Application__c = appId, Application_Source_Id__c = applicationSourceId, Device__c = pd.Device__c, Source_Id__c = pd.Program__c, Source_Name__c = pd.Program__r.Name));
						}
					}
				}
			} else {
				if(programIdAppIdListMap.containsKey(pd.Program__c)){
					String applicationSourceId = pd.Program__c;
					if(applicationSourceId.length() == 18){
						applicationSourceId = applicationSourceId.substring(0,15);
					}
					for(Id appId : programIdAppIdListMap.get(pd.Program__c)){
						String approvalStatus;
						if(programAppIdStatusMap.get(pd.Program__c + '' + appId) == 'Candidate'){
							approvalStatus = 'Not Submitable';
						} else {
							approvalStatus = 'Not Submitted';
						}
						
						if(pd.Source_Id__c != null){
							devAppsToInsert.add(new DeviceApplicationAssoc__c(Device__c = pd.Device__c, Application__c = appId, Include_in_BOM__c = true, Approval_Status__c = approvalStatus, Source_Id__c = pd.Source_Id__c, Source_Name__c = pd.Source_Name__c, Application_Source_Id__c = applicationSourceId));
						} else {
							devAppsToInsert.add(new DeviceApplicationAssoc__c(Device__c = pd.Device__c, Application__c = appId, Include_in_BOM__c = true, Approval_Status__c = approvalStatus, Source_Id__c = pd.Program__c, Source_Name__c = pd.Program__r.Name, Application_Source_Id__c = applicationSourceId));
						}
					}
				}
			}
		}
		
		system.debug('BLOCKED ACTIONS TO INSERT: ' + blockedActionsToInsert);
		
		insert stableAppsToInsert;
		insert cdpAppsToInsert;
		insert devAppsToInsert;
		insert blockedActionsToInsert;

	}
	/*
	private static testmethod void checkForDuplicatesANDcheckProgramBeforeDeleteProgramApplicationsTest(){
		system.debug('TESTING');
		Program__c p = new Program__c(Name='testProgram', Reviewed_Approved__c = 'No');
		insert p;
		Program__c p2 = new Program__c(Name='testProgram', Reviewed_Approved__c = 'No');
		insert p2;

		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		insert ca1;
		
		Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=app.Id, Status__c = 'Optional');
		insert pa;
		Program_Application__c paDuplicate = new Program_Application__c(Program__c=p.Id, Application__c=app.Id);
		
		Profile prof = [select id from profile where name='Standard User'];
		User nonAdminUser = new User(	alias = 'standt', email='nonAdminUser@test.com',
							emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
							localesidkey='en_US', profileid = prof.Id,
							timezonesidkey='Australia/Darwin', username='nonAdminUser@test.com');
    	insert nonAdminUser;
    	
		Test.startTest();
			System.runAs(nonAdminUser){
				try{			
					insert paDuplicate;
				} catch(System.DMLException e){
					System.assert(e.getMessage().contains('This application is already attached to this Program. Please select another Application.'));
				}
			}
			List<Program_Application__c> progapps = [SELECT Id, Status__c FROM Program_Application__c WHERE Program__c =: p.Id];
			for(Program_Application__c progapp : progapps){
				progapp.Status__c = 'Mandatory';
			}
			update progapps;
			
			p.Reviewed_Approved__c = 'Yes';
			update p;
			
			for(Program_Application__c progapp : [SELECT Id, Status__c, Application__c FROM Program_Application__c WHERE Program__c =: p.Id]){
				system.debug('THIS IS PROGAPP app / status: ' + progapp.Application__c + ' / ' + progapp.Status__c);
			}
			
			// test for checkProgramBeforeDeleteProgramApplications			
			try{
				delete pa;
			} catch(System.DMLException e){
				system.debug('CATCH');
				System.assert(e.getMessage().contains('Cannot remove Application from Program because Program has been Reviewed and Approved'));
			}
			
			p.Reviewed_Approved__c = 'No';
			update p;
			system.debug('BEFORE DELETE PA');
			delete pa;
			
		Test.stopTest();
	}*/
	
	private static testmethod void checkProgramStatusTest(){
		Program__c p = new Program__c(Name='testProgram', Reviewed_Approved__c = 'Yes');
		insert p;
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		insert ca1;
		
		Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=app.Id);
		User u = [SELECT Id FROM User WHERE IsActive=true AND profileId != : [SELECT Id FROM Profile WHERE Name = 'MotoDev - SysAdmin'].Id LIMIT 1];
		
		Test.startTest();
			try{
				System.runAs(u){
					insert pa;
				}
			} catch(System.DMLException e){
				System.assert(e.getMessage().contains('You cannot add new Applications to this Program because it has been Reviewed and Approved.'));
			}
		Test.stopTest();
	}
	
	private static testmethod void addAppToProgramDevicesTest(){
		Program__c p = new Program__c(Name='testProgram');
		insert p;
		Program__c p2 = new Program__c(Name='testProgram2');
		insert p2;
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
		
		Device__c d = new Device__c(Name='testDevice');
		insert d;
		Device__c d2 = new Device__c(Name='testDevice2');
		insert d2;
		
		DeviceApplicationAssoc__c da = new DeviceApplicationAssoc__c(Device__c=d.Id, Application__c=app.Id);
		insert da;
		
		Program_Device__c pd = new Program_Device__c(Program__c=p.id, Device__c=d.Id);
		insert pd;
		Program_Device__c pd2 = new Program_Device__c(Program__c=p.id, Device__c=d2.Id);
		insert pd2;
		Program_Device__c pd3 = new Program_Device__c(Program__c=p2.id, Device__c=d.Id);
		insert pd3;
		Program_Device__c pd4 = new Program_Device__c(Program__c=p2.id, Device__c=d2.Id, Source_Id__c=p2.Id);
		insert pd4;
				
		Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=app.Id, Status__c='Optional');
		Program_Application__c pa2 = new Program_Application__c(Program__c=p2.Id, Application__c=app.Id);
		Program_Application__c pa3 = new Program_Application__c(Program__c=p2.Id, Application__c=app2.Id);
		
		Test.startTest();
			insert new List<Program_Application__c>{pa,pa2,pa3};
			pa.Status__c = 'Candidate';
			update pa;
			pa2.Status__c = 'Optional';
			update pa2;
		Test.stopTest();
	}
	
	
	
	private static testmethod void checkForApplictionContractTest(){
		Program__c p = new Program__c(Name='testProgram');
		insert p;
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;

		Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=app.Id, Status__c = 'Optional');
		try{
			insert pa;
		} catch(System.DmlException e){
			system.debug(e.getMessage());
			System.assert(e.getMessage().contains('You cannot add this Application to a Program because it does have have a Governing Contract.'));
		}
	}	
}