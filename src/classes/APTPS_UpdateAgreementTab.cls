/***************************************************************************
  COMMENT: This batch class updates the Available Tab and the Return to Tab
           field on the all Agreements
  Testmethod: UpdateAgreementTabTestClass
***************************************************************************/  

global class APTPS_UpdateAgreementTab implements Database.Batchable<sObject> {
    global String query;
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject>scope){
        List<Apttus__APTS_Agreement__c> updateAgr = new List<Apttus__APTS_Agreement__c>();
        
        for(Sobject s: scope){
            Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)s;
            if (ag.Apttus__Status_Category__c == 'Request' || ag.Apttus__Status_Category__c == 'In Filing') {
                ag.return_to_tab__c = 'tab2';
                ag.available_tab__c = 2;
            }else if ((ag.Apttus__Status_Category__c == 'In Authoring' || ag.Apttus__Status_Category__c == 'In Filing') && (ag.Apttus_Approval__Approval_Status__c == 'Not Submitted' || ag.Apttus_Approval__Approval_Status__c == '')) {
                ag.return_to_tab__c = 'tab4';
                ag.available_tab__c = 4;
            }else if ((ag.Apttus__Status_Category__c == 'In Authoring'  || ag.Apttus__Status_Category__c == 'In Filing') && (ag.Apttus_Approval__Approval_Status__c == 'Pending Approval' || ag.Apttus_Approval__Approval_Status__c == 'Approved')) {
                ag.return_to_tab__c = 'tab5';
                ag.available_tab__c = 5;
            } else if ((ag.Apttus__Status_Category__c == 'In Signatures' || ag.Apttus__Status_Category__c == 'In Filing') || ag.Apttus__Status__c == 'Fully Signed' || ag.Apttus__Status__c == 'Other Party Signatures') {
                ag.return_to_tab__c = 'tab6';
                ag.available_tab__c = 6;
            } else if (ag.Apttus__Status_Category__c == 'In Effect' || ag.Apttus__Status__c == 'Activated') {
                ag.return_to_tab__c = 'tab7';
                ag.available_tab__c = 7;
            }else{
                ag.return_to_tab__c = 'tab1';
                ag.available_tab__c = 1;
            }
            updateAgr.add(ag);
        }
        try{
            update updateAgr;
        }catch(DmlException de){
            System.debug(de.getDmlMessage(0));
        }
    }
   
    global void finish(Database.BatchableContext BC){}
}