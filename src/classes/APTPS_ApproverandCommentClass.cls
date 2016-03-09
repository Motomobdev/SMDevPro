/***************************************************************************
  COMMENT: Update the approver and the comment on the approval request record
           when the record is approved/rejected
  Entry Point: ApproverandCommentTrigger
  Testmethod: ApproverandCommentTriggerTestClass
***************************************************************************/  

public class APTPS_ApproverandCommentClass{
    
    public static void CheckApproverComment(List<Apttus_Approval__Approval_Request__c> approvalRequestList){
        List<Apttus_Approval__Approval_Request__c> arList = new List<Apttus_Approval__Approval_Request__c>();
        Set<String> userEmailList = new Set<String>();
        Set<String> fedIdList = new Set<String>();
        Map<Id, Approval_Inbound_Email__c> approvalEmailMap = new Map<Id, Approval_Inbound_Email__c>();
        Map<String, String> userMap = new Map<String, String>();
        
        List<Approval_Inbound_Email__c> aieList = [SELECT Id, Email_Id__c, Approval_Comment__c, Email_Received_Date_Time__c, Email_Received_Date__c, From_Address__c, From_Name__c, User_Id__c, Approval_Request__c 
                                                       FROM Approval_Inbound_Email__c WHERE Approval_Request__c IN: approvalRequestList AND Processed__c = false];
        
        for(Approval_Inbound_Email__c a: aieList){ 
            userEmailList.add(a.From_Address__c);
            fedIdList.add(a.Email_Id__c);
            approvalEmailMap.put(a.Approval_Request__c, a);
            a.Processed__c = true;
        }
        
        for(Apttus_Approval__Approval_Request__c a: approvalRequestList){
            if(a.Apttus_Approval__Approval_Status__c.equals('Approved')){ //If the Agreement is approved
                arList.add(a);
            }else if(a.Apttus_Approval__Approval_Status__c.equals('Rejected')){ //If the Agreement is rejected
                arList.add(a);
            }
        }
        
        if(!arList.isEmpty()){       
            List<User> userList = [SELECT Id, Email, DaScoopComposer__Email_Alias_1__c,DaScoopComposer__Email_Alias_2__c, FederationIdentifier FROM User 
                                   WHERE Email IN:userEmailList OR DaScoopComposer__Email_Alias_1__c IN: userEmailList OR DaScoopComposer__Email_Alias_2__c IN: userEmailList OR FederationIdentifier IN: fedIdList];
            
            for(User u: userList){
                userMap.put(u.email, u.Id);
                if(String.isNotBlank(u.DaScoopComposer__Email_Alias_1__c)){
                    userMap.put(u.DaScoopComposer__Email_Alias_1__c, u.Id);
                }
                if(String.isNotBlank(u.DaScoopComposer__Email_Alias_2__c)){
                    userMap.put(u.DaScoopComposer__Email_Alias_2__c, u.Id);
                }
                if(String.isNotBlank(u.FederationIdentifier)){
                    userMap.put(u.FederationIdentifier.toLowerCase() , u.Id);
                }
            }
            
            for(Apttus_Approval__Approval_Request__c a: arList){
                if(approvalEmailMap.get(a.Id) != null){
                    Approval_Inbound_Email__c aie = approvalEmailMap.get(a.Id);
                    if(a.Apttus_Approval__Approval_Status__c.equals('Approved') && a.Apttus_Approval__Assigned_To_Id__c != a.Apttus_Approval__Actual_Approver__c
                        && a.Approver_Email__c != aie.From_Address__c && userMap.get(aie.From_Address__c) != null){ //If the actual approver is not the same as the assigned to approver

                        aie.Apttus_Actual_Approver__c = a.Apttus_Approval__Actual_Approver__c;
                        a.Apttus_Approval__Actual_Approver__c = userMap.get(aie.From_Address__c);
                        
                        if(a.Apttus_Approval__Actual_Approver__c == null){
                            a.Apttus_Approval__Actual_Approver__c = userMap.get(aie.Email_Id__c);
                        }
                    }
                    
                    if(String.isNotBlank(a.Apttus_Approval__Approver_Comments__c)){
                        aie.Apttus_Approver_Comments__c = a.Apttus_Approval__Approver_Comments__c;
                            
                        Integer cnt = a.Apttus_Approval__Approver_Comments__c.countMatches('\n') + 1;
                        List<String> commentList = a.Apttus_Approval__Approver_Comments__c.split('\n', cnt);
                        a.Apttus_Approval__Approver_Comments__c = '';
                        a.Apttus_Approval__Approver_Comments__c = commentList.get(0) + '\r\n' + '(' + aie.From_Name__c + ')';
                         
                        if(String.isNotBlank(aie.Approval_Comment__c)){ 
                            a.Apttus_Approval__Approver_Comments__c += ' ' + aie.Approval_Comment__c;
                        }
                    }
                }
            }
        }
        
        try{
            update aieList;
            //delete aieList;
        }catch(DMLException de){
            System.debug(de.getDMLMessage(0));
        }
    }
}