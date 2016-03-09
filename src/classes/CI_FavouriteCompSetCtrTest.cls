@isTest
private class CI_FavouriteCompSetCtrTest 
{

    static testMethod void myUnitTest() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User u1 = new User(Alias = 'u1', Email='user1@email.com', 
                           EmailEncodingKey='UTF-8', LastName='Dummy1', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='user1@motorola.com');
        User u2 = new User(Alias = 'u2', Email='user2@email.com', 
                           EmailEncodingKey='UTF-8', LastName='Dummy2', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, 
                           TimeZoneSidKey='America/Los_Angeles', UserName='user2@motorola.com');
        
        insert u1;
        insert u2;
        
        Competitive_Product_Comp_Set__c compSet = new Competitive_Product_Comp_Set__c(Name='Test', 
                                                                                      Motorola_Product__c='MOTO Prod 1',
                                                                                      Competitor_Products__c='SS Prod 2,HTC Prod 3',
                                                                                      User__c=u2.Id);
        insert compSet;
        
        Test.startTest();
        
        //PageReference pageRef = Page.SavedCompSet;
        //Test.setCurrentPage(pageRef);
        
        System.runAs(u1)
        {
            CI_FavouriteCompSetCtr con1 = new CI_FavouriteCompSetCtr(); 
            
            System.assertEquals(con1.isEmpty, false); //no records with user 1
        }
        
        System.runAs(u2)
        {
            
            CI_FavouriteCompSetCtr con2 = new CI_FavouriteCompSetCtr();

            System.assertEquals(con2.isEmpty, false); //one record with user 2

            con2.idToDelete = compSet.Id;
            con2.remove();
            
            System.assertEquals(con2.isEmpty, true); //verify that remove() is working
        }
        
        Test.stopTest();
    }
}