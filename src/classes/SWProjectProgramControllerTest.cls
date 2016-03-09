@isTest
public class SWProjectProgramControllerTest{

    public static testMethod void testConstructor(){
        PMD_Program__c testProgram = new PMD_Program__c(Name='Test Program');
        insert testProgram;
        
        JIRA_Project__c testSWProject = new JIRA_Project__c(Name='Test Project',Type__c='Experiences');
        insert testSWProject;
        
        SWProjectProgramController swController;
        Program_SW_ProjectController prgController;
        
        Test.startTest();
            ApexPages.StandardController stdController = new ApexPages.StandardController(testProgram);
            swController = new SWProjectProgramController(stdController);
            
            prgController = new Program_SW_ProjectController(
                    new ApexPages.StandardController(testSWProject));
        Test.stopTest();
        
    }
    
    public static testMethod void testinsertNewSWProjectProgramRecords(){
        PMD_Program__c testProgram = new PMD_Program__c(Name='Test Program');
        insert testProgram;
        
        JIRA_Project__c testSWProject = new JIRA_Project__c(Name='Test Project',Type__c='Experiences');
        insert testSWProject;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(testProgram);
        SWProjectProgramController  swController = new SWProjectProgramController(stdController);
        Program_SW_ProjectController prgController = new Program_SW_ProjectController(
                    new ApexPages.StandardController(testSWProject));
 
        for (SWProjectProgramController.SWProjectProgramWrapper wrap: swController.newProgramSWProjects) 
            wrap.include = true;
        
        for (Program_SW_ProjectController.SWProjectProgramWrapper wrap: prgController.newProgramSWProjects) 
            wrap.include = true;
                    
        Test.startTest();
            swController.insertNewSWProjectProgramRecords();
            prgController.insertNewSWProjectProgramRecords();
        Test.stopTest();
    }
    
}