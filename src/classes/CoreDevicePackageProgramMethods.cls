public with sharing class CoreDevicePackageProgramMethods {

    /*
     * Created by: Jesse
     * Creation date: Unknown
     * Description: <TO-DO>
     * Change history:
     * Date: 05-Jul-2012 Changed by: Rajesh Krishnaiah
     * Change: Added logic to skip addAppsToCoreDevicePackageAndCoreDevices
     *
     * Date: 27-Jun-2012 Changed by: Rajesh Krishnaiah
     * Changes: Fixed 2 bugs in the removeAppsFromCoreDevicePackageAndCoreDevices method
     * 1. The applicationSourceIds was defined as a list of IDs -- changed it to list of strings
     * 2. The SOQL for coreAppsToDelete was using "=" instead of the "IN" clause.
     */
    public static void addAppsToCoreDevicePackageAndCoreDevices(List<Core_Device_Package_Program__c> newList){
        List<Id> programIds = new List<Id>();
        List<Id> coreIds = new List<Id>();
        Map<Id, List<Id>> coreIdProgramIdListMap = new Map<Id, List<Id>>();
        
        /**
        	Author: Big Kite Consulting - Andy Leung
			Date: July 19, 2012
			
			Analysis: This loop is redundant since newList had run once in CoreDevicePackageProgram_Insert().
			Consolidate this loop with CoreDevicePackageProgram_Insert() will reduce # of statements.
        */
        for(Core_Device_Package_Program__c cdpp : newList){
            programIds.add(cdpp.Program__c);
            coreIds.add(cdpp.Core_Device_Package__c);
            
            if(coreIdProgramIdListMap.containsKey(cdpp.Core_Device_Package__c)){
                List<Id> tempList = coreIdProgramIdListMap.get(cdpp.Core_Device_Package__c);
                tempList.add(cdpp.Program__c);
                coreIdProgramIdListMap.put(cdpp.Core_Device_Package__c, tempList);
            } else {
                coreIdProgramIdListMap.put(cdpp.Core_Device_Package__c, new List<Id>{cdpp.Program__c});
            }
        }
        
        // create map of program-apps for each program id
        Map<Id, List<Program_Application__c>> programIdAppIdListMap = new Map<Id, List<Program_Application__c>>();     
        for(Program_Application__c pa : [SELECT Id, Application__c, Program__c, Program__r.Name 
                                         FROM Program_Application__c WHERE Program__c IN : programIds]){
            List<Program_Application__c> tempList = programIdAppIdListMap.get(pa.Program__c);
            if(tempList == null){
                tempList = new List<Program_Application__c>{pa};
            } else {
                tempList.add(pa);
            }
            programIdAppIdListMap.put(pa.Program__c, tempList);
        }
        
        // create list of coreapps to insert
        List<Core_Device_Package_Application__c> coreAppsToInsert = new List<Core_Device_Package_Application__c>();
        
        if (CloneCoreDevicePackage.insertAppsFromCDP_AndNotFromPrograms) {
            system.debug('insertAppsFromCDP_AndNotFromPrograms: ' + CloneCoreDevicePackage.existingCoreId);
	        for(Core_Device_Package_Application__c sourceCdpa : 
	             [SELECT Id, Application__c, Source_Id__c, Source_Name__c,
                      Include_in_BOM__c, Application_Source_Id__c,
                      Core_Device_Package__c
	             FROM Core_Device_Package_Application__c
	             WHERE Core_Device_Package__c = :CloneCoreDevicePackage.existingCoreId
                   AND Source_Id__c != null]) {

	               coreAppsToInsert.add(
                       new Core_Device_Package_Application__c(
                           Core_Device_Package__c = CloneCoreDevicePackage.newCoreId, 
                           Application__c = sourceCdpa.Application__c,
                           Source_Id__c = sourceCdpa.Source_Id__c, 
                           Source_Name__c = sourceCdpa.Source_Name__c,
                           Include_in_BOM__c = sourceCdpa.Include_in_BOM__c,
                           Application_Source_Id__c = sourceCdpa.Application_Source_Id__c));
	        }
        } else {
    
	        /**
	        	Author: Big Kite Consulting - Andy Leung
				Date: July 19, 2012
				
				Analysis: This loop is redundant since newList had run once in CoreDevicePackageProgram_Insert().
				Consolidate this loop with CoreDevicePackageProgram_Insert() will reduce # of statements.
	        */
            for(Core_Device_Package_Program__c cdpp : newList){
                String applicationSourceId = cdpp.Program__c;
                if(applicationSourceId.length() == 18){
                    applicationSourceId = applicationSourceId.substring(0,15);
                }
                
                if(programIdAppIdListMap.containsKey(cdpp.Program__c)){
                    for(Program_Application__c pa : programIdAppIdListMap.get(cdpp.Program__c)){
                        coreAppsToInsert.add(
                            new Core_Device_Package_Application__c(
                                Core_Device_Package__c=cdpp.Core_Device_Package__c, 
                                Application__c=pa.Application__c, 
                                Source_Id__c=pa.Program__c, 
                                Source_Name__c = pa.Program__r.Name,
                                Application_Source_Id__c = applicationSourceId));
                        // Rajesh: Should "include in BOM" be part of this?
                    }
                }           
            }
        }
        //create progDevice to insert
        //create list of DevApps to add to devices that use Core
        List<Program_Device__c> programDevicesToInsert = new List<Program_Device__c>();
        List<DeviceApplicationAssoc__c> devAppsToInsert = new List<DeviceApplicationAssoc__c>();
        for(Device__c d : [SELECT Id, Core_Device_Package__c, Core_Device_Package__r.Name, OwnerId, 
                           SWBOM_Reviewed_and_Approved__c, Device_Name_plus_ID__c 
                           FROM Device__c 
                           WHERE Core_Device_Package__c IN : coreIds]){
                               
            for(Id programId : coreIdProgramIdListMap.get(d.Core_Device_Package__c)){
                programDevicesToInsert.add(
                    new Program_Device__c(Program__c = programId, 
                                          Device__c = d.Id, 
                                          Source_Id__c = d.Core_Device_Package__c,
                                          Source_Name__c = d.Core_Device_Package__r.Name));
                    
                String applicationSourceId = programId;
                if(applicationSourceId.length() == 18){
                    applicationSourceId = applicationSourceId.substring(0,15);
                }
                
                if(programIdAppIdListMap.containsKey(programId)){
                    for(Program_Application__c pa : programIdAppIdListMap.get(programId)){
                        devAppsToInsert.add(
                            new DeviceApplicationAssoc__c(
                                Device__c=d.Id, Application__c=pa.Application__c, 
                                Source_Id__c=d.Core_Device_Package__c, 
                                Source_Name__c = d.Core_Device_Package__r.Name,
                                Application_Source_Id__c = applicationSourceId,
                                Include_in_BOM__c=true));
                    }
                }   
            }
        }
        
        insert coreAppsToInsert;
        insert programDevicesToInsert;
        insert devAppsToInsert;
    }
    
    public static void removeAppsFromCoreDevicePackageAndCoreDevices(List<Core_Device_Package_Program__c> oldList){
        List<Id> programIds = new List<Id>();
        List<Id> coreIds = new List<Id>();
        List<String> applicationSourceIds = new List<String>();
        Map<Id, List<Id>> coreIdProgramIdListMap = new Map<Id, List<Id>>();
        
        //extract Ids and create map of core Id to program Ids
        for(Core_Device_Package_Program__c cdpp : oldList){
            programIds.add(cdpp.Program__c);
            coreIds.add(cdpp.Core_Device_Package__c);
            
            String appSourceId = cdpp.Program__c;
            if(appSourceId.length() == 18){
                appSourceId = appSourceId.substring(0,15);
            }
            applicationSourceIds.add(appSourceId);
            
            if(coreIdProgramIdListMap.containsKey(cdpp.Core_Device_Package__c)){
                List<Id> tempList = coreIdProgramIdListMap.get(cdpp.Core_Device_Package__c);
                tempList.add(cdpp.Program__c);
                coreIdProgramIdListMap.put(cdpp.Core_Device_Package__c, tempList);
            } else {
                coreIdProgramIdListMap.put(cdpp.Core_Device_Package__c, new List<Id>{cdpp.Program__c});
            }
        }
        
        // create map of program-apps for each program id
        Map<Id, List<Id>> programIdAppIdListMap = new Map<Id, List<Id>>();      
        for(Program_Application__c pa : [SELECT Id, Application__c, Program__c, Program__r.Name 
                    FROM Program_Application__c WHERE Program__c IN : programIds]){
            List<Id> tempList = programIdAppIdListMap.get(pa.Program__c);
            if(tempList == null){
                tempList = new List<Id>{pa.Application__c};
            } else {
                tempList.add(pa.Application__c);
            }
            programIdAppIdListMap.put(pa.Program__c, tempList);
        }
        
        // create list of Core-Apps to delete
        // Rajesh - 27-Jun-2012: Replaced: Application_Source_Id__c = :applicationSourceIds
        // with Application_Source_Id__c in :applicationSourceIds
             
        List<Core_Device_Package_Application__c> coreAppsToDelete = 
            [SELECT Id, Source_Id__c, Source_Name__c 
            FROM Core_Device_Package_Application__c 
            WHERE Core_Device_Package__c IN : coreIds 
            AND Source_Id__c IN : programIds 
            AND Application_Source_Id__c in :applicationSourceIds];
        
        //clear source fields so that we can update the core app records and prep them for deletion
        for(Core_Device_Package_Application__c cdpa : coreAppsToDelete){
            cdpa.Source_Id__c = null;
        }

        //find devices that use program where source is core, so that we can remove program from them
        List<Program_Device__c> programDevices = 
            [SELECT Id, Device__r.SWBOM_Reviewed_and_Approved__c, Device__c, 
                 Device__r.Core_Device_Package__c, 
                 Device__r.Core_Device_Package__r.Name, Program__c
             FROM Program_Device__c 
             WHERE Program__c IN : programIds 
             AND Source_Id__c IN : coreIds];      
        List<Program_Device__c> programDevicesToDelete = new List<Program_Device__c>();
        List<Id> deviceIds = new List<Id>();    
        List<Id> deviceIdsToNOTRemoveAppsFrom = new List<Id>(); 
        List<Blocked_Action__c> blockedActionsToInsert = new List<Blocked_Action__c>();
        
        for(Program_Device__c pg : programDevices){
            deviceIds.add(pg.Device__c);
            // only remove these programs from devices if device is NOT reviewed and approved
            if(pg.Device__r.SWBOM_Reviewed_and_Approved__c == 'No'){
                pg.Source_Id__c = null;
                programDevicesToDelete.add(pg);
            }
        }
        
        // only delete the device applications from devices that are not SW BOM Reviewed & Approved
        List<DeviceApplicationAssoc__c> devAppsToDelete = new List<DeviceApplicationAssoc__c>();            
        for(DeviceApplicationAssoc__c da : 
            [SELECT Device__c, Device__r.SWBOM_Reviewed_and_Approved__c, 
                 Application__c, Application_Source_Id__c, Source_Id__c,
                 Source_Name__c
             FROM DeviceApplicationAssoc__c
             WHERE Device__c IN : deviceIds
             AND Source_Id__c IN : coreIds
             AND Application_Source_Id__c =: applicationSourceIds]){
            // only remove these apps from devices if device is NOT reviewed and approved
            if(da.Device__r.SWBOM_Reviewed_and_Approved__c == 'No'){
                da.Source_Id__c = null;
                devAppsToDelete.add(da);
            } else {
                blockedActionsToInsert.add(
                    new Blocked_Action__c(
                        Action_Attempted__c = 'Delete', 
                        Application__c = da.Application__c, 
                        Application_Source_Id__c = da.Application_Source_Id__c, 
                        Device__c = da.Device__c, 
                        Source_Id__c = da.Source_Id__c,
                        Source_Name__c = da.Source_Name__c,
                        Device_Application_if_delete__c = da.Id));
            }
        }

        // update and delete records
        update coreAppsToDelete;        
        delete coreAppsToDelete;
        update programDevicesToDelete;  
        delete programDevicesToDelete;      
        update devAppsToDelete;
        delete devAppsToDelete;
        insert blockedActionsToInsert;
    }
    
    private static void emailDeviceOwnersOfUpdatedCore(
            List<Device__c> devices, 
            Map<Id, Core_Device_Package__c> cdpMap, 
            Map<Id, String> coreDevicePackageIdProgramNameMap, 
            String action){
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();
        
        for(Device__c d : devices){
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setSaveAsActivity(false);
            
            mail.setTargetObjectId(d.OwnerId);
                
            mail.setReplyTo('doNotReply@motorola.com');
            
            mail.setSenderDisplayName('SalesForce');
                            
            mail.setSubject('Core Device Package Update skipped your Device: ' + d.Name);
            
            // Set to True if you want to BCC yourself on the email.    
            mail.setBccSender(false);
            
            // Optionally append the salesforce.com email signature to the email.  
            // The email address of the user executing the Apex Code will be used.  
            mail.setUseSignature(false);
            
            // Specify the text content of the email.  
            mail.setPlainTextBody('The program ' + 
                                  coreDevicePackageIdProgramNameMap.get(
                                      cdpMap.get(d.Core_Device_Package__c).Id) + 
                                  ' has been ' + action + ' the Core Device Package ' + 
                                  cdpMap.get(d.Core_Device_Package__c).Name + 
                                  '. Your device ' + d.Name + ' (' + d.Device_ID__c + 
                                  ') uses this core but could not be updated with this ' +
                                  ' Program because it has already been SW BOM Reviewed and Approved.');
            mailList.add(mail);
        }
                
        // Send the emails       
        Messaging.sendEmail(mailList);
    }
    
    private static testmethod void CoreDevicePackageProgramMethodsTest1(){
        /* Test's this class and CoreDevicePackageProgram_Insert/Delete classes and trigger */
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp');
        insert cdp;
        
        Program__c program = new Program__c(Name='testProgram');
        insert program;

        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c appOnProgram = new Application__c(Name='appOnProgram', 
                                                         Account__c=a.Id, 
                                                         Application_Type__c='Preload', 
                                                         Application_Sub_Type__c='faketype', 
                                                         Application_Category__c='fakeCategory', 
                                                         Description__c='fakeDescription', 
                                                         Available_For_Use__c=true);
        insert appOnProgram;
        Application__c appOnProgram2 = new Application__c(Name='appOnProgram', 
                                                          Account__c=a.Id, 
                                                          Application_Category__c='fakeCategory', 
                                                          Description__c='fakeDescription', 
                                                          Available_For_Use__c=true);
        insert appOnProgram2;
        
        Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
        insert c;
        ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c.Id, 
                                                    Application__c=appOnProgram.Id, 
                                                    Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id, 
                                                    Application__c=appOnProgram2.Id, 
                                                    Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca1, ca2};
        
        Program_Application__c pa = new Program_Application__c(Program__c=program.Id, Application__c=appOnProgram.Id);
        insert pa;
        Program_Application__c pa2 = new Program_Application__c(Program__c=program.Id, Application__c=appOnProgram2.Id);
        insert pa2;
        
        User u = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Device__c d = new Device__c(Name='d', Core_Device_Package__c = cdp.Id);
        //Device__c d2 = new Device__c(Name='d', Core_Device_Package__c = cdp.Id, 
        //SWBOM_Reviewed_and_Approved__c='Yes', SW_BOM_List_Approver__c=u.Id);
        Device__c d3 = new Device__c(Name='d', Core_Device_Package__c = cdp.Id);
        System.runAs(u) {           
            insert new List<Device__c>{d,d3};
        }
        
        Core_Device_Package_Program__c cdpp = new Core_Device_Package_Program__c(
            Core_Device_Package__c = cdp.Id, 
            Program__c = program.Id);
        
        Test.startTest();
            insert cdpp;
            
            DeviceApplicationAssoc__c devApp = 
                [SELECT Id, Approval_Status__c 
                 FROM DeviceApplicationAssoc__c 
                 WHERE Device__c =: d3.Id 
                 AND Application__c =: appOnProgram.Id];
            devApp.Approval_Status__c = 'Approved';
            update devApp;
            devApp = [SELECT Id, Approval_Status__c
                      FROM DeviceApplicationAssoc__c 
                      WHERE Device__c =: d3.Id 
                      AND Application__c =: appOnProgram2.Id];
            devApp.Approval_Status__c = 'Approved';
            update devApp;
            
            pa.Status__c = 'Optional';
            update pa;
            pa2.Status__c = 'Optional';
            update pa2;
            program.Reviewed_Approved__c = 'Yes';
            update program;
            
            /*devApp = [SELECT Id, Approval_Status__c FROM DeviceApplicationAssoc__c 
                        WHERE Device__c =: d3.Id AND Application__c =: appOnProgram.Id];
            devApp.Approval_Status__c = 'Approved';
            update devApp;
            devApp = [SELECT Id, Approval_Status__c FROM DeviceApplicationAssoc__c 
                    WHERE Device__c =: d3.Id AND Application__c =: appOnProgram2.Id];
            devApp.Approval_Status__c = 'Approved';
            update devApp;
            
            d3.SWBOM_Reviewed_and_Approved__c='Yes';
            d3.SW_BOM_List_Approver__c=u.Id;
            
            update d3;
            
            delete cdpp;*/
        Test.stopTest();
    }
    
    private static testmethod void CoreDevicePackageProgramMethodsTest2(){
        /* Test's this class and CoreDevicePackageProgram_Insert/Delete classes and trigger */
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp');
        insert cdp;
        
        Program__c program = new Program__c(Name='testProgram');
        insert program;

        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c appOnProgram = new Application__c(Name='appOnProgram', 
                                                         Account__c=a.Id, 
                                                         Application_Type__c='Preload', 
                                                         Application_Sub_Type__c='faketype', 
                                                         Application_Category__c='fakeCategory',
                                                         Description__c='fakeDescription', 
                                                         Available_For_Use__c=true);
        insert appOnProgram;
        Application__c appOnProgram2 = new Application__c(Name='appOnProgram', 
                                                          Account__c=a.Id,
                                                          Application_Category__c='fakeCategory', 
                                                          Description__c='fakeDescription', 
                                                          Available_For_Use__c=true);
        insert appOnProgram2;
        
        Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
        insert c;
        ContApplAssoc__c ca1 = new ContApplAssoc__c(Contract__c=c.Id, 
                                                    Application__c=appOnProgram.Id, 
                                                    Governing_End_Date__c=true);
        ContApplAssoc__c ca2 = new ContApplAssoc__c(Contract__c=c.Id,
                                                    Application__c=appOnProgram2.Id, 
                                                    Governing_End_Date__c=true);
        insert new List<ContApplAssoc__c>{ca1, ca2};
        
        Program_Application__c pa = new Program_Application__c(Program__c=program.Id,
                                                               Application__c=appOnProgram.Id,
                                                               Status__c = 'Optional');
        insert pa;
        Program_Application__c pa2 = new Program_Application__c(Program__c=program.Id,
                                                                Application__c=appOnProgram2.Id,
                                                                Status__c = 'Optional');
        insert pa2;
        
        User u = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Device__c d = new Device__c(Name='d', Core_Device_Package__c = cdp.Id);
        //Device__c d2 = new Device__c(Name='d', Core_Device_Package__c = cdp.Id,
        //SWBOM_Reviewed_and_Approved__c='Yes', SW_BOM_List_Approver__c=u.Id);
        Device__c d3 = new Device__c(Name='d', Core_Device_Package__c = cdp.Id);
        System.runAs(u) {           
            insert new List<Device__c>{d,d3};
        }
        
        Core_Device_Package_Program__c cdpp = new Core_Device_Package_Program__c(
            Core_Device_Package__c = cdp.Id,
            Program__c = program.Id);
        
        Test.startTest();
            insert cdpp;
            
            /*DeviceApplicationAssoc__c devApp = [SELECT Id, Approval_Status__c 
            FROM DeviceApplicationAssoc__c 
            WHERE Device__c =: d3.Id AND Application__c =: appOnProgram.Id];
            devApp.Approval_Status__c = 'Approved';
            update devApp;
            devApp = [SELECT Id, Approval_Status__c 
            FROM DeviceApplicationAssoc__c 
            WHERE Device__c =: d3.Id 
            AND Application__c =: appOnProgram2.Id];
            devApp.Approval_Status__c = 'Approved';
            update devApp;
            
            pa.Status__c = 'Optional';
            update pa;
            pa2.Status__c = 'Optional';
            update pa2;
            program.Reviewed_Approved__c = 'Yes';
            update program;*/
            
            DeviceApplicationAssoc__c devApp = [SELECT Id, Approval_Status__c 
                                                FROM DeviceApplicationAssoc__c 
                                                WHERE Device__c =: d3.Id 
                                                AND Application__c =: appOnProgram.Id];
            devApp.Approval_Status__c = 'Approved';
            update devApp;
            devApp = [SELECT Id, Approval_Status__c 
                      FROM DeviceApplicationAssoc__c 
                      WHERE Device__c =: d3.Id 
                      AND Application__c =: appOnProgram2.Id];
            devApp.Approval_Status__c = 'Approved';
            update devApp;
            
            program.Reviewed_Approved__c = 'Yes';
            update program;
            
            d3.SWBOM_Reviewed_and_Approved__c='Yes';
            d3.SW_BOM_List_Approver__c=u.Id;
            
            update d3;
            
            delete cdpp;
        Test.stopTest();
    }
}