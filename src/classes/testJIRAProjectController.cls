@isTest
public class testJIRAProjectController{

    public static testMethod void testAllDatesBeingEqual(){
    	List<Device__c> devices = new List<Device__c>();
        for(Integer count = 0; count < 10; count++){
        	devices.add(new Device__c(Name='Test Device' + count,LE__c=Date.today(),SA_Date__c=DAte.today(),TA_Date__c=Date.today()));
        }
        insert devices;
        
        JIRA_Project__c testProject = new JIRA_Project__c(Name__c='Test Project');
        insert testProject;
        
        List<Device_JIRA_Project__c> djps = new List<Device_JIRA_Project__c>();
        for( Device__c device: devices) djps.add(new Device_JIRA_Project__c(JIRA_Project__c=testProject.id,Device__c=device.id));
        insert djps;
        
        Test.startTest();
        	List<JIRA_Project__c> projects = new List<JIRA_Project__c>();
        	projects.add(testProject);
        	JIRAProjectcontroller.getDeviceDates(projects);
        Test.stopTest();
        
        
        testProject = [Select id, LE_Date__c, SA_Date__c, TA_Date__c,Oldest_LE_Date__c, Oldest_SA_Date__c, Oldest_TA_Date__c from JIRa_Project__c Where id =:testProject.id];
        System.assertEquals(Date.today(), testProject.LE_Date__c);
        System.assertEquals(Date.today(), testProject.SA_Date__c);
        System.assertEquals(Date.today(), testProject.TA_Date__c);
        System.assertEquals(Date.today(), testProject.Oldest_LE_Date__c);
        System.assertEquals(Date.today(), testProject.Oldest_SA_Date__c);
        System.assertEquals(Date.today(), testProject.Oldest_TA_Date__c);
    }
    
    public static testMethod void testAllDatesNotBeingEqual(){
    	List<Device__c> devices = new List<Device__c>();
        for(Integer count = 0; count < 10; count++){
        	devices.add(new Device__c(Name='Test Device' + count,LE__c=Date.today().addDays(count),SA_Date__c=DAte.today().addDays(-count),TA_Date__c=Date.today().addDays(count)));
        }
        insert devices;
        
        JIRA_Project__c testProject = new JIRA_Project__c(Name__c='Test Project');
        insert testProject;
        
        List<Device_JIRA_Project__c> djps = new List<Device_JIRA_Project__c>();
        for( Device__c device: devices) djps.add(new Device_JIRA_Project__c(JIRA_Project__c=testProject.id,Device__c=device.id));
        insert djps;
        
        Test.startTest();
        	List<JIRA_Project__c> projects = new List<JIRA_Project__c>();
        	projects.add(testProject);
        	JIRAProjectcontroller.getDeviceDates(projects);
        Test.stopTest();
        
        
        testProject = [Select id, LE_Date__c, SA_Date__c, TA_Date__c,Oldest_LE_Date__c, Oldest_SA_Date__c, Oldest_TA_Date__c from JIRa_Project__c Where id =:testProject.id];
        System.assertEquals(Date.today(), testProject.LE_Date__c);
        System.assertEquals(Date.today().addDays(-9), testProject.SA_Date__c);
        System.assertEquals(Date.today(), testProject.TA_Date__c);
    }
    
    public static testMethod void testAllDatesNotBeingEqualFromTrigger(){
    	List<Device__c> devices = new List<Device__c>();
        for(Integer count = 0; count < 10; count++){
        	devices.add(new Device__c(Name='Test Device' + count,LE__c=Date.today().addDays(count),SA_Date__c=DAte.today().addDays(-count),TA_Date__c=Date.today().addDays(count)));
        }
        insert devices;
        
        JIRA_Project__c testProject = new JIRA_Project__c(Name__c='Test Project');
        insert testProject;
        
        List<Device_JIRA_Project__c> djps = new List<Device_JIRA_Project__c>();
        for( Device__c device: devices) djps.add(new Device_JIRA_Project__c(JIRA_Project__c=testProject.id,Device__c=device.id));
 
        Test.startTest();
        	insert djps;
        Test.stopTest();
        
        
        testProject = [Select id, LE_Date__c, SA_Date__c, TA_Date__c,Oldest_LE_Date__c, Oldest_SA_Date__c, Oldest_TA_Date__c from JIRa_Project__c Where id =:testProject.id];
        System.assertEquals(Date.today(), testProject.LE_Date__c);
        System.assertEquals(Date.today().addDays(-9), testProject.SA_Date__c);
        System.assertEquals(Date.today(), testProject.TA_Date__c);
        System.assertEquals(Date.today().addDays(9), testProject.Oldest_LE_Date__c);
        System.assertEquals(Date.today(), testProject.Oldest_SA_Date__c);
        System.assertEquals(Date.today().addDays(9), testProject.Oldest_TA_Date__c);
    }
    
}