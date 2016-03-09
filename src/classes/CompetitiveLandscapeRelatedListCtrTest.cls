@isTest
private class CompetitiveLandscapeRelatedListCtrTest 
{
    static testMethod void myUnitTest() 
    {
        List<GroupMember> members = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId IN (SELECT Id FROM Group WHERE Name = 'CL Comparison Creators' AND Type = 'Regular')];
        
        List<Id> regionalSideBySideUserIds = new List<Id>();
        
        for(GroupMember member : members)
        {
            regionalSideBySideUserIds.add(member.UserOrGroupId);
        }
        
    	List<User> users = [SELECT Id FROM User WHERE Id IN :regionalSideBySideUserIds];

        Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User admin = [SELECT Id FROM User WHERE ProfileId = :prof.Id AND IsActive = true LIMIT 1];
    	
    	////
    	
        if(users != null && !users.isEmpty())
        {
            System.runAs(users[0])
            {
                List<Competitive_Product_Comp_Set__c> compSets = new List<Competitive_Product_Comp_Set__c>();
                compSets.add(new Competitive_Product_Comp_Set__c(Name = 'xyz North America xyz',
                                                                 Competitor_Products__c = 'SONY Xperia Z',
                                                                 Motorola_Product__c = 'MOTOROLA Moto X'));
                compSets.add(new Competitive_Product_Comp_Set__c(Name = 'xyz South West Asia xyz',
                                                                 Competitor_Products__c = 'SAMSUNG Galaxy Y',
                                                                 Motorola_Product__c = 'MOTOROLA Moto G'));
                insert compSets;
            }
        }
                
        ////
        
        System.runAs(admin)
        {
        	List<Account> accounts = new List<Account>();
            accounts.add(new Account(Name = 'Test acc 2',
                                    Region__c = 'APAC',
                                    Sub_Region__c = 'South West Asia'));
            accounts.add(new Account(Name = 'Test acc 1',
                                    Region__c = 'North America',
                                    Sub_Region__c = 'North America'));
        	insert accounts;
        	
        	////
        	
            String motoRecordTypeId = Schema.SObjectType.Competitive_Product__c.getRecordTypeInfosByName().get('Motorola Product').getRecordTypeId();
            String compRecordTypeId = Schema.SObjectType.Competitive_Product__c.getRecordTypeInfosByName().get('Competitor Product').getRecordTypeId();
                    
            List<Competitive_Product__c> compProds = new List<Competitive_Product__c>();
            compProds.add(new Competitive_Product__c(RecordTypeId = motoRecordTypeId,
                                                  Brand__c = 'MOTOROLA',
                                                  Product__c = 'Moto G',
                                                  Entry_Period__c = 'Q1 2015'));
            compProds.add(new Competitive_Product__c(RecordTypeId = motoRecordTypeId,
                                                  Brand__c = 'MOTOROLA',
                                                  Product__c = 'Moto X',
                                                  Entry_Period__c = 'Q1 2015'));
            compProds.add(new Competitive_Product__c(RecordTypeId = compRecordTypeId,
                                                  Brand__c = 'SAMSUNG', 
                                                  Product__c = 'Galaxy Y',
                                                  Entry_Period__c = 'Q1 2015'));
            compProds.add(new Competitive_Product__c(RecordTypeId = compRecordTypeId,
                                                  Brand__c = 'SONY', 
                                                  Product__c = 'Xperia Z',
                                                  Entry_Period__c = 'Q1 2015'));
            insert compProds;
            
            ////
                    
            List<PMD_Program__c> pmdPrograms = new List<PMD_Program__c>();
            pmdPrograms.add(new PMD_Program__c(Name = 'Moto G Program'));
            pmdPrograms.add(new PMD_Program__c(Name = 'Moto X Program'));
            insert pmdPrograms;
            
            List<PMD_Project__c> pmdProjects = new List<PMD_Project__c>();
            pmdProjects.add(new PMD_Project__c(Name = 'Moto G Project', Program_ID__c = pmdPrograms[0].Id));
            pmdProjects.add(new PMD_Project__c(Name = 'Moto X Project', Program_ID__c = pmdPrograms[1].Id));
            insert pmdProjects;
            
            List<PMD_Product__c> pmdProducts = new List<PMD_Product__c>();
            pmdProducts.add(new PMD_Product__c(Name = 'Moto G', Project_ID__c = pmdProjects[0].Id));
            pmdProducts.add(new PMD_Product__c(Name = 'Moto X', Project_ID__c = pmdProjects[1].Id, Price_Tier_Target__c = '$301-$400'));
            insert pmdProducts;
            
            List<Product2> p2Products = new List<Product2>();
            p2Products.add(new Product2(Name = 'Moto G', PMD_Product__c = pmdProducts[0].Id, Business_Unit__c = 'Mobile Devices', IsActive = true));
            p2Products.add(new Product2(Name = 'Moto X', PMD_Product__c = pmdProducts[1].Id, Business_Unit__c = 'Mobile Devices', IsActive = true));
            insert p2Products;
            
            ////
            
        	List<Competitive_Landscape__c> landscapes = new List<Competitive_Landscape__c>();
        	
            landscapes.add(new Competitive_Landscape__c(Account__c = accounts[0].Id,
                                                    Competitor_Product__c = compProds[2].Id,
                                                    Device_Rank__c = 2,
                                                    Motorola_Product__c = p2Products[0].Id));
            landscapes.add(new Competitive_Landscape__c(Account__c = accounts[0].Id,
                                                    Competitor_Product__c = compProds[3].Id,
                                                    Device_Rank__c = 3,
                                                    Motorola_Product__c = p2Products[0].Id));
            landscapes.add(new Competitive_Landscape__c(Account__c = accounts[1].Id,
                                                    Competitor_Product__c = compProds[3].Id,
                                                    Device_Rank__c = 3,
                                                    Motorola_Product__c = p2Products[1].Id));
        	insert landscapes;
        	
        	////
        	
        	List<Weekly_Report_Item__c> weeklies = new List<Weekly_Report_Item__c>();
        	
        	weeklies.add(new Weekly_Report_Item__c(Account__c = accounts[0].Id,
        	                                      Category__c = 'Market Intelligence',
        	                                      Competitive_Landscape__c = landscapes[0].Id,
        	                                      Function__c = 'GTM',
        	                                      Include_in_Report__c = true,
        	                                      Status__c = 'Assigned',
        	                                      Sub_Category__c = 'Advertising & Promotions',
        	                                      Summary__c = 'Test item 1'));  
            weeklies.add(new Weekly_Report_Item__c(Account__c = accounts[1].Id,
                                                  Category__c = 'Market Intelligence',
                                                  Function__c = 'GTM',
                                                  Include_in_Report__c = true,
                                                  Status__c = 'Assigned',
                                                  Sub_Category__c = 'General',
                                                  Summary__c = 'Test item 2'));  
        	insert weeklies;
        	
        	////
            
            Test.startTest();
            
            PageReference pageRef1 = Page.CompetitiveLandscapeRelatedList;
            Test.setCurrentPage(pageRef1);
            
            CompetitiveLandscapeRelatedListCtr ctr1 = new CompetitiveLandscapeRelatedListCtr(null); // Id paramenter missing
            
            ////
            
            PageReference pageRef2 = Page.CompetitiveLandscapeRelatedList;
            pageRef2.getParameters().put('Id', accounts[0].Id);
            Test.setCurrentPage(pageRef2);
            
            CompetitiveLandscapeRelatedListCtr ctr2 = new CompetitiveLandscapeRelatedListCtr(new ApexPages.StandardController(accounts[0])); // with Id parameter
            
            ctr2.fetchClData();
            Boolean isClEmpty2 = ctr2.getIsClEmpty();
            System.assertEquals(isClEmpty2, false);
            
            ////
            
            PageReference pageRef3 = Page.CompetitiveLandscapeRelatedList;
            pageRef3.getParameters().put('Id', accounts[1].Id);
            pageRef3.getParameters().put('showtitle', 'true');
            Test.setCurrentPage(pageRef3);
            
            CompetitiveLandscapeRelatedListCtr ctr3 = new CompetitiveLandscapeRelatedListCtr(new ApexPages.StandardController(accounts[1])); // with Id & showtitle parameters
            
            ctr3.fetchClData();
            Boolean isClEmpty3 = ctr3.getIsClEmpty();
            System.assertEquals(isClEmpty3, false);
            
            ctr3.fetchMiData();
            Boolean isMiEmpty3 = ctr3.getIsMiEmpty();
            System.assertEquals(isMiEmpty3, false);
            
            ctr3.toggleViewMode();
            
            Test.stopTest();
        }
    }
}