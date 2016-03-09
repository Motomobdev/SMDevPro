public class JIRAProjectcontroller{

    
    public static void getDeviceDates(List<JIRA_Project__c> JIRAProjects){
    	Map<ID,JIRA_Project__c> projectMap = new Map<Id,JIRA_Project__c>(JIRAProjects);
        List<Device_JIRA_Project__c> AllDevices = [Select id,JIRA_Project__c,Device__c,Device__r.TA_Date__c,Device__r.SA_Date__c,Device__r.LE__c From Device_JIRA_Project__c Where JIRA_Project__c IN :JIRAProjects];
        
        Map<ID,List<DeviceDates.DeviceIDLEDate>> LEDates = new Map<ID,List<DeviceDates.DeviceIDLEDate>>();
        Map<ID,List<DeviceDates.DeviceIDTADate>> TADates = new Map<ID,List<DeviceDates.DeviceIDTADate>>();
        Map<ID,List<DeviceDates.DeviceIDSADate>> SADates = new Map<ID,List<DeviceDates.DeviceIDSADate>>();
        
        for(Device_JIRA_Project__c djp: AllDevices){
        	if(djp.JIRA_Project__c == null || djp.Device__c == null) continue;
            
          	// Organize LE Dates
            if(djp.Device__r.LE__c != null){
            	if(!LEDates.containsKey(djp.JIRA_Project__c)) LEDates.put(djp.JIRA_Project__c,new List<DeviceDates.DeviceIDLEDate>());
				DeviceDates.DeviceIDLEDate newLEDate = new DeviceDates.DeviceIDLEDate();
                newLEDate.DeviceID=djp.Device__c;
                newLEDate.LEDate=djp.Device__r.LE__c;
                LEDates.get(djp.JIRA_Project__c).add(newLEDate);
            }
            
            // Organize TA Dates
            if(djp.Device__r.TA_Date__c != null){
            	if(!TADates.containsKey(djp.JIRA_Project__c)) TADates.put(djp.JIRA_Project__c,new List<DeviceDates.DeviceIDTADate>());
				DeviceDates.DeviceIDTADate newTADate = new DeviceDates.DeviceIDTADate();
                newTADate.DeviceID=djp.Device__c;
                newTADate.TADate=djp.Device__r.TA_Date__c;
                TADates.get(djp.JIRA_Project__c).add(newTADate);
            }
            
            // Organize SA Dates
            if(djp.Device__r.SA_Date__c != null){
            	if(!SADates.containsKey(djp.JIRA_Project__c)) SADates.put(djp.JIRA_Project__c,new List<DeviceDates.DeviceIDSADate>());
				DeviceDates.DeviceIDSADate newSADate = new DeviceDates.DeviceIDSADate();
                newSADate.DeviceID=djp.Device__c;
                newSADate.SADate=djp.Device__r.SA_Date__c;
                SADates.get(djp.JIRA_Project__c).add(newSADate);
            }
        }
        
        for(JIRA_Project__c jp:JIRAProjects){
            if(LEDates.containsKey(jp.id) && LEDates.get(jp.id).size() > 0){
            	List<DeviceDates.DeviceIDLEDate> dates = LEDates.get(jp.id);
                dates.sort();
                jp.LE_Date__c = dates.get(0).LEDate;
                jp.Oldest_LE_Date__c = dates.get(dates.size()-1).LEDate;
            }
            
            if(TADates.containsKey(jp.id) && TADates.get(jp.id).size() > 0){
            	List<DeviceDates.DeviceIDTADate> dates = TADates.get(jp.id);
                dates.sort();
                jp.TA_Date__c = dates.get(0).TADate;
                jp.Oldest_TA_Date__c = dates.get(dates.size()-1).TADate;
            }
            
            if(SADates.containsKey(jp.id) && SADates.get(jp.id).size() > 0){
            	List<DeviceDates.DeviceIDSADate> dates = SADates.get(jp.id);
                dates.sort();
                jp.SA_Date__c = dates.get(0).SADate;
                jp.Oldest_SA_Date__c = dates.get(dates.size()-1).SADate;
            }
        }
        
        if(JIRAProjects.size() > 0) update JIRAProjects;
    }
    
    
}