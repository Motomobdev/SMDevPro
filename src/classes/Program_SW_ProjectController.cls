public class Program_SW_ProjectController {

   /*
     * Created by: Rajesh Krishnaiah
     * Creation date: 08-May-2014
     * Test Class: SWProjectProgramControllerTest
     * Description: Add PMD Programs to a software project
     */
 
    public JIRA_Project__c this_SW_Project {get;set;}
    public List<SWProjectProgramWrapper> newProgramSWProjects {get;set;}

    public Program_SW_ProjectController(ApexPages.StandardController controller) {
        this_SW_Project = (JIRA_Project__c)controller.getRecord();
        populateList();
    }

    public void populateList() {
 
        newProgramSWProjects = new List<SWProjectProgramWrapper>();
        List<PMD_Program__c> activePrograms = 
          [Select id,Name From PMD_Program__c Where Program_Status__c in ('Active', 'Shipping', 'End of Life', 'On Hold', 'Discovery') AND Exclude_from_POR_Experiences_Chart__c = FALSE AND POR_Grouping__c !=''
          Order by Name];
            
        for (PMD_Program__c program : activePrograms){
            SWProjectProgramWrapper w = new SWProjectProgramWrapper();
            w.include = false;
            w.Name = program.Name;
            w.newProgramSWProject = 
                new Program_SW_Project__c(SW_Project__c=this_SW_Project.Id, Program_PMD__c=program.Id);
            newProgramSWProjects.add(w);
        }
    }
    
    public void insertNewSWProjectProgramRecords(){
        List<Program_SW_Project__c> insertList = new List<Program_SW_Project__c>();
        
        for (SWProjectProgramWrapper wrap: newProgramSWProjects) {
          if(wrap.include) 
              insertList.add(wrap.newProgramSWProject);
        }
 
        if (insertList.size() > 0) 
            insert insertList;
        populateList();
    }

    public class SWProjectProgramWrapper{
        public Boolean include {get;set;}
        public String Name {get;set;}
        public Program_SW_Project__c newProgramSWProject {get;set;}
    }
}