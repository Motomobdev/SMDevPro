@RestResource(urlMapping='/ApplicationDownloadStats/*')
global class ApplicationDownloadStats{
    
    static final String OVERALLS = 'overall';

    @HttpPost
    global static String bulkUpload(String fileType, String payload){
        List<Application_Download_Stats__c> stats = (List<Application_Download_Stats__c>)JSON.deserialize(payload, List<Application_Download_Stats__c>.class);

        String response = null;
        if (!fileType.contains(OVERALLS)){
            Map<Date, ID> mapping = getOveralls(stats.get(0).Application__c);
            
            for(Application_Download_Stats__c stat : stats){
				ID statID = mapping.get(stat.Date__c);
                stat.Overall__c = statID;
            }
        }
         
        upsert stats UniqueID__c;

        // returns IDs with Stats
       	Map<ID,Application_Download_Stats__c> statMap = new Map<ID,Application_Download_Stats__c>(stats);
        response = JSON.serialize(statMap);     
        return response;
    }
    
    private static Map<Date, ID> getOveralls(String appID){        
    	String query = null;
        
        //Getting the record type ID.
        //RecordType in production -> 01240000000Duy9AAC
        //RecordType in sandbox -> 012f0000000CzSyAAK        
        List<RecordType> recordTypes = [select ID from RecordType where Name = 'Google Play Store' limit 1];
		ID recordTypeID = null;
        if (recordTypes.size() > 0){
            recordTypeID = recordTypes.get(0).ID;
        }
        
        query = 'SELECT ID, application__c, Date__c, overall__c, RecordTypeId ';
		query += 'FROM Application_Download_Stats__c WHERE overall__c = null AND RecordTypeId = ';
        query += '\'' + recordTypeID + '\' AND application__c = ';
		query +=  '\'' + appID + '\' ORDER BY Date__c ASC NULLS FIRST';
        
        List<Application_Download_Stats__c> queryResult = Database.query(query);
        
        Map<Date, ID> mapping = new Map<Date, ID>();
        
        for(Application_Download_Stats__c result : queryResult){
            mapping.put(result.Date__c, result.Id);
        }
        
        return mapping;
    }
}