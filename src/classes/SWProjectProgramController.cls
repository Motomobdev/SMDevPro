public class SWProjectProgramController{

    public PMD_Program__c thisProgram {get;set;}
    public List<SWProjectProgramWrapper> newProgramSWProjects {get;set;}
    
    public SWProjectProgramController(ApexPages.StandardController stdController){
        thisProgram = (PMD_Program__c)stdController.getRecord();
        populateList();
    }
    
    public void insertNewSWProjectProgramRecords(){
        List<Program_SW_Project__c> insertList = new List<Program_SW_Project__c>();
        for(SWProjectProgramWrapper wrap: newProgramSWProjects){
            if(wrap.include) insertList.add(wrap.newProgramSWProject);
        }
        if(insertList.size() > 0) insert insertList;
        populateList();
    }
    
    public void populateList(){
        newProgramSWProjects = new List<SWProjectProgramWrapper>();
        for(JIRA_Project__c swP: SWProjectsList){
            SWProjectProgramWrapper wrapper = new SWProjectProgramWrapper();
            wrapper.include = false;
            wrapper.Name = swP.Name;
            wrapper.newProgramSWProject = 
                new Program_SW_Project__c(SW_Project__c=swP.Id, Program_PMD__c=thisProgram.Id);
            newProgramSWProjects.add(wrapper);
        }
    }
    
    public class SWProjectProgramWrapper{
        public Boolean include {get;set;}
        public String Name {get;set;}
        public Program_SW_Project__c newProgramSWProject {get;set;}
    }
    
    public static List<JIRA_Project__c> SWProjectsList = 
        [Select id,Name From JIRA_Project__c Where Type__c='Experiences' AND Status__c != 'Canceled' AND POR_Grouping__c !='' AND POR_Status__c != 'Exclude from POR Chart'];   
}