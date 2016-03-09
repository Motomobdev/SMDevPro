public with sharing class DeviceApplication_Update {
    public static void beforeUpdate(List<DeviceApplicationAssoc__c> newList, List<DeviceApplicationAssoc__c> oldList){
        //Profile motoDevSysAdmin = [SELECT Id FROM Profile WHERE Name = 'MotoDev - SysAdmin' LIMIT 1];
        Id motoDevSysAdminId = '00e40000000oqQ9AAI';
        Set<Id> devIdsInludeBomOrSDCard = new Set<Id>();
        List<Id> devAppsToUpdateAppItemState = new List<Id>();
                
        Map<Id, DeviceApplicationAssoc__c> devAppsWithExtendedFields = 
            new Map<Id, DeviceApplicationAssoc__c> ([
                SELECT Id, Royalty_High__c, Application__r.Skip_LRB_Approval__c, 
                    Skip_SDS_Approval__c, Skip_App_Manager_Selection_Approval__c, 
                    Device__r.Skip_Budget_Approval__c, Skip_Partner_Manager_Approval_Country__c 
                FROM DeviceApplicationAssoc__c 
                WHERE Id IN : newList]);
        // Instanciate instance of DeviceApplicationApprovalProcess class so we can use its methods
        //DeviceApplicationApprovalProcess daap = new DeviceApplicationApprovalProcess(trigger.new);
        
        Set<Id> sourceIds = new Set<Id>();
        Set<Id> appIds = new Set<Id>();
        Set<Id> deviceIds = new Set<Id>();
        
        for(Integer i=0; i<newList.size(); i++){
            if(newList[i].Source_Id__c != null){ sourceIds.add(newList[i].Source_Id__c); }
            if(newList[i].Application__c != null){ sourceIds.add(newList[i].Application__c); }
            appIds.add(newList[i].Application__c);
            deviceIds.add(newList[i].Device__c);
        }
        
        Map<String, Stable_Application__c> stableAppCombinedIdStableAppMap = new Map<String, Stable_Application__c>();
        for(Stable_Application__c s : [SELECT Id, Stable__c, Application__c, 
                                       Stable_App_Status__c, Owner__c
                                       FROM Stable_Application__c 
                                       WHERE Stable__c IN : sourceIds
                                       AND Application__c IN : appIds]){
            stableAppCombinedIdStableAppMap.put(s.Stable__c + '' + s.Application__c, s);
        }

        for(Integer i=0; i<newList.size(); i++){        
            system.debug('include new, include old, source_id: ' + 
                         newList[i].Include_in_BOM__c + ', ' + 
                         oldList[i].Include_in_BOM__c + ', ' + 
                         newList[i].Source_Id__c);
            if(newList[i].Include_in_BOM__c == false && newList[i].Include_in_BOM__c != oldList[i].Include_in_BOM__c){
                if(newList[i].Source_Id__c != null && 
                   stableAppCombinedIdStableAppMap.get(newList[i].Source_Id__c + '' + newList[i].Application__c) != null){
                    if(stableAppCombinedIdStableAppMap.get(newList[i].Source_Id__c + ''
                                                           + newList[i].Application__c).Stable_App_Status__c == 'Mandatory'){
                        if(stableAppCombinedIdStableAppMap.get(newList[i].Source_Id__c + '' 
                                                               + newList[i].Application__c).Owner__c != UserInfo.getUserId() 
                           || UserInfo.getProfileId() != motoDevSysAdminId){
                            newList[i].addError('This Application cannot be taken off the ' +
                                                'BOM because it is a Stable mandatory Application');
                        }
                    }
                }
            }
            
            /* Rajesh - Start */
            /* Bineet: Commented for now as it was causing SOQL 101 error---DeviceApplicationMethods.checkForDuplicates(newList, deviceIds, appIds); */
            /* Rajesh - End */

            /*** Begin calculate % executed contraced on BOM or SD ***/     
            if((newList[i].Include_in_BOM__c != oldList[i].Include_in_BOM__c) || 
               (newList[i].Include_on_SD_Card__c != oldList[i].Include_on_SD_Card__c)){
                devIdsInludeBomOrSDCard.add(newList[i].Device__c); // for % executed contracts on BOM/SD
            }
            /*** End calculate % executed contraced on BOM or SD ***/
            
            system.debug('THIS IS MAPskipLRBApproval: ' + devAppsWithExtendedFields.get(newList[i].Id).Application__r.Skip_LRB_Approval__c);
            system.debug('THIS IS MAPskipSDSApproval: ' + devAppsWithExtendedFields.get(newList[i].Id).Skip_SDS_Approval__c);
            system.debug('THIS IS MAPskipAppManagerSelectionApproval: ' + devAppsWithExtendedFields.get(newList[i].Id).Skip_App_Manager_Selection_Approval__c);
            system.debug('THIS IS MAPskipBudgetApproval: ' + devAppsWithExtendedFields.get(newList[i].Id).Device__r.Skip_Budget_Approval__c);
            system.debug('THIS IS MAPskipPartnerManagerChecklistApproval: ' + devAppsWithExtendedFields.get(newList[i].Id).Skip_Partner_Manager_Approval_Country__c);
                                    
            // Set Approval and Past fields to N/A and true after they have been skipped
            if(newList[i].Approval_Status__c == 'In Progress' || newList[i].Approval_Status__c == 'Approved'){              
                if(oldList[i].Approval_Status__c == 'Not Submitted' || oldList[i].Approval_Status__c == 'Rejected'){
                    if(devAppsWithExtendedFields.get(newList[i].Id).Application__r.Skip_LRB_Approval__c){
                        newList[i].LRB_Approval__c = 'Approved';
                        newList[i].Past_LRB_Approval__c = true;
                    }
                }
                
                if(newList[i].Past_LRB_Approval__c == true && oldList[i].Past_LRB_Approval__c == false){
                    if(devAppsWithExtendedFields.get(newList[i].Id).Skip_SDS_Approval__c){
                        newList[i].DTS_Approval__c = 'N/A';
                        newList[i].Past_SDS_Approval__c = true;
                    }
                }
                
                if(newList[i].Past_SDS_Approval__c == true && oldList[i].Past_SDS_Approval__c == false){
                    if(devAppsWithExtendedFields.get(newList[i].Id).Skip_App_Manager_Selection_Approval__c){
                        newList[i].Application_Mgr_Selection_Approval__c = 'Approved';
                        newList[i].Past_App_Mgr_Approval__c = true;
                    }
                }
                
                if(newList[i].Past_App_Mgr_Approval__c == true && oldList[i].Past_App_Mgr_Approval__c == false){
                    if(devAppsWithExtendedFields.get(newList[i].Id).Device__r.Skip_Budget_Approval__c || (!devAppsWithExtendedFields.get(newList[i].Id).Device__r.Skip_Budget_Approval__c && devAppsWithExtendedFields.get(newList[i].Id).Royalty_High__c == 0.0000)){
                        newList[i].Confirmation_of_Budget_Royalties__c = 'Approved';
                        newList[i].Past_Budget_Approval__c = true;
                    }
                }
                
                if(newList[i].Past_Budget_Approval__c == true && oldList[i].Past_Budget_Approval__c == false){
                    if(devAppsWithExtendedFields.get(newList[i].Id).Skip_Partner_Manager_Approval_Country__c){
                        newList[i].Partner_Manager_Checklist_Approval__c = 'Approved';
                        newList[i].Past_Partner_Manager_Approval__c = true;
                    }   
                }
                
                if(newList[i].Past_Partner_Manager_Approval__c == true && oldList[i].Past_Partner_Manager_Approval__c == false){
                    newList[i].Approval_Status__c = 'Approved';
                }                   
            }

            if(newList[i].Approval_Status__c == 'Rejected' && oldList[i].Approval_Status__c != 'Rejected'){
                newList[i].LRB_Approval__c = 'In Progress';
                newList[i].Past_LRB_Approval__c = false;
                newList[i].DTS_Approval__c = 'In Progress';
                newList[i].Past_SDS_Approval__c = false;
                newList[i].Application_Mgr_Selection_Approval__c = 'In Progress';
                newList[i].Past_App_Mgr_Approval__c = false;
                newList[i].Confirmation_of_Budget_Royalties__c = 'In Progress';
                newList[i].Past_Budget_Approval__c = false;
                newList[i].Partner_Manager_Checklist_Approval__c = 'In Progress';
                newList[i].Past_Partner_Manager_Approval__c = false;
            }
            
            //Set devapp item state since workflow will not run after approval process finishes
            if(newList[i].Approval_Status__c != null && newList[i].Application_Contract_Status__c != null && newList[i].X3rd_Party_Approval_Status__c != null && newList[i].Application_Governing_EndDate__c != null && newList[i].SA_Date__c != null){
                if(newList[i].Approval_Status__c == 'Approved' && newList[i].Application_Contract_Status__c.contains('Execution and Processing') && (newList[i].X3rd_Party_Approval_Status__c=='N/A' || newList[i].X3rd_Party_Approval_Status__c=='Approved') && newList[i].Application_Governing_EndDate__c > newList[i].SA_Date__c.addDays(14) && newList[i].App_Item_State__c != '35 - Full Release'){
                    devAppsToUpdateAppItemState.add(newList[i].Id);
                }
            }           
        }
        
        /*** Begin calculate % contracts executed & on BOM/SD ***/
        if(!devIdsInludeBomOrSDCard.isEmpty()){
            DevAppsOnBomSDWithExecutedContracts.calculatePercentOfExecutedContractsOnBomOrSDCardFromDeviceId(devIdsInludeBomOrSDCard);
        }
        /*** end calculate % ***/
        
        if(!devAppsToUpdateAppItemState.isEmpty()){
            Map<Id, DeviceApplicationAssoc__c> daIdMap = new Map<Id, DeviceApplicationAssoc__c>([SELECT Id, Application__r.ECCN_subECCN_Value__c, Application__r.ENC_License_Category__c, Application__r.Royalty_Current__c FROM DeviceApplicationAssoc__c WHERE Id IN : devAppsToUpdateAppItemState]);
            for(Integer i=0; i<newList.size(); i++){
                if(daIdMap.containsKey(newList[i].Id)){
                    if(daIdMap.get(newList[i].Id).Application__r.ECCN_subECCN_Value__c != null && daIdMap.get(newList[i].Id).Application__r.ENC_License_Category__c != null){
                        if(daIdMap.get(newList[i].Id).Application__r.ECCN_subECCN_Value__c != '' && daIdMap.get(newList[i].Id).Application__r.ENC_License_Category__c != ''){
                            if(daIdMap.get(newList[i].Id).Application__r.Royalty_Current__c == null){
                                newList[i].App_Item_State__c = '32 - Controlled';
                            } else {
                                newList[i].App_Item_State__c = '35 - Full Release';
                            }
                        }
                    }
                }
            }   
        }
    }   
    
    private static testmethod void DeviceApplication_UpdateTest(){
        Stable__c s = new Stable__c(Name='s');
        insert s;

        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;
        Application__c appOnStable = new Application__c(Name='appOnStable', Account__c=a.Id, Application_Type__c='fakeValueToSkipSomeSteps', Application_Category__c='fakeCategory', Description__c='fakeDescription');
        insert appOnStable;
        
        appOnStable.Automate_Partner_Checklist_Approval__c = true;
        appOnStable.Available_For_Use__c = true;
        update appOnStable;

        Contract c = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c;
        ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=appOnStable.Id, Governing_End_Date__c=true);
        insert ca;
        
        Stable_Application__c sa = new Stable_Application__c(Stable__c=s.Id, Application__c=appOnStable.Id, Stable_App_Status__c = 'Mandatory');
        insert sa;
        
        //User u = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Device__c d = new Device__c(Name='d', Stable__c = s.Id, Skip_Budget_Approval__c = true);
        //System.runAs(u) {         
            insert d;
        //}
        
        StableDeviceMethods.addStableElementsToDevice(d);
        
        DeviceApplicationAssoc__c da = [SELECT Id, Include_in_BOM__c FROM DeviceApplicationAssoc__c WHERE Device__c =: d.Id];
        da.Skip_Partner_Manager_Approval_Country__c = true;
        update da;
        
        User u = [SELECT Id FROM User WHERE Name != 'MotoDev - SysAdmin' AND isActive = true LIMIT 1];
        
        Test.startTest();
            //da.Source_Id__c = '32452';
            //da.Include_in_BOM__c = false;
            //update da;
            //da.Include_in_BOM__c = true;
            //update da;
            
            da.Source_Id__c = s.Id;
            da.Include_in_BOM__c = false;
            try{
                System.runAs(u){
                    update da;
                }
            } catch (System.Dmlexception e){
                System.assert(e.getMessage().contains('This Application cannot be taken off the BOM because it is a Stable mandatory Application'));
            }
            
            sa.Stable_App_Status__c = 'Not Mandatory';
            update sa;
            
            //da.Approval_Status__c = 'In Progress';
            //update da;
            
            //da.Approval_Status__c = 'Rejected';
            //update da;
            
            /* Added by Neel on 28/Aug/2012 */
            /********************************/
            da.Approval_Status__c = 'Not Submitted';
            update da;
            da.Approval_Status__c = 'In Progress';
            update da;
            da.Approval_Status__c = 'Rejected';
            update da;
            da.Past_App_Mgr_Approval__c = true;
            update da;
            da.Past_Budget_Approval__c = true;
            update da;
            da.Past_LRB_Approval__c = true;
            update da;
            da.Past_Partner_Manager_Approval__c = true;
            update da;
            da.Past_SDS_Approval__c = true;
            update da;
            
        Test.stopTest();
    }
}