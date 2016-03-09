public without sharing class AccountTeamPermissionReportCtr 
{
	public class AccountTeamPermission
	{
		public String UserId {get; set;}
        public String FirstName {get; set;}
        public String LastName {get; set;}
        public String RoleName {get; set;}
        public String AccountId {get; set;}
        public String AccountName {get; set;}
        public String TeamMemberRole {get; set;}
        public String AccountAccessLevel {get; set;}
        public String OpportunityAccessLevel {get; set;}
	}
	
    public Boolean isAdmin {get; set;}
	public List<AccountTeamPermission> atpList {get; set;}
	
    public AccountTeamPermissionReportCtr()
    {
        if(UtilUserInfo.isContextUserPartOfPermissionSet('Sales Ops Admin').equals('true') ||
           UtilUserInfo.isContextUserPartOfPublicGroup('GTM Sales Operations').equals('true') || 
           UtilUserInfo.getContextProfileName().equals('System Administrator'))
        {
            isAdmin = true;
            
        	atpList = new List<AccountTeamPermission>();
        	
            Map<Id, User> userMap = new Map<Id, User>([SELECT Id, FirstName, LastName, UserRoleId, UserRole.Name FROM User WHERE IsActive = true]);
            
        	Map<Id, UserRole> roleMap = new Map<Id, UserRole>([SELECT Id, Name FROM UserRole WHERE Name LIKE '%GTM%' AND (NOT Name LIKE '%Apttus%')]);
        	
            List<Id> userList = new List<Id>();

            for(User u : userMap.values())
            {
            	if(roleMap.containsKey(u.UserRoleId))
            	{
            		userList.add(u.Id);
            	}
            }
            
            String query = 'SELECT Id FROM Account WHERE Active__c = true' + (Test.isRunningTest() ? '' : ' AND OwnerId IN :userList');
            List<Account> accList = Database.query(query);
            
            AccountShare[] acsList = [SELECT UserOrGroupId, AccountId, AccountAccessLevel, OpportunityAccessLevel FROM AccountShare WHERE AccountId IN :accList AND IsDeleted = false];
            AccountTeamMember[] atmList = [SELECT UserId, AccountAccessLevel, AccountId, Account.Name, TeamMemberRole FROM AccountTeamMember WHERE AccountId IN :accList ORDER BY Account.Name, TeamMemberRole];

            Map<String, AccountShare> acsMap = new Map<String, AccountShare>();
             
            for(AccountShare acs : acsList)
            {
            	acsMap.put(acs.UserOrGroupId + '|' + acs.AccountId, acs);
            }
            
        	for(AccountTeamMember atm : atmList)
        	{
        		User u = userMap.get(atm.UserId);
                AccountShare acs = acsMap.get(atm.UserId + '|' + atm.AccountId);
                
                if(u != null) //meaning user is active now
                {
    	    		AccountTeamPermission atp = new AccountTeamPermission();
    	            
    	            atp.UserId = atm.UserId;
    	            atp.FirstName = u.FirstName;
    	            atp.LastName = u.LastName;
    	            atp.RoleName = u.UserRole.Name;
    	            atp.AccountId = atm.AccountId;
    	    		atp.AccountName = atm.Account.Name;
    	    		atp.TeamMemberRole = atm.TeamMemberRole;
    	    		atp.AccountAccessLevel = (atm.AccountAccessLevel.equals('Edit') ? 'Read/Write' : atm.AccountAccessLevel);
    	            atp.OpportunityAccessLevel = (acs == null ? 'None' : (acs.OpportunityAccessLevel.equals('Edit') ? 'Read/Write' : acs.OpportunityAccessLevel));
    	    		
    	    		atpList.add(atp);
                }
        	}
        }
        else
            isAdmin = false;
    }
}