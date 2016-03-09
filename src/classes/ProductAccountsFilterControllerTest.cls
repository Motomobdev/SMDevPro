@Istest
public class ProductAccountsFilterControllerTest {
    static testmethod void createTestData(){
    PageReference pageRef = Page.PMDFilterCriteria;
    Test.setCurrentPage(Page.PMDFilterCriteria);
    
   PPM_Project__c ppm = new PPM_Project__c();
    ppm.Name = 'Vanquish MAXX WE/LTE';
            
    PMD_Product__c pmd = new PMD_Product__c();
    pmd.Project_ID__c = 'a1D40000006Rr21';
    pmd.Franchise__c = 'Droid Category';
    pmd.Price_Tier_Target__c = '500';
    pmd.SA_Date__c =System.Today();
    pmd.Status__c = 'Active';
    insert pmd;
     
    Account acc1 = new Account();
    acc1.Name = 'testacc';
    acc1.Region__c = 'Latin America';
    acc1.Sub_Region__c = 'Latin America North';
    acc1.Country__c = 'Mexico';
    acc1.Technology_Type__c='CDMA';
    acc1.RecordTypeId = '01240000000DpysAAC';
    acc1.Allow_Opportunities__c = true;
            
    insert acc1;
    pmd.Account_Id__c=acc1.Id;
    update pmd;
       
     Account acc2 = new Account();
    acc2.Name = 'Acc2';
    acc2.Region__c = 'APAC';
    acc2.Sub_Region__c = 'North East Asia';
    acc2.Country__c = 'Japan';
    acc2.Technology_Type__c='GSM';
    acc2.RecordTypeId = '01240000000DpysAAC';
    acc2.Allow_Opportunities__c = true;
    insert acc2;
    
    PMD_Product__c pmd2 = new PMD_Product__c();
    pmd2.Project_ID__c = 'a1D40000006RqpC';
    pmd2.Franchise__c = 'Droid Category';
    pmd2.Price_Tier_Target__c = '500';
    
    pmd2.SA_Date__c =System.Today();
    pmd2.Status__c = 'Active';
    insert pmd2;
    
    Account acc3 = new Account();
    acc3.Name = 'Acc3';
    acc3.Region__c = 'Global';
    acc3.Sub_Region__c = 'North America';
    acc3.Country__c = 'Canada';
    acc3.Technology_Type__c='iDEN';
    acc3.RecordTypeId = '01240000000DpysAAC';
    acc3.Allow_Opportunities__c = true;
    insert acc3;
     
     
     
    ProductAccountsFilterController controller = new ProductAccountsFilterController(new ApexPages.StandardController(pmd));
    
    Test.startTest();
    ProductAccountsFilterController.AccountRecords accRec1 = new ProductAccountsFilterController.AccountRecords();
    accRec1.recName = 'Test1';
    accRec1.techName = 'CDMA';
    accRec1.isSelected = true;
    accRec1.id = '0000000000ert678vvQ';
    
    ProductAccountsFilterController.AccountRecords accRec2 = new ProductAccountsFilterController.AccountRecords();
    accRec2.recName = 'Test2';
    accRec2.techName = 'GSM';
    accRec2.isSelected = true;
    accRec2.id = '0000000000ert677vvQ';
    
    List<ProductAccountsFilterController.AccountRecords> accRecList = new List<ProductAccountsFilterController.AccountRecords>();
    ProductAccountsFilterController.Pagination testPagination1 = new ProductAccountsFilterController.Pagination(accRecList,5);
    accRecList.add(accRec1);
    accRecList.add(accRec2);
    ProductAccountsFilterController.Pagination testPagination2 = new ProductAccountsFilterController.Pagination(accRecList,5);
    List<Account> accList= new List<Account>();
    ProductAccountsFilterController.Pagination testPagination3 = new ProductAccountsFilterController.Pagination(accList,5);
    accList.add(acc3);
    accList.add(acc2);
    ProductAccountsFilterController.Pagination testPagination4 = new ProductAccountsFilterController.Pagination(accList,5);
    //testPagination4.pagenumber();
    testPagination4.gethasprevious();
    testPagination4.gethasnext();
    testPagination4.getRecords();
    testPagination4.getAccRecords();
    
    
     controller.createRegionFiltersMap();
    controller.selectedRegion = 'Latin America';
     controller.updateSubRegionFilters();
    controller.selectedSubRegion = 'Latin America North';
    controller.updateCountryFilters();
    controller.selectedCountry = 'Mexico';
    List<selectOption> optlist = new List<selectOption>();
    optlist.add(new selectOption('CDMA','CDMA'));
    controller.selectedOptions=optlist;
    controller.updateAccountFilters();
    controller.selectedAccount ='Acc1';
    controller.saveAccounts();
    PMDProduct_Account__c pmdacc = new PMDProduct_Account__c();
     pmdacc.Account__c = acc1.Id;
     pmdacc.Product_PMD__c = pmd.Id;
     insert pmdacc; 
    controller.getGroupBySelectOptions();
    controller.getRegionSelectOptions();
    controller.getGroupBySelectOptions();
    controller.toggleSort();
    controller.runSearch();
    controller.selectedRegion = '-1';
    controller.selectedSubRegion = '-1';
    controller.selectedCountry = '-1';
    controller.selectedAccount = '-1';
    controller.selectedRegion = 'Latin America';
    controller.updateCountryFilters();
    
    // stop the test
    Test.stopTest();
    
               
  }
  
  
  
}