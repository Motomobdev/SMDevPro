public class SWExperienceProgramController{

    public PMD_Program__c thisProgram {get;set;}
    public List<SWExperienceProgramWrapper> newProgramSWExperiences {get;set;}
    
    public SWExperienceProgramController(ApexPages.StandardController stdController){
        thisProgram = (PMD_Program__c)stdController.getRecord();
        populateList();
    }
    
    public void insertNewSWExperienceProgramRecords(){
        List<Program_SW_Experience__c> insertList = new List<Program_SW_Experience__c>();
        for(SWExperienceProgramWrapper wrap: newProgramSWExperiences){
            if(wrap.include) insertList.add(wrap.newProgramSWExperience);
        }
        if(insertList.size() > 0) insert insertList;
        populateList();
    }
    
    public void populateList(){
        newProgramSWExperiences = new List<SWExperienceProgramWrapper>();
        for(SW_Experiences_and_Releases__c swP: SWExperiencesList){
            SWExperienceProgramWrapper wrapper = new SWExperienceProgramWrapper();
            wrapper.include = false;
            wrapper.Name = swP.Name;
            wrapper.newProgramSWExperience = 
                new Program_SW_Experience__c(SW_Experiences__c=swP.Id, Program_PMD__c=thisProgram.Id);
            newProgramSWExperiences.add(wrapper);
        }
    }
    
    public class SWExperienceProgramWrapper{
        public Boolean include {get;set;}
        public String Name {get;set;}
        public Program_SW_Experience__c newProgramSWExperience {get;set;}
    }
    
    public static List<SW_Experiences_and_Releases__c> SWExperiencesList = 
        [Select id,Name From SW_Experiences_and_Releases__c Where Type__c='Experiences' and Status__c != 'Canceled' AND POR_Status__c != 'Exclude from POR Chart'];   
}