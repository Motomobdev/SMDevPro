public with sharing class APTPS_Generate_StatustoAuthorContract {

    public Boolean isError {set; get;}
    Apttus__APTS_Agreement__c agreement;
    List<Apttus__APTS_Agreement__c> agmt;
    
    public APTPS_Generate_StatustoAuthorContract(ApexPages.StandardController controller) {
        agreement = (Apttus__APTS_Agreement__c)controller.getrecord();
        
        agmt = [select Id, Name ,Apttus__Status_Category__c, Apttus__Status__c, 
                    RecordTypeId, APTPS_Executive_Summary_Generated__c
                from Apttus__APTS_Agreement__c 
                where id = :agreement.id];
    }
    
    public pagereference UpdateStatus() {
        try {

            if (agmt[0].Apttus__Status_Category__c != 'In Authoring') {
                agmt[0].Apttus__Status_Category__c =  'In Authoring';      
                update agmt[0];
            }
            
            if( agmt[0].Apttus__Status__c != 'Author Contract') {
                agmt[0].Apttus__Status__c =  'Author Contract';   
                update agmt[0];
             }
             
             agmt[0].APTPS_Executive_Summary_Generated__c = true;
             update agmt[0];
        } catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, ex.getMessage());
            ApexPages.addMessage(myMsg);
            isError = true;
        }
        
        pagereference newPageRef = new pagereference('/apex/Apttus__SelectTemplate?id='+ agreement.id + '&action=Generate_Supporting_Document&templateType=Supporting_Document');

        return newPageRef;
    }
}