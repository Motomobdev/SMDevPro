@isTest
public class SWExperienceProgramControllerTest{

    public static testMethod void testConstructor(){
        PMD_Program__c testProgram = new PMD_Program__c
        (Name='Test Program',Program_Status__c='Shipping', Exclude_from_POR_Experiences_Chart__c=FALSE,POR_Grouping__c ='test');
        insert testProgram;
        
        JIRA_Project__c testSWProject = new JIRA_Project__c(Name='Test Project',Type__c='Experiences');
        insert testSWProject;
        
        SW_Experiences_and_Releases__c testSWExperience = 
        new SW_Experiences_and_Releases__c(Name='Test Experience',Status__c = 'Shipping' , POR_Status__c = 'Test',SW_Project__c=testSWProject.id);
        insert testSWExperience;
        
        SWExperienceProgramController swController;
        Program_SW_ExperienceController prgController;
        
        SWExperienceProgramController.SWExperienceProgramWrapper sw = new SWExperienceProgramController.SWExperienceProgramWrapper();
        sw.include=false;
        sw.Name=testSWExperience.Name;
        sw.newProgramSWExperience = 
                new Program_SW_Experience__c(SW_Experiences__c=testSWExperience.Id, Program_PMD__c=testProgram.Id);
       
        Program_SW_ExperienceController.SWExperienceProgramWrapper sw1 = new Program_SW_ExperienceController.SWExperienceProgramWrapper(); 
        sw1.include=false;
        sw1.Name=testSWExperience.Name;
        sw1.newProgramSWExperience = 
                new Program_SW_Experience__c(SW_Experiences__c=testSWExperience.Id, Program_PMD__c=testProgram.Id);       
         
        Test.startTest();
            ApexPages.StandardController stdController = new ApexPages.StandardController(testProgram);
            swController = new SWExperienceProgramController(stdController);           
            
            prgController = new Program_SW_ExperienceController(
                    new ApexPages.StandardController(testSWExperience));
        Test.stopTest();
        
    }
    
    public static testMethod void testinsertNewSWExperienceProgramRecords(){
        
        PMD_Program__c testProgram = new PMD_Program__c
        (Name='Test Program3',Program_Status__c='Active', Exclude_from_POR_Experiences_Chart__c=FALSE,POR_Grouping__c ='test');
        insert testProgram;
        
        JIRA_Project__c testSWProject = new JIRA_Project__c(Name='Test Project2',Type__c='Experiences');
        insert testSWProject;
        
        SW_Experiences_and_Releases__c testSWExperience = new SW_Experiences_and_Releases__c(Name='Test Experience2', SW_Project__c=testSWProject.id,Status__c = 'Active' , POR_Status__c = 'Test');
        insert testSWExperience;
        
        SWExperienceProgramController  swController = new SWExperienceProgramController(
                    new ApexPages.StandardController(testProgram));
        Program_SW_ExperienceController prgController = new Program_SW_ExperienceController(
                    new ApexPages.StandardController(testSWExperience));
                    
        SWExperienceProgramController.SWExperienceProgramWrapper sw = new SWExperienceProgramController.SWExperienceProgramWrapper();
        sw.include=false;
        sw.Name=testSWExperience.Name;
        sw.newProgramSWExperience = 
                new Program_SW_Experience__c(SW_Experiences__c=testSWExperience.Id, Program_PMD__c=testProgram.Id);
       
        Program_SW_ExperienceController.SWExperienceProgramWrapper sw1 = new Program_SW_ExperienceController.SWExperienceProgramWrapper(); 
        sw1.include=false;
        sw1.Name=testSWExperience.Name;
        sw1.newProgramSWExperience = 
                new Program_SW_Experience__c(SW_Experiences__c=testSWExperience.Id, Program_PMD__c=testProgram.Id);                  
                    
        for (SWExperienceProgramController.SWExperienceProgramWrapper wrap: swController.newProgramSWExperiences) {
            wrap.include = true;         
            }
        
        for (Program_SW_ExperienceController.SWExperienceProgramWrapper wrap: prgController.newProgramSWExperiences) {
            wrap.include = true;
            }
                    
        Test.startTest();
            
            swController.populateList();           
            swController.insertNewSWExperienceProgramRecords();
            
            prgController.populateList();
            prgController.insertNewSWExperienceProgramRecords();
        Test.stopTest();
    }
    
    
}