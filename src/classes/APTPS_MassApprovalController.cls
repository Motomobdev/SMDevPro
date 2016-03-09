public with sharing class APTPS_MassApprovalController {

public Boolean isError {set; get;}
 public String agreementFeeIDString;
 public set<id> agreementFeeId = new set<id>();
     public string[] idArray;
         public Boolean status;
         
         
         public String textComment;

public String getTextComment()
{
  return textComment;
}

public void setTextComment(String newTD)
{
   textComment=newTD;
}


 
    public APTPS_MassApprovalController(ApexPages.StandardController controller) {
    
 
    agreementFeeIDString = apexpages.currentpage().getparameters().get('IDList ');
    agreementFeeId = getAgreementFeeIDSet(agreementFeeIDString);

    }
    
        //Method to split the string of IDs and put it in ID array
    //@param : String
    //@return: ID set
    public set<ID> getAgreementFeeIDSet(string agreementFeeIDString ){
        idArray = agreementFeeIDString.split(',',-2);
        for(string id : idArray ){
            agreementFeeId.add(id);
            }
        return agreementFeeId;
        }
    
    public pagereference doSuspend()
    {

        try {
        list<Apttus_Approval__Approval_Request__c> tempList = new List<Apttus_Approval__Approval_Request__c>();
        tempList = [select Id, APTPS_Is_Suspended__c,Apttus_Approval__Approver_Comments__c
                                            from Apttus_Approval__Approval_Request__c 
                                              where id in :agreementFeeId];

             for (Apttus_Approval__Approval_Request__c a: tempList)
        {
                                                      
            a.APTPS_Is_Suspended__c=true;
            a.Apttus_Approval__Approver_Comments__c = System.NOW()+ '\n (' + UserInfo.getName()+ ')\nSuspended by ' + UserInfo.getName() +'\n' + '\n\n' + a.APTPS_Last_Approval_Comments__c;
            
       if(textComment!='')
        {
         a.Apttus_Approval__Approver_Comments__c = textComment + '\n\n'+ a.Apttus_Approval__Approver_Comments__c ;
        }
                                       
        }
        update  tempList;   

        }
        catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, ex.getMessage());
            ApexPages.addMessage(myMsg);
            isError = true;
        }
      //  pagereference newPageRef = new pagereference('/'+ apprequest.Apttus_Approval__Related_Agreement__c );
        pagereference newPageRef = new pagereference('/a5o');
        
        return newPageRef;
}


public pagereference doApprove()
    {

        try {

        for (Id a: agreementFeeId)
        {
        status = Apttus_Approval.ApprovalsWebService.approveRequest(a,'\nMass Approved: ' + textComment);
    }

        
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, ex.getMessage());
            ApexPages.addMessage(myMsg);
            isError = true;
        }
     
         pagereference newPageRef = new pagereference('/a5o');
        return newPageRef;
}

public pagereference doReject()
    {

        try {

        for (Id a: agreementFeeId)
        {
        status = Apttus_Approval.ApprovalsWebService.rejectRequest(a,'\nMass Rejected: '+textComment);
    }

        
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, ex.getMessage());
            ApexPages.addMessage(myMsg);
            isError = true;
        }
     
         pagereference newPageRef = new pagereference('/a5o');
        return newPageRef;
}

public pagereference doAddComment()
    {

 try {
        list<Apttus_Approval__Approval_Request__c> tempList = new List<Apttus_Approval__Approval_Request__c>();
        tempList = [select Id, APTPS_Is_Suspended__c,Apttus_Approval__Approver_Comments__c
                                            from Apttus_Approval__Approval_Request__c 
                                              where id in :agreementFeeId];
             for (Apttus_Approval__Approval_Request__c a: tempList)
        {
                                                      

        if(textComment!='')
        {
         a.Apttus_Approval__Approver_Comments__c = textComment + '\n\n'+ a.Apttus_Approval__Approver_Comments__c ;
        }                               
        }
        update  tempList;   
        }
        catch(Exception ex){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.severity.FATAL, ex.getMessage());
            ApexPages.addMessage(myMsg);
            isError = true;
        }
     
         pagereference newPageRef = new pagereference('/a5o');
        return newPageRef;
}

public pagereference doCancel()
    {

        pagereference newPageRef = new pagereference('/a5o');       
        return newPageRef;
}

}