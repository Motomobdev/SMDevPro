/**************************************************************
Created By: Neel Desai
Created On: 26-Jun-2013
Purpose   : To get UserInfo from AJAX Toolkit by invoking Apex
Test Class: UtilUserInfoTest
***************************************************************/
global without sharing class UtilUserInfo 
{
    webService static String getContextUserName()
    {
        return UserInfo.getUserName();
    }
    
    webService static String getContextUserId()
    {
        return UserInfo.getUserId();
    }

    webService static String getContextProfileId()
    {
        return UserInfo.getProfileId();
    }

    webService static String getContextProfileName()
    {
        Profile p = [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()];
        
        return p.Name;
    }
    
    webService static String isContextUserPartOfPublicGroup(String publicGroupName)
    {
    	List<Group> gList = [SELECT Id FROM Group WHERE Name = :publicGroupName AND Type = 'Regular'];
    	
    	if(gList == null || gList.isEmpty())
            return 'false';
	    
    	List<GroupMember> gmList = [SELECT Id FROM GroupMember WHERE GroupId = :gList.get(0).Id AND UserOrGroupId = :UserInfo.getUserId()];
    	
    	if(gmList == null || gmList.size() == 0)
        	return 'false';
    	else
    	    return 'true';
    }
    
    webService static String isContextUserPartOfPermissionSet(String permissionSetName) 
    {
        List<PermissionSet> permSets = [SELECT Id FROM PermissionSet WHERE Label = :permissionSetName];
        
        if(permSets == null || permSets.isEmpty())
            return 'false';
        
        List<PermissionSetAssignment> permSetAsgmts = [SELECT Id FROM PermissionSetAssignment WHERE AssigneeId = :UserInfo.getUserId() AND PermissionSetId = :permSets[0].Id];
        
        if(permSetAsgmts == null || permSetAsgmts.isEmpty())
            return 'false';
        else
            return 'true';
    }
}