/*******************************************************************************************************
CREATED BY : Lakshman Sateesh
CREATED ON : 24/Aug/2013
PURPOSE    : To implement the Opportunity Forecast for Quantity based on Region,Product and Time based filters. The output is
             grouped by Account,Region,Opportunity Stage or Forecast Category.

TEST CLASS : UCD_Controller_Test.cls
*******************************************************************************************************/
public without sharing class UCD_Controller {

    private final string yearPrefix = 'CY ';
    private final string qtrPrefix = 'Q ';
    private final string periodSuffix = ' Period';
    private final string TOTAL_COLUMN_HEADER = 'TOTAL';
    private final string SELECT_ALL_LABEL = '--All--';
    private final string SELECT_ALL_VALUE = '-1';
    private final string LAYOUT_QTR = 'Quarterly';
    private final string LAYOUT_MONTH = 'Monthly';
    private final string LAYOUT_BOTH = 'Both';
    private final string GRP_BY_REGION = 'Region';
    private final string GRP_BY_SUB_REGION = 'Sub Region';
    private final string GRP_BY_COUNTRY = 'Country';
    private final string GRP_BY_ACCOUNT = 'Account';
    private final string GRP_BY_PRODUCT = 'Product';
    private final string GRP_BY_PROGRAM = 'Program';
    private final string GRP_BY_PROJECT = 'Project';
    private final string GRP_BY_PRODUCT_FAMILY = 'Product Family';
    private final string GRP_BY_OPP_STAGE = 'Opportunity Stage';
    private final string GRP_BY_FORECAST_CAT = 'Forecast Category';
    private final string PIPELINE = 'Pipeline';
    private final string CLOSED = 'Closed';
    private final string COMIT = 'Commit';
    private final string BESTCASE = 'Best Case';
    private final string OMITTED = 'Omitted';
    public string monthViewClass {get{return 'monthView';}set;}
    private Date startDate;         //Start date of the selected time filter
    private Date endDate;           //End date of the selected time filter
    private Date snapshotDate;      // Date of the snapshot selected in the data source dropdown
    private string whereClause;
    private Map<Integer,String> mapNumberToMonth = new Map<Integer,String>{1=>'Jan',2=>'Feb',3=>'Mar',4=>'Apr',5=>'May',6=>'Jun',7=>'Jul',8=>'Aug',9=>'Sep',10=>'Oct',11=>'Nov',12=>'Dec'};
    private map<Integer,Integer> mapMonthToQtr = new map<Integer,Integer>{1=>1,2=>1,3=>1,4=>2,5=>2,6=>2,7=>3,8=>3,9=>3,10=>4,11=>4,12=>4};
    public String selectedRegion {get;set;}
    public String selectedSubRegion {get;set;}
    public String selectedCountry {get;set;}
    public String selectedAccount {get;set;}
    public list<string> selectedProductList {get;set;}
    public set<String> selectedProductSet {get{
                                                selectedProductSet = new set<string>();
                                                selectedProductSet.addAll(selectedProductList);
                                                return selectedProductSet;}set;}
   public list<string> selectedFamilyList {get;set;}
    public set<String> selectedFamilySet {get{
                                                selectedFamilySet = new set<string>();
                                                selectedFamilySet.addAll(selectedFamilyList);
                                                return selectedFamilySet;}set;}
    public String selectedFamily {get;set;}
    public list<string> selectedProjectList {get;set;}
    public String selectedProgram {get;set;}
    public String selectedProject {get;set;}
    public set<String> selectedProjectSet {get{
                                                selectedProjectSet = new set<string>();
                                                selectedProjectSet.addAll(selectedProjectList);
                                                return selectedProjectSet;}set;}
    public list<string> selectedProgramList {get;set;}
    public set<String> selectedProgramSet {get{
                                                selectedProgramSet = new set<string>();
                                                selectedProgramSet.addAll(selectedProgramList);
                                                return selectedProgramSet;}set;}

    public String selectedPortfolio {get;set;}
    public String selectedYear {get;set;}
    public String selectedQtr {get;set;}
    public String selectedPeriods {get;set;}
    public list<string> selectedForecastList {get;set;}
    public set<String> selectedForecastSet {get{
                                                selectedForecastSet = new set<string>();
                                                selectedForecastSet.addAll(selectedForecastList);
                                                return selectedForecastSet;}set;}
    public String selectedOppStage {get;set;}
    public List<string> selectedOppStageList {get;set;}
    public set<String> selectedOppStageset {get{
                                             selectedOppStageset = new set<string>();
                                             selectedOppStageset.addAll(selectedOppStageList);
                                             return selectedOppStageset;}set;}
    public String selectedLayout {get;set;}
    public String selectedGroupBy {get;set;}
    public String selectedDataSource {get;set;} {selectedDataSource = SELECT_ALL_VALUE;}
    public List<SelectOption> regionSelectList {get;set;}
    public List<SelectOption> subRegionSelectList {get;set;}
    public List<SelectOption> countrySelectList {get;set;}
    public List<SelectOption> accountSelectList {get;set;}
    public List<SelectOption> productSelectList {get;set;}
    public List<SelectOption> pdtFamilySelectList {get;set;}
     public List<SelectOption> portfolioSegmentSelectList {get;set;}
    public List<SelectOption> projectSelectList {get;set;}
    public List<SelectOption> programSelectList {get;set;}
    public List<SelectOption> yearSelectList {get;set;}
    public List<SelectOption> qtrSelectList {get;set;}
    public List<SelectOption> periodSelectList {get;set;}
    public List<SelectOption> forecastSelectList {get;set;}
    public List<SelectOption> oppStageSelectList {get;set;}
    public List<SelectOption> layoutSelectList {get;set;}
    public List<SelectOption> groupBySelectList {get;set;}
    public List<ResultWrapper> listOfQtrWrapperObj {get;set;}
    public List<ResultWrapper> listOfMonthWrapperObj {get;set;}
    public List<ResultWrapper> listOfUCDQtrWrapperObj {get;set;}
    public List<ResultWrapper> listOfUCDMonthWrapperObj {get;set;}
    public Map<Id,Account> mapAccountIdToAccount;
    public list<string> qtrHeaders{get;set;}
    public list<String> monthHeaders{get;set;}
    public List<SelectOption> weekNumbers {get; set;} {weekNumbers = new List<SelectOption>();}
    map<String,Set<String>> mapRegionSubRegion = new map<String,Set<String>>();
    map<String,Set<String>> mapSubRegionCountry = new map<String,Set<String>>();
    map<String,Set<Account>> mapCountryAccount = new map<String,Set<Account>>();

    Datetime timeDifference;

    //***Constructor***//
    public UCD_Controller() {
        initRegionFilters();
        initProductFilters();
        initWeekNumber();
        yearSelectList = getYearSelectOptions();
        qtrSelectList = getQuarterSelectOptions();
        periodSelectList = getPeriodSelectOptions();
        forecastSelectList = getForecastSelectOptions();
        oppStageSelectList = getOppStageSelectOptions();
        layoutSelectList = getLayoutSelectOptions();
        groupBySelectList = getGroupBySelectOptions();
        mapAccountIdToAccount = new Map<Id,Account>();
        selectedFamily = SELECT_ALL_VALUE;
        // selectedForecastList = new List<String>{SELECT_ALL_VALUE};
        selectedOppStageList = new List<String>{SELECT_ALL_VALUE};
        selectedFamilyList = new List<String>{SELECT_ALL_VALUE};
        createRegionFiltersMap();
        createProductFiltersMap();
    }

    public void createRegionFiltersMap() {
        Account[] results = [Select Region__c,Sub_Region__c,Country__c,Name,Id
                                From Account
                                Where Region__c != null
                                AND Sub_Region__c != ''
                                AND ownerid != '00540000001qX0C' // Customer interface
                                AND RecordTypeId = '01240000000DpysAAC'
                                AND (Type = 'Customer' OR Type = 'Prospect')
                                Order By Region__c,Sub_Region__c,Country__c];

        Set<String> setSubRegion;
        Set<String> setCountry;
        Set<Account> setAccount;

        for (Account objAccount:results) {
            setSubRegion = new Set<String>();
            setCountry = new Set<String>();
            setAccount = new Set<Account>();

            if (mapRegionSubRegion.containsKey(objAccount.Region__c)  && mapRegionSubRegion.keyset() != null)
                setSubRegion.addAll(mapRegionSubRegion.get(objAccount.Region__c));
            if (mapSubRegionCountry.containsKey(objAccount.Sub_Region__c)  && mapSubRegionCountry.keyset() != null)
                setCountry.addAll(mapSubRegionCountry.get(objAccount.Sub_Region__c));
            if (mapCountryAccount.containsKey(objAccount.Country__c)  && mapCountryAccount.keyset() != null)
                setAccount.addAll(mapCountryAccount.get(objAccount.Country__c));

            setSubRegion.add(objAccount.Sub_Region__c);
            setCountry.add(objAccount.Country__c);
            setAccount.add(objAccount);
            mapRegionSubRegion.put(objAccount.Region__c,setSubRegion);
            mapSubRegionCountry.put(objAccount.Sub_Region__c,setCountry);
            mapCountryAccount.put(objAccount.Country__c,setAccount);
        }
    }

    Map<String,Set<String>> mapFamilyProgram = new Map<String,Set<String>>();
    Map<String,Set<String>> mapProgramProject = new Map<String,Set<String>>();
    Map<String,Set<Product2>> mapProjectProduct = new Map<String,Set<Product2>>();
    Map<String,Set<String>> mapPortfolioFamily = new Map<String,Set<String>>();

    public void createProductFiltersMap() {
         Product2[] results = [Select Program__c,Project__c,Name,Id,Family,Portfolio_Segment__c From Product2
                               Where Portfolio_Segment__c != ''
                               AND Business_Unit__c !=null
                               AND IsActive = True
                               ORDER BY
                               Portfolio_Segment__c,Family,Program__c,Project__c,Name];

         Set<String> setProgram;
         Set<String> setProject;
         Set<Product2> setProduct;
         Set<String> setPortfolioFamily;
         for (Product2 objProduct : results) {
            setProgram = new Set<String>();
            setProject = new Set<String>();
            setProduct = new Set<Product2>();
            setPortfolioFamily = new Set<String>();

            if (mapPortfolioFamily.containsKey(objProduct.Portfolio_Segment__c)&& mapPortfolioFamily.keyset() != null)
                setPortfolioFamily.addAll(mapPortfolioFamily.get(objProduct.Portfolio_Segment__c));
            if (mapFamilyProgram.containsKey(objProduct.Portfolio_Segment__c+''+objProduct.Family)  && mapFamilyProgram.keyset() != null)
                setProgram.addAll(mapFamilyProgram.get(objProduct.Portfolio_Segment__c+''+objProduct.Family));
            if (mapProgramProject.containsKey(objProduct.Portfolio_Segment__c+''+objProduct.Family+''+objProduct.Program__c)  && mapProgramProject.keyset() != null)
                setProject.addAll(mapProgramProject.get(objProduct.Portfolio_Segment__c+''+objProduct.Family+''+objProduct.Program__c));
            if (mapProjectProduct.containsKey(objProduct.Portfolio_Segment__c+''+objProduct.Family+''+objProduct.Program__c+''+objProduct.Project__c)  && mapProjectProduct.keyset() != null)
                setProduct.addAll(mapProjectProduct.get(objProduct.Portfolio_Segment__c+''+objProduct.Family+''+objProduct.Program__c+''+objProduct.Project__c));

            setPortfolioFamily.add(objProduct.Family);
            setProgram.add(objProduct.Program__c);
            setProject.add(objProduct.Project__c);
            setProduct.add(objProduct);
            mapPortfolioFamily.put(objProduct.Portfolio_Segment__c,setPortfolioFamily);
            mapFamilyProgram.put(objProduct.Portfolio_Segment__c+''+objProduct.Family,setProgram);
            mapProgramProject.put(objProduct.Portfolio_Segment__c+''+objProduct.Family+''+objProduct.Program__c,setProject);
            mapProjectProduct.put(objProduct.Portfolio_Segment__c+''+objProduct.Family+''+objProduct.Program__c+''+objProduct.Project__c,setProduct);
         }
    }

    public pagereference resetAllFilters() {
        initRegionFilters();
        initProductFilters();
        yearSelectList = getYearSelectOptions();
        qtrSelectList = getQuarterSelectOptions();
        periodSelectList = getPeriodSelectOptions();
        forecastSelectList = getForecastSelectOptions();
        oppStageSelectList = getOppStageSelectOptions();
        layoutSelectList = getLayoutSelectOptions();
        groupBySelectList = getGroupBySelectOptions();
        mapAccountIdToAccount = new Map<Id,Account>();
        selectedRegion = '';
        selectedSubRegion =  '';
        selectedCountry =  '';
        selectedAccount = '';
        selectedFamily = '';
        selectedProjectList = new List<String>{SELECT_ALL_VALUE};
        selectedProgramList = new List<String>{SELECT_ALL_VALUE};
        selectedProductList = new List<String>{SELECT_ALL_VALUE};
        selectedFamilyList = new List<String>{SELECT_ALL_VALUE};
        //selectedYear = '';
        //selectedQtr = '';
        selectedPeriods = '';
        //selectedForecastList = new List<String>{SELECT_ALL_VALUE};
        selectedOppStage = '';
        selectedOppStageList = new List<String>{SELECT_ALL_VALUE};
        selectedLayout = '';
        selectedGroupBy = '';
        selectedDataSource = SELECT_ALL_VALUE;
        snapshotDate = null;
        listOfQtrWrapperObj = null;
        listOfUCDQtrWrapperObj = null;
        listOfMonthWrapperObj = null;
        listOfUCDMonthWrapperObj = null;
        selectedPortfolio = '';
        return null;
    }

    //*** Constructor without any initialization of parameters ***//
    public UCD_Controller(Boolean isBlank) {}

    public PageReference xlsExport() {
        pageReference ref = new PageReference('/apex/UCD_Xls_Export');
        return ref;
    }

    /*******************************************************************************************************
    PURPOSE    : Initialize or reset week numbers dropdown
                (Data source: Opportunity snapshot object)
    *******************************************************************************************************/
    private void initWeekNumber() {
        List<AggregateResult> ars = 
            [SELECT WEEK_IN_YEAR(Snapshot_Date__c) weeknum, Snapshot_Date__c sdate
             FROM Opportunity_Snapshot_Date__c
             GROUP BY Snapshot_Date__c
             ORDER BY Snapshot_Date__c DESC
            LIMIT 52];

        weekNumbers.add(new SelectOption(SELECT_ALL_VALUE, 'Real time'));

        for (AggregateResult ar : ars) {
            Date dt = (Date)ar.get('sdate');
            String val = dt.year() + '-' + dt.month() + '-' + dt.day();
            weekNumbers.add(new SelectOption(val, 'W' + ar.get('weeknum') + ' : ' + val));
        }
    }

    /*******************************************************************************************************
    PURPOSE    : Initialize or reset the Region,Subregion and Country related filters
    *******************************************************************************************************/
    private void initRegionFilters() {
        regionSelectList = getRegionSelectOptions();
        subRegionSelectList = new List<SelectOption>();
        countrySelectList =  new List<SelectOption>();
        accountSelectList =  new List<SelectOption>();
        resetsubRegionSelectList();
        resetCountrySelectList();
        resetAccountSelectList();
    }

    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Region select options based on available values on Account object
    *******************************************************************************************************/
    public List<SelectOption> getRegionSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
        Schema.DescribeFieldResult fieldResult = Account.Region__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getValue(), f.getLabel()));
        }
        return options;
    }

    /*******************************************************************************************************
    PURPOSE    : Populate the SubRegion select options based on the selected Region value
    *******************************************************************************************************/
    public PageReference updateSubRegionFilters() {

        resetSubRegionSelectList();
        resetCountrySelectList();
        updateAccountFilters();

        if (selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE) {
            List<SelectOption> tempListSelectOption =  new List<SelectOption>();
            if (mapRegionSubRegion.containskey(selectedRegion)) {
                for (String strSubRegion : mapRegionSubRegion.get(selectedRegion)) {
                    tempListSelectOption.add(new SelectOption(strSubRegion,strSubRegion));
                }
                tempListSelectOption= SortOptionList(tempListSelectOption);
                subRegionSelectList.addAll(tempListSelectOption);
            }
        }
        return null;
    }

    /*******************************************************************************************************
    PURPOSE    : Populate the Country select options based on the selected Region and SubRegion values
    *******************************************************************************************************/
    public PageReference updateCountryFilters() {

        resetCountrySelectList();
        updateAccountFilters();

        if (selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE && selectedSubRegion != NULL && selectedSubRegion != SELECT_ALL_VALUE) {
          List<SelectOption> tempListSelectOption =  new List<SelectOption>();
            if (mapSubRegionCountry.containskey(selectedSubRegion)) {
                for (String strCountry : mapSubRegionCountry.get(selectedSubRegion)) {
                    if (strCountry!=null)
                    tempListSelectOption.add(new SelectOption(strCountry,strCountry));
                }
            }

            tempListSelectOption = SortOptionList(tempListSelectOption);
            countrySelectList.addall(tempListSelectOption);
        }

        return null;
    }

    /*******************************************************************************************************
    PURPOSE    : Populate the Account select options based on the selected Region,SubRegion and County values
    *******************************************************************************************************/
    public PageReference updateAccountFilters() {

        resetAccountSelectList();

        if (selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE) {
        List<SelectOption> tempListSelectOption =  new List<SelectOption>();
            if (mapCountryAccount.containskey(selectedCountry)) {
                String name;
                for (Account objAccount : mapCountryAccount.get(selectedCountry)) {
                    if (objAccount!=null) {
                        name = objAccount.name.length()>25 ? objAccount.name.substring(0,25)+'..' : objAccount.Name;
                        tempListSelectOption.add(new SelectOption(objAccount.Id,name));
                    }
                }
            }
            tempListSelectOption = SortOptionList(tempListSelectOption);
            accountSelectList.addall(tempListSelectOption);
        }

        return null;
    }

    /*******************************************************************************************************
    PURPOSE    : Initialize SubRegion select options
    *******************************************************************************************************/
    private void resetSubRegionSelectList() {
        subRegionSelectList.clear();
        subRegionSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedSubRegion = SELECT_ALL_VALUE;
    }

    /*******************************************************************************************************
    PURPOSE    : Intialize Country select options
    *******************************************************************************************************/
    private void resetCountrySelectList() {
        countrySelectList.clear();
        countrySelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedCountry = SELECT_ALL_VALUE;
    }

    /*******************************************************************************************************
    PURPOSE    : Intialize Account select options
    *******************************************************************************************************/
    private void resetAccountSelectList() {
        accountSelectList.clear();
        accountSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedAccount = SELECT_ALL_VALUE;
    }

    /*******************************************************************************************************
    PURPOSE    : Initialize or reset the Product,ProductFamily,Program and Project related filters
    *******************************************************************************************************/
    private void initProductFilters() {
        //pdtFamilySelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        updateFamilyFilters();
        portfolioSegmentSelectList = getPortfolioSegmentSelectOptions();
        programSelectList = new List<SelectOption>();
        projectSelectList =  new List<SelectOption>();
        productSelectList =  new List<SelectOption>();
        resetPgmSelectList();
        resetProjSelectList();
        resetPdtSelectList();
        resetFamilySelectList();
    }

    /*******************************************************************************************************
    PURPOSE    : Intialize Product Family select options
    *******************************************************************************************************/
    private void resetFamilySelectList() {
        pdtFamilySelectList =  new List<SelectOption>();
        pdtFamilySelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedFamily = SELECT_ALL_VALUE;
        selectedFamilyList = new List<String>{SELECT_ALL_VALUE};
    }

    /*******************************************************************************************************
    PURPOSE    : Populate the Product Project select options based on selected Product Family and Program values
    *******************************************************************************************************/
    public PageReference updateFamilyFilters() {
        resetFamilySelectList();

        programSelectList = new List<SelectOption>();
        projectSelectList =  new List<SelectOption>();
        productSelectList =  new List<SelectOption>();
        resetPgmSelectList();
        resetProjSelectList();
        resetPdtSelectList();
        List<SelectOption> tempListSelectOption =  new List<SelectOption>();

        if (selectedPortfolio != NULL && selectedPortfolio != SELECT_ALL_VALUE) {
            system.debug(mapPortfolioFamily + ' --mapPortfolioFamily');
            if (mapPortfolioFamily.containskey(selectedPortfolio)) {
                for (String strFamily : mapPortfolioFamily.get(selectedPortfolio)) {
                    if (strFamily !=null)
                    tempListSelectOption.add(new SelectOption(strFamily ,strFamily ));
                }
            }

          tempListSelectOption = SortOptionList(tempListSelectOption);
          pdtFamilySelectList.addAll(tempListSelectOption);
        }
        return null;
    }

    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Portfolio Segment select options based on available values on Product object
    *******************************************************************************************************/
    public List<SelectOption> getPortfolioSegmentSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
        //.Product_Segment__c From PMD_Product__c
        Schema.DescribeFieldResult fieldResult = PMD_Product__c.Product_Segment__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f : ple) {
            options.add(new SelectOption(f.getLabel(), f.getValue()));
        }
        return options;
    }

    /*******************************************************************************************************
    PURPOSE    : Populate the Product Program select options based on selected Product Family value
    *******************************************************************************************************/
    public PageReference updatePgmFilters() {
        resetPgmSelectList();
        resetProjSelectList();
        resetPdtSelectList();

        if (!selectedFamilyset.contains(SELECT_ALL_VALUE) && !selectedFamilyset.isEmpty()) {
            List<SelectOption> tempListSelectOption =  new List<SelectOption>();
            for (String strselectedFamily : selectedFamilyset) {
                if (mapFamilyProgram.containskey(selectedPortfolio+''+strselectedFamily)) {
                    for (String strProgram : mapFamilyProgram.get(selectedPortfolio+''+strselectedFamily)) {
                        if (strProgram!=null)
                            tempListSelectOption.add(new SelectOption(strProgram,strProgram));
                    }
                }
            }
            tempListSelectOption= SortOptionList(tempListSelectOption);
            programSelectList.addAll(tempListSelectOption);
        }

        return null;
    }

    /*******************************************************************************************************
    PURPOSE    : Populate the Product Project select options based on selected Product Family and Program values
    *******************************************************************************************************/
    Set<String> tempkey;
    public PageReference updateProjFilters() {

        resetProjSelectList();
        resetPdtSelectList();
        tempkey = new Set<String>();

        if (!selectedProgramSet.isEmpty() && !selectedProgramSet.contains(SELECT_ALL_VALUE)) {

            List<SelectOption> tempListSelectOption =  new List<SelectOption>();
            for (String strSelectedFamily:selectedFamilySet) {
                for (String strSelectedProgramSet:selectedProgramSet) {
                    tempkey.add(selectedPortfolio+''+strSelectedFamily+''+strSelectedProgramSet);
                }
            }

            for (String strSelectedProgramSet:tempkey) {
                if (mapProgramProject.containskey(strSelectedProgramSet)) {
                    for (String strProject : mapProgramProject.get(strSelectedProgramSet)) {
                        if (strProject!=null)
                        tempListSelectOption.add(new SelectOption(strProject,strProject));
                    }
                }
            }

            tempListSelectOption = SortOptionList(tempListSelectOption);
            projectSelectList.addAll(tempListSelectOption);
        }
        return null;
    }

    /*******************************************************************************************************
    PURPOSE    : Populate the Product select options based on selected Product Family, Program and Project values
    *******************************************************************************************************/
    public PageReference updatePdtFilters() {
        resetPdtSelectList();
        set<string> tempProductKey = new set<string>();
        if (!selectedProgramSet.isEmpty() && !selectedProgramSet.contains(SELECT_ALL_VALUE)
         && !selectedProjectSet.isEmpty() && !selectedProjectSet.contains(SELECT_ALL_VALUE)) {

            for (String strTempKey:tempkey) {
                for (String strSelectedProject:selectedProjectSet) {
                    tempProductKey.add(strTempKey+''+strSelectedProject);
                }
            }

            List<SelectOption> tempListSelectOption =  new List<SelectOption>();
            for (String strSelectedProject:tempProductKey) {
                if (mapProjectProduct.containskey(strSelectedProject)) {
                    for (Product2 objProduct: mapProjectProduct.get(strSelectedProject)) {
                        if (objProduct!=null)
                        tempListSelectOption.add(new SelectOption(objProduct.id,objProduct.Name));
                    }
                }
            }

            system.debug(tempListSelectOption + '--tempListSelectOption');
            tempListSelectOption = SortOptionList(tempListSelectOption);
            productSelectList.addAll(tempListSelectOption);
        }
        return null;
    }

    /*******************************************************************************************************
    PURPOSE    : Initialize Product Program select options
    *******************************************************************************************************/
    private void resetPgmSelectList() {
        programSelectList.clear();
        programSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedProgramList = new List<String>{SELECT_ALL_VALUE};
    }

    /*******************************************************************************************************
    PURPOSE    : Initialize Product Project select options
    *******************************************************************************************************/
    private void resetProjSelectList() {
        projectSelectList.clear();
        projectSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedProjectList = new List<String>{SELECT_ALL_VALUE};
    }

    /*******************************************************************************************************
    PURPOSE    : Initialize Product select options
    *******************************************************************************************************/
    private void resetPdtSelectList() {
        productSelectList.clear();
        productSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedProductList = new List<String>{SELECT_ALL_VALUE};
    }

    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Year select options
    *******************************************************************************************************/
    public List<SelectOption> getYearSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer index=2013; index<=2018; index++) {
            options.add(new SelectOption(String.valueOf(index), yearPrefix+index));
        }
        selectedYear = String.valueOf(DateTime.Now().Year());
        return options;
    }

    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Quarter select options
    *******************************************************************************************************/
    public List<SelectOption> getQuarterSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer index=1; index<=4; index++) {
            options.add(new SelectOption(String.valueOf(index), qtrPrefix+index));
        }

        selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        return options;
    }

    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Period select options
    *******************************************************************************************************/
    public List<SelectOption> getPeriodSelectOptions() {
        List<SelectOption> options = new List<SelectOption>();
        for (Integer index=1; index<=6; index++) {
            options.add(new SelectOption(String.valueOf(index), index+periodSuffix));
        }
        return options;
    }

    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Forecast Category select options based on available values in
                 OpportunityLineItem object
    *******************************************************************************************************/
    public List<SelectOption> getForecastSelectOptions() {
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
       Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Product_Forecast_Category__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       selectedForecastList = new List<String>();
       for (Schema.PicklistEntry f : ple) {
          options.add(new SelectOption(f.getValue(),f.getLabel()));
           if (f.getValue() != 'OMITTED')
            selectedForecastList.add(f.getValue());
       }
       return options;
    }

    public List<SelectOption> getOppStageSelectOptions() {
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
       Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for (Schema.PicklistEntry f : ple) {
          options.add(new SelectOption(f.getValue(),f.getLabel()));
       }
       return options;
    }

    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of output Layout select options
    *******************************************************************************************************/
    public List<SelectOption> getLayoutSelectOptions() {
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(LAYOUT_QTR, LAYOUT_QTR));
       options.add(new SelectOption(LAYOUT_MONTH, LAYOUT_MONTH));
       options.add(new SelectOption(LAYOUT_BOTH, LAYOUT_BOTH));
       return options;
    }

    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Group By select options
    *******************************************************************************************************/
    public List<SelectOption> getGroupBySelectOptions() {
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(GRP_BY_REGION, GRP_BY_REGION));
       options.add(new SelectOption(GRP_BY_SUB_REGION, GRP_BY_SUB_REGION));
       options.add(new SelectOption(GRP_BY_COUNTRY, GRP_BY_COUNTRY));
       options.add(new SelectOption(GRP_BY_ACCOUNT, GRP_BY_ACCOUNT));
       options.add(new SelectOption(GRP_BY_OPP_STAGE, GRP_BY_OPP_STAGE));
       options.add(new SelectOption(GRP_BY_FORECAST_CAT, GRP_BY_FORECAST_CAT));
       options.add(new SelectOption(GRP_BY_PRODUCT_FAMILY, GRP_BY_PRODUCT_FAMILY));
       options.add(new SelectOption(GRP_BY_PROGRAM, GRP_BY_PROGRAM));
       options.add(new SelectOption(GRP_BY_PROJECT, GRP_BY_PROJECT));
       options.add(new SelectOption(GRP_BY_PRODUCT, GRP_BY_PRODUCT));
       return options;
    }

    /*******************************************************************************************************
    PURPOSE    : Prepare and return a Map of <AccountId,AccountRecord> key-value pairs, based on the received
                 set of Account Ids
    *******************************************************************************************************/
    private Map<Id,Account> createAccountMap(set<String> accIds) {
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>();

        if (accIds != null && accIds.size()>0) {
            for (Account acc : [Select Id, Name, Region__c, Sub_Region__c, Country__c from Account where Id IN :accIds]) {
                mapIdToAccount.put(acc.Id, acc);
            }
        }

        return mapIdToAccount;
    }

    /*******************************************************************************************************
    PURPOSE    : Main method to perform the search in database based on the user selected filters
    *******************************************************************************************************/
    public PageReference doSearch() {
        try {
            mapAccountIdToAccount.clear();
            listOfQtrWrapperObj = null;
            listOfUCDQtrWrapperObj = null;
            listOfMonthWrapperObj = null;
            listOfUCDMonthWrapperObj = null;
            getStartAndEndDate();

            // Check if the data source is opportunity snapshot or realtime
            boolean realtime = true;
            system.debug('selectedDataSource: ' + selectedDataSource);
            if (selectedDataSource != SELECT_ALL_VALUE) {
                realtime = false;
                snapshotDate = Date.valueOf(selectedDataSource);
            }

            system.debug(startdate + ' :: ' + enddate);
            whereClause  = prepareWhereClause(realtime);

            if (selectedLayout == LAYOUT_BOTH || selectedLayout == LAYOUT_QTR) {
                prepareQuarterlyData(realtime);
            }
            if (selectedLayout == LAYOUT_BOTH || selectedLayout == LAYOUT_MONTH) {
                prepareMonthlyData(realtime);
            }
        } catch(Exception ex) {
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msgs);
        }
        return null;
    }

    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Quarterly data based on the selected data Grouping.
                 Invoked from 'doSearch' method.
    *******************************************************************************************************/
    private void prepareQuarterlyData(Boolean realtime) {
        listOfQtrWrapperObj = new List<ResultWrapper>();
        listOfUCDQtrWrapperObj = new List<ResultWrapper>();
        qtrHeaders = generateQtrHeaders();
        listOfQtrWrapperObj = prepareInnerQuarterWiseData(realtime);// prepareQuarterlyData_By_Product();
        if (selectedGroupBy == GRP_BY_FORECAST_CAT)
            listOfUCDQtrWrapperObj = prepareUCDWiseData_By_Forecast(listOfQtrWrapperObj, qtrHeaders);
    }

    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Monthly data based on the selected data Grouping.
                 Invoked from 'doSearch' method.
    *******************************************************************************************************/
    private void prepareMonthlyData(Boolean realtime) {
        listOfMonthWrapperObj = new List<ResultWrapper>();
        listOfUCDMonthWrapperObj = new List<ResultWrapper>();
        monthHeaders = generateMonthHeaders();
        listOfMonthWrapperObj = prepareInnerMonthlyData(realtime);
        if (selectedGroupBy == GRP_BY_FORECAST_CAT)
            listOfUCDMonthWrapperObj = prepareUCDWiseData_By_Forecast(listOfMonthWrapperObj, monthHeaders);
    }

    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Quarter wise data for Program Name based grouping.
                 Invoked from 'prepareQuarterlyData' method.
    *******************************************************************************************************/
    public List<ResultWrapper> prepareInnerQuarterWiseData(Boolean realtime) {
        
        String query = prepareQuery(realtime, 'Q');

        system.debug('prepareInnerQuarterWiseData Query: ' + query);
        system.debug('selectedGroupBy: ' + selectedGroupBy);
        List<AggregateResult> results = database.query(query);

        List<ResultWrapper> listOfQtrWrapperObjTemp = new List<ResultWrapper>();
        Map<String,ResultWrapper> mapKeyValueToQtrWrapper = new Map<String,ResultWrapper>();
        map<string,string> mapForecastValueToLabel = new map<String,string>();

        //IF (Group By = FORECAST CATEGORY)

        if (selectedGroupBy == GRP_BY_FORECAST_CAT) {
            mapForecastValueToLabel = fetchForecastValueToLabel();
            if (!selectedForecastSet.contains(SELECT_ALL_VALUE)) {
                for (String forecast : selectedForecastSet) {
                    mapKeyValueToQtrWrapper.put(forecast, new ResultWrapper(selectedGroupBy,forecast,qtrHeaders));
                }
            } else {
                for (String forecast : mapForecastValueToLabel.values()) {
                    mapKeyValueToQtrWrapper.put(forecast, new ResultWrapper(selectedGroupBy,forecast,qtrHeaders));
                }
            }
        }

        // END of IF

        String strKey;
        Integer qtr;
        Integer year;
        ResultWrapper tempWrapper;
        String qtrHeaderValue;

        for (AggregateResult ar : results) {

            if (selectedGroupBy == GRP_BY_COUNTRY) {
                strKey = (String)ar.get('rgn')+ '-' + (String)ar.get('sbrgn')+'-'+(String)ar.get('ctr');
            } else if (selectedGroupBy == GRP_BY_SUB_REGION) {
                strKey = (String)ar.get('rgn')+ '-' + (String)ar.get('sbrgn');
            } else if (selectedGroupBy == GRP_BY_FORECAST_CAT) {
                strKey =  mapForecastValueToLabel.get((String)ar.get('keyValue'));
            } else if (selectedGroupBy == GRP_BY_PRODUCT_FAMILY) {
                strKey = (String)ar.get('keyValue') +'-'+(String)ar.get('bu');
            } else {
                strKey = (String)ar.get('keyValue');
            }
            year = (Integer)ar.get('year');
            qtr = (Integer)ar.get('qtr');

            if (!mapKeyValueToQtrWrapper.containsKey(strKey)) {
                if (selectedGroupBy == GRP_BY_COUNTRY) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',qtrHeaders);
                    tempWrapper.accountRegion = (String)ar.get('rgn');
                    tempWrapper.accountSubRegion =  (String)ar.get('sbrgn');
                    tempWrapper.accountCountry = (String)ar.get('ctr');
                    mapKeyValueToQtrWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_SUB_REGION) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',qtrHeaders);
                    tempWrapper.accountRegion = (String)ar.get('rgn');
                    tempWrapper.accountSubRegion = (String)ar.get('sbrgn');
                    mapKeyValueToQtrWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_PROGRAM) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',qtrHeaders);
                    tempWrapper.program = (String)ar.get('keyValue');
                    tempWrapper.programFamily = (String)ar.get('family');
                    mapKeyValueToQtrWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_PRODUCT) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',qtrHeaders);
                    tempWrapper.product = (String)ar.get('keyValue');
                    tempWrapper.programFamily = (String)ar.get('family');
                    tempWrapper.businessUnit = (String)ar.get('BU');
                    tempWrapper.program = (String)ar.get('prgrm');
                    mapKeyValueToQtrWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_PROJECT) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',qtrHeaders);
                    tempWrapper.program = (String)ar.get('prgrm');
                    tempWrapper.project = (String)ar.get('KeyValue');
                    tempWrapper.programFamily = (String)ar.get('family');
                    mapKeyValueToQtrWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_PRODUCT_FAMILY) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',qtrHeaders);
                    tempWrapper.programFamily = (String)ar.get('keyValue');
                    tempWrapper.businessUnit = (String)ar.get('BU');
                    mapKeyValueToQtrWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_SUB_REGION) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',qtrHeaders);
                    tempWrapper.accountRegion = (String)ar.get('rgn');
                    tempWrapper.accountSubRegion = (String)ar.get('subrgn');
                    mapKeyValueToQtrWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_COUNTRY) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',qtrHeaders);
                    tempWrapper.accountRegion = (String)ar.get('rgn');
                    tempWrapper.accountSubRegion = (String)ar.get('subrgn');
                    tempWrapper.accountCountry = (String)ar.get('ctr');
                    mapKeyValueToQtrWrapper.put(strKey, tempWrapper);
                } else {
                    mapKeyValueToQtrWrapper.put(strKey, new ResultWrapper(selectedGroupBy,strKey,qtrHeaders));
                }
            }
            qtrHeaderValue = convertToQtrHeader(qtr, year);
            mapKeyValueToQtrWrapper.get(strKey).headerWiseQtySum.put(qtrHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }

       // IF (Group By = Account)
       if (selectedGroupBy == GRP_BY_ACCOUNT) {
            if (mapAccountIdToAccount.size()==0) {
                mapAccountIdToAccount = createAccountMap(mapKeyValueToQtrWrapper.keySet());
            }
            map<String,Set<String>> mapRegionToAccIds = new map<String,Set<String>>();
            Account acc;
            for (ResultWrapper wrap : mapKeyValueToQtrWrapper.values()) {
                    acc = mapAccountIdToAccount.get(wrap.accountid);
                    wrap.accountName = acc.Name;
                    wrap.accountRegion = acc.Region__c;
                    wrap.accountSubRegion = acc.Sub_Region__c;
                    wrap.accountCountry = acc.Country__c;
                    if (!mapRegionToAccIds.containsKey(acc.Region__c)) {
                        mapRegionToAccIds.put(acc.Region__c, new Set<String>());
                }
                mapRegionToAccIds.get(acc.Region__c).add(wrap.accountid);
            }
        }
        // END of If

        // IF (Group By = Forcast Category)
        if (selectedGroupBy == GRP_BY_FORECAST_CAT) {
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(CLOSED)) {
                listOfQtrWrapperObjTemp.add(mapKeyValueToQtrWrapper.get(CLOSED));
            }
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(COMIT)) {
                listOfQtrWrapperObjTemp.add(mapKeyValueToQtrWrapper.get(COMIT));
            }
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(BESTCASE)) {
                listOfQtrWrapperObjTemp.add(mapKeyValueToQtrWrapper.get(BESTCASE));
            }
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(PIPELINE)) {
                listOfQtrWrapperObjTemp.add(mapKeyValueToQtrWrapper.get(PIPELINE));
            }
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(OMITTED)) {
                listOfQtrWrapperObjTemp.add(mapKeyValueToQtrWrapper.get(OMITTED));
            }
        } else {
            List<string> listSortedStages = new List<String>();
            listSortedStages.addAll(mapKeyValueToQtrWrapper.keySet());
            listSortedStages.sort();
            for (String strKeyName : listSortedStages) {
                listOfQtrWrapperObjTemp.add(mapKeyValueToQtrWrapper.get(strKeyName));
            }
        }
        // END of IF-ELSE
        listOfQtrWrapperObjTemp = calculateTotals(qtrHeaders, listOfQtrWrapperObjTemp);
        return listOfQtrWrapperObjTemp;
    }

    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Monthly data for
                 Program Name based grouping.
                 Invoked from 'prepareMonthlyData' method.
    *******************************************************************************************************/
    public List<ResultWrapper> prepareInnerMonthlyData(Boolean realtime) {
 
        String query = prepareQuery(realtime, 'M');

        system.debug('prepareInnerMonthlyData Query: ' + query);
        List<AggregateResult> results = database.query(query);

        List<ResultWrapper> listOfMonthWrapperObjTemp = new List<ResultWrapper>();
        Map<String,ResultWrapper> mapKeyValueToMonthWrapper = new Map<String,ResultWrapper>();
        map<string,string> mapForecastValueToLabel = new map<String,string>();

        if (selectedGroupBy == GRP_BY_FORECAST_CAT) {
            mapForecastValueToLabel = fetchForecastValueToLabel();
            if (!selectedForecastSet.contains(SELECT_ALL_VALUE)) {
                for (String forecast : selectedForecastSet) {
                    mapKeyValueToMonthWrapper.put(forecast, new ResultWrapper(selectedGroupBy,forecast,monthHeaders));
                }
            } else {
                for (String forecast : mapForecastValueToLabel.values()) {
                    mapKeyValueToMonthWrapper.put(forecast, new ResultWrapper(selectedGroupBy,forecast,monthHeaders));
                }
            }
        }

        String strKey;
        Integer month;
        Integer year;
        ResultWrapper tempWrapper;
        String monthHeaderValue;

        for (AggregateResult ar : results) {
            system.debug('ar -- Month -- ' + ar);
            if (selectedGroupBy == GRP_BY_COUNTRY) {
                strKey = (String)ar.get('rgn')+ '-' + (String)ar.get('sbrgn')+'-'+(String)ar.get('ctr');
            } else if (selectedGroupBy == GRP_BY_SUB_REGION) {
                strKey = (String)ar.get('rgn')+ '-' + (String)ar.get('sbrgn');
            } else if (selectedGroupBy == GRP_BY_FORECAST_CAT) {
                strKey =  mapForecastValueToLabel.get((String)ar.get('keyValue'));
            } else if (selectedGroupBy == GRP_BY_PRODUCT_FAMILY) {
                strKey = (String)ar.get('keyValue') +'-'+(String)ar.get('bu');
            } else {
                strKey = (String)ar.get('keyValue');
            }

            year = (Integer)ar.get('year');
            month = (Integer)ar.get('month');

            if (!mapKeyValueToMonthWrapper.containsKey(strKey)) {
                if (selectedGroupBy == GRP_BY_COUNTRY) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',monthHeaders);
                    tempWrapper.accountRegion = (String)ar.get('rgn');
                    tempWrapper.accountSubRegion =  (String)ar.get('sbrgn');
                    tempWrapper.accountCountry = (String)ar.get('ctr');
                    mapKeyValueToMonthWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_SUB_REGION) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',monthHeaders);
                    tempWrapper.accountRegion = (String)ar.get('rgn');
                    tempWrapper.accountSubRegion = (String)ar.get('sbrgn');
                    mapKeyValueToMonthWrapper.put(strKey, tempWrapper);
                } else  if (selectedGroupBy == GRP_BY_PROGRAM) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',monthHeaders);
                    tempWrapper.program = (String)ar.get('keyValue');
                    tempWrapper.programFamily = (String)ar.get('family');
                    mapKeyValueToMonthWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_PRODUCT) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',monthHeaders);
                    tempWrapper.product = (String)ar.get('keyValue');
                    tempWrapper.programFamily = (String)ar.get('family');
                    tempWrapper.businessUnit = (String)ar.get('BU');
                    tempWrapper.program = (String)ar.get('prgrm');
                    mapKeyValueToMonthWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_PROJECT) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',monthHeaders);
                    tempWrapper.program = (String)ar.get('prgrm');
                    tempWrapper.project = (String)ar.get('KeyValue');
                    tempWrapper.programFamily = (String)ar.get('family');
                    mapKeyValueToMonthWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_PRODUCT_FAMILY) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',monthHeaders);
                    tempWrapper.programFamily = (String)ar.get('keyValue');
                    tempWrapper.businessUnit = (String)ar.get('BU');
                    mapKeyValueToMonthWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_SUB_REGION) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',monthHeaders);
                    tempWrapper.accountRegion = (String)ar.get('rgn');
                    tempWrapper.accountSubRegion = (String)ar.get('subrgn');
                    mapKeyValueToMonthWrapper.put(strKey, tempWrapper);
                } else if (selectedGroupBy == GRP_BY_COUNTRY) {
                    tempWrapper = new ResultWrapper(selectedGroupBy,'',monthHeaders);
                    tempWrapper.accountRegion = (String)ar.get('rgn');
                    tempWrapper.accountSubRegion = (String)ar.get('subrgn');
                    tempWrapper.accountCountry = (String)ar.get('ctr');
                    mapKeyValueToMonthWrapper.put(strKey, tempWrapper);
                } else {
                    mapKeyValueToMonthWrapper.put(strKey, new ResultWrapper(selectedGroupBy,strKey,monthHeaders));
                }
            }
            monthHeaderValue = convertToMonthHeader(month, year);
            mapKeyValueToMonthWrapper.get(strKey).headerWiseQtySum.put(monthHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }
        if (selectedGroupBy == GRP_BY_ACCOUNT) {
            if (mapAccountIdToAccount.size()==0) {
                mapAccountIdToAccount = createAccountMap(mapKeyValueToMonthWrapper.keySet());
            }
            map<String,Set<String>> mapRegionToAccIds = new map<String,Set<String>>();
            Account acc;
            for (ResultWrapper wrap : mapKeyValueToMonthWrapper.values()) {
                acc = mapAccountIdToAccount.get(wrap.accountid);
                wrap.accountName = acc.Name;
                wrap.accountRegion = acc.Region__c;
                wrap.accountSubRegion = acc.Sub_Region__c;
                wrap.accountCountry = acc.Country__c;
                if (!mapRegionToAccIds.containsKey(acc.Region__c)) {
                    mapRegionToAccIds.put(acc.Region__c, new Set<String>());
                }
                mapRegionToAccIds.get(acc.Region__c).add(wrap.accountid);
            }
        }

        if (selectedGroupBy == GRP_BY_FORECAST_CAT) {
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(CLOSED)) {
                listOfMonthWrapperObjTemp.add(mapKeyValueToMonthWrapper.get(CLOSED));
            }
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(COMIT)) {
                listOfMonthWrapperObjTemp.add(mapKeyValueToMonthWrapper.get(COMIT));
            }
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(BESTCASE)) {
                listOfMonthWrapperObjTemp.add(mapKeyValueToMonthWrapper.get(BESTCASE));
            }
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(PIPELINE)) {
                listOfMonthWrapperObjTemp.add(mapKeyValueToMonthWrapper.get(PIPELINE));
            }
            if (selectedForecastSet.contains(SELECT_ALL_VALUE) || selectedForecastSet.contains(OMITTED)) {
                listOfMonthWrapperObjTemp.add(mapKeyValueToMonthWrapper.get(OMITTED));
            }
        }

        if (selectedGroupBy != GRP_BY_FORECAST_CAT) {
            List<string> listSortedStages = new List<String>();
            listSortedStages.addAll(mapKeyValueToMonthWrapper.keySet());
            listSortedStages.sort();
            for (String strKeyName : listSortedStages) {
                listOfMonthWrapperObjTemp.add(mapKeyValueToMonthWrapper.get(strKeyName));
            }
        }

        listOfMonthWrapperObjTemp = calculateTotals(monthHeaders, listOfMonthWrapperObjTemp);

        return listOfMonthWrapperObjTemp;
    }

    /*******************************************************************************************************
    PURPOSE    : Prepares the main SOQL query. The group by is the only change between 
    *******************************************************************************************************/
    private String prepareQuery(Boolean realtime, String quarterlyOrMonthly) {

        String queryFields = '';
        String groupByFields = '';

        if (selectedGroupBy == GRP_BY_PROGRAM) {
            if (realtime) {
                queryFields = ' PricebookEntry.Product2.Program__c keyValue, PricebookEntry.Product2.Family family, ';
                groupByFields = ' PricebookEntry.Product2.Program__c, PricebookEntry.Product2.Family, ';
            } else {
                queryFields = ' Program__c keyValue, Product_Family__c family, ';
                groupByFields = ' Program__c, Product_Family__c, ';
            }
        } else if (selectedGroupBy == GRP_BY_PRODUCT) {
            if (realtime) {
                queryFields = ' PricebookEntry.Product2.Name keyValue, PricebookEntry.Product2.Family family, PricebookEntry.Product2.Program__c prgrm,Business_Unit__c bu, ';
                groupByFields = ' PricebookEntry.Product2.Name, PricebookEntry.Product2.Family, PricebookEntry.Product2.Program__c, Business_Unit__c, ';
            } else {
                queryFields = ' Product__r.Name keyValue, Product_Family__c family, Program__c prgrm, Product__r.Business_Unit__c bu, ';
                groupByFields = ' Product__r.Name, Product_Family__c, Program__c, Product__r.Business_Unit__c, ';
            }
        } else if (selectedGroupBy == GRP_BY_PROJECT) {
            if (realtime) {
                queryFields = ' PricebookEntry.Product2.Project__C keyValue, PricebookEntry.Product2.Program__c prgrm, PricebookEntry.Product2.Family family , ';
                groupByFields = ' PricebookEntry.Product2.Project__C, PricebookEntry.Product2.Program__c, PricebookEntry.Product2.Family, ';
            } else {
                queryFields = ' Project__c keyValue, Program__c prgrm, Product_Family__c family, ';
                groupByFields = ' Project__c, Program__c, Product_Family__c, ';
            }
        } else if (selectedGroupBy == GRP_BY_PRODUCT_FAMILY) {
            if (realtime) {
                queryFields = ' PricebookEntry.Product2.Family keyValue, Business_Unit__c bu, ';
                groupByFields = ' PricebookEntry.Product2.Family, Business_Unit__c, ';
            } else {
                queryFields = ' Product_Family__c keyValue, Product__r.Business_Unit__c bu, ';
                groupByFields = ' Product_Family__c, Product__r.Business_Unit__c, ';
            }
        } else if (selectedGroupBy == GRP_BY_REGION) {
            if (realtime) {
                queryFields = ' Opportunity.Account.Region__c keyValue,';
                groupByFields = ' Opportunity.Account.Region__c,';
            } else {
                queryFields = ' Region__c keyValue,';
                groupByFields = ' Region__c,';
            }
        } else if (selectedGroupBy == GRP_BY_SUB_REGION) {
            if (realtime) {
                queryFields = ' Opportunity.Account.Sub_Region__c sbrgn, Opportunity.Account.Region__c rgn, ';
                groupByFields = ' Opportunity.Account.Sub_Region__c, Opportunity.Account.Region__c, ';
            } else {
                queryFields = ' Sub_Region__c sbrgn, Region__c rgn, ';
                groupByFields = ' Sub_Region__c, Region__c, ';
            }
        } else if (selectedGroupBy == GRP_BY_COUNTRY) {
            if (realtime) {
                queryFields = ' Opportunity.Account.Country__c ctr,Opportunity.Account.Sub_Region__c sbrgn,Opportunity.Account.Region__c rgn, ';
                groupByFields = ' Opportunity.Account.Country__c, Opportunity.Account.Sub_Region__c, Opportunity.Account.Region__c, ';
            } else {
                queryFields = ' Country__c ctr,Sub_Region__c sbrgn,Region__c rgn, ';
                groupByFields = ' Country__c, Sub_Region__c, Region__c, ';
            }
        } else if (selectedGroupBy == GRP_BY_ACCOUNT) {
            if (realtime) {
                queryFields = ' Opportunity.AccountId keyValue, ';
                groupByFields = ' Opportunity.AccountId, ';
            } else {
                queryFields = ' Account__c keyValue, ';
                groupByFields = ' Account__c, ';
            }
        } else if (selectedGroupBy == GRP_BY_OPP_STAGE) {
            if (realtime) {
                queryFields = ' Opportunity.Stagename keyValue, ';
                groupByFields = ' Opportunity.Stagename, ';
            } else {
                queryFields = ' Stage__c keyValue, ';
                groupByFields = ' Stage__c, ';
            }
        } else if (selectedGroupBy == GRP_BY_FORECAST_CAT) {
            // These 2 fields have the same names in both OLI and the snapshot objects
            queryFields = ' Product_Forecast_Category__c keyValue, ';
            groupByFields = ' Product_Forecast_Category__c, ';
        }

        String query = 'SELECT ' + queryFields;
        String groupByClause = ' GROUP BY ' + groupByFields;
        
        // Quarterly start
        if (quarterlyOrMonthly == 'Q') {
            if (realtime) {
                query +=   ' CALENDAR_YEAR(ServiceDate) year, '
                         + ' CALENDAR_QUARTER(ServiceDate) qtr, '
                         + ' SUM(Quantity)Qty '
                         + ' FROM OpportunityLineItem';

                groupByClause += ' CALENDAR_YEAR(ServiceDate), '
                          + ' CALENDAR_QUARTER(ServiceDate)';

            } else {
                query +=   ' CALENDAR_YEAR(Forecast_Date__c) year, '
                    + ' CALENDAR_QUARTER(Forecast_Date__c) qtr, '
                    + ' SUM(Quantity__c)Qty '
                    + ' FROM Opportunity_Snapshot__c';
                 
                 groupByClause += ' CALENDAR_YEAR(Forecast_Date__c), '
                               +  ' CALENDAR_QUARTER(Forecast_Date__c)';
            }
        } else { // Monthly
            if (realtime) {
                query +=    'CALENDAR_YEAR(ServiceDate) year, CALENDAR_MONTH(ServiceDate) month, ' +
                            'CALENDAR_QUARTER(ServiceDate) qtr, SUM(Quantity) Qty ' +
                            'FROM OpportunityLineItem';

                groupByClause += ' CALENDAR_YEAR(ServiceDate), ' +
                                ' CALENDAR_MONTH(ServiceDate), ' +
                                ' CALENDAR_QUARTER(ServiceDate)';
            } else {
                query +=    'CALENDAR_YEAR(Forecast_Date__c) year, CALENDAR_MONTH(Forecast_Date__c) month, ' +
                            'CALENDAR_QUARTER(Forecast_Date__c) qtr, SUM(Quantity__c) Qty ' +
                            'FROM Opportunity_Snapshot__c';

               groupByClause += ' CALENDAR_YEAR(Forecast_Date__c), ' +
                                ' CALENDAR_MONTH(Forecast_Date__c), ' +
                                ' CALENDAR_QUARTER(Forecast_Date__c)';
            }
        }

        query  += ' WHERE ' +  whereClause + groupByClause;

        return query;
    }

    /*******************************************************************************************************
    PURPOSE    :
    *******************************************************************************************************/
    private List<ResultWrapper> prepareUCDWiseData_By_Forecast(list<ResultWrapper> listForecastWrappers, list<string> headers) {
        Map<String,ResultWrapper> mapUCDToWrapper = new Map<String,ResultWrapper>();
        list<ResultWrapper> listUCDWrapper = new list<ResultWrapper>();
        String UCD = 'UCD';
        String UCD_BESTCASE = 'UCD(Bestcase)';
        String UCD_PIPELINE = 'Total Pipeline';

        mapUCDToWrapper.put(UCD, new ResultWrapper(selectedGroupBy,UCD,headers));
        mapUCDToWrapper.put(UCD_BESTCASE, new ResultWrapper(selectedGroupBy,UCD_BESTCASE,headers));
        mapUCDToWrapper.put(UCD_PIPELINE, new ResultWrapper(selectedGroupBy,UCD_PIPELINE,headers));

        Long qtySum = 0;
        for (ResultWrapper result : listForecastWrappers) {
            if (result.forecast == PIPELINE) {
                for (String header : headers) {
                    if (TOTAL_COLUMN_HEADER==header) {continue;}
                    qtySum = result.headerWiseQtySum.get(header);
                    mapUCDToWrapper.get(UCD_PIPELINE).headerWiseQtySum.put(header,mapUCDToWrapper.get(UCD_PIPELINE).headerWiseQtySum.get(header)+qtySum);
                }
            } else if (result.forecast == CLOSED || result.forecast == COMIT) {
                for (String header : headers) {
                    if (TOTAL_COLUMN_HEADER==header) {continue;}
                    qtySum = result.headerWiseQtySum.get(header);
                    mapUCDToWrapper.get(UCD).headerWiseQtySum.put(header,mapUCDToWrapper.get(UCD).headerWiseQtySum.get(header)+qtySum);
                    mapUCDToWrapper.get(UCD_BESTCASE).headerWiseQtySum.put(header,mapUCDToWrapper.get(UCD_BESTCASE).headerWiseQtySum.get(header)+qtySum);
                    mapUCDToWrapper.get(UCD_PIPELINE).headerWiseQtySum.put(header,mapUCDToWrapper.get(UCD_PIPELINE).headerWiseQtySum.get(header)+qtySum);
                }
            } else if (result.forecast == BESTCASE) {
                for (String header : headers) {
                    if (TOTAL_COLUMN_HEADER==header) {continue;}
                    qtySum = result.headerWiseQtySum.get(header);
                    mapUCDToWrapper.get(UCD_BESTCASE).headerWiseQtySum.put(header,mapUCDToWrapper.get(UCD_BESTCASE).headerWiseQtySum.get(header)+qtySum);
                    mapUCDToWrapper.get(UCD_PIPELINE).headerWiseQtySum.put(header,mapUCDToWrapper.get(UCD_PIPELINE).headerWiseQtySum.get(header)+qtySum);
                }
            }
        }

        listUCDWrapper.add(mapUCDToWrapper.get(UCD));
        listUCDWrapper.add(mapUCDToWrapper.get(UCD_BESTCASE));
        listUCDWrapper.add(mapUCDToWrapper.get(UCD_PIPELINE));
        listUCDWrapper = calculateTotals(headers, listUCDWrapper);
        System.debug('###listUCDWrapper'+listUCDWrapper);
        return listUCDWrapper;
    }

    /*******************************************************************************************************
    PURPOSE    : Method prepares and returns the SOQL Where clause based on the selected Region, Product
                 and Time filters
    *******************************************************************************************************/
    private String prepareWhereClause(Boolean realtime) {
        String whereClause  = '';

        if (realtime) {
            whereClause  = ' ServiceDate <= :endDate and ServiceDate >= :startDate';
        } else {
            whereClause  = ' Forecast_Date__c <= :endDate and Forecast_Date__c >= :startDate'
                         + ' AND Snapshot_Date__c = :snapshotDate'
                         + ' AND Opportunity_Line_Number__c != null'
                         + ' AND Quantity__c != null ';
                         // There could be records in the snapshot that represent
                         // the opportunity header but not lines - ignore them
        }

        if (selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE) {
            if (realtime)
                whereClause += ' AND Opportunity.Account.Region__c =\''+ selectedRegion  + '\'';
            else
                whereClause += ' AND Region__c =\''+ selectedRegion  + '\'';
        }

        if (selectedSubRegion != NULL && selectedSubRegion != SELECT_ALL_VALUE) {
            if (realtime)
                whereClause += ' AND Opportunity.Account.Sub_Region__c =\''+ selectedSubRegion  + '\'';
            else
                whereClause += ' AND Sub_Region__c =\''+ selectedSubRegion  + '\'';
        }

        if (selectedCountry != NULL && selectedCountry != SELECT_ALL_VALUE) {
            if (realtime)
                whereClause += ' AND Opportunity.Account.Country__c =\''+ selectedCountry  + '\'';
            else
                whereClause += ' AND Country__c =\''+ selectedCountry  + '\'';
        }

        if (!selectedProductSet.isEmpty() && !selectedProductSet.contains(SELECT_ALL_VALUE)) {
            if (realtime)
                whereClause += ' AND PricebookEntry.Product2Id IN :selectedProductSet';
            else
                whereClause += ' AND Product__c IN :selectedProductSet';
        }

        if (!selectedFamilyset.contains(SELECT_ALL_VALUE) && !selectedFamilyset.isEmpty()) {
            if (realtime)
                whereClause += ' AND PricebookEntry.Product2.Family IN : selectedFamilyset';
            else
                whereClause += ' AND Product_Family__c IN : selectedFamilyset';
        }

        if (selectedPortfolio != NULL && selectedPortfolio != SELECT_ALL_VALUE) {
            if (realtime)
                whereClause += ' AND PricebookEntry.Product2.Portfolio_Segment__c =\''+ selectedPortfolio  + '\'';
            else
                whereClause += ' AND Product__r.Portfolio_Segment__c =\''+ selectedPortfolio  + '\'';
        }

        if (!selectedProjectSet.isEmpty() && !selectedProjectSet.contains(SELECT_ALL_VALUE)) {
            if (realtime)
                whereClause += ' AND PricebookEntry.Product2.Project__c IN :selectedProjectSet';
            else
                whereClause += ' AND Project__c IN :selectedProjectSet';
        }

        if (!selectedProgramSet.isEmpty() && !selectedProgramSet.contains(SELECT_ALL_VALUE)) {
            if (realtime)
                whereClause += ' AND PricebookEntry.Product2.Program__c IN :selectedProgramSet';
            else
                whereClause += ' AND Program__c IN :selectedProgramSet';
        }

        if (!selectedForecastSet.contains(SELECT_ALL_VALUE)) {
            if (realtime)
                whereClause += ' AND Product_Forecast_Category__c IN :selectedForecastSet';
            else
                whereClause += ' AND Product_Forecast_Category__c IN :selectedForecastSet';
        }

        if (selectedAccount != NULL && selectedAccount != SELECT_ALL_VALUE) {
            if (realtime)
                whereClause += ' AND Opportunity.AccountId =\''+ selectedAccount  + '\'';
            else
                whereClause += ' AND Account__c =\''+ selectedAccount  + '\'';
        }

        if (!selectedOppStageSet.contains(SELECT_ALL_VALUE)) {
            if (realtime)
                whereClause += ' AND Opportunity.StageName IN :selectedOppStageSet';
            else
                whereClause += ' AND Stage__c IN :selectedOppStageSet';
        }

        return whereClause;
    }

    /*******************************************************************************************************
    PURPOSE    : Calculate Start and End Date based on the selected Time filters
    *******************************************************************************************************/
   private void getStartAndEndDate() {
        map<String,String> mapQtrToStartDate = new map<String,String>();
        Integer intSelectedYear = integer.valueof(SelectedYear);
        String Quarter1Start = date.newinstance(intSelectedYear,1,1).format();
        String Quarter2Start = date.newinstance(intSelectedYear,4,1).format();
        String Quarter3Start = date.newinstance(intSelectedYear,7,1).format();
        String Quarter4Start = date.newinstance(intSelectedYear,10,1).format();
        mapQtrToStartDate.put('1', Quarter1Start);
        mapQtrToStartDate.put('2', Quarter2Start);
        mapQtrToStartDate.put('3', Quarter3Start);
        mapQtrToStartDate.put('4', Quarter4Start);
        startDate = Date.parse(mapQtrToStartDate.get(selectedQtr));
        endDate = startDate.addMonths(Integer.valueOf(selectedPeriods) * 3).addDays(-1);
    }

    /*******************************************************************************************************
    PURPOSE    : Calculate Quater Header based on received Quarter and Year value
    *******************************************************************************************************/
    private String convertToQtrHeader(Integer qtrNumber, Integer year) {
        return 'Q' + qtrNumber + '\'' + String.valueOf(year).substring(2, 4);
    }

    /*******************************************************************************************************
    PURPOSE    : Calculate Month Header based on received Month and Year value
    *******************************************************************************************************/
    private String convertToMonthHeader(Integer monthNumber, Integer year) {
        return mapNumberToMonth.get(monthNumber) + '\'' + String.valueOf(year).substring(2, 4);
    }

    /*******************************************************************************************************
    PURPOSE    : Calculate all Quater Header values for the selected Time filter
    *******************************************************************************************************/
    private list<string> generateQtrHeaders() {
        list<String> qtrHeaderValues = new list<String>();
        for (Date tempDate = startDate; tempDate <= endDate; ) {
            qtrHeaderValues.add(convertToQtrHeader(mapMonthToQtr.get(tempDate.month()), tempDate.year()));
            tempDate = tempDate.addMonths(3);
        }
        qtrHeaderValues.add(TOTAL_COLUMN_HEADER);
        return qtrHeaderValues;
    }

    /*******************************************************************************************************
    PURPOSE    : Calculate all Month Header values for the selected Time filter
    *******************************************************************************************************/
    private list<string> generateMonthHeaders() {
        list<String> monthHeaderValues = new list<String>();

        for (Date tempDate = startDate; tempDate <= endDate; ) {
            monthHeaderValues.add(convertToMonthHeader(tempDate.month(),tempDate.year()));
            tempDate = tempDate.addMonths(1);
        }
        monthHeaderValues.add(TOTAL_COLUMN_HEADER);
        return monthHeaderValues;
    }

    /*******************************************************************************************************
    PURPOSE    : Fetch and return a list of Opportunity Stage values from Opportunity object
    *******************************************************************************************************/
    private list<String> fetchStageValues() {
        List<String> stageValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            stageValues.add(f.getLabel());
        }

        return stageValues;
    }

    /*******************************************************************************************************
    PURPOSE    : Fetch and return a map of Forecast Category <Value, Label> key-value pairs from LineItemOverride Object
    *******************************************************************************************************/
    private map<String,String> fetchForecastValueToLabel() {
        map<String,String> mapForecastValueToLabel = new map<String,String>();
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Product_Forecast_Category__c.getDescribe();
        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            mapForecastValueToLabel.put(f.getValue(),f.getLabel());
        }
        return mapForecastValueToLabel;
    }

    /*******************************************************************************************************
    PURPOSE    : Fetch and return a list of Region values from Account object
    *******************************************************************************************************/
    private list<String> fetchRegionValues() {
        List<String> regionValues = new List<String>();
        Schema.DescribeFieldResult fieldResult = Account.Region__c.getDescribe();
        for (Schema.PicklistEntry f : fieldResult.getPicklistValues()) {
            regionValues.add(f.getLabel());
        }

        return regionValues;
    }

    /*******************************************************************************************************
    PURPOSE    : Calculate Row and Column totals
    *******************************************************************************************************/
    private list<ResultWrapper> calculateTotals(list<string> headers, list<ResultWrapper> wrappers) {
        if (wrappers!=null && wrappers.size()>0) {
            ResultWrapper totalsRow = new ResultWrapper(null,null,headers);

            if (selectedGroupBy == GRP_BY_ACCOUNT) {
                totalsRow.accountCountry = TOTAL_COLUMN_HEADER;
            } else if (selectedGroupBy == GRP_BY_OPP_STAGE) {
                totalsRow.stage = TOTAL_COLUMN_HEADER;
            } else if (selectedGroupBy == GRP_BY_REGION) {
                totalsRow.region = TOTAL_COLUMN_HEADER;
            } else if (selectedGroupBy == GRP_BY_FORECAST_CAT) {
                totalsRow.forecast = TOTAL_COLUMN_HEADER;
            } else if (selectedGroupBy == GRP_BY_SUB_REGION) {
                totalsRow.accountSubRegion = TOTAL_COLUMN_HEADER;
            } else if (selectedGroupBy == GRP_BY_COUNTRY) {
                totalsRow.accountCountry = TOTAL_COLUMN_HEADER;
            } else if (selectedGroupBy == GRP_BY_PROGRAM) {
                totalsRow.program = TOTAL_COLUMN_HEADER;
            } else if (selectedGroupBy == GRP_BY_Product) {
                totalsRow.product = TOTAL_COLUMN_HEADER;
            } else if (selectedGroupBy == GRP_BY_Project) {
                totalsRow.project = TOTAL_COLUMN_HEADER;
            } else if (selectedGroupBy == GRP_BY_PRODUCT_FAMILY) {
                totalsRow.programFamily = TOTAL_COLUMN_HEADER;
            }

            Long rowTotal;
            for (ResultWrapper wrapper : wrappers) {
                rowTotal = 0;
                for (String header : wrapper.headerWiseQtySum.KeySet()) {
                    totalsRow.headerWiseQtySum.put(header,totalsRow.headerWiseQtySum.get(header)+wrapper.headerWiseQtySum.get(header));
                    rowTotal+=wrapper.headerWiseQtySum.get(header);
                }
                wrapper.headerWiseQtySum.put(TOTAL_COLUMN_HEADER,rowTotal);
                totalsRow.headerWiseQtySum.put(TOTAL_COLUMN_HEADER,totalsRow.headerWiseQtySum.get(TOTAL_COLUMN_HEADER)+rowTotal);
            }
            wrappers.add(totalsRow);
        }
        return wrappers;
    }

    /*******************************************************************************************************
    PURPOSE    : Returns label of Total Column Header
    *******************************************************************************************************/
    public string getTotalHeader() {
        return TOTAL_COLUMN_HEADER;
    }

    /*******************************************************************************************************
    PURPOSE    : check if Account grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByAcc() {
        return selectedGroupBy == GRP_BY_ACCOUNT ? true : false;
    }

    /*******************************************************************************************************
    PURPOSE    : check if Region grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByRegion() {
        return selectedGroupBy == GRP_BY_REGION ? true : false;
    }

    /*******************************************************************************************************
    PURPOSE    : check if Sub Region grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpBySubRegion() {
        return selectedGroupBy == GRP_BY_SUB_REGION ? true : false;
    }

    /*******************************************************************************************************
    PURPOSE    : check if Country grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByCountry() {
        return selectedGroupBy == GRP_BY_COUNTRY ? true : false;
    }

    /*******************************************************************************************************
    PURPOSE    : check if Opportunity Stage grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByOppStage() {
        return selectedGroupBy == GRP_BY_OPP_STAGE ? true : false;
    }

    /*******************************************************************************************************
    PURPOSE    : check if Forecast Category grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByForecast() {
        return selectedGroupBy == GRP_BY_FORECAST_CAT ? true : false;
    }

    /*******************************************************************************************************
    PURPOSE    : check if Forecast Category grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByProgram() {
        return selectedGroupBy == GRP_BY_Program ? true : false;
    }
    public boolean getIsGrpByProduct() {
        return selectedGroupBy == GRP_BY_PRODUCT ? true : false;
    }
     public boolean getIsGrpByProject() {
        return selectedGroupBy == GRP_BY_PROJECT ? true : false;
    }
    public boolean getIsGrpByProductFamily() {
        return selectedGroupBy == GRP_BY_Product_Family ? true : false;
    }

    /*******************************************************************************************************
    PURPOSE    : QuickSort to sort the Selectlist
    *******************************************************************************************************/
    private static List<SelectOption> SortOptionList(List<SelectOption> ListToSort) {
        if (ListToSort == null || ListToSort.size() <= 1)
            return ListToSort;

        List<SelectOption> Less = new List<SelectOption>();
        List<SelectOption> Greater = new List<SelectOption>();
        integer pivot = ListToSort.size() / 2;

        // save the pivot and remove it from the list
        SelectOption pivotValue = ListToSort[pivot];
        ListToSort.remove(pivot);

        for (SelectOption x : ListToSort) {
            if (x.getLabel() <= pivotValue.getLabel())
                Less.add(x);
            else if (x.getLabel() > pivotValue.getLabel()) Greater.add(x);
        }
        List<SelectOption> returnList = new List<SelectOption> ();
        returnList.addAll(SortOptionList(Less));
        returnList.add(pivotValue);
        returnList.addAll(SortOptionList(Greater));
        return returnList;
    }

    /*******************************************************************************************************
    PURPOSE    : Wrapper class to store the data in required format and display on visualforce page
    *******************************************************************************************************/
    public class ResultWrapper {
        public Id accountid {get;set;}
        public String accountName {get;set;}
        public String accountRegion {get;set;}
        public String accountSubRegion {get;set;}
        public String accountCountry {get;set;}
        public String stage {get;set;}
        public String region {get;set;}
        public String forecast {get;set;}
        public String program {get;set;}
        public String programFamily {get;set;}
        public String project {get;set;}
        public String product {get;set;}
        public String businessUnit {get;set;}
        public map<String, Long> headerWiseQtySum{get;set;}
        public Long rowTotal{get;set;}

        //** Constructor **//
        public ResultWrapper(String grpBy, String grpByValue,list<string> headers) {
            UCD_Controller parentClass = new UCD_Controller(true);

            if (grpBy == parentClass.GRP_BY_ACCOUNT) {
                accountid = grpByValue;
                accountName = '';
                accountRegion = '';
                accountSubRegion = '';
                accountCountry = '';
            } else if (grpBy == parentClass.GRP_BY_OPP_STAGE) {
                stage = grpByValue;
            } else if (grpBy == parentClass.GRP_BY_REGION || grpBy == parentClass.GRP_BY_SUB_REGION || grpBy == parentClass.GRP_BY_COUNTRY) {
                region = grpByValue;
            } else if (grpBy == parentClass.GRP_BY_FORECAST_CAT) {
                forecast = grpByValue;
            } else if (grpBy == parentClass.GRP_BY_Program) {
                program = grpByValue;
            } else if (grpBy == parentClass.GRP_BY_Product) {
                product = grpByValue;
            } else if (grpBy == parentClass.GRP_BY_Project) {
                project = grpByValue;
            } else if (grpBy == parentClass.GRP_BY_PRODUCT_FAMILY) {
                programFamily = grpByValue;
            }
            headerWiseQtySum = new map<String, Long>();
            system.debug('grpByValue' + grpByValue);
            for (string header : headers) {
                headerWiseQtySum.put(header, 0);
            }
        }
    }
}