public with sharing class WeeklyReportController {
/*
Author: Bineet Mishra
Created On: Jan 20, 2014
Description: Controller class for WeeklyReport page. This page will be used to generate 
             customized weekly report based on filters 
             selected by users. This page will also provide editable grid to make changes 
             to weekly items.
Change History:
Rajesh Krishnaiah -> 16-May-2014: Changed the default value of "included" variable 
    from 'Y' to ''
*/
    public string function{get; set;}
    public string weekEnding{get; set;} {
        AggregateResult[] results = [SELECT MAX(Week_Ending__c) maxdate FROM Weekly_Report__c];
        weekEnding = string.valueOf((Date)results[0].get('maxdate'));
    }
    public string business{get; set;}
    public string businessgroup{get; set;}
    public string included{get; set;}
    
    public String[] userIds{get; set;}
    public String[] selectedRegions{get; set;}
    public String[] selectedSubRegions{get; set;}
    public String[] selectedCountries{get; set;}
    public String[] selectedAccounts{get; set;}
    public String[] selectedCalendars{get; set;}

    public boolean showGrid{get; set;}
    public boolean showResult{get; set;}
    public String toggleButtonText{get; set;}
    
    Map<String, String> functionMap = new Map<String, String>();
    Map<String, Date> weekMap = new Map<String, Date>();
    Map<String, String> userMap = new Map<String, String>();
    
    Map<String, String> regionMap = new Map<String, String>();
    Map<String, String> subRegionMap = new Map<String, String>();
    Map<String, String> countryMap = new Map<String, String>();
    Map<String, String> accountMap = new Map<String, String>();
    
    List<Weekly_Report_Item__c> weeklyItems;
    List<Weekly_Report_Item__c> weeklyItemsByCreator;
    List<Weekly_Report__c> weekly;  
    Set<Id> weeklyIds = new Set<Id>();

    public List<Weekly_Report_Item__c> highlights{get; set;}
    public List<Weekly_Report_Item__c> marketIntelligence{get; set;}
    public List<Weekly_Report_Item__c> nextWeeksPriorities{get; set;}
    public List<Weekly_Report_Item__c> keyHighlights{get; set;}
    public List<Weekly_Report_Item__c> upcomingMeetings{get; set;}

    public List<Weekly_Report_Item__c> highlightsByCreator{get; set;}
    public List<Weekly_Report_Item__c> marketIntelligenceByCreator{get; set;}
    public List<Weekly_Report_Item__c> nextWeeksPrioritiesByCreator{get; set;}
    public List<Weekly_Report_Item__c> keyHighlightsByCreator{get; set;}
    public List<Weekly_Report_Item__c> upcomingMeetingsByCreator{get; set;}
    
    public Weekly_Report_Item__c weeklyRprtItem {get;set;}
    public List<SelectOption> options {get;set;}
    public String actualOrgRole {get;set;}
    public String businessGrpFilter{get;set;}
    public WeeklyReportController()
    {   
        /**
         * Modified by prelude
         */
         
        ///<OBJECTIVE>
        /// Fetch the "Time Period" picklist field values and display the values in visualforce page.
        ///<OBJECTIVE>
        weeklyRprtItem = new  Weekly_Report_Item__c();        
        options = new List<SelectOption>();
        // Use DescribeFieldResult object to retrieve the time period picklist field.
        Schema.DescribeFieldResult picklistField =  Weekly_Report_Item__c.Time_Period__c.getDescribe();
        // For each picklist value, create a new select option
        for (Schema.Picklistentry picklistEntry:picklistField.getPicklistValues())
        {
            options.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
            // obtain and assign default value
            if (picklistEntry.defaultValue)
            {
                weeklyRprtItem.Time_Period__c = pickListEntry.getValue();
            }  
        }       
        userIds = new String[]{''};
        selectedRegions = new String[]{''};
        selectedSubRegions = new String[]{''};
        selectedCountries = new String[]{''};
        selectedAccounts = new String[]{''};
        selectedCalendars = new String[]{''};
        included = '';

        showResult = false;
        showGrid = false;
        toggleButtonText = 'Edit Weekly';

        highlights = new List<Weekly_Report_Item__c>();
        marketIntelligence = new List<Weekly_Report_Item__c>();
        nextWeeksPriorities = new List<Weekly_Report_Item__c>();
        keyHighlights = new List<Weekly_Report_Item__c>();
        upcomingMeetings = new List<Weekly_Report_Item__c>();

        highlightsByCreator = new List<Weekly_Report_Item__c>();
        marketIntelligenceByCreator = new List<Weekly_Report_Item__c>();
        nextWeeksPrioritiesByCreator = new List<Weekly_Report_Item__c>();
        keyHighlightsByCreator = new List<Weekly_Report_Item__c>();
        upcomingMeetingsByCreator = new List<Weekly_Report_Item__c>();
        
        string week = ApexPages.currentPage().getParameters().get('week');
        if(week != null)
            weekEnding = week;

        string func = ApexPages.currentPage().getParameters().get('function');
        if(func != null)
            function = func;
        String delim = '$$$';
        String myOrgRoles = delim + 'Lenovo_ROW' + delim + 'MobileDevices' + delim;
        Map<String,String> businessGroupMap = new Map<String,String>();//Key Org role,Value is businessgroup
        businessGroupMap.put('MobileDevices','Motorola');
        businessGroupMap.put('Lenovo_ROW','Lenovo');
        List<UserRole> orgRoles = [Select id, Developername,parentroleId from Userrole where parentroleId!=null];
        Map<Id,Id> orgRoleIds = new Map<Id,Id>();
        Map<Id,String> roleNameMap = new Map<Id,String>();
        for(UserRole eachRole:orgRoles){        
            orgRoleIds.put(eachRole.id,eachRole.parentroleid);
            roleNameMap.put(eachRole.id,eachRole.DeveloperName);
        }

        Id currentrole = Userinfo.getUserRoleId();
        String devName = roleNameMap.get(currentRole);
        System.debug('currentrole'+currentrole);
        System.debug('devname'+devName);
        businessGrpFilter = '';  
        do{            
            if( devName != null && myOrgRoles.contains(delim+devName+delim)){
                actualOrgRole = devName;
                break;
            }
            currentRole = orgRoleIds.get(currentrole);
             System.debug('parentrolefound'+currentRole);
            devName = roleNameMap.get(currentRole);
        } while( currentRole != null );
        System.debug('Actualorgrole'+actualOrgRole);

        if( actualOrgRole != '' && businessGroupMap.containsKey(actualOrgRole)){
            businessGrpFilter = businessGroupMap.get(actualOrgRole);                
        }

    }

    public PageReference ExportReport(){
        PageReference ref = new PageReference('/apex/WeeklyReportExport');
        return ref;
    }

    public PageReference ExportReportByCreator(){
        PageReference ref = new PageReference('/apex/WeeklyReportExportByCreator');
        return ref;
    }
    public List<SelectOption> getAllWeekEndings(){
        Set<Date> weekSet = new Set<Date>();
        List<Date> weekList = new List<Date>();
        List<SelectOption> weeks = new List<SelectOption>{getAllOption()};

        showResult = false;
        string query = 'SELECT Week_Ending__c FROM Weekly_Report__c';
        query += ' ORDER BY Week_Ending__c Desc';

        try{
            weekly = Database.query(query);
        
            weekSet.clear();
            for(Weekly_Report__c wr : weekly){
                if(!weekSet.contains(wr.Week_Ending__c))
                    weekSet.add(wr.Week_Ending__c);
            }
            weekList.addAll(weekSet);
            weekList.sort();

            for(integer i=weekList.size()-1; i>=0; i--){
                weeks.add(new SelectOption(string.valueOf(weekList[i]), string.valueOf(weekList[i])));              
            }
        }
        catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,'Too many filters attempted, please refresh the page to proceed.');
            ApexPages.addMessage(pageMsg);
        }

        return weeks;
    }

    public List<SelectOption> getAllFunctions(){
        showResult = false;
        List<SelectOption> functions = new List<SelectOption>{getAllOption()};
        string query = 'SELECT Function__c FROM Weekly_Report__c';
        if(String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' WHERE Week_Ending__c = :temp';
        }
        
        query += ' ORDER BY Function__c Desc';
        try{
            weekly = Database.query(query);

            String[] functionList = new String[]{};
            functionMap.clear();
            for(Weekly_Report__c wr : weekly){
                system.debug('Function added to map: ' + wr.Function__c);
                functionMap.put(wr.Function__c, wr.Function__c);                
            }
            functionList.addAll(functionMap.keyset());
            functionList.sort();
            for(String fn : functionList)
                functions.add(new SelectOption(fn, functionMap.get(fn)));
        
        }
        catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
              'Too many filters attempted, please refresh the page to proceed. '
                + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }

        return functions;
    }

    public List<SelectOption> getAllBusinesses(){
        showResult = false;
        Set<String> businessSet = new Set<String>();
        List<SelectOption> businesses = new List<SelectOption>{getAllOption()};
        
        string query = 'SELECT Id FROM Weekly_Report__c WHERE Name != null';
        if(String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' AND Week_Ending__c = :temp';
        }
        if(String.isNotBlank(function))
            query += ' AND Function__c = \'' + function + '\'';
        
        try{
            weekly = Database.query(query);

            weeklyIds.clear();  
            for(Weekly_Report__c wr : weekly)
                weeklyIds.add(wr.Id);

            string itemQuery = 'SELECT Business__c FROM Weekly_Report_Item__c WHERE Weekly_Report__c IN :weeklyIds';
            itemQuery += ' ORDER BY Business__c';
                
            weeklyItems = Database.query(itemQuery);
            
            if(weeklyItems.size() == 0)
                return businesses;

            String[] businessList = new String[]{};
            businessSet.clear();
            for(Weekly_Report_Item__c wi : weeklyItems){
                if(String.isNotBlank(wi.Business__c))
                    businessSet.add(wi.Business__c);                
            }
            businessList.addAll(businessSet);
            businessList.sort();
            for(String b : businessList)
                businesses.add(new SelectOption(b, b));

        }
        catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
              'Too many filters attempted, please refresh the page to proceed. '
                                                              + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }
            
        return businesses;
    }

    public List<SelectOption> getAllBusinessesgroup(){
        showResult = false;
        Set<String> businessgroupSet = new Set<String>();
        List<SelectOption> businessesgroup = new List<SelectOption>{getAllOption()};
        
        string query = 'SELECT Id FROM Weekly_Report__c WHERE Name != null';
        if(String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' AND Week_Ending__c = :temp';
        }
        if(String.isNotBlank(function))
            query += ' AND Function__c = \'' + function + '\'';
        
        try{
            weekly = Database.query(query);

            weeklyIds.clear();  
            for(Weekly_Report__c wr : weekly)
                weeklyIds.add(wr.Id);

            string itemQuery = 'SELECT Account__r.Business_Group__c FROM Weekly_Report_Item__c WHERE Weekly_Report__c IN :weeklyIds';

            if( businessGrpFilter != '' ){       
                itemQuery =  itemQuery + ' AND Account__r.Business_Group__c = :businessGrpFilter';
            }
            if(String.isNotBlank(businessgroup)){
                itemQuery += ' AND Account__r.Business_Group__c = :businessgroup';
            }
            itemQuery += ' ORDER BY Account__r.Business_Group__c';
                
            weeklyItems = Database.query(itemQuery);
            
            if(weeklyItems.size() == 0)
                return businessesgroup;

            String[] businessList1 = new String[]{};
            businessgroupSet.clear();
            for(Weekly_Report_Item__c wi : weeklyItems){
                if(String.isNotBlank(wi.Account__r.Business_Group__c))
                    businessgroupSet.add(wi.Account__r.Business_Group__c);                
            }
            businessList1.addAll(businessgroupSet);
            businessList1.sort();
            for(String b : businessList1)
                businessesgroup.add(new SelectOption(b, b));

        }
        catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
              'Too many filters attempted, please refresh the page to proceed. '
                                                              + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }
            
        return businessesgroup;
    }
    
    public List<SelectOption> getAllRegions(){
        showResult = false;
        List<SelectOption> regions = new List<SelectOption>{getAllOption()};

        string query = 'SELECT Id FROM Weekly_Report__c WHERE Name != null';
        if(String.isNotBlank(function))
            query += ' AND Function__c = \'' + function + '\'';
        if(String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' AND Week_Ending__c = :temp';
        }           
        try{
            weekly = Database.query(query);
        
            weeklyIds.clear();  
            for(Weekly_Report__c wr : weekly)
                weeklyIds.add(wr.Id);

            string itemQuery = 'SELECT Account__r.Region__c FROM Weekly_Report_Item__c WHERE Weekly_Report__c IN :weeklyIds';
            if(String.isNotBlank(businessgroup)){
                itemQuery += ' AND Account__r.Business_Group__c = :businessgroup';
            }
            if( businessGrpFilter != '' ){       
                itemQuery =  itemQuery + ' AND Account__r.Business_Group__c = :businessGrpFilter';
            }
            
            if(String.isNotBlank(business)){
                itemQuery += ' AND Business__c = :business';
            }
            itemQuery += ' ORDER BY Account__r.Region__c';
            

            weeklyItems = Database.query(itemQuery);
            
            if(weeklyItems.size() == 0)
                return regions;
            //System.debug('Weekly Data: ' + weekly[0].Id + ' Size ' + weekly.size());              
            
            String[] regionlist = new String[]{};
            regionMap.clear();
            for(Weekly_Report_Item__c wi : weeklyItems){
                if(String.isNotBlank(wi.Account__r.Region__c) && !regionMap.containsKey(wi.Account__r.Region__c))   
                    regionMap.put(wi.Account__r.Region__c, wi.Account__r.Region__c);
            }
            regionList.addAll(regionMap.keyset());
            regionList.sort();
            for(String region : regionList)
                regions.add(new SelectOption(region, regionMap.get(region)));   
            
            system.debug('Region list: ' + regions.size());
        }
        catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
              'Too many filters attempted, please refresh the page to proceed.'
                                                              + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }           
        return regions;
    }
    
    public List<SelectOption> getAllSubRegions(){
        showResult = false;
        List<SelectOption> subRegions = new List<SelectOption>{getAllOption()};

        string query = 'SELECT Id FROM Weekly_Report__c WHERE Name != null';
        if(String.isNotBlank(function))
            query += ' AND Function__c = \'' + function + '\'';
        if(String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' AND Week_Ending__c = :temp';
        }
        
        try{            
            weekly = Database.query(query);
        
            weeklyIds.clear();  
            for(Weekly_Report__c wr : weekly)
                weeklyIds.add(wr.Id);
            
            string itemQuery = 'SELECT Account__r.Sub_Region__c FROM Weekly_Report_Item__c WHERE Weekly_Report__c IN :weeklyIds';

            if(String.isNotBlank(businessgroup)){
                itemQuery += ' AND Account__r.Business_Group__c = :businessgroup';
            }
            if( businessGrpFilter != '' ){       
                itemQuery =  itemQuery + ' AND Account__r.Business_Group__c = :businessGrpFilter';
            }
            if(String.isNotBlank(business)){
                itemQuery += ' AND Business__c = :business';
            }
            if(String.isNotBlank(selectedRegions[0])){
                itemQuery += ' AND Account__r.Region__c IN (\'' + String.join(selectedRegions,'\',\'') + '\')';
            }
            itemQuery += ' ORDER BY Account__r.Sub_Region__c';

            weeklyItems = Database.query(itemQuery);

            if(weeklyItems.size() == 0)
                return subRegions;
            //System.debug('Weekly Data: ' + weekly[0].Id + ' Size ' + weekly.size());              
            
            String[] subRegionlist = new String[]{};
            subRegionMap.clear();
            for(Weekly_Report_Item__c wi : weeklyItems){
                if(String.isNotBlank(wi.Account__r.Sub_Region__c) && !subRegionMap.containsKey(wi.Account__r.Sub_Region__c))    
                    subRegionMap.put(wi.Account__r.Sub_Region__c, wi.Account__r.Sub_Region__c);
            }
            subRegionList.addAll(subRegionMap.keyset());
            subRegionList.sort();
            for(String subRegion : subRegionList)
                subRegions.add(new SelectOption(subRegion, subRegionMap.get(subRegion)));   
            
            system.debug('Sub Region list: ' + subRegions.size());  
        }
        catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
                 'Too many filters attempted, please refresh the page to proceed. '
                 + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }

        return subRegions;
    }
    
    public List<SelectOption> getAllCountries(){
        showResult = false;
        List<SelectOption> countries = new List<SelectOption>{getAllOption()};

        string query = 'SELECT Id FROM Weekly_Report__c WHERE Name != null';
        if(String.isNotBlank(function))
            query += ' AND Function__c = \'' + function + '\'';
        if(String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' AND Week_Ending__c = : temp';
        }
        
        try{            
            weekly = Database.query(query);
        
            weeklyIds.clear();  
            for(Weekly_Report__c wr : weekly)
                weeklyIds.add(wr.Id);
            
            string itemQuery = 'SELECT Account__r.Country__c FROM Weekly_Report_Item__c WHERE Weekly_Report__c IN :weeklyIds';
             /*if(String.isNotBlank(businessgroup)){
                itemQuery += ' AND Account__r.Business_Group__c = :businessgroup';
            }*/
if(String.isNotBlank(businessgroup)){
                itemQuery += ' AND Account__r.Business_Group__c = :businessgroup';
            }
            if( businessGrpFilter != '' ){       
                itemQuery =  itemQuery + ' AND Account__r.Business_Group__c = :businessGrpFilter';
            }
            if(String.isNotBlank(business)){
                itemQuery += ' AND Business__c = :business';
            }
            if(String.isNotBlank(selectedRegions[0])){
                itemQuery += ' AND Account__r.Region__c IN (\'' + String.join(selectedRegions,'\',\'') + '\')';
            }
            if(selectedSubRegions.size() > 0 && String.isNotBlank(selectedSubRegions[0])){
                itemQuery += ' AND Account__r.Sub_Region__c IN (\'' + String.join(selectedSubRegions,'\',\'') + '\')';
            }
            itemQuery += ' ORDER BY Account__r.Country__c';
            
        
            weeklyItems = Database.query(itemQuery);
            
            if(weeklyItems.size() == 0)
                return countries;
            //System.debug('Weekly Data: ' + weekly[0].Id + ' Size ' + weekly.size());              
            
            String[] countrylist = new String[]{};
            countryMap.clear();
            for(Weekly_Report_Item__c wi : weeklyItems){
                if(String.isNotBlank(wi.Account__r.Country__c) && !countryMap.containsKey(wi.Account__r.Country__c))    
                    countryMap.put(wi.Account__r.Country__c, wi.Account__r.Country__c);
            }
            countryList.addAll(countryMap.keyset());
            countryList.sort();
            for(String country : countryList)
                countries.add(new SelectOption(country, countryMap.get(country)));  
            
            system.debug('Country list: ' + countries.size());
        }
        catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
                  'Too many filters attempted, please refresh the page to proceed.'
                   + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }           
        return countries;
    }

    public List<SelectOption> getAllAccounts(){
        showResult = false;
        List<SelectOption> accounts = new List<SelectOption>{getAllOption()};

        string query = 'SELECT Id FROM Weekly_Report__c WHERE Name != null';
        if(String.isNotBlank(function))
            query += ' AND Function__c = \'' + function + '\'';
        if(String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' AND Week_Ending__c = : temp';
        }
        try{
            weekly = Database.query(query);

            weeklyIds.clear();  
            for(Weekly_Report__c wr : weekly)
                weeklyIds.add(wr.Id);

            string itemQuery = 'SELECT Account__r.Id, Account__r.Name FROM Weekly_Report_Item__c'
                      + ' WHERE Weekly_Report__c IN :weeklyIds';
                       if( businessGrpFilter != '' ){       
                itemQuery =  itemQuery + ' AND Account__r.Business_Group__c = :businessGrpFilter';
            }
            if(String.isNotBlank(business)){
                itemQuery += ' AND Business__c = :business';
            }
            if(String.isNotBlank(businessgroup)){
                itemQuery += ' AND Account__r.Business_Group__c = :businessgroup';
            }
            if(String.isNotBlank(selectedRegions[0])){
                itemQuery += ' AND Account__r.Region__c IN (\'' + String.join(selectedRegions,'\',\'') + '\')';
            }
            if(selectedSubRegions.size() > 0 && String.isNotBlank(selectedSubRegions[0])){
                itemQuery += ' AND Account__r.Sub_Region__c IN (\'' + String.join(selectedSubRegions,'\',\'') + '\')';
            }
            if(selectedCountries.size() > 0 && String.isNotBlank(selectedCountries[0])){
                itemQuery += ' AND Account__r.Country__c IN (\'' + String.join(selectedCountries,'\',\'') + '\')';
            }
            itemQuery += ' ORDER BY Account__r.Name';

            weeklyItems = Database.query(itemQuery);

            if(weeklyItems.size() == 0)
                return accounts;
            //System.debug('Weekly Data: ' + weekly[0].Id + ' Size ' + weekly.size());              
            
            String[] accountlist = new String[]{};
            accountMap.clear();
            for(Weekly_Report_Item__c wi : weeklyItems){
                system.debug('Account added to map: ' + wi.Account__r.Name);
                if(String.isNotBlank(wi.Account__r.Id) && !accountMap.containsKey(wi.Account__r.Id)){
                    accountMap.put(wi.Account__r.Id, wi.Account__r.Name);
                    accounts.add(new SelectOption(wi.Account__r.Id, wi.Account__r.Name));
                }
            }
            /*
            accountList.addAll(accountMap.keyset());
            for(String acct : accountList)
                accounts.add(new SelectOption(acct, accountMap.get(acct))); 
            */
            system.debug('Account list: ' + accounts.size());
        }
        catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
              'Too many filters attempted, please refresh the page to proceed. '
                 + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }           
        return accounts;
    }

    public List<SelectOption> getAllUsers(){
        showResult = false;
        List<SelectOption> users = new List<SelectOption>{getAllOption()};
        
        string query = 'SELECT Id FROM Weekly_Report__c WHERE Name != null';
        if(String.isNotBlank(function))
            query += ' AND Function__c = \'' + function + '\'';

        if(String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' AND Week_Ending__c = : temp';
        }
        
        try{
            weekly = Database.query(query);
        
            weeklyIds.clear();  
            for(Weekly_Report__c wr : weekly)
                weeklyIds.add(wr.Id);

            string itemQuery = 'SELECT CreatedById, CreatedBy.Name FROM Weekly_Report_Item__c WHERE Weekly_Report__c IN :weeklyIds';
            if( businessGrpFilter != '' ){       
                itemQuery =  itemQuery + ' AND Account__r.Business_Group__c = :businessGrpFilter';
            }
            if(String.isNotBlank(business)){
                itemQuery += ' AND Business__c = :business';
            }
            if(String.isNotBlank(selectedRegions[0])){
                itemQuery += ' AND Account__r.Region__c IN (\'' + String.join(selectedRegions,'\',\'') + '\')';
            }
            if(selectedSubRegions.size() > 0 && String.isNotBlank(selectedSubRegions[0])){
                itemQuery += ' AND Account__r.Sub_Region__c IN (\'' + String.join(selectedSubRegions,'\',\'') + '\')';
            }
            if(selectedCountries.size() > 0 && String.isNotBlank(selectedCountries[0])){
                itemQuery += ' AND Account__r.Country__c IN (\'' + String.join(selectedCountries,'\',\'') + '\')';
            }
            if(selectedAccounts.size() > 0 && String.isNotBlank(selectedAccounts[0])){
                itemQuery += ' AND Account__c IN :selectedAccounts';
            }
            itemQuery += ' ORDER BY CreatedBy.Name';

            weeklyItems = Database.query(itemQuery);

            if(weeklyItems.size() == 0)
                return users;
            //System.debug('Weekly Data: ' + weekly[0].Id + ' Size ' + weekly.size());              
            
            String[] userlist = new String[]{};
            userMap.clear();
            for(Weekly_Report_Item__c wi : weeklyItems){
                system.debug('User added to map: ' + wi.CreatedBy.Name);
                if(!userMap.containsKey(wi.CreatedById)){
                    userMap.put(wi.CreatedById, wi.CreatedBy.Name);
                    users.add(new SelectOption(wi.CreatedById, wi.CreatedBy.Name));
                }
            }
            /*
            userList.addAll(userMap.keyset());
            for(String user : userList)
                users.add(new SelectOption(user, userMap.get(user)));   
            */
            system.debug('User list size: ' + users.size());    
        }
        catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
                   'Too many filters attempted, please refresh the page to proceed. '
                   + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }

        return users;
    }

    public List<SelectOption> getIncludeOptions(){
        List<SelectOption> includes = new List<SelectOption>{getAllOption()};
        includes.add(new SelectOption('Y', 'YES'));
        includes.add(new SelectOption('N', 'NO'));
        return includes;
    }

    public List<Weekly_Report_Item__c> getWeeklyItems(){        
        string query = 'SELECT Id FROM Weekly_Report__c WHERE Name != null';
        if (String.isNotBlank(function))
            query += ' AND Function__c = \'' + function + '\'';
        
        if (String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' AND Week_Ending__c = : temp';
        }
                        
        system.debug('Query: ' + query);
        try {
            weekly = Database.query(query);

            weeklyIds.clear();
            for (Weekly_Report__c wr : weekly) {
                system.debug('Output Weekly Id: ' + wr.Id);
                weeklyIds.add(wr.Id);
            }
            
            /**
             * Modified by prelude
             */ 
             
            /// Add the program,time period and competitive product fields to the item query
            string itemQuery = 'SELECT CreatedDate,CreatedById,Program__c,Time_Period__c,Competitive_Product__c,Account__r.Business_Group__c,CreatedBy.Name, Summary__c, ' 
                + ' Account__c, Account__r.PublicCalendar__c, Account__r.Name, '
                + ' Account__r.Friendly_Account_Name__c, Account__r.Region__c, '
                + ' Account__r.Sub_Region__c, Account__r.Country__c, Include_In_Report__c,'
                + ' Friendly_Account_Name__c, Region__c, Country__c, Category__c, '
                + ' Sub_Category__c, Function__c, Business__c, Weekly_Report__r.Name, '
                + ' Region_Sort_Order__c '
                + ' FROM Weekly_Report_Item__c WHERE Weekly_Report__c IN :weeklyIds';

                
            
             if( businessGrpFilter != ''){       
                itemQuery =  itemQuery + ' AND Account__r.Business_Group__c = :businessGrpFilter ';
            }
            
            if(String.isNotBlank(businessgroup)){
                itemQuery += ' AND Account__r.Business_Group__c = :businessgroup';
            }
            if(String.isNotBlank(business)){
                itemQuery += ' AND Business__c = :business';
            }

            if(String.isNotBlank(selectedRegions[0])){
                itemQuery += ' AND Account__r.Region__c IN (\'' + String.join(selectedRegions,'\',\'') + '\')';
            }

            if(selectedSubRegions.size() > 0 && String.isNotBlank(selectedSubRegions[0])){
                itemQuery += ' AND Account__r.Sub_Region__c IN (\'' + String.join(selectedSubRegions,'\',\'') + '\')';
            }

            if(selectedCountries.size() > 0 && String.isNotBlank(selectedCountries[0])){
                itemQuery += ' AND Account__r.Country__c IN (\'' + String.join(selectedCountries,'\',\'') + '\')';
            }

            if(selectedAccounts.size() > 0 && String.isNotBlank(selectedAccounts[0])){
                itemQuery += ' AND Account__c IN :selectedAccounts';
            }   

            if(userIds.size() > 0 && String.isNotBlank(userIds[0])){
                itemQuery += ' AND CreatedByID IN :userIds';
            }

            if(String.isNotBlank(included)){
                if(included == 'Y')
                    itemQuery += ' AND Include_in_Report__c = true';
                else
                    itemQuery += ' AND Include_in_Report__c = false';
            }
            
            if (selectedCalendars.size() > 0 && String.isNotBlank(selectedCalendars[0])) {
                itemQuery += ' AND Account__r.PublicCalendar__c IN :selectedCalendars';
            }
            
            /**
             * Modified By Prelude
             */
             
            /// add the filters Programs__c, TimePeriod and CompetitiveProduct
            string selectedProgram = weeklyRprtItem.Program__c;
            if(String.isNotBlank(selectedProgram))
            {
                itemQuery += ' AND Program__c = :selectedProgram';
            }

            string timePeriod = weeklyRprtItem.Time_Period__c;
            itemQuery += ' AND Time_Period__c = :timePeriod ';

            string selectedCompProduct = weeklyRprtItem.Competitive_Product__c;
            if(String.isNotBlank(selectedCompProduct))
            {
                itemQuery += ' AND Competitive_Product__c = : selectedCompProduct ';
            }
        
            String orderByQuery = ' ORDER BY Function__c, Category__c, Region_Sort_Order__c, '
                      +  ' Account__r.Friendly_Account_Name__c, CreatedBy.Name';

            // For exporting weekly items to word doc
            system.debug(itemQuery + orderByQuery);
         
            weeklyItems = Database.query(itemQuery + orderByQuery);


            highlights.clear();
            marketIntelligence.clear();
            nextWeeksPriorities.clear();
            keyHighlights.clear();
            upcomingMeetings.clear();

            for (Weekly_Report_Item__c wri : weeklyItems) {
                if(wri.Category__c == 'Highlights')
                    highlights.add(wri);
                if(wri.Category__c == 'Market Intelligence')
                    marketIntelligence.add(wri);
                if(wri.Category__c == 'Next Week\'s Priorities')
                    nextWeeksPriorities.add(wri);
                if(wri.Category__c == 'Key Highlights')
                    keyHighlights.add(wri);
                if(wri.Category__c == 'Upcoming Meetings')
                    upcomingMeetings.add(wri);
            }
            
            // For exporting weekly items to word doc by function, creator ********/
            orderByQuery = ' ORDER BY Function__c, CreatedBy.Name';
            system.debug(itemQuery + orderByQuery);
            
            weeklyItemsByCreator = Database.query(itemQuery + orderByQuery);

            highlightsByCreator.clear();
            marketIntelligenceByCreator.clear();
            nextWeeksPrioritiesByCreator.clear();
            keyHighlightsByCreator.clear();
            upcomingMeetingsByCreator.clear();

            for (Weekly_Report_Item__c wri : weeklyItemsByCreator) {
                if(wri.Category__c == 'Highlights')
                    highlightsByCreator.add(wri);
                if(wri.Category__c == 'Market Intelligence')
                    marketIntelligenceByCreator.add(wri);
                if(wri.Category__c == 'Next Week\'s Priorities')
                    nextWeeksPrioritiesByCreator.add(wri);
                if(wri.Category__c == 'Key Highlights')
                    keyHighlightsByCreator.add(wri);
                if(wri.Category__c == 'Upcoming Meetings')
                    upcomingMeetingsByCreator.add(wri);
            }
        } catch(Exception ex){
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
                    'Too many filters attempted, please refresh the page to proceed. ' 
                                                              + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }
        
        return weeklyItems;
    }

    public string getWeeklyItemsList(){
        List<Id> weeklyItemIds = new List<Id>();
        String weeklyIdsList = '';

        string query = 'SELECT Id FROM Weekly_Report__c WHERE Name != null';
        if(String.isNotBlank(function))
            query += ' AND Function__c = \'' + function + '\'';
        if(String.isNotBlank(weekEnding)){
            Date temp =  date.valueOf(weekEnding);
            query += ' AND Week_Ending__c = : temp';
        }
                        
        system.debug('Query: ' + query);
        try {
            weekly = Database.query(query); 
        
            weeklyIds.clear();
            for(Weekly_Report__c wr : weekly){
                system.debug('Output Weekly Id: ' + wr.Id);
                weeklyIds.add(wr.Id);
            }
            
            /**
             * Modified by prelude
             */ 
             
            /// Add the program,time period and competitive product fields to the item query
            string itemQuery = 'SELECT CreatedById,CreatedBy.Name,Summary__c,Program__c,Time_Period__c,Account__r.Business_Group__c,Competitive_Product__c,Account__c,'
                                + ' Account__r.Name, Account__r.Friendly_Account_Name__c,'
                                + ' Account__r.Region__c, Account__r.Sub_Region__c,'
                                + ' Account__r.Country__c, Include_In_Report__c,'
                                + ' Category__c, Sub_Category__c, Function__c, Business__c,'
                                + ' Weekly_Report__r.Name '
                                + ' FROM Weekly_Report_Item__c '
                                + ' WHERE Weekly_Report__c IN :weeklyIds';


                if( businessGrpFilter != '' ){       
                itemQuery =  itemQuery + ' AND Account__r.Business_Group__c = :businessGrpFilter';
            }       
            
            if(String.isNotBlank(business)){
                itemQuery += ' AND Business__c = :business';
            }
            
            if(String.isNotBlank(businessgroup)){
                itemQuery += ' AND Account__r.Business_Group__c = :businessgroup';
            }

            if(String.isNotBlank(selectedRegions[0])){
                itemQuery += ' AND Account__r.Region__c IN (\'' + String.join(selectedRegions,'\',\'') + '\')';
            }

            if(selectedSubRegions.size() > 0 && String.isNotBlank(selectedSubRegions[0])){
                itemQuery += ' AND Account__r.Sub_Region__c IN (\'' + String.join(selectedSubRegions,'\',\'') + '\')';
            }
            
            if(selectedCountries.size() > 0 && String.isNotBlank(selectedCountries[0])){
                itemQuery += ' AND Account__r.Country__c IN (\'' + String.join(selectedCountries,'\',\'') + '\')';
            }
            
            if(selectedAccounts.size() > 0 && String.isNotBlank(selectedAccounts[0])){
                itemQuery += ' AND Account__c IN :selectedAccounts';
            }
            
            if(userIds.size() > 0 && String.isNotBlank(userIds[0])){
                itemQuery += ' AND CreatedByID IN :userIds';
            }
            
            if(String.isNotBlank(included)){
                if(included == 'Y')
                    itemQuery += ' AND Include_in_Report__c = true';
                else
                    itemQuery += ' AND Include_in_Report__c = false';
            }

            if(selectedCalendars.size() > 0 && String.isNotBlank(selectedCalendars[0])){
                itemQuery += ' AND Account__r.PublicCalendar__c IN :selectedCalendars';
            }
          
            /**
             * Modified By Prelude
             */
             
            /// add the filters Programs__c, TimePeriod and CompetitiveProduct
            string selectedProgram = weeklyRprtItem.Program__c;
            if(String.isNotBlank(selectedProgram))
            {
                itemQuery += ' AND Program__c = :selectedProgram';
            }

            string timePeriod = weeklyRprtItem.Time_Period__c;
            itemQuery += ' AND Time_Period__c = :timePeriod ';

            string selectedCompProduct = weeklyRprtItem.Competitive_Product__c;
            if(String.isNotBlank(selectedCompProduct))
            {
                itemQuery += ' AND Competitive_Product__c = : selectedCompProduct ';
            }

            itemQuery += ' ORDER BY Function__c, Category__c, '
                       + 'Account__r.Friendly_Account_Name__c, CreatedBy.Name';

            weeklyItems = Database.query(itemQuery);

            for(Weekly_Report_Item__c wi : weeklyItems)
                weeklyItemIds.add(wi.Id);

            system.debug('weeklyItemIds size: ' + weeklyItemIds.size());
            weeklyIdsList = string.join(weeklyItemIds, ',');
            system.debug('weeklyIdsList: ' + weeklyIdsList);
        } catch(Exception ex) {
            ApexPages.Message pageMsg = new ApexPages.Message(ApexPages.Severity.Error,
                      'Too many filters attempted, please refresh the page to proceed. ' 
                      + ex.getMessage());
            ApexPages.addMessage(pageMsg);
        }

        return weeklyIdsList;       
    }

    public List<SelectOption> getPublicCalendars() {
        List<SelectOption> cals = new List<SelectOption>();
        List<PublicCalendar__c> pcals = PublicCalendar__c.getall().values();
        
        cals.add(getAllOption());
        
        for (PublicCalendar__c pc : pcals) {
            if (pc.Active__c && pc.GTM__c)
                cals.add(new SelectOption(pc.name, pc.name));
        }
        cals.sort();
        return cals;
    }
    
    public SelectOption getNoneOption() {
        return new SelectOption('', '---None---');
    }
    
    public SelectOption getAllOption() {
        return new SelectOption('', '---All---');
    }

    public PageReference ShowReport(){
        
        showResult = true;
    
        return null;
    }

    public PageReference toggleGrid(){
        if(showGrid){
            showGrid = false;
            toggleButtonText = 'Edit Weekly';
        }
        else{
            showGrid = true;
            toggleButtonText = 'Show Table';
        }
        showResult = true;
        return null;
    }

    public PageReference clearAllFilters(){
        showResult = false;
        function = '';
        weekEnding = '';
        userIds = new String[]{''};
        selectedRegions = new String[]{''};
        selectedSubRegions = new String[]{''};
        selectedCountries = new String[]{''};   
        return null;
    }
    
    public PageReference clearAcctFilters(){
        showResult = false;
        userIds = new String[]{''};
        selectedRegions = new String[]{''};
        selectedSubRegions = new String[]{''};
        selectedCountries = new String[]{''};
        selectedAccounts = new String[]{''};
        return null;
    }
}