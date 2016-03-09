public class CopyAppsToExistingDevicewApprovals2 {

    /*
     * Author: Jesse A
     * Creation Date: 
     * Description: Copies approved device apps records from the source device to the
     *              target device.
     * Change history:
     *   Date: 14-Jun-2012  Author: Rajesh Krishnaiah
     *   Description: Fixed a bug that was copying only one occurance of a dev app record to the target
     *                device ignoring the other occurances. Also removed the logic that was not copying
     *                apps from source to target if the target already had that app.
     *
     *   Date: 24-Jan-2012   Author: Jesse A
     *   Description: If copying from a device where some devApps are still In Progress, do not copy them as 
     *           Approved, rather reset and resubmit them.     
     */

    public Device__c OriginalDevice {get; set;}
    public Device__c DestinationDevice;
    
    public Boolean showError {get; set;}
    public String ErrorMessage {get; set;}
    
    List<DeviceapplicationAssoc__c> devAppstoAdd = new List<DeviceapplicationAssoc__c>();
    List<DeviceapplicationAssoc__c> devAppstoAddAndSubmit = new List<DeviceapplicationAssoc__c>();
    Set<Id> appIdsAlreadyOnCopiedDevice = new Set<Id>();
    //Map<Id, DeviceApplicationAssoc__c> appsOnOriginalDeviceAvailableForUseMap = new Map<Id, DeviceApplicationAssoc__c>();
    
    List<DeviceApplicationAssoc__c> devAppsOnOriginalDeviceAvailableForUse
        = new List<DeviceApplicationAssoc__c>();
        
    public List<Application__c> appsNotAvailableForUse = new List<Application__c>();

    public Boolean additionalCheckRequired = false;
    public List<Profile> profiles = [SELECT id FROM Profile 
        WHERE name NOT IN ('MotoDev - SysAdmin', 'MotoDev - MotoReady Admin') ORDER BY Name];
    public Map<Id, Profile> profileIdMap = new Map<Id, Profile>(
        [SELECT id FROM Profile 
        WHERE name NOT IN ('MotoDev - SysAdmin', 'MotoDev - MotoReady Admin') ORDER BY Name]);
   
    public List<Application__c> getappsNotAvailableForUse(){
        return appsNotAvailableForUse;
    }
    
    public Boolean getshowAppsNotAvailable(){
        if(!appsNotAvailableForUse.isEmpty()){
            return true;
        }
        return false;
    }
    
    /** CODE FOR POP-UP
    public Boolean displayPopup {get; set;}
 
    public void closePopup() {
        system.debug('BEFORE CLOSE DISPLAY');
        displayPopup = false;
        system.debug('AFTER CLOSE DISPLAY');
    }
 
    public void showPopup() {
        if(CopiedDevice == null){
            displayPopup = true;            
        }
    }    
    **/
    
    public CopyAppsToExistingDevicewApprovals2(ApexPages.StandardController controller) {
        showError = false;
        
        OriginalDevice = [SELECT Id, Name, Android_Release__c, Country__c, Product_Family__c,
            Destination_Device__c, Core_Device_Package__c, Stable__c 
            FROM Device__c 
            WHERE Id =: controller.getId()];
        
        for(DeviceApplicationAssoc__c da : 
            [select Device__c,Application__c, Application__r.Name, Application__r.Available_For_Use__c, 
                AcctOwner__r.Name, lrb_approval__c, dts_approval__c, Application_Mgr_Selection_Approval__c,
                Confirmation_of_Budget_Royalties__c, FMD_Status_Approval__c, Partner_Manager_Checklist_Approval__c, 
                Requester_Approval__c, Conditional_Approval_Details__c, Approval_Status__c, DTS_Support__c, 
                Include_in_BOM__c, Include_on_SD_Card__c, Specific_Requirements__c, Device_Feature_ID__c,
                FMD_State__c, Application_Manager__c, Past_LRB_Approval__c, Past_SDS_Approval__c, 
                Past_App_Mgr_Approval__c, Past_Budget_Approval__c, Past_Partner_Manager_Approval__c,
                Source_Id__c, Source_Name__c, Application_Source_Id__c
            from DeviceApplicationAssoc__c
            WHERE Device__c =:OriginalDevice.ID AND isDeleted = false]){
                
            if(da.Application__r.Available_For_Use__c != false){
                //appsOnOriginalDeviceAvailableForUseMap.put(da.Application__c, da);
                devAppsOnOriginalDeviceAvailableForUse.add(da);
            } else {
                appsNotAvailableForUse.add(new Application__c(Id=da.Application__c, 
                    Name=da.Application__r.Name, Description__c=da.AcctOwner__r.Name));
            }
        }
    }

    public pagereference copyapps(){
        system.debug('THIS IS UserInfo.getProfileId' + UserInfo.getProfileId());

        //Check to see if user profile requires extra checks
        system.debug('START copyapps');
        
        try{
            DestinationDevice = [SELECT Id, Android_Release__c, Country__c, Product_Family__c 
                                FROM Device__c WHERE Id =: OriginalDevice.Destination_Device__c];
        } catch(System.QueryException e){
            ErrorMessage = 'There is no destination device selected.';
            showError = true;
        }
        
        // Check to see if DestinationDevice doesnt have matrices
        List<AIF_Approval_Matrix__c> aifList = [SELECT Id, DTS_Approver__c, Finance_Approver__c, LRB_Approver__c
                                                FROM AIF_Approval_Matrix__c 
                                                WHERE Device_Name__c =: DestinationDevice.Id];
        List<Application_Manager_Selection_Matrix__c> amsmList = 
            [SELECT Id, Application_Manager__c 
            FROM Application_Manager_Selection_Matrix__c 
            WHERE Device__c =: DestinationDevice.Id];
    
        if(aifList.size() != 1 || 
                (aifList[0].DTS_Approver__c == null || aifList[0].Finance_Approver__c == null || 
                aifList[0].LRB_Approver__c == null)){
            ErrorMessage = 'The Device you are trying to copy apps to is missing or has ' +
                            'an incomplete AIF matrix. Please correct before continuing.';
            showError = true;
        }       
        if(amsmList.size() != 3 || 
            (amsmList[0].Application_Manager__c == null || 
            amsmList[1].Application_Manager__c == null || 
            amsmList[2].Application_Manager__c == null)){
            ErrorMessage = 'The Device you are trying to copy apps to is missing or has an incomplete ' +
                        'Application Manager Selection matrix. Please correct before continuing.';
            showError = true;
        }       
        system.debug('PAST MATRIX CHECK');      
        // Check if DestinationDevice already has applications, show error
        if([SELECT count() FROM DeviceApplicationAssoc__c 
            WHERE Device__c =: DestinationDevice.Id AND CreatedById != '005400000013EXdAAM'] > 0){
            ErrorMessage = 'The Destination Device selected already has Applications associated to it.';
            showError = true;
        }
        system.debug('PAST EXISTING APP CHECK');   
         // create list of profiles that do NOT require extra checks
        
        system.debug('THIS IS UserInfo.getProfileId' + UserInfo.getProfileId());    
        if(UserInfo.getProfileId() != '00e40000000oqQ9AAI' && UserInfo.getProfileId() != '00e40000000oqznAAA'){
            //the userprofile matches that of one that requires additional checks
            additionalCheckRequired = true;     
            
            if((OriginalDevice.Android_Release__c != null && DestinationDevice.Android_Release__c != null) && 
               (OriginalDevice.Android_Release__c != DestinationDevice.Android_Release__c)){
                ErrorMessage = 'The field Release does not match between the two selected devices.';
                showError = true;
            }
            else if(OriginalDevice.Android_Release__c == null || DestinationDevice.Android_Release__c == null){
                ErrorMessage = 'The field Release is blank on at least one of the selected devices.';
                showError = true;
            }
            system.debug('original/copied: ' + OriginalDevice.Country__c + '/' + DestinationDevice.Country__c);
            system.debug('PAST RELEASE CHEC'); 
            
            if((OriginalDevice.Country__c != null && DestinationDevice.Country__c != null) && 
              (OriginalDevice.Country__c != DestinationDevice.Country__c)){ 
                
                ErrorMessage = 'The field Country does not match between the two selected devices.';
                showError = true;
            }
            else if(OriginalDevice.Country__c == null || DestinationDevice.Country__c == null){
                if(DestinationDevice.Country__c == null) {system.debug('DestinationDevice.Country is null');}
                ErrorMessage = 'The field Country is blank on at least one of the selected devices.';
                showError = true;
            }
            system.debug('PAST COUNTRY CHECK'); 
            if((OriginalDevice.Product_Family__c != null && DestinationDevice.Product_Family__c != null) && 
              (OriginalDevice.Product_Family__c != DestinationDevice.Product_Family__c)){
                ErrorMessage = 'The field Product Family does not match between the two selected devices.';
                showError = true;
            }
            else if(OriginalDevice.Product_Family__c == null || DestinationDevice.Product_Family__c == null){
                ErrorMessage = 'The field Product Family is blank on at least one of the selected devices.';
                showError = true;
            }
            system.debug('PAST PRODUCT FAMILY'); 
        }
        
        if(showError == true){
            return null;
        }

        system.debug('PAST FIELD CHECKS');

        //*************************************************Device Applications***********************************************************************
    
        system.debug('LOOK FOR DEVAPPS');
        
        for(DeviceApplicationAssoc__c devAppAlreadyOnCopiedDevice : [SELECT Id, Device__c, Application__c 
        FROM DeviceApplicationAssoc__c
        WHERE Device__c =: DestinationDevice.Id AND isDeleted = false]){
            appIdsAlreadyOnCopiedDevice.add(devAppAlreadyOnCopiedDevice.Application__c);
        }
        
        
        // for(Id appId : appsOnOriginalDeviceAvailableForUseMap.keySet()){
        for (DeviceApplicationAssoc__c originalDevApp : devAppsOnOriginalDeviceAvailableForUse) {
            // 14-Jun-2012: Brian Chiang requested to remove this check for duplicates
            // if(!appIdsAlreadyOnCopiedDevice.contains(appId)){
                if(originalDevApp.Approval_Status__c == 'Approved'){
                    
                    devAppstoAdd.add(new DeviceApplicationAssoc__c(device__c = DestinationDevice.Id,
                        Application__c = originalDevApp.Application__c,
                        lrb_approval__c = originalDevApp.lrb_approval__c, 
                        dts_approval__c = originalDevApp.dts_approval__c, 
                        Application_Mgr_Selection_Approval__c = originalDevApp.Application_Mgr_Selection_Approval__c, 
                        Confirmation_of_Budget_Royalties__c = originalDevApp.Confirmation_of_Budget_Royalties__c, 
                        FMD_Status_Approval__c = originalDevApp.FMD_Status_Approval__c,
                        Partner_Manager_Checklist_Approval__c = originalDevApp.Partner_Manager_Checklist_Approval__c, 
                        Requester_Approval__c = originalDevApp.Requester_Approval__c, 
                        Conditional_Approval_Details__c = originalDevApp.Conditional_Approval_Details__c, 
                        Approval_Status__c = originalDevApp.Approval_Status__c, 
                        DTS_Support__c = originalDevApp.DTS_Support__c, 
                        Include_in_BOM__c = originalDevApp.Include_in_BOM__c, 
                        Include_on_SD_Card__c = originalDevApp.Include_on_SD_Card__c, 
                        Specific_Requirements__c = originalDevApp.Specific_Requirements__c, 
                        Device_Feature_ID__c = originalDevApp.Device_Feature_ID__c, 
                        FMD_State__c = originalDevApp.FMD_State__c, 
                        Application_Manager__c = originalDevApp.Application_Manager__c,
                        Past_LRB_Approval__c = originalDevApp.Past_LRB_Approval__c, 
                        Past_SDS_Approval__c = originalDevApp.Past_SDS_Approval__c, 
                        Past_App_Mgr_Approval__c = originalDevApp.Past_App_Mgr_Approval__c, 
                        Past_Budget_Approval__c = originalDevApp.Past_Budget_Approval__c, 
                        Past_Partner_Manager_Approval__c = originalDevApp.Past_Partner_Manager_Approval__c,
                        Source_Id__c = originalDevApp.Source_Id__c,
                        Application_Source_Id__c = originalDevApp.Application_Source_Id__c,
                        Source_Name__c = originalDevApp.Source_Name__c));
                        
                } else {
                    devAppstoAddAndSubmit.add(new DeviceApplicationAssoc__c(device__c = DestinationDevice.Id,
                            Application__c = originalDevApp.Application__c, 
                            Approval_Status__c = 'Not Submitted',
                            Include_in_BOM__c = originalDevApp.Include_in_BOM__c,
                            Source_Id__c = originalDevApp.Source_Id__c,
                            Application_Source_Id__c = originalDevApp.Application_Source_Id__c,
                            Source_Name__c = originalDevApp.Source_Name__c));
                }               
            //}
        }
        
        system.debug('Submit DevApps that need 3rd party approval');
        // insert apps that were already approved
        // submit any of the ones that require 3rd party approval
        if(!devAppstoAdd.isEmpty()){
            DestinationDevice.Applications_Copied_From__c = OriginalDevice.ID;
            DestinationDevice.applications_copied__c = System.NOW();
            // Rajesh: 20-Jun-2012: Add the 2 lines below per Brian Chiang's request
            DestinationDevice.Core_Device_Package__c = OriginalDevice.Core_Device_Package__c;
            DestinationDevice.Stable__c = OriginalDevice.Stable__c;
            update DestinationDevice;
             
            insert devAppstoAdd;
            
            List<DeviceApplicationAssoc__c> newDevAppsRequiring3rdPartyApproval = 
                [SELECT Id, X3rd_Party_Approval_Required__c, X3rd_Party_Approval_Status__c 
                FROM DeviceApplicationAssoc__c 
                WHERE Device__c =: DestinationDevice.Id 
                AND X3rd_Party_Approval_Required__c = true 
                AND X3rd_Party_Approval_Status__c = 'In Progress']; 

            for(DeviceApplicationAssoc__c da : newDevAppsRequiring3rdPartyApproval){
                // Create an approval request for the DevApp  

                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                //req.setComments('Submitting request for approval.');
                req.setObjectId(da.Id);
                
                try{
                    // Submit the approval request for the account              
                    Approval.ProcessResult result = Approval.process(req);
                    
                    // Verify the result            
                    system.assert(result.isSuccess());
                }
                catch(System.DmlException e){
                    ErrorMessage = 'The new DeviceApplications have been created but one or ' +
                            'more of them that need to be re-submitted for 3rd Party Approval ' +
                            'could not be automatically re-submitted and must be done manually.';
                    showError = true;
                    return ApexPages.CurrentPage();
                }           
            }
        }
        
        system.debug('Submit DevApps that need to be resubmited because they were in mid approval');
        // insert and submit the devapps that were not already approved
        if(!devAppstoAddAndSubmit.isEmpty()){
            insert devAppstoAddAndSubmit;
            
            for(DeviceApplicationAssoc__c da : devAppstoAddAndSubmit){
                if (da.Include_in_BOM__c == true) {
                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                    //req.setComments('Submitting request for approval.');
                    req.setObjectId(da.Id);
                    
                    try{
                        // Submit the approval request for the account              
                        Approval.ProcessResult result = Approval.process(req);
                        
                        // Verify the result            
                        system.assert(result.isSuccess());
                    }
                    catch(System.DmlException e){
                        ErrorMessage = 'The new DeviceApplications have been created but one or ' +
                                    ' more of them that need to be re-submitted could not be ' +
                                    ' automatically re-submitted and must be done manually.';
                        showError = true;
                        return ApexPages.CurrentPage();
                    }  
                }
            }
        }

        PageReference DestinationPage = new pagereference('/'+OriginalDevice.Destination_Device__c+'?returl=/'+OriginalDevice.ID);
        System.Debug(OriginalDevice.Destination_Device__c + '**********Destination Device**********');
        return DestinationPage;
    }

    /************* ADDED BY JESSE *************/
    public static testmethod void CopyAppsToExistingDevicewApprovals2Test() { // to test the code added by Jesse
        User datafeed = [SELECT ID From User Where name = 'Automated Data Feed'];
        Device__c DevA = new Device__c(name='DevA', Android_Release__c='valA', Country__c='valA', Product_Family__c='valA');        
        Device__c DevB = new Device__c(name='DevB', Android_Release__c='valA', Country__c='valB', Product_Family__c='valA');
        List<Device__c> devices = new List<Device__c>();
        devices.add(devA);
        devices.add(devB);
        System.runAs(datafeed){
            insert devices;
            devA.Destination_Device__c = devB.Id;
            update DevA;

        }
        
        Account acc = new Account(Name='account');
        insert acc;
        
        List<Application__c> apps = new List<Application__c>{new Application__c(Name='App1', application_type__c = 'Embedded', 
                            X3rd_Party_Approval_Required__c=true, Account__c=acc.Id, 
                            Available_For_Use__c=true)};
        insert apps;
        DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c(Device__c=devA.Id, Application__c=apps[0].Id);
        insert devApp;

        AIF_Approval_Matrix__c aif = [SELECT Id, DTS_Approver__c, Finance_Approver__c, LRB_Approver__c 
            FROM AIF_Approval_Matrix__c 
            WHERE Device_Name__c =: devB.Id];
        Application_Manager_Selection_Matrix__c amsm = [SELECT Id, Application_Manager__c 
        FROM Application_Manager_Selection_Matrix__c 
        WHERE Device__c =: devB.Id LIMIT 1];
        update amsm;
        // Instantiate controller
        Apexpages.StandardController stanCon = new Apexpages.standardController(DevA);
        
        // Instantiate page
        PageReference pr = Page.CopyAppsToExistingDevicewApprovals2;
        pr.getParameters().put('id', DevA.id);
        test.setCurrentPage(pr);
        CopyAppsToExistingDevicewApprovals2 testPage = new CopyAppsToExistingDevicewApprovals2(stanCon);
        
        // call accessory methods    
        Boolean test1 = testPage.showError;
        String test2 = testPage.ErrorMessage;
        
        User a = [SELECT Id FROM User WHERE isActive = true AND name NOT IN ('MotoDev - MotoReady Admin', 'MotoDev - SysAdmin') LIMIT 1];
        testPage.CopyApps();
        
        System.runAs(datafeed){
            testPage.CopyApps();        
        }
        
        aif.LRB_Approver__c=null;
        update aif;
        System.runAs(a){
            testPage.CopyApps();        
        }

        //aif.LRB_Approver__c=aif.DTS_Approver__c;
        //update aif;
        /*amsm.Application_Manager__c = null;
        update amsm;
        System.runAs(a){
            testPage.CopyApps();        
        }*/
        //amsm.Application_Manager__c = aif.DTS_Approver__c;
        //update amsm;      
        
        // test Android_Release__c field checks
        //DevB.Android_Release__c = '';
        //update DevB;
        //System.runAs(a){
        //    testPage.CopyApps();        
        //}
       /* DevB.Android_Release__c = null;
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Android_Release__c = 'valA';
       */         
        // test Country__c field checks
 /*       DevB.Country__c = 'valB';
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }       
        DevB.Country__c = null;
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Country__c = 'valA';

        // test Product_Family__c field checks
        DevB.Product_Family__c = 'valB';
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Product_Family__c = null;
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Product_Family__c = 'valA';
        update devB;    
        
        System.runAs(a){
            testPage.CopyApps();        
        }   */    
                
    }
    
    
    public static testmethod void CopyAppsToExistingDevicewApprovals2Test2() { // to test the code added by Jesse
        User datafeed = [SELECT ID From User Where name = 'Automated Data Feed'];
        Device__c DevA = new Device__c(name='DevA', Android_Release__c='valA', Country__c='valA', Product_Family__c='valA');        
        Device__c DevB = new Device__c(name='DevB', Android_Release__c='valA', Country__c='valA', Product_Family__c='valA');
        List<Device__c> devices = new List<Device__c>();
        devices.add(devA);
        devices.add(devB);
        System.runAs(datafeed){
            insert devices;
            devA.Destination_Device__c = devB.Id;
            update DevA;
        }
        
        Account acc = new Account(Name='account');
        insert acc;
        
        List<Application__c> apps = new List<Application__c>{
            new Application__c(Name='App1', application_type__c = 'Embedded', 
            X3rd_Party_Approval_Required__c=true, Account__c=acc.Id, Available_For_Use__c=true)};
        insert apps;
        DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c(Device__c=devA.Id, Application__c=apps[0].Id);
        insert devApp;

        //AIF_Approval_Matrix__c aif = [SELECT Id, DTS_Approver__c, Finance_Approver__c, LRB_Approver__c FROM AIF_Approval_Matrix__c WHERE Device_Name__c =: devB.Id];
        //Application_Manager_Selection_Matrix__c amsm = [SELECT Id, Application_Manager__c FROM Application_Manager_Selection_Matrix__c WHERE Device__c =: devB.Id LIMIT 1];
        //update amsm;
        // Instantiate controller
        Apexpages.StandardController stanCon = new Apexpages.standardController(DevA);
        
        // Instantiate page
        PageReference pr = Page.CopyAppsToExistingDevicewApprovals2;
        pr.getParameters().put('id', DevA.id);
        test.setCurrentPage(pr);
        CopyAppsToExistingDevicewApprovals2 testPage = new CopyAppsToExistingDevicewApprovals2(stanCon);
        
        // call accessory methods    
        Boolean test1 = testPage.ShowError;
        String test2 = testPage.ErrorMessage;
        
        User a = [SELECT Id FROM User WHERE isActive = true AND name NOT IN ('MotoDev - MotoReady Admin', 'MotoDev - SysAdmin') LIMIT 1];
       /* testPage.CopyApps();
        
        System.runAs(datafeed){
            testPage.CopyApps();        
        }
        
        aif.LRB_Approver__c=null;
        update aif;
        System.runAs(a){
            testPage.CopyApps();        
        }

        aif.LRB_Approver__c=aif.DTS_Approver__c;
        update aif;
        amsm.Application_Manager__c = null;
        update amsm;
        System.runAs(a){
            testPage.CopyApps();        
        }
        amsm.Application_Manager__c = aif.DTS_Approver__c;
        update amsm;        
        
        // test Android_Release__c field checks
        DevB.Android_Release__c = 'valB';
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Android_Release__c = null;
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Android_Release__c = 'valA';
      */          
        // test Country__c field checks
        DevB.Country__c = 'valB';
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }       
        //DevB.Country__c = null;
       // update DevB;
        //System.runAs(a){
        //    testPage.CopyApps();        
        //}
        //DevB.Country__c = 'valA';

        // test Product_Family__c field checks
       /* DevB.Product_Family__c = 'valB';
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Product_Family__c = null;
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Product_Family__c = 'valA';
        update devB;    
        
        System.runAs(a){
            testPage.CopyApps();        
        }   */   
                
    }
    
    public static testmethod void CopyAppsToExistingDevicewApprovals2Test3() { // to test the code added by Jesse
        User datafeed = [SELECT ID From User Where name = 'Automated Data Feed'];
        Device__c DevA = new Device__c(name='DevA', Android_Release__c='valA', Country__c='valA', Product_Family__c='valA');        
        Device__c DevB = new Device__c(name='DevB', Android_Release__c='valA', Country__c='valA', Product_Family__c='valA');
        List<Device__c> devices = new List<Device__c>();
        devices.add(devA);
        devices.add(devB);
        System.runAs(datafeed){
            insert devices;
            devA.Destination_Device__c = devB.Id;
            update DevA;

        }
        
        Account acc = new Account(Name='account');
        insert acc;
        
        List<Application__c> apps = new List<Application__c>{new Application__c(Name='App1', application_type__c = 'Embedded',
        X3rd_Party_Approval_Required__c=true, Account__c=acc.Id, Available_For_Use__c=true)};
        insert apps;
        DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c(Device__c=devA.Id, Application__c=apps[0].Id);
        insert devApp;

        //AIF_Approval_Matrix__c aif = [SELECT Id, DTS_Approver__c, Finance_Approver__c, LRB_Approver__c FROM AIF_Approval_Matrix__c WHERE Device_Name__c =: devB.Id];
        //Application_Manager_Selection_Matrix__c amsm = [SELECT Id, Application_Manager__c FROM Application_Manager_Selection_Matrix__c WHERE Device__c =: devB.Id LIMIT 1];
        //update amsm;
        // Instantiate controller
        Apexpages.StandardController stanCon = new Apexpages.standardController(DevA);
        
        // Instantiate page
        PageReference pr = Page.CopyAppsToExistingDevicewApprovals2;
        pr.getParameters().put('id', DevA.id);
        test.setCurrentPage(pr);
        CopyAppsToExistingDevicewApprovals2 testPage = new CopyAppsToExistingDevicewApprovals2(stanCon);
        
        // call accessory methods    
        Boolean test1 = testPage.ShowError;
        String test2 = testPage.ErrorMessage;
        
        User a = [SELECT Id FROM User WHERE isActive = true AND name NOT IN ('MotoDev - MotoReady Admin', 'MotoDev - SysAdmin') LIMIT 1];
       /* testPage.CopyApps();
        
        System.runAs(datafeed){
            testPage.CopyApps();        
        }
        
        aif.LRB_Approver__c=null;
        update aif;
        System.runAs(a){
            testPage.CopyApps();        
        }

        aif.LRB_Approver__c=aif.DTS_Approver__c;
        update aif;
        amsm.Application_Manager__c = null;
        update amsm;
        System.runAs(a){
            testPage.CopyApps();        
        }
        amsm.Application_Manager__c = aif.DTS_Approver__c;
        update amsm;        
        
        // test Android_Release__c field checks
        DevB.Android_Release__c = 'valB';
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Android_Release__c = null;
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Android_Release__c = 'valA';
               
        // test Country__c field checks
        DevB.Country__c = 'valB';
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }       
        DevB.Country__c = null;
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
        DevB.Country__c = 'valA';
    */
        // test Product_Family__c field checks
        DevB.Product_Family__c = 'valB';
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }
       /* DevB.Product_Family__c = null;
        update DevB;
        System.runAs(a){
            testPage.CopyApps();        
        }*/
       /* DevB.Product_Family__c = 'valA';
        update devB;    
        
        System.runAs(a){
            testPage.CopyApps();        
        } */     
                
    }
    
    /************* END ADDED BY JESSE *************/  

}



/*
    public pagereference validateDevices(){
        system.debug('THIS IS UserInfo.getProfileId' + UserInfo.getProfileId());

        //Check to see if user profile requires extra checks
        system.debug('START copyapps');
        
        try{
            DestinationDevice = [SELECT Id, Android_Release__c, Country__c, Product_Family__c FROM Device__c WHERE Id =: OriginalDevice.Destination_Device__c];
        } catch(System.QueryException e){
            ErrorMessage = 'There is no destination device selected.';
            showError = true;
        }
        
        // Check to see if DestinationDevice doesnt have matrices
        List<AIF_Approval_Matrix__c> aifList = [SELECT Id, DTS_Approver__c, Finance_Approver__c, LRB_Approver__c  FROM AIF_Approval_Matrix__c WHERE Device_Name__c =: DestinationDevice.Id];
        List<Application_Manager_Selection_Matrix__c> amsmList = [SELECT Id, Application_Manager__c FROM Application_Manager_Selection_Matrix__c WHERE Device__c =: DestinationDevice.Id];
    
        if(aifList.size() != 1 || (aifList[0].DTS_Approver__c == null || aifList[0].Finance_Approver__c == null || aifList[0].LRB_Approver__c == null)){
            ErrorMessage = 'The Device you are trying to copy apps to is missing or has an incomplete AIF matrix. Please correct before continuing.';
            showError = true;
        }       
        if(amsmList.size() != 3 || (amsmList[0].Application_Manager__c == null || amsmList[1].Application_Manager__c == null || amsmList[2].Application_Manager__c == null)){
            ErrorMessage = 'The Device you are trying to copy apps to is missing or has an incomplete Application Manager Selection matrix. Please correct before continuing.';
            showError = true;
        }       
        system.debug('PAST MATRIX CHECK');      
        // Check if DestinationDevice already has applications, show error
        if([SELECT count() FROM DeviceApplicationAssoc__c WHERE Device__c =: DestinationDevice.Id AND CreatedById != '005400000013EXdAAM'] > 0){
            ErrorMessage = 'The Destination Device selected already has Applications associated to it.';
            showError = true;
        }
        system.debug('PAST EXISTING APP CHECK');   
         // create list of profiles that do NOT require extra checks
        
        system.debug('THIS IS UserInfo.getProfileId' + UserInfo.getProfileId());
        //for(Integer z=0; z<profiles.size(); z++){
            //system.debug('THIS IS profile.get(z)' + profiles.get(z).Id);
            if(UserInfo.getProfileId() != '00e40000000oqQ9AAI' && UserInfo.getProfileId() != '00e40000000oqznAAA'){
            //if(profileIdMap.keySet().contains(UserInfo.getProfileId())){
            //if(UserInfo.getProfileId() == profiles.get(z).Id){
                //the userprofile matches that of one that requires additional checks
                additionalCheckRequired = true;     
                
                if((OriginalDevice.Android_Release__c != null && DestinationDevice.Android_Release__c != null) && (OriginalDevice.Android_Release__c != DestinationDevice.Android_Release__c)){
                    ErrorMessage = 'The field Release does not match between the two selected devices.';
                    showError = true;
                }
                else if(OriginalDevice.Android_Release__c == null || DestinationDevice.Android_Release__c == null){
                    ErrorMessage = 'The field Release is blank on at least one of the selected devices.';
                    showError = true;
                }
                system.debug('original/copied: ' + OriginalDevice.Country__c + '/' + DestinationDevice.Country__c);
                system.debug('PAST RELEASE CHEC'); 
                
                if((OriginalDevice.Country__c != null && DestinationDevice.Country__c != null) && (OriginalDevice.Country__c != DestinationDevice.Country__c)){ 
                    
                    ErrorMessage = 'The field Country does not match between the two selected devices.';
                    showError = true;
                }
                else if(OriginalDevice.Country__c == null || DestinationDevice.Country__c == null){
                    if(DestinationDevice.Country__c == null) {system.debug('DestinationDevice.Country is null');}
                    ErrorMessage = 'The field Country is blank on at least one of the selected devices.';
                    showError = true;
                }
                system.debug('PAST COUNTRY CHECK'); 
                if((OriginalDevice.Product_Family__c != null && DestinationDevice.Product_Family__c != null) && (OriginalDevice.Product_Family__c != DestinationDevice.Product_Family__c)){
                    ErrorMessage = 'The field Product Family does not match between the two selected devices.';
                    showError = true;
                }
                else if(OriginalDevice.Product_Family__c == null || DestinationDevice.Product_Family__c == null){
                    ErrorMessage = 'The field Product Family is blank on at least one of the selected devices.';
                    showError = true;
                }
                system.debug('PAST PRODUCT FAMILY'); 
            }
        //}
        system.debug('PAST FIELD CHECKS');
        
    }
    */