@isTest
private class UtilUserInfoTest 
{
    static testMethod void myUnitTest() 
    {
    	Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
    	User u = [SELECT Id, UserName FROM User WHERE ProfileId = :p.Id AND IsActive = true LIMIT 1];
        PermissionSet[] ps = [SELECT Id, Name, Label FROM PermissionSet WHERE ProfileId = null AND UserLicenseId = null LIMIT 2];
        
        Group g1 = new Group(Name = 'Group 1', Type = 'Regular');
        insert g1;
        Group g2 = new Group(Name = 'Group 2', Type = 'Regular');
        insert g2;
        GroupMember gm = new GroupMember(GroupId = g1.Id, UserOrGroupId = u.Id);
        insert gm;
        
        PermissionSetAssignment psa = new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = ps[0].Id);
        insert psa;
        
    	Test.startTest();
    	
    	System.runAs(u)
    	{
            System.assertEquals(UtilUserInfo.getContextUserName(), u.UserName);
            System.assertEquals(UtilUserInfo.getContextUserId(), u.Id);
            System.assertEquals(UtilUserInfo.getContextProfileId(), p.Id);
            System.assertEquals(UtilUserInfo.getContextProfileName(), 'System Administrator');
            System.assertEquals(UtilUserInfo.isContextUserPartOfPublicGroup('-not available-'), 'false');
            System.assertEquals(UtilUserInfo.isContextUserPartOfPublicGroup('Group 2'), 'false');
            System.assertEquals(UtilUserInfo.isContextUserPartOfPublicGroup('Group 1'), 'true');
            System.assertEquals(UtilUserInfo.isContextUserPartOfPermissionSet(ps[0].Label), 'true');
            System.assertEquals(UtilUserInfo.isContextUserPartOfPermissionSet(ps[1].Label), 'false');
            System.assertEquals(UtilUserInfo.isContextUserPartOfPermissionSet('xyz'), 'false');
    	}
    	
    	Test.stopTest();
    }
}