/**
 * Author: Bineet Mishra
 * Date  : 4-Dec-2013
 * Desc  : This class contains unit tests for validating the behavior of Apex class MeetingAttendeesController.
 */
@isTest (SeeAllData=true)
private class MeetingAttendeesControllerTest {

    static testMethod void myUnitTest() {
        PageReference custMeetingAttdRef = Page.CustomerMeetingAttendees;
        Test.setCurrentPage(custMeetingAttdRef);
        
        Account acct = new Account(name = 'Test Bin', Region__c = 'North America');
        insert acct;
        
        Contact cont = new Contact(lastname='Test Cont', Account=acct, title='AAA');
        insert cont;
        
        Customer_Meeting__c meeting = new Customer_Meeting__c(
        									name = 'Test CM1', Account__c = acct.Id, 
        									PublicCalendar__c = '02340000000kFEh',
        									Meeting_Start_Date__c = date.today(), Meeting_End_Date__c = date.today());
        insert meeting;
        
        User u = [SELECT id, name FROM User WHERE email = 'bineet@motorola.com'];
        
        Event e = new Event(Subject = 'Test E', OwnerId= u.Id, DurationInMinutes = 60, ActivityDateTime = System.now(), WhatId = meeting.id);
        insert e;
        
        EventRelation er = new EventRelation(EventId = e.Id, RelationId = cont.Id, IsInvitee = False, IsParent = True);
        insert er;
                      
        //Test edit Meeting  
        ApexPages.currentPage().getParameters().put('id', meeting.Id);     
        ApexPages.StandardController ctlr = new ApexPages.StandardController(meeting);      
        MeetingAttendeesController controller = new MeetingAttendeesController(ctlr);
        controller.getAllUsers();
        
        controller.searchTextUser = 'bin';
        controller.getAllUsers();
        
        controller.getAllContacts();
        
        controller.searchTextContact = 'bk';
        controller.getAllContacts();
        
        controller.populateEventRecord(new Event(), meeting);        
        controller.internalAttendees.add(new SelectOption(u.id, u.Name));
        controller.externalAttendees.add(new SelectOption(cont.id, cont.lastname));
        controller.attendeesSave(); 
    }
}