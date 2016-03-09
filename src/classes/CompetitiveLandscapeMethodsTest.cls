@isTest
private class CompetitiveLandscapeMethodsTest 
{
    static testMethod void myUnitTest() 
    {
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User usr = [SELECT Id FROM User WHERE ProfileId = :prof.Id AND IsActive = true LIMIT 1];
        
        System.runAs(usr)
        {
            Account acc = new Account(Name = 'Test account');
            insert acc;
            
            ////
            
            String motoRecordTypeId = Schema.SObjectType.Competitive_Product__c.getRecordTypeInfosByName().get('Motorola Product').getRecordTypeId();
            String compRecordTypeId = Schema.SObjectType.Competitive_Product__c.getRecordTypeInfosByName().get('Competitor Product').getRecordTypeId();
            
            List<Competitive_Product__c> compProds = new List<Competitive_Product__c>();
            
            compProds.add(new Competitive_Product__c(RecordTypeId = motoRecordTypeId,
                                                  Brand__c = 'MOTOROLA',
                                                  Product__c = 'Moto X',
                                                  Entry_Period__c = 'Q1 2015'));
            compProds.add(new Competitive_Product__c(RecordTypeId = compRecordTypeId,
                                                  Brand__c = 'SAMSUNG', 
                                                  Product__c = 'Galaxy Y',
                                                  Entry_Period__c = 'Q1 2015'));
            insert compProds;
            
            PMD_Program__c pmdProgram = new PMD_Program__c(Name = 'Moto X Program');
            insert pmdProgram;
            
            PMD_Project__c pmdProject = new PMD_Project__c(Name = 'Moto X Project', Program_ID__c = pmdProgram.Id);
            insert pmdProject;
            
            PMD_Product__c pmdProduct = new PMD_Product__c(Name = 'Moto X', Project_ID__c = pmdProject.Id, Price_Tier_Target__c = '$301-$400');
            insert pmdProduct;
            
            Product2 prod2 = new Product2(Name = 'Moto X', PMD_Product__c = pmdProduct.Id, Business_Unit__c = 'Mobile Devices', IsActive = true);
            insert prod2;
            
            ////
            
            Competitive_Landscape__c cl = new Competitive_Landscape__c(Account__c = acc.Id,
                                                                       Competitor_Product__c = compProds[1].Id,
                                                                       Device_Rank__c = 2,
                                                                       Latest_Updates__c = 'Update 1',
                                                                       Motorola_Product__c = prod2.Id);
            insert cl;
            
            
            
            Test.startTest();
            
            
            /* Test beforeUpdate - History field testing */
            cl.Latest_Updates__c = 'Update 2';
            update cl; // trigger should update History__c field
            
            cl = [SELECT Latest_Updates__c, History__c 
                  FROM   Competitive_Landscape__c 
                  WHERE  Id = :cl.Id];
            system.assertEquals(cl.Latest_Updates__c, 'Update 2');
            system.assertEquals(cl.History__c.contains('Update 1'), true); //history field should have been updated by trigger
            
            Test.stopTest();
        }
    }
}