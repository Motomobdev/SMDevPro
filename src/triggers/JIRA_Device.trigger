/**
 * JIRA_Device Trigger.
 * Responsible to create the relationship with (Device__c and SW_Kit__c)
 * 
 * @author: Jimens - jimens@motorola.com
 */
trigger JIRA_Device on JIRA_Device__c (before insert, before update) {
    try{
        if(JiraImporter.updateFromJira){        
            List<String> swkitIds = new List<String>();
            List<String> deviceIds = new List<String>();
                    
            for(JIRA_Device__c records : trigger.new){
                swkitIds.add(records.SW_KIT_ID__c);
                deviceIds.add(records.Device_ID__c);                    
            }
            
            List<Device__c> devices = [SELECT Id,Device_ID__c FROM Device__c WHERE Device_ID__c in :deviceIds];
            List<SW_Kit__c> kits    = [SELECT Id,Name FROM SW_Kit__c WHERE Name in :swkitIds];
            
            
            for(JIRA_Device__c newJiraDevRecord : trigger.new){
                if (newJiraDevRecord.Updated_From_SF__c == false){
                    for (Device__c device : devices){                        
                        if (newJiraDevRecord.Device_ID__c == device.Device_ID__c){               
                            newJiraDevRecord.Device__c = device.Id;  
                            break;
                        }
                    }
                    
                    for (SW_Kit__c kit : kits){
                        if (newJiraDevRecord.SW_KIT_ID__c == kit.Name){
                            newJiraDevRecord.SW_Kit__c = kit.Id; 
                            break;
                        }
                    }
                    
                    newJiraDevRecord.Updated_From_SF__c = false;                    
                }
            }
        }
    }catch(Exception e){
        System.debug('Exception on JIRA_Device trigger '+BOMUtils.getStackTrace(e));
    }
}