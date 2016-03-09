public with sharing class NDA_DisclosureRequest {

    public NDA_Disclosure_Request__c objNDAdr {get; set;}
    public NDA__c objNDA {get; set;}
    public String strNDAFileID{get; set;}
    public Boolean boolIsSummary {get; set;}
    
    public NDA_DisclosureRequest(ApexPages.StandardController controller) {
        boolIsSummary = false;
        objNDAdr = (NDA_Disclosure_Request__c) controller.getRecord();
        String strID = objNDAdr.Id;
          if(strID != null && strID != ''){
            String strWherClause;
            strWherClause=' from NDA_Disclosure_Request__c WHERE ID = \'' + objNDAdr.id +'\'' ;
            objNDAdr = Database.query(NDA_HelperDatabase.fnAllColumnsByCustomQuery('NDA_Disclosure_Request__c', strWherClause));
            if(objNDAdr != null){
                 boolIsSummary = true;                 
             }
        }
    }
    
    public Pagereference fnAction(){     
      if(!boolIsSummary){
         strNDAFileID = ApexPages.currentPage().getParameters().get('pv02');   
          if(strNDAFileID != null && strNDAFileID != ''){  
                objNDA = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA__c', strNDAFileID));
                objNDAdr.NDA__c = objNDA.id;
                objNDAdr.NDAFileID__c = objNDA.NDAFileID__c;
                objNDAdr.DPL_Status__c = 'Not Submitted';
            } 
         return null;
       } else {
        strNDAFileID = ApexPages.currentPage().getParameters().get('pv02');   
          if(strNDAFileID != null && strNDAFileID != ''){
           objNDA = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA__c', strNDAFileID));
           objNDAdr.NDA__c = objNDA.id;
          }         
           return null;
       }
   }
   
   /*
    * This is a method for submitting products disclosed for Category lead approval to re-use existing executed product NDAs. 
    */
    public PageReference fnUpdate() {       
       if(objNDAdr.Software__c == false && objNDAdr.Premium_Products__c == false 
       && objNDAdr.Value_Products__c == false && objNDAdr.Companion_Products__c == false) {                                
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please make Category selection to Submit disclosure for approval'); 
            ApexPages.addMessage(myMsg);
            return null;                                    
        }
        try{            
            //objNDAdr.NDAFileID__c = objNDA.NDAFileID__c;
            update objNDAdr;               

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Disclosure request is updated successfully');
            ApexPages.addMessage(myMsg);                     
            return null;            
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Some error occurred. Please contact IT.'); 
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
   
    /*
    * This is a method for submitting products disclosed for Category lead approval to re-use existing executed product NDAs. 
    */
    public PageReference fnSubmitApproval() {       
       if(objNDAdr.Software__c == false && objNDAdr.Premium_Products__c == false 
       && objNDAdr.Value_Products__c == false && objNDAdr.Companion_Products__c == false) {                                
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please make Category selection to Submit disclosure for approval'); 
            ApexPages.addMessage(myMsg);
            return null;                                    
        }
        try{            
            objNDAdr.NDAFileID__c = objNDA.NDAFileID__c;
            objNDAdr.DPL_Status__c = 'Pending';
            insert objNDAdr;   
            
             
            if(objNDAdr.Id != null){
                NDA_Disclosure_Request__c obj = [select id, ndafileid__c,DPL_Status__c from NDA_Disclosure_Request__c where id =: objNDAdr.id];

                    // create the new approval request to submit
                         Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                         req.setComments('Submitted for approval. Please approve.');
                         req.setObjectId(obj.id);
                     // submit the approval request for processing
                         Approval.ProcessResult result = Approval.process(req);
                     // display if the reqeust was successful   
                      
                 } 
                 
                 /* else if(obj.DPL_Status__c == 'Pending') {
                     update obj;
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Disclosure request is updated successfully');
                     ApexPages.addMessage(myMsg); 
                 }   */ 
                 
                 ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Disclosure request is submitted for approval successfully');
                 ApexPages.addMessage(myMsg);                   
                                
            return null;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Some error occurred. Please contact IT.'); 
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    
     public PageReference fnShowPremium() {     
        return null;
    }   
    
    public PageReference fnShowValue() {     
        return null;
    } 
     
    public PageReference fnShowCompanion() {     
        return null;
    } 
     
    public PageReference fnShowSoftware() {     
        return null;
    }  

}