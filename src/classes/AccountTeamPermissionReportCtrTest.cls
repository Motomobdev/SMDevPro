@isTest
private class AccountTeamPermissionReportCtrTest 
{
    static testMethod void myUnitTest() 
    {
        Profile prof = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User[] usrs = [SELECT Id FROM User WHERE ProfileId = :prof.Id AND IsActive = true LIMIT 2];
        
        System.runAs(usrs[0])
        {
            Account[] accList = new Account[0];
            accList.add(new Account(Name = 'Test account 1', Allow_Opportunities__c = true));
            accList.add(new Account(Name = 'Test account 2', Allow_Opportunities__c = true));
            insert accList;
            
            AccountShare[] acsList = new AccountShare[0];
            acsList.add(new AccountShare(UserOrGroupId = usrs[1].Id, AccountId = accList[0].Id, AccountAccessLevel = 'Edit', OpportunityAccessLevel = 'Edit'));
            acsList.add(new AccountShare(UserOrGroupId = usrs[1].Id, AccountId = accList[1].Id, AccountAccessLevel = 'Read', OpportunityAccessLevel = 'Read'));
            insert acsList;
            
            AccountTeamMember[] atmList = new AccountTeamMember[0];
            atmList.add(new AccountTeamMember(UserId = usrs[1].Id, AccountId = accList[0].Id, TeamMemberRole = 'Sales VP'));
            atmList.add(new AccountTeamMember(UserId = usrs[1].Id, AccountId = accList[1].Id, TeamMemberRole = 'Sales GM'));
            insert atmList;
            
            Test.startTest();
            
            PageReference pageRef = Page.AccountTeamPermissionReport;
            Test.setCurrentPage(pageRef);
            
            AccountTeamPermissionReportCtr controller = new AccountTeamPermissionReportCtr();
            
            Test.stopTest();
        }
    }
}