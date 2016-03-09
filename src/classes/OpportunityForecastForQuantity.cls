/*******************************************************************************************************
CREATED BY : Lakshman Sateesh
CREATED ON : 24/Aug/2013
PURPOSE    : To implement the Opportunity Forecast for Quantity based on Region,Product and Time based filters. The output is 
             grouped by Account,Region,Opportunity Stage or Forecast Category.

TEST CLASS : Test_OpportunityForecast.cls
*******************************************************************************************************/
public class OpportunityForecastForQuantity { 
    
    private final string yearPrefix = 'CY ';
    private final string qtrPrefix = 'Q ';
    private final string periodSuffix = ' Period';
    private final string TOTAL_COLUMN_HEADER = 'TOTAL';
    private final string SELECT_ALL_LABEL = '--All--';
    private final string SELECT_ALL_VALUE = '-1';
    private final string LAYOUT_QTR_LABEL = 'Quarterly';
    private final string LAYOUT_QTR_VALUE = 'quater';
    private final string LAYOUT_MONTH_LABEL = 'Monthly';
    private final string LAYOUT_MONTH_VALUE = 'month';
    private final string LAYOUT_BOTH_LABEL = 'Both';
    private final string LAYOUT_BOTH_VALUE = 'both';
    private final string GRP_BY_REGION_LABEL = 'Region';
    private final string GRP_BY_REGION_VALUE = 'region';
    private final string GRP_BY_ACCOUNT_LABEL = 'Account';
    private final string GRP_BY_ACCOUNT_VALUE = 'account';
    private final string GRP_BY_OPP_STAGE_LABEL = 'Opportunity Stage';
    private final string GRP_BY_OPP_STAGE_VALUE = 'oppStage';
    private final string GRP_BY_FORECAST_CAT_LABEL = 'Forecast Category';
    private final string GRP_BY_FORECAST_CAT_VALUE = 'forecastCat';
    private Date startDate;         //Start date of the selected time filter
    private Date endDate;           //End date of the selected time filter
    private string whereClause;
    private string customerInterfaceUserId;
    private Map<Integer,String> mapNumberToMonth = new Map<Integer,String>{1=>'Jan',2=>'Feb',3=>'Mar',4=>'Apr',5=>'May',6=>'Jun',7=>'Jul',8=>'Aug',9=>'Sep',10=>'Oct',11=>'Nov',12=>'Dec'};
    private map<Integer,Integer> mapMonthToQtr = new map<Integer,Integer>{1=>1,2=>1,3=>1,4=>2,5=>2,6=>2,7=>3,8=>3,9=>3,10=>4,11=>4,12=>4};
    public String selectedRegion {get;set;}
    public String selectedSubRegion {get;set;}
    public String selectedCountry {get;set;}
    public String selectedAccount {get;set;}
    public String selectedProduct {get;set;}
    public String selectedFamily {get;set;}
    public String selectedProject {get;set;}
    public String selectedProgram {get;set;}
    public String selectedYear {get;set;}
    public String selectedQtr {get;set;}
    public String selectedPeriods {get;set;}
    public list<string> selectedForecastList {get;set;}
    public set<String> selectedForecastSet {get{
                                                selectedForecastSet = new set<string>();
                                                selectedForecastSet.addAll(selectedForecastList);
                                                return selectedForecastSet;}set;}
    public String selectedLayout {get;set;}
    public String selectedGroupBy {get;set;}
    public List<SelectOption> regionSelectList {get;set;}
    public List<SelectOption> subRegionSelectList {get;set;}
    public List<SelectOption> countrySelectList {get;set;}
    public List<SelectOption> accountSelectList {get;set;}
    public List<SelectOption> productSelectList {get;set;}
    public List<SelectOption> pdtFamilySelectList {get;set;}
    public List<SelectOption> projectSelectList {get;set;}
    public List<SelectOption> programSelectList {get;set;}
    public List<SelectOption> yearSelectList {get;set;}
    public List<SelectOption> qtrSelectList {get;set;}
    public List<SelectOption> periodSelectList {get;set;}
    public List<SelectOption> forecastSelectList {get;set;}
    public List<SelectOption> layoutSelectList {get;set;}
    public List<SelectOption> groupBySelectList {get;set;}
    public List<ResultWrapper> listOfQtrWrapperObj {get;set;}
    public List<ResultWrapper> listOfMonthWrapperObj {get;set;}
    public Map<Id,Account> mapAccountIdToAccount;
    public list<string> qtrHeaders{get;set;}
    public list<String> monthHeaders{get;set;}
    
    //***Constructor***//
    public OpportunityForecastForQuantity(){
        initRegionFilters();
        initProductFilters();
        yearSelectList = getYearSelectOptions();
        qtrSelectList = getQuarterSelectOptions();
        periodSelectList = getPeriodSelectOptions();
        forecastSelectList = getForecastSelectOptions();
        layoutSelectList = getLayoutSelectOptions();
        groupBySelectList = getGroupBySelectOptions();
        mapAccountIdToAccount = new Map<Id,Account>();
        selectedFamily = SELECT_ALL_VALUE;
        selectedForecastList = new List<String>{SELECT_ALL_VALUE};
      }
    
    public pagereference resetAllFilters(){
        initRegionFilters();
        initProductFilters();
        yearSelectList = getYearSelectOptions();
        qtrSelectList = getQuarterSelectOptions();
        periodSelectList = getPeriodSelectOptions();
        forecastSelectList = getForecastSelectOptions();
        layoutSelectList = getLayoutSelectOptions();
        groupBySelectList = getGroupBySelectOptions();
        mapAccountIdToAccount = new Map<Id,Account>();
        selectedRegion = '';
        selectedSubRegion =  '';
        selectedCountry =  '';
        selectedAccount = '';
        selectedFamily = '';
        selectedProject = '';
        selectedProgram = '';
        //selectedYear = '';
        //selectedQtr = '';
        selectedPeriods = '';
        selectedForecastList = new List<String>{SELECT_ALL_VALUE};
        selectedLayout = '';
        selectedGroupBy = '';
        listOfQtrWrapperObj = null;
        listOfMonthWrapperObj = null;
        return null;
    }
    
