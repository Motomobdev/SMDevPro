public with sharing class APTPS_ApprovalController3 {

    public Boolean isError {set; get;}
    Apttus_Approval__Approval_Request__c apprequest;
    Apttus__APTS_Agreement__c agreement;

    public APTPS_ApprovalController3(ApexPages.StandardController controller) {
        apprequest = (Apttus_Approval__Approval_Request__c)controller.getrecord();
    }
    
    public pagereference doSuspend() {

        try {

            if (apprequest.APTPS_Is_Suspended__c != true) {
               // Update Status to Suspended
               apprequest.APTPS_Is_Suspended__c = true;

               // Append comments
               String approvalComments = apprequest.Apttus_Approval__Approver_Comments__c;
               if (approvalComments == null)
                   approvalComments = '';

               String lastApprovalComments = apprequest.APTPS_Last_Approval_Comments__c;
               if (lastApprovalComments == null)
                   lastApprovalComments = '';
               
               apprequest.Apttus_Approval__Approver_Comments__c = 
                           System.NOW()+ '\n (' + 
                           UserInfo.getName()+ ')\n' + 
                           + approvalComments + '\n\n' +
                           lastApprovalComments;
    
               update  apprequest;
            }
        } catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, ex.getMessage());
            ApexPages.addMessage(myMsg);
            isError = true;
        }
        
        pagereference newPageRef = new pagereference('/'+ apprequest.Apttus_Approval__Related_Agreement__c );
        
        return newPageRef;
    }

}