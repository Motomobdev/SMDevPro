/*   Copyright (c) 2013 Zuora, Inc.
 *
 *   Permission is hereby granted, free of charge, to any person obtaining a copy of 
 *   this software and associated documentation files (the "Software"), to use copy, 
 *   modify, merge, publish the Software and to distribute, and sublicense copies of 
 *   the Software, provided no fee is charged for the Software.  In addition the
 *   rights specified above are conditioned upon the following:
 *
 *   The above copyright notice and this permission notice shall be included in all
 *   copies or substantial portions of the Software.
 *
 *   Zuora, Inc. or any other trademarks of Zuora, Inc.  may not be used to endorse
 *   or promote products derived from this Software without specific prior written
 *   permission from Zuora, Inc.
 *
 *   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *   FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
 *   ZUORA, INC. BE LIABLE FOR ANY DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES
 *   (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 *   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 *   ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 *   (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *   SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.  
 *
 *
 *   IN THE EVENT YOU ARE AN EXISTING ZUORA CUSTOMER, USE OF THIS SOFTWARE IS GOVERNED
 *   BY THIS AGREEMENT AND NOT YOUR MASTER SUBSCRIPTION AGREEMENT WITH ZUORA.
 */
 
@isTest
private class Z_ExistingCharges_TEST {

        static testMethod void testComponent() {
                
                // Make some test data
                zqu__Quote__c testQuote = makeQuote();
                zqu__ZProduct__c testProduct = Z_TestDataSetup.prepareProductCatalog();
                Application__c testApp = Z_TestFactory.makeApplication(); 
                
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
                
                Z_ExistingCharges ctl = new Z_ExistingCharges();
                ctl.quoteIDname = testQuote.Id;

                String name = ctl.fromName;
                List<zqu.ZChargeGroup> chargeGroupList = ctl.chargeGroupList;
                
                ctl.toEditGroupID = chargeGroup.groupId;
                ctl.editProduct();
                
                ctl.getApplications();
                ctl.getPrepaid();
                
                ctl.chosenApplication = testApp.Id;
                ctl.setApplicationValues();
                
                ctl.quntityChange();
                ctl.discountchange();
                ctl.effectiveChange();
                ctl.totalChange();
                
                ctl.saveProduct();
                ctl.cancelEditing();
                
                ctl.toDeleteGroupID = chargeGroup.groupId;
                ctl.deleteProduct();
                
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