@isTest
public class SWProjectMotoCoreTest{
	
    public static testMethod void testaddRecords(){
    	Motorola_Core_Directory__c testMoto = new Motorola_Core_Directory__c(Name='Gram Bischof');
        insert testMoto;
        JIRA_Project__c testProject = new JIRA_Project__c(Name='test project');
        insert testProject;
        
        List< SW_Project_Moto_Core_Directory__c> testlist = new List< SW_Project_Moto_Core_Directory__c>();
        testlist.add(new SW_Project_Moto_Core_Directory__c(Motorola_Core_Directory__c=testMoto.id,SW_Project__c=testProject.Id,time_dedicated__c=1,Role__c='Developer'));
        
        Test.startTest();
        	SWProjectMotoCore.addRecords(JSON.serialize(testlist));
        Test.stopTest();
    }
    
    public static testMethod void testUpdateRecords(){
    	Motorola_Core_Directory__c testMoto = new Motorola_Core_Directory__c(Name='Gram Bischof');
        insert testMoto;
        JIRA_Project__c testProject = new JIRA_Project__c(Name='test project');
        insert testProject;
        
        List< SW_Project_Moto_Core_Directory__c> testlist = new List< SW_Project_Moto_Core_Directory__c>();
        testlist.add(new SW_Project_Moto_Core_Directory__c(Motorola_Core_Directory__c=testMoto.id,SW_Project__c=testProject.Id,time_dedicated__c=1,Role__c='Developer'));
        insert testlist;
        
        
        Test.startTest();
        	SWProjectMotoCore.updateRecords(JSON.serialize(testlist));
        Test.stopTest();
    }
}