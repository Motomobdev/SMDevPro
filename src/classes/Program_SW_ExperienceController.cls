public class Program_SW_ExperienceController {

   /*
     * Created by: Lipsa Mishra
     * Creation date: 08-July-2015
     * Test Class: SWExperienceProgramControllerTest
     * Description: Add PMD Programs to a Software Experience
     */
 
    public SW_Experiences_and_Releases__c this_SW_Experiences {get;set;}
    public List<SWExperienceProgramWrapper> newProgramSWExperiences {get;set;}

    public Program_SW_ExperienceController(ApexPages.StandardController controller) {
        this_SW_Experiences = (SW_Experiences_and_Releases__c)controller.getRecord();
        populateList();
    }

    public void populateList() {
 
        newProgramSWExperiences = new List<SWExperienceProgramWrapper>();
        List<PMD_Program__c> activePrograms = 
          [Select id,Name From PMD_Program__c Where Program_Status__c in ('Active', 'Shipping', 'On Hold', 'Discovery') AND Exclude_from_POR_Experiences_Chart__c = FALSE AND POR_Grouping__c !=''
          Order by Name];
            
        for (PMD_Program__c program : activePrograms){
            SWExperienceProgramWrapper w = new SWExperienceProgramWrapper();
            w.include = false;
            w.Name = program.Name;
            w.newProgramSWExperience = 
                new Program_SW_Experience__c(SW_Experiences__c=this_SW_Experiences.Id, Program_PMD__c=program.Id);
            newProgramSWExperiences.add(w);
        }
    }
    
    public void insertNewSWExperienceProgramRecords(){
        List<Program_SW_Experience__c> insertList = new List<Program_SW_Experience__c>();
        
        for (SWExperienceProgramWrapper wrap: newProgramSWExperiences) {
          if(wrap.include) 
              insertList.add(wrap.newProgramSWExperience);
        }
 
        if (insertList.size() > 0) 
            insert insertList;
        populateList();
    }

    public class SWExperienceProgramWrapper{
        public Boolean include {get;set;}
        public String Name {get;set;}
        public Program_SW_Experience__c newProgramSWExperience {get;set;}
    }
}