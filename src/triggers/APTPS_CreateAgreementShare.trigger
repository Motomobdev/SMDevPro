trigger APTPS_CreateAgreementShare on Apttus_Approval__Approval_Request__c (after insert, after update) 
{
    String APPROVAL_SHARING_REASON= 'Temporary Access for Approvals';
     
    List<Id> agmtIdsStart = new List<Id>();
    List<Id> agmtIdsEnd = new List<Id>();
    List<Apttus__APTS_Agreement__Share> agmtShares  = new List<Apttus__APTS_Agreement__Share>();
    List<Apttus__APTS_Agreement__c> agmts = new List <Apttus__APTS_Agreement__c>();
    List <Apttus_Approval__Approval_Request__c> pStart = new List <Apttus_Approval__Approval_Request__c>();
    List <Apttus_Approval__Approval_Request__c> pEnd = new List <Apttus_Approval__Approval_Request__c>();
    // will be included in process only if the instance is IN this defined status set
    Set<String> APP_REQ_STATUS = new Set<String>{'Not Submitted', 'Assigned', 'Reassigned'};
    String STATUS_SUBMITTED = 'Submitted';
    String STATUS_REASSIGNED = 'Reassigned';
    String STATUS_ASSIGNED = 'Assigned';
    Map <Id, List<id>> agmtIdUsersMap = new Map<Id, List<Id>> ();
    
    
    
    try{
    
        String appProcInstId;
        String objectType;
        String approvalStatus;
        String agreementId;
    
    
        for ( Apttus_Approval__Approval_Request__c appReq : trigger.new )
        {
            System.debug('Request being handled '+ appReq.id + ' status '+ appReq.Apttus_Approval__Approval_Status__c);
                //if assigned to has not changed skip
            System.debug('assigned to ' +appReq.Apttus_Approval__Assigned_To_Id__c);
            System.debug('old map ' + trigger.oldMap);
            if((trigger.oldMap <> null && trigger.oldMap.get(appReq.id) <> null) && 
                (appReq.Apttus_Approval__Approval_Status__c == trigger.oldMap.get(appReq.id).Apttus_Approval__Approval_Status__c &&
                    appReq.Apttus_Approval__Assigned_To_Id__c == trigger.oldMap.get(appReq.id).Apttus_Approval__Assigned_To_Id__c)){
                continue;
            }
            // STEP 2: Get Agreement Id for process start and end
            if( appReq.Apttus_Approval__Approval_Status__c == STATUS_REASSIGNED){
                pStart.add(appReq);
                agmtIdsStart.add(appReq.Apttus_Approval__Related_Agreement__c);
            }else {
                pEnd.add(appReq);
                agmtIdsEnd.add(appReq.Apttus_Approval__Related_Agreement__c);
            }
        }
        //for the req starts add the sharing
        System.debug('req starts is '+ pstart);
        if(pStart.size()>0){
            //get the users corresponding to the requests
            for(Apttus_Approval__Approval_Request__c appReq: pStart){
                List<Id> addUsers = agmtIdUsersMap.get(appReq.Apttus_Approval__Related_Agreement__c);
                if(addUsers == null)
                    addUsers = new List<Id>();
                if(appReq.Apttus_Approval__Assigned_To_Type__c == 'User' || appReq.Apttus_Approval__Assigned_To_Type__c == 'Role'){
                    addUsers.add(appReq.Apttus_Approval__Assigned_To_Id__c);
                }//else if(appReq.Apttus_Approval__Assigned_To_Type__c == 'Queue' )
                    //this should not occur. system does not allow request to be reassigned to a queue
                    //addUsers.addAll(getUsersFromQueue(appReq.Apttus_Approval__Assigned_To_Id__c));
                
                agmtIdUsersMap.put(appReq.Apttus_Approval__Related_Agreement__c, addUsers); 
                System.debug('the agmtid is '+ appReq.Apttus_Approval__Related_Agreement__c + ' and addusers is ' + addUsers );
            }
            System.debug('users to be added to share '+ agmtIdUsersMap);
            
            //call the async method to add the agmt shares so that it can be done without sharing - this will avoid any permission issue for users setting backup
            APTPS_AgreementShareAsync.createAgreementShares(agmtIdUsersMap);
            /*
            //add sharing for the users
            if(agmtIdUsersMap.size()>0){
                for(Id agmtId: agmtIdUsersMap.keyset()){
                    addSharing(agmtId, agmtIdUsersMap.get(agmtId));
                }                   
            }*/
        }
        
        /*  moved to separate class to avoid permission issue
        // Insert all of the newly created Share records and capture save result
        System.debug('Add share for ' + agmtShares); 
        if(agmtShares.size()>0)
        {
            Database.SaveResult[] agmtShareInsertResult = Database.insert(agmtShares,false);
            System.debug('Agreement share insert results'+agmtShareInsertResult);
            //AptsDeleteAgreementShareAync.createAgreementShares(agmtShares)
        }
    
        //delete the shares not needed anymore // commented based on Motorola requirements
        if(agmtIdsEnd.size()>0)
        {
            System.debug('Deleted Ids'+ agmtIdsEnd);
            //AptsDeleteAgreementShareAync.deleteAgreementShares(agmtIdsEnd);
        }
        */
    } 
    catch(Exception e)
    {
        //agmts[0].addError('Error in trigger'+e);
        System.debug('Error in agreement trigger:'+e);
    }
    
    
    
    /*
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
    }*/ 
    
}