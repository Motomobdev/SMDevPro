@isTest 
public class RetailSalesTestUtil {

    /*
    * Author: Rajesh Krishnaiah
    * Date  : 21-Nov-20111
    * Desc  : Contains static methods for creating retails sales test data.
    */

    public static Account createTestAccount() { 
       Account a = new Account(name = 'Retail Sales Test Account');
       insert a;
       return a;
    }

    public static List<Product2> createTestProducts() {
       
       // One product for each quarter
       List<Product2> products = new Product2[]{
           new Product2(name = 'Retail Test Product1'),
           new Product2(name = 'Retail Test Product2'),
           new Product2(name = 'Retail Test Product3'),
           new Product2(name = 'Retail Test Product4')
            };
       
       insert products;
       
       return products;
    }
    
    public static Retail_Price_Book__c createPriceBook() {
        Retail_Price_Book__c rpb = new Retail_Price_Book__c(name = 'Retail Test RPB');
        insert rpb;
        
        return rpb;
    }
    
    public static List<Retail_Price_Book_Line__c> createPriceBookLines(
            Account a, Retail_Price_Book__c rpb, List<Product2> products) {
        
        List<Retail_Price_Book_Line__c> rpbls = new List<Retail_Price_Book_Line__c>();
        Integer i = 0;
        
        for (Product2 product : products) {

            Retail_Price_Book_Line__c rpbl = new Retail_Price_Book_Line__c();
            
            // every other product will not have an account and the business value
            // goes from Home to Other
            if (i == 0) {
                rpbl.Account__c = a.id;
                rpbl.carrier__c = 'Verizon';
                rpbl.business__c = 'Home';
            } else {
                rpbl.business__c = 'Other';
                rpbl.carrier__c = 'Sprint';
            }
            
            ++i;
            rpbl.Retail_Price_Book__c = rpb.id;
            rpbl.product__c = product.id;
            rpbl.q1_asp__c = 20 + i;
            rpbl.q2_asp__c = 18 + i;
            rpbl.q3_asp__c = 16 + i;
            rpbl.q4_asp__c = 14 + i;
            rpbl.q1_mcpu__c = 12 + i;
            rpbl.q2_mcpu__c = 10 + i;
            rpbl.q3_mcpu__c = 8 + i;
            rpbl.q4_mcpu__c = 6 + i;

            rpbls.add(rpbl);
            if (i == 2)
                i = 0;
        }

        insert rpbls;
        return rpbls;
    }
    
    public static Retail_forecast__c createForecast(Account a, Retail_Price_Book__c rpb, 
        String year, String quarter) {
        Retail_Forecast__c rf = new Retail_Forecast__c(name = 'Retail Test Forecast', 
                Account__c = a.id, price_book__c = rpb.id, 
                forecast_year__c = year, forecast_quarter__c = quarter, locked__c = false);
        insert rf;

        return rf;
    }
    
    public static Retail_outlook__c createOutlook(Retail_Forecast__c rf) {
        Retail_Outlook__c ro = new Retail_Outlook__c(name = 'Retail Test Outlook', 
                Retail_Forecast__c = rf.id, Outlook_Locked__c= false, Week_Number__c = 1); 
                //Week_Start_Date__c = 2010-04-14T00:00:00.000Z);
        insert ro;

        return ro;
    }
    
    public static List<Retail_outlook_line__c> createOutlookLines(List<Retail_Forecast_line__c> rfls, Retail_Outlook__c ro) {
        
        List<Retail_Outlook_Line__c> rols = new List<Retail_Outlook_Line__c>();
        
        Integer i = 1;
        for (Retail_Forecast_line__c rfl : rfls) {
            Retail_Outlook_Line__c rol = new Retail_Outlook_Line__c(
                Retail_Forecast_Line__c = rfl.id, Retail_Outlook__c =ro.id );
           
            rols.add(rol);
            ++i;
            if (i == 5)
                i = 1;
        }
                
        insert rols;

        return rols;
    }
    
    public static void lockForecast(Retail_forecast__c rf) {
        rf.locked__c = true;
        update rf;
    }
    
    
    public static List<Retail_forecast_Line__c> createForecastLines(Account a, 
        Retail_forecast__c rf, List<Retail_Price_Book_Line__c> rpbls) {
        
        List<Retail_forecast_Line__c> rfls = new List<Retail_forecast_Line__c>();
        
        Integer i = 1;
        for (Retail_Price_Book_Line__c rpbl : rpbls) {
            Retail_forecast_Line__c rfl = new Retail_forecast_Line__c(
                retail_forecast__c = rf.id,
                Retail_Price_Book_Line__c = rpbl.id
            );
           
           String quarter = 'Q' + i;
           rfl.asp__c = (Double)rpbl.get(quarter + '_asp__c');
           rfl.mcpu__c = (Double)rpbl.get(quarter + '_mcpu__c'); 
            
            rfls.add(rfl);
            ++i;
            if (i == 5)
                i = 1;
        }

        insert rfls;
        return rfls;
    }
    
    public static Retail_Outlook_RO__C createRetailOutlookRO(Retail_Outlook_Line__c rol, String ro,
        String roType, String roProbability, Decimal roPrice, integer roUnits) {

        Retail_Outlook_RO__c roro = new Retail_Outlook_RO__c(Retail_Outlook_Line__c = rol.id, RO__c = ro,
            RO_Type__c = roType, RO_Probability__c = roProbability, RO_Price__c = roPrice, RO_Units__c = roUnits);
        
        insert roro;
        return roro;
    }
    
    private static testmethod void testUpdateForecastLinesTrigger() {
    
        Account a = createTestAccount();
        List<Product2> products = createTestProducts();
        Retail_Price_Book__c rpb = createPriceBook();
        List<Retail_Price_Book_Line__c> rpbls = createPriceBookLines(a, rpb, products);
        Retail_Forecast__c rf = createForecast(a, rpb, '2011', 'Q4');
        
        // Scenario -- changes to a price book line when the line is not attached to any forecast
        Retail_Price_Book_Line__c rpbl = rpbls[0];
        rpbl.q1_asp__c = 5;
        rpbl.q2_asp__c = 6;
        rpbl.q3_asp__c = 7;
        rpbl.q4_asp__c = 8;
        update rpbl;
        
        // Add price book lines to the forecast
        List<Retail_forecast_Line__c> rfls = createForecastLines(a, rf, rpbls);
        
        // Update price book line 2
        rpbl = rpbls[1];
        rpbl.q1_asp__c = 6;
        rpbl.q2_asp__c = 7;
        rpbl.q3_asp__c = 8;
        rpbl.q4_asp__c = 9;        
        update rpbl;
        
    }
    
    private static testmethod void testDeleteForecastLinesTrigger() {
    
        Account a = createTestAccount();
        List<Product2> products = createTestProducts();
        Retail_Price_Book__c rpb = createPriceBook();
        List<Retail_Price_Book_Line__c> rpbls = createPriceBookLines(a, rpb, products);
        Retail_Forecast__c rf = createForecast(a, rpb, '2011', 'Q4');
        Retail_Outlook__c ro = createOutlook(rf);
        
              
        // Add price book lines to the forecast
        List<Retail_forecast_Line__c> rfls = createForecastLines(a, rf, rpbls);
        List <Retail_Outlook_Line__c> rols = createOutlookLines (rfls, ro);
        //Delete Forecast Line
        //delete rols;
        try{
          delete rfls;
          
        } catch(DMLException e) {
         //Generic exception handling code here
         //We expect test fail here
        }
    } 
    private static testmethod void testValidatePriceBookLineDeleteTrigger() {
    
        Account a = createTestAccount();
        List<Product2> products = createTestProducts();
        Retail_Price_Book__c rpb = createPriceBook();
        List<Retail_Price_Book_Line__c> rpbls = createPriceBookLines(a, rpb, products);
        Retail_Forecast__c rf = createForecast(a, rpb, '2011', 'Q4');
        Retail_Outlook__c ro = createOutlook(rf);
        
        try{
          delete rpbls[0];
          
        } catch(DMLException e) {
         //Generic exception handling code here
         //We expect test fail here
        }
        List<Retail_Price_Book_Line__c> pbLines00 = [SELECT id FROM Retail_Price_Book_Line__c WHERE Retail_Price_Book__c = :rpb.Id];

        system.assert(pbLines00.size() == 3);
        
        delete rpbls[1];
        delete rpbls[2];
        delete rpbls[3];
        rpbls = createPriceBookLines(a, rpb, products);
        
        // Add price book lines to the forecast
        List<Retail_forecast_Line__c> rfls = createForecastLines(a, rf, rpbls);
        
        // Delete price book line.
        try{
          delete rpbls[0];
          
        } catch(DMLException e) {
         //Generic exception handling code here
         //We expect test fail here
        }
        List<Retail_Price_Book_Line__c> pbLines01 = [SELECT id FROM Retail_Price_Book_Line__c WHERE Retail_Price_Book__c = :rpb.Id];

        system.assert(pbLines01.size() == 4);
    } 
}