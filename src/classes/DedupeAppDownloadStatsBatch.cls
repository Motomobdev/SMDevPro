public class DedupeAppDownloadStatsBatch implements Database.Batchable<sObject>{
   
   	public String query;
    
    public DedupeAppDownloadStatsBatch(){
    	query = 'Select id,UniqueID__c From Application_Download_Stats__c';
    }
    
   	public Database.QueryLocator start(Database.BatchableContext BC){
		return Database.getQueryLocator(query);
	}

	public void execute(Database.BatchableContext BC, List<sObject> scope){
    	List<Application_Download_Stats__c> queryStats = (List<Application_Download_Stats__c>) scope;
        List<Application_Download_Stats__c> statsToDelete = new List<Application_Download_Stats__c>();
        Set<String> uniqueIds = new Set<String>();
        
        for(Application_Download_Stats__c dstat: queryStats){
        	if(uniqueIds.contains(dstat.UniqueID__c)) statsToDelete.add(dstat);
            uniqueIds.add(dstat.UniqueID__c);
        }
        
        List<Application_Download_Stats__c> matchingStats = [Select id,UniqueID__c From Application_Download_Stats__c Where UniqueID__c IN :uniqueIds AND ID NOT IN :queryStats];
        statsToDelete.addAll(matchingStats);
        
        if(statsToDelete.size() > 0) delete statsToDelete;
        
    }

	public void finish(Database.BatchableContext BC){
   	}

}