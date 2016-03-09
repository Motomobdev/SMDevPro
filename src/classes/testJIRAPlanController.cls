@isTest
public class testJIRAPlanController{

    public static testMethod void testTransferFeatureProjectToPlan(){
        JIRA_Project__c testProject = new JIRA_Project__c(Name='Test Project');
        insert testProject;
        
        Integer totalRecords = 1;
        
        List<JIRA_Feature__c> features = new List<JIRA_Feature__c>(); 
        for(Integer count = 0; count < totalRecords; count++){
            features.add(new JIRA_Feature__c(Name='Feature-'+count,JIRA_Project__c=testProject.id));
        }
        insert features;
        
        List<JIRA_Plan__c> plans = new List<JIRA_Plan__c>();
        for(Integer count = 0; count < totalRecords; count++){
            plans.add(new JIRA_Plan__c(Name='RPSC-'+count,JIRA_Project__c=testProject.id,JIRA_Feature__c=features.get(count).id));
        }
        
        Test.startTest();
 			insert plans;      
        Test.stopTest();
                         
        plans = [Select id,JIRA_Project__c,JIRA_Feature__c,JIRA_Feature__r.JIRA_Project__c From JIRA_Plan__c];
        for(JIRA_Plan__c jp: plans){
        	System.assertEquals(jp.JIRA_Feature__r.JIRA_Project__c,jp.JIRA_Project__c);
        }
                         
    }
    
    public static testMethod void testTransferFeatureProjectToPlanFromUpdatingFeature(){
        JIRA_Project__c testProject = new JIRA_Project__c(Name='Test Project');
        insert testProject;
        
        Integer totalRecords = 1;
        
        List<JIRA_Feature__c> features = new List<JIRA_Feature__c>(); 
        for(Integer count = 0; count < totalRecords; count++){
            features.add(new JIRA_Feature__c(Name='Feature-'+count,JIRA_Project__c=testProject.id));
        }
        insert features;
        
        List<JIRA_Plan__c> plans = new List<JIRA_Plan__c>();
        for(Integer count = 0; count < totalRecords; count++){
            plans.add(new JIRA_Plan__c(Name='RPSC-'+count,JIRA_Project__c=testProject.id,JIRA_Feature__c=features.get(count).id));
        }
        insert plans;
     
        JIRA_Project__c otherTestProject = new JIRA_Project__c(Name='Other Test Project');
        insert otherTestProject;
        
        JIRA_Feature__c otherFeature = new JIRA_Feature__c(Name='Feature-Other',JIRA_Project__c=otherTestProject.id);
        insert otherFeature;
            
        Test.startTest();
 		  for(JIRA_Plan__c jp: plans){
          		jp.JIRA_Feature__c = otherFeature.id;
          }
          update plans;
        Test.stopTest();
                         
        plans = [Select id,JIRA_Project__c,JIRA_Feature__c,JIRA_Feature__r.JIRA_Project__c From JIRA_Plan__c];
        for(JIRA_Plan__c jp: plans){
        	System.assertEquals(otherTestProject.id,jp.JIRA_Project__c);
        }
                         
    }
    
}