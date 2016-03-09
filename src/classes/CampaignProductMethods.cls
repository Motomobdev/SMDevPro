public class CampaignProductMethods {

    /*
     * Created by: Rajesh Krishnaiah
     * Creation date: 17-Sep-2013
     * Test Class: CampaignProductMethodsTest
     * Description: Utility class for Campaign Product object related methods
     * Change history:
     * Changed on:
     * Changed by:
     * Description:
     */

    /*
     * A campaign product (CMPG_P) record can be for a project or a product.
     * The product has a relation to PMD project. This code copies the PMD Project
     * value from the selected product to the project field. This code must be 
     * executed from the "before update/insert" context.
     */
    public static void UpdateProject(List<Campaign_Product__c> newList, List<Campaign_Product__c> oldList) {

        Set<Id> productIds = new Set<Id>();
        List<Integer> recordNumbers = new List<Integer>();
        
        for (Integer i = 0; i < newList.size(); ++i) {
            Campaign_Product__c cp = newList[i];

            if (cp.product__c != null) {
                productIds.add(cp.product__c);
                recordNumbers.add(i);
            }
        }

        Map<Id, Product2> productMap = 
                new Map<Id, Product2>([select id, PMD_Product__r.Project_ID__c
                    from Product2 where id in :productIds]);
    
        for (Integer i : recordNumbers) {
            
            Campaign_Product__c cp = newList[i];
            Product2 p = productMap.get(cp.product__c);

            system.debug('i: ' + i + ', ' + cp.product__c + ', ' + p.PMD_Product__r.Project_ID__c);
            if (p != null)
                cp.Project_PMD__c = p.PMD_Product__r.Project_ID__c;
        }
    }
}