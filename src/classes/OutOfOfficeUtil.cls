global class OutOfOfficeUtil implements Database.Batchable<sObject>,Database.Stateful{
/*
Author: Bineet Mishra
Created Date: Nov 7, 2012
Description: Utility class for Out-of-Office delegated approver check. This class is used by the ScheduleOutOfOfficeUtil class to schedule an hourly run.
The logic here checks if any user has active record in Out_Of_office__c objects and if that user is currently out-of-office based on it's End_Time__c field value.
If it find any such record it updates the DelegatedApprover field of User object to refelect the current status of the  user.

Case 1: 
Condition(Out_Of_Office:End Time > Current Time & Delegated Approver NOT null)
Action: User:DelegatedApprover =  Out_Of_Office:DelegatedApprover

Case 2:
Condition(Out_Of_Office:End Time > Current Time & Delegated Approver IS null)
Action: User:DelegatedApprover =  AS IS

Case 3:
Condition(Out_Of_Office:End Time < Current Time & Delegated Approver NOT null)
Action: User:DelegatedApprover =  null

Case 4:
Condition(Out_Of_Office:End Time < Current Time & Delegated Approver IS null)
Action: User:DelegatedApprover =  null
*/
    public String query = 'SELECT User__c, Start_Time__c, End_Time__c, Delegated_Approver__c  FROM Out_Of_Office__c WHERE Delegated_Approver__c != null';
    public Map<Id, Id> outOfOfficeUsersMap = new Map<Id, Id>();
    public Set<Id> inOfficeUsersSet = new Set<Id>();
     
    global Database.QueryLocator start(Database.BatchableContext bc){     
         return  Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> scope) {    
        for(SObject s : scope) {   
            Out_Of_Office__c outOfOffice = (Out_Of_Office__c)s;       
            if(outOfOffice.Start_Time__c < datetime.now() && outOfOffice.End_Time__c > datetime.now())
                outOfOfficeUsersMap.put(outOfOffice.User__c, outOfOffice.Delegated_Approver__c);
            else
                inOfficeUsersSet.add(outOfOffice.User__c);      
        }
        setDelegatedApprover(outOfOfficeUsersMap);
        removeDelegatedApprover(inOfficeUsersSet);      
    }
    
    global void finish(Database.BatchableContext info) {
        
    }
 
 
    private void setDelegatedApprover(Map<Id, Id> outOfOfficeUsersMap){
        List<User> outOfOfficeUserList = new List<User>(); 
        List<User> outOfOfficeUpdatedUserList = new List<User>();
       
        outOfOfficeUserList = [SELECT Id, DelegatedApproverId, IsActive FROM User WHERE Id IN :outOfOfficeUsersMap.keyset() AND IsActive = true];
        for(User oooUser : outOfOfficeUserList){
        	if(outOfOfficeUsersMap.get(oooUser.Id) != null){
            	oooUser.DelegatedApproverId = outOfOfficeUsersMap.get(oooUser.Id);
            	outOfOfficeUpdatedUserList.add(oooUser);
        	}
        }
        
        update outOfOfficeUpdatedUserList;
   }
   
   private void removeDelegatedApprover(Set<Id> inOfficeUsersMap){       
        List<User> inOfficeUserList = new List<User>(); 
        List<User> inOfficeUpdatedUserList = new List<User>();
        
        inOfficeUserList = [SELECT Id, DelegatedApproverId, IsActive FROM User WHERE Id IN :inOfficeUsersSet AND IsActive = true];
        for(User inOfficeUser : inOfficeUserList){
            inOfficeUser.DelegatedApproverId = null;
            inOfficeUpdatedUserList.add(inOfficeUser);
        }
        
        update inOfficeUpdatedUserList;
   }
   
   static testmethod void TestOutOfOfficeUtil() { 
   	  User newUser = [SELECT Id, Email FROM User WHERE Alias='bMishra' LIMIT 1];
   	  	
   	  Out_Of_Office__c newOOO = new Out_Of_Office__c();
   	  newOOO.User__c = newUser.Id;
   	  newOOO.Start_Time__c = DateTime.parse('11/01/2012 11:46 AM');  
   	  newOOO.End_Time__c = DateTime.parse('11/11/2012 11:46 AM');  
   	  newOOO.Active__c = true;
   	  insert newOOO;
   	    
	  test.startTest();
	    
	  OutOfOfficeUtil oooUtil = new OutOfOfficeUtil();	  
	  integer batchSize = 10;
	  database.executebatch(oooUtil, batchSize);   
	     
	  test.stopTest();   
 	}
  
}