    //*** Constructor without any initialization of parameters ***//
    public OpportunityForecastForQuantity(Boolean isBlank){}
    
    public PageReference xlsExport(){
    
        pageReference ref = new PageReference('/apex/UCD_Xls_Export');
        return ref;
    
    
    }
    
    /*******************************************************************************************************
    PURPOSE    : Initialize or reset the Region,Subregion and Country related filters
    *******************************************************************************************************/
    private void initRegionFilters(){
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
    public List<SelectOption> getRegionSelectOptions(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
       Schema.DescribeFieldResult fieldResult = Account.Region__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getValue(), f.getLabel()));
       }  
       return options;     
    }
    
    /*******************************************************************************************************
    PURPOSE    : Populate the SubRegion select options based on the selected Region value
    *******************************************************************************************************/
    public PageReference updateSubRegionFilters(){
        resetSubRegionSelectList();
        resetCountrySelectList();
        updateAccountFilters();
        
        if(selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE){
            AggregateResult[] results = [Select Sub_Region__c sRegion From Account Where Region__c=:selectedRegion AND Sub_Region__c!=null AND Sub_Region__c!='' GROUP BY Sub_Region__c];
            for (AggregateResult ar : results) {
                subRegionSelectList.add(new SelectOption((String)ar.get('sRegion'),(String)ar.get('sRegion')));
            }
        }
        
        return null;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Populate the Country select options based on the selected Region and SubRegion values
    *******************************************************************************************************/
    public PageReference updateCountryFilters(){
        resetCountrySelectList();
        updateAccountFilters();
        
        if(selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE && selectedSubRegion != NULL && selectedSubRegion != SELECT_ALL_VALUE){
            AggregateResult[] results = [Select Country__c cntry From Account Where Region__c=:selectedRegion AND Sub_Region__c=:selectedSubRegion AND Country__c!=null AND Country__c!='' GROUP BY Country__c];
            for (AggregateResult ar : results) {
                countrySelectList.add(new SelectOption((String)ar.get('cntry'),(String)ar.get('cntry')));
            }
        }
        return null;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Populate the Account select options based on the selected Region,SubRegion and County values
    *******************************************************************************************************/
    public PageReference updateAccountFilters(){
        resetAccountSelectList();
        
        String Qry = 'Select Id, Name from Account';
        String WhereClause = '';
        
        if(selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE){
            WhereClause += ' Region__c =\''+ selectedRegion  + '\'';
        
            if(selectedSubRegion != NULL && selectedSubRegion != SELECT_ALL_VALUE){
                if(WhereClause != ''){
                    WhereClause += ' AND ';
                }
                WhereClause += ' Sub_Region__c =\''+ selectedSubRegion  + '\'';
            }
            
            if(selectedCountry != NULL && selectedCountry != SELECT_ALL_VALUE){
                if(WhereClause != ''){
                    WhereClause += ' AND ';
                }
                WhereClause += 'Country__c =\''+ selectedCountry  + '\'';
            }
            
            Qry += ' Where Allow_Opportunities__c=true and Active__c=true and ' + WhereClause + ' Order by Name Asc limit 300';
            
            List<Account> AccountResults = database.query(Qry);
            
            String name;
            for (Account ar : AccountResults) {
                name = ar.name.length()>25 ? ar.name.substring(0,25)+'..' : ar.Name;
                
                accountSelectList.add(new SelectOption(ar.id,name));
            }
        }
        
        return null;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Initialize SubRegion select options
    *******************************************************************************************************/
    private void resetSubRegionSelectList(){
        subRegionSelectList.clear();
        subRegionSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL)); 
        selectedSubRegion = SELECT_ALL_VALUE;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Intialize Country select options
    *******************************************************************************************************/
    private void resetCountrySelectList(){
        countrySelectList.clear();
        countrySelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL)); 
        selectedCountry = SELECT_ALL_VALUE;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Intialize Account select options
    *******************************************************************************************************/
    private void resetAccountSelectList(){
        accountSelectList.clear();
        accountSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL)); 
        selectedAccount = SELECT_ALL_VALUE;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Initialize or reset the Product,ProductFamily,Program and Project related filters
    *******************************************************************************************************/
    private void initProductFilters(){
        pdtFamilySelectList = getPdtFamilySelectOptions();
        programSelectList = new List<SelectOption>();
        projectSelectList =  new List<SelectOption>();
        productSelectList =  new List<SelectOption>();
        resetPgmSelectList();
        resetProjSelectList();
        resetPdtSelectList();
    }
    
    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Product Family select options based on available values on Product object
    *******************************************************************************************************/
    public List<SelectOption> getPdtFamilySelectOptions(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
       Schema.DescribeFieldResult fieldResult = Product2.Family.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getLabel(), f.getValue()));
       }  
       return options;     
    }
    
    /*******************************************************************************************************
    PURPOSE    : Populate the Product Program select options based on selected Product Family value
    *******************************************************************************************************/
    public PageReference updatePgmFilters(){
        resetPgmSelectList();
        resetProjSelectList();
        resetPdtSelectList();
        
        if(selectedFamily != NULL && selectedFamily != SELECT_ALL_VALUE){
            AggregateResult[] results = [Select Program__c pgm From Product2 Where Family=:selectedFamily AND Program__c!=null AND Program__c!='' GROUP BY Program__c];
            for (AggregateResult ar : results) {
                programSelectList.add(new SelectOption((String)ar.get('pgm'),(String)ar.get('pgm')));
            }
        }
        
        return null;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Populate the Product Project select options based on selected Product Family and Program values
    *******************************************************************************************************/
    public PageReference updateProjFilters(){
        resetProjSelectList();
        resetPdtSelectList();
        
        if(selectedFamily != NULL && selectedFamily != SELECT_ALL_VALUE && selectedProgram != NULL && selectedProgram != SELECT_ALL_VALUE){
            AggregateResult[] results = [Select Project__c proj From Product2 Where Family=:selectedFamily AND Program__c=:selectedProgram AND Project__c!=null AND Project__c!=''  GROUP BY Project__c];
            for (AggregateResult ar : results) {
                projectSelectList.add(new SelectOption((String)ar.get('proj'),(String)ar.get('proj')));
            }
        }
        return null;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Populate the Product select options based on selected Product Family, Program and Project values
    *******************************************************************************************************/
    public PageReference updatePdtFilters(){
        resetPdtSelectList();
        
        if(selectedFamily != NULL && selectedFamily != SELECT_ALL_VALUE && selectedProgram != NULL && selectedProgram != SELECT_ALL_VALUE && selectedProject != NULL && selectedProject != SELECT_ALL_VALUE){
            List<Product2> lstOfProduct2 = [Select Id,Name From Product2 Where Family=:selectedFamily AND Program__c=:selectedProgram AND Project__c=:selectedProject];
            if(lstOfProduct2 != NULL && lstOfProduct2.Size()>0){
                for(Product2 pdt:lstOfProduct2){
                    productSelectList.add(new SelectOption(pdt.Id,pdt.Name));
                }
            }
        }
        return null;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Initialize Product Program select options
    *******************************************************************************************************/
    private void resetPgmSelectList(){
        programSelectList.clear();
        programSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedProgram = SELECT_ALL_VALUE;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Initialize Product Project select options
    *******************************************************************************************************/
    private void resetProjSelectList(){
        projectSelectList.clear();
        projectSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedProject = SELECT_ALL_VALUE;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Initialize Product select options
    *******************************************************************************************************/
    private void resetPdtSelectList(){
        productSelectList.clear();
        productSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL)); 
        selectedProduct = SELECT_ALL_VALUE;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Year select options
    *******************************************************************************************************/
    public List<SelectOption> getYearSelectOptions(){
        List<SelectOption> options = new List<SelectOption>();
        for(Integer index=2013; index<=2018; index++){
            options.add(new SelectOption(String.valueOf(index), yearPrefix+index));
        }
        selectedYear = String.valueOf(DateTime.Now().Year());
        return options;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Quarter select options
    *******************************************************************************************************/
    public List<SelectOption> getQuarterSelectOptions(){
        List<SelectOption> options = new List<SelectOption>();
        for(Integer index=1; index<=4; index++){
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
        for(Integer index=1; index<=6; index++){
            options.add(new SelectOption(String.valueOf(index), index+periodSuffix));
        }
        return options;   
    }
    
    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Forecast Category select options based on available values in
                 OpportunityLineItem object
    *******************************************************************************************************/
    public List<SelectOption> getForecastSelectOptions(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
       Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Product_Forecast_Category__c.getDescribe();
       List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
       for( Schema.PicklistEntry f : ple){
          options.add(new SelectOption(f.getValue(),f.getLabel()));
       }  
       return options;     
    }
    
    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of output Layout select options
    *******************************************************************************************************/
    public List<SelectOption> getLayoutSelectOptions(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(LAYOUT_QTR_VALUE, LAYOUT_QTR_LABEL));
       options.add(new SelectOption(LAYOUT_MONTH_VALUE, LAYOUT_MONTH_LABEL));
       options.add(new SelectOption(LAYOUT_BOTH_VALUE, LAYOUT_BOTH_LABEL));
       return options;     
    }
    
    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Group By select options
    *******************************************************************************************************/
    public List<SelectOption> getGroupBySelectOptions(){
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(GRP_BY_REGION_VALUE, GRP_BY_REGION_LABEL));
       options.add(new SelectOption(GRP_BY_ACCOUNT_VALUE, GRP_BY_ACCOUNT_LABEL));
       options.add(new SelectOption(GRP_BY_OPP_STAGE_VALUE, GRP_BY_OPP_STAGE_LABEL));
       options.add(new SelectOption(GRP_BY_FORECAST_CAT_VALUE, GRP_BY_FORECAST_CAT_LABEL));
       return options;     
    }
    
    /*******************************************************************************************************
    PURPOSE    : Prepare and return a Map of <AccountId,AccountRecord> key-value pairs, based on the received
                 set of Account Ids
    *******************************************************************************************************/
    private Map<Id,Account> createAccountMap(set<String> accIds){
        Map<Id,Account> mapIdToAccount = new Map<Id,Account>();
        
        if(accIds != null && accIds.size()>0){
            for(Account acc : [Select Id, Name, Region__c, Sub_Region__c, Country__c from Account where Id IN :accIds]){
                mapIdToAccount.put(acc.Id, acc);
            }
        }
        
        return mapIdToAccount;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Main method to perform the search in database based on the user selected filters 
    *******************************************************************************************************/
    public PageReference doSearch() {
        try{
            mapAccountIdToAccount.clear();
            listOfQtrWrapperObj = null;
            listOfMonthWrapperObj = null;
            getStartNEndDates();
            whereClause  = prepareWhereClause();
            
            if(selectedLayout == LAYOUT_BOTH_VALUE || selectedLayout == LAYOUT_QTR_VALUE){
                prepareQuarterWiseData();
            }
            if(selectedLayout == LAYOUT_BOTH_VALUE || selectedLayout == LAYOUT_MONTH_VALUE){
                prepareMonthWiseData();
            }
        }catch(Exception ex){
            ApexPages.Message msgs = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
            ApexPages.addMessage(msgs);
        }
        return null;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Quarter wise data based on the selected data Grouping.
                 Invoked from 'doSearch' method.
    *******************************************************************************************************/
    private void prepareQuarterWiseData(){
        listOfQtrWrapperObj = new List<ResultWrapper>();
        qtrHeaders = generateQtrHeaders();
        
        if(selectedGroupBy == GRP_BY_ACCOUNT_VALUE){
            listOfQtrWrapperObj = prepareQuarterWiseData_By_Account();
        } if(selectedGroupBy == GRP_BY_OPP_STAGE_VALUE){
            listOfQtrWrapperObj = prepareQuarterWiseData_By_OptyStage();
        } if(selectedGroupBy == GRP_BY_REGION_VALUE){
            listOfQtrWrapperObj = prepareQuarterWiseData_By_Region();
        } if(selectedGroupBy == GRP_BY_FORECAST_CAT_VALUE){
            listOfQtrWrapperObj = prepareQuarterWiseData_By_Forecast();
        }
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Month wise data based on the selected data Grouping.
                 Invoked from 'doSearch' method.
    *******************************************************************************************************/
    private void prepareMonthWiseData(){
        listOfMonthWrapperObj = new List<ResultWrapper>();
        monthHeaders = generateMonthHeaders();
        
        if(selectedGroupBy == GRP_BY_ACCOUNT_VALUE){
            listOfMonthWrapperObj = prepareMonthWiseData_By_Account();
        } if(selectedGroupBy == GRP_BY_OPP_STAGE_VALUE){
            listOfMonthWrapperObj = prepareMonthWiseData_By_OptyStage();
        } if(selectedGroupBy == GRP_BY_REGION_VALUE){
            listOfMonthWrapperObj = prepareMonthWiseData_By_Region();
        } if(selectedGroupBy == GRP_BY_FORECAST_CAT_VALUE){
            listOfMonthWrapperObj = prepareMonthWiseData_By_Forecast();
        }
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Month wise data for Account Name based grouping.
                 Invoked from 'prepareMonthWiseData' method.
    *******************************************************************************************************/
    private List<ResultWrapper> prepareMonthWiseData_By_Account(){
        List<ResultWrapper> listOfMonthWrapperObjTemp = new List<ResultWrapper>();
        String Qry = 'Select Opportunity.AccountId accId,CALENDAR_YEAR(ServiceDate) year, CALENDAR_MONTH(ServiceDate) month, SUM(Quantity)Qty From OpportunityLineItem';
        String GrpClause = ' Group By Opportunity.AccountId,CALENDAR_YEAR(ServiceDate),CALENDAR_MONTH(ServiceDate)';
        Qry  += ' WHERE ' +  whereClause + GrpClause;
        
        List<AggregateResult> results = database.query(Qry);
        
        Map<String,ResultWrapper> mapAccIdToMonthWrapper = new Map<String,ResultWrapper>();
        String accId;
        Integer month;
        Integer year;
        String monthHeaderValue;
        for (AggregateResult ar : results) {
            accId = (String)ar.get('accId');
            year = (Integer)ar.get('year');
            month = (Integer)ar.get('month');
            if(!mapAccIdToMonthWrapper.containsKey(accId)){
                mapAccIdToMonthWrapper.put(accId, new ResultWrapper(selectedGroupBy,accId,monthHeaders));
            }
            monthHeaderValue = convertToMonthHeader(month, year);
            mapAccIdToMonthWrapper.get(accId).headerWiseQtySum.put(monthHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }
        
        if(mapAccountIdToAccount.size()==0){
            mapAccountIdToAccount = createAccountMap(mapAccIdToMonthWrapper.keySet());  
        }
        
        listOfMonthWrapperObjTemp = mapAccIdToMonthWrapper.values();
        
        Account acc;
        for(ResultWrapper wrap : listOfMonthWrapperObjTemp){
            acc = mapAccountIdToAccount.get(wrap.accountid);
            wrap.accountName = acc.Name;
            wrap.accountRegion = acc.Region__c;
            wrap.accountSubRegion = acc.Sub_Region__c;
            wrap.accountCountry = acc.Country__c;
        }
        
        listOfMonthWrapperObjTemp = calculateTotals(monthHeaders, listOfMonthWrapperObjTemp);
        
        return listOfMonthWrapperObjTemp;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Month wise data for Opportunity Stage based grouping.
                 Invoked from 'prepareMonthWiseData' method.
    *******************************************************************************************************/
    private List<ResultWrapper> prepareMonthWiseData_By_OptyStage(){
        List<ResultWrapper> listOfMonthWrapperObjTemp = new List<ResultWrapper>();
        Map<String,ResultWrapper> mapStageToMonthWrapper = new Map<String,ResultWrapper>();
        
        for(String stageName : fetchStageValues()){
            mapStageToMonthWrapper.put(stageName, new ResultWrapper(selectedGroupBy,stageName,monthHeaders));
        }     
        
        String Qry = 'Select Opportunity.Stagename stg,CALENDAR_YEAR(ServiceDate) year, CALENDAR_MONTH(ServiceDate) month, SUM(Quantity)Qty From OpportunityLineItem';
        String GrpClause = ' Group By Opportunity.Stagename,CALENDAR_YEAR(ServiceDate),CALENDAR_MONTH(ServiceDate)';
        Qry  += ' WHERE ' +  whereClause + GrpClause;
        
        List<AggregateResult> results = database.query(Qry);
        
        String stage;
        Integer month;
        Integer year;
        String monthHeaderValue;
        for (AggregateResult ar : results) {
            stage = (String)ar.get('stg');
            year = (Integer)ar.get('year');
            month = (Integer)ar.get('month');
            if(!mapStageToMonthWrapper.containsKey(stage)){
                mapStageToMonthWrapper.put(stage, new ResultWrapper(selectedGroupBy,stage,monthHeaders));
            }
            monthHeaderValue = convertToMonthHeader(month, year);
            mapStageToMonthWrapper.get(stage).headerWiseQtySum.put(monthHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }
        
        List<string> listSortedStages = new List<String>();
        listSortedStages.addAll(mapStageToMonthWrapper.keySet());
        listSortedStages.sort();
        for(String stageName : listSortedStages){
            listOfMonthWrapperObjTemp.add(mapStageToMonthWrapper.get(stageName));
        }
        
        listOfMonthWrapperObjTemp = calculateTotals(monthHeaders, listOfMonthWrapperObjTemp);
        
        return listOfMonthWrapperObjTemp;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Quarter wise data for Account Name based grouping.
                 Invoked from 'prepareQuarterWiseData' method.
    *******************************************************************************************************/
    private List<ResultWrapper> prepareQuarterWiseData_By_Account(){
        List<ResultWrapper> listOfQtrWrapperObjTemp = new List<ResultWrapper>();
        
        String Qry = 'Select Opportunity.AccountId accId,CALENDAR_YEAR(ServiceDate) year, CALENDAR_QUARTER(ServiceDate) qtr, SUM(Quantity)Qty From OpportunityLineItem';
        String GrpClause = ' Group By Opportunity.AccountId, CALENDAR_YEAR(ServiceDate),CALENDAR_QUARTER(ServiceDate) ORDER BY CALENDAR_YEAR(ServiceDate) ASC,CALENDAR_QUARTER(ServiceDate) ASC';
        Qry  += ' WHERE ' +  whereClause + GrpClause;
        
        AggregateResult[] results = database.query(Qry);
        
        Map<String,ResultWrapper> mapAccIdToQtrWrapper = new Map<String,ResultWrapper>();
        String accId;
        Integer qtr;
        Integer year;
        String qtrHeaderValue;
        for (AggregateResult ar : results) {
            accId = (String)ar.get('accId');
            year = (Integer)ar.get('year');
            qtr = (Integer)ar.get('qtr');
            if(!mapAccIdToQtrWrapper.containsKey(accId)){
                mapAccIdToQtrWrapper.put(accId, new ResultWrapper(selectedGroupBy,accId,qtrHeaders));
            }
            qtrHeaderValue = convertToQtrHeader(qtr, year);
            mapAccIdToQtrWrapper.get(accId).headerWiseQtySum.put(qtrHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }
        
        if(mapAccountIdToAccount.size()==0){
            mapAccountIdToAccount = createAccountMap(mapAccIdToQtrWrapper.keySet());    
        }
        
        listOfQtrWrapperObjTemp = mapAccIdToQtrWrapper.values();
        
        Account acc;
        for(ResultWrapper wrap : listOfQtrWrapperObjTemp){
            acc = mapAccountIdToAccount.get(wrap.accountid);
            wrap.accountName = acc.Name;
            wrap.accountRegion = acc.Region__c;
            wrap.accountSubRegion = acc.Sub_Region__c;
            wrap.accountCountry = acc.Country__c;
        }
        
        listOfQtrWrapperObjTemp = calculateTotals(qtrHeaders, listOfQtrWrapperObjTemp);
        
        return listOfQtrWrapperObjTemp;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Quarter wise data for Opportunity Stage based grouping.
                 Invoked from 'prepareQuarterWiseData' method.
    *******************************************************************************************************/
    private List<ResultWrapper> prepareQuarterWiseData_By_OptyStage(){
        List<ResultWrapper> listOfQtrWrapperObjTemp = new List<ResultWrapper>();
        Map<String,ResultWrapper> mapStageToQtrWrapper = new Map<String,ResultWrapper>();
        
        for(String stageName : fetchStageValues()){
            mapStageToQtrWrapper.put(stageName, new ResultWrapper(selectedGroupBy,stageName,qtrHeaders));
        } 
        
        String Qry = 'Select Opportunity.StageName stg,CALENDAR_YEAR(ServiceDate) year, CALENDAR_QUARTER(ServiceDate) qtr, SUM(Quantity)Qty From OpportunityLineItem';
        String GrpClause = ' Group By Opportunity.StageName, CALENDAR_YEAR(ServiceDate),CALENDAR_QUARTER(ServiceDate) ORDER BY CALENDAR_YEAR(ServiceDate) ASC,CALENDAR_QUARTER(ServiceDate) ASC';
        Qry  += ' WHERE ' +  whereClause + GrpClause;
        
        AggregateResult[] results = database.query(Qry);
        
        String stage;
        Integer qtr;
        Integer year;
        String qtrHeaderValue;
        for (AggregateResult ar : results) {
            stage = (String)ar.get('stg');
            year = (Integer)ar.get('year');
            qtr = (Integer)ar.get('qtr');
            if(!mapStageToQtrWrapper.containsKey(stage)){
                mapStageToQtrWrapper.put(stage, new ResultWrapper(selectedGroupBy,stage,qtrHeaders));
            }
            qtrHeaderValue = convertToQtrHeader(qtr, year);
            mapStageToQtrWrapper.get(stage).headerWiseQtySum.put(qtrHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }
        
        List<string> listSortedStages = new List<String>();
        listSortedStages.addAll(mapStageToQtrWrapper.keySet());
        listSortedStages.sort();
        for(String stageName : listSortedStages){
            listOfQtrWrapperObjTemp.add(mapStageToQtrWrapper.get(stageName));
        }
        
        listOfQtrWrapperObjTemp = calculateTotals(qtrHeaders, listOfQtrWrapperObjTemp);
        
        return listOfQtrWrapperObjTemp;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Quarter wise data for Region based grouping.
                 Invoked from 'prepareQuarterWiseData' method.
    *******************************************************************************************************/
    private List<ResultWrapper> prepareQuarterWiseData_By_Region(){
        List<ResultWrapper> listOfQtrWrapperObjTemp = new List<ResultWrapper>();
        Map<String,ResultWrapper> mapRegionToQtrWrapper = new Map<String,ResultWrapper>();
        
        for(String regionName : fetchRegionValues()){
            mapRegionToQtrWrapper.put(regionName, new ResultWrapper(selectedGroupBy,regionName,qtrHeaders));
        } 
        
        String Qry = 'Select Opportunity.Account.Region__c reg,CALENDAR_YEAR(ServiceDate) year, CALENDAR_QUARTER(ServiceDate) qtr, SUM(Quantity)Qty From OpportunityLineItem';
        String GrpClause = ' Group By Opportunity.Account.Region__c, CALENDAR_YEAR(ServiceDate),CALENDAR_QUARTER(ServiceDate) ORDER BY CALENDAR_YEAR(ServiceDate) ASC,CALENDAR_QUARTER(ServiceDate) ASC';
        Qry  += ' WHERE ' +  whereClause + GrpClause;
        
        AggregateResult[] results = database.query(Qry);
        
        String reg;
        Integer qtr;
        Integer year;
        String qtrHeaderValue;
        for (AggregateResult ar : results) {
            reg = (String)ar.get('reg');
            year = (Integer)ar.get('year');
            qtr = (Integer)ar.get('qtr');
            if(!mapRegionToQtrWrapper.containsKey(reg)){
                mapRegionToQtrWrapper.put(reg, new ResultWrapper(selectedGroupBy,reg,qtrHeaders));
            }
            qtrHeaderValue = convertToQtrHeader(qtr, year);
            mapRegionToQtrWrapper.get(reg).headerWiseQtySum.put(qtrHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }
        
        List<string> listSortedRegion = new List<String>();
        listSortedRegion.addAll(mapRegionToQtrWrapper.keySet());
        listSortedRegion.sort();
        for(String regionName : listSortedRegion){
            listOfQtrWrapperObjTemp.add(mapRegionToQtrWrapper.get(regionName));
        }
        
        listOfQtrWrapperObjTemp = calculateTotals(qtrHeaders, listOfQtrWrapperObjTemp);
        
        return listOfQtrWrapperObjTemp;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Month wise data for Region based grouping.
                 Invoked from 'prepareMonthWiseData' method.
    *******************************************************************************************************/
    private List<ResultWrapper> prepareMonthWiseData_By_Region(){
        List<ResultWrapper> listOfMonthWrapperObjTemp = new List<ResultWrapper>();
        Map<String,ResultWrapper> mapRegionToMonthWrapper = new Map<String,ResultWrapper>();
        
        for(String regionName : fetchRegionValues()){
            mapRegionToMonthWrapper.put(regionName, new ResultWrapper(selectedGroupBy,regionName,monthHeaders));
        }     
        
        String Qry = 'Select Opportunity.Account.Region__c reg,CALENDAR_YEAR(ServiceDate) year, CALENDAR_MONTH(ServiceDate) month, SUM(Quantity)Qty From OpportunityLineItem';
        String GrpClause = ' Group By Opportunity.Account.Region__c,CALENDAR_YEAR(ServiceDate),CALENDAR_MONTH(ServiceDate)';
        Qry  += ' WHERE ' +  whereClause + GrpClause;
        
        List<AggregateResult> results = database.query(Qry);
        
        String reg;
        Integer month;
        Integer year;
        String monthHeaderValue;
        for (AggregateResult ar : results) {
            reg = (String)ar.get('reg');
            year = (Integer)ar.get('year');
            month = (Integer)ar.get('month');
            if(!mapRegionToMonthWrapper.containsKey(reg)){
                mapRegionToMonthWrapper.put(reg, new ResultWrapper(selectedGroupBy,reg,monthHeaders));
            }
            monthHeaderValue = convertToMonthHeader(month, year);
            mapRegionToMonthWrapper.get(reg).headerWiseQtySum.put(monthHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }
        
        List<string> listSortedRegion = new List<String>();
        listSortedRegion.addAll(mapRegionToMonthWrapper.keySet());
        listSortedRegion.sort();
        for(String regionName : listSortedRegion){
            listOfMonthWrapperObjTemp.add(mapRegionToMonthWrapper.get(regionName));
        }
        
        listOfMonthWrapperObjTemp = calculateTotals(monthHeaders, listOfMonthWrapperObjTemp);
        
        return listOfMonthWrapperObjTemp;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Quarter wise data for Forecast Category based grouping.
                 Invoked from 'prepareQuarterWiseData' method.
    *******************************************************************************************************/
    private List<ResultWrapper> prepareQuarterWiseData_By_Forecast(){
        List<ResultWrapper> listOfQtrWrapperObjTemp = new List<ResultWrapper>();
        Map<String,ResultWrapper> mapForecastToQtrWrapper = new Map<String,ResultWrapper>();
        map<string,string> mapForecastValueToLabel = fetchForecastValueToLabel();
        
        if(!selectedForecastSet.contains(SELECT_ALL_VALUE)){
            for(String forecast : selectedForecastSet){
                mapForecastToQtrWrapper.put(forecast, new ResultWrapper(selectedGroupBy,forecast,qtrHeaders));
            }
        } else {
            for(String forecast : mapForecastValueToLabel.values()){
                mapForecastToQtrWrapper.put(forecast, new ResultWrapper(selectedGroupBy,forecast,qtrHeaders));
            }
        }
        
        String Qry = 'Select Product_Forecast_Category__c catg,CALENDAR_YEAR(ServiceDate) year, CALENDAR_QUARTER(ServiceDate) qtr, SUM(Quantity)Qty From OpportunityLineItem';
        String GrpClause = ' Group By Product_Forecast_Category__c, CALENDAR_YEAR(ServiceDate),CALENDAR_QUARTER(ServiceDate) ORDER BY CALENDAR_YEAR(ServiceDate) ASC,CALENDAR_QUARTER(ServiceDate) ASC';
        Qry  += ' WHERE ' +  whereClause + GrpClause;
        
        List<AggregateResult> results = database.query(Qry);
       
        String Overrideforecast;
        Integer qtr;
        Integer year;
        String qtrHeaderValue;
        for (AggregateResult ar : results) {
            year = (Integer)ar.get('year');
            qtr = (Integer)ar.get('qtr');
            Overrideforecast = mapForecastValueToLabel.get((String)ar.get('catg'));
            if(!mapForecastToQtrWrapper.containsKey(Overrideforecast)){
                mapForecastToQtrWrapper.put(Overrideforecast, new ResultWrapper(selectedGroupBy,Overrideforecast,qtrHeaders));
            }
            qtrHeaderValue = convertToQtrHeader(qtr, year);
            mapForecastToQtrWrapper.get(Overrideforecast).headerWiseQtySum.put(qtrHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }
        
        List<string> listSortedForecast = new List<String>();
        listSortedForecast.addAll(mapForecastToQtrWrapper.keySet());
        listSortedForecast.sort();
        for(String forecast : listSortedForecast){
            listOfQtrWrapperObjTemp.add(mapForecastToQtrWrapper.get(forecast));
        }
        
        listOfQtrWrapperObjTemp = calculateTotals(qtrHeaders, listOfQtrWrapperObjTemp);
        
        return listOfQtrWrapperObjTemp;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method responsible for preparing Month wise data for Forecast Category based grouping.
                 Invoked from 'prepareMonthWiseData' method.
    *******************************************************************************************************/
    private List<ResultWrapper> prepareMonthWiseData_By_Forecast(){
        List<ResultWrapper> listOfMonthWrapperObjTemp = new List<ResultWrapper>();
        Map<String,ResultWrapper> mapForecastToMonthWrapper = new Map<String,ResultWrapper>();
        map<string,string> mapForecastValueToLabel = fetchForecastValueToLabel();
        
        if(!selectedForecastSet.contains(SELECT_ALL_VALUE)){
            for(String forecast : selectedForecastSet){
                mapForecastToMonthWrapper.put(forecast, new ResultWrapper(selectedGroupBy,forecast,monthHeaders));
            }
        } else {
            for(String forecast : mapForecastValueToLabel.values()){
                mapForecastToMonthWrapper.put(forecast, new ResultWrapper(selectedGroupBy,forecast,monthHeaders));
            }
        }
        
        String Qry = 'Select Product_Forecast_Category__c catg,CALENDAR_YEAR(ServiceDate) year, CALENDAR_MONTH(ServiceDate) month, SUM(Quantity)Qty From OpportunityLineItem';
        String GrpClause = ' Group By Product_Forecast_Category__c,CALENDAR_YEAR(ServiceDate),CALENDAR_MONTH(ServiceDate)';
        Qry  += ' WHERE ' +  whereClause + GrpClause;
        
        List<AggregateResult> results = database.query(Qry);
        
        String Overrideforecast;
        Integer month;
        Integer year;
        String monthHeaderValue;
        for (AggregateResult ar : results) {
            year = (Integer)ar.get('year');
            month = (Integer)ar.get('month');
            Overrideforecast = mapForecastValueToLabel.get((String)ar.get('catg'));
            if(!mapForecastToMonthWrapper.containsKey(Overrideforecast)){
                mapForecastToMonthWrapper.put(Overrideforecast, new ResultWrapper(selectedGroupBy,Overrideforecast,monthHeaders));
            }
            monthHeaderValue = convertToMonthHeader(month, year);
            mapForecastToMonthWrapper.get(Overrideforecast).headerWiseQtySum.put(monthHeaderValue,Math.roundToLong((Double)ar.get('Qty')));
        }
        
        List<string> listSortedForecast = new List<String>();
        listSortedForecast.addAll(mapForecastToMonthWrapper.keySet());
        listSortedForecast.sort();
        for(String forecast : listSortedForecast){
            listOfMonthWrapperObjTemp.add(mapForecastToMonthWrapper.get(forecast));
        }
        
        listOfMonthWrapperObjTemp = calculateTotals(monthHeaders, listOfMonthWrapperObjTemp);
        
        return listOfMonthWrapperObjTemp;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Method prepares and returns the SOQL Where clause based on the selected Region, Product
                 and Time filters
    *******************************************************************************************************/   
    private string prepareWhereClause(){
        String WhereClause  = ' ServiceDate<=:endDate and ServiceDate>=:startDate';
        
        if(selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE){
            if(WhereClause != ''){
                WhereClause += ' AND ';
            }
            WhereClause += ' Opportunity.Account.Region__c =\''+ selectedRegion  + '\'';
        }
        
        if(selectedSubRegion != NULL && selectedSubRegion != SELECT_ALL_VALUE){
            if(WhereClause != ''){
                WhereClause += ' AND ';
            }
            WhereClause += ' Opportunity.Account.Sub_Region__c =\''+ selectedSubRegion  + '\'';
        }
        
        if(selectedCountry != NULL && selectedCountry != SELECT_ALL_VALUE){
            if(WhereClause != ''){
                WhereClause += ' AND ';
            }
            WhereClause += ' Opportunity.Account.Country__c =\''+ selectedCountry  + '\'';
        }
        
        if(selectedProduct != NULL && selectedProduct != SELECT_ALL_VALUE){
            if(WhereClause != ''){
                WhereClause += ' AND ';
            }
            WhereClause += ' PricebookEntry.Product2Id =\''+ selectedProduct  + '\'';
        }
        if(selectedFamily != NULL && selectedFamily != SELECT_ALL_VALUE){
            if(WhereClause != ''){
                WhereClause += ' AND ';
            }
            WhereClause += ' PricebookEntry.Product2.Family =\''+ selectedFamily  + '\'';
        }
        if(selectedProject != NULL && selectedProject != SELECT_ALL_VALUE){
            if(WhereClause != ''){
                WhereClause += ' AND ';
            }
            WhereClause += ' PricebookEntry.Product2.Project__c =\''+ selectedProject  + '\'';
        }
        if(selectedProgram != NULL && selectedProgram != SELECT_ALL_VALUE){
            if(WhereClause != ''){
                WhereClause += ' AND ';
            }
            WhereClause += ' PricebookEntry.Product2.Program__c =\''+  selectedProgram  + '\'';
        }
        
        if(!selectedForecastSet.contains(SELECT_ALL_VALUE)){
            if(whereClause != ''){
                whereClause += ' AND ';
            }
            whereClause += ' Product_Forecast_Category__c IN:selectedForecastSet';
        }
        
        if(selectedAccount != NULL && selectedAccount != SELECT_ALL_VALUE){
             if(whereClause != ''){
                whereClause += ' AND ';
            }
            whereClause += ' Opportunity.AccountId =\''+ selectedAccount  + '\'';
        }
        
        return WhereClause;
    }
    
    
    /*******************************************************************************************************
    PURPOSE    : Calculate Start and End Date based on the selected Time filters
    *******************************************************************************************************/
    /* private void getStartNEndDates(){
        map<String,String> mapQtrToStartDate = new map<String,String>{'1'=>'01/01','2'=>'04/01','3'=>'07/01','4'=>'10/01'};
        startDate = Date.parse(mapQtrToStartDate.get(selectedQtr)+'/'+selectedYear);
        endDate = startDate.addMonths(Integer.valueOf(selectedPeriods)*3).addDays(-1);
    } */
   
   private void getStartNEndDates(){
        map<String,String> mapQtrToStartDate = new map<String,String>();
        Integer intSelectedYear = integer.valueof(SelectedYear);
        String Quarter1Start = date.newinstance(intSelectedYear,1,1).format();
        String Quarter2Start = date.newinstance(intSelectedYear,4,1).format();
        String Quarter3Start = date.newinstance(intSelectedYear,7,1).format();
        String Quarter4Start = date.newinstance(intSelectedYear,10,1).format();
        mapQtrToStartDate.put('1',Quarter1Start);
        mapQtrToStartDate.put('2',Quarter2Start);
        mapQtrToStartDate.put('3',Quarter3Start);
        mapQtrToStartDate.put('4',Quarter4Start);   
        startDate = Date.parse(mapQtrToStartDate.get(selectedQtr));
        endDate = startDate.addMonths(Integer.valueOf(selectedPeriods)*3).addDays(-1);
 }
    
    /*******************************************************************************************************
    PURPOSE    : Calculate Quater Header based on received Quarter and Year value
    *******************************************************************************************************/
    private String convertToQtrHeader(Integer qtrNumber, Integer year){
        return 'Q'+qtrNumber+'\''+String.valueOf(year).substring(2, 4);
    }
    
    /*******************************************************************************************************
    PURPOSE    : Calculate Month Header based on received Month and Year value
    *******************************************************************************************************/
    private String convertToMonthHeader(Integer monthNumber, Integer year){
        return mapNumberToMonth.get(monthNumber)+'\''+String.valueOf(year).substring(2, 4);
    }
    
    /*******************************************************************************************************
    PURPOSE    : Calculate all Quater Header values for the selected Time filter
    *******************************************************************************************************/
    private list<string> generateQtrHeaders(){
        list<String> qtrHeaderValues = new list<String>();
        for(Date tempDate=startDate; tempDate<=endDate; ){
            qtrHeaderValues.add(convertToQtrHeader(mapMonthToQtr.get(tempDate.month()), tempDate.year()));
            tempDate = tempDate.addMonths(3);
        }
        qtrHeaderValues.add(TOTAL_COLUMN_HEADER);
        return qtrHeaderValues;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Calculate all Month Header values for the selected Time filter
    *******************************************************************************************************/
    private list<string> generateMonthHeaders(){
        list<String> monthHeaderValues = new list<String>();
        
        for(Date tempDate=startDate; tempDate<=endDate; ){
            monthHeaderValues.add(convertToMonthHeader(tempDate.month(),tempDate.year()));
            tempDate = tempDate.addMonths(1);
        }
        monthHeaderValues.add(TOTAL_COLUMN_HEADER);
        return monthHeaderValues;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Fetch and return a list of Opportunity Stage values from Opportunity object
    *******************************************************************************************************/
    private list<String> fetchStageValues(){
       List<String> stageValues = new List<String>();
       Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
       for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){
         stageValues.add(f.getLabel());
       } 
       
       return stageValues;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Fetch and return a map of Forecast Category <Value, Label> key-value pairs from LineItemOverride Object
    *******************************************************************************************************/
    private map<String,String> fetchForecastValueToLabel(){
       map<String,String> mapForecastValueToLabel = new map<String,String>();
       Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Product_Forecast_Category__c.getDescribe();
       for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){
         mapForecastValueToLabel.put(f.getValue(),f.getLabel());
       } 
       return mapForecastValueToLabel;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Fetch and return a list of Region values from Account object
    *******************************************************************************************************/
    private list<String> fetchRegionValues(){
       List<String> regionValues = new List<String>();
       Schema.DescribeFieldResult fieldResult = Account.Region__c.getDescribe();
       for( Schema.PicklistEntry f : fieldResult.getPicklistValues()){
         regionValues.add(f.getLabel());
       } 
       
       return regionValues;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Calculate Row and Column totals
    *******************************************************************************************************/
    private list<ResultWrapper> calculateTotals(list<string> headers, list<ResultWrapper> wrappers){
        if(wrappers!=null && wrappers.size()>0){
            ResultWrapper totalsRow = new ResultWrapper(null,null,headers);
        
            if(selectedGroupBy == GRP_BY_ACCOUNT_VALUE){
                totalsRow.accountCountry = TOTAL_COLUMN_HEADER;
            } if(selectedGroupBy == GRP_BY_OPP_STAGE_VALUE){
                totalsRow.stage = TOTAL_COLUMN_HEADER;
            } if(selectedGroupBy == GRP_BY_REGION_VALUE){
                totalsRow.region = TOTAL_COLUMN_HEADER;
            } if(selectedGroupBy == GRP_BY_FORECAST_CAT_VALUE){
                totalsRow.forecast = TOTAL_COLUMN_HEADER;
            }
            
            Long rowTotal;
            for(ResultWrapper wrapper : wrappers){
                rowTotal = 0;
                for(String header : wrapper.headerWiseQtySum.KeySet()){
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
    public string getTotalHeader(){
        return TOTAL_COLUMN_HEADER;
    }
    
    /*******************************************************************************************************
    PURPOSE    : check if Account grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByAcc(){
        return selectedGroupBy==GRP_BY_ACCOUNT_VALUE?true:false;
    }
    
    /*******************************************************************************************************
    PURPOSE    : check if Region grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByRegion(){
        return selectedGroupBy==GRP_BY_REGION_VALUE?true:false;
    }
    
    /*******************************************************************************************************
    PURPOSE    : check if Opportunity Stage grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByOppStage(){
        return selectedGroupBy==GRP_BY_OPP_STAGE_VALUE?true:false;
    }
    
    /*******************************************************************************************************
    PURPOSE    : check if Forecast Category grouping is selected
    *******************************************************************************************************/
    public boolean getIsGrpByForecast(){
        return selectedGroupBy==GRP_BY_FORECAST_CAT_VALUE?true:false;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Wrapper class to store the data in required format and display on visualforce page
    *******************************************************************************************************/
    public class ResultWrapper{
        public Id accountid {get;set;}
        public String accountName {get;set;}
        public String accountRegion {get;set;}
        public String accountSubRegion {get;set;}
        public String accountCountry {get;set;}
        public String stage {get;set;}
        public String region {get;set;}
        public String forecast {get;set;}
        public map<String, Long> headerWiseQtySum{get;set;}
        public Long rowTotal{get;set;}  
        
        //** Constructor **//
        public ResultWrapper(String grpBy, String grpByValue,list<string> headers) {
            OpportunityForecastForQuantity parentClass = new OpportunityForecastForQuantity(true);
            
            if(grpBy == parentClass.GRP_BY_ACCOUNT_VALUE){
                accountid = grpByValue;
                accountName = '';
                accountRegion = '';
                accountSubRegion = '';
                accountCountry = '';
            } else if(grpBy == parentClass.GRP_BY_OPP_STAGE_VALUE){
                stage = grpByValue;
            }else if(grpBy == parentClass.GRP_BY_REGION_VALUE){
                region = grpByValue;
            }else if(grpBy == parentClass.GRP_BY_FORECAST_CAT_VALUE){
                forecast = grpByValue;
            }
            headerWiseQtySum = new map<String, Long>();
            
            for(string header : headers){
                headerWiseQtySum.put(header, 0);
            }
        }
    }
}