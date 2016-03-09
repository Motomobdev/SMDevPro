public with sharing class ApplicationMethods {
    public static void setSkipLRBField(List<Application__c> newList){
        for(Application__c app : newList){
            app.Skip_LRB_Approval__c = true;
            if((app.Application_Type__c == 'Services' || app.Application_Type__c == 'Embedded' || app.Application_Type__c == 'Preload') || app.Application_Type__c == null){
                if(app.Application_Contract_LRB_Pipeline_ID__c != 'grandfathered'){
                    if((app.Application_Contract_LRB_Approved_Device__c != 'all devices') || (app.Application_Contract_LRB_Approved_Region__c != 'global')){
                        if(app.Application_Contract_Decision__c != 'Pass'){  
                            if(app.Application_Contract_Decision__c != 'Exempt / N/A' ){
                                app.Skip_LRB_Approval__c = false;                        
                            }
                        }
                    }
                }
            }
        }
    }
    
    // *** VHD Ticket #39089	FR124104 ***
    // Modified By: Neel Desai	Date: 21/Aug/2012
    // When 'Available for Use' is UNCHECKED for an application, field 'Automate Partner Checklist Approval' should 
    // automatically UNCHECKED as well. 
    // If the app is already associated with a device, the 'auto-approve' should be removed (if it hasn't yet been approved).
    public static void uncheckAutomatePartnerChecklistApproval(List<Application__c> newList, List<Application__c> oldList)
    {
    	List<DeviceApplicationAssoc__c> devAppsToUpdate = new List<DeviceApplicationAssoc__c>();
    	 
    	for(Integer i=0; i<newList.size(); i++)
    	{
    		// to check 'Available for Use' is being unckecked
    		if(newList[i].Available_For_Use__c == false && oldList[i].Available_For_Use__c == true)
    		{
    			// Uncheck 'Automate Partner Checklist Approval'
    			newList[i].Automate_Partner_Checklist_Approval__c = false;
    			
    			// Get list of records from Device Application for current Application
    			// and status is not approved/conditional
    			List<DeviceApplicationAssoc__c> DevApps = [SELECT 	Skip_Partner_Manager_Approval_Country__c
    													   FROM 	DeviceApplicationAssoc__c 
    													   WHERE 	Application__c = :newList[i].Id 
    													   			AND Approval_Status__c NOT IN ('Approved','Conditional')];
    			
    			for(DeviceApplicationAssoc__c DevApp : DevApps)
    			{
    				// if 'Automate Partner Checklist Approval' is checked
    				if(DevApp.Skip_Partner_Manager_Approval_Country__c <> false)
    				{
    					// unchecked it
	    				DevApp.Skip_Partner_Manager_Approval_Country__c = false;
	    				// add to list for commit changes to Sf later
    					devAppsToUpdate.add(DevApp);
    				}
    			}
    		}
    	}

		// update back changed Device Application records
		if(!devAppsToUpdate.isEmpty())
			update devAppsToUpdate;
    }
    
    public static void setAvailableForUseToFalse(List<Application__c> newList){
    	for(Application__c app : newList){
    		app.Available_For_Use__c = false;
    	}
    }
    
    public static void checkAvailableForUseSettting(List<Application__c> newList, List<Application__c> oldList){
    	Set<Id> appIds = new Set<Id>();
		for(Integer i=0; i<newList.size();i++){
			if(newList[i].Available_For_Use__c != oldList[i].Available_For_Use__c){
				appIds.add(newList[i].Id);
			}	
		}
		
		if(!appIds.isEmpty()){
			GoverningContractApplication.contractApplicationUpdate(appIds);
		}
    }
    
    
    public static void updateContractApplications(List<Application__c> newList, List<Application__c> oldList){
    	Map<Id, Application__c> appIdMap = new Map<Id, Application__c>(); 
    	for(Integer i=0; i<newList.size(); i++){
    		if((newList[i].Description__c != oldList[i].Description__c) || (newList[i].Application_Instructions__c != oldList[i].Application_Instructions__c)){
    			appIdMap.put(newList[i].Id, newList[i]);
    		}
    	}
    	
    	if(!appIdMap.keySet().isEmpty()){
    		List<Program_Application__c> progApps = [SELECT Id, Application_Description__c, Application_Instructions__c, Application__c FROM Program_Application__c WHERE Application__c IN : appIdMap.keySet()];
    		for(Integer i=0; i<progApps.size(); i++){
    			if(appIdMap.get(progApps[i].Application__c) != null){
	    			progApps[i].Application_Description__c = appIdMap.get(progApps[i].Application__c).Description__c;
	    			progApps[i].Application_Instructions__c = appIdMap.get(progApps[i].Application__c).Application_Instructions__c;
    			}
    		}
    		update progApps;
    	}
    }
    
    public static void fillMicrogenApplicationId(List<Application__c> newList){
		List<Application__c> tempList = new List<Application__c>();
		for(Application__c a : newList){
			tempList.add(new Application__c(Id = a.Id, Microgen_Application_ID__c = a.Application_ID__c));
		}
		
		update tempList;
	}
    
    public static void updateProgramApplicationCosts(List<Id> appIds){
        Map<Id, Application__c> apps = new Map<Id, Application__c>([SELECT Id, convertCurrency(Royalty_High__c), convertCurrency(Royalty_Low__c), convertCurrency(Royalty_Current__c) FROM Application__c WHERE Id IN : appIds]);
                        
        List<Program_Application__c> pApps = [SELECT Id, Application__c, Application_Cost_Current__c, Application_Cost_High__c, Application_Cost_Low__c FROM Program_Application__c WHERE Application__c IN : appIds];
        for(Program_Application__c pa : pApps){
            pa.Application_Cost_Current__c = apps.get(pa.Application__c).Royalty_Current__c;
            pa.Application_Cost_High__c = apps.get(pa.Application__c).Royalty_High__c;
            pa.Application_Cost_Low__c = apps.get(pa.Application__c).Royalty_Low__c;
        }       
        update pApps;
    }
    
    public static Map<Id, Application__c> getCurrencyConvertedApplicationMap(List<Id> appIds){
        Map<Id, Application__c> appIdMap = new Map<Id, Application__c>([SELECT Id, Royalty_High__c, Royalty_Low__c, Royalty_Current__c, CurrencyIsoCode FROM Application__c WHERE Id IN : appIds]);
        
        List<String> isoCodes = new List<String>();
        for(Application__c app : appIdMap.Values()){
            isoCodes.add(app.CurrencyIsoCode);
        }
        
        Map<String, CurrencyType> isoCodeCurrencyMap = new Map<String, CurrencyType>();
        for(CurrencyType c : [SELECT IsoCode, ConversionRate FROM CurrencyType WHERE IsoCode IN : isoCodes]){
            isoCodeCurrencyMap.put(c.IsoCode, c);
        }
        
        for(Application__c app : appIdMap.Values()){
            if(app.CurrencyIsoCode != 'USD'){
                if(app.Royalty_Current__c != null){ app.Royalty_Current__c = app.Royalty_Current__c / isoCodeCurrencyMap.get(app.CurrencyIsoCode).ConversionRate; }
                if(app.Royalty_High__c != null){ app.Royalty_High__c = app.Royalty_High__c / isoCodeCurrencyMap.get(app.CurrencyIsoCode).ConversionRate; }
                if(app.Royalty_Low__c != null){ app.Royalty_Low__c = app.Royalty_Low__c / isoCodeCurrencyMap.get(app.CurrencyIsoCode).ConversionRate; }
            }
        }
        
        return appIdMap;
    }
    
    public static void validateApplicationDelete(List<Application__c> appsToBeDeleted){
    	Map<Id, Application__c> appIdMap = new Map<Id, Application__c>();
    	appIdMap.putAll(appsToBeDeleted);
    	
    	for(DeviceApplicationAssoc__c devApp : [SELECT Id, Application__c FROM DeviceApplicationAssoc__c WHERE Application__c IN : appIdMap.keySet()]){
    		appIdMap.get(devApp.Application__c).addError('This Application cannot be deleted because it is on Device(s) and possibly other records.');	
    	}
    	
    	for(ContApplAssoc__c conApp : [SELECT Id, Application__c FROM ContApplAssoc__c WHERE Application__c IN : appIdMap.keySet()]){
    		appIdMap.get(conApp.Application__c).addError('This Application cannot be deleted because it is on Contract(s) and possibly other records.');	
    	}
    	
    	for(Program_Application__c progApp : [SELECT Id, Application__c FROM Program_Application__c WHERE Application__c IN : appIdMap.keySet()]){
    		appIdMap.get(progApp.Application__c).addError('This Application cannot be deleted because it is on Program(s) and possibly other records.');	
    	}
    	
    	for(Stable_Application__c stableApp : [SELECT Id, Application__c FROM Stable_Application__c WHERE Application__c IN : appIdMap.keySet()]){
    		appIdMap.get(stableApp.Application__c).addError('This Application cannot be deleted because it is on Stable(s) and possibly other records.');	
    	}
    	
    	for(Core_Device_Package_Application__c coreApp : [SELECT Id, Application__c FROM Core_Device_Package_Application__c WHERE Application__c IN : appIdMap.keySet()]){
    		appIdMap.get(coreApp.Application__c).addError('This Application cannot be deleted because it is on Core(s) and possibly other records.');	
    	}
    	
    	for(Payment_Application_Assoc__c paymentApp : [SELECT Id, Application__c FROM Payment_Application_Assoc__c WHERE Application__c IN : appIdMap.keySet()]){
    		appIdMap.get(paymentApp.Application__c).addError('This Application cannot be deleted because it is has Payment(s) and possibly other records.');	
    	}
    	
    	for(SW_Bundle_Application__c swApp : [SELECT Id, Application__c FROM SW_Bundle_Application__c WHERE Application__c IN : appIdMap.keySet()]){
    		appIdMap.get(swApp.Application__c).addError('This Application cannot be deleted because it is a part of SW Bundle(s) and possibly other records.');	
    	}
    	
    	for(Competitive_Source_Apps__c topApp : [SELECT Id, Application__c FROM Competitive_Source_Apps__c WHERE Application__c IN : appIdMap.keySet()]){
    		appIdMap.get(topApp.Application__c).addError('This Application cannot be deleted because it is a Top 10 App and possibly related to other records.');	
    	}
    	
    	for(Campaign_Apps__c campaignApp : [SELECT Id, Application__c FROM Campaign_Apps__c WHERE Application__c IN : appIdMap.keySet()]){
    		appIdMap.get(campaignApp.Application__c).addError('This Application cannot be deleted because it is on Campaign(s) and possibly other records.');	
    	}
    }
    
    private static testmethod void validateApplicationDeleteTest(){
    	Account a = new Account(Name='account', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        insert app;
        
        Device__c d = new Device__c(Name='device');
        insert d;
        Contract c = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		insert ca;
        Program__c p = new Program__c(Name='program');
        insert p;
        Stable__c s = new Stable__c(Name='stable');
        insert s;
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='core');
        insert cdp;
        Payment__c payment = new Payment__c(Name='payment');
        insert payment;
        SW_Bundle__c swBundle = new SW_Bundle__c(Name='swbundle');
        insert swBundle;
        Competitive_Sources__c compSource = new Competitive_Sources__c(Name='compSource');
        insert compSource;
        Campaign camp = new Campaign(Name='campaign');
        insert camp;        
        
        DeviceApplicationAssoc__c da = new DeviceApplicationAssoc__c(Application__c=app.Id, Device__c=d.Id);
        insert da;
        Program_Application__c pa = new Program_Application__c(Application__c=app.Id, Program__c=p.Id);
        insert pa;
        Stable_Application__c sa = new Stable_Application__c(Application__c=app.Id, Stable__c=s.Id);
        insert sa;
        Core_Device_Package_Application__c cdpa = new Core_Device_Package_Application__c(Application__c=app.Id, Core_Device_Package__c=cdp.Id);
        insert cdpa;
        Payment_Application_Assoc__c pay = new Payment_Application_Assoc__c(Application__c=app.Id, Payment__c=payment.Id);
        insert pay;
        SW_Bundle_Application__c swApp = new SW_Bundle_Application__c(Application__c=app.Id, Service_Type__c=swBundle.Id);
        insert swApp;
        Competitive_Source_Apps__c compSourceApp = new Competitive_Source_Apps__c(Application__c=app.Id, Competitive_Sources__c=compSource.Id,Date_Sourced__c=Date.today());
        insert compSourceApp;
        Campaign_Apps__c campaignApp = new Campaign_Apps__c(Application__c=app.Id, Campaign__c=camp.Id);
        insert campaignApp;
        
        Test.startTest();
        	try{
        		delete app;
        	} catch(System.DMLException e){
        		// delete stopped
        	}
        Test.stopTest();
    }
    
    private static testmethod void ApplicationMethodsTest(){
        Program__c p = new Program__c(Name='p');
        insert p;
        
        Account a = new Account(Name='Google', Tier__c ='1');
        insert a;
        Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Royalty_High__c = 0.1800, Application_Type__c='Preload', Application_Sub_Type__c='faketype', CurrencyIsoCode='CNY', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        insert app;
        Contract c = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		insert ca;

        Program_Application__c pa = new Program_Application__c(Program__c = p.id, Application__c = app.Id);
        insert pa;
        
        Test.startTest();
            app.Royalty_High__c = 1;
            app.Description__c = 'new description';
            update app;
        Test.stopTest();        
    }
}