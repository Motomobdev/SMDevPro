/*
 * Test code for this trigger found in testDeviceApplicationApprovals
 */

trigger Account on Account (after update) {
    List<Id> accountIdsWithUpdatedOwners = new List<Id>();
    for(Integer i=0; i<trigger.new.size(); i++){
        if(trigger.new[i].OwnerId != trigger.old[i].OwnerId){
            accountIdsWithUpdatedOwners.add(trigger.new[i].Id);
        }
    }
    
    if(!accountIdsWithUpdatedOwners.isEmpty()){ 
        AccountMethods.updatedApplicationsAndDevAppsAfterAccountOwnerChange(accountIdsWithUpdatedOwners); 
        
        PopulateAccountOwner.updateAccountOwnerOnPayment(accountIdsWithUpdatedOwners);
    }

}