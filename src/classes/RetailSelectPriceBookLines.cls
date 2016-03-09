public class RetailSelectPriceBookLines {

    /*
     * Author: Rajesh Krishnaiah
     * Date  : 21-Nov-20111
     * Desc  : Allows the users to add price book lines to a forecast.
     *         A retail price book line can be added to a forecast only once.
     *         A wrapper class is used to show a checkbox for selecting products.
     */
    public String forecastId {get; set;}
    public List<RetailForecastLineWrapper> data {get; set;}
    public String sortField {get; set;}
    public String previousSortField {get; set;}
    public List<SelectOption> business {get; set;}
    public String selectedBusiness {get; set;}
    
    String sortOrder = 'asc';
    
    public RetailSelectPriceBookLines() {
    
        // Check if we have the business parameter
        selectedBusiness = ApexPages.currentPage().getParameters().get('business');
        forecastId = ApexPages.currentPage().getParameters().get('forecastId');
    }
    
    public PageReference init() {
    
        // Show an error if the forecast ID is invalid
        if (forecastId == null) {
             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,            
             'Contact your system administrator. Error: Invalid forecast ID [' + forecastId + ']');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        // Get the forecast record        
        List<Retail_Forecast__c> rfs = [select id, price_book__c, account__c, Forecast_Quarter__c 
                                        from retail_forecast__c where id = :forecastId];
        // Show an error if no forecast record found
        if (rfs.isEmpty()) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,            
             'Contact your system administrator. Error: There is no forecast with an ID of [' + forecastId + ']');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        Retail_Forecast__c rf = rfs[0];
        
        // Add business filter if necessary
        String businessSoql = '';
        system.debug('selectedBusiness ==> ' + selectedBusiness);
        
        if (selectedBusiness != null && selectedBusiness != '')
            businessSoql =  'and business__c = \'' + selectedBusiness + '\' ';
        String orderBySoql = '';
        if (sortField != null)
            orderBySoql = ' Order By ' + sortField;
        else
            orderBySoql = ' Order By Account__r.name, business__c, carrier__c ';
        orderBySoql += sortOrder;
        
        // Construct a dynamic SOQL -- we don't show pricebook lines
        // that are already on the forecast
        String soql = 'select id, name, business__c, carrier__c, account__c, account__r.name, ' +
                             'q1_asp__c, q1_mcpu__c,' + 
                             'q2_asp__c, q2_mcpu__c,' +
                             'q3_asp__c, q3_mcpu__c,' +
                             'q4_asp__c, q4_mcpu__c,' + 
                             'product__r.name ' +
                      'from Retail_Price_Book_Line__c ' +
                      'where Retail_Price_Book__c = \'' + rf.price_book__c + '\'' +
                      '  and ( Account__c = null or account__c = \'' + rf.account__c + '\')' +
                          businessSoql + 
                      '  and id not in (select Retail_Price_Book_Line__c ' +
                                      ' from retail_forecast_line__c ' +
                                      ' where retail_forecast__c = \'' + rf.Id + '\')' + 
                      orderBySoql;
        List<SObject> queryResults = Database.query(soql);
        Set<String> uniqueBusinesses = new Set<String>();
        
        data = new List<RetailForecastLineWrapper>();
        for (SObject obj : queryResults) {
            Retail_Price_Book_Line__c rpbLine = (Retail_Price_Book_Line__c)obj;            
            RetailForecastLineWrapper wrapper = new RetailForecastLineWrapper();
            wrapper.selected = false;
            wrapper.quarter = rf.forecast_quarter__c;
            wrapper.rpbl = rpbLine;
            data.add(wrapper);
            uniqueBusinesses.add(rpbLine.business__c);
        }
        
        // Convert businesses in to select options
        if (business == null) {
            business = new List<SelectOption>();
            business.add(new SelectOption('', ''));
    
            for (String biz : uniqueBusinesses) {
                business.add(new SelectOption(biz, biz));
            }
        }
        return null;
    }
    
    public PageReference save() {
        List<Retail_Forecast_Line__c> rfls = new List<Retail_Forecast_Line__c>();
        
        for (RetailForecastLineWrapper wrapper : data) {
        
            if (wrapper.selected) {
                
                Double myAsp = 0.0;
                Double myMcpu = 0.0;
                
                if (wrapper.quarter == 'Q1') {
                    myAsp = wrapper.rpbl.q1_asp__c;
                    myMcpu = wrapper.rpbl.q1_mcpu__c;
                } else if (wrapper.quarter == 'Q2') {
                    myAsp = wrapper.rpbl.q2_asp__c;
                    myMcpu = wrapper.rpbl.q2_mcpu__c;
                } else if (wrapper.quarter == 'Q3') {
                    myAsp = wrapper.rpbl.q3_asp__c;
                    myMcpu = wrapper.rpbl.q3_mcpu__c;
                } else {
                    myAsp = wrapper.rpbl.q4_asp__c;
                    myMcpu = wrapper.rpbl.q4_mcpu__c;
                }
                
                Retail_Forecast_Line__c rfl = new Retail_Forecast_Line__c(
                    Retail_Forecast__c = forecastId,
                    Retail_Price_Book_Line__c = wrapper.rpbl.id,
                    asp__c = myAsp,
                    mcpu__c = myMcpu
                );
                
                rfls.add(rfl);
            }
        }
            
        upsert rfls;
        
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,            
         'Added [' + rfls.size() + '] products to the forecast');
        ApexPages.addMessage(myMsg);
        
        // refresh the data table contents
        return init();
    }
    
    public PageReference goBack() {
        
        return new PageReference('/' + forecastId);
    }
    
    public void doSort(){
        sortOrder = ' asc';

        if (previousSortField == sortField) {
            sortOrder = ' desc';
            previousSortField = null;
        } else {
            previousSortField = sortField;
        }
        
        init();
    }
    
    // Inner class -- acts as a wrapper to collect the checkbox status
    public class RetailForecastLineWrapper {
        public Boolean selected {get; set;}
        public String quarter {get;set;}
        public Retail_Price_Book_Line__c rpbl {get; set;}
    }
    
    public static testmethod void test() {
        Account a = RetailSalesTestUtil.createTestAccount();
        List<Product2> products = RetailSalesTestUtil.createTestProducts();
        Retail_Price_Book__c rpb = RetailSalesTestUtil.createPriceBook();
        List<Retail_Price_Book_Line__c> rpbls = 
            RetailSalesTestUtil.createPriceBookLines(a, rpb, products);
                
        // Invoke select price book lines page without the forecast ID
        PageReference myPage = Page.RetailSelectPriceBookLines;
        Test.setCurrentPage(myPage);
        
        RetailSelectPriceBookLines ctrl = new RetailSelectPriceBookLines();
        ctrl.init();

        Integer i = 1;
        
        // 4 quarters
        for (i = 1; i <= 4; ++i) {
            Retail_forecast__c rf = RetailSalesTestUtil.createForecast(a, rpb, '2011', 'Q' + i);
            // Add forecast ID parameter
            myPage.getParameters().put('forecastId', rf.id);
            ctrl = new RetailSelectPriceBookLines();
            ctrl.init();
            // Select products -- simulate user selecting all products
            for (RetailForecastLineWrapper wrapper : ctrl.data) {
                wrapper.selected = true;
            }
            
            // Save
            ctrl.save();    
        }
                
        // Simulate sorting
        ctrl.sortField = 'Carrier__c';
        ctrl.doSort();
        
        // Sort one more time -- descending order
        ctrl.sortField = 'Carrier__c';
        ctrl.doSort();
        
        // Simulate goback button click
        ctrl.goback();

        // Add business ID parameter
        myPage.getParameters().put('business', 'Home');
        ctrl = new RetailSelectPriceBookLines();
        ctrl.init();
    }
}