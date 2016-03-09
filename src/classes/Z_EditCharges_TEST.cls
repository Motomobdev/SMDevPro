/*

Test class for the edit charge function

@author Mickael Pham

*/

@isTest
public with sharing class Z_EditCharges_TEST {

        
        static testMethod void testDisplayNoQuoteFound() {

                Test.startTest();

                ApexPages.StandardController stdController = new ApexPages.StandardController(new zqu__Quote__c());
                Z_EditCharges ctl = new Z_EditCharges(stdController);

                Test.stopTest();
        }

        static testMethod void testDisplayWrongQuoteId() {

                // Create a non-quote object (to get a correct ID but wrong object)
                Account acc = Z_TestFactory.makeAccount();

                Test.startTest();

                ApexPages.Standardcontroller stdController = new ApexPages.StandardController(acc);
                Z_EditCharges ctl = new Z_EditCharges(stdController);

                Test.stopTest();
        }


        static testMethod void testDisplayNoProduct() {

                // Create the quote object
                Account acc = Z_TestFactory.makeAccount();
                Opportunity opp = Z_TestFactory.makeOpportunity(acc);
                zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);

                Test.startTest();

                ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
                Z_EditCharges ctl = new Z_EditCharges(stdController);

                Test.stopTest();
        }


        static testMethod void testDisplayProduct() {

                // Setup the product catalog
                zqu__ZProduct__c product = Z_TestDataSetup.prepareProductCatalog();

                // Create the quote object
                Account acc = Z_TestFactory.makeAccount();
                Opportunity opp = Z_TestFactory.makeOpportunity(acc);
                zqu__Quote__c quote = Z_TestFactory.makeQuote(opp);
                Application__c testApp = Z_TestFactory.makeApplication(); 

                // Update quote information
                quote.zqu__Currency__c = 'USD';
                quote.zqu__StartDate__c = Date.today().addDays(1);
                update quote;

                // Make a quote amendment
                zqu__QuoteAmendment__c quoteAmendment = new zqu__QuoteAmendment__c();
                quoteAmendment.zqu__Description__c = 'test amendment';
                quoteAmendment.zqu__TotalAmount__c = 150;
                quoteAmendment.zqu__Type__c = 'AddProduct';
                quoteAmendment.zqu__Quote__c = quote.Id;

                insert quoteAmendment;

                Test.startTest();

                ApexPages.Standardcontroller stdController = new ApexPages.StandardController(quote);
                Z_EditCharges ctl = new Z_EditCharges(stdController);

                // Display/Cancel catalog
                ctl.doDisplayProductCatalog();
                ctl.cancelDisplayProductCatalog();
                
                
                ctl.getApplications();
                ctl.chosenApplication = testApp.Id;
                ctl.setApplicationValues();

                // Add a charge to the quote
                List<zqu__ProductRatePlan__c> prpList = [
                        SELECT
                                Name
                        FROM
                                zqu__ProductRatePlan__c
                        WHERE
                                zqu__ZProduct__c = :product.Id
                ];

                ctl.toBeAddedChargeGroup = zqu.ZQuoteUtil.getChargeGroup(quote.Id, prpList[0].Id);

                // Charge group added to the quote
                zqu.ZChargeGroup addedChargeGroup = zqu.ZQuoteUtil.addChargeGroup(ctl.toBeAddedChargeGroup);

                ctl.selectedChargeGroup = addedChargeGroup.groupId;

                // On load
                ctl.onLoad();

                // Cancel an amendment
                ctl.quoteAmendmentToUndo = quoteAmendment.Id;
                ctl.undoAmendment();

                ctl.deleteGroup();
                ctl.unDeleteGroup();
                ctl.editGroup();
                ctl.cancelEditGroup();
                ctl.saveGroup();

                // Changes in the charge group
                ctl.onDiscountChange();
                ctl.onQuantityChange();
                ctl.onEffectivePriceChange();
                ctl.onTotalChange();
                
                //delete a charge group
                List<zqu.zChargeGroup>  listOfChargesToDelete = new List<zqu.zChargeGroup>();
                listOfChargesToDelete.add(addedChargeGroup);
                ctl.chargeGroupList = listOfChargesToDelete;
                
                ctl.deleteChargeGroups(listOfChargesToDelete);
                ctl.removeChargeGroup(addedChargeGroup);
                 

                Test.stopTest();
        }
}