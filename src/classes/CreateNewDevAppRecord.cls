public class CreateNewDevAppRecord {
    private DeviceApplicationAssoc__c newDevApp;
    private Boolean showSystemException;
    private String systemException;

    public String partnerManager {get; set;}

    // variable used to identify record type
    Map<String,String> keyPrefixMap = SystemMethods.getPrefixNameObjectMap();

    public CreateNewDevAppRecord(ApexPages.StandardSetController controller) {
        showSystemException = false;
        newDevApp = new DeviceApplicationAssoc__c();
        String Id = ApexPages.currentPage().getParameters().get('Id');

        if(keyPrefixMap.get(Id.subString(0,3)) == 'Device__c'){
            newDevApp.Device__c = Id;
            try {
                newDevApp.DevApp_Item_Effective_Date__c = 
                    [SELECT Id, SW_Kit__r.Effective_Date__c FROM Device__c WHERE Id =: Id].SW_Kit__r.Effective_Date__c;
            } catch (System.Queryexception e){              
            }
        }
        else {
            newDevApp.Application__c = Id;
        }           
    }

    public Boolean getshowSystemException(){
        return showSystemException;
    }

    public String getSystemException(){
        return systemException;
    }

    public DeviceApplicationAssoc__c getDevApp(){
        return newDevApp;
    }

    public void setDevApp(DeviceApplicationAssoc__c nda){
        this.newDevApp = nda;
    }

    public Boolean getisThisADevAppDuplicate(){
        if([SELECT count() FROM DeviceApplicationAssoc__c 
            WHERE Device__c =: newDevApp.Device__c 
            AND Application__c =: newDevApp.Application__c] == 0){
            return false;
        }
        return true;
    }

    public Boolean getIsThisAppNotAvailableForUse(){
        if(newDevApp.Application__c != null){
            if([SELECT Available_For_Use__c FROM Application__c 
                WHERE Id =: newDevApp.Application__c].Available_For_Use__c == false){
                return true;
            }           
        }
        return false;
    }

    public Boolean getAreAllMatricesCreated(){
        if([SELECT count() FROM AIF_Approval_Matrix__c 
            WHERE Device_Name__c = : newDevApp.Device__c] < 1){
            return false;
        }
        else if([SELECT count() FROM Application_Manager_Selection_Matrix__c 
            WHERE Device__c = : newDevApp.Device__c] < 3){
            return false;
        }
        return true;
    }

    public Boolean getIsAppPostload(){
        if(newDevApp.Application__c != null){
            if([SELECT Application_Type__c FROM Application__c 
                WHERE Id =: newDevApp.Application__c].Application_Type__c == 'Postload'){
                return true;
            }
            return false;
        }
        return false;
    }

    public Boolean getIsDeviceSWBOMApproved(){
        if(newDevApp.Device__c != null 
            && UserInfo.getProfileId() != '00e40000000oqQ9AAI' && UserInfo.getProfileId() != '00e40000000oqznAAA'){
            try{
                if([SELECT Id, SWBOM_Reviewed_and_Approved__c FROM Device__c 
                WHERE Id =: newDevApp.Device__c].SWBOM_Reviewed_and_Approved__c == 'Yes'){
                    return true;
                }
            } catch (System.Queryexception e){
                return false;
            }
        }
        return false;
    }

    public Boolean getDoesApplicationHaveContract(){
        if(newDevApp.Application__c != null){
            if([SELECT count() FROM ContApplAssoc__c WHERE Application__c =: newDevApp.Application__c 
                AND Governing_End_Date__c = true] > 0){
                return true;
            }
            
            try{
                partnerManager = [SELECT Account__r.Owner.Name FROM Application__c 
                    WHERE Id =: newDevApp.Application__c].Account__r.Owner.Name;
            } catch(System.QueryException e){
                partnerManager = '';
            }
            return false;
        }
        return true;
        
    }

    public PageReference save(){
        /*** USE THIS WHEN USING CommandLink styled as btn to get parameter passed
        String saveOption = ApexPages.currentPage().getParameters().get('saveOption');
        */
        system.debug('getisThisADevAppDuplicate(): ' + getisThisADevAppDuplicate());
        system.debug('getIsAppPostload(): ' + getIsAppPostload());
        system.debug('getIsDeviceSWBOMApproved(): ' + getIsDeviceSWBOMApproved());
        system.debug('getIsThisAppNotAvailableForUse(): ' + getIsThisAppNotAvailableForUse());
        system.debug('getDoesApplicationHaveContract(): ' + getDoesApplicationHaveContract());
        
        if(getisThisADevAppDuplicate() == false && getIsAppPostload() != true && 
            getIsDeviceSWBOMApproved() != true && getIsThisAppNotAvailableForUse() != true && 
            getDoesApplicationHaveContract() == true){
            // insert a try catch so that we can catch any insert errors and display to user
            try{
                insert newDevApp;
            }
            catch(System.DmlException e){
                return returnToPageShowError(e.getMessage());
            }
            //return back to Device
            return returnUserBackToDevice();
        }
        return ApexPages.CurrentPage();
    }

    public PageReference saveAndCreateNewDevApp(){
        system.debug('getisThisADevAppDuplicate(): ' + getisThisADevAppDuplicate());
        system.debug('getIsAppPostload(): ' + getIsAppPostload());
        system.debug('getIsDeviceSWBOMApproved(): ' + getIsDeviceSWBOMApproved());
        system.debug('getIsThisAppNotAvailableForUse(): ' + getIsThisAppNotAvailableForUse());
        system.debug('getDoesApplicationHaveContract(): ' + getDoesApplicationHaveContract());

        if(getisThisADevAppDuplicate() == false && getIsAppPostload() != true && 
            getIsDeviceSWBOMApproved() != true && getIsThisAppNotAvailableForUse() != true && 
            getDoesApplicationHaveContract() == true){
            try{
                insert newDevApp;
            }
            catch(System.DmlException e){
                return returnToPageShowError(e.getMessage());
            }
            return returnUserToCreateNewDevApp();
        }
        return ApexPages.CurrentPage();
    }

    public PageReference saveAndSubmit(){
        if(getisThisADevAppDuplicate() == false && getIsAppPostload() != true && 
            getIsDeviceSWBOMApproved() != true && getIsThisAppNotAvailableForUse() != true && 
            getDoesApplicationHaveContract() == true){
            try{
                insert newDevApp;

                // Create an approval request for the DevApp
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                //req.setComments('Submitting request for approval.');
                req.setObjectId(newDevApp.Id);
                // Submit the approval request for the account
                Approval.ProcessResult result = Approval.process(req);

                // Verify the result
                system.assert(result.isSuccess());
            }
            catch(System.DmlException e){
                return returnToPageShowError(e.getMessage());
            }

            return returnUserBackToDevice();
        }
        return ApexPages.currentPage();
    }

    public PageReference saveAndSubmitAndCreateNewDevApp(){
        if(getisThisADevAppDuplicate() == false && getIsAppPostload() != true && 
            getIsDeviceSWBOMApproved() != true && getIsThisAppNotAvailableForUse() != true && 
            getDoesApplicationHaveContract() == true){
            try{
                insert newDevApp;

                // Create an approval request for the DevApp
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                //req.setComments('Submitting request for approval.');
                req.setObjectId(newDevApp.Id);

                // Submit the approval request for the account
                Approval.ProcessResult result = Approval.process(req);

                // Verify the result
                system.assert(result.isSuccess());
            }
            catch(System.DmlException e){
                return returnToPageShowError(e.getMessage());
            }
            return returnUserToCreateNewDevApp();
        }
        return ApexPages.currentPage();
    }

    public PageReference cancel(){
        try{
            return returnUserBackToDevice();
        }
        catch(System.NullPointerException e){
            return ApexPages.currentPage();
        }
    }

    public PageReference returnUserBackToDevice(){
        PageReference pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
        pr.setRedirect(true);
        return pr;
    }

    public PageReference returnToPageShowError(String message){
        systemException = message;
        showSystemException = true;
        return ApexPages.currentPage();
    }

    public PageReference returnUserToCreateNewDevApp(){
        newDevApp = new DeviceApplicationAssoc__c();
        newDevApp.Include_in_BOM__c = true;
        newDevApp.Device__c = ApexPages.currentPage().getParameters().get('Id');
        return ApexPages.currentPage();
    }

    public static testMethod void SubmitDevAppsForApprovalSaveTest(){
        // this test includes testing for some triggers and other classes, including SADateMethods
        // the DevApps in this test are marked to not test %ofOnBOMorSD apps on full contract   

        // Create Device
        Device__c newDevice = new Device__c(name='testdevforcreatenewdevapp');
        insert newDevice;

        // Create AID Approval Matrix
        AIF_Approval_Matrix__c newAIFApprovalMatrix = new AIF_Approval_Matrix__c();
        newAIFApprovalMatrix.name='AIFApprovalMatrix';
        newAIFApprovalMatrix.Device_Name__c=newDevice.Id;
        newAIFApprovalMatrix.LRB_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.DTS_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.FMD_Status_Check_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Finance_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Application_Requester__c=UserInfo.getUserId();
        insert newAIFApprovalMatrix;

        // Create Application Manager Selection Matrix Embedded
        Application_Manager_Selection_Matrix__c newAMSMEmbedded = new Application_Manager_Selection_Matrix__c();
        newAMSMEmbedded.name='Embedded';
        newAMSMEmbedded.Device__c=newDevice.Id;
        newAMSMEmbedded.Application_Manager__c=UserInfo.getUserId();
        newAMSMEmbedded.Application_Type__c='Embedded';
        insert newAMSMEmbedded;

        // Create Application Manager Selection Matrix Preload
        Application_Manager_Selection_Matrix__c newAMSMPreload = new Application_Manager_Selection_Matrix__c();
        newAMSMPreload.name='Preload';
        newAMSMPreload.Device__c=newDevice.Id;
        newAMSMPreload.Application_Manager__c=UserInfo.getUserId();
        newAMSMPreload.Application_Type__c='Preload';
        insert newAMSMPreload;

        // Create Application Manager Selection Matrix Other
        Application_Manager_Selection_Matrix__c newAMSMOther = new Application_Manager_Selection_Matrix__c();
        newAMSMOther.name='Other';
        newAMSMOther.Device__c=newDevice.Id;
        newAMSMOther.Application_Manager__c=UserInfo.getUserId();
        newAMSMOther.Application_Type__c='Other';
        insert newAMSMOther;

        Account acc = new Account(Name='account');
        insert acc;

        // Create Application
        Application__c newApp = new Application__c(name='newApplication', Account__c=acc.Id, 
            Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true );
        newApp.Application_Type__c = 'Preload';
        newApp.Application_Sub_Type__c='faketype';
        insert newApp;
        // The application methods clss make Available_For_Use__c false upon insert, we want to set to true
        newApp.Available_For_Use__c=true;
        update newApp;

        Application__c newAppPostload = new Application__c(name='newApplicationPostlaod', 
            Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newAppPostload.Application_Type__c = 'Postload';
        insert newAppPostload;

        Contract c = new Contract(Name='contract', AccountId=acc.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newApp.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newAppPostload.Id, Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca, ca2};
        // The application methods clss make Available_For_Use__c false upon insert, we want to set to true
        newApp.Available_For_Use__c=true;
        update newApp;
                
        // Create Instance of CNDAR
        List<Device__c> deviceList = [SELECT id FROM Device__c WHERE id=: newdevice.Id];

        DeviceApplicationAssoc__c devApp3 = new DeviceApplicationAssoc__c(device__c=newDevice.Id, 
            Application__c=newAppPostload.Id, Include_in_BOM__c = false);
        insert devApp3;

        system.debug('START OF TEST ****************************************************************************************************');

        Test.startTest();
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(deviceList);

        // test with launching page from Application
        ApexPages.currentPage().getParameters().put('Id', newAppPostload.Id);
        CreateNewDevAppRecord cndar = new CreateNewDevAppRecord(setCon);
        Boolean isappAcceptable = cndar.getIsAppPostload();

        ApexPages.currentPage().getParameters().put('Id', newApp.Id);
        cndar = new CreateNewDevAppRecord(setCon);
        isappAcceptable = cndar.getIsAppPostload();

        ApexPages.currentPage().getParameters().put('Id', newdevice.Id);
        cndar = new CreateNewDevAppRecord(setCon);
        isappAcceptable = cndar.getIsAppPostload();

        //Test.setCurrentPage(newdevice);

        system.debug('BEFORE TEST ACCESSORY METHODS *******************************************************************************************');

        // Call accessory methods
        Boolean testDuplicate = cndar.getisThisADevAppDuplicate();
        //Boolean testSWBOMApproved = cndar.getIsDeviceSWBOMApproved();
        Boolean shwError = cndar.getshowSystemException();
        String systemmessage = cndar.getSystemException();
        DeviceApplicationAssoc__c devApp = cndar.getDevApp();
        devApp.Device__c = newDevice.Id;
        devApp.Application__c = newApp.id;
        devApp.Include_in_BOM__c = false;
        cndar.setDevApp(devApp);
        Boolean matrixTest = cndar.getAreAllMatricesCreated();
        cndar.cancel();
        ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
        cndar.cancel();
        PageReference pr = cndar.returnToPageShowError('Error Message');

        system.debug('BEFORE TEST SAVE****************************************************************************************************');
        // Test save()
        system.debug('TEST SAVE');
        pr = cndar.save();
        DeviceApplicationAssoc__c devApp2 = cndar.getDevApp();
        devApp2.Include_in_BOM__c = false;
        cndar.setDevApp(devApp2);
        pr = cndar.save();

        // Test DeviceAppplication.trigger before update
        devApp.Partner_Manager_Checklist_Approval__c = 'Approved';
        update devApp;

        /**** TEST CODE FOR Application_After.trigger ****/
        newApp.Application_Type__c = 'Embedded';
        newApp.X3rd_Party_Approval_Required__c = true;
        newApp.Royalty_High__c = 25;
        update newApp;
        newApp.X3rd_Party_Approval_Required__c = false;
        update newApp;
        /**** END TEST CODE FOR Application_After.trigger ****/

        /*** TEST ApplicationManagerMatrixUpdate ***/
        newAMSMEmbedded.Name = 'newName';
        update newAMSMEmbedded;
        newAMSMOther.Name = 'newName';
        update newAMSMOther;

        /*** END TEST ApplicationManagerMatrixUpdate ***/

        Test.stopTest();
    }

    public static testMethod void SubmitDevAppsForApprovalSaveAndCreateAndSubmitTest1(){
        // this test includes testing for some triggers and other classes, including SADateMethods
        // the DevApps in this test are marked to not test %ofOnBOMorSD apps on full contract   

        // Create Device
        Device__c newDevice = new Device__c(name='testdevforcreatenewdevapp');
        insert newDevice;

        // Create AID Approval Matrix
        AIF_Approval_Matrix__c newAIFApprovalMatrix = new AIF_Approval_Matrix__c();
        newAIFApprovalMatrix.name='AIFApprovalMatrix';
        newAIFApprovalMatrix.Device_Name__c=newDevice.Id;
        newAIFApprovalMatrix.LRB_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.DTS_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.FMD_Status_Check_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Finance_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Application_Requester__c=UserInfo.getUserId();
        insert newAIFApprovalMatrix;

        // Create Application Manager Selection Matrix Embedded
        Application_Manager_Selection_Matrix__c newAMSMEmbedded = new Application_Manager_Selection_Matrix__c();
        newAMSMEmbedded.name='Embedded';
        newAMSMEmbedded.Device__c=newDevice.Id;
        newAMSMEmbedded.Application_Manager__c=UserInfo.getUserId();
        newAMSMEmbedded.Application_Type__c='Embedded';

        // Create Application Manager Selection Matrix Preload
        Application_Manager_Selection_Matrix__c newAMSMPreload = new Application_Manager_Selection_Matrix__c();
        newAMSMPreload.name='Preload';
        newAMSMPreload.Device__c=newDevice.Id;
        newAMSMPreload.Application_Manager__c=UserInfo.getUserId();
        newAMSMPreload.Application_Type__c='Preload';

        // Create Application Manager Selection Matrix Other
        Application_Manager_Selection_Matrix__c newAMSMOther = new Application_Manager_Selection_Matrix__c();
        newAMSMOther.name='Other';
        newAMSMOther.Device__c=newDevice.Id;
        newAMSMOther.Application_Manager__c=UserInfo.getUserId();
        newAMSMOther.Application_Type__c='Other';

        insert new List<Application_Manager_Selection_Matrix__c>{newAMSMEmbedded, newAMSMPreload, newAMSMOther};

        Account acc = new Account(Name='account');
        insert acc;

        // Create Application
        Application__c newApp = new Application__c(name='newApplication', Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newApp.Application_Type__c = 'Preload';
        newApp.Application_Sub_Type__c='faketype';

        Application__c newAppPostload = new Application__c(name='newApplicationPostlaod', Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newAppPostload.Application_Type__c = 'Postload';
        insert new List<Application__c>{newApp, newAppPostload};
        // The application methods clss make Available_For_Use__c false upon insert, we want to set to true
        newApp.Available_For_Use__c=true;
        update newApp;

        Contract c = new Contract(Name='contract', AccountId=acc.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newApp.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newAppPostload.Id, Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca, ca2};
        // The application methods clss make Available_For_Use__c false upon insert, we want to set to true
        newApp.Available_For_Use__c=true;
        update newApp;

        // Create Instance of CNDAR
        List<Device__c> deviceList = [SELECT id FROM Device__c WHERE id=: newdevice.Id];

        DeviceApplicationAssoc__c devApp3 = new DeviceApplicationAssoc__c(device__c=newDevice.Id, Application__c=newAppPostload.Id, Include_in_BOM__c = false);
        insert devApp3;

        system.debug('START OF TEST ****************************************************************************************************');

        Test.startTest();
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(deviceList);
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            // test with launching page from Application
            ApexPages.currentPage().getParameters().put('Id', newAppPostload.Id);
            CreateNewDevAppRecord cndar = new CreateNewDevAppRecord(setCon);
            Boolean isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newApp.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newdevice.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
                //Test.setCurrentPage(newdevice);
                /*
            system.debug('BEFORE TEST SAVEANDCREATENEW****************************************************************************************************');
            // Test saveAndCreateNewDevApp()
            //ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            //setCon = new ApexPages.StandardSetController(deviceList);
            cndar = new CreateNewDevAppRecord(setCon);
            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            PageReference pr = cndar.saveAndCreateNewDevApp();
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            system.debug('SAVE And New 1');
            DeviceApplicationAssoc__c devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndCreateNewDevApp();
            system.debug('SAVE And New 2');
            delete devApp;
                system.debug('BEFORE TEST SAVEANDSUBMIT****************************************************************************************************');
            // Test saveAndSubmit()
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 1');
            devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 2');
            delete devApp;
                system.debug('BEFORE TEST SAVEANDSUBMITANDCREATE****************************************************************************************************');
            // Test saveAndSubmitAndCreateNewDevApp()
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 1');
            devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 2');
            delete devApp;
                // test saveAndSubmit and saveAndSubmitAndNew when devApp cannot be submitted
            delete newAIFApprovalMatrix;
        
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
                // ReCreate newApp so we can also test trigger code in DeviceApplication.trigger
                newApp.X3rd_Party_Approval_Required__c = true;
                update newApp;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            Boolean matrixTest = cndar.getAreAllMatricesCreated();
            delete newAMSMPreload;
            delete newAMSMEmbedded;
            delete newAMSMOther;
            matrixTest = cndar.getAreAllMatricesCreated();
            pr = cndar.saveAndSubmit();
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            */
        Test.stopTest();
    }

    public static testMethod void SubmitDevAppsForApprovalSaveAndCreateAndSubmitTest2(){
        // this test includes testing for some triggers and other classes, including SADateMethods
        // the DevApps in this test are marked to not test %ofOnBOMorSD apps on full contract   
        
        // Create Device
        Device__c newDevice = new Device__c(name='testdevforcreatenewdevapp');
        insert newDevice;

        // Create AID Approval Matrix
        AIF_Approval_Matrix__c newAIFApprovalMatrix = new AIF_Approval_Matrix__c();
        newAIFApprovalMatrix.name='AIFApprovalMatrix';
        newAIFApprovalMatrix.Device_Name__c=newDevice.Id;
        newAIFApprovalMatrix.LRB_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.DTS_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.FMD_Status_Check_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Finance_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Application_Requester__c=UserInfo.getUserId();
        insert newAIFApprovalMatrix;

        // Create Application Manager Selection Matrix Embedded
        Application_Manager_Selection_Matrix__c newAMSMEmbedded = new Application_Manager_Selection_Matrix__c();
        newAMSMEmbedded.name='Embedded';
        newAMSMEmbedded.Device__c=newDevice.Id;
        newAMSMEmbedded.Application_Manager__c=UserInfo.getUserId();
        newAMSMEmbedded.Application_Type__c='Embedded';

        // Create Application Manager Selection Matrix Preload
        Application_Manager_Selection_Matrix__c newAMSMPreload = new Application_Manager_Selection_Matrix__c();
        newAMSMPreload.name='Preload';
        newAMSMPreload.Device__c=newDevice.Id;
        newAMSMPreload.Application_Manager__c=UserInfo.getUserId();
        newAMSMPreload.Application_Type__c='Preload';

        // Create Application Manager Selection Matrix Other
        Application_Manager_Selection_Matrix__c newAMSMOther = new Application_Manager_Selection_Matrix__c();
        newAMSMOther.name='Other';
        newAMSMOther.Device__c=newDevice.Id;
        newAMSMOther.Application_Manager__c=UserInfo.getUserId();
        newAMSMOther.Application_Type__c='Other';

        insert new List<Application_Manager_Selection_Matrix__c>{newAMSMEmbedded, newAMSMPreload, newAMSMOther};

        Account acc = new Account(Name='account');
        insert acc;

        // Create Application
        Application__c newApp = new Application__c(name='newApplication', Account__c=acc.Id, 
            Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newApp.Application_Type__c = 'Preload';
        newApp.Application_Sub_Type__c='faketype';

        Application__c newAppPostload = new Application__c(name='newApplicationPostlaod', 
            Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newAppPostload.Application_Type__c = 'Postload';
        insert new List<Application__c>{newApp, newAppPostload};

        Contract c = new Contract(Name='contract', AccountId=acc.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newApp.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newAppPostload.Id, Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca, ca2};
        // The application methods clss make Available_For_Use__c false upon insert, we want to set to true
        newApp.Available_For_Use__c=true;
        update newApp;

        // Create Instance of CNDAR
        List<Device__c> deviceList = [SELECT id FROM Device__c WHERE id=: newdevice.Id];

        DeviceApplicationAssoc__c devApp3 = new DeviceApplicationAssoc__c(device__c=newDevice.Id, 
            Application__c=newAppPostload.Id, Include_in_BOM__c = false);
        insert devApp3;

        system.debug('START OF TEST ****************************************************************************************************');

        Test.startTest();
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(deviceList);
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            // test with launching page from Application
            ApexPages.currentPage().getParameters().put('Id', newAppPostload.Id);
            CreateNewDevAppRecord cndar = new CreateNewDevAppRecord(setCon);
            /*Boolean isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newApp.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newdevice.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
            */
            //Test.setCurrentPage(newdevice);
                
            system.debug('BEFORE TEST SAVEANDCREATENEW****************************************************************************************************');
            // Test saveAndCreateNewDevApp()
            //ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            //setCon = new ApexPages.StandardSetController(deviceList);
            cndar = new CreateNewDevAppRecord(setCon);
            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            PageReference pr = cndar.saveAndCreateNewDevApp();
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            system.debug('SAVE And New 1');
            DeviceApplicationAssoc__c devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndCreateNewDevApp();
            system.debug('SAVE And New 2');
            delete devApp;
           /*
            system.debug('BEFORE TEST SAVEANDSUBMIT****************************************************************************************************');
            // Test saveAndSubmit()
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 1');
            devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 2');
            delete devApp;
                system.debug('BEFORE TEST SAVEANDSUBMITANDCREATE****************************************************************************************************');
            // Test saveAndSubmitAndCreateNewDevApp()
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 1');
            devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 2');
            delete devApp;
                // test saveAndSubmit and saveAndSubmitAndNew when devApp cannot be submitted
            delete newAIFApprovalMatrix;
        
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
                // ReCreate newApp so we can also test trigger code in DeviceApplication.trigger
                newApp.X3rd_Party_Approval_Required__c = true;
                update newApp;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            Boolean matrixTest = cndar.getAreAllMatricesCreated();
            delete newAMSMPreload;
            delete newAMSMEmbedded;
            delete newAMSMOther;
            matrixTest = cndar.getAreAllMatricesCreated();
            pr = cndar.saveAndSubmit();
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            */
        Test.stopTest();
    }

    public static testMethod void SubmitDevAppsForApprovalSaveAndCreateAndSubmitTest3(){
        // this test includes testing for some triggers and other classes, including SADateMethods
        // the DevApps in this test are marked to not test %ofOnBOMorSD apps on full contract   
        
        
        // Create Device
        Device__c newDevice = new Device__c(name='testdevforcreatenewdevapp');
        insert newDevice;

        // Create AID Approval Matrix
        AIF_Approval_Matrix__c newAIFApprovalMatrix = new AIF_Approval_Matrix__c();
        newAIFApprovalMatrix.name='AIFApprovalMatrix';
        newAIFApprovalMatrix.Device_Name__c=newDevice.Id;
        newAIFApprovalMatrix.LRB_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.DTS_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.FMD_Status_Check_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Finance_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Application_Requester__c=UserInfo.getUserId();
        insert newAIFApprovalMatrix;

        // Create Application Manager Selection Matrix Embedded
        Application_Manager_Selection_Matrix__c newAMSMEmbedded = new Application_Manager_Selection_Matrix__c();
        newAMSMEmbedded.name='Embedded';
        newAMSMEmbedded.Device__c=newDevice.Id;
        newAMSMEmbedded.Application_Manager__c=UserInfo.getUserId();
        newAMSMEmbedded.Application_Type__c='Embedded';

        // Create Application Manager Selection Matrix Preload
        Application_Manager_Selection_Matrix__c newAMSMPreload = new Application_Manager_Selection_Matrix__c();
        newAMSMPreload.name='Preload';
        newAMSMPreload.Device__c=newDevice.Id;
        newAMSMPreload.Application_Manager__c=UserInfo.getUserId();
        newAMSMPreload.Application_Type__c='Preload';

        // Create Application Manager Selection Matrix Other
        Application_Manager_Selection_Matrix__c newAMSMOther = new Application_Manager_Selection_Matrix__c();
        newAMSMOther.name='Other';
        newAMSMOther.Device__c=newDevice.Id;
        newAMSMOther.Application_Manager__c=UserInfo.getUserId();
        newAMSMOther.Application_Type__c='Other';

        insert new List<Application_Manager_Selection_Matrix__c>{newAMSMEmbedded, newAMSMPreload, newAMSMOther};

        Account acc = new Account(Name='account');
        insert acc;

        // Create Application
        Application__c newApp = new Application__c(name='newApplication', Account__c=acc.Id, 
            Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newApp.Application_Type__c = 'Preload';
        newApp.Application_Sub_Type__c='faketype';

        Application__c newAppPostload = new Application__c(name='newApplicationPostlaod', 
            Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newAppPostload.Application_Type__c = 'Postload';
        insert new List<Application__c>{newApp, newAppPostload};

        Contract c = new Contract(Name='contract', AccountId=acc.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newApp.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newAppPostload.Id, Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca, ca2};
        // The application methods clss make Available_For_Use__c false upon insert, we want to set to true
        newApp.Available_For_Use__c=true;
        update newApp;

        // Create Instance of CNDAR
        List<Device__c> deviceList = [SELECT id FROM Device__c WHERE id=: newdevice.Id];

        DeviceApplicationAssoc__c devApp3 = new DeviceApplicationAssoc__c(device__c=newDevice.Id, 
            Application__c=newAppPostload.Id, Include_in_BOM__c = false);
        insert devApp3;

        system.debug('START OF TEST ****************************************************************************************************');

        Test.startTest();
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(deviceList);
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            // test with launching page from Application
            ApexPages.currentPage().getParameters().put('Id', newAppPostload.Id);
            CreateNewDevAppRecord cndar = new CreateNewDevAppRecord(setCon);
            /*Boolean isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newApp.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newdevice.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
                //Test.setCurrentPage(newdevice);
                
            system.debug('BEFORE TEST SAVEANDCREATENEW****************************************************************************************************');
            // Test saveAndCreateNewDevApp()
            //ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            //setCon = new ApexPages.StandardSetController(deviceList);
            cndar = new CreateNewDevAppRecord(setCon);
            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            PageReference pr = cndar.saveAndCreateNewDevApp();
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            system.debug('SAVE And New 1');
            DeviceApplicationAssoc__c devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndCreateNewDevApp();
            system.debug('SAVE And New 2');
            delete devApp;
          */
            system.debug('BEFORE TEST SAVEANDSUBMIT****************************************************************************************************');
            // Test saveAndSubmit()
            cndar = new CreateNewDevAppRecord(setCon);
            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            PageReference pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 1');
            DeviceApplicationAssoc__c devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 2');
            delete devApp;
           /*
            system.debug('BEFORE TEST SAVEANDSUBMITANDCREATE****************************************************************************************************');
            // Test saveAndSubmitAndCreateNewDevApp()
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 1');
            devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 2');
            delete devApp;
                // test saveAndSubmit and saveAndSubmitAndNew when devApp cannot be submitted
            delete newAIFApprovalMatrix;
        
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
                // ReCreate newApp so we can also test trigger code in DeviceApplication.trigger
                newApp.X3rd_Party_Approval_Required__c = true;
                update newApp;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            Boolean matrixTest = cndar.getAreAllMatricesCreated();
            delete newAMSMPreload;
            delete newAMSMEmbedded;
            delete newAMSMOther;
            matrixTest = cndar.getAreAllMatricesCreated();
            pr = cndar.saveAndSubmit();
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            */
        Test.stopTest();
    }

    public static testMethod void SubmitDevAppsForApprovalSaveAndCreateAndSubmitTest4(){
        // this test includes testing for some triggers and other classes, including SADateMethods
        // the DevApps in this test are marked to not test %ofOnBOMorSD apps on full contract   
        
        
        // Create Device
        Device__c newDevice = new Device__c(name='testdevforcreatenewdevapp');
        insert newDevice;

        // Create AID Approval Matrix
        AIF_Approval_Matrix__c newAIFApprovalMatrix = new AIF_Approval_Matrix__c();
        newAIFApprovalMatrix.name='AIFApprovalMatrix';
        newAIFApprovalMatrix.Device_Name__c=newDevice.Id;
        newAIFApprovalMatrix.LRB_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.DTS_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.FMD_Status_Check_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Finance_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Application_Requester__c=UserInfo.getUserId();
        insert newAIFApprovalMatrix;

        // Create Application Manager Selection Matrix Embedded
        Application_Manager_Selection_Matrix__c newAMSMEmbedded = new Application_Manager_Selection_Matrix__c();
        newAMSMEmbedded.name='Embedded';
        newAMSMEmbedded.Device__c=newDevice.Id;
        newAMSMEmbedded.Application_Manager__c=UserInfo.getUserId();
        newAMSMEmbedded.Application_Type__c='Embedded';

        // Create Application Manager Selection Matrix Preload
        Application_Manager_Selection_Matrix__c newAMSMPreload = new Application_Manager_Selection_Matrix__c();
        newAMSMPreload.name='Preload';
        newAMSMPreload.Device__c=newDevice.Id;
        newAMSMPreload.Application_Manager__c=UserInfo.getUserId();
        newAMSMPreload.Application_Type__c='Preload';

        // Create Application Manager Selection Matrix Other
        Application_Manager_Selection_Matrix__c newAMSMOther = new Application_Manager_Selection_Matrix__c();
        newAMSMOther.name='Other';
        newAMSMOther.Device__c=newDevice.Id;
        newAMSMOther.Application_Manager__c=UserInfo.getUserId();
        newAMSMOther.Application_Type__c='Other';

        insert new List<Application_Manager_Selection_Matrix__c>{newAMSMEmbedded, newAMSMPreload, newAMSMOther};

        Account acc = new Account(Name='account');
        insert acc;

        // Create Application
        Application__c newApp = new Application__c(name='newApplication', Account__c=acc.Id, 
            Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newApp.Application_Type__c = 'Preload';
        newApp.Application_Sub_Type__c='faketype';

        Application__c newAppPostload = new Application__c(name='newApplicationPostlaod', Account__c=acc.Id, 
            Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newAppPostload.Application_Type__c = 'Postload';
        insert new List<Application__c>{newApp, newAppPostload};

        Contract c = new Contract(Name='contract', AccountId=acc.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newApp.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newAppPostload.Id, Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca, ca2};
        // The application methods clss make Available_For_Use__c false upon insert, we want to set to true
        newApp.Available_For_Use__c=true;
        update newApp;

        // Create Instance of CNDAR
        List<Device__c> deviceList = [SELECT id FROM Device__c WHERE id=: newdevice.Id];

        DeviceApplicationAssoc__c devApp3 = new DeviceApplicationAssoc__c(device__c=newDevice.Id, 
            Application__c=newAppPostload.Id, Include_in_BOM__c = false);
        insert devApp3;

        system.debug('START OF TEST ****************************************************************************************************');

        Test.startTest();
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(deviceList);
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            // test with launching page from Application
            ApexPages.currentPage().getParameters().put('Id', newAppPostload.Id);
            CreateNewDevAppRecord cndar = new CreateNewDevAppRecord(setCon);
            /*Boolean isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newApp.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newdevice.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
                //Test.setCurrentPage(newdevice);
                
            system.debug('BEFORE TEST SAVEANDCREATENEW****************************************************************************************************');
            // Test saveAndCreateNewDevApp()
            //ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            //setCon = new ApexPages.StandardSetController(deviceList);
            cndar = new CreateNewDevAppRecord(setCon);
            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            PageReference pr = cndar.saveAndCreateNewDevApp();
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            system.debug('SAVE And New 1');
            DeviceApplicationAssoc__c devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndCreateNewDevApp();
            system.debug('SAVE And New 2');
            delete devApp;
                system.debug('BEFORE TEST SAVEANDSUBMIT****************************************************************************************************');
            // Test saveAndSubmit()
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 1');
            devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 2');
            delete devApp;
          */
            system.debug('BEFORE TEST SAVEANDSUBMITANDCREATE****************************************************************************************************');
            // Test saveAndSubmitAndCreateNewDevApp()
            cndar = new CreateNewDevAppRecord(setCon);
            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            PageReference pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 1');
            DeviceApplicationAssoc__c devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 2');
            delete devApp;
           /*
            // test saveAndSubmit and saveAndSubmitAndNew when devApp cannot be submitted
            delete newAIFApprovalMatrix;
        
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
                // ReCreate newApp so we can also test trigger code in DeviceApplication.trigger
                newApp.X3rd_Party_Approval_Required__c = true;
                update newApp;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            Boolean matrixTest = cndar.getAreAllMatricesCreated();
            delete newAMSMPreload;
            delete newAMSMEmbedded;
            delete newAMSMOther;
            matrixTest = cndar.getAreAllMatricesCreated();
            pr = cndar.saveAndSubmit();
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            */
        Test.stopTest();
    }

    public static testMethod void SubmitDevAppsForApprovalSaveAndCreateAndSubmitTest5(){
        // this test includes testing for some triggers and other classes, including SADateMethods
        // the DevApps in this test are marked to not test %ofOnBOMorSD apps on full contract   
        
        
        // Create Device
        Device__c newDevice = new Device__c(name='testdevforcreatenewdevapp');
        insert newDevice;

        // Create AID Approval Matrix
        AIF_Approval_Matrix__c newAIFApprovalMatrix = new AIF_Approval_Matrix__c();
        newAIFApprovalMatrix.name='AIFApprovalMatrix';
        newAIFApprovalMatrix.Device_Name__c=newDevice.Id;
        newAIFApprovalMatrix.LRB_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.DTS_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.FMD_Status_Check_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Finance_Approver__c=UserInfo.getUserId();
        newAIFApprovalMatrix.Application_Requester__c=UserInfo.getUserId();
        insert newAIFApprovalMatrix;

        // Create Application Manager Selection Matrix Embedded
        Application_Manager_Selection_Matrix__c newAMSMEmbedded = new Application_Manager_Selection_Matrix__c();
        newAMSMEmbedded.name='Embedded';
        newAMSMEmbedded.Device__c=newDevice.Id;
        newAMSMEmbedded.Application_Manager__c=UserInfo.getUserId();
        newAMSMEmbedded.Application_Type__c='Embedded';

        // Create Application Manager Selection Matrix Preload
        Application_Manager_Selection_Matrix__c newAMSMPreload = new Application_Manager_Selection_Matrix__c();
        newAMSMPreload.name='Preload';
        newAMSMPreload.Device__c=newDevice.Id;
        newAMSMPreload.Application_Manager__c=UserInfo.getUserId();
        newAMSMPreload.Application_Type__c='Preload';

        // Create Application Manager Selection Matrix Other
        Application_Manager_Selection_Matrix__c newAMSMOther = new Application_Manager_Selection_Matrix__c();
        newAMSMOther.name='Other';
        newAMSMOther.Device__c=newDevice.Id;
        newAMSMOther.Application_Manager__c=UserInfo.getUserId();
        newAMSMOther.Application_Type__c='Other';

        insert new List<Application_Manager_Selection_Matrix__c>{newAMSMEmbedded, newAMSMPreload, newAMSMOther};

        Account acc = new Account(Name='account');
        insert acc;

        // Create Application
        Application__c newApp = new Application__c(name='newApplication', Account__c=acc.Id, 
            Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newApp.Application_Type__c = 'Preload';
        newApp.Application_Sub_Type__c='faketype';

        Application__c newAppPostload = new Application__c(name='newApplicationPostlaod', 
            Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        newAppPostload.Application_Type__c = 'Postload';
        insert new List<Application__c>{newApp, newAppPostload};

        Contract c = new Contract(Name='contract', AccountId=acc.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newApp.Id, Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, Application__c=newAppPostload.Id, Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca, ca2};
        // The application methods clss make Available_For_Use__c false upon insert, we want to set to true
        newApp.Available_For_Use__c=true;
        update newApp;

        // Create Instance of CNDAR
        List<Device__c> deviceList = [SELECT id FROM Device__c WHERE id=: newdevice.Id];

        DeviceApplicationAssoc__c devApp3 = new DeviceApplicationAssoc__c(device__c=newDevice.Id, 
            Application__c=newAppPostload.Id, Include_in_BOM__c = false);
        insert devApp3;

        system.debug('START OF TEST ****************************************************************************************************');

        Test.startTest();
            ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(deviceList);
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            // test with launching page from Application
            ApexPages.currentPage().getParameters().put('Id', newAppPostload.Id);
            CreateNewDevAppRecord cndar = new CreateNewDevAppRecord(setCon);
            /*Boolean isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newApp.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
                ApexPages.currentPage().getParameters().put('Id', newdevice.Id);
            cndar = new CreateNewDevAppRecord(setCon);
            isappAcceptable = cndar.getIsAppPostload();
                //Test.setCurrentPage(newdevice);
                
            system.debug('BEFORE TEST SAVEANDCREATENEW****************************************************************************************************');
            // Test saveAndCreateNewDevApp()
            //ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            //setCon = new ApexPages.StandardSetController(deviceList);
            cndar = new CreateNewDevAppRecord(setCon);
            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            PageReference pr = cndar.saveAndCreateNewDevApp();
            ApexPages.currentPage().getParameters().put('retURL', deviceList.get(0).Id);
            system.debug('SAVE And New 1');
            DeviceApplicationAssoc__c devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndCreateNewDevApp();
            system.debug('SAVE And New 2');
            delete devApp;
                system.debug('BEFORE TEST SAVEANDSUBMIT****************************************************************************************************');
            // Test saveAndSubmit()
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 1');
            devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmit();
            system.debug('SAVE And Submit 2');
            delete devApp;
                system.debug('BEFORE TEST SAVEANDSUBMITANDCREATE****************************************************************************************************');
            // Test saveAndSubmitAndCreateNewDevApp()
            cndar = new CreateNewDevAppRecord(setCon);
            devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 1');
            devApp2 = new DeviceApplicationAssoc__c();
            devApp2.Device__c = newDevice.Id;
            devApp2.Application__c = newApp.id;
            devApp2.Include_in_BOM__c = false;
            cndar.setDevApp(devApp2);
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            system.debug('saveAndSubmitAndCreateNewDevApp 2');
            delete devApp;
           */
            // test saveAndSubmit and saveAndSubmitAndNew when devApp cannot be submitted
            delete newAIFApprovalMatrix;
        
            cndar = new CreateNewDevAppRecord(setCon);
            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c();
            devApp.Device__c = newDevice.Id;
                // ReCreate newApp so we can also test trigger code in DeviceApplication.trigger
                newApp.X3rd_Party_Approval_Required__c = true;
                update newApp;
            devApp.Application__c = newApp.id;
            devApp.Include_in_BOM__c = false;
            cndar.setDevApp(devApp);
            Boolean matrixTest = cndar.getAreAllMatricesCreated();
            delete newAMSMPreload;
            delete newAMSMEmbedded;
            delete newAMSMOther;
            matrixTest = cndar.getAreAllMatricesCreated();
            PageReference pr = cndar.saveAndSubmit();
            pr = cndar.saveAndSubmitAndCreateNewDevApp();
            Test.stopTest();
    }
}