public class RetailOutlookController {

    /*
     * Created by: Rajesh Krishnaiah
     * Creation date: 11-Nov-2011
     * Description: This controller creates an outlook and its lines for the NEXT WEEK.
     *   If an outlook for next week exists, the user would be notified with an error message.
     *   We add 7 days to today to determine the next week.
     *   An outlook is a clone of a forecast line which is a clone of price book line.
     *   Every outlook line has a reference back to the prior week's outlook like (connected via
     *   forecast line ID). When the quarter changes, the reference to prior week will be null.
     * Change history:
     * Changed on: 06-Jun-2012
     * Changed by: Rajesh Krishnaiah
     * Description: The date format of mm/dd/yyyy for the "today" parameter caused the code
     *              to fail when the user has non en_US locale. Added logic to split the
     *              string date into year, month and day to create an instance of a date.
     */

    public String forecastURL {get; set;}
    Integer currentWeekQuarterNumber;
    Integer currentWeekNumber;
    
    Integer outlookWeekQuarterNumber;
    Integer outlookWeekNumber;
    Integer outlookWeekYear;

    Date today = Date.today();
    Date outlookWeek = today.addDays(7);
    Date fristDayOfTheOutlook = outlookWeek.toStartofWeek();
    
    Public boolean copyRNO = false; // Indicates if we need to copy R&O data or not
    Public boolean copyUnits = false; // Indicates if we need to copy units data
    Retail_Forecast__c retailForecast = null;
    Retail_Outlook__c currentWeekOutlook  = null;
    public Retail_Outlook__c outlookWeekOutlook  = null;
    public List<Retail_Outlook_Line__c> outlookLines = 
        new List<Retail_Outlook_Line__c>();

    public RetailOutlookController() {
        // Get forecast ID from the URL
        String forecastId = ApexPages.currentPage().getParameters().get('forecastId');
        forecastURL = '/' + forecastId;
        
        // Retrieve the forecast record
        retailForecast = [select id, name, forecast_year__c, forecast_quarter__c, 
                            account__c, locked__c, Quarter_First_Day__c
                          from retail_forecast__c
                          where id = :forecastId
                          LIMIT 1];

        // This field overrides today with a new value so you can create outlooks for the past/future weeks
        // Date format = MM/DD/YYYY, Example: 12/27/2009
        String dt = ApexPages.currentPage().getParameters().get('today');
        if (dt != null) {
            List<String> splitDate = dt.split('/');
            Integer month = Integer.valueOf(splitDate.get(0));
            Integer day = Integer.valueOf(splitDate.get(1));
            Integer year = Integer.valueOf(splitDate.get(2));
            
            //today = Date.parse(dt);
            today = date.newInstance(year, month, day);
            
            outlookWeek = today.addDays(7);
            fristDayOfTheOutlook = outlookWeek.toStartofWeek();
        }

        // Do we need to copy R&O data from the current week to next week's outlook
        String tempCopyRNO = ApexPages.currentPage().getParameters().get('copyRNO');
        if (tempCopyRNO != null && tempCopyRNO == 'true')
            copyRNO = true;
        String tempCopyUnits = ApexPages.currentPage().getParameters().get('copyUnits');
        if (tempCopyUnits != null && tempCopyUnits == 'true')
            copyUnits = true;
    }

    public PageReference init() {

        // Outlook cannot be created for an unlocked forecast
        if (!retailForecast.locked__c) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Your forecast is unlocked. An Outlook cannot be created on an unlocked forecast.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        // Insert a dummy record to get the week and quarter numbers via SOQL
        Retail_Outlook_Temp__c rtemp = 
            new Retail_Outlook_Temp__c(date1__c = today, date2__c = outlookWeek,
                                    date3__c = retailForecast.Quarter_First_Day__c);
        Insert rtemp;

        List<AggregateResult> ars =
            [select id, CALENDAR_YEAR(date2__c) CYN, CALENDAR_YEAR(date3__c) CYF,
                        CALENDAR_QUARTER(date1__c) CQ, WEEK_IN_YEAR(date1__c) WY,
                        CALENDAR_QUARTER(date2__c) CQN, WEEK_IN_YEAR(date2__c) WYN,
                        CALENDAR_QUARTER(date3__c) CQF, WEEK_IN_YEAR(date3__c) WYF
             from Retail_Outlook_Temp__c Where id = :rtemp.id
             group by id, CALENDAR_YEAR(date2__c),CALENDAR_YEAR(date3__c),
                          CALENDAR_QUARTER(date1__c), WEEK_IN_YEAR(date1__c),
                          CALENDAR_QUARTER(date2__c), WEEK_IN_YEAR(date2__c),
                          CALENDAR_QUARTER(date3__c), WEEK_IN_YEAR(date3__c) 
            ];
        AggregateResult ar = ars[0];

        currentWeekQuarterNumber = (Integer)ar.get('CQ');
        currentWeekNumber = (Integer)ar.get('WY');
        
        outlookWeekQuarterNumber = (Integer)ar.get('CQN');
        outlookWeekNumber = (Integer)ar.get('WYN');
        outlookWeekYear = (Integer)ar.get('CYN');

        // Delete the dummy record
        Delete rtemp;
        
        Integer forecastYear = Integer.valueOf(retailForecast.forecast_year__c);
        if (outlookWeekYear != forecastYear) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'Your forecast year [' + forecastYear + '] is different than next week\'s year [' + outlookWeekYear + '].'
                + ' Use a different forecast to create the outlook.');
            ApexPages.addMessage(myMsg);
            return null;
        }
                
        // Check if we already have next week's outlook on this forecast
        Integer outlookWeekNumber = currentWeekNumber + 1;
        List<Retail_Outlook__c> outlooks =
            [select id from Retail_Outlook__c
             where Retail_Forecast__c = :retailForecast.Id
             and week_number__c = :outlookWeekNumber];

        if (!outlooks.isEmpty()) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'An outlook for week W' + outlookWeekNumber + ' already exists.');
            ApexPages.addMessage(myMsg);
            return null;
        }

        Map<Id, Retail_Outlook_line__c> currentWeekOutlookLineMap =
            new Map<Id, Retail_Outlook_line__c>();
        
        /*
        system.debug('Today: [' + today + ']. Q Frist Day: [ ' + retailForecast.Quarter_First_Day__c);
        system.debug('outlookWeekQuarterNumber: [' + 
                outlookWeekQuarterNumber + ']. currentWeekQuarterNumber: [' + 
                currentWeekQuarterNumber);
        */
        if (today < retailForecast.Quarter_First_Day__c) {
            // Get the week number for the first day of the foreacst year and quarter
            Integer forecastyearQuarterWeekNumber = (Integer)ar.get('WYF');         
            
            // Do we have an outlook for forecast year + quarter + weekNumber
            outlooks = [select id from Retail_Outlook__c
                        where Retail_Forecast__c = :retailForecast.id
                        and week_number__c = :forecastyearQuarterWeekNumber];

            if (!outlooks.isEmpty()) {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                    'An outlook for week W' + outlookWeekNumber + ' in year ' + retailForecast.Quarter_First_Day__c.year()
                    + ' already exists.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            outlookWeekQuarterNumber = forecastyearQuarterWeekNumber;
            outlookWeekNumber = (Integer)ar.get('WYF');
            outlookWeekYear = (Integer)ar.get('CYF');
            fristDayOfTheOutlook = retailForecast.Quarter_First_Day__c.toStartofWeek();
        } else if (outlookWeekQuarterNumber == currentWeekQuarterNumber) {

            // Check if the current week has an outlook
            outlooks = [select id from Retail_Outlook__c
             where Retail_Forecast__c = :retailForecast.id
             and week_number__c = :currentWeekNumber];

            if (!outlooks.isEmpty()) {
                currentWeekOutlook = outlooks.get(0);

                // Get current week's outlook lines including risk and oppty (R&O) lines
                List<Retail_Outlook_Line__c> currentWeekOutlookLines =
                    [select id, Retail_Forecast_Line__c, units__c,
                      (SELECT Id, Name, Retail_Outlook_Line__c, RO_Comments__c, 
                              RO_Price__c, RO_Probability__c, RO_Type__c,
                              RO_Units__c,RO__c 
                       FROM Retail_Outlook_ROs__r)
                     from Retail_Outlook_Line__c
                     where Retail_Outlook__c = :currentWeekOutlook.id
                       and Retail_Forecast_Line__r.retail_forecast__c = :retailForecast.id];

                for (Retail_Outlook_Line__c rol : currentWeekOutlookLines) {
                    currentWeekOutlookLineMap.put(rol.Retail_Forecast_Line__c, rol);
                }
            }
        } else {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,
                'You\'ve reached the end of the current quarter. Outlook for next week must be '
                + ' created from the forecast for the next quarter.');
            ApexPages.addMessage(myMsg);
            return null;
        }

        // Create an outlook header record
        outlookWeekOutlook = new Retail_Outlook__c(
                        name = retailForecast.name + ' - W' + outlookWeekNumber,
                        Retail_Forecast__c = retailForecast.id,
                        Outlook_Locked__c = false,
                        week_number__c = outlookWeekNumber,
                        Week_Start_Date__c = fristDayOfTheOutlook
                        );
        insert outlookWeekOutlook;

        String quarter = retailForecast.forecast_quarter__c;
        // Construct a dynamic SOQL to get quarter data from the forecast lines object
        String forecastLinesSoql =
                    'select id, Business__c,Carrier__c, units__c, asp__c, mcpu__c, '
                    + 'Retail_Price_Book_Line__r.' + quarter + '_asp__c, '
                    + 'Retail_Price_Book_Line__r.' + quarter + '_mcpu__c '
                    + 'from Retail_Forecast_Line__c '
                    + 'where retail_forecast__c = \'' + retailForecast.id + '\'';

        List<SObject> queryResults = Database.query(forecastLinesSoql);

        // Add outlook lines
        for (SObject obj : queryResults) {

            Retail_Forecast_Line__c forecastLine = (Retail_Forecast_Line__c)obj;
            Retail_Price_Book_Line__c rpbl = (Retail_Price_Book_Line__c)obj.getSObject('Retail_Price_Book_Line__r');

            // Lookup the corresponding retail outlook line from the current week
            // by using the forecast line ID
            Retail_Outlook_Line__c rol =
                currentWeekOutlookLineMap.get(forecastLine.id);

            Retail_Outlook_Line__c outlookLine = new Retail_Outlook_Line__c(
                asp__c = (Decimal)rpbl.get(quarter + '_asp__c'),
                mcpu__c = (Decimal)rpbl.get(quarter + '_mcpu__c'),
                plan_asp__c = (Decimal)forecastLine.get('asp__c'),
                plan_mcpu__c = (Decimal)forecastLine.get('mcpu__c'),
                plan_units__c = (Decimal)forecastLine.get('units__c')
            );

            if (rol != null) {
                outlookLine.Prev_Week_Retail_Outlook_Line__c = rol.id;
                
                if (copyUnits) {
                //                outlookLine.units__c = 0.0; // rol.units__c;
                    outlookLine.units__c = rol.units__c;
                } else {
                    outlookLine.units__c = 0.0;
                }
                
            } else {
                // Copy units from forecast line because we don't have previous outlook line
                outlookLine.units__c = (Decimal)forecastLine.get('units__c');
            }

            outlookLine.Retail_Forecast_Line__c = forecastLine.id;
            outlookLine.Retail_Outlook__c = outlookWeekOutlook.id;

            outlookLines.add(outlookLine);
        }

        if (!outlookLines.isEmpty())
            insert outlookLines;

        if (copyRNO) {            
            // Copy R&O (risk and oppty) lines from the current week's outlook to the 
            // new next week's outlook
            List<Retail_Outlook_RO__C> newROs = new List<Retail_Outlook_RO__C>();
            
            for (Retail_Outlook_Line__c newRol : outlookLines) {
            
                // If this new (next week's) outlook line has a tie back to the
                // prior week's outlook line then copy its R&O records 
                if (newRol.Prev_Week_Retail_Outlook_Line__c != null) {
                    Retail_Outlook_Line__c priorWeekRol = 
                        currentWeekOutlookLineMap.get(newRol.Retail_Forecast_Line__c);
                    
                    for (Retail_Outlook_RO__C priorRO : priorWeekRol.Retail_Outlook_ROs__r) {
                        Retail_Outlook_RO__C newRO = new Retail_Outlook_RO__C(
                            Retail_Outlook_Line__c = newRol.id,
                            RO_Comments__c = priorRO.RO_Comments__c,
                            RO_Price__c = priorRO.RO_Price__c,
                            RO_Probability__c = priorRo.RO_Probability__c,
                            RO_Type__c = priorRO.RO_Type__c,
                            RO_Units__c = priorRO.RO_Units__c,
                            RO__c = priorRO.RO__c
                        );
                        newROs.add(newRO);
                    }
                }
            }
            
            if (!newROs.isEmpty()) {
                insert newROs;
            }
        }
        
        // Show a confirmation for the outlook creation
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,
                'An outlook for W' + outlookWeekNumber + ' week has been created.');
        ApexPages.addMessage(myMsg);

        PageReference pageRef = new PageReference('/' + outlookWeekOutlook.id);
        pageref.setRedirect(false);
        return pageRef;
    }

    /*
     *
     */
    private static testmethod void test() {
    
        PageReference roPage = Page.Retail_Outlook;
        String currentYear = String.valueOf(Date.today().year());
        Account a = RetailSalesTestUtil.createTestAccount();
        List<Product2> products = RetailSalesTestUtil.createTestProducts();
        Retail_Price_Book__c rpb = RetailSalesTestUtil.createPriceBook();
        List<Retail_Price_Book_Line__c> rpbls = 
            RetailSalesTestUtil.createPriceBookLines(a, rpb, products);
        Test.setCurrentPage(roPage);
        
        // Test for all four quarters
        RetailOutlookController ctrl = null;
        Retail_forecast__c rf = null;
        List<Retail_Forecast_Line__c> rfls = null;
        
        for (Integer i = 1; i < 5; ++i) {
            rf = RetailSalesTestUtil.createForecast(a, rpb, currentYear, 'Q' + i);
            rfls = RetailSalesTestUtil.createForecastLines(a, rf, rpbls);
            RetailSalesTestUtil.lockForecast(rf);

            // Select the forecast record so the quarter first day formula field has a value
            rf = [select id, name, forecast_year__c, forecast_quarter__c, 
                            account__c, locked__c, Quarter_First_Day__c
                          from retail_forecast__c
                          where id = :rf.id
                          LIMIT 1];
            Date today = rf.Quarter_First_Day__c;
            
            roPage.getParameters().put('forecastId', rf.id);
            // Create an outlook from the first day of quarter Qi
            roPage.getParameters().put('today', today.month() + '/' + today.day() + '/' + today.year());
            ctrl = new RetailOutlookController();
            ctrl.init();
    
            // Add a Risk and Opportunity record for the first outlook line
            RetailSalesTestUtil.createRetailOutlookRO(ctrl.outlookLines[0], 'Risk', 'Price', 'High', 10.0, 0);
            Retail_Outlook_RO__C roro = 
                RetailSalesTestUtil.createRetailOutlookRO(ctrl.outlookLines[0], 'Opportunity', 
                    'Demand', 'Medium', 0.0, 30);
                    
            // try to create one more outlook for the same week
            // expect it to fail
            roPage.getParameters().put('forecastId', rf.id);
            roPage.getParameters().put('today', today.month() + '/' + today.day() + '/' + today.year());
            ctrl = new RetailOutlookController();
            system.assert(ctrl.init() == null);

        }

        // now that we have created an outlook for next week, let's create one more
        // outlook for the week after next, by passing in today's parameter.
        // Also, test Copy R&O and Copy Units parameters as well
        Date outlookWeek = Date.today().addDays(7);
        roPage.getParameters().put('forecastId', rf.id);
        roPage.getParameters().put('today', outlookWeek.month() + '/' + outlookWeek.day() + '/' + outlookWeek.year());
        roPage.getParameters().put('copyRNO', 'true');
        roPage.getParameters().put('copyUnits', 'true');
        ctrl = new RetailOutlookController();
        ctrl.init();

        // Set forecast year to be next year
        String nextYear = String.valueOf(Date.today().year() + 1);
        rf = RetailSalesTestUtil.createForecast(a, rpb, nextYear, 'Q1');
        rfls = RetailSalesTestUtil.createForecastLines(a, rf, rpbls);
        roPage.getParameters().put('forecastId', rf.id);
        roPage.getParameters().put('today', '12/31/' + nextYear);
        RetailSalesTestUtil.lockForecast(rf);
        ctrl = new RetailOutlookController();
        ctrl.init();

        // Simulate unlocked forecast scenario
        rf = RetailSalesTestUtil.createForecast(a, rpb, nextYear, 'Q2');
        rfls = RetailSalesTestUtil.createForecastLines(a, rf, rpbls);
        roPage.getParameters().put('forecastId', rf.id);
        roPage.getParameters().put('today', '04/01/' + nextYear);
        ctrl = new RetailOutlookController();
        ctrl.init();
        
        // Simulate today < forecast first day
        rf = RetailSalesTestUtil.createForecast(a, rpb, nextYear, 'Q3');
        rfls = RetailSalesTestUtil.createForecastLines(a, rf, rpbls);
        roPage.getParameters().put('forecastId', rf.id);
        RetailSalesTestUtil.lockForecast(rf);
        ctrl = new RetailOutlookController();
        ctrl.init();
               
        // Handle risks and opportunities
        if (!ctrl.outlookLines.isEmpty()) {
            system.debug('Inside RO test');
            RetailSalesTestUtil.createRetailOutlookRO(ctrl.outlookLines[0], 'Risk', 'Price', 'High', 10.0, 0);
            Retail_Outlook_RO__C roro = 
                RetailSalesTestUtil.createRetailOutlookRO(ctrl.outlookLines[0], 'Opportunity', 
                    'Demand', 'Medium', 0.0, 30);
            delete roro;
        }
    }
}