trigger TA_Submission_Date on Device__c(before insert, before update){
    if(trigger.isInsert){
        for(Device__c device: Trigger.New){
            device.Original_Google_TA_Submission_Date__c = device.Date_CTS_SW_Checklist_Sent_to_Google__c;
        }
    }
    if(trigger.isUpdate){
        for(Device__c device: Trigger.New){
            if(device.Original_Google_TA_Submission_Date__c == null){
                device.Original_Google_TA_Submission_Date__c = device.Date_CTS_SW_Checklist_Sent_to_Google__c;
            }
        }
    }
}