@isTest
private class WeeklyReportTest {
    
    static testMethod void myUnitTest() {        
        test.startTest();
                
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
        
        Weekly_Report_Item__c wri = new Weekly_Report_Item__c();
        wri.Function__c = 'GTM';
        wri.Category__c = 'Highlights';
        wri.Summary__c = 'Some test comments';
        wri.Current_Week__c = true;
        // assign value to program field
        wri.Program__c = prog.Id;
        // assign value to time period field
        wri.Time_Period__c = 'Weekly';
        // assign value to competitive product field
        wri.Competitive_Product__c = compProduct.Id;
        insert wri;
        
        WeeklyReport wr = new WeeklyReport();
        //wr.query = 'SELECT Weekly_Report__c, Current_Week__c, Previous_Week__c, Function__c FROM Weekly_Report_Item__c WHERE Current_Week__c = true OR Previous_Week__c = true';
        integer batchSize = 20;
        database.executebatch(wr, batchSize);
             
        test.stopTest();
   
    }
}