global class APTPS_ApprovalHistoryController { 

    Public String ProposalId{get; set;}
    Public List<Apttus_Approval__Approval_Request__c> ListOfApprovalLineItems{get; set;}
    Public List<Apttus_Approval__Approval_Request__c> ListOfTermApprovalLineItems{get; set;}
    
    Public APTPS_ApprovalHistoryController(){
    
    }

    Public List<Apttus_Approval__Approval_Request__c> GetApprovalHistory(){
    
        ListOfApprovalLineItems=new List<Apttus_Approval__Approval_Request__c>();
        
        ListOfApprovalLineItems=[Select Apttus_Approval__Step_Name__c, Apttus_Approval__Approval_Status__c, 
                Apttus_Approval__Date__c, Apttus_Approval__Assigned_To_Name__c, Apttus_Approval__DependsOn__c ,
                Apttus_Approval__Actual_Approver__c, Apttus_Approval__Approver_Comments__c
                from Apttus_Approval__Approval_Request__c
                Where Apttus_Approval__Related_Agreement__c=:ProposalID];
                //AND Apttus_Approval__ProcessInstanceId__r.Apttus_Approval__ApprovalProcessId__r.Name='000000'];
                
        return ListOfApprovalLineItems;
    
    }


}