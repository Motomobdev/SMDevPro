@isTest(SeeAllData=true)
private class UCD_Controller_Test {
  private static List<Account> listAccounts = new List<Account>();
  private static List<Product2> products = new List<Product2>();
  private static List<PriceBookEntry> pbes = new List<PriceBookEntry>();
  private static List<Opportunity> opps;
  private static map<Integer,Integer> mapMonthToQtr = new map<Integer,Integer>{1=>1,2=>1,3=>1,4=>2,5=>2,6=>2,7=>3,8=>3,9=>3,10=>4,11=>4,12=>4};
  
  public static TestMethod void testRegionWise(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = listAccounts[0].Region__c;
        controller.updateSubRegionFilters();
        controller.selectedSubRegion = listAccounts[0].Sub_Region__c;
        controller.updateCountryFilters();
        controller.selectedCountry = listAccounts[0].Country__c;
        controller.updateAccountFilters();
        controller.selectedAccount = listAccounts[0].Id;
        controller.selectedFamily = products[0].Family;
        controller.updatePgmFilters();
        controller.selectedProgramList = new list<String>{'-1'};
        controller.updateProjFilters();
        controller.selectedProjectList = new list<String>{'-1'};
        controller.updatePdtFilters();
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'region';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(1);
        controller.doSearch();
        controller.selectedDataSource = '2013-11-15';
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  
  public static TestMethod void testSubRegionWise(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = listAccounts[0].Region__c;
        controller.updateSubRegionFilters();
        controller.selectedSubRegion = listAccounts[0].Sub_Region__c;
        controller.updateCountryFilters();
        controller.selectedCountry = listAccounts[0].Country__c;
        controller.updateAccountFilters();
        controller.selectedAccount = listAccounts[0].Id;
        controller.selectedFamily = products[0].Family;
        controller.updatePgmFilters();
        controller.selectedProgramList = new list<String>{'-1'};
        controller.updateProjFilters();
        controller.selectedProjectList = new list<String>{'-1'};
        controller.updatePdtFilters();
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'subRegion';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(6);
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  
  public static TestMethod void testCountryWise(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = listAccounts[0].Region__c;
        controller.updateSubRegionFilters();
        controller.selectedSubRegion = listAccounts[0].Sub_Region__c;
        controller.updateCountryFilters();
        controller.selectedCountry = listAccounts[0].Country__c;
        controller.updateAccountFilters();
        controller.selectedAccount = listAccounts[0].Id;
        controller.selectedFamily = products[0].Family;
        controller.updatePgmFilters();
        controller.selectedProgramList = new list<String>{'-1'};
        controller.updateProjFilters();
        controller.selectedProjectList = new list<String>{'-1'};
        controller.updatePdtFilters();
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'country';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(1);
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  
  public static TestMethod void testALL(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = '-1';
        controller.selectedSubRegion = '-1';
        controller.selectedCountry = '-1';
        controller.selectedAccount = '-1';
        controller.selectedFamily = '-1';
        controller.selectedProgramList = new list<String>{'-1'};
        controller.selectedProjectList = new list<String>{'-1'};
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'region';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(1);
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  
  public static TestMethod void testForecastWise(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = listAccounts[0].Region__c;
        controller.updateSubRegionFilters();
        controller.selectedSubRegion = listAccounts[0].Sub_Region__c;
        controller.updateCountryFilters();
        controller.selectedCountry = listAccounts[0].Country__c;
        controller.updateAccountFilters();
        controller.selectedAccount = listAccounts[0].Id;
         controller.selectedFamily = products[0].Family;
        controller.updatePgmFilters();
        controller.selectedProgramList = new list<String>{'-1'};
        controller.updateProjFilters();
        controller.selectedProjectList = new list<String>{'-1'};
        controller.updatePdtFilters();
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'forecastCat';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(1);
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  
  public static TestMethod void testProductWise(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = listAccounts[0].Region__c;
        controller.updateSubRegionFilters();
        controller.selectedSubRegion = listAccounts[0].Sub_Region__c;
        controller.updateCountryFilters();
        controller.selectedCountry = listAccounts[0].Country__c;
        controller.updateAccountFilters();
        controller.selectedAccount = listAccounts[0].Id;
         controller.selectedFamily = products[0].Family;
        controller.updatePgmFilters();
        controller.selectedProgramList = new list<String>{'-1'};
        controller.updateProjFilters();
        controller.selectedProjectList = new list<String>{'-1'};
        controller.updatePdtFilters();
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'Product';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(1);
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  public static TestMethod void testProgramWise(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = listAccounts[0].Region__c;
        controller.updateSubRegionFilters();
        controller.selectedSubRegion = listAccounts[0].Sub_Region__c;
        controller.updateCountryFilters();
        controller.selectedCountry = listAccounts[0].Country__c;
        controller.updateAccountFilters();
        controller.selectedAccount = listAccounts[0].Id;
         controller.selectedFamily = products[0].Family;
        controller.updatePgmFilters();
        controller.selectedProgramList = new list<String>{'-1'};
        controller.updateProjFilters();
        controller.selectedProjectList = new list<String>{'-1'};
        controller.updatePdtFilters();
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'Program';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(1);
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  public static TestMethod void testProjectWise(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = listAccounts[0].Region__c;
        controller.updateSubRegionFilters();
        controller.selectedSubRegion = listAccounts[0].Sub_Region__c;
        controller.updateCountryFilters();
        controller.selectedCountry = listAccounts[0].Country__c;
        controller.updateAccountFilters();
        controller.selectedAccount = listAccounts[0].Id;
         controller.selectedFamily = products[0].Family;
        controller.updatePgmFilters();
        controller.selectedProgramList = new list<String>{'-1'};
        controller.updateProjFilters();
        controller.selectedProjectList = new list<String>{'-1'};
        controller.updatePdtFilters();
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'Project';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(1);
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  
  public static TestMethod void testStageWise(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = listAccounts[0].Region__c;
        controller.updateSubRegionFilters();
        controller.selectedSubRegion = listAccounts[0].Sub_Region__c;
        controller.updateCountryFilters();
        controller.selectedCountry = listAccounts[0].Country__c;
        controller.updateAccountFilters();
        controller.selectedAccount = listAccounts[0].Id;
        controller.selectedFamily = products[0].Family;
        controller.updatePgmFilters();
        controller.selectedProgramList = new list<String>{'-1'};
        controller.updateProjFilters();
        controller.selectedProjectList = new list<String>{'-1'};
        controller.updatePdtFilters();
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'oppStage';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(1);
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  
  public static TestMethod void testAccountWise(){
    createTestData();
        test.startTest();
        UCD_Controller controller = new UCD_Controller();
        controller.selectedRegion = listAccounts[0].Region__c;
        controller.updateSubRegionFilters();
        controller.selectedSubRegion = listAccounts[0].Sub_Region__c;
        controller.updateCountryFilters();
        controller.selectedCountry = listAccounts[0].Country__c;
        controller.updateAccountFilters();
        controller.selectedAccount = listAccounts[0].Id;
        controller.selectedFamily = products[0].Family;
        controller.updatePgmFilters();
        controller.selectedProgramList = new list<String>{'-1'};
        controller.updateProjFilters();
        controller.selectedProjectList = new list<String>{'-1'};
        controller.updatePdtFilters();
        controller.selectedProductList = new list<String>{'-1'};
        controller.selectedForecastList = new list<String>{'-1'};
        controller.selectedLayout = 'both';
        controller.selectedGroupBy = 'account';
        controller.selectedYear = String.valueOf(DateTime.Now().Year());
        controller.selectedQtr = String.valueOf(mapMonthToQtr.get(DateTime.Now().Month()));
        controller.selectedPeriods = String.valueOf(1);
        controller.doSearch();
        controller.resetAllFilters();
        Test.stopTest();
  }
  
  private static void createTestData(){
    Account acc1 = new Account();
    acc1.Name = 'Acc1';
    acc1.Region__c = 'Latin America';
    acc1.Sub_Region__c = 'Latin America North';
    acc1.Country__c = 'Mexico';
    acc1.Allow_Opportunities__c = true;
    listAccounts.add(acc1);
    
    Account acc2 = new Account();
    acc2.Name = 'Acc2';
    acc2.Region__c = 'APAC';
    acc2.Sub_Region__c = 'North East Asia';
    acc2.Country__c = 'Japan';
    acc2.Allow_Opportunities__c = true;
    listAccounts.add(acc2);
    
    Account acc3 = new Account();
    acc3.Name = 'Acc3';
    acc3.Region__c = 'Global';
    acc3.Sub_Region__c = 'North America';
    acc3.Country__c = 'Canada';
    acc3.Allow_Opportunities__c = true;
    listAccounts.add(acc3);
    insert listAccounts;
    
    for(Account acc : listAccounts){
      System.assert(acc.Id!=null);  
    }
    
    products = new List<Product2>{
           new Product2(name = 'Pdt1', isactive=true, type__c = 'NPI Product', Family = 'Portable Bluetooth & Auto',Program__c='ONYX', Project__c='ONYX'),
           new Product2(name = 'Pdt2', isactive=true, type__c = 'PMD Product', Family = 'Social Media',Program__c='ArgonMini', Project__c='ArgonMini UMTS'),
           new Product2(name = 'Pdt3', isactive=true, type__c = 'NPI Product', Family = 'Multimedia',Program__c='EUROPA', Project__c='EUROPA'),
           new Product2(name = 'Pdt4', isactive=true, type__c = 'PMD Product', Family = 'Portable Bluetooth & Auto',Program__c='Xfon', Project__c='Xfon UMTS/LTE ROW'),
           new Product2(name = 'Pdt5', isactive=true, type__c = 'NPI Product', Family = 'Multimedia',Program__c='JUPITER', Project__c='JUPITER')
        };
    insert products;

    Pricebook2 pb = [SELECT Id FROM Pricebook2 WHERE IsStandard = true AND isActive = true LIMIT 1];

    for(Product2 pdt : products){
        pbes.add(new PriceBookEntry(Pricebook2Id = pb.Id, Product2Id = pdt.id, UnitPrice = 0.0, CurrencyIsoCode = 'USD', IsActive = true));
        System.assert(pdt.Id!=null);  
    }
        
    if(!pbes.isEmpty())
        insert pbes;
    
    opps = new List<Opportunity>{
           new Opportunity(name='Oppty1', AccountId=acc1.Id,CurrencyIsoCode = pbes[0].CurrencyIsoCode, StageName='1. Prospecting',Amount=100000,CloseDate=Date.today().addDays(10)),
           new Opportunity(name='Oppty2', AccountId=acc2.Id,CurrencyIsoCode = pbes[1].CurrencyIsoCode, StageName='2. Presenting Device',Amount=100000,CloseDate=Date.today().addDays(15)),
           new Opportunity(name='Oppty3', AccountId=acc3.Id,CurrencyIsoCode = pbes[2].CurrencyIsoCode, StageName='3. Proposal Preparation',Amount=100000,CloseDate=Date.today()),
           new Opportunity(name='Oppty4', AccountId=acc1.Id,CurrencyIsoCode = pbes[3].CurrencyIsoCode, StageName='4. Commercial Proposal Delivered',Amount=100000,CloseDate=Date.today().addDays(25)),
           new Opportunity(name='Oppty5', AccountId=acc3.Id,CurrencyIsoCode = pbes[4].CurrencyIsoCode, StageName='5. Active Negotiation',Amount=100000,CloseDate=Date.today().addDays(30)),
           new Opportunity(name='Oppty6', AccountId=acc2.Id,CurrencyIsoCode = pbes[4].CurrencyIsoCode, StageName='8. Closed Lost',Amount=100000,CloseDate=Date.today().addDays(-2))
        };
    insert opps;
    for(Opportunity opp : opps){
      System.assert(opp.Id!=null);  
    }
    
    List<OpportunityLineItem> lineItems = new List<OpportunityLineItem>{
           new OpportunityLineItem(ServiceDate=Date.today().addDays(10),TotalPrice=100,PricebookEntryId=pbes[0].Id, OpportunityId=opps[0].id,Product_Forecast_Category__c='Best Case',Quantity=100),
           new OpportunityLineItem(ServiceDate=Date.today().addDays(15),TotalPrice=100,PricebookEntryId=pbes[1].Id, OpportunityId=opps[1].id,Product_Forecast_Category__c='Pipeline',Quantity=100),
           //new OpportunityLineItem(ServiceDate=Date.today().addDays(20),TotalPrice=100,PricebookEntryId=pbes[2].Id, OpportunityId=opps[2].id,Product_Forecast_Category__c='Closed',Quantity=100),
           new OpportunityLineItem(ServiceDate=Date.today().addDays(10),TotalPrice=100,PricebookEntryId=pbes[3].Id, OpportunityId=opps[3].id,Product_Forecast_Category__c='Pipeline',Quantity=100),
           new OpportunityLineItem(ServiceDate=Date.today().addDays(15),TotalPrice=100,PricebookEntryId=pbes[4].Id, OpportunityId=opps[4].id,Product_Forecast_Category__c='Commit',Quantity=100),
           new OpportunityLineItem(ServiceDate=Date.today().addDays(20),TotalPrice=100,PricebookEntryId=pbes[0].Id, OpportunityId=opps[5].id,Product_Forecast_Category__c='Omitted',Quantity=100),
           new OpportunityLineItem(ServiceDate=Date.today().addDays(25),TotalPrice=100,PricebookEntryId=pbes[0].Id, OpportunityId=opps[4].id,Product_Forecast_Category__c='Pipeline',Quantity=100),
           new OpportunityLineItem(ServiceDate=Date.today().addDays(30),TotalPrice=100,PricebookEntryId=pbes[1].Id, OpportunityId=opps[0].id,Product_Forecast_Category__c='Pipeline',Quantity=100),
           new OpportunityLineItem(ServiceDate=Date.today().addDays(10),TotalPrice=100,PricebookEntryId=pbes[2].Id, OpportunityId=opps[1].id,Product_Forecast_Category__c='Pipeline',Quantity=100),
           //new OpportunityLineItem(ServiceDate=Date.today().addDays(15),TotalPrice=100,PricebookEntryId=pbes[3].Id, OpportunityId=opps[2].id,Product_Forecast_Category__c='Closed',Quantity=100),
           new OpportunityLineItem(ServiceDate=Date.today().addDays(50),TotalPrice=100,PricebookEntryId=pbes[4].Id, OpportunityId=opps[3].id,Product_Forecast_Category__c='Best Case',Quantity=100)
        };
    insert lineItems;
    for(OpportunityLineItem item : lineItems){
      System.assert(item.Id!=null);  
    }
  }
}