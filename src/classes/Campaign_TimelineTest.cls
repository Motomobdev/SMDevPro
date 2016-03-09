@isTest(SeeAllData=true)
private class Campaign_TimelineTest {

    @isTest static void test_method_one() {
        Campaign c = new Campaign();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        Campaign_Timeline ct = new Campaign_Timeline(sc);

        // NOTE: These hard-coded values match the picklist values in the object.
        // If the object picklist values are removed or renamed then this test case will fail.
        ct.selectedPortfolioSegment = 'Value';
        ct.populateProgramMap();

        ct.selectedProgram = 'a1C400000068SHGEA2-DVX';
        ct.selectedProject = 'a1D40000006RqwEEAS-DVX CDMA';
        ct.selectedProduct = 'a1B40000002P6jTEAS-DVX CDMA 16GB';

        ct.acct.region__c = 'North America';
        ct.acct.sub_region__c = 'North America';
        ct.acct.country__c = 'United States';
        
        String[] regions = new List<String>{'North America'};
        String[] countries= new List<String>{'United States'};
        String[] accounts = new List<String>{'0014000000nNCpxAAG'};// {'AT&T MOBILITY'};
        
        ct.selectedRegions = regions;
        ct.selectedSubRegions = regions;
        ct.selectedCountries = countries;
        ct.selectedAccounts = accounts;

        ct.cmpg.type = 'Other';
        ct.cmpg.category__c = 'Other';
        ct.cmpg.sub_category__c = 'Other';
        ct.cmpg.target__c = 'Other';

        ct.submit();

        ct.getJsonData();
        ct.populateRegions();
        ct.populateSubRegions();
        ct.populateCountries();
        ct.populateAccounts();
        ct.populateProjects();
        ct.populateProducts();
    }

    @isTest static void test_missing_recordtype() {
        Campaign c = new Campaign();
        ApexPages.StandardController sc = new ApexPages.StandardController(c);
        Campaign_Timeline ct = new Campaign_Timeline(sc);

        ct.promotionRecordType = null;
        ct.submit();
    }
}