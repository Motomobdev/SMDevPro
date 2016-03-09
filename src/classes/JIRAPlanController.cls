public class JIRAPlanController{

    public static void checkFeatureIDHasBeenChanged(Map<ID,JIRA_Plan__c> oldPlans,List<JIRA_Plan__c> plans){
        Set<ID> filteredPlanFeatureIDs = new Set<ID>();
        for( JIRA_Plan__c jp: plans){
            if(jp.JIRA_Feature__c != null && jp.JIRA_Feature__c != oldPlans.get(jp.id).JIRA_Feature__c ) filteredPlanFeatureIDs.add(jp.JIRA_Feature__c);
        }
        
        Map<ID,JIRA_Feature__c> featureMap = new Map<ID,JIRA_Feature__c>([Select id,JIRA_Project__c From JIRA_Feature__c Where id IN :filteredPlanFeatureIDs]);
        for( JIRA_Plan__c jp: plans){
            if(jp.JIRA_Feature__c != null && featureMap.containsKey(jp.JIRA_Feature__c)) jp.JIRA_Project__c = featureMap.get(jp.JIRA_Feature__c).JIRA_Project__c;
        }
    
    } 
    
    public static void transferFeatureProjectToPlan(List<JIRA_Plan__c> plans){
        Set<ID> filteredPlanFeatureIDs = new Set<ID>();
        for( JIRA_Plan__c jp: plans){
            if(jp.JIRA_Feature__c != null) filteredPlanFeatureIDs.add(jp.JIRA_Feature__c);
        }
        
        Map<ID,JIRA_Feature__c> featureMap = new Map<ID,JIRA_Feature__c>([Select id,JIRA_Project__c From JIRA_Feature__c Where id IN :filteredPlanFeatureIDs]);
        for( JIRA_Plan__c jp: plans){
            if(jp.JIRA_Feature__c != null) jp.JIRA_Project__c = featureMap.get(jp.JIRA_Feature__c).JIRA_Project__c;
        }
    }
    
}