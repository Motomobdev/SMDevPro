/*************************************************************
  COMMENT: Record email history for all inbound approval emails
  Testmethod: InboundApprovalEmailClassTest
**************************************************************/  

global class APTPS_InboundApprovalEmailClass implements Messaging.InboundEmailHandler{
   global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        
        Apttus_Approval__Approval_Request__c approvalReqt = null;
        Approval_Inbound_Email__c ie = new Approval_Inbound_Email__c();
        
        //Get the plain text version of the email body 
        String emailBody = email.plainTextBody;
        
        //Get Approval Request Id
        Integer approvalRequestStart = emailBody.indexOf('Approval Request ID:');
        if(approvalRequestStart != -1){
            approvalRequestStart += 20;
            Integer approvalRequestEnd = approvalRequestStart + 18;
            String approvalRequestId = emailBody.subString(approvalRequestStart, approvalRequestEnd);
            try{    
                approvalReqt = [SELECT Id, Apttus_Approval__DateAssigned__c FROM Apttus_Approval__Approval_Request__c WHERE Id =: approvalRequestId];
                ie.Approval_Request__c = approvalReqt.Id;
            }catch(Exception e){
                System.debug(e.getMessage());
                RecordError('Approval Request cannot be found', 'No Id');
            }
        }
        
        //Get Approver User ID
        if(approvalReqt != null){
            Integer userIdStart = emailBody.indexOf('Approver User ID:');
            if(userIdStart != -1){
                userIdStart += 17;
                Integer userIdEnd = userIdStart + 18;
                try{    
                    ie.User_Id__c = emailBody.subString(userIdStart, userIdEnd);
                }catch(Exception e){
                    System.debug(e.getMessage());
                    RecordError(e.getMessage(), ie.Approval_Request__c);
                    return null;
                }
            }
            
            //Split the email body based on line break
            Integer newLine = emailBody.countMatches('\n') + 1;
            List<String> emailMessageList = emailBody.split('\n', newLine);
            
            String strDateAssigned = '';
            String strDateAssigned1 = ''; 
            if(approvalReqt.Apttus_Approval__DateAssigned__c != null){
                strDateAssigned = 'On ' + getDayofWeek(approvalReqt.Apttus_Approval__DateAssigned__c);
                strDateAssigned1 = 'On ' + InReplyDate(approvalReqt.Apttus_Approval__DateAssigned__c);
            } 
            
            if(emailMessageList.get(0) != null){
                ie.Approval_Status__c = emailMessageList.get(0);
            }
            
            if(emailMessageList.get(1) != null && !emailMessageList.get(1).startsWith(strDateAssigned) && !emailMessageList.get(1).startsWith(strDateAssigned1)){
                ie.Approval_Comment__c = emailMessageList.get(1);
            }
            
            ie.From_Address__c = email.fromAddress.toLowerCase();
            ie.Email_Id__c = email.fromAddress.subStringBefore('@');
            ie.From_Name__c = email.fromName;
            ie.Email_Received_Date_Time__c = DateTime.now();
            ie.Full_Email_Body__c = emailBody;
            if(emailBody != null && emailBody.length() > 32700){
                  ie.Full_Email_Body__c = emailBody.subString(0, 32700);
            }
            
            try{
                insert ie;
            }catch(DMLException de){
                system.debug(de.getDMLMessage(0));
                RecordError(de.getDMLMessage(0), ie.Approval_Request__c);
            }
            
            //Send email and envelope to Apttus email handler class
            Apttus_Approval.ApprovalEmailHandler ae = new Apttus_Approval.ApprovalEmailHandler();
            ae.handleInboundEmail(email, envelope);
        }
        return new Messaging.InboundEmailResult();
    }
    
    //Track errors associated with tracking the inbound email 
    private static void RecordError(String errorMsg, String ApprovalRequestId){
        ApprovalEmailError__c aee = new ApprovalEmailError__c();
        aee.Name = ApprovalRequestId + ' ' + DateTime.now();
        if(ApprovalRequestId.length() == 18){
            aee.Name = ApprovalRequestId.subString(10) + ' ' + DateTime.now();
        }
        //aee.Name = 'Testing Error' + ' ' + DateTime.now(); 
        aee.Error_Message__c = errorMsg;
        try{
            insert aee;
        }catch(DMLException de){
            system.debug(de.getDMLMessage(0));
        }
    }
    
    public static String InReplyDate(DateTime dateAssigned){
        return dateAssigned.format('MMM');
    }
    
    public static String getDayofWeek(DateTime dateAssigned){
        final List<String> daysofWeek = new List<String>{'Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'};
        Date startDate = date.newInstance(0001, 1,1);
        Integer intDay = Math.mod(startDate.daysBetween(dateAssigned.date()) ,7);
        return daysOfWeek.get(intDay);
    }
}