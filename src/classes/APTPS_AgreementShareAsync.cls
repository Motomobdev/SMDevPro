public without sharing class APTPS_AgreementShareAsync {
    /*@future
    public static void deleteAgreementShares(List <Id> agmtIdsEnd){
        try{
            System.debug('Deleted Ids'+ agmtIdsEnd);
            List <Apttus__APTS_Agreement__Share> delAgmtShares = [select id from  Apttus__APTS_Agreement__Share where parentId in :agmtIdsEnd and RowCause='APTPS_Temporary_Access_for_Approvals__c'];
            System.debug('Deleted shares'+ delAgmtShares);
            if(delAgmtShares != null && delAgmtShares.size()>0){
                Database.DeleteResult[] agmtShareDelResult = Database.delete(delAgmtShares);
                System.debug('Agreement share delete results'+agmtShareDelResult);
            }
        }catch(exception e){
            System.debug('Error when deleting shares '+ e);
        }
    }*/


    //@future
    public static void createAgreementShares(Map <Id, List<id>> agmtIdUsersMap){
        try{
            List<Apttus__APTS_Agreement__Share> agmtShares = new List<Apttus__APTS_Agreement__Share>();
            //add sharing for the users
            if(agmtIdUsersMap.size()>0){
                for(Id agmtId: agmtIdUsersMap.keyset()){
                    agmtShares.addAll(addSharing(agmtId, agmtIdUsersMap.get(agmtId)));
                }                   
            }

            // Insert all of the newly created Share records and capture save result
            System.debug('Add share for ' + agmtShares); 
            if(agmtShares.size()>0)
            {
                Database.SaveResult[] agmtShareInsertResult = Database.insert(agmtShares,false);
                System.debug('Agreement share insert results'+agmtShareInsertResult);
                //AptsDeleteAgreementShareAync.createAgreementShares(agmtShares)
            }


        }catch(exception e){
            System.debug('Error when deleting shares '+ e);
        }
        
    }


    static List<Apttus__APTS_Agreement__Share> addSharing( Id agmtId, List <Id> users)
    {
        List<Apttus__APTS_Agreement__Share> agmtShares = new List<Apttus__APTS_Agreement__Share>();
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
        return  agmtShares;
    }   
    


}