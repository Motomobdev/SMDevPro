trigger NDA_NDATrigger on NDA__c (after insert, after update , before update) {
/*
* Created by: BigKite Consulting
* Creation date: 15-Sep-2013
* Test Class: NDA_NDATriggerTest
* Description: This trigger will send the notification to additional notifier with NDA if NDA Status is updated.
*
* Change history:
* Changed on:
* Changed by:
* Description:
*/
    if(Trigger.isBefore && Trigger.isUpdate){
        set<NDA__c> setNDA = new set<NDA__c>();
        list<NDA__c> lstNDAUpdate = new list<NDA__c>();
        
        for(NDA__c objNDA : Trigger.new){
            //Notifier Get the Old map NDA record value
            NDA__c objOldNDA = Trigger.oldMap.get(objNDA.ID);
            if (objNDA.NDAStatus__c != objOldNDA.NDAStatus__c) {
                setNDA.add(objNDA);         
            }
                    
            // Check Amendment status
            if (objNDA.amendmentSigned__c == 'true' && objNDA.Expires_On__c != null) {
                // Extend the expiry date to 1 more year
                objNDA.Expires_On__c =  objNDA.Expires_On__c.addYears(1);
                lstNDAUpdate.add(objNDA);  
            }   
              
        }
        
        map<ID, string> mapNDAIdANDNotifierEamil = new map<ID, string>();
        for(NDA_Notifier__c objNotifier : [Select id, name, Notifier_Email__c,nda__c from NDA_Notifier__c where NDA__c IN :setNDA]){
            mapNDAIdANDNotifierEamil.put(objNotifier.nda__c, objNotifier.Notifier_Email__c);
            system.debug('********in trigger 1:****'+objNotifier.Notifier_Email__c);
        }
        
        for(NDA__c objNDARecord : setNDA){
            if(mapNDAIdANDNotifierEamil.size()>0){
                set<String> setEmailID = new set<String>();
                if(mapNDAIdANDNotifierEamil.get(objNDARecord.id) != null && mapNDAIdANDNotifierEamil.get(objNDARecord.id) != ''){
                system.debug('********in trigger 2:****'+mapNDAIdANDNotifierEamil.get(objNDARecord.id));
                    setEmailID.add(mapNDAIdANDNotifierEamil.get(objNDARecord.id));
                }
                if(setEmailID != null){
                system.debug('********in trigger 3:****'+setEmailID);
                    NDA_EmailService.send(objNDARecord, null, setEmailID, 'NotifierUpdate');
                }   
            }
        }
        
        if(Trigger.isUpdate && Trigger.isAfter){
            if(lstNDAUpdate.size() > 0){                
                update lstNDAUpdate;
            }
        }
        
    }
}