public class GPSHeirarchyBatch implements Database.Batchable<sObject>, Database.Stateful{

    public String query {get;set;}
    
    public GPSHeirarchyBatch(){
        query = 'Select id,UniqueID__C From Application_Download_Stats__c Where UniqueID_Length__c > 26 AND Overall__c = \'\'';
    }
    
    public GPSHeirarchyBatch(String query){
        this.query = query;
    }
    
    public Database.QueryLocator start(Database.BatchableContext BC){
    	return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Application_Download_Stats__c> appDownloadStats){
        // Get UniqueIds
        Set<String> uniqueIds = new Set<String>();
        for(Application_Download_Stats__c appStat:appDownloadStats) uniqueIds.add(appStat.uniqueId__c.substring(0,26));
        
        // Query Overall Application_Download_Stats__c from UniqueIds and create Mapping
        List<Application_Download_Stats__c> overalls = [Select id,UniqueID__c From Application_Download_Stats__c Where UniqueId__c IN :uniqueIds];
        Map<String,Application_Download_Stats__c> overallMap = new Map<String,Application_Download_Stats__c>();
        for(Application_Download_Stats__c appStat: overalls) overallMap.put(appStat.UniqueID__c,appStat);
        
        // Update Application_Download_Stats__c with overalls 
        for(Application_Download_Stats__c appStat:appDownloadStats){
          //if(!overallMap.containsKey(appStat.UniqueID__c.substring(0,26))) continue;   
          appStat.Overall__c = overallMap.get(appStat.UniqueID__c.substring(0,26)).Id;
        }
        
        update appDownloadStats;
        
    }
    
    public void finish(Database.BatchableContext BC){
    }
}