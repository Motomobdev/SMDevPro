@isTest
private class GoogleTASubmissionRankingControllerTest
{
    @isTest static void test_GoogleTASubmissionRanking()
    {
        Profile p;
        User u;
        
        List<Device__c> devices = new List<Device__c>();
        //new submission - without priority value set 
        devices.add(new Device__c(Name='Device 1', 
                                  GMS_Submission_Status__c='Sent to Google', 
                                  CTS_Submission_Status__c='Sent to Google', 
                                  Google_TA_Approval_Status__c='In Progress'));
        //existing submission - with priority value set
        devices.add(new Device__c(Name='Device 2', 
                                  LE_CTS_Submission_Status__c='Sent to Google',
                                  Google_TA_Approval_Status__c='In Progress', 
                                  Priority__c=2));
        
        insert devices;
        
        Test.startTest();
        
        //admin user
        p = [SELECT Id FROM Profile WHERE Name='MotoDev - Google TA Process Admin'];
        if(p != null)
        {
            u = [SELECT Id FROM User WHERE ProfileId=:p.Id AND IsActive=true LIMIT 1];
            if(u != null)
            {
                System.runAs(u)
                {               
                    Pagereference mypage = Page.GoogleTASubmissionRanking;
                    Test.setCurrentPage(mypage);
                    
                    GoogleTASubmissionRankingController controller = new GoogleTASubmissionRankingController();
                    
                    //verify admin access
                    System.assertEquals(controller.isAdministrator, true);
            
                    //check if both records are fetched by the query
                    System.assertEquals(controller.TASubmissionList.size(), 2);
            
                    //verify the display order. make sure newly submitted device are at the end of list.
                    System.assertEquals(controller.TASubmissionList.get(0).Name, 'Device 2');
                    System.assertEquals(controller.TASubmissionList.get(1).Name, 'Device 1');
            
                    //simulate jQuery functionality - swap order of item 1 & 2
                    controller.sequence = controller.TASubmissionList.get(1).Id + ',' + controller.TASubmissionList.get(0).Id;
                    
                    //simulate save functionality
                    controller.saveSequence();
                    
                    //verify that reordered items are stored correctly
                    System.assertEquals(controller.TASubmissionList.get(0).Name, 'Device 1');
                    System.assertEquals(controller.TASubmissionList.get(1).Name, 'Device 2');
                }
            }
        }
        //non-admin user
        p = [SELECT Id FROM Profile WHERE Name='MotoDev - Google TA Process'];
        if(p != null)
        {
            u = [SELECT Id FROM User WHERE ProfileId=:p.Id AND IsActive=true LIMIT 1];
            if(u != null)
            {
                System.runAs(u)
                {
                    GoogleTASubmissionRankingController controller = new GoogleTASubmissionRankingController();
                    
                    //verify no admin access
                    System.assertEquals(controller.isAdministrator, false);
                }
            }
        }

        //Anonymous user
        p = [SELECT Id FROM Profile WHERE Name='Google TA Submission Ranking Profile'];
        if(p != null)
        {
            u = [SELECT Id FROM User WHERE ProfileId=:p.Id AND IsActive=true LIMIT 1];
            if(u != null)
            {
                System.runAs(u)
                {               
                    Pagereference mypage = Page.GoogleTASubmissionRanking;
                    Test.setCurrentPage(mypage);
                    
                    GoogleTASubmissionRankingController controller = new GoogleTASubmissionRankingController();
                    
                    //verify anonymous access
                    System.assertEquals(controller.isAnonymous, true);
                }
            }
        }
        
        Test.stopTest();
    }
}