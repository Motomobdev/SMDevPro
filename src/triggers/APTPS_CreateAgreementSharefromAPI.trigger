trigger APTPS_CreateAgreementSharefromAPI on Apttus_Approval__ApprovalProcessInstance__c (after insert, after update) 
{
    String APPROVAL_SHARING_REASON= 'Temporary Access for Approvals';
     
    List<Id> agmtIdsStart = new List<Id>();
    List<Id> agmtIdsEnd = new List<Id>();
    List<Apttus__APTS_Agreement__Share> agmtShares  = new List<Apttus__APTS_Agreement__Share>();
    List<Apttus__APTS_Agreement__c> agmts = new List <Apttus__APTS_Agreement__c>();
    List <Apttus_Approval__ApprovalProcessInstance__c> pInstancesStart = new List <Apttus_Approval__ApprovalProcessInstance__c>();
    List <Apttus_Approval__ApprovalProcessInstance__c> pInstancesEnd = new List <Apttus_Approval__ApprovalProcessInstance__c>();
    // will be included in process only if the instance is IN this defined status set
    Set<String> APP_REQ_STATUS = new Set<String>{'Not Submitted', 'Assigned', 'Reassigned'};
    String STATUS_SUBMITTED = 'Submitted';
    Map <Id, List<id>> agmtIdUsersMap = new Map<Id, List<Id>> ();  
    
    
    
    try{
    
        String appProcInstId;
        String objectType;
        String approvalStatus;
        String agreementId;
    
    
        for ( Apttus_Approval__ApprovalProcessInstance__c appProcInst : trigger.new )
        {
            // STEP 1: Check the business object the approval process is for
            objectType = appProcInst.Apttus_Approval__BusinessObjectType__c;
            System.debug('Process being handled '+ appProcInst.id + ' status '+ appProcInst.Apttus_Approval__Status__c);
            System.debug('status to ' +appProcInst.Apttus_Approval__Status__c);
            System.debug('old map ' + trigger.oldMap);
            if (ObjectType == 'Apttus__APTS_Agreement__c')
            {   
                //if status has not changed skip
                if(trigger.oldMap <> null && trigger.oldMap.get(appProcInst.id) <> null && 
                    (appProcInst.Apttus_Approval__Status__c == trigger.oldMap.get(appProcInst.id).Apttus_Approval__Status__c)){
                    continue;
                }
                // STEP 2: Get Agreement Id for process start and end
                if(appProcInst.Apttus_Approval__Status__c == STATUS_SUBMITTED){
                    pInstancesStart.add(appProcInst);
                    agmtIdsStart.add(appProcInst.Apttus_Approval__BusinessObjectId__c);
                }else {
                    pInstancesEnd.add(appProcInst);
                    agmtIdsEnd.add(appProcInst.Apttus_Approval__BusinessObjectId__c);
                }
            }
        }
        System.debug('pinstance start '+ pInstancesStart);
        //for the process starts add the sharing
        if(pInstancesStart.size()>0){
            //clear out the existing temporary shares
            deleteSharing(agmtIdsStart);
            // STEP 3: Get Approval Requests for the Approval Process Instance
            List <Apttus_Approval__Approval_Request__c> appReqs = [Select Apttus_Approval__Related_Agreement__c, Apttus_Approval__Assigned_To_Type__c, Apttus_Approval__Assigned_To_Id__c 
                    FROM Apttus_Approval__Approval_Request__c  
                    WHERE Apttus_Approval__ProcessInstanceId__c in :pInstancesStart and Apttus_Approval__Approval_Status__c in :APP_REQ_STATUS];
            //get the users corresponding to the requests
            if(appReqs.size()>0){
                for(Apttus_Approval__Approval_Request__c appReq: appReqs){
                    List<Id> addUsers = agmtIdUsersMap.get(appReq.Apttus_Approval__Related_Agreement__c);
                    if(addUsers == null)
                        addUsers = new List<Id>();
                    System.debug('assigned type '+appReq.Apttus_Approval__Assigned_To_Type__c + ' and assigned id '+ appReq.Apttus_Approval__Assigned_To_Id__c );
                    if(appReq.Apttus_Approval__Assigned_To_Type__c == 'User' || appReq.Apttus_Approval__Assigned_To_Type__c == 'Role'){
                        addUsers.add(appReq.Apttus_Approval__Assigned_To_Id__c);
                    }else if(appReq.Apttus_Approval__Assigned_To_Type__c == 'Queue' )
                        addUsers.addAll(getUsersFromQueue(appReq.Apttus_Approval__Assigned_To_Id__c));
                    agmtIdUsersMap.put(appReq.Apttus_Approval__Related_Agreement__c, addUsers);
                }
            }
            //add sharing for the users
            if(agmtIdUsersMap.size()>0){
                for(Id agmtId: agmtIdUsersMap.keyset()){
                    addSharing(agmtId, agmtIdUsersMap.get(agmtId));
                }                   
            }
        }
        
            
        // Insert all of the newly created Share records and capture save result
        System.debug('Add share for ' + agmtShares); 
        if(agmtShares.size()>0)
        {
            Database.SaveResult[] agmtShareInsertResult = Database.insert(agmtShares,false);
            System.debug('Agreement share insert results'+agmtShareInsertResult);
        }
    
        //delete the shares not needed anymore
        
        //deleteSharing(agmtIdsEnd);   //commented based on motorola requirement. if this is needed in future, thecode can be uncommented to do the delete function
        
    } 
    catch(Exception e)
    {
        //agmts[0].addError('Error in trigger'+e);
        System.debug('Error in agreement trigger:'+e);
    }
    
    void deleteSharing(List <Id> agmtIds){
        //delete the shares not needed anymore
        if(agmtIds.size()>0)
        {
            System.debug('Deleted Ids'+ agmtIds);
            List <Apttus__APTS_Agreement__Share> delAgmtShares = [select id from  Apttus__APTS_Agreement__Share where parentId in :agmtIds and RowCause='APTPS_Temporary_Access_for_Approvals__c'];
            System.debug('Deleted shares'+ delAgmtShares);
            if(delAgmtShares != null && delAgmtShares.size()>0)
            {
                Database.DeleteResult[] agmtShareDelResult = Database.delete(delAgmtShares);
                System.debug('Agreement share delete results'+agmtShareDelResult);
            }
        }
    }
    
    
    void addSharing( Id agmtId, List <Id> users)
    {
        if(agmtId <> null && users<> null && users.size() > 0){
            for(Id userId: users){
                Apttus__APTS_Agreement__Share agmtShare = new Apttus__APTS_Agreement__Share();
                agmtShare.parentId = agmtId;
                agmtShare.UserOrGroupId = userId; 
                agmtShare.AccessLevel = 'Read';
                agmtShare.RowCause = Schema.Apttus__APTS_Agreement__Share.RowCause.APTPS_Temporary_Access_for_Approvals__c;
                agmtShares.add(agmtShare);
                System.debug('Add sharing for ' + userId);
            }
        }   
    }   
    
    List <Id> getUsersFromQueue (Id queueId){
        List <Id> users = new List<Id>();
        if(queueId<> null){
            List <GroupMember> groupMembers = [select userorgroupid from GroupMember where groupId = :queueId];
            if(groupMembers <> null && groupMembers.size()>0){
                for(GroupMember gm: groupMembers){
                    users.add(gm.userorgroupid);
                }
            }
        }
        return users;
    }   
    
}