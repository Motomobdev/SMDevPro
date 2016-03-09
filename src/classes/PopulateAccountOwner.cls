public with sharing class PopulateAccountOwner {

    /*
     *
     * Change history:
     * Date: 11-Jan-2013 Changed by: Rajesh Krishnaiah
     * Change: Moved the account owner change method to future to avoid too many DML rows error
     */
    public static void populateAccountOwnerOnPayment(Map<Id, List<Payment__c>> accountIdPaymentListMap){
        Map<Id, Id> accountIdOwnerIdMap = new Map<Id, Id>();
        
        for(Account a : [SELECT Id, OwnerId FROM Account WHERE Id IN : accountIdPaymentListMap.keySet()]){
            for(Payment__c p : accountIdPaymentListMap.get(a.Id)){
                p.Account_Manager__c = a.OwnerId;
            }
        }
    }
    
    public static void updateAccountOwnerOnPayment(List<Id> accountIds){
        List<Payment__c> paymentsToUpdate = new List<Payment__c>();
        
        for(Payment__c p : [SELECT Id, Account_Manager__c, Account__c, Account__r.OwnerId FROM Payment__c WHERE Account__c IN : accountIds]){
            p.Account_Manager__c = p.Account__r.OwnerId;
            paymentsToUpdate.add(p);
        }
        
        if(!paymentsToUpdate.isEmpty()){ 
            update paymentsToUpdate;
        }
    }
    
    private static testmethod void populateAccountOwnerOnPaymentTest() {
        Account a1 = new Account(Name='a1', ownerId = '005400000012v9NAAQ'); // motorola partner managements
        Account a2 = new Account(Name='a2', ownerId = '005400000013EXdAAM'); // automated data feed
        insert a1;
        insert a2;
        Payment__c p = new Payment__c(Name = 'testPayment', Account__c = a1.Id);
        
        Test.startTest();
            insert p;
            p.Account__c = a2.Id;
            update p;
            
            a2.OwnerId = '005400000012v9NAAQ';
            update a2;
        Test.stopTest();
        
    }

}