@isTest
public class SWProjectTest{
	
    public static testMethod void testaddRecords(){
    	
        JIRA_Project__c testProject = new JIRA_Project__c(Name='test project');
        
        List< JIRA_Project__c> testlist = new List< JIRA_Project__c>();
        testlist.add(testProject);
        
        Test.startTest();
        	SWProject.addRecords(JSON.serialize(testlist));
        Test.stopTest();
    }
    
    public static testMethod void testUpdateRecords(){
    	
        JIRA_Project__c testProject = new JIRA_Project__c(Name='test project');
        insert testProject;
        
        List< JIRA_Project__c> testlist = new List< JIRA_Project__c>();
        testlist.add(testProject);
        
        
        Test.startTest();
        	SWProject.updateRecords(JSON.serialize(testlist));
        Test.stopTest();
    }
}