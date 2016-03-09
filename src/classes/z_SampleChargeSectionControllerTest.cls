@isTest
private class z_SampleChargeSectionControllerTest {
	
        static testMethod void testComponent() {
                // Make some test data
                Application__c testApp = Z_TestFactory.makeApplication();
                zqu__Quote__c testQuote = makeQuote();
                zqu__ZProduct__c testProduct = Z_TestDataSetup.prepareProductCatalog();
                
                List<zqu__ProductRatePlan__c> ratePlanList = [
                        SELECT 
                                Id
                        FROM
                                zqu__ProductRatePlan__c
                        WHERE
                                zqu__ZProduct__c = :testProduct.Id
                ];
                
                if (ratePlanList.size() == 0)
                        return;
                        
                System.debug('#### rate plan list size = ' + ratePlanList.size());
                
                // Add the charge group to the quote
                zqu.zChargeGroup chargeGroup = zqu.zQuoteUtil.getChargeGroup(testQuote.Id, ratePlanList.get(0).Id);
                zqu.zQuoteUtil.addChargeGroups(new List<zqu.zChargeGroup> { chargeGroup });
                
                Test.startTest();
                z_SampleChargeSectionController ctl = new z_SampleChargeSectionController();
                
                List<zqu.ZChargeGroup> chargeGroupList = ctl.chargeGroupList;
                
                ctl.currentChargeGroup = chargeGroup;
                ctl.changedCharge = 'Changed Charge Name';
                ctl.discountChange();
                ctl.quntityChange();
                ctl.effectiveChange();
                ctl.totalChange();
                PageReference testPage = ctl.saveCharges();
                ctl.defaultCumulationVal();
                ctl.getprepaid();
                
                Test.stopTest();
        }
        
        /**
         * Prepare a quote
         */
        private static zqu__Quote__c makeQuote() {
                
                Account acc = Z_TestFactory.makeAccount();
                Contact con = Z_TestFactory.makeContact(acc);
                Opportunity opp = Z_TestFactory.makeOpportunity(acc);
                
                zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
                
                quote.zqu__StartDate__c = date.today();
                quote.zqu__SoldToContact__c = con.Id;
                quote.zqu__BillToContact__c = con.Id;
                quote.zqu__Currency__c = 'USD';
                
                update quote;
                return quote;
        }
}