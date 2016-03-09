trigger DeviceApplication_Shippable on DeviceApplicationAssoc__c (before insert, after update, after delete) {

    /*Map<ID, Device__c> devmap = New Map<ID, Device__c>();
       
    if(Trigger.isDelete){
   
        for(Integer i=0; i<trigger.old.size(); i++){
            if(!devmap.keySet().contains(trigger.old[i].Device__c)){
                devmap.put(trigger.old[i].Device__c,new Device__c(Id = trigger.old[i].Device__c));
            }      
        }
    }

    
    if(Trigger.isInsert){
    
        for(Integer i=0; i<trigger.new.size(); i++){
            Trigger.New[i].App_Item_State__c= '12 - Prelim';               
                if(!devmap.keySet().contains(trigger.new[i].Device__c)){
                    devmap.put(trigger.new[i].Device__c,new Device__c(Id = trigger.new[i].Device__c, Device_SW_KIT_State__c = '12 - Prelim'));        
                }
        }
    }


    if(Trigger.IsUpdate){   
        for(Integer i=0; i<trigger.new.size(); i++){
            if((Trigger.New[i].Approval_Status__c != Trigger.Old[i].Approval_Status__c) ||
            (Trigger.New[i].Application_Contract_Status__c != Trigger.Old[i].Application_Contract_Status__c)||    
            (Trigger.New[i].X3rd_Party_Approval_Status__c != Trigger.Old[i].X3rd_Party_Approval_Status__c)){
                if(!devmap.keySet().contains(trigger.new[i].Device__c)){
                    devmap.put(trigger.new[i].Device__c,new Device__c(Id = trigger.new[i].Device__c));
                }  
            }  
        } 
        system.debug('THIS IS DEVMAP:' + devmap);
     
        if(!devmap.IsEmpty()){   
        List<DeviceApplicationAssoc__c> devapps = New List<DeviceApplicationAssoc__c>([SELECT APP_ITEM_STATE__C, Device__c  FROM DeviceApplicationAssoc__c where Device__c IN: devmap.keyset() AND Include_in_Bom__c = true AND Device__r.Cancelled__c = false AND Device__r.Device_ID__c != NULL]);
        
        SetDeviceShippableandApprovalState.SetDeviceShippableandApprovalState(devapps);       
        System.debug(devmap.values() + 'Updated Device id & Value');
        
        }
        
	}
*/
}