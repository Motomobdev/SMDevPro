@isTest
public class QuoteApprovalRequestTest {
 static testMethod void testQuoteUtil(){
    
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User[] usrList = [SELECT Id FROM User WHERE ProfileId = :pf.Id AND IsActive = true LIMIT 1];
             
              
        Account acc1 = new Account();
        acc1.Name = 'Acc1';
        acc1.Region__c = 'Latin America';
        acc1.Sub_Region__c = 'Latin America North';
        acc1.Country__c = 'Mexico';
        acc1.Allow_Opportunities__c = true;
        insert acc1;
        
         Opportunity objopp = new Opportunity();
        objopp.Name = 'TEST';
        objopp.StageName = 'Presenting Device';
        objopp.CloseDate = system.today();
        objopp.AccountId = acc1.id;
        insert objopp;
        
       Quote thisQuote = new Quote();
        //thisQuote.id = '0Q0M0000000WfPgKAK';
        thisQuote.Name = 'TEST';
        thisQuote.pricebook2Id = '01s400000006B0eAAE';
        thisQuote.OpportunityId = objopp.id;
        thisQuote.Deal_Review_Date__c = system.today();
        insert thisQuote;
           
            
        QuoteApprovalRequest objDealApprovalRequest = new QuoteApprovalRequest();
            
        objDealApprovalRequest.UserType= 'This Weeks Agenda';
            objDealApprovalRequest.search();
            objDealApprovalRequest.DisplayQueryList();
        objDealApprovalRequest.UserType='Next Weeks Agenda';    
            objDealApprovalRequest.search();
            objDealApprovalRequest.DisplayQueryList();
            objDealApprovalRequest.UserType='Selected Week Deals';
          objDealApprovalRequest.StartDate = System.Today();
            objDealApprovalRequest.endDate = System.Today() +1;
            objDealApprovalRequest.DisplayQueryList3();
            objDealApprovalRequest.search();
             objDealApprovalRequest.UserType='All Approved Deals';
            objDealApprovalRequest.DisplayQueryList();
            objDealApprovalRequest.search();
             objDealApprovalRequest.UserType='View Draft Deals';
           objDealApprovalRequest.DisplayQueryList();
           objDealApprovalRequest.search();
            objDealApprovalRequest.UserType='All Deals';
           objDealApprovalRequest.DisplayQueryList();
             objDealApprovalRequest.search();    
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting request for approval.');
        req.setObjectId(thisQuote.id);
        //req.setNextApproverIds(usrList[0].id);
        //Approval.ProcessResult result = Approval.process(req); 
    
        objDealApprovalRequest.UserType='All Approvers';                
            objDealApprovalRequest.search();
    
  }
  }