public with sharing class StableMethods {
	public static void checkNameChange(List<Stable__c> newList, List<Stable__c> oldList){
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Name != oldList[i].Name && UserInfo.getUserId() != newList[i].CreatedById){
				newList[i].addError('You cannot edit the name of this Stable.');
			}
		}
	}
	
	public static void calculateApplicationCostsFromStableIds(List<Id> stableIds){
		List<Stable__c> stableList = [SELECT Id, Application_Cost_Current__c, Application_Cost_High__c, Application_Cost_Low__c, Number_of_Apps_on_Stable__c FROM Stable__c WHERE Id IN : stableIds];
		Set<Id> appIds = new Set<Id>();
		
		List<Id> appIdsForCurrencyConversion = new List<Id>();
		List<Stable_Application__c> saList = [SELECT Stable__c, Application__c, Application_Type__c, Application__r.Royalty_Current__c, Application__r.Royalty_High__c, Application__r.Royalty_Low__c FROM Stable_Application__c WHERE Stable__c IN : stableIds];
		for(Stable_Application__c sa : saList){
			appIdsForCurrencyConversion.add(sa.Application__c);
		}		
		Map<Id, Application__c> appIdMap = ApplicationMethods.getCurrencyConvertedApplicationMap(appIdsForCurrencyConversion);
		
		for(Stable__c s : stableList){
			s.Application_Cost_Current__c = 0;
			s.Application_Cost_High__c = 0;
			s.Application_Cost_Low__c = 0;
			s.Current_Royalty_Cost_of_Embedded_Apps__c = 0;
			s.Current_Royalty_Cost_of_IP_Apps__c = 0;
			s.Current_Royalty_Cost_of_Preload_Apps__c = 0;
			s.Current_Royalty_Cost_of_Services_Apps__c = 0;
			s.Number_of_Apps_on_Stable__c = 0;
			appIds = new Set<Id>();
			
			for(Stable_Application__c sa : saList){
				if(s.Id == sa.Stable__c && !appIds.contains(sa.Application__c)){
					if(appIdMap.get(sa.Application__c).Royalty_Current__c != null){ 
						s.Application_Cost_Current__c = s.Application_Cost_Current__c + appIdMap.get(sa.Application__c).Royalty_Current__c;
						
						if(sa.Application_Type__c == 'Embedded') { s.Current_Royalty_Cost_of_Embedded_Apps__c = s.Current_Royalty_Cost_of_Embedded_Apps__c + appIdMap.get(sa.Application__c).Royalty_Current__c; }
						else if(sa.Application_Type__c == 'IP Settlement') { s.Current_Royalty_Cost_of_IP_Apps__c = s.Current_Royalty_Cost_of_IP_Apps__c + appIdMap.get(sa.Application__c).Royalty_Current__c; }
						else if(sa.Application_Type__c == 'Preload') { s.Current_Royalty_Cost_of_Preload_Apps__c = s.Current_Royalty_Cost_of_Preload_Apps__c + appIdMap.get(sa.Application__c).Royalty_Current__c; }
						else if(sa.Application_Type__c == 'Services') { s.Current_Royalty_Cost_of_Services_Apps__c = s.Current_Royalty_Cost_of_Services_Apps__c + appIdMap.get(sa.Application__c).Royalty_Current__c; }
					}
					if(appIdMap.get(sa.Application__c).Royalty_High__c != null){ s.Application_Cost_High__c = s.Application_Cost_High__c + appIdMap.get(sa.Application__c).Royalty_High__c; }
					if(appIdMap.get(sa.Application__c).Royalty_Low__c != null){ s.Application_Cost_Low__c = s.Application_Cost_Low__c + appIdMap.get(sa.Application__c).Royalty_Low__c; }
					s.Number_of_Apps_on_Stable__c = s.Number_of_Apps_on_Stable__c + 1;
					appIds.add(sa.Application__c);
				}
			}
		}
		
		update stableList;
	}
	
	public static void calculateApplicationCostsFromAppIds(List<Id> appIds){		
		List<Stable_Application__c> saList = [SELECT Stable__c, Application__c, Application_Type__c, Application__r.Royalty_Current__c, Application__r.Royalty_High__c, Application__r.Royalty_Low__c FROM Stable_Application__c WHERE Application__c IN : appIds];
		List<Stable__c> stablesToUpdate = new List<Stable__c>();
		
		Set<Id> stableIds = new Set<Id>();
		List<Id> appIdsForCurrencyConversion = new List<Id>();
		for(Stable_Application__c sa : saList){
			stableIds.add(sa.Stable__c);
			appIdsForCurrencyConversion.add(sa.Application__c);
		}
		
		Map<Id, Application__c> appIdMap = ApplicationMethods.getCurrencyConvertedApplicationMap(appIdsForCurrencyConversion);
				
		Decimal Current;
		Decimal High;
		Decimal Low;
		Decimal Embedded;
		Decimal IP;
		Decimal Preload;
		Decimal Services;
		Integer Number_of_Apps_on_Stable;
		Set<Id> appIdsToCheckDuplicates = new Set<Id>();
		
		for(Id sId : stableIds){
			Current = 0;
			High = 0;
			Low = 0;
			Embedded = 0;
			IP = 0;
			Preload = 0;
			Services = 0;
			Number_of_Apps_on_Stable = 0;
			appIdsToCheckDuplicates = new Set<Id>();
			
			for(Stable_Application__c sa : saList){
				if(sId == sa.Stable__c && !appIdsToCheckDuplicates.contains(sa.Application__c)){
					if(appIdMap.get(sa.Application__c).Royalty_Current__c != null){ 
						Current = Current + appIdMap.get(sa.Application__c).Royalty_Current__c;
						
						if(sa.Application_Type__c == 'Embedded') { Embedded = Embedded + appIdMap.get(sa.Application__c).Royalty_Current__c; }
						else if(sa.Application_Type__c == 'IP Settlement') { IP = IP + appIdMap.get(sa.Application__c).Royalty_Current__c; }
						else if(sa.Application_Type__c == 'Preload') { Preload = Preload + appIdMap.get(sa.Application__c).Royalty_Current__c; }
						else if(sa.Application_Type__c == 'Services') { Services = Services + appIdMap.get(sa.Application__c).Royalty_Current__c; }
					}
					if(appIdMap.get(sa.Application__c).Royalty_High__c != null){ High = High + appIdMap.get(sa.Application__c).Royalty_High__c; }
					if(appIdMap.get(sa.Application__c).Royalty_Low__c != null){ Low = Low + appIdMap.get(sa.Application__c).Royalty_Low__c; }
					Number_of_Apps_on_Stable = Number_of_Apps_on_Stable + 1;
					appIdsToCheckDuplicates.add(sa.Application__c);
				}
			}
			
			stablesToUpdate.add(new Stable__c(Id = sId, Application_Cost_Current__c = Current, Current_Royalty_Cost_of_Embedded_Apps__c = Embedded, Current_Royalty_Cost_of_IP_Apps__c = IP, Current_Royalty_Cost_of_Preload_Apps__c = Preload, Current_Royalty_Cost_of_Services_Apps__c = Services, Application_Cost_High__c = High, Application_Cost_Low__c = Low, Number_of_Apps_on_Stable__c = Number_of_Apps_on_Stable));
		}
		
		update stablesToUpdate;
	}
	
	public static testmethod void stableMethodsTest(){
		Stable__c s = new Stable__c(Name='testStable');
		insert s;
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Contract c = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		insert ca;
		Stable_Application__c sa = new Stable_Application__c(Stable__c = s.Id, Application__c = app.id, Stable_App_Status__c = 'Not Mandatory');
		User u = [SELECT Id FROM User WHERE isActive = true AND Id !=: UserInfo.getUserId() LIMIT 1];
		Test.startTest();
			System.runAs(u){
				s.Name = 'newName';
				try{
					update s;
				} catch(System.DMLException e){
					System.assert(e.getMessage().contains('You cannot edit the name of this Stable.'));
				}
			}
		
			insert sa;
			
			app.Royalty_Low__c = .03;
			update app;
			
			delete sa;
		Test.stopTest();
	}
}