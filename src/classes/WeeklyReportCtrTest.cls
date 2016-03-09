@isTest
private class WeeklyReportCtrTest {
    
    @isTest 
    static void testWeeklyReportCtr() {        
        PageReference currPage = Page.WeeklyReport;
        Test.setCurrentPage(currPage);

        Weekly_Report__c wr = WeeklyReport.createWeekly('GTM', date.today());

        Account acct = new Account(name='Test Weekly',Region__c='North America', Sub_Region__c='North America', Country__c='United States');
        insert acct;
        
        /**
         * Modified by Prelude
         */
         
        ///<Objective>
        /// Insert a record in pmd program custom object 
        ///<Objective>
        PMD_Program__c prog = new PMD_Program__c(name = 'Test Program');
        insert prog;
        
        ///<Objective>
        /// Insert a record in competitive product custom object 
        ///<Objective>
        Competitive_Product__c compProduct = new Competitive_Product__c(name='Test Competitive Product',Brand__c ='ACER',Product__c = 'Test Product');
        insert compProduct;

        Weekly_Report_Item__c item = new Weekly_Report_Item__c();
        item.Summary__c = 'Some text written here';
        item.Account__c = acct.Id;
        item.Function__c = 'GTM';
        item.Business__c = 'Handset';
        item.Weekly_Report__c = wr.Id;
        // assign value to program field
        item.Program__c = prog.Id;
        // assign value to time period field
        item.Time_Period__c = 'Weekly';
        // assign value to competitive product field
        item.Competitive_Product__c = compProduct.Id; 
        // assign value to include in report field
        item.Include_In_Report__c = true; 
        Test.startTest();
        insert item;       
        
        WeeklyReportController ctr = new WeeklyReportController();
        ctr.function = 'GTM';

        AggregateResult[] results = [SELECT MAX(Week_Ending__c) maxdate FROM Weekly_Report__c];
        ctr.weekEnding = string.valueOf(date.today());
        ctr.business = 'Handset';   
        //ctr.userIds = new String[]{'005400000015Ymg', '00540000001Pmd9'};
        ctr.selectedRegions = new String[]{'North America'};
        ctr.selectedSubRegions = new String[]{'North America'};
        ctr.selectedCountries = new String[]{'United States'};
        ctr.selectedAccounts = new String[]{acct.Id};       
        ctr.getAllAccounts();
        ctr.getAllBusinesses();
        ctr.getAllCountries();
        ctr.getAllFunctions();
        ctr.getAllRegions();
        ctr.getAllSubRegions();
        ctr.getAllBusinessesgroup();
        ctr.getAllUsers();
        ctr.getAllWeekEndings();
        ctr.getWeeklyItems();
        ctr.getWeeklyItemsList();
        ctr.clearAllFilters();
        ctr.clearAcctFilters();
        ctr.toggleGrid();
        ctr.getNoneOption();
        ctr.getAllOption();
        ctr.getPublicCalendars();
        ctr.ShowReport();
        ctr.ExportReport();
        // call the IncludeOptions method
        ctr.getIncludeOptions();
        Test.stopTest();  
            
    }
    
}