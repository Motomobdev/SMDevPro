/*

Test class for the product selector

@author Mickael Pham

*/

@isTest
private class Z_ProductSelector_TEST {

        static testMethod void testDisplayNoQuoteFound() {

                Test.startTest();

                ApexPages.StandardController stdController = new ApexPages.StandardController(new zqu__Quote__c());
                Z_ProductSelector ctl = new Z_ProductSelector(stdController);

                Test.stopTest();
        }

        static testMethod void testDisplayWrongQuoteId() {

                // Create a non-quote object (to get a correct ID but wrong object)
                Account acc = Z_TestFactory.makeAccount();

                Test.startTest();

                ApexPages.Standardcontroller stdController = new ApexPages.StandardController(acc);
                Z_ProductSelector ctl = new Z_ProductSelector(stdController);

                Test.stopTest();
        }


        static testMethod void testDisplayNoProduct() {

                // Create the quote object
                Account acc = Z_TestFactory.makeAccount();
                Opportunity opp = Z_TestFactory.makeOpportunity(acc);
                zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);

                Test.startTest();

                ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
                Z_ProductSelector ctl = new Z_ProductSelector(stdController);

                Test.stopTest();
        }


        static testMethod void testDisplayProduct() {

                // Setup the product catalog
                zqu__ZProduct__c product = Z_TestDataSetup.prepareProductCatalog();

                // Create the quote object
                Account acc = Z_TestFactory.makeAccount();
                Opportunity opp = Z_TestFactory.makeOpportunity(acc);
                zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);

                // Update quote information
                quote.zqu__Currency__c = 'USD';
                quote.zqu__StartDate__c = Date.today().addDays(1);
                update quote;

                Test.startTest();

                ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
                Z_ProductSelector ctl = new Z_ProductSelector(stdController);

                // Get the product list to display
                List<zqu__ZProduct__c> productList = ctl.productList;
                List<zqu__ProductRatePlan__c> ratePlanList = ctl.ratePlanList;

                // Get the product section info
                String productSection = ctl.productSectionInfo;
                Boolean productHasPrevious = ctl.productHasPrevious;
                Boolean productHasNext = ctl.productHasNext;
                ctl.nextProductPage();
                ctl.previousProductPage();

                // Search for a given product
                ctl.productSearchString = product.Name;
                ctl.refreshProducts();

                // Select a product and refresh the rate plan
                ctl.selProductId = product.Id;
                ctl.refreshRatePlans();
                ratePlanList = ctl.ratePlanList;

                // Get the product rate plan info
                String ratePlanSection = ctl.ratePlanSectionInfo;
                Boolean ratePlanHasPrevious = ctl.ratePlanHasPrevious;
                Boolean ratePlanHasNext = ctl.ratePlanHasNext;
                ctl.nextRatePlanPage();
                ctl.previousRatePlanPage();

                // Search for a given rate plan
                ctl.ratePlanSearchString = 'some string';
                //ctl.changedCharge = 'Some String';
                
                ctl.refreshRatePlans();

                if (ratePlanList.size() > 0) {
                        ctl.selRatePlanId = ratePlanList[0].Id;
                }

                // Charge group
                ctl.refreshChargeGroup();

                ctl.discountChange();
                ctl.quantityChange();
                ctl.totalChange();
                //ctl.effectiveChange();

                // Add the charge to the quote
                ctl.saveCharges();
                ctl.saveAndNewCharges();

                Test.stopTest();
        }
        
        static testMethod void testGetPicklists() {

                // Setup the product catalog
                zqu__ZProduct__c product = Z_TestDataSetup.prepareProductCatalog();

                // Create the quote object
                Account acc = Z_TestFactory.makeAccount();
                Opportunity opp = Z_TestFactory.makeOpportunity(acc);
                zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);

                // Update quote information
                quote.zqu__Currency__c = 'USD';
                quote.zqu__StartDate__c = Date.today().addDays(1);
                update quote;

                Test.startTest();
				ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
                Z_ProductSelector ctl = new Z_ProductSelector(stdController);

                // Get the product list to display
                List<selectOption> applicationList = ctl.getapplications();
                List<selectOption> prepaidList = ctl.getprepaid();
                
                Test.stopTest();
        }
}