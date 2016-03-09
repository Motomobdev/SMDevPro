public with sharing class ApplicationCountryMethods {
	public static void setLegallyShippableCountriesOnApplication(Set<Id> appIds){
		Map<Id, List<Application_Country__c>> appIdCountyListMap = new Map<Id, List<Application_Country__c>>();
		Map<Id, List<ContApplAssoc__c>> appIdContractAppListMap = new Map<Id, List<ContApplAssoc__c>>(); 
		
		for(Application_Country__c ac : [SELECT Application__c, Country__c, Country__r.Country_Code__c FROM Application_Country__c WHERE Application__c IN : appIds AND Relationship__c = 'Legal']){
			List<Application_Country__c> tempList = appIdCountyListMap.get(ac.Application__c);
			if(tempList == null){
				tempList = new List<Application_Country__c>{ac};
			} else {
				tempList.add(ac);
			}
			appIdCountyListMap.put(ac.Application__c, tempList);
		}
		
		for(ContApplAssoc__c ca : [SELECT Id, Application__c, Legally_Shippable__c FROM ContApplAssoc__c WHERE Application__c IN : appIds]){
			List<ContApplAssoc__c> tempList = appIdContractAppListMap.get(ca.Application__c);
			if(tempList == null){
				tempList = new List<ContApplAssoc__c>{ca};
			} else {
				tempList.add(ca);
			}
			appIdContractAppListMap.put(ca.Application__c, tempList);
		}
				
		String legallyShippableCountries = '';
		
		List<Application__c> appsToUpdate = new List<Application__c>();
		List<ContApplAssoc__c> conAppsToUpdate = new List<ContApplAssoc__c>();
		
		for(Id appId : appIds){
			legallyShippableCountries = '';
			
			if(appIdCountyListMap.get(appId) != null){
				for(Application_Country__c ac : appIdCountyListMap.get(appId)){
					if(ac.Country__r.Country_Code__c != null && ac.Country__r.Country_Code__c != ''){
						if(legallyShippableCountries == ''){
							legallyShippableCountries = ac.Country__r.Country_Code__c;
						} else {
							legallyShippableCountries = legallyShippableCountries + ', ' + ac.Country__r.Country_Code__c;
						} 
					}
				}
			}
			appsToUpdate.add(new Application__c(Id=appId, Legally_Shippable__c=legallyShippableCountries));
			
			if(appIdContractAppListMap.get(appId) != null){
				for(ContApplAssoc__c ca : appIdContractAppListMap.get(appId)){
					ca.Legally_Shippable__c = legallyShippableCountries;
					conAppsToUpdate.add(ca);
				}
			}
			
		}
		
		update appsToUpdate;		
		update conAppsToUpdate;
	}
	
	public static void setApplicationCountriesCondensedListsOnApp(Set<Id> appIds){
		Map<Id, String> availableCountriesMap = setApplicationAvailableCountriesCondensedListOnApp(appIds);
		Map<Id, String> legalCountriesMap = setApplicationLegalCountriesCondensedListOnApp(appIds);
		
		List<ContApplAssoc__c> conAppsToUpdate = [SELECT Id, Application__c, Contract__c, Application_Available_Countries_Condense__c, Application_Legal_Countries_Condensed__c FROM ContApplAssoc__c WHERE Application__c IN : availableCountriesMap.keySet()];
		for(ContApplAssoc__c ca : conAppsToUpdate){
			ca.Application_Available_Countries_Condense__c = availableCountriesMap.get(ca.Application__c);
			ca.Application_Legal_Countries_Condensed__c = legalCountriesMap.get(ca.Application__c);
		}
		
		update conAppsToUpdate;
	}
	
	private static Map<Id, String> setApplicationAvailableCountriesCondensedListOnApp(Set<Id> appIds){
		Map<Id, Country__c> allCountries = new Map<Id, Country__c>([SELECT Id, Name, Country_Code__c FROM Country__c WHERE Region__c != null AND Region__c != '']);
		Map<Id, Set<Id>> appIdIncludesCountryListMap = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> appIdExcludesCountryListMap = new Map<Id, Set<Id>>();
		Map<Id, String> appsToUpdate = new Map<Id, String>();
		
		for(Application_Country__c ac : [SELECT Application__c, Country__c, Country__r.Name FROM Application_Country__c WHERE Application__c IN : appIds AND Relationship__c = 'Available']){
			Set<Id> tempList = appIdIncludesCountryListMap.get(ac.Application__c);
			if(tempList == null){
				tempList = new Set<Id>{ac.Country__c};
			} else {
				tempList.add(ac.Country__c);
			}
			appIdIncludesCountryListMap.put(ac.Application__c, tempList);
			system.debug('LIST OF Included COUNTRYIDS FOR APP: ' + ac.Application__c + ' - ' + tempList);
		}
		
		for(Id appId : appIds){
			Set<Id> tempList = new Set<Id>();
			
			for(Id countryId : allCountries.keySet()){
				if(appIdIncludesCountryListMap.get(appId) == null || !appIdIncludesCountryListMap.get(appId).contains(countryId)){
					tempList.add(countryId);
				}
			}	
			appIdExcludesCountryListMap.put(appid, tempList);
			system.debug('LIST OF Excluded COUNTRYIDS FOR APP: ' + appId + ' - ' + tempList);
		}
		
		for(Id appId : appIds){
			// number Of Included Countries = appIdIncludesCountryListMap.get(appId).size();
			// number Of Excluded Countries = appIdExcludesCountryListMap.get(appId).size();
			
			String condensedField = null;
			
			if(appIdIncludesCountryListMap.get(appId) == null || appIdIncludesCountryListMap.get(appId).size() == 0){
				condensedField = 'No Available countries selected.';
				system.debug('No Available countries selected.');
			} else if(appIdExcludesCountryListMap.get(appId) == null || appIdExcludesCountryListMap.get(appId).size() == 0){
				condensedField = 'Global';
				system.debug('Global');
			} else if(appIdIncludesCountryListMap.get(appId).size() <= appIdExcludesCountryListMap.get(appId).size()){
				// set condensed field to "Includes:...."				
				for(Id countryId : appIdIncludesCountryListMap.get(appId)){
					system.debug('COUNTRY ID: ' + countryId);
					system.debug('COUNTRY Name: ' + allCountries.get(countryId).Name);
					if(condensedField == null){
						condensedField = 'Includes: ' + allCountries.get(countryId).Name;
					} else {
						condensedField = condensedField + ', ' + allCountries.get(countryId).Name;
					}
				}
				system.debug('LIST OF Included COUNTRYCODES FOR APP: ' + appId + ' - ' + condensedField);
			} else if(appIdExcludesCountryListMap.get(appId).size() < appIdIncludesCountryListMap.get(appId).size()){
				// set condensed field to "Excludes:..."
				for(Id countryId : appIdExcludesCountryListMap.get(appId)){
					if(condensedField == null){
						condensedField = 'Excludes: ' + allCountries.get(countryId).Name;
					} else {
						condensedField = condensedField + ', ' + allCountries.get(countryId).Name;
					}
				}
				system.debug('LIST OF Excluded COUNTRYCODES FOR APP: ' + appId + ' - ' + condensedField);
			}
			
			appsToUpdate.put(appId, condensedField);
		}
		
		return appsToUpdate;

	}
	
	private static Map<Id, String> setApplicationLegalCountriesCondensedListOnApp(Set<Id> appIds){
		Map<Id, Country__c> allCountries = new Map<Id, Country__c>([SELECT Id, Name, Country_Code__c FROM Country__c WHERE Region__c != null AND Region__c != '']);
		Map<Id, Set<Id>> appIdIncludesCountryListMap = new Map<Id, Set<Id>>();
		Map<Id, Set<Id>> appIdExcludesCountryListMap = new Map<Id, Set<Id>>();
		Map<Id, String> appsToUpdate = new Map<Id, String>();
		
		for(Application_Country__c ac : [SELECT Application__c, Country__c, Country__r.Name FROM Application_Country__c WHERE Application__c IN : appIds AND Relationship__c = 'Legal']){
			Set<Id> tempList = appIdIncludesCountryListMap.get(ac.Application__c);
			if(tempList == null){
				tempList = new Set<Id>{ac.Country__c};
			} else {
				tempList.add(ac.Country__c);
			}
			appIdIncludesCountryListMap.put(ac.Application__c, tempList);
			system.debug('LIST OF Included COUNTRYIDS FOR APP: ' + ac.Application__c + ' - ' + tempList);
		}
		
		for(Id appId : appIds){
			Set<Id> tempList = new Set<Id>();
			
			for(Id countryId : allCountries.keySet()){
				if(appIdIncludesCountryListMap.get(appId) == null || !appIdIncludesCountryListMap.get(appId).contains(countryId)){
					tempList.add(countryId);
				}
			}	
			appIdExcludesCountryListMap.put(appid, tempList);
			system.debug('LIST OF Excluded COUNTRYIDS FOR APP: ' + appId + ' - ' + tempList);
		}
		
		for(Id appId : appIds){
			// number Of Included Countries = appIdIncludesCountryListMap.get(appId).size();
			// number Of Excluded Countries = appIdExcludesCountryListMap.get(appId).size();
			
			String condensedField = null;
			
			if(appIdIncludesCountryListMap.get(appId) == null || appIdIncludesCountryListMap.get(appId).size() == 0){
				condensedField = 'No legal countries selected.';
				system.debug('No legal countries selected.');
			} else if(appIdExcludesCountryListMap.get(appId) == null || appIdExcludesCountryListMap.get(appId).size() == 0){
				condensedField = 'Global';
				system.debug('Global');
			} else if(appIdIncludesCountryListMap.get(appId).size() <= appIdExcludesCountryListMap.get(appId).size()){
				// set condensed field to "Includes:...."				
				for(Id countryId : appIdIncludesCountryListMap.get(appId)){
					if(condensedField == null){
						condensedField = 'Includes: ' + allCountries.get(countryId).Name;
					} else {
						condensedField = condensedField + ', ' + allCountries.get(countryId).Name;
					}
				}
				system.debug('LIST OF Included COUNTRYName FOR APP: ' + appId + ' - ' + condensedField);
			} else if(appIdExcludesCountryListMap.get(appId).size() < appIdIncludesCountryListMap.get(appId).size()){
				// set condensed field to "Excludes:..."
				for(Id countryId : appIdExcludesCountryListMap.get(appId)){
					if(condensedField == null){
						condensedField = 'Excludes: ' + allCountries.get(countryId).Name;
					} else {
						condensedField = condensedField + ', ' + allCountries.get(countryId).Name;
					}
				}
				system.debug('LIST OF Excluded COUNTRYName FOR APP: ' + appId + ' - ' + condensedField);
			}
			
			appsToUpdate.put(appId, condensedField);
		}
		
		return appsToUpdate;

	}
	
		private static testmethod void ApplicationCountryMethodsTest(){
		Account a = new Account(Name='Google', Tier__c ='1');
		insert a;
		Contract contract1 = new Contract(Name='Contract1', AccountId=a.Id);			
		Contract contract2 = new Contract(Name='Contract2', AccountId=a.Id);
		insert new List<Contract> {contract1, contract2};
		
		Map<Id, Country__c> allCountries = new Map<Id, Country__c>([SELECT Id, Name, Country_Code__c FROM Country__c WHERE Region__c != null AND Region__c != '']);
		if(allcountries.isEmpty()){
			Country__c c = new Country__c(Name='fakeCountry', Country_Code__c = 'FC', Region__c = 'United States');
			Country__c c2 = new Country__c(Name='fakeCountry2', Country_Code__c = 'FC2', Region__c = 'United States');
			insert new List<Country__c>{c, c2};
			
			Test.startTest();
				Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', CurrencyIsoCode='CNY', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
				insert app;
				ContApplAssoc__c caa1 = new ContApplAssoc__c(Contract__c=contract1.id, Application__c=app.Id);
				ContApplAssoc__c caa2 = new ContApplAssoc__c(Contract__c=contract2.id, Application__c=app.Id, Governing_End_Date__c=false);
				insert new List<ContApplAssoc__c>{caa1, caa2};
				Application_Country__c ac = new Application_Country__c(Application__c = app.Id, Country__c = c.Id, Relationship__c = 'Legal');
				Application_Country__c ac2 = new Application_Country__c(Application__c = app.Id, Country__c = c2.Id, Relationship__c = 'Legal');
				Application_Country__c ac3 = new Application_Country__c(Application__c = app.Id, Country__c = c.Id, Relationship__c = 'Available');
				Application_Country__c ac4 = new Application_Country__c(Application__c = app.Id, Country__c = c2.Id, Relationship__c = 'Available');
				insert new List<Application_Country__c>{ac, ac2, ac3, ac4};
				delete new List<Application_Country__c>{ac, ac2, ac3, ac4};
			Test.stopTest();			
		} else {
			Test.startTest();
				Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', CurrencyIsoCode='CNY', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
				insert app;
				ContApplAssoc__c caa1 = new ContApplAssoc__c(Contract__c=contract1.id, Application__c=app.Id);
				ContApplAssoc__c caa2 = new ContApplAssoc__c(Contract__c=contract2.id, Application__c=app.Id, Governing_End_Date__c=false);
				insert new List<ContApplAssoc__c>{caa1, caa2};
				List<Application_Country__c> appCountryList = new List<Application_Country__c>();
				appCountryList.add(new Application_Country__c(Application__c = app.Id, Country__c = allCountries.values()[0].Id, Relationship__c = 'Legal'));
				appCountryList.add(new Application_Country__c(Application__c = app.Id, Country__c = allCountries.values()[1].Id, Relationship__c = 'Legal'));
				appCountryList.add(new Application_Country__c(Application__c = app.Id, Country__c = allCountries.values()[0].Id, Relationship__c = 'Available'));
				appCountryList.add(new Application_Country__c(Application__c = app.Id, Country__c = allCountries.values()[1].Id, Relationship__c = 'Available'));
				insert appCountryList;
				delete appCountryList;
				
				appCountryList = new List<Application_Country__c>();				
				for(Integer i=0; i < allCountries.keySet().size()-1; i++){
					appCountryList.add(new Application_Country__c(Application__c = app.Id, Country__c = allCountries.values()[i].Id, Relationship__c = 'Legal'));
					appCountryList.add(new Application_Country__c(Application__c = app.Id, Country__c = allCountries.values()[i].Id, Relationship__c = 'Available'));
				}
				insert appCountryList;
				Application_Country__c lastAcToMakeGlobal = new Application_Country__c(Application__c = app.Id, Country__c = allCountries.values()[allCountries.keySet().size()-1].Id, Relationship__c = 'Legal');
				Application_Country__c lastAcToMakeGlobal2 = new Application_Country__c(Application__c = app.Id, Country__c = allCountries.values()[allCountries.keySet().size()-1].Id, Relationship__c = 'Available');
				insert new List<Application_Country__c>{lastAcToMakeGlobal, lastAcToMakeGlobal2};
				
			Test.stopTest();
		}		
	}
}