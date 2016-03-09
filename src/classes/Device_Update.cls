public with sharing class Device_Update {
    public static void beforeUpdate(List<Device__c> newList, List<Device__c> oldList){

        List<Device__c> devicesWithNewSWBOMOwner = new List<Device__c>();
        Set<Device__c> devicesViolatingBOMCompliance = new Set<Device__c>();
        Set<Device__c> devicesViolatingContractCompliance = new Set<Device__c>();
        Set<Device__c> devicesViolatingAIFCompliance = new Set<Device__c>();
        Set<Device__c> devicesWithUpdatedMotoreadyPMNew = new Set<Device__c>();
        Set<Device__c> devicesWithUpdatedMotoreadyPMOld = new Set<Device__c>();       
        
        
        DeviceMethods.validateDeviceReviewedAndApproved(newList, oldList);
        
        for(Integer i=0; i<newList.size(); i++){
            if(newList[i].Device_Fully_Approved__c == 'Yes' && oldList[i].Device_Fully_Approved__c == 'Yes' && (UserInfo.getProfileId() != '00e40000000oqQ9AAI' && UserInfo.getProfileId() != '00e40000000oqznAAA' && UserInfo.getProfileId() != '00e40000000or7mAAA')){
                if(newList[i].SWBOM_Reviewed_and_Approved__c != oldList[i].SWBOM_Reviewed_and_Approved__c || newList[i].White_Listed_Build_Fingerprint__c != oldList[i].White_Listed_Build_Fingerprint__c){
                    newList[i].addError(' One or more of the fields changed are locked due to the Device being fully approved.');
                }
            }
            
            if(newList[i].MOTOREADY_Preload_Program_Manager__c != oldList[i].MOTOREADY_Preload_Program_Manager__c){
                if(newList[i].MOTOREADY_Preload_Program_Manager__c != null){
                    devicesWithUpdatedMotoreadyPMNew.add(newList[i]);
                }
                
                if(oldList[i].MOTOREADY_Preload_Program_Manager__c != null){
                    devicesWithUpdatedMotoreadyPMOld.add(oldList[i]);
                }       
            }           
            
            if(newList[i].SWBOM_Owner_Email__c != null && newList[i].SWBOM_Owner_Email__c != oldList[i].SWBOM_Owner_Email__c){
                devicesWithNewSWBOMOwner.add(newList[i]);
            } else if(newList[i].SWBOM_Owner_Email__c == null && newList[i].SWBOM_Owner_Email__c != oldList[i].SWBOM_Owner_Email__c){
                newList[i].SW_BOM_Owner_Manager__c = null;
            }
            
            if(newList[i].sendAIFComplianceEmail__c == true && oldList[i].sendAIFComplianceEmail__c == false){
                if(newList[i].SA_Date__c <= Date.today().addDays(28) && newList[i].SA_Date__c >= Date.today().addDays(15) && newList[i].SA_Date__c != newList[i].ComplianceEmail_AifLevel1_SentForSADate__c){
                    devicesViolatingAIFCompliance.add(newList[i]);
                    newList[i].ComplianceEmail_AifLevel1_SentForSADate__c = newList[i].SA_Date__c;
                    
                } else if(newList[i].SA_Date__c <= Date.today().addDays(14) && newList[i].SA_Date__c >= Date.today() && newList[i].SA_Date__c != newList[i].ComplianceEmail_AifLevel2_SentForSADate__c){
                    devicesViolatingAIFCompliance.add(newList[i]);
                    newList[i].ComplianceEmail_AifLevel2_SentForSADate__c = newList[i].SA_Date__c;
                } 
                newList[i].sendAIFComplianceEmail__c = false;
            }           
            
            if(newList[i].sendBOMComplianceEmail__c == true && oldList[i].sendBOMComplianceEmail__c == false){
                if(newList[i].SA_Date__c <= Date.today().addDays(28) && newList[i].SA_Date__c >= Date.today().addDays(8) && newList[i].SA_Date__c != newList[i].ComplianceEmail_BomLevel1_SentForSADate__c){
                    devicesViolatingBOMCompliance.add(newList[i]);
                    newList[i].ComplianceEmail_BomLevel1_SentForSADate__c = newList[i].SA_Date__c;
                    
                } else if(newList[i].SA_Date__c <= Date.today().addDays(7) && newList[i].SA_Date__c >= Date.today() && newList[i].SA_Date__c != newList[i].ComplianceEmail_BomLevel2_SentForSADate__c){
                    devicesViolatingBOMCompliance.add(newList[i]);
                    newList[i].ComplianceEmail_BomLevel2_SentForSADate__c = newList[i].SA_Date__c;
                }
                newList[i].sendBOMComplianceEmail__c = false;
            }
            
            if(newList[i].sendContractComplianceEmail__c == true && oldList[i].sendContractComplianceEmail__c == false){
                if(newList[i].SA_Date__c <= Date.today().addDays(42) && newList[i].SA_Date__c >= Date.today().addDays(29) && newList[i].SA_Date__c != newList[i].ComplianceEmail_ContLevel1_SentForSADate__c){
                    devicesViolatingContractCompliance.add(newList[i]);                 
                    newList[i].ComplianceEmail_ContLevel1_SentForSADate__c = newList[i].SA_Date__c;
                    
                }else if(newList[i].SA_Date__c <= Date.today().addDays(28) && newList[i].SA_Date__c >= Date.today().addDays(15) && newList[i].SA_Date__c != newList[i].ComplianceEmail_ContLevel2_SentForSADate__c){
                    devicesViolatingContractCompliance.add(newList[i]);                 
                    newList[i].ComplianceEmail_ContLevel2_SentForSADate__c = newList[i].SA_Date__c;
                    
                } else if(newList[i].SA_Date__c <= Date.today().addDays(14) && newList[i].SA_Date__c >= Date.today() && newList[i].SA_Date__c != newList[i].ComplianceEmail_ContLevel3_SentForSADate__c){
                    devicesViolatingContractCompliance.add(newList[i]);
                    newList[i].ComplianceEmail_ContLevel3_SentForSADate__c = newList[i].SA_Date__c;
                }               
                newList[i].sendContractComplianceEmail__c = false;
            }
        }

        if(!devicesWithNewSWBOMOwner.isEmpty()){
            DeviceMethods.findSWBOMOwnerManager(devicesWithNewSWBOMOwner);
        }
        
        if(!devicesViolatingAIFCompliance.isEmpty()){ DeviceNotificationEmails.aifComplianceNotification(devicesViolatingAIFCompliance); }
        
        if(!devicesViolatingBOMCompliance.isEmpty()){ DeviceNotificationEmails.bomComplianceNotification(devicesViolatingBOMCompliance); }
        
        if(!devicesViolatingContractCompliance.isEmpty()){ DeviceNotificationEmails.contractComplianceNotification(devicesViolatingContractCompliance); }
        
        if(!devicesWithUpdatedMotoreadyPMNew.isEmpty()){ DeviceNotificationEmails.motoreadyPMUpdated(devicesWithUpdatedMotoreadyPMNew, devicesWithUpdatedMotoreadyPMOld); }
    }
    
    public static void afterUpdate(List<Device__c> newList, List<Device__c> oldList){
        system.debug('Device_Update.afterUpdate');
        Set<String> productFamilies = new Set<String>();    
        Set<Id> devicesDeletedFromNPI = new Set<Id>();
        List<Id> devicesWithChangedSADate = new List<Id>();
        //Set<Device__c> devicesWithCamera = new Set<Device__c>();
        Set<Id> swKitIdsFromDevicesWithUpdatedSADate = new Set<Id>();
        Map<Id, Device__c> devicesWithUpdatedSWAndAppsLead = new Map<Id, Device__c>();
        Set<Device__c> devicesWithNewOrUpdatedSWKit = new Set<Device__c>();
        
        //added by Swetha
        Set<Id> devicesToProcess = new Set<Id>();

        for(Integer i=0; i<newList.size(); i++){
            
            // if estimated royalty cost HIGH w/o Qualcomm has changed, re-eval skip_budget_approval
            if(newList[i].Estimated_High_Royalty_Cost_w_o_Qualcomm__c != oldList[i].Estimated_High_Royalty_Cost_w_o_Qualcomm__c && newList[i].Estimated_High_Royalty_Cost_w_o_Qualcomm__c != null && newList[i].Product_Family__c != null && newList[i].Product_Family__c != '' && newList[i].Business_Unit__c != 'Companion Products' && newList[i].Product_Segment__c != 'MMCP'){ 
                productFamilies.add(newList[i].Product_Family__c);
            }
            
            // if device has been deleted from NPI, remove all devApps
            if(newList[i].SA_Status__c == 'Device Deleted from NPI' && newList[i].SA_Status__c != oldList[i].SA_Status__c){
                devicesDeletedFromNPI.add(newList[i].Id);
            }
            
            if(newList[i].SA_Date__c != oldList[i].SA_Date__c){
                if(newList[i].Device_Fully_Approved__c != 'Yes' && (newList[i].Number_of_12_Prelim_DevApps__c > 0 || newList[i].Number_of_32_Controlled_DevApps__c > 0)){
                    devicesWithChangedSADate.add(newList[i].Id);
                }
                if(newList[i].SW_Kit__c != null){
                    swKitIdsFromDevicesWithUpdatedSADate.add(newList[i].SW_Kit__c);
                }
                
            }
            
            //if(newList[i].Camera_resolution__c != oldList[i].Camera_resolution__c){
            //    devicesWithCamera.add(newList[i]);
            //}
            
            if(newList[i].SW_Apps_Lead__c != oldList[i].SW_Apps_Lead__c && newList[i].SW_Apps_Lead__c != null){
                devicesWithUpdatedSWAndAppsLead.put(newList[i].id, newList[i]);
            }
            
    /*****/     if(newList[i].SW_Kit__c != oldList[i].SW_Kit__c && newList[i].SW_Kit__c != null){
                devicesWithNewOrUpdatedSWKit.add(newList[i]);
            }
            
        }
        
        if(!swKitIdsFromDevicesWithUpdatedSADate.isEmpty()){ SWKitMethods.updateSWKitEffectiveDate(swKitIdsFromDevicesWithUpdatedSADate); }
        
        if(!devicesWithChangedSADate.isEmpty()){ updateAllDevAppsIfSADateHasChanged(devicesWithChangedSADate); }
        
        if(!productFamilies.isEmpty()){ DeviceMethods.calculateSkipBudgetApproval(productFamilies); }       
        
        if(!devicesDeletedFromNPI.isEmpty()){
            List<DeviceApplicationAssoc__c> devAppsForDeletedDevice = [SELECT Id FROM DeviceApplicationAssoc__c WHERE Device__c IN : devicesDeletedFromNPI];
            delete devAppsForDeletedDevice;
        }
        
        
        // added by Swetha
        for(Integer i=0; i<newList.size(); i++) {
            // Rajesh: 3/14/2014 - Removed this condition - newList[i].SA_Date__c >= system.today() &&
            // Check if one or more device fields, which needs to be evaluated for IP Apps, have changed
            if(newList[i].Adjunct_Chipset__c != oldList[i].Adjunct_Chipset__c
               || newList[i].Audio_Playback_Codecs__c != oldList[i].Audio_Playback_Codecs__c
               || newList[i].Baseband_Chipset__c != oldList[i].Baseband_Chipset__c 
               || newList[i].Browser_Type__c != oldList[i].Browser_Type__c 
               || newList[i].Business_Unit__c != oldList[i].Business_Unit__c
               || newList[i].Camera_Resolution__c != oldList[i].Camera_Resolution__c
               || newList[i].Carrier__c != oldList[i].Carrier__c 
               || newList[i].Country__c != oldList[i].Country__c 
               || newList[i].Device_Type__c != oldList[i].Device_Type__c 
               || newList[i].Display_Pixels__c != oldList[i].Display_Pixels__c
               || newList[i].DTV__c != oldList[i].DTV__c
               || newList[i].Dual_SIM__c != oldList[i].Dual_SIM__c
               || newList[i].Email__c != oldList[i].Email__c
               || newList[i].Messaging_Types__c != oldList[i].Messaging_Types__c
               || newList[i].Navigation_Control__c != oldList[i].Navigation_Control__c 
               || newList[i].Platform__c != oldList[i].Platform__c 
               || newList[i].Software_Features__c != oldList[i].Software_Features__c 
               || newList[i].Tech_Description__c != oldList[i].Tech_Description__c
               || newList[i].Technology__c != oldList[i].Technology__c)
            {
                devicesToProcess.add(newList[i].Id);
            }
        }
        // Automatically Add or Remove IP Applications
        //IPApplications.addOrRemoveIPApplications(newList, oldList);
        // added by Swetha
        if(!devicesToProcess.isEmpty()){            
            //Future Apex
            //IPApplications.addOrRemoveIPApplications(devicesToProcess);
            
            // Batch Apex
            Database.executeBatch(new IPApplications_new(devicesToProcess),200);
    
             //check if there are 5 active batch jobs
            //In some cases, might need to add "Status='Queued' " to the criteria
       /*     if ([SELECT count() FROM AsyncApexJob WHERE JobType='BatchApex' AND (Status = 'Processing' OR Status = 'Preparing')] < 5){ 
                  Database.executeBatch(new IPApplications_new(devicesToProcess),500);
            } else {
               //schedule this same schedulable class again in 30 mins
               IPApplications_new_Schedulable sc = new IPApplications_new_Schedulable();
               Datetime dt = Datetime.now() + (0.024305); // i.e. 30 mins
               String timeForScheduler = dt.format('s m H d M \'?\' yyyy');
               Id schedId = System.Schedule('MatrixRetry'+timeForScheduler,timeForScheduler,sc);
               system.schedule('IPApplications_new', timeForScheduler, new IPApplications_new(devicesToProcess)); 
            }    */        
        }
        

        if(!devicesWithUpdatedSWAndAppsLead.isEmpty()){ DeviceMethods.updateAIFMatricesFromNewSWAppsLead(devicesWithUpdatedSWAndAppsLead); }
        
        //checkForChangesToIPApplicationFields(newList, oldList);
        
        checkIfCountryHasBeenChanged(newList, oldList);
        
        checkIfDeviceIsCancelledOrSADateChanged(newList, oldList);
        
        SWKitSalesModelRelationshipMethods.syncSalesModelsToDevicesWithSWKits(newList, oldList);
        
        ProductFamilyMethods.relateDeviceToProductFamily(newList, oldList);
    }
    
    
    
    private static void checkIfDeviceIsCancelledOrSADateChanged(List<Device__c> newList, List<Device__c> oldList){
        // tested by setMicrogenCountriesOnDeviceTest
        Set<Id> deletedORLaterSADeviceIdsForSADateCalculation = new Set<Id>();
        Set<Id> EarlierSADeviceIdsForSADateCalculation = new Set<Id>(); 
        
        for(Integer i=0; i<newList.size(); i++){
            if((newList[i].Cancelled__c == true && oldList[i].Cancelled__c == false) || (newList[i].SA_Date__c > oldList[i].SA_Date__c)){
                deletedORLaterSADeviceIdsForSADateCalculation.add(newList[i].Id);
            }
            
            if(newList[i].SA_Date__c < oldList[i].SA_Date__c){ // SA Date is earlier
                EarlierSADeviceIdsForSADateCalculation.add(newList[i].Id);
            }
        }
        
        if(!deletedORLaterSADeviceIdsForSADateCalculation.isEmpty()){ SADateMethods.devAppDeletedOrDevCancelledOrLaterDate(deletedORLaterSADeviceIdsForSADateCalculation); }
        
        if(!EarlierSADeviceIdsForSADateCalculation.isEmpty()){ SADateMethods.newDevAppOrEarlierDate(EarlierSADeviceIdsForSADateCalculation); }      
    }

    // Below method was added by Neel on 12-Mar-2013
    // This code replaces old code (which is commented and after this method) 
    private static void checkIfCountryHasBeenChanged(List<Device__c> newList, List<Device__c> oldList)
    {
        Map<String, Id> countryMap = new Map<String, Id>();
        Map<String, DeviceCountryAssoc__c> existingDevCountriesMap = new Map<String, DeviceCountryAssoc__c>();
        List<DeviceCountryAssoc__c> devCountriesToAdd = new List<DeviceCountryAssoc__c>();
        List<DeviceCountryAssoc__c> devCountriesToDelete = new List<DeviceCountryAssoc__c>();
        String key = null;
        
        
        // Get list of countries
        Country__c[] countryList = [SELECT Id, Name FROM Country__c WHERE Region__c != ''];
        
        // Build Name-Id map
        for(Country__c country : countryList)
        {
            countryMap.put(country.Name, country.Id);
        }
        
        // Get existing DeviceCountry list
        DeviceCountryAssoc__c[] dcList = [SELECT Id, Device__c, Country__c, Country__r.Name FROM DeviceCountryAssoc__c WHERE Device__c IN :oldList];
        
        // Build map of existing DeviceCountryAssoc
        for(DeviceCountryAssoc__c dc : dcList)
        {
            existingDevCountriesMap.put(dc.Device__c + '|' + dc.Country__r.Name, dc);
        }
        
        // loop through all the devices
        for(Integer i=0; i<newList.size(); i++)
        {
            // Check if Country__c value has changed. Skip in case of no change.
            if(newList[i].Country__c != oldList[i].Country__c)
            {
                // 1. Previous value was null/empty and new value of Country__c is set
                // Need to add new DeviceCountryAssoc if country name is valid
                if((oldList[i].Country__c == null || oldList[i].Country__c == '') && (newList[i].Country__c != null || newList[i].Country__c != ''))
                {
                    if(countryMap.containsKey(newList[i].Country__c))
                    {
                        // Add record to DeviceCountryAssoc 
                        devCountriesToAdd.add(new DeviceCountryAssoc__c(device__c=newList[i].Id, country__c=(Id)countryMap.get(newList[i].Country__c)));
                    }
                } 
                // 2. Country__c had value which is removed now
                // Need to remove old DeviceCountryAssoc
                else if((newList[i].Country__c == null || newList[i].Country__c == '') && (oldList[i].Country__c != null || oldList[i].Country__c != ''))
                {
                    key = oldList[i].Id + '|' + oldList[i].Country__c;
                    
                    if(existingDevCountriesMap.get(key) != null)
                    {
                        devCountriesToDelete.add(existingDevCountriesMap.get(key));
                    }
                } 
                // 3. Country__c value has changed.
                // Need to remove old DeviceCountryAssoc and add new DeviceCountryAssoc (if country name is valid)
                else if((newList[i].Country__c != null || newList[i].Country__c != '') && (oldList[i].Country__c != null || oldList[i].Country__c != ''))
                {
                    key = oldList[i].Id + '|' + oldList[i].Country__c;
                    
                    if(existingDevCountriesMap.get(key) != null)
                    {
                        devCountriesToDelete.add(existingDevCountriesMap.get(key));
                    }
                    if(countryMap.containsKey(newList[i].Country__c))
                    { 
                        devCountriesToAdd.add(new DeviceCountryAssoc__c(device__c=newList[i].Id, country__c=(Id)countryMap.get(newList[i].Country__c)));
                    }
                }
            }
        }
        
        if(!devCountriesToDelete.isEmpty()) { delete devCountriesToDelete; }

        if(!devCountriesToAdd.isEmpty()) { insert devCountriesToAdd; }
        
    }   
     
    /********* OLD METHOD - REPLACED BY NEW ONE ***************
    private static void checkIfCountryHasBeenChanged(List<Device__c> newList, List<Device__c> oldList)
    {
        // if country was blank and has changed create new devCountry record
        Map<String, Country__c> countryNameMap = new Map<String, Country__c>();
        List<DeviceCountryAssoc__c> devCountries = new List<DeviceCountryAssoc__c>();
        List<DeviceCountryAssoc__c> devCountriesToDelete = new List<DeviceCountryAssoc__c>();
        Map<String, DeviceCountryAssoc__c> existingDevCountries = new Map<String, DeviceCountryAssoc__c>();
        
        
        
        for(Integer i=0; i<newList.size(); i++)
        {
            if(newList[i].Country__c != oldList[i].Country__c)
            {
                if(countryNameMap.isEmpty())
                {
                    for(Country__c c : [SELECT Id, Name, Region__c FROM Country__c WHERE Region__c != ''])
                    {
                        countryNameMap.put(c.Name, c);
                    }
                }
                
                for(Device__c d : oldList)
                {
                    if(d.Country__c != null && existingDevCountries.isEmpty())
                    {
                        for(DeviceCountryAssoc__c dc : [SELECT Id, Device__c, Country__c, Country__r.Name FROM DeviceCountryAssoc__c WHERE Device__c IN : newList])
                        {
                            if(countryNameMap.get(dc.Country__r.Name) != null)
                            {
                                existingDevCountries.put(dc.Device__c + '' + dc.Country__r.Name, dc);
                            }
                        }
                    }
                }
                
                
                if((oldList[i].Country__c == null || oldList[i].Country__c == '') && (newList[i].Country__c != null || newList[i].Country__c != ''))
                {                   
                    if(countryNameMap.containsKey(newList[i].Country__c))
                    { 
                        devCountries.add(new DeviceCountryAssoc__c(device__c=newList[i].Id, country__c=countryNameMap.get(newList[i].Country__c).Id));
                    }
                } 
                else if((newList[i].Country__c == null || newList[i].Country__c == '') && (oldList[i].Country__c != null || oldList[i].Country__c != ''))
                {
                    if(existingDevCountries.get(oldList[i].Id + '' + oldList[i].Country__c) != null)
                    {
                        devCountriesToDelete.add(existingDevCountries.get(oldList[i].Id + '' + oldList[i].Country__c));
                    }
                } 
                else if((newList[i].Country__c != null || newList[i].Country__c != '') && (oldList[i].Country__c != null || oldList[i].Country__c != '') && (newList[i].Country__c != oldList[i].Country__c))
                {
                    if(existingDevCountries.get(oldList[i].Id + '' + oldList[i].Country__c) != null)
                    {
                        devCountriesToDelete.add(existingDevCountries.get(oldList[i].Id + '' + oldList[i].Country__c));
                    }
                    if(countryNameMap.containsKey(newList[i].Country__c))
                    { 
                        devCountries.add(new DeviceCountryAssoc__c(device__c=newList[i].Id, country__c=countryNameMap.get(newList[i].Country__c).Id));
                    }
                }
            }
        }
        
        if(!devCountries.isEmpty()){ insert devCountries; }
        
        if(!devCountriesToDelete.isEmpty()){ delete devCountriesToDelete; }
    }
    */
    
    private static void updateAllDevAppsIfSADateHasChanged(List<Id> deviceIds){
        
            //Austin's devApp workflow rules related to app Item State required that if a Devices SA Date is changed then
            //the devapps should be updated to hit the triggers/workflow
        
        List<DeviceApplicationAssoc__c> devAppsToUpdate = [SELECT Id FROM DeviceApplicationAssoc__c WHERE Device__c IN : deviceIds AND App_Item_State__c != '35 - Full Release'];
        update devAppsToUpdate;
    }
    
    /*private static void checkForChangesToIPApplicationFields(List<Device__c> newList, List<Device__c> oldList){
        List<Device__c> devicesWithUpdatedIPTechAndRegionNew = new List<Device__c>();
        List<Device__c> devicesWithUpdatedIPTechAndRegionOld = new List<Device__c>();
        
        List<Device__c> devicesWithUpdatedIPCapabilitiesNew = new List<Device__c>();
        List<Device__c> devicesWithUpdatedIPCapabilitiesOld = new List<Device__c>();
        
        List<Device__c> devicesWithUpdatedHDMICapabilitiesNew = new List<Device__c>();
        List<Device__c> devicesWithUpdatedHDMICapabilitiesOld = new List<Device__c>();
        
        for(Integer i=0; i<newList.size(); i++){
            // check to see if IP Technology & Region has changed
            if(newList[i].IP_Technology_Region__c != oldList[i].IP_Technology_Region__c){
                system.debug('IP TECH HAS CHANGED');
                devicesWithUpdatedIPTechAndRegionNew.add(newList[i]);
                devicesWithUpdatedIPTechAndRegionOld.add(oldList[i]);
            }
            
            // check to see if IP Capabilities has changed
            if(newList[i].IP_Cap__c != oldList[i].IP_Cap__c){
                devicesWithUpdatedIPCapabilitiesNew.add(newList[i]);
                devicesWithUpdatedIPCapabilitiesOld.add(oldList[i]);
            }
            
            // check to see if HDMI Capabilities has changed
            if(newList[i].IP_HDMI_Capabilities__c != oldList[i].IP_HDMI_Capabilities__c){
                devicesWithUpdatedHDMICapabilitiesNew.add(newList[i]);
                devicesWithUpdatedHDMICapabilitiesOld.add(oldList[i]);
            }
        }
        
        // if there are devices with updated IP Technology & Region fields update the related applications
        if(!devicesWithUpdatedIPTechAndRegionNew.isEmpty()){
            IPApplications.updateIPTechAndRegion(devicesWithUpdatedIPTechAndRegionNew, devicesWithUpdatedIPTechAndRegionOld);
        }
        
        // if there are devices with updated IP Capbilities fields update the related applications
        if(!devicesWithUpdatedIPCapabilitiesNew.isEmpty()){
            IPApplications.updateIPCapabilities(devicesWithUpdatedIPCapabilitiesNew, devicesWithUpdatedIPCapabilitiesOld);
        }
        
        // if there are devices with updated HDMI Capabilities update the related applications
        if(!devicesWithUpdatedHDMICapabilitiesNew.isEmpty()){
            IPApplications.updateHDMIApplications(devicesWithUpdatedHDMICapabilitiesNew, devicesWithUpdatedHDMICapabilitiesOld);
        }
    }*/
    
    // Test Method for IP Applications class
    private static testmethod void DeviceUpdateTest(){
        Device__c d = new Device__c(Name='d1', SA_Date__c = system.today());
        insert d;
        
        d.Business_Unit__c = 'Mobile Device';
        d.Audio_Playback_Codecs__c = 'mp3';
        // This should add a record to device app junction object: 'Sisvel: .mp3 *IP-S*'
        update d;
    }
    
    private static testmethod void deviceFullyApprovedLockTest(){
        SW_Kit__c swkit = new SW_Kit__c(Name='swkit', SW_Kit_Item_State__c='32 - Controlled');
        insert swkit;
        Device__c d = new Device__c(Name='testDevice', Number_of_Sales_Models__c=1, SW_Kit__c=swkit.Id, SWBOM_Reviewed_and_Approved__c='Yes', SW_BOM_List_Approver__c=UserInfo.getUserId(), Device_SW_KIT_State__c='32 - Controlled');
        insert d;
        update d;
        
        User p = [SELECT Id FROM User WHERE profileId = '00e40000000ouz3' AND isActive = true LIMIT 1];
        
        Test.startTest();
            System.runAs(p){
                d.White_Listed_Build_Fingerprint__c = 'changed text';
                try{
                    update d;
                } catch(System.DMLException e){
                    System.assert(e.getMessage().contains('One or more of the fields changed are locked due to the Device being fully approved.'));
                }
            }
        Test.stopTest();
        
    }
}