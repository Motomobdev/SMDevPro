public class APTPS_RequestListController{

     List<RequestWrapper> ListOfApprovalRequests;
    
    Public List<RequestWrapper> GetApprovalRequests(){
    
        List<Apttus_Approval__Approval_Request__c> ListOfRequests=new List<Apttus_Approval__Approval_Request__c>();
        ListOfApprovalRequests=new List<RequestWrapper>();
        
        ListOfRequests=[Select Name,APTPS_Approval_Actions__c, Apttus_Approval__Approval_Status__c, 
                Apttus_Approval__Date__c, Apttus_Approval__Assigned_To_Name__c, Apttus_Approval__DependsOn__c ,
                Apttus_Approval__Actual_Approver__c, Apttus_Approval__Approver_Comments__c,createdDate,
                APTPS_Status__c,
                Apttus_Approval__Related_Agreement__r.Apttus__Total_Contract_Value__c,
                Apttus_Approval__Related_Agreement__r.id,
                Apttus_Approval__Related_Agreement__r.Apttus__Account__r.name,
                Apttus_Approval__Related_Agreement__r.Apttus__FF_Agreement_Number__c,
                Apttus_Approval__Related_Agreement__r.Name,
                APTPS_Last_Approval_Comments__c,
                Approver_Comment__c  
                From Apttus_Approval__Approval_Request__c
                where ownerid=:UserInfo.getUserId() 
                    And Apttus_Approval__Approval_Status__c in ('Assigned','Reassigned','On Hold')];
     
        for(Apttus_Approval__Approval_Request__c Request:ListOfRequests){
        
            RequestWrapper RW=new RequestWrapper(Request,false);
            ListOfApprovalRequests.add(RW);
            
        }
                    
        return ListOfApprovalRequests;
    
    }
    
    public List<Apttus_Approval__Approval_Request__c> getCheckedRecords(){
        
        List<Apttus_Approval__Approval_Request__c> ListOfRequests=new List<Apttus_Approval__Approval_Request__c>();
        
        for(RequestWrapper RW:ListOfApprovalRequests){
            if(RW.isChecked==true){
                ListOfRequests.Add(RW.Request);
            }
        }
        
        return ListOfRequests;
    }

    public pagereference doSuspend(){
    
        String approvalComments = '';
        String previousComments = '';
        
        List<Apttus_Approval__Approval_Request__c> ListOfRequests=getCheckedRecords();
        
        for(Apttus_Approval__Approval_Request__c Request:ListOfRequests){                                              
            // Set Suspended Flag to true
            Request.APTPS_Is_Suspended__c=true;
            
            //// Modified by SD - 08/29 to fix null comments issue
            // Get Previous Comments
            if (Request.Apttus_Approval__Approver_Comments__c == null)
                previousComments = '';
            else
                previousComments = Request.Apttus_Approval__Approver_Comments__c;
            
            // Append Comments
            if (Request.Approver_Comment__c == null)
                approvalComments = '';
            else
                approvalComments = Request.Approver_Comment__c;
                
            // Call web service to suspend
            //Request.Apttus_Approval__Approver_Comments__c += 'Suspended on ' + System.NOW()+ '\n (' + UserInfo.getName()+ ')';
            Request.Apttus_Approval__Approver_Comments__c = '\n' + System.NOW()+ '\n(' + UserInfo.getName()+ ')' + '\nSuspended by ' + UserInfo.getName() + '.\n' + approvalComments +'\n\n'+ previousComments;
         
            // Reset comments to blank
            Request.Approver_Comment__c = '';
            approvalComments = '';
         }
         
         Update ListOfRequests;
         
         return GoBack();
    }
    
    public pagereference doApprove(){
       
       List<Apttus_Approval__Approval_Request__c> ListOfRequests=getCheckedRecords();
        
       for(Apttus_Approval__Approval_Request__c Request:ListOfRequests){   
           if(Request.Apttus_Approval__Approver_Comments__c <> NULL)
           {   
            Apttus_Approval.ApprovalsWebService.approveRequest(Request.id,'\nApproved using Mass Approvals. ' + Request.Approver_Comment__c);
            }
            else
            {
              Apttus_Approval.ApprovalsWebService.approveRequest(Request.id,'\nApproved using Mass Approvals.' );
            }
        }
        
        return GoBack();
    }

    public pagereference doReject(){
    
       List<Apttus_Approval__Approval_Request__c> ListOfRequests=getCheckedRecords();
        
       for(Apttus_Approval__Approval_Request__c Request:ListOfRequests){      
            Apttus_Approval.ApprovalsWebService.rejectRequest(Request.id,'\nRejected using Mass Approvals. ' + Request.Approver_Comment__c);
        }
    
         return GoBack();
    }

    public pagereference doAddComment(){
    
       String approvalComments = '';
       String previousComments = '';
        
       List<Apttus_Approval__Approval_Request__c> ListOfRequests=getCheckedRecords();
       
       for(Apttus_Approval__Approval_Request__c Request:ListOfRequests){                                              
            
            //// Modified by SD - 08/29 to fix null comments issue
            // Get Previous Comments
            if (Request.Apttus_Approval__Approver_Comments__c == null)
                previousComments = '';
            else
                previousComments = Request.Apttus_Approval__Approver_Comments__c;
            
            // Append Comments
            if (Request.Approver_Comment__c == null)
                approvalComments = '';
            else
                approvalComments = Request.Approver_Comment__c;
                
            // Call web service to suspend
            //Request.Apttus_Approval__Approver_Comments__c += 'Suspended on ' + System.NOW()+ '\n (' + UserInfo.getName()+ ')';
            if (approvalComments <> '')
                Request.Apttus_Approval__Approver_Comments__c = '\n' + System.NOW()+ '\n(' + UserInfo.getName()+ ')' + '\n' + approvalComments +'\n\n'+ previousComments;
         
            // Reset comments to blank
            Request.Approver_Comment__c = '';
            approvalComments = '';
         }
       
       Update  ListOfRequests;
        
        return GoBack();
    }

    public pagereference doCancel(){
        return GoBack();
    }
    
    public pageReference GoBack(){
        pagereference newPageRef = new pagereference('/apex/APTPS_ApprovalRequestListPage?sfdc.tabName=01rV00000008g2W');
        return newPageRef;
    }
    
    public class RequestWrapper{
    
        public Apttus_Approval__Approval_Request__c Request{get;set;}
        public boolean isChecked {get;set;}
        
        public RequestWrapper(Apttus_Approval__Approval_Request__c Req, boolean ischeck){
            Request=Req;
            isChecked=ischeck;
        }
    
    }
    
}