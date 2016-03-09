/**
 * Author: Bineet Mishra
 * Date  : 2-Sep-2013
 * Desc  : This class contains unit tests for validating the behavior of Apex class CustomerMeetingController.
 */
@isTest
private class CustomerMeetingControllerTest {

    static testMethod void myUnitTest() {
        System.Test.setCurrentPage(Page.CustomerMeeting);
        
        Account acct = new Account(name = 'Test Bin', Region__c = 'North America');
        insert acct;
        
        Contact cont = new Contact(lastname='Test Cont', Account=acct, title='AAA');
        insert cont;
        
        Customer_Meeting__c meeting = new Customer_Meeting__c(
        									name = 'Test CM1', Account__c = acct.Id, 
        									PublicCalendar__c = '02340000000kFEh',
        									Meeting_Start_Date__c = date.today(), 
            								Meeting_End_Date__c = date.today());
        insert meeting;
        
        User u = [SELECT id, name FROM User WHERE isactive = true LIMIT 1];
        
        Event e = new Event(Subject = 'Test E', OwnerId= u.Id, DurationInMinutes = 60, ActivityDateTime = System.now());
        insert e;
        
        EventRelation er = new EventRelation(EventId = e.Id, RelationId = cont.Id, IsInvitee = False, IsParent = True);
        insert er;

        //Test new
        ApexPages.StandardController ctlr1 = new ApexPages.StandardController(meeting);
        CustomerMeetingController controller1 = new CustomerMeetingController(ctlr1);
        controller1.mySave();
              
        //Test edit Meeting  
        ApexPages.currentPage().getParameters().put('id', meeting.Id);     
        ApexPages.StandardController ctlr2 = new ApexPages.StandardController(meeting);      
        CustomerMeetingController controller2 = new CustomerMeetingController(ctlr2);
        controller2.populateEventRecord(new Event(), meeting);
        controller2.getSelectTimes();
        controller2.mySave();
        controller2.addAttendees();
        controller2.updatePublicCalendar();
        
    }

    static testMethod void supplierTest() {
        System.Test.setCurrentPage(Page.CustomerMeeting);
        
        Account acct = null;        
        
        RecordType[] rts = [SELECT Id FROM RecordType WHERE SobjectType = 'Account' 
                            AND Name = 'Supplier'];
        if (!rts.isEmpty())
            acct = new Account(name = 'Test Supplier', Region__c = 'North America', 
                               RecordTypeId = rts[0].id);
		else
            acct = new Account(name = 'Test Supplier', Region__c = 'North America');
        
        insert acct;
        
        Contact cont = new Contact(lastname='Test Supplier Cont', Account=acct, title='AAA');
        insert cont;
        
        Customer_Meeting__c meeting = new Customer_Meeting__c(
        									name = 'Test CM1', Account__c = acct.Id, 
        									PublicCalendar__c = '02340000000kFEh',
        									Meeting_Start_Date__c = date.today(), 
            								Meeting_End_Date__c = date.today());
        insert meeting;

        //Test new
        ApexPages.StandardController ctlr1 = new ApexPages.StandardController(meeting);
        CustomerMeetingController controller1 = new CustomerMeetingController(ctlr1);
        controller1.mySave();
    }
}