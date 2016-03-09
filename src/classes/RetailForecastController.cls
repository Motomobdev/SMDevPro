public class RetailForecastController {

    ApexPages.StandardController myController;

    public RetailForecastController(ApexPages.StandardController controller) {
        myController = controller;
    }
    
    public PageReference mySave(){
        PageReference myPage = null;
        
        if (myController.save() == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
            'A forecast for this account already exists for this period (year and quarter).');
            ApexPages.addMessage(myMsg);
            
            return null;        
        } else {
            myPage = myController.view();
        }

        return myPage;
    }
    
     private static testmethod void test() {
        
        Account a = RetailSalesTestUtil.createTestAccount();
        List<Product2> products = RetailSalesTestUtil.createTestProducts();
        Retail_Price_Book__c rpb = RetailSalesTestUtil.createPriceBook();
        List<Retail_Price_Book_Line__c> rpbls = 
            RetailSalesTestUtil.createPriceBookLines(a, rpb, products);
                
        // Create a forecast
        Retail_forecast__c  rf = new Retail_Forecast__c(Account__c = a.id, price_book__c = rpb.id, 
            forecast_year__c = '2011', forecast_quarter__c = 'Q1');
        
        PageReference rfPage = Page.Retail_Forecast;
        Test.setCurrentPage(rfPage);

        RetailForecastController ctrl = 
            new RetailForecastController(new ApexPages.StandardController(rf));
        // New forecast save should take the user to the forecast view page
        system.assert(ctrl.mySave() != null);

        // Try creating one more forecast for the same account, year and quarter combination
        // and expect mysave to return null
        rf = new Retail_Forecast__c(Account__c = a.id, price_book__c = rpb.id, 
            forecast_year__c = '2011', forecast_quarter__c = 'Q1');
        ctrl = new RetailForecastController(new ApexPages.StandardController(rf));

        system.assert(ctrl.mySave() == null);
     }
}