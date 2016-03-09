public with sharing class ProductAccountsFilterController {
    private final string GRP_BY_REGION = 'Region';
    private final string GRP_BY_SUB_REGION = 'Sub Region';
    private final string GRP_BY_COUNTRY = 'Country';
    //private final string GRP_BY_Technology = 'Technology';
    Public SelectOption[] availableOptions {get;set;}
    private final string TOTAL_COLUMN_HEADER = 'TOTAL';
    private final string SELECT_ALL_LABEL = '--All--';
    private final string SELECT_ALL_VALUE = '-1';
    public String selectedRegion {get;set;}
    public String selectedSubRegion {get;set;}
    public PMD_Product__c prod {get;set;}
    public List<SelectOption> selectedOptions {get;set;}
    public String selectedCountry {get;set;}
    //public String selectedTechnology {get;set;}
    public String selectedAccount {get;set;}
    public PMD_Product__c selectedProd {get;set;}
    public List<SelectOption> regionSelectList {get;set;}
    public List<SelectOption> subRegionSelectList {get;set;}
    public List<SelectOption> countrySelectList {get;set;}
     //public List<SelectOption> TechnologySelectList {get;set;}
    map<String,Set<String>> mapRegionSubRegion = new map<String,Set<String>>();
    map<String,Set<String>> mapSubRegionCountry = new map<String,Set<String>>();
    map<String,Set<Account>> mapCountryAccount = new map<String,Set<Account>>();
    map<String,Set<Account>> mapRegionAccount  = new map<String,Set<Account>>();
    //map<String,Set<String>> mapTechnologyTypeAccount = new map<String,Set<String>>();
    public List<SelectOption> accountSelectList {get;set;}
    public List<AccountRecords> accountsList {get;set;}
    
    public Pagination accountsPaginationObj{get;set;} 
    public Pagination accountsRelatedListPagObj {get;set;}  
    public ProductAccountsFilterController(ApexPages.StandardController controller) {
       if(!Test.isRunningTest()){
            controller.addFields(new List<String>{ 'Account_Id__c', 'Account_Product_Based_Data__c','Project_ID__c' });
       }
       selectedProd = (PMD_Product__c) controller.getRecord();
       
       initRegionFilters();
       createRegionFiltersMap();
       populateRelatedAccountsList();
       accountsList = new List<AccountRecords>();
    }
    private void initRegionFilters() {
        regionSelectList = getRegionSelectOptions();
        subRegionSelectList = new List<SelectOption>();
        countrySelectList =  new List<SelectOption>();
        availableOptions = getAvailableProductOptions();
        accountSelectList =  new List<SelectOption>();
        selectedOptions = new List<SelectOption>();
        resetsubRegionSelectList();
        resetCountrySelectList();
        resetAccountSelectList();
        //resetTechnologySelectList();
    }
    public void createRegionFiltersMap() {
        Account[] results = [Select Region__c,Sub_Region__c,Country__c,Name,Id,Technology_Type__c
                                From Account
                                Where Region__c != null
                                AND Sub_Region__c != ''AND Technology_Type__c!= '' AND ownerid != '00540000001qX0C'
                                AND RecordTypeId = '01240000000DpysAAC'
                                Order By Region__c,Sub_Region__c,Country__c Limit 2000];
        Set<String> setSubRegion;
        Set<String> setCountry;
        //Set<String> setTechnology;
        Set<Account> setAccount;
        Set<Account> setRegionAccounts;
        for (Account objAccount:results) {
            setSubRegion = new Set<String>();
            setCountry = new Set<String>();
            //setTechnology = new Set<String>();
            setAccount = new Set<Account>();
            setRegionAccounts = new Set<Account>();
            if (mapRegionSubRegion.containsKey(objAccount.Region__c)  && mapRegionSubRegion.keyset() != null)
                setSubRegion.addAll(mapRegionSubRegion.get(objAccount.Region__c));
            if (mapSubRegionCountry.containsKey(objAccount.Sub_Region__c)  && mapSubRegionCountry.keyset() != null)
                setCountry.addAll(mapSubRegionCountry.get(objAccount.Sub_Region__c));
            if (mapCountryAccount.containsKey(objAccount.Country__c)  && mapCountryAccount.keyset() != null)
                setAccount.addAll(mapCountryAccount.get(objAccount.Country__c));
            /*if (mapTechnologyTypeAccount.containsKey(objAccount.Region__c)  && mapTechnologyTypeAccount.keyset() != null)
                    setTechnology.addAll(mapTechnologyTypeAccount.get(objAccount.Region__c));*/
            if (mapRegionAccount.containsKey(objAccount.Region__c)  && mapRegionAccount.keyset() != null)
                    setRegionAccounts.addAll(mapRegionAccount.get(objAccount.Region__c));
            setSubRegion.add(objAccount.Sub_Region__c);
            //setTechnology.add(objAccount.Technology_Type__c);
            setCountry.add(objAccount.Country__c);
            setAccount.add(objAccount);
            setRegionAccounts.add(objAccount);
            mapRegionSubRegion.put(objAccount.Region__c,setSubRegion);
            mapSubRegionCountry.put(objAccount.Sub_Region__c,setCountry);
            mapCountryAccount.put(objAccount.Country__c,setAccount);
            mapRegionAccount.put(objAccount.Region__c, setRegionAccounts);
            //mapTechnologyTypeAccount.put(objAccount.Region__c,setTechnology);
        }
        system.debug(mapRegionSubRegion+'--'+'mapSubRegionCountry'+mapSubRegionCountry);
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
         //updateAccountFilters();
        //resetTechnologySelectList();
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Selected Region'+selectedRegion);//Same old drama 
        //ApexPages.addMessage(myMsg);
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
    PURPOSE    : Populate the Technology select options based on the selected Region value
    *******************************************************************************************************/
    /*public PageReference updateTechnologyTypeFilters() {

        resetSubRegionSelectList();
        resetCountrySelectList();
        resetTechnologySelectList();
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Selected Region'+selectedRegion);//Same old drama 
        //ApexPages.addMessage(myMsg);
        if (selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE) {
            List<SelectOption> tempListSelectOption =  new List<SelectOption>();
            if (mapTechnologyTypeAccount.containskey(selectedRegion)) {
                for (String strTechnologyType : mapTechnologyTypeAccount.get(selectedRegion)) {
                    tempListSelectOption.add(new SelectOption(strTechnologyType,strTechnologyType));
                }
                tempListSelectOption= SortOptionList(tempListSelectOption);
                TechnologySelectList.addAll(tempListSelectOption);
            }
        }
        return null;
    }*/
    

    /*******************************************************************************************************
    PURPOSE    : Populate the Country select options based on the selected Region and SubRegion values
    *******************************************************************************************************/
    public PageReference updateCountryFilters() {

        resetCountrySelectList();
        updateAccountFilters();
        //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Selected Region'+selectedRegion+'----selectedSubRegion'+selectedSubRegion);//Same old drama 
        //ApexPages.addMessage(myMsg);
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
    PURPOSE    : Initialize SubRegion select options
    *******************************************************************************************************/
    private void resetSubRegionSelectList() {
        subRegionSelectList.clear();
        subRegionSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedSubRegion = SELECT_ALL_VALUE;
    }
    
    /*******************************************************************************************************
    PURPOSE    : Initialize SubRegion select options
    *******************************************************************************************************/
    /*private void resetTechnologySelectList() {
        TechnologySelectList.clear();
        TechnologySelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedTechnology = SELECT_ALL_VALUE;
    }*/

   
    /*******************************************************************************************************
    PURPOSE    : Intialize Country select options
    *******************************************************************************************************/
    private void resetCountrySelectList() {
        countrySelectList.clear();
        countrySelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedCountry = SELECT_ALL_VALUE;
    }
   
    
    /*******************************************************************************************************
    PURPOSE    : Prepare and return list of Group By select options
    *******************************************************************************************************/
    public List<SelectOption> getGroupBySelectOptions() {
       List<SelectOption> options = new List<SelectOption>();
       options.add(new SelectOption(GRP_BY_REGION, GRP_BY_REGION));
       options.add(new SelectOption(GRP_BY_SUB_REGION, GRP_BY_SUB_REGION));
       options.add(new SelectOption(GRP_BY_COUNTRY, GRP_BY_COUNTRY));
       return options;
    }

        public List<SelectOption> getAvailableProductOptions(){
         availableOptions = new List<SelectOption>();
         //selectedOptions = new List<SelectOption>();
         availableOptions.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
        Schema.DescribeFieldResult Technames= Account.Technology_Type__c.getDescribe();

        List<Schema.PicklistEntry> Technamesvalues= Technames.getPicklistValues();

               
        for(Schema.PicklistEntry techname : Technamesvalues){
        availableOptions.add(new SelectOption(techname.getValue(),techname.getLabel()));
        }
        return availableOptions;
    }   
    /*public List<SelectOption> getselectedOptions(){
        selectedOptions = new List<SelectOption>();
        selectedOptions.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
        selectedOptions.add(new SelectOption(SELECT_ALL_VALUE, SELECT_ALL_LABEL));
        Schema.DescribeFieldResult fieldResults = Account.Technology_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple12 = fieldResults.getPicklistValues();
        for (Schema.PicklistEntry f12 : ple12) {
            selectedOptions.add(new SelectOption(f12.getValue(), f12.getLabel()));
        }
        return selectedOptions;
    }*/ 
        
    public PageReference toggleSort(){
    return null;
    }
    public PageReference runSearch() {

    String Country= Apexpages.currentPage().getParameters().get('Country');
    String SubRegion = Apexpages.currentPage().getParameters().get('SubRegion');
    String Region= Apexpages.currentPage().getParameters().get('Region');
    //String Technology= Apexpages.currentPage().getParameters().get('Technology');
    return null;
    
    }
    
    /*******************************************************************************************************
    PURPOSE    : Populate the Account select options based on the selected Region,SubRegion and County values
    *******************************************************************************************************/
    public PageReference updateAccountFilters() {

        resetAccountSelectList();
        system.Debug('selected TechnologyOptions----'+selectedOptions);
        List<String> selectedTechOptions = new List<String>();
        if( selectedOptions.size() > 0 ){
            
            system.Debug('selectedTechOptionsArr---'+selectedOptions);
        }
        System.Debug('selected Country----'+selectedCountry);
        System.Debug('selected Sub Region----'+selectedSubRegion);
        accountsList = new List<AccountRecords>();
        if (selectedRegion != NULL && selectedRegion != SELECT_ALL_VALUE) {
            List<SelectOption> tempListSelectOption =  new List<SelectOption>();
            if( selectedCountry != NULL && selectedCountry != SELECT_ALL_VALUE ){               
                if (mapCountryAccount.containskey(selectedCountry)) {
                    String name;
                    String techname;
                    for (Account objAccount : mapCountryAccount.get(selectedCountry)) {                     
                        if (objAccount!=null) {
                            if( selectedOptions.size() > 0 ){
                                for(SelectOption eachTechOption:selectedOptions){
                                    String accountBasedTechOptions = ';' + objAccount.Technology_Type__c + ';';
                                    if( accountBasedTechOptions.contains( ';'+eachTechOption.getValue()+';')){                                  
                                        AccountRecords eachRec = new AccountRecords();
                                        name = objAccount.name.length()>25 ? objAccount.name.substring(0,25)+'..' : objAccount.Name;
                                        tempListSelectOption.add(new SelectOption(objAccount.Id,name));
                                        eachRec.recName = name;
                                        eachRec.techName=objAccount.Technology_Type__c;
                                        eachRec.isSelected = false;
                                        eachRec.id = String.valueOf(objAccount.id);
                                        accountsList.add(eachRec);
                                    }//Account Technology has selected filter value
                                }//Loop Over selected Technology Values
                            }else{
                                AccountRecords eachRec = new AccountRecords();
                                name = objAccount.name.length()>25 ? objAccount.name.substring(0,25)+'..' : objAccount.Name;
                                tempListSelectOption.add(new SelectOption(objAccount.Id,name));
                                eachRec.recName = name;
                                eachRec.techName=objAccount.Technology_Type__c;
                                eachRec.isSelected = false;
                                eachRec.id = String.valueOf(objAccount.id);
                                accountsList.add(eachRec);
                            }                           
                        }//If Acc Rec is not null
                    }//Loop Over Country based accounts
                }//Region & SubRegion & Country based Results
            }
            else if( selectedSubRegion != NULL && selectedSubRegion != SELECT_ALL_VALUE ){  
                system.debug('---mapSubRegionCountry size--'+mapSubRegionCountry);
                system.debug('----mapSubRegionCountry ---'+mapSubRegionCountry);
                if (mapSubRegionCountry.containskey(selectedSubRegion)) {
                    System.Debug('selected Sub Region----'+selectedSubRegion);
                    Set<String> countriesList = mapSubRegionCountry.get(selectedSubRegion);
                    system.debug('# of countries: '+countriesList.size());
                    for(String eachCountry: countriesList){
                        if (mapCountryAccount.containskey(eachCountry)) {
                            String name;
                            String techname;
                            for (Account objAccount : mapCountryAccount.get(eachCountry)) {
                                if (objAccount!=null) {
                                    if( selectedOptions.size() > 0 ){
                                        for(SelectOption eachTechOption:selectedOptions){
                                            String accountBasedTechOptions = ';' + objAccount.Technology_Type__c + ';';
                                            if( accountBasedTechOptions.contains( ';'+eachTechOption.getValue()+';')){                                          
                                                AccountRecords eachRec = new AccountRecords();
                                                name = objAccount.name.length()>25 ? objAccount.name.substring(0,25)+'..' : objAccount.Name;
                                                tempListSelectOption.add(new SelectOption(objAccount.Id,name));
                                                eachRec.recName = name;
                                                eachRec.techName=objAccount.Technology_Type__c;
                                                eachRec.isSelected = false;
                                                eachRec.id = String.valueOf(objAccount.id);
                                                accountsList.add(eachRec);
                                            }//If Account has selected Technology Options
                                        }//Loop Over Selected Technology Options
                                    }else{
                                        AccountRecords eachRec = new AccountRecords();
                                        name = objAccount.name.length()>25 ? objAccount.name.substring(0,25)+'..' : objAccount.Name;
                                        tempListSelectOption.add(new SelectOption(objAccount.Id,name));
                                        eachRec.recName = name;
                                        eachRec.techName=objAccount.Technology_Type__c;
                                        eachRec.isSelected = false;
                                        eachRec.id = String.valueOf(objAccount.id);
                                        accountsList.add(eachRec);
                                    }                                                                      
                                }//If Account Rec is not null
                            }//Loop Over Country based accounts
                        }//Get Accounts per Country                     
                    }//Loop over each Country of a Sub Region
                }//If SubRegion based account records Exist                                 
            } // Region & Sub Region based results
            else{//SHOW ACCOUNTS BASED ON REGION
                if( mapRegionAccount.containsKey(selectedRegion) ){
                    String name;
                    String techname;
                    for (Account objAccount : mapRegionAccount.get(selectedRegion)) {                     
                        if (objAccount!=null) {
                            if( selectedOptions.size() > 0 ){
                                for(SelectOption eachTechOption:selectedOptions){
                                    String accountBasedTechOptions = ';' + objAccount.Technology_Type__c + ';';
                                    if( accountBasedTechOptions.contains( ';'+eachTechOption.getValue()+';')){                                  
                                        AccountRecords eachRec = new AccountRecords();
                                        name = objAccount.name.length()>25 ? objAccount.name.substring(0,25)+'..' : objAccount.Name;
                                        tempListSelectOption.add(new SelectOption(objAccount.Id,name));
                                        eachRec.recName = name;
                                        eachRec.techName=objAccount.Technology_Type__c;
                                        eachRec.isSelected = false;
                                        eachRec.id = String.valueOf(objAccount.id);
                                        accountsList.add(eachRec);
                                    }//Account Technology has selected filter value
                                }//Loop Over selected Technology Values
                            }else{
                                AccountRecords eachRec = new AccountRecords();
                                name = objAccount.name.length()>25 ? objAccount.name.substring(0,25)+'..' : objAccount.Name;
                                tempListSelectOption.add(new SelectOption(objAccount.Id,name));
                                eachRec.recName = name;
                                eachRec.techName=objAccount.Technology_Type__c;
                                eachRec.isSelected = false;
                                eachRec.id = String.valueOf(objAccount.id);
                                accountsList.add(eachRec);
                            }                           
                        }//If Acc Rec is not null
                    }
                }           
            } 
            if( accountsList.size() > 0 ){
                
                accountsPaginationObj = new Pagination(accountsList,8);
                system.Debug('--Pagination Object Set---'+accountsPaginationObj);
            }
            
            if( tempListSelectOption.size() > 0 ){
                tempListSelectOption = SortOptionList(tempListSelectOption);
                accountSelectList.addall(tempListSelectOption);
            }
        }

        return null;
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
    PURPOSE    : Intialize Account select options
    *******************************************************************************************************/
    private void resetAccountSelectList() {
        accountSelectList.clear();
        accountSelectList.add(new SelectOption(SELECT_ALL_VALUE,SELECT_ALL_LABEL));
        selectedAccount = SELECT_ALL_VALUE;
    }
    
    public class AccountRecords{
        public String recName {get;set;}
         public String techName {get;set;}
        public boolean isSelected {get;set;}  
        public String id {get;set;}
    }
    
    public void populateRelatedAccountsList(){
        if(selectedProd.Account_Id__c != null && selectedProd.Account_Id__c != '' ){
            String relAccs = selectedProd.Account_Id__c;
            String[] relAccArr = relAccs.split(',');
            List<Account> relAcc = [select Id,Name from Account where id in :relAccArr];
            accountsRelatedListPagObj = new Pagination(relAcc, 5);
        }else{
            List<Account> relAcc = new List<Account>();
            accountsRelatedListPagObj = new Pagination(relAcc, 5);
        }   
    }
    public PageReference saveAccounts(){
        //List<Project_Ranging__c> parentobj = new List<Project_Ranging__c>();
        List<AccountRecords> selectedAccounts = accountsList;
        String selectedAccStr = '';
        String selectedAccIdsStr = '';
        String existingAccountRecIds = '';
        if( selectedProd.Account_Id__c != null ){
            existingAccountRecIds = selectedProd.Account_Id__c; 
        }
        String retURL = '';
        retURL = '/'+selectedProd.id;
        PageReference pg = new PageReference(retURL);
        system.debug('---selectedAccSsize--'+selectedAccounts.size());
        for(AccountRecords eachSelectedAccount:selectedAccounts){
            if( eachSelectedAccount.isSelected ){
                if( existingAccountRecIds != '' && existingAccountRecIds.contains(eachSelectedAccount.id) ){
                    continue;
                }else{                    
                    selectedAccIdsStr = selectedAccIdsStr + eachSelectedAccount.id + ',';
                }
            }
        }        
        system.debug('---selectedAccIdsStr--'+selectedAccIdsStr);
        if( selectedAccIdsStr != '' ){            
            selectedAccIdsStr = selectedAccIdsStr.substring(0,selectedAccIdsStr.length()-1);            
            if( selectedProd.Account_Id__c != null ){
                selectedProd.Account_Id__c = selectedProd.Account_Id__c + ',' + selectedAccIdsStr; //New Field which stores Accounts Ids
            }else{
                selectedProd.Account_Id__c = selectedAccIdsStr; //New Field which stores Accounts Ids
            }
            upsert selectedProd;
            String[] accountsArr = selectedAccIdsStr.split(',');
            for(String selectedAcc: accountsArr){
                PMDProduct_Account__c relObj = new PMDProduct_Account__c();
                relObj.Account__c = selectedAcc;
                relObj.Product_PMD__c = selectedProd.id;
                insert relObj;
                /*Project_Ranging__c newrange = new Project_Ranging__c();                    
                newrange.Account__c = selectedAcc;                    
                newrange.Status__c='Not presented';
                newrange.Project__c = selectedProd.Project_ID__c;
                insert newrange;*/
            }
    
        }

       /* List<Project_Ranging__c> accBasedRecords = new List<Project_Ranging__c>(); 

        for(Project_Ranging__c a:[SELECT Account__c,Id,Name,Project__c FROM Project_Ranging__c]){ 
              //if(a.contains(selectedAccount) ){     
                Project_Ranging__c newrange = new Project_Ranging__c();
                    
                    newrange.Account__c = selectedProd.Account_Id__c;
                    //newrange.Project__c
                    newrange.Status__c='Not presented';
                  accBasedRecords.add(newrange);

                    //}

                    insert accBasedRecords;
        }*/
        
    
        return pg;
    }
     
    public class Pagination{
        public integer pagenumber{get;set;}
        public integer totalpages{get;set;}
        public integer pagesize{get;set;}
        public list<AccountRecords> rowsList{get;set;} 
        public list<Account> allAccs{get;set;}      
        public Pagination(list<AccountRecords> allRows,integer memosToDisplayPerPage){
            if( allRows.size() != 0 ){
                pagenumber =1;
                pagesize = memosToDisplayPerPage;
                this.rowsList=allRows;
                totalpages= Integer.valueof(math.ceil((double)allRows.size()/(double)pagesize ));
            }    
            else{
                pagenumber = 0;
                totalpages = 0;
                pagesize = 1;
            }
        }
        public Pagination(list<Account> allAccs,integer memosToDisplayPerPage){
            if( allAccs.size() != 0 ){
                pagenumber =1;
                pagesize = memosToDisplayPerPage;
                this.allAccs=allAccs;
                totalpages= Integer.valueof(math.ceil((double)allAccs.size()/(double)pagesize ));
            }    
            else{
                pagenumber = 0;
                totalpages = 0;
                pagesize = 1;
            }
        }
        public boolean gethasprevious(){
          return (pagenumber != 1 && totalpages != 0);
        }
        public boolean gethasnext(){
            return (pagenumber != totalpages);
        }
        public pagereference Previous(){
            if(gethasprevious())
                pagenumber--;
            return null;
        }
        public pagereference next(){
            if(gethasnext())
                pagenumber++;
            return null;
        }
        public list<AccountRecords> getRecords(){
            list<AccountRecords> paginatedRows = new list<AccountRecords>();  
            if( rowsList != null && rowsList.size() != 0 ){
                for(integer counter2=(pagenumber-1)*pagesize;counter2<(math.min(pagenumber*pagesize,rowsList.size()));counter2++){
                    paginatedRows.add(rowsList.get(counter2));
                }
            }            
            return paginatedRows;
        }
        public list<Account> getAccRecords(){
            list<Account> paginatedRows = new list<Account>();  
            if( allAccs != null && allAccs.size() != 0 ){
                for(integer counter2=(pagenumber-1)*pagesize;counter2<(math.min(pagenumber*pagesize,allAccs.size()));counter2++){
                    paginatedRows.add(allAccs.get(counter2));
                }
            }            
            return paginatedRows;
        }       
    }
    
    }