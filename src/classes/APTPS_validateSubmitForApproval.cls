public class APTPS_validateSubmitForApproval {

   // Test Class: APTPS_TestValidateSubmitForApproval
   public Apttus__APTS_Agreement__c agreement;
   ID agreementID;
   String agreementString;
   boolean enableAttachments = true;

   public APTPS_validateSubmitForApproval() {
       agreementID= ApexPages.currentPage().getParameters().get('sObjectId');
       agreementString = ApexPages.currentPage().getParameters().get('sObjectType');
       agreement=[select APTPS_Deal_Specific_Approver__c,Business_Unit_Finance_Approver__c,
                       Apttus__Requestor__c,APTPS_Business_VP__c,
                       Procurement_Approver__c,Legal_Approver__c,APTPS_Procurement_VP__c,
                       APTPS_Staff_Level_SLT_1__c,
                       APTPS_Staff_Level_SLT_2__c,APTPS_Staff_Level_SLT_3__c,
                       APTPS_Practice_Area__c 
                   from Apttus__APTS_Agreement__c where id = :agreementID];
   }
   
    public pagereference checkApprovalProcessType() {
        system.debug(agreement.APTPS_Practice_Area__c);
        
        if (agreement.APTPS_Practice_Area__c == 'Indirect Supply Chain' ||
            agreement.APTPS_Practice_Area__c == 'Direct Supply Chain') {
             List<String> approvers = new List<String>();   
             approvers.add(agreement.APTPS_Deal_Specific_Approver__c);
             approvers.add(agreement.Business_Unit_Finance_Approver__c);
             //approvers.add(agreement.Apttus__Requestor__c);
             approvers.add(agreement.APTPS_Business_VP__c);
             approvers.add(agreement.Procurement_Approver__c);
             approvers.add(agreement.Legal_Approver__c);
             approvers.add(agreement.APTPS_Procurement_VP__c);
             approvers.add(agreement.APTPS_Staff_Level_SLT_1__c);
             approvers.add(agreement.APTPS_Staff_Level_SLT_2__c);
             approvers.add(agreement.APTPS_Staff_Level_SLT_3__c);
             
             Integer count = 0;
             for(String approver : approvers) {
                 if (approver <> null) {
                    count++;
                 }
            }
            system.debug('Count: ' + count);

            if (count < 1) {
               system.debug('Please select an ad-hoc approver and then submit for approval.');
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 
                                      'At least one ad-hoc approver is required.'));
               return null;
            } else {
                string url = '/apex/Apttus_Approval__ApprovalContextSubmit?sObjectType='
                           + agreementString + '&enableAttachments=true&sObjectId='
                           + agreementID;
                pagereference  pageref = new pagereference(url);
                //pagref.setRedirect(true);
                return pageref ;
            }
        } else if (agreement.APTPS_Practice_Area__c == 'GTM' ||  // Goto Market
                   agreement.APTPS_Practice_Area__c == 'Marketing' ||
                   agreement.APTPS_Practice_Area__c == 'REWS') {
            string url = '/apex/Apttus_Approval__ApprovalContextSubmit?sObjectType='
                       + agreementString + '&enableAttachments=true&sObjectId='
                       + agreementID;
            pagereference  pageref = new pagereference(url);
            //pagref.setRedirect(true);
            return pageref ;
        }
        return null;
    }
    
     public pagereference goBack() {
       PageReference pagref = new Pagereference('/'+agreementID);
      // pagref.setRedirect(true);
       return pagref;
     }
}