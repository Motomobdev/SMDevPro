public without sharing class Campaign_Timeline {

    private final string SELECT_ALL_LABEL = '--All--';
    private final string SELECT_ALL_VALUE = '';
 
    List<Account> accountlist; 
    List<Campaign> campaignlist; 
    public String selectedProgram {get; set;}
    public String selectedProject {get; set;}
    public String selectedProduct {get; set;} 
    
    public String[] selectedRegions{get; set;} {
        selectedRegions = new String[]{''};      
    }  
    public String[] selectedSubRegions{get; set;} {
        selectedSubRegions = new String[]{''}; 
    }
    public String[] selectedCountries{get; set;} {
        selectedCountries = new String[]{''};
    }
    public String[] selectedAccounts{get; set;} {
        selectedAccounts = new String[]{''};
    }

    Map<String, String> countryMap = new Map<String, String>();
    Map<String, String> accountMap = new Map<String, String>();  

    public List<SelectOption> regions {get; set;}
    public List<SelectOption> subRegions {get; set;}
    public List<SelectOption> countries {get; set;}
    public List<SelectOption> accounts {get; set;}

    public List<SelectOption> programs {get; set;}
    public List<SelectOption> projects {get; set;}
    public List<SelectOption> products {get; set;}
    public List<SelectOption> portfolioSegments {get; set;}
    public List<SelectOption> campaignStatus {get; set;}
    
    public String selectedPortfolioSegment {get; set;}
    public String selectedCampaignStatus {get; set;}

    map<String, Set<String>> regionSubRegionMap = new map<String, Set<String>>();
    map<String, Set<String>> subRegionCountryMap = new map<String, Set<String>>();
    map<String, Set<Account>> countryAccountMap = new map<String, Set<Account>>();

    public Campaign cmpg {get; set;}
    public Account acct {get; set;}

    public List<Campaign> campaigns {get; set;}

    public RecordType promotionRecordType;
    private Map<PMD_Program__c, Map<PMD_Project__c, Set<Product2>>> programMap =
        new Map<PMD_Program__c, Map<PMD_Project__c, Set<Product2>>>();

    public Campaign_Timeline(ApexPages.StandardController ctrl) {

        promotionRecordType = [select id from RecordType where SobjectType = 'Campaign'
        and name = 'Promotion' LIMIT 1];
        reset();

        selectedRegions = new String[]{''};
        selectedSubRegions = new String[]{''};
        selectedCountries = new String[]{''};
        selectedAccounts = new String[]{''};
        
        populateAccountDetails();
        populateportfolioSegments();
        populateCampaignStatus();
        
        submit();
    }

    public void populateAccountDetails() {
		// You cannot show more than 300 entries in a picklist
        List<Account> accounts = 
            [Select Region__c,Sub_Region__c,Country__c,Name,Id
             From Account
             WHERE id in ( select account__c from Campaign 
                          where recordtypeid = :promotionRecordType.Id)
             AND Region__c != null
             AND Sub_Region__c != null
             Order By Region__c,Sub_Region__c,Country__c,Name
            LIMIT 300];
        
        for (Account a : accounts) {
            
            Set<String> temp = regionSubRegionMap.get(a.Region__c);
            if (temp == null)
                regionSubRegionMap.put(a.region__c, new Set<String>{a.sub_region__c});
            else
                temp.add(a.sub_region__c);

		 	temp = subRegionCountryMap.get(a.sub_region__c);
            if (temp == null)
                subRegionCountryMap.put(a.sub_region__c, new Set<String>{a.country__c});
            else
                temp.add(a.country__c);

		 	Set<Account> tempAccountSet = countryAccountMap.get(a.country__c);
            if (tempAccountSet == null)
                countryAccountMap.put(a.country__c, new Set<Account>{a});
            else
                tempAccountSet.add(a);
        }
        
        populateRegions();
    }

    public PageReference populateRegions() {
		regions = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};

        selectedRegions = new String[]{''};
        selectedSubRegions = new String[]{''};
        selectedCountries = new String[]{''};
        selectedAccounts = new String[]{''};

        for (String region : regionSubRegionMap.keySet())
            regions.add(new SelectOption(region, region));
 
        return null;
    }

    public PageReference populateSubRegions(){
    	subRegions = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};                        

        selectedSubRegions = new String[]{''};
        selectedCountries = new String[]{''};
        selectedAccounts = new String[]{''};
        
        if (selectedRegions[0] != SELECT_ALL_VALUE)
            for (String region : selectedRegions)
            	if (region != null && regionSubRegionMap.containsKey(region))
                    for (String subRegion : regionSubRegionMap.get(region))
                        subRegions.add(new SelectOption(subRegion, subRegion));
 
        return null;
    }
    
    public PageReference populateCountries() {

    	countries = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};                        

        selectedCountries = new String[]{''};
        selectedAccounts = new String[]{''};

        system.debug('selectedSubRegions: ' + selectedSubRegions + ', ' + selectedSubRegions.size());
        if (selectedSubRegions[0] != SELECT_ALL_VALUE)
            for (String subRegion : selectedSubRegions) {
                system.debug(subRegion);
                if (subRegion != null && subRegionCountryMap.containsKey(subRegion)) {
                    system.debug(subRegionCountryMap.get(subRegion));
                    for (String country : subRegionCountryMap.get(subRegion))
                        countries.add(new SelectOption(country, country));
                }
            }
        return null;
    }
    
    public PageReference populateAccounts() {

    	accounts = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};                        
		List<SelectOption> accountsTemp = new List<SelectOption>();
        
        selectedAccounts = new String[]{''};

        if (selectedCountries[0] != SELECT_ALL_VALUE)
            for (String country : selectedCountries)
            	if (countryAccountMap.containsKey(country))
                    for (Account a : countryAccountMap.get(country))
                        accountsTemp.add(new SelectOption(a.name, a.id));

        // Sorts on select option label
        accountsTemp.sort();
        
        for (SelectOption so : accountsTemp)
            accounts.add(new SelectOption(so.getLabel(), so.getValue()));

        return null;
    }

    private void populateCampaignStatus() {
        campaignStatus = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};

        Schema.DescribeFieldResult fieldResult = Campaign.Status.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f : ple) {
            system.debug(f);
            campaignStatus.add(new SelectOption(f.getValue(), f.getLabel()));
        }
    }

    private void populateportfolioSegments() {
        portfolioSegments = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};

        Schema.DescribeFieldResult fieldResult = PMD_Product__c.Product_Segment__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f : ple) {
            portfolioSegments.add(new SelectOption(f.getValue(), f.getLabel()));
        }
    }

    public PageReference reset() {
        cmpg = new Campaign();
        Date today = System.today();

        // Default to 4 months
        cmpg.startDate = today.addMonths(-2);
        cmpg.endDate = today.addMonths(2);

        acct = new Account();

        regions = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};
        subRegions = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};
        countries = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};
        accounts = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};
        
        programs = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};
        projects = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};
        products = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};

        selectedRegions = new String[]{''};
        selectedSubRegions = new String[]{''};
        selectedCountries = new String[]{''};
        selectedAccounts = new String[]{''};
        selectedProgram  = null;
        selectedProject = null;
        selectedProduct = null;
        selectedPortfolioSegment = null;
        selectedCampaignStatus = null;
        
       	populateRegions();
        populateportfolioSegments();
        populateCampaignStatus();

        campaigns = null;
        return null;
    }

    public PageReference submit() {

        if (promotionRecordType == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'The promotion record type is missing. Contact your system administrator');
            ApexPages.addMessage(myMsg);
            return null;
        }

        // These 2 local variables are created because the class
        // variables are NOT visible to the dynamic SOQL
        Date sd = cmpg.startDate;
        Date ed = cmpg.endDate;

        // Select campaigns that are/were/will-be active in the given date range
        String soql =   'SELECT id, name, startDate, endDate, status, account__c, ' +
                            'type, category__c, sub_category__c, target__c, ' +
                            'account__r.name, account__r.region__c,' +
                            'account__r.sub_region__c, account__r.country__c, ' +
                            'account__r.friendly_account_name__c ' +
                        'FROM Campaign ' +
                        'WHERE recordtypeid = \'' + promotionRecordType.id + '\'' +
                            ' AND ((startDate >= :sd AND startDate <= :ed)' +
                                'OR (endDate >= :sd AND endDate <= :ed))';

        if (selectedRegions != null && selectedRegions[0] != SELECT_ALL_VALUE)
            soql += ' AND account__r.region__c in  (\'' + String.join(selectedRegions,'\',\'') + '\')';
        if (selectedSubRegions != null && selectedSubRegions[0] != SELECT_ALL_VALUE)
            soql += ' AND account__r.sub_region__c in  (\'' + String.join(selectedSubRegions,'\',\'') + '\')';
        if (selectedCountries != null && selectedCountries[0] != SELECT_ALL_VALUE)
            soql += ' AND account__r.country__c in  (\'' + String.join(selectedCountries,'\',\'') + '\')';
        if (selectedAccounts != null && selectedAccounts[0] != SELECT_ALL_VALUE)
            soql += ' AND account__c in  (\'' + String.join(selectedAccounts,'\',\'') + '\')';
        if (cmpg.category__c != null)
            soql += ' AND category__c = \'' + cmpg.category__c + '\'';
        if (cmpg.sub_category__c != null)
            soql += ' AND sub_category__c = \'' + cmpg.sub_category__c + '\'';
        if (cmpg.target__c != null)
            soql += ' AND target__c = \'' + cmpg.target__c + '\'';
        if (cmpg.type != null)
            soql += ' AND type = \'' + cmpg.type + '\'';
        if (selectedCampaignStatus != null && selectedCampaignStatus != SELECT_ALL_VALUE)
            soql += ' AND status = \'' + selectedCampaignStatus + '\'';

        // PMD Product and SFDC Product have one to one relation
        if (selectedPortfolioSegment != null && selectedPortfolioSegment != SELECT_ALL_VALUE ||
            selectedProgram != null && selectedProgram != SELECT_ALL_VALUE ||
            selectedProject != null && selectedProject != SELECT_ALL_VALUE ||
            selectedProduct != null && selectedProduct != SELECT_ALL_VALUE ) {

            // Portfolio segment must be selected if program, project or product are selected
            soql += ' AND ID in (select campaign__c from Campaign_Product__c where ';

            // CP = Companion Product
            // For CPs, the program, project and product fields are empty since
            // CPs are not managed in PMD yet
            if (selectedPortfolioSegment == 'CP')
                 soql += ' Product__r.Portfolio_Segment__c = \'' + selectedPortfolioSegment + '\'';
            else
                 soql += ' Product__r.PMD_Product__r.Product_Segment__c = \'' + selectedPortfolioSegment + '\'';

                if (selectedProgram != null && selectedProgram != SELECT_ALL_VALUE)
                    soql += ' AND Product__r.PMD_Product__r.Project_ID__r.Program_ID__c = \'' +
                            selectedProgram.split('-')[0] + '\'';

                if (selectedProject != null && selectedProject != SELECT_ALL_VALUE)
                    soql += ' AND Product__r.PMD_Product__r.Project_ID__c = \'' +
                        selectedProject.split('-')[0] + '\'';

                if (selectedProduct != null && selectedProduct != SELECT_ALL_VALUE)
                    soql += ' AND Product__c = \'' + selectedProduct.split('-')[0] + '\'';

            soql += ')';
        }

        soql += ' ORDER BY account__r.name, startDate';
        system.debug(soql);
        campaigns = Database.query(soql);

        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
        //        'Found ' + campaigns.size() + ' records.');
        //ApexPages.addMessage(myMsg);

        system.debug(JSON.serialize(campaigns));
        return null;
    }

    public PageReference populateProgramMap() {

        // Clear the dependent fields
        programs = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};
        projects = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};
        products = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};

        if (selectedPortfolioSegment != null && selectedPortfolioSegment != SELECT_ALL_VALUE) {

            programMap = new Map<PMD_Program__c, Map<PMD_Project__c, Set<Product2>>>();

            List<Product2> productList =
                    [select PMD_Product__r.Project_ID__r.Program_ID__c,
                            PMD_Product__r.Project_ID__r.Program_ID__r.name,
                            PMD_Product__r.Project_ID__c,
                            PMD_Product__r.Project_ID__r.name,
                            Portfolio_Segment__c,
                            id, name
                        from Product2
                        where PMD_Product__r.Product_Segment__c = :selectedPortfolioSegment
                          and PMD_Product__r.Project_ID__r.Project_Status__c in
                                ('Active', 'On Hold', 'Shipping')
                          order by  PMD_Product__r.Project_ID__r.Program_ID__r.name,
                                    PMD_Product__r.Project_ID__r.name, name
                          LIMIT 300]; // The picklist can only show 300 values

            for (Product2 p : productList) {

                PMD_Program__c pmdProgram = new PMD_Program__c(Id=p.PMD_Product__r.Project_ID__r.Program_ID__c,
                                                            name=p.PMD_Product__r.Project_ID__r.Program_ID__r.name);
                PMD_Project__c pmdProject = new PMD_Project__c(Id=p.PMD_Product__r.Project_ID__c,
                                                            name=p.PMD_Product__r.Project_ID__r.name);

                if (programMap.containsKey(pmdProgram)) {
                    Map<PMD_Project__c, Set<Product2>> prjMap = programMap.get(pmdProgram);

                    if (prjMap.containsKey(pmdProject)) {
                        prjMap.get(pmdProject).add(p);
                    } else { // New Project
                        prjMap.put(pmdProject, new Set<Product2>{p});
                    }
                } else { // New Program
                    Map<PMD_Project__c, Set<Product2>> prjMap =
                        new Map<PMD_Project__c, Set<Product2>>{pmdProject => new Set<Product2>{p}};
                    programMap.put(pmdProgram, prjMap);
                }
            }

            for (PMD_Program__c prg : programMap.keySet()) {
                programs.add(new SelectOption(prg.id + '-' + prg.name, prg.name));
            }
        }

        return null;
    }

    public PageReference populateProjects() {
        projects = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};
        products = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};

        if (selectedProgram != null && selectedProgram != SELECT_ALL_VALUE) {
            String[] s = selectedProgram.split('-');
            system.debug(s[0]);
            PMD_Program__c program = new PMD_Program__c(Id=s[0], Name=s[1]);
            if (programMap.containsKey(program)) {
                Map<PMD_Project__c, Set<Product2>> projectMap = programMap.get(program);

                for (PMD_Project__c prj : projectMap.keySet())
                    projects.add(new SelectOption(prj.id + '-' + prj.name, prj.name));
            }
        }
        return null;
    }

    public PageReference populateProducts() {
        products = new List<SelectOption>{new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL)};

        if (selectedProgram != null && selectedProgram != SELECT_ALL_VALUE &&
            selectedProject != null && selectedProject != SELECT_ALL_VALUE) {

            String[] s = selectedProgram.split('-');
            PMD_Program__c program = new PMD_Program__c(Id=s[0], Name=s[1]);
            if (programMap.containsKey(program)) {
                Map<PMD_Project__c, Set<Product2>> projectMap = programMap.get(program);

                if (projectMap != null) {

                    s = selectedProject.split('-');
                    PMD_Project__c project = new PMD_Project__c(Id=s[0], Name=s[1]);
                    for (Product2 prd : projectMap.get(project))
                        products.add(new SelectOption(prd.id + '-' + prd.name, prd.name));
                }
            }
        }
        return null;
    }

    public String getJsonData() {

        List<Campaign> campaignsClone = campaigns.deepClone(false, true, false);

        for (Campaign c : campaignsClone) {
            if (c.startDate < cmpg.startDate)
                c.startDate = cmpg.startDate;
            if (c.endDate > cmpg.endDate)
                c.endDate = cmpg.endDate;
        }

        return JSON.serialize(campaignsClone);
    }
}