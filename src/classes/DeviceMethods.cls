public with sharing class DeviceMethods {
/*
Description: Contains methods that are called from Device triggers.
Change History:
Bineet Mishra(Jun 15, 2012): Added code to update 'Estimated_Royalty_Cost__c' field in the Device object. #INM000005784446
*/
    public static void updateAIFMatricesFromNewSWAppsLead(Map<Id, Device__c> devices){
        Map<String, User> userMap = UserMethods.getNameUserMap();
        
        List<AIF_Approval_Matrix__c > matricesToUpdate = new List<AIF_Approval_Matrix__c>();
        
        for(AIF_Approval_Matrix__c aif : [SELECT Id, Finance_Approver__c, Device_Name__c FROM AIF_Approval_Matrix__c Where Device_Name__c IN : devices.keySet()]){
            if(devices.get(aif.Device_Name__c).SW_Apps_Lead__c != null && devices.get(aif.Device_Name__c).SW_Apps_Lead__c != '' && userMap.get(devices.get(aif.Device_Name__c).SW_Apps_Lead__c) != null){
                if(aif.Finance_Approver__c != userMap.get(devices.get(aif.Device_Name__c).SW_Apps_Lead__c).Id){
                    aif.Finance_Approver__c = userMap.get(devices.get(aif.Device_Name__c).SW_Apps_Lead__c).Id;
                    matricesToUpdate.add(aif);
                }
            }
        }
        
        if(!matricesToUpdate.isEmpty()){ update matricesToUpdate; }
    }
    
    public static void findSWBOMOwnerManager(List<Device__c> newList){      
        Set<String> ownerEmails = new Set<String>();
        for(Device__c d : newList){
            ownerEmails.add(d.SWBOM_Owner_Email__c);
        }
        
        Map<String, String> ownerEmailManagerIdMap = new Map<String, String>();
        for(User owner : [SELECT Id, Email, ManagerId FROM User WHERE Email IN : ownerEmails]){
            ownerEmailManagerIdMap.put(owner.Email, owner.ManagerId);
        }
        
        for(Device__c d : newList){
            d.SW_BOM_Owner_Manager__c = ownerEmailManagerIdMap.get(d.SWBOM_Owner_Email__c);
        }       
    }
    
    private static testmethod void findSWBOMOwnerManagerTest(){
        Profile p = [select id from profile where name='Standard User'];
        User managerUser = new User(    alias = 'standt', email='managerUser@test.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='Australia/Darwin', username='managerUser@test.com');
        insert managerUser;
        User ownerUser = new User(  alias = 'standt', email='ownerUser@test.com',
                            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                            localesidkey='en_US', profileid = p.Id,
                            timezonesidkey='Australia/Darwin', username='ownerUser@test.com', managerId=managerUser.Id);
        insert ownerUser;
        Device__c d = new Device__c(Name='testD');
        insert d;
        
        Test.startTest();
            d.SWBOM_Owner_Email__c = ownerUser.Email;
            update d;
            
            d.SWBOM_Owner_Email__c = null;
            update d;
        Test.stopTest();
    }
    
    public static void validateDeviceReviewedAndApproved(List<Device__c> newList, List<Device__c> oldList){
        Map<Id, Device__c> deviceIdMap = new Map<Id, Device__c>();
        List<Id> approvedDeviceIds = new List<Id>();
        
        List<Id> stableIds = new List<Id>();
        
        for(Integer i=0; i<newList.size(); i++){
            if(newList[i].SWBOM_Reviewed_and_Approved__c == 'Yes' && newList[i].SWBOM_Reviewed_and_Approved__c != oldList[i].SWBOM_Reviewed_and_Approved__c){
                approvedDeviceIds.add(newList[i].Id);
                deviceIdMap.put(newList[i].Id, newList[i]);
                stableIds.add(newList[i].Stable__c);
            }                       
        }
        if(!stableIds.isEmpty()){
            Map<Id, Stable__c> stables = new Map<Id, Stable__c>([SELECT Id, Reviewed_Approved__c FROM Stable__c WHERE Id IN : stableIds AND Reviewed_Approved__c = 'No']);
            
            List<Program_Device__c> programDevices = [SELECT Id, Device__c, Program__r.Reviewed_Approved__c FROM Program_Device__c WHERE Device__c IN : approvedDeviceIds AND Program__r.Reviewed_Approved__c = 'No'];
            
            for(Device__c d : deviceIdMap.values()){
                if(stables.keySet().contains(d.Stable__c)){
                    d.addError('This Device cannot be approved because the stable has not been approved.');
                }
                
                for(Program_Device__c pd : programDevices){
                    if(d.Id == pd.Device__c){
                        d.addError('This Device cannot be approved because one of the programs have not been approved.');
                    }
                }
            }
        }
    }
        
    /*** CALCULATE ESTIMATED ROYALTY COST FROM DEVICE/APP ID ***/
    // Tested by CreateNewDevAppRecord.testSubmitDevAppsForApproval()
    public static void calculateEstimatedRoyaltyCost(Set<Id> deviceIds){
        Double highTotal = 0;
        Double lowTotal = 0;
        Double currentTotal = 0;
        Double highWithoutQualcomm = 0;
        
        Map<Id, List<DeviceApplicationAssoc__c>> deviceIdDevAppListMap = new Map<Id, List<DeviceApplicationAssoc__c>>();
        for(DeviceApplicationAssoc__c devApp : [SELECT id, Device__c, Royalty_High__c, Royalty_Low__c, Royalty_Current__c, Account__c, Device__r.Product_Family__c, Device__r.Skip_Budget_Approval__c FROM DeviceApplicationAssoc__c WHERE Device__c IN : deviceIds AND (Include_in_BOM__c = true OR Include_on_SD_Card__c = true) AND Device__r.Cancelled__c = false AND Device__r.Device_Fully_Approved__c = 'No']){
            List<DeviceApplicationAssoc__c> tempList = deviceIdDevAppListMap.get(devApp.Device__c);
            if(tempList == null){
                tempList = new List<DeviceApplicationAssoc__c>{devApp};
            } else {
                tempList.add(devApp);
            }
            deviceIdDevAppListMap.put(devApp.Device__c, tempList);
        }
        
        List<Device__c> devicesToUpdate = new List<Device__c>();

        for(Id devId : deviceIds){
            highTotal = 0;
            lowTotal = 0;
            currentTotal = 0;
            highWithoutQualcomm = 0;
            if(deviceIdDevAppListMap.get(devId) != null){
                for(DeviceApplicationAssoc__c devApp : deviceIdDevAppListMap.get(devId)){
                    system.debug('THIS IS devApp.Id royalty high: ' + devApp.Id + ', ' +devApp.Royalty_High__c);
                    if(devApp.Royalty_High__c != null){ highTotal += devApp.Royalty_High__c; }
                    if(devApp.Royalty_Low__c != null){ lowTotal += devApp.Royalty_Low__c; }
                    if(devApp.Royalty_Current__c != null){ currentTotal += devApp.Royalty_Current__c; } // Added as Part of #INM000005784446 
                    system.debug('THIS IS devApp.Id royalty current: ' + devApp.Id + ', ' +devApp.Royalty_Current__c);
                    if(devApp.Account__c != '0014000000Mi82b' && devApp.Royalty_High__c != null){ highWithoutQualcomm += devApp.Royalty_High__c; } // Quallcomm Account ID                                  
                }
                devicesToUpdate.add(new Device__c(Id=devId, Estimated_High_Royalty_Cost__c=highTotal, Estimated_Low_Royalty_Cost__c=lowTotal, Estimated_Current_Royalty_Cost__c=currentTotal, Estimated_High_Royalty_Cost_w_o_Qualcomm__c=highWithoutQualcomm));
            }
        }
        
        update devicesToUpdate;
    }
    
    @future
    // Tested by CreateNewDevAppRecord.testSubmitDevAppsForApproval()
    public static void calculateEstimatedRoyaltyCostFromApps(List<Id> appIds){
        Set<Id> deviceIds = new Set<Id>();
        
        Map<Id, List<DeviceApplicationAssoc__c>> deviceIdDevAppListMap = new Map<Id, List<DeviceApplicationAssoc__c>>();
        for(DeviceApplicationAssoc__c devApp : [SELECT id, Device__c FROM DeviceApplicationAssoc__c WHERE Application__c IN : appIds AND (Include_in_BOM__c = true OR Include_on_SD_Card__c = true) AND Device__r.Cancelled__c = false AND Device__r.Device_Fully_Approved__c = 'No']){
            deviceIds.add(devApp.Device__c);
            
            /*List<DeviceApplicationAssoc__c> tempList = deviceIdDevAppListMap.get(devApp.Device__c);
            if(tempList == null){
                tempList = new List<DeviceApplicationAssoc__c>{devApp};
            } else {
                tempList.add(devApp);
            }
            deviceIdDevAppListMap.put(devApp.Device__c, tempList);*/
        }
        
        //List<List<Id>> listOfIdLists = new List<List<Id>>();      
        //for(Integer i=0; i<(deviceIds.size() / 200) + 1; i++){
        //  listOfIdLists.add(new List<Id>());
        //}
        
        /*for(Integer i=0; i<deviceIds.size(); i++){
            for(Integer z=0; z<listOfIdLists.size(); z++){
                if(listOfIdLists[z].size() != 200){
                    listOfIdLists[z] = new List<Id>{deviceIds[i]}
                }
            }
        }*/
            
        
        //system.debug('THIS IS NUMBER OF DEVICES: ' + deviceIdDevAppListMap.keySet().size());
        //for(Id devId : deviceIdDevAppListMap.keySet()){
        //  system.debug('THIS IS NUMBER OF apps on device: ' + deviceIdDevAppListMap.get(devId).size());
        //}
        calculateEstimatedRoyaltyCost(deviceIds);
    }
    
    
    /*** CALCULATE SKIP BUDGET ***/
    public static void calculateSkipBudgetApproval(Set<String> productFamilies){
        List<Device__c> devicesToUpdate = new List<Device__c>();
        List<Device__c> devices = [SELECT Id, Skip_Budget_Approval__c, SA_Date__c, Estimated_High_Royalty_Cost_w_o_Qualcomm__c, Product_Family__c, SWBOM_Reviewed_and_Approved__c, Device_Fully_Approved__c, Business_Unit__c FROM Device__c WHERE Product_Family__c IN : productFamilies AND Cancelled__c = false AND Business_Unit__c != 'Companion Products' AND Product_Segment__c != 'MMCP'];
        
        Device__c leadDevice = null;
        for(String productFamily : productFamilies){
            leadDevice = null;
            for(Device__c device : devices){
                if(productFamily == device.Product_Family__c){
                    if(device.SA_Date__c != null && (leadDevice == null || leadDevice.SA_Date__c > device.SA_Date__c) && device.Business_Unit__c != 'Companion Products'){
                        leadDevice = device;
                    }
                }
            }
            
            if(leadDevice != null){
                if(leadDevice.Estimated_High_Royalty_Cost_w_o_Qualcomm__c == null){
                    calculateEstimatedRoyaltyCost(new Set<Id>{leadDevice.Id});
                    leadDevice = [SELECT Id, Skip_Budget_Approval__c, SA_Date__c, Estimated_High_Royalty_Cost_w_o_Qualcomm__c, Product_Family__c, SWBOM_Reviewed_and_Approved__c, Device_Fully_Approved__c FROM Device__c WHERE Id =: leadDevice.Id];
                }
                
                if(leadDevice.SWBOM_Reviewed_and_Approved__c == 'No' && leadDevice.Device_Fully_Approved__c == 'No'){
                    leadDevice.Skip_Budget_Approval__c = true;
                    devicesToUpdate.add(leadDevice);            
                }
                
                Double royaltyLimit;
                if(leadDevice.Estimated_High_Royalty_Cost_w_o_Qualcomm__c != null){
                    royaltyLimit = leadDevice.Estimated_High_Royalty_Cost_w_o_Qualcomm__c + (leadDevice.Estimated_High_Royalty_Cost_w_o_Qualcomm__c * .05);
                }
                else{
                    royaltyLimit = 0;
                }
                
                for(Device__c device : devices){
                    if(device.Id != leadDevice.Id){
                        if(leadDevice.Product_Family__c == device.Product_Family__c && royaltyLimit >= device.Estimated_High_Royalty_Cost_w_o_Qualcomm__c){
                            if(device.Skip_Budget_Approval__c != true && device.SWBOM_Reviewed_and_Approved__c == 'No' && device.Device_Fully_Approved__c == 'No'){
                                device.Skip_Budget_Approval__c = true;
                                devicesToUpdate.add(device);
                            }
                        }
                        else if(leadDevice.Product_Family__c == device.Product_Family__c && royaltyLimit < device.Estimated_High_Royalty_Cost_w_o_Qualcomm__c){
                            if(device.Skip_Budget_Approval__c == true && device.SWBOM_Reviewed_and_Approved__c == 'No' && device.Device_Fully_Approved__c == 'No'){
                                device.Skip_Budget_Approval__c = false;
                                devicesToUpdate.add(device);
                            }                   
                        }
                    }
                }
            }               
        }
        if(!devicesToUpdate.isEmpty()){     
            update devicesToUpdate;
        }
    }
    
    private static testmethod void validateDeviceReviewedAndApprovedTest(){
        Stable__c s = new Stable__c(Name='testStable');
        insert s;
        Program__c p = new Program__c(Name='testProgram', Reviewed_Approved__c = 'No');
        insert p;
        
        Device__c d = new Device__c(Name='testDevice', Stable__c = s.Id);
        insert d;
                
        Test.startTest();
            d.SWBOM_Reviewed_and_Approved__c = 'Yes';
            try{
                update d;
            } catch(System.DMLException e){
                System.assert(e.getMessage().contains('This Device cannot be approved because the stable has not been approved.'));
            }
            
            Program_Device__c pd = new Program_Device__c(Program__c = p.Id, Device__c = d.Id);
            insert pd;
            d.Stable__c = null;
            try{
                update d;
            } catch(System.DMLException e){
                System.assert(e.getMessage().contains('This Device cannot be approved because one of the programs have not been approved.'));
            }
        Test.stopTest();        
    }
}