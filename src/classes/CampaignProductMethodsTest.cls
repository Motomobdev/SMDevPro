@isTest
public class CampaignProductMethodsTest {

    static testMethod void testUpdateProject() {
        Account ac1 = new Account(name = 'CampaignProductMethodsTest');
        insert ac1;
        
        Campaign cmpg = new Campaign(name = 'CampaignProductMethodsTest');
        insert cmpg;
        
        PMD_Program__c program = new PMD_Program__c(name = 'Test Program');
        insert program;

        PMD_Project__c project = new PMD_Project__c(name = 'Test Project', Program_ID__c = program.id);
        insert project;
        
        PMD_Product__c product = new PMD_Product__c(name = 'Test Product', Project_ID__c = project.id);
        insert product;

        Product2 sfProduct = new Product2(name = 'Test Product', PMD_Product__c = product.id,
                                         business_unit__c = 'Mobile Device', isactive = true);
        insert sfProduct;

        Campaign_Product__c cp = new Campaign_Product__c(Product__c = sfProduct.id, 
                                Project_PMD__c = null, Campaign__c = cmpg.id);
        insert cp;
        
        Campaign_Product__c cp2 = [select id , Project_PMD__c from Campaign_Product__c
                                  where id = :cp.id];
    	System.assertNotEquals(cp2.Project_PMD__c, null);
    }
}