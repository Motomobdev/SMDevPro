public with sharing class ProgramApplicationDeleteMethods { 
	public static Set<Program_Application__c> checkProgramBeforeDeleteProgramApplications(List<Program_Application__c> oldList){
		List<Id> programIds = new List<Id>();
		List<Id> appIds = new List<Id>();
		Set<Program_Application__c> finalSet = new Set<Program_Application__c>(oldList);
		for(Program_Application__c pa : oldList){
			programIds.add(pa.Program__c);
			appIds.add(pa.Application__c);
		}
		
		for(Program__c p : [SELECT Id, Reviewed_Approved__c FROM Program__c WHERE Id IN : programIds AND Reviewed_Approved__c = 'Yes']){
			for(Program_Application__c pa : oldList){
				if(pa.Program__c == p.Id){
					finalSet.remove(pa);
					pa.addError('Cannot remove Application from Program because Program has been Reviewed and Approved');
				}
			}
		}
		
		return finalSet;
	}
	
	public static void removeAppsFromProgramDevices(Set<Program_Application__c> oldList, List<Id> programIds, List<Id> appIds, List<String> applicationSourceIds){		
		system.debug('THIS IS APPLICATIONSOURCEIDS: ' + applicationSourceIds);
		system.debug('THIS IS programIds: ' + programIds);
		system.debug('THIS IS appIds: ' + appIds);
		// create a map of application Id to the owner of the program that app was on
		Map<Id, Id> appIdProgramOwnerId = new Map<Id, Id>();
		for(Program__c p : [SELECT Id, OwnerId FROM Program__c WHERE Id IN : programIds]){
			for(Program_Application__c pa : oldList){
				if(p.Id == pa.Program__c){
					appIdProgramOwnerId.put(pa.Application__c, p.OwnerId);
				}
			}
		}
		
		// Find and delete devapps that were added because App was on Program
		List<DeviceApplicationAssoc__c> devAppsToDeleteInitial = [SELECT Id, Name, Device__c, Device__r.Name, Source_Id__c, Source_Name__c, CreatedById, Application__c, Application__r.Name, Device__r.SWBOM_Reviewed_and_Approved__c, Device__r.SW_BOM_List_Approver__c, Application_Source_Id__c, Include_in_BOM__c FROM DeviceApplicationAssoc__c WHERE Application__c IN : appids AND Application_Source_Id__c IN : applicationSourceIds];
		List<DeviceApplicationAssoc__c> devAppsToDeleteFinal = new List<DeviceApplicationAssoc__c>();
		List<Blocked_Action__c> blockedActionsToInsert = new List<Blocked_Action__c>();
		//List<DeviceApplicationAssoc__c> devAppsWhoseDevicesAreApproved = new List<DeviceApplicationAssoc__c>();
		
		for(DeviceApplicationAssoc__c da : devAppsToDeleteInitial){
			system.debug('DEVICE SW BOM: ' + da.Device__r.SWBOM_Reviewed_and_Approved__c);
			if(da.Device__r.SWBOM_Reviewed_and_Approved__c == 'Yes'){
				//devAppsWhoseDevicesAreApproved.add(da);
				blockedActionsToInsert.add(new Blocked_Action__c(Action_Attempted__c = 'Delete', Application__c = da.Application__c, Application_Source_Id__c = da.Application_Source_Id__c, Device__c = da.Device__c, Source_Id__c = da.Source_Id__c, Source_Name__c = da.Source_Name__c, Device_Application_if_delete__c = da.Id));
			} else {
				da.Source_Id__c = null;
				da.Source_Name__c = null;
				devAppsToDeleteFinal.add(da);
			}
		}		
		
		update devAppsToDeleteFinal;
		delete devAppsToDeleteFinal;
		insert blockedActionsToInsert;
	}
	
	public static void removeAppsFromProgramParents(Set<Program_Application__c> oldList, List<Id> programIds, List<Id> appIds, List<String> applicationSourceIds){		
		
		List<Id> stableIds = new List<Id>();
		for(Stable_Program__c sp : [SELECT Stable__c, Program__c FROM Stable_Program__c WHERE Program__c IN : programIds]){
			stableIds.add(sp.Stable__c);
		}
		
		List<Stable_Application__c> stableAppsToDelete = [SELECT Id, Source_Id__c FROM Stable_Application__c WHERE Stable__c IN : stableIds AND Application__c IN : appIds AND Source_Id__c IN : programIds AND Application_Source_Id__c IN : applicationSourceIds];
		for(Stable_Application__c sa : stableAppsToDelete){
			sa.Source_Id__c = null;
			sa.Source_Name__c = null;
		}
					
		List<Id> coreIds = new List<Id>();
		List<Core_Device_Package_Application__c> cdpAppsToDelete = [SELECT Id, Application__c, Source_Id__c, Source_Name__c, Application_Source_Id__c FROM Core_Device_Package_Application__c WHERE Application__c IN : appIds AND (Source_Id__c IN : stableIds OR Source_Id__c IN : programIds) AND Application_Source_Id__c IN : applicationSourceIds];
		for(Core_Device_Package_Application__c cdpa : cdpAppsToDelete){
			cdpa.Source_Id__c = null;
			cdpa.Source_Name__c = null;
		}
		
		update stableAppsToDelete;
		delete stableAppsToDelete;
		
		update cdpAppsToDelete;
		delete cdpAppsToDelete;
	}	
	
	private static testmethod void removeAppsFromProgramDevicesTest(){
		Program__c p = new Program__c(Name='testProgram');
		insert p;
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		insert ca;
		Device__c d = new Device__c(Name='testDevice');
		insert d;
		Program_Device__c pd = new Program_Device__c(Program__c=p.id, Device__c=d.Id);
		insert pd;
		Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=app.Id, Status__c = 'Optional');
		insert pa;
		DeviceApplicationAssoc__c da = new DeviceApplicationAssoc__c(Device__c=d.Id, Application__c=app.Id, Include_In_BOM__c=false);
		insert da;

		Device__c reviewedDevice = new Device__c(Name='testDevice');
		insert reviewedDevice;
		Program_Device__c pd2 = new Program_Device__c(Program__c=p.id, Device__c=reviewedDevice.Id);
		insert pd2;
		
		p.Reviewed_Approved__c = 'Yes';
		update p;
		
		DeviceApplicationAssoc__c da2 = [SELECT Id, Approval_Status__c, Source_Id__c FROM DeviceApplicationAssoc__c WHERE Device__c =: reviewedDevice.Id AND Application__c =: app.Id];
		system.debug('THIS IS DA2 source / program Id' + da2.Source_Id__c + ' / ' + p.Id);
		da2.Approval_Status__c = 'Approved';
		update da2;
		reviewedDevice.SWBOM_Reviewed_and_Approved__c = 'Yes';
		reviewedDevice.SW_BOM_List_Approver__c = UserInfo.getUserId();
		update reviewedDevice;
		
		p.Reviewed_Approved__c = 'No';
		update p;
		
		Test.startTest();
			//System.assertEquals(2, [SELECT count() FROM DeviceApplicationAssoc__c WHERE Device__c=:d.Id AND Application__c=:app.Id]);
			delete pa;		
						
			
		Test.stopTest();
	}		
}