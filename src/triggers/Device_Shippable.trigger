trigger Device_Shippable on Device__c (after update) {
    /*
    Map<ID,Device__c> DeviceMap = New Map<ID, Device__c>();
    Map<ID,Device__c> PrelimDeviceMap = New Map<ID, Device__c>();

    List<String> DevappStatelist = New List<String>();

    for(Integer i=0; i<trigger.new.size(); i++){ 
    
    
        if((Trigger.New[i].SW_KIT__c != Trigger.Old[i].SW_KIT__c) || (Trigger.New[i].SWBOM_Reviewed_and_Approved__c != Trigger.Old[i].SWBOM_Reviewed_and_Approved__c) || (Trigger.New[i].SW_BOM_List_Approver__c != Trigger.Old[i].SW_BOM_List_Approver__c)){
            if((Trigger.New[i].SW_KIT__c != NULL) && (Trigger.New[i].SWBOM_Reviewed_and_Approved__c == 'Yes') && (Trigger.New[i].SW_BOM_List_Approver__c != NULL)){ 
                if(!DeviceMap.keyset().contains(Trigger.New[i].id)){
                
                DeviceMap.put(Trigger.New[i].id, Trigger.New[i]);
                
                }
            }
      
            if((Trigger.New[i].SW_KIT__c == NULL) || (Trigger.New[i].SWBOM_Reviewed_and_Approved__c == 'No') || (Trigger.New[i].SW_BOM_List_Approver__c == NULL)){
                if(!PrelimDeviceMap.keyset().contains(Trigger.New[i].id)){
                    if(Trigger.New[i].Device_SW_KIT_State__c != '12 - Prelim'){
                        
                        PrelimDeviceMap.put(Trigger.New[i].id,New Device__c(id=Trigger.New[i].id,Device_SW_KIT_State__c='12 - Prelim',Device_Fully_Approved__c='No'));
                    }
                }
            }
        }
    }
    
    if(!PrelimDeviceMap.IsEmpty()){
    
        update PrelimDeviceMap.Values();
    
    }
    
    System.debug(Devicemap.keyset() + 'device map keys');
    System.debug(Devicemap.values() + 'device map values');
    
    if(!DeviceMap.IsEmpty()){
        List<DeviceApplicationAssoc__c> devapps = New List<DeviceApplicationAssoc__c>([SELECT Device__c, App_Item_State__c from DeviceApplicationAssoc__c where Device__c IN:DeviceMap.keyset() AND Include_in_BOM__c=: TRUE]);        
        System.debug(devapps.size() + 'Number of Apps on Devices');
        
        
        //SetDeviceShippableandApprovalState.SetDeviceShippableandApprovalState(devapps);
        System.debug(Devapps + 'Device Applications');
    }
    */
}