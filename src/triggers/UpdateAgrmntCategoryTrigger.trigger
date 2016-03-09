trigger UpdateAgrmntCategoryTrigger on Apttus__APTS_Agreement__c (before insert) 
{
    // Test class: test_UpdateAgrmntCategoryTrigger
    Profile p = [select name from profile where id =: UserInfo.getProfileId ()];     
    for (Integer i = 0; i < trigger.new.size(); i++) {
    
        if (p != null && (p.Name == 'Apttus Direct SC Contract Manager' ||  
                          p.Name == 'Apttus Indirect SC Contract Manager')) {
            trigger.new[i].Apttus__Agreement_Category__c = 'Supply Chain';
        } else {
            trigger.new[i].Apttus__Agreement_Category__c = 'Mobile Devices';
        }

        // Set external spend request to null for cloned agreements
        // NOTE: The relation between these objects is 1:1
        if (trigger.new[i].Apttus__Workflow_Trigger_Created_From_Clone__c) {
            
            trigger.new[i].Apttus__Other_Party_Signed_Date__c = null;
            trigger.new[i].Apttus__Company_Signed_Date__c = null;
            trigger.new[i].external_spend_request__c = null;
        }
    }
}