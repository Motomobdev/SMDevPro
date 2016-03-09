public class CopyAppsToExistingDevice{

    /*
     * Author: Jesse A
     * Creation Date: 
     * Description: Copies device apps records from the source device to the target device.
     * Change history:
     *   Date: 14-Jun-2012  Author: Rajesh Krishnaiah
     *   Description: Fixed a bug that was copying only one occurance of a dev app record to the target
     *                ignoring the other occurances. Also removed the logic that was NOT copying
     *                apps from source to target if the target already had that app.
     */

    public Device__c OriginalDevice {get; set;}
    private Device__c DestinationDevice;
    
    public Boolean showError {get; set;}
    public String ErrorMessage {get; set;}
    
    List<DeviceapplicationAssoc__c> devAppstoAdd = new List<DeviceapplicationAssoc__c>();
    Set<Id> appIdsAlreadyOnCopiedDevice = new Set<Id>();
//    Map<Id, DeviceApplicationAssoc__c> appIdsOnOriginalDeviceAvailableForUseIncludeInBomMap = 
//            new Map<Id, DeviceApplicationAssoc__c>();
    List<DeviceApplicationAssoc__c> devAppsOnOriginalDeviceAvailableForUse
        = new List<DeviceApplicationAssoc__c>();
    private List<Application__c> appsNotAvailableForUse = new List<Application__c>();
            
    public List<Application__c> getappsNotAvailableForUse(){
        return appsNotAvailableForUse;
    }
    
    public Boolean getshowAppsNotAvailable(){
        if(!appsNotAvailableForUse.isEmpty()){
            return true;
        }
        return false;
    }

    public CopyAppsToExistingDevice(ApexPages.StandardController controller) {
        OriginalDevice = [SELECT Id, Name, Android_Release__c, Country__c, 
                              Product_Family__c, Destination_Device__c,
                              Core_Device_Package__c, Stable__c 
                          FROM Device__c
                          WHERE Id =: controller.getId()];

        for(DeviceApplicationAssoc__c da : [select Device__c,Application__c, Application__r.Name, 
                                                Application__r.Available_For_Use__c, AcctOwner__r.Name, 
                                                Include_in_BOM__c, Source_Id__c, Source_Name__c,
                                                Application_Source_Id__c
                                            from DeviceApplicationAssoc__c
                                            WHERE Device__c =:OriginalDevice.Id  
                                            AND isDeleted = false]){
            if(da.Application__r.Available_For_Use__c != false){
                //appIdsOnOriginalDeviceAvailableForUseIncludeInBomMap.put(da.Application__c, da);
                devAppsOnOriginalDeviceAvailableForUse.add(da);
            } else {
                appsNotAvailableForUse.add(
                    new Application__c(Id = da.Application__c,
                                       Name = da.Application__r.Name,
                                       Description__c = da.AcctOwner__r.Name));
            }
        }
    }

    public pagereference copyapps(){ 
        showError = false;
        system.debug('THIS IS DESTINATIONID: ' + OriginalDevice.Destination_Device__c);
        
        try {
            DestinationDevice = [SELECT Id, Android_Release__c, Country__c, Product_Family__c,
                                     Applications_Copied_From__c, applications_copied__c 
                                 FROM Device__c
                                 WHERE Id =: OriginalDevice.Destination_Device__c];
        } catch(System.QueryException e){
            ErrorMessage = 'There is no destination device selected.';
            showError = true;
            return null;
        }
        
        for(DeviceApplicationAssoc__c devAppAlreadyOnCopiedDevice : [SELECT Id, Device__c, Application__c 
                                                                     FROM DeviceApplicationAssoc__c 
                                                                     WHERE Device__c =: DestinationDevice.Id 
                                                                     AND isDeleted = false]){
            appIdsAlreadyOnCopiedDevice.add(devAppAlreadyOnCopiedDevice.Application__c);
        }
    
        // Check to see if destinationDevice doesnt have matrices
        List<AIF_Approval_Matrix__c> aifList = [SELECT Id, DTS_Approver__c, Finance_Approver__c, 
                                                LRB_Approver__c  
                                                FROM AIF_Approval_Matrix__c 
                                                WHERE Device_Name__c =: DestinationDevice.Id];

        List<Application_Manager_Selection_Matrix__c> amsmList = [SELECT Id, Application_Manager__c 
                                                                  FROM Application_Manager_Selection_Matrix__c 
                                                                  WHERE Device__c =: DestinationDevice.Id];
    
        if(aifList.size() != 1 || (aifList[0].DTS_Approver__c == null || 
                                   aifList[0].Finance_Approver__c == null || 
                                   aifList[0].LRB_Approver__c == null)){
            ErrorMessage = 'The Device you are trying to copy apps to is missing ' +
                            'or has an incomplete AIF matrix. Please correct before continuing.';
            showError = true;
            return null;
        }       
        if(amsmList.size() != 3 || (amsmList[0].Application_Manager__c == null || 
                                    amsmList[1].Application_Manager__c == null || 
                                    amsmList[2].Application_Manager__c == null)){
            ErrorMessage = 'The Device you are trying to copy apps to is missing ' +
                            'or has an incomplete Application Manager Selection matrix. ' +
                            'Please correct before continuing.';
            showError = true;
            return null;
        } 
        
        //for(Id appid : appIdsOnOriginalDeviceAvailableForUseIncludeInBomMap.keySet()) {
        for (DeviceApplicationAssoc__c originalDevApp : devAppsOnOriginalDeviceAvailableForUse) {
            // 14-Jun-2012: Brian Chiang asked me to remove this check for duplicates
            // if(!appIdsAlreadyOnCopiedDevice.contains(originalDevApp.application__c)) {
                // DeviceApplicationAssoc__c originalDevApp = appIdsOnOriginalDeviceAvailableForUseIncludeInBomMap.get(appId);

                devAppstoAdd.add(new DeviceApplicationAssoc__c(
                    device__c = DestinationDevice.Id,
                    Application__c = originalDevApp.application__c, 
                    Include_in_BOM__c = originalDevApp.Include_in_BOM__c,
                    Source_Id__c = originalDevApp.Source_Id__c,
                    Application_Source_Id__c = originalDevApp.Application_Source_Id__c,
                    Source_Name__c = originalDevApp.Source_Name__c));
            // }
        }

        DestinationDevice.Applications_Copied_From__c = OriginalDevice.ID;
        DestinationDevice.applications_copied__c = System.NOW();
        // Rajesh: 20-Jun-2012: Add the 2 lines below per Brian Chiang's request
        DestinationDevice.Core_Device_Package__c = OriginalDevice.Core_Device_Package__c;
        DestinationDevice.Stable__c = OriginalDevice.Stable__c;

        update DestinationDevice;
        
        insert devAppstoAdd;

        PageReference DestinationPage = 
            new pagereference('/'+OriginalDevice.Destination_Device__c+'?returl=/'+OriginalDevice.ID);
        System.Debug(OriginalDevice.Destination_Device__c + '**********Destination Device**********');
        return DestinationPage;
    }

    public static testmethod void TestmethodA() {
        PageReference TestPage;
        // SFDC 1: Prepare records
        User datafeed = [SELECT ID From User Where name = 'Automated Data Feed'];
        Device__c DestinationTest = new Device__c(name='DestinationTest');
        Device__c DeviceTest = new Device__c(name='DeviceTest');
        System.runAs(datafeed){
            insert new List<Device__c>{deviceTest, DestinationTest};            
        }

        DeviceTest.Destination_Device__c = destinationtest.id;
        update DeviceTest;

        // SFDC 2: Instantiate a controller
        Apexpages.StandardController CopyAppsToExistingDeviceController = new Apexpages.standardController(DeviceTest);

        // SFDC 3: Set page
        testPage = Page.CopyAppsToExistingDevice;

        testPage.getParameters().put('id', DeviceTest.id);

        test.setCurrentPage(testPage);

        // SFDC 4: Instantiate an extension
        CopyAppsToExistingDevice ext = new CopyAppsToExistingDevice(CopyAppsToExistingDeviceController);

        // SFDC 5: Use extension to assert all your methods, properties, getters and setters.  Assert Values are as Expected.
        ext.CopyApps();
        
        String error = ext.ErrorMessage;
        Boolean showmessage = ext.ShowError;

        //System.assertEquals(ext.FromDevice.id, 'a06R0000007JAkwIAG');    
        //production:    
       // System.assertEquals(ext.FromDevice.id, 'a064000000B91qJ');    
        //System.assertEquals(ext.FromDevice.Destination_Device__c, 'a06R0000007OzSUIA0'); 
        //production:
       // System.assertEquals(ext.FromDevice.Destination_Device__c, 'a064000000FJ7h6');
    }
}