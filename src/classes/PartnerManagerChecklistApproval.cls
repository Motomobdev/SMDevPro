public with sharing class PartnerManagerChecklistApproval {
    static List<DeviceApplicationAssoc__c> devApps = new List<DeviceApplicationAssoc__c>();
    static Map<Id, List<DeviceApplicationAssoc__c>> appIdDevAppListMap = new Map<Id, List<DeviceApplicationAssoc__c>>();

    // Rajesh - 6/11/2012 -- I don't know if this method is even needed. If it is not, the above
    // static variables have to be converted to local variables
    public static void calculatePartnerManagerChecklistApproval(List<DeviceApplicationAssoc__c> devAppList){
        system.debug('START OF calculatePartnerManagerChecklistApproval');
        devApps = devAppList;
        List<Id> appIds = new List<Id>();
        Set<Id> deviceIds = new Set<Id>();

        for(DeviceApplicationAssoc__c devApp : devAppList){
            appIds.add(devApp.Application__c);
            deviceIds.add(devApp.Device__c);

            List<DeviceApplicationAssoc__c> tempList = appIdDevAppListMap.get(devApp.Application__c);
            if(tempList == null){
                tempList = new List<DeviceApplicationAssoc__c>{devApp};
            } else {
                tempList.add(devApp);
            }
            appIdDevAppListMap.put(devApp.Application__c, tempList);
        }

        Date todayPlusSixMonths = Date.today().addMonths(6);
        Map<Id, Application__c> appIdMap = new Map<Id, Application__c>();

        //for(Application__c app : [SELECT Id, Account_Name__c, Automate_Partner_Checklist_Approval__c, 
        //Application_Contract_Governing_End_Date__c, GMS_App__c FROM Application__c 
        //WHERE Id IN : appIds/ * AND (Application_Type__c='Embedded' OR Application_Type__c='IP Settlement' 
        //OR Application_Type__c='Preload')* /]){
        
        for(Application__c app : [SELECT Id, Account_Name__c, Automate_Partner_Checklist_Approval__c, 
                                    Application_Contract_Governing_End_Date__c, GMS_App__c
                                    FROM Application__c
                                    WHERE Id IN : appIds]){
            
            if ((app.Application_Contract_Governing_End_Date__c > todayPlusSixMonths) || 
               (app.Account_Name__c == 'Google' && 
                app.GMS_App__c == true && app.Automate_Partner_Checklist_Approval__c == true)){
                appIdMap.put(app.Id, app);
            }
        }
        system.debug('APPIdMap: ' + appIdMap);
        if(!appIdMap.isEmpty()){
            //syncLanguages(appIdMap); disabled as per weekly meeting 2/23, per Ingred's note
            syncCountries(appIdMap, deviceIds);
        }
    }

    // this method is @future because line 42 is a non-selective query on a large object
    @future
    public static void calculatePartnerManagerChecklistApproval(List<Id> appIds){
        Date todayPlusSixMonths = Date.today().addMonths(6);
        Set<Id> deviceIds = new Set<Id>();
        Map<Id, Application__c> appIdMap = new Map<Id, Application__c>();

        //for(Application__c app : [SELECT Id, Account_Name__c, Automate_Partner_Checklist_Approval__c, 
        //Application_Contract_Governing_End_Date__c, GMS_App__c FROM Application__c 
        //WHERE Id IN : appIds AND (Application_Type__c='Embedded' OR Application_Type__c='IP Settlement' 
        //OR Application_Type__c='Preload')]){
        
        for(Application__c app : [SELECT Id, Account_Name__c, Automate_Partner_Checklist_Approval__c, 
                    Application_Contract_Governing_End_Date__c, GMS_App__c 
                    FROM Application__c 
                    WHERE Id IN : appIds]){

            if((app.Application_Contract_Governing_End_Date__c > todayPlusSixMonths) || 
                (app.Account_Name__c == 'Google' && 
                 app.GMS_App__c == true && 
                 app.Automate_Partner_Checklist_Approval__c == true)){
                appIdMap.put(app.Id, app);
            }
        }

        if(!appIdMap.isEmpty()){
            // Rajesh - 6/11/2012 - Emptied the static variable to avoid duplicate ID issue
            devApps.clear();
            
            // Rajesh - 6/11/2011 - Removed this condition from the SOQL:  AND Approval_Status__c != 'In Progress'
            for(DeviceApplicationAssoc__c da : [SELECT Id, Device__c, Application__c, Skip_Partner_Manager_Approval_Language__c
                                                FROM DeviceApplicationAssoc__c
                                                WHERE Application__c IN : appIdMap.keySet()
                                                AND Approval_Status__c != 'Approved'
                                                AND Device__r.Cancelled__c = false]){
                deviceIds.add(da.Device__c);
                // Added by Rajesh 6/1/2012 -- Start
                devApps.add(da);
                List<DeviceApplicationAssoc__c> tempList = appIdDevAppListMap.get(da.Application__c);
                if(tempList == null){
                    tempList = new List<DeviceApplicationAssoc__c>{da};
                } else {
                    tempList.add(da);
                }
                appIdDevAppListMap.put(da.Application__c, tempList);
                // Added by Rajesh 6/1/2012 -- End
            }
        }

        if(!deviceIds.isEmpty()){
            //syncLanguages(appIdMap); disabled as per weekly meeting 2/23, per Ingred's note
            syncCountries(appIdMap, deviceIds);
        }
    }

    /*public static void syncLanguages(Map<Id, Application__c> appIdMap){

        List<Language_Application__c> appLanguages = [SELECT id, Language__c, Application__c 
                FROM Language_Application__c 
                WHERE Application__c IN : appIdMap.keySet()];

        if(appLanguages.size() == 0){
            // None of the apps have languages selected
            for(DeviceApplicationAssoc__c da : devApps){
                da.Skip_Partner_Manager_Approval_Language__c = false;
            }
        }
        else{
            Set<Id> deviceIds = new Set<Id>();
            for(DeviceApplicationAssoc__c da : devApps){
                deviceIds.add(da.Device__c);
            }

            List<Language_Device__c> deviceLanguages = [SELECT Id, Device__c, Language__c, Language__r.Name 
                                            FROM Language_Device__c 
                                            WHERE device__c IN : deviceIds];
            if(deviceLanguages.size() == 0){
                for(DeviceApplicationAssoc__c da : devApps){
                    da.Skip_Partner_Manager_Approval_Language__c = false;
                }
            }
            else{
                system.debug('THIS IS DEVLANGUAGES: ' + deviceLanguages);
                Set<Id> appLanguageIds;
                for(Application__c a : appIdMap.Values()){
                    if(a.Automate_Partner_Checklist_Approval__c == true){
                        appLanguageIds = new Set<Id>();
                        for(Language_Application__c la : appLanguages){
                            if(a.Id == la.Application__c){
                                appLanguageIds.add(la.Language__c);
                            }
                        }

                        Set<Id> devLanguageIds;
                        for(DeviceApplicationAssoc__c da : devApps){
                            if(a.Id == da.Application__c){
                                devLanguageIds = new Set<Id>();
                                for(Language_Device__c ld : deviceLanguages){
                                    system.debug('WORKING WITH THIS LD: ' + ld.Language__r.Name);
                                    if(da.Device__c == ld.Device__c){
                                        devLanguageIds.add(ld.Language__c);
                                    }
                                }

                                if(appLanguageIds.containsAll(devLanguageIds) && devLanguageIds.containsAll(appLanguageIds)){
                                    da.Skip_Partner_Manager_Approval_Language__c = true;
                                }
                                else{
                                    da.Skip_Partner_Manager_Approval_Language__c = false;
                                }
                            }
                        }
                    }
                    else{
                        for(DeviceApplicationAssoc__c da : devApps){
                            if(a.Id == da.Application__c){
                                da.Skip_Partner_Manager_Approval_Language__c = false;
                            }
                        }
                    }
                }
            }
        }
        update devApps;
    }*/

    public static void syncCountries(Map<Id, Application__c> appIdMap, Set<Id> deviceIds){
        List<DeviceApplicationAssoc__c> devAppsToUpdate = new List<DeviceApplicationAssoc__c>();

        //List<Language_Application__c> appLanguages = [SELECT id, Language__c, Application__c 
        // FROM Language_Application__c WHERE Application__c IN : appIds];

        //System.debug('THIS IS DEVIDS in SyncCountries' + deviceIds);
        //List<DeviceCountryAssoc__c> deviceCountries = [SELECT Id, Device__c, Country__c 
        // FROM DeviceCountryAssoc__c WHERE device__c IN : deviceIds];
        
        Map<Id, Set<Id>> devIdCountriesIdSetMap = new Map<Id, Set<Id>>();
        Set<Id> deviceCountryIdsMasterList = new Set<Id>();
        for(DeviceCountryAssoc__c dc : [SELECT Id, Device__c, Country__c 
                                        FROM DeviceCountryAssoc__c 
                                        WHERE device__c IN : deviceIds]){
            Set<Id> tempList = devIdCountriesIdSetMap.get(dc.Device__c);
            if(tempList == null){
                tempList = new Set<Id>{dc.Country__c};
            } else {
                tempList.add(dc.Country__c);
            }
            devIdCountriesIdSetMap.put(dc.Device__c, tempList);

            deviceCountryIdsMasterList.add(dc.Country__c);
        }

        if(devIdCountriesIdSetMap.size() == 0){
            // none of the devices have countries
            for(DeviceApplicationAssoc__c da : devApps){
                da.Skip_Partner_Manager_Approval_Country__c = false;
                devAppsToUpdate.add(da);
            }
        } else{
            system.debug('THIS IS appIdMap.keyset(): ' + appIdMap.keyset());
            Map<Id, List<Application_Country__c>> appIdAppCountriesListMap = 
                new Map<Id, List<Application_Country__c>>();
            for(Application_Country__c ac : [SELECT Id, Application__c, Country__c, Relationship__c 
                        FROM Application_Country__c 
                        WHERE Application__c IN : appIdMap.keySet() 
                        AND Country__c IN : deviceCountryIdsMasterList]){
                List<Application_Country__c> tempList = appIdAppCountriesListMap.get(ac.Application__c);
                if(tempList == null){
                    tempList = new List<Application_Country__c>{ac};
                } else {
                    tempList.add(ac);
                }
                appIdAppCountriesListMap.put(ac.Application__c, tempList);
            }

            if(appIdAppCountriesListMap.isEmpty()){
                // None of the apps have countries selected
                for(DeviceApplicationAssoc__c da : devApps){
                    da.Skip_Partner_Manager_Approval_Country__c = false;
                    devAppsToUpdate.add(da);
                }
            } else{
                //system.debug('THIS IS DEVCountries: ' + deviceCountries);
                Set<Id> appLegalCountryIds;
                for(Id appId : appIdAppCountriesListMap.keySet()){
                    if(appIdMap.get(appId) != null){
                        Application__c a = appIdMap.get(appId);
                        if(a.Automate_Partner_Checklist_Approval__c == true){
                            // Need to find final list of countries for this app that is 
                            // intersection of Legal and Available countries
                            appLegalCountryIds = new Set<Id>();
                            Set<Id> appAvailableCountryIds = new Set<Id>();
                            for(Application_Country__c ac : appIdAppCountriesListMap.get(a.Id)){
                                if(ac.Relationship__c == 'Legal'){
                                    appLegalCountryIds.add(ac.Country__c);
                                }
                                else if(ac.Relationship__c == 'Available'){
                                    appAvailableCountryIds.add(ac.Country__c);
                                }
                            }
                            appLegalCountryIds.retainAll(appAvailableCountryIds);

                            if(appIdDevAppListMap.get(a.Id) != null){
                                for(DeviceApplicationAssoc__c da : appIdDevAppListMap.get(a.Id)){
                                    if(devIdCountriesIdSetMap.get(da.Device__c) != null &&
                                       appLegalCountryIds.containsAll(devIdCountriesIdSetMap.get(da.Device__c))){
                                        da.Skip_Partner_Manager_Approval_Country__c = true;
                                    }
                                    else{
                                        da.Skip_Partner_Manager_Approval_Country__c = false;
                                    }
                                    devAppsToUpdate.add(da);
                                }
                            }
                        }
                        else{
                            for(DeviceApplicationAssoc__c da : devApps){
                                if(a.Id == da.Application__c){
                                    da.Skip_Partner_Manager_Approval_Country__c = false;
                                    devAppsToUpdate.add(da);
                                }
                            }
                        }
                    }
                }
            }
        }

        if(!devAppsToUpdate.isEmpty()){
            system.debug('THIS IS devAppsToUpdate: ' + devAppsToUpdate);
            update devAppsToUpdate;
        }
    }

    /*

    public void syncLanguages(Map<Id, Application__c> appIdMap){

        List<Language_Application__c> appLanguages = [SELECT id, Language__c, Application__c 
            FROM Language_Application__c 
            WHERE Application__c IN : appIds];

        if(appLanguages.size() == 0){
            // None of the apps have languages selected
            for(DeviceApplicationAssoc__c da : devApps){
                da.Skip_Partner_Manager_Approval_Language__c = false;
            }
            update devApps;
        }
        else{
            Set<Id> deviceIds = new Set<Id>();
            for(DeviceApplicationAssoc__c da : devApps){
                deviceIds.add(da.Device__c);
            }

            List<Language_Device__c> deviceLanguages = [SELECT Id, Device__c, Language__c, Language__r.Name 
                    FROM Language_Device__c WHERE device__c IN : deviceIds];
            if(deviceLanguages.size() == 0){
                for(DeviceApplicationAssoc__c da : devApps){
                    da.Skip_Partner_Manager_Approval_Language__c = false;
                }
            }
            else{
                system.debug('THIS IS DEVLANGUAGES: ' + deviceLanguages);
                Set<Id> appLanguageIds;
                for(Application__c a : appIdMap.Values()){
                    if(a.Automate_Partner_Checklist_Approval__c == true){
                        appLanguageIds = new Set<Id>();
                        for(Language_Application__c la : appLanguages){
                            if(a.Id == la.Application__c){
                                appLanguageIds.add(la.Language__c);
                            }
                        }

                        Set<Id> devLanguageIds;
                        for(DeviceApplicationAssoc__c da : devApps){
                            if(a.Id == da.Application__c){
                                devLanguageIds = new Set<Id>();
                                for(Language_Device__c ld : deviceLanguages){
                                    system.debug('WORKING WITH THIS LD: ' + ld.Language__r.Name);
                                    if(da.Device__c == ld.Device__c){
                                        devLanguageIds.add(ld.Language__c);
                                    }
                                }

                                if(appLanguageIds.containsAll(devLanguageIds) && !devLanguageIds.isEmpty()){
                                    da.Skip_Partner_Manager_Approval_Language__c = true;
                                }
                                else{
                                    da.Skip_Partner_Manager_Approval_Language__c = false;
                                }
                            }
                        }
                    }
                    else{
                        for(DeviceApplicationAssoc__c da : devApps){
                            if(a.Id == da.Application__c){
                                da.Skip_Partner_Manager_Approval_Language__c = false;
                            }
                        }
                    }
                }
            }
            update devApps;
        }
    }

    public void syncCountries(Map<Id, Application__c> appIdMap){
        Set<Id> appIds = appIdMap.keySet();

        //List<Language_Application__c> appLanguages = [SELECT id, Language__c, Application__c 
        // FROM Language_Application__c WHERE Application__c IN : appIds];
        List<Application_Country__c> appCountries = [SELECT Id, Application__c, Country__c, 
                Relationship__c FROM Application_Country__c 
                WHERE Application__c IN : appIds];

        if(appCountries.isEmpty()){
            // None of the apps have languages selected
            for(DeviceApplicationAssoc__c da : devApps){
                da.Skip_Partner_Manager_Approval_Country__c = false;
            }
            update devApps;
        }
        else{
            Set<Id> deviceIds = new Set<Id>();
            for(DeviceApplicationAssoc__c da : devApps){
                deviceIds.add(da.Device__c);
            }

            List<DeviceCountryAssoc__c> deviceCountries = [SELECT Id, Device__c, Country__c 
                            FROM DeviceCountryAssoc__c 
                            WHERE device__c IN : deviceIds];
            if(deviceCountries.size() == 0){
                for(DeviceApplicationAssoc__c da : devApps){
                    da.Skip_Partner_Manager_Approval_Country__c = false;
                }
            }
            else{
                system.debug('THIS IS DEVCountries: ' + deviceCountries);
                Set<Id> appLegalCountryIds;
                for(Application__c a : appIdMap.Values()){
                    if(a.Automate_Partner_Checklist_Approval__c == true){
                        // Need to find final list of countries for this app that is 
                        // intersection of Legal and Available countries
                        appLegalCountryIds = new Set<Id>();
                        Set<Id> appAvailableCountryIds = new Set<Id>();
                        for(Application_Country__c ac : appCountries){
                            if(a.Id == ac.Application__c && ac.Relationship__c == 'Legal'){
                                appLegalCountryIds.add(ac.Country__c);
                            }
                            else if(a.Id == ac.Application__c && ac.Relationship__c == 'Available'){
                                appAvailableCountryIds.add(ac.Country__c);
                            }
                        }
                        appLegalCountryIds.retainAll(appAvailableCountryIds);

                        Set<Id> devCountryIds;
                        for(DeviceApplicationAssoc__c da : devApps){
                            if(a.Id == da.Application__c){
                                devCountryIds = new Set<Id>();
                                for(DeviceCountryAssoc__c dc : deviceCountries){
                                    if(da.Device__c == dc.Device__c){
                                        devCountryIds.add(dc.Country__c);
                                    }
                                }

                                if(appLegalCountryIds.containsAll(devCountryIds) && 
                                    devCountryIds.containsAll(appLegalCountryIds)){
                                    da.Skip_Partner_Manager_Approval_Country__c = true;
                                }
                                else{
                                    da.Skip_Partner_Manager_Approval_Country__c = false;
                                }
                            }
                        }
                    }
                    else{
                        for(DeviceApplicationAssoc__c da : devApps){
                            if(a.Id == da.Application__c){
                                da.Skip_Partner_Manager_Approval_Country__c = false;
                            }
                        }
                    }
                }
            }
            update devApps;
        }
    }*/


}