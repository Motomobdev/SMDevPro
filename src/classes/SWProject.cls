@RestResource(urlMapping='/SWProject')
global class SWProject{
    
    @HttpPost
    global static String addRecords(String records){
        
        List<JIRA_Project__c> swprojects = (List< JIRA_Project__c>)JSON.deserialize(records, List< JIRA_Project__c>.class);
        insert swprojects;
        return JSON.serialize(swprojects);
    }
    
    @HttpPatch
    global static String updateRecords(String records){
        
        List<JIRA_Project__c> swprojects = (List< JIRA_Project__c>)JSON.deserialize(records, List< JIRA_Project__c>.class);
        update swprojects;
        return JSON.serialize(swprojects);
    }

}