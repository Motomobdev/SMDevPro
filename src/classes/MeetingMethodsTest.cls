/*
 * Author: Bineet Mishra
 * Date  : 12-Sep-2013
 * Desc  : Test class for MeetingMethods
 *
 */ 
@isTest(SeeAllData=true)
private class MeetingMethodsTest {

    static testMethod void myUnitTest() {
        
        PublicCalendar__c cal = [SELECT Name, ID__c FROM PublicCalendar__c LIMIT 1];
        
        Account acct = new Account(name = 'Test Bin', Region__c = 'North America', 
                                   PublicCalendar__c = cal.Name);
        insert acct;
        
        MeetingMethods mmobj = new MeetingMethods();
        
        Contact cont1 = new Contact();
        cont1.AccountId = acct.id;
        cont1.Email = 'neeldesai@motorola.com';
        cont1.FirstName = 'Neel';
        cont1.LastName = 'Desai';
        insert cont1;
        
        Contact cont2 = new Contact();
        cont2.AccountId = acct.id;
        cont2.Email = 'bineet@motorola.com';
        cont2.FirstName = 'Bineet';
        cont2.LastName = 'Mishra';
        insert cont2;
        
        Event e = new Event();
        e.Subject = 'Test Event';
        e.WhoId = cont1.Id;
        e.StartDateTime = System.now();
        e.EndDateTime = System.now().addHours(1);
        e.DurationInMinutes = 60;
        insert e;
        
        List<EventRelation> erList = new List<EventRelation>();
        
        EventRelation er1 = new EventRelation();
        er1.EventId = e.Id;
        er1.RelationId = cont2.Id;
        er1.IsInvitee = false;    
        erList.add(er1);
        
        insert erList;
               
        MeetingMethods.createMeetingFromEvent(e.Id);
        MeetingMethods.updateMeetingFromEvent(e.Id, e.WhatId);
        
        Event e2 = new Event();
        e2.Subject = 'Test Event';
        e2.WhoId = cont1.Id;
        e2.StartDateTime = System.now();
        e2.EndDateTime = System.now().addHours(1);
        e2.DurationInMinutes = 60;
        insert e2;
        
        Customer_Meeting__c newMeeting = new Customer_Meeting__c();
        newMeeting.Account__c = acct.Id;
        newMeeting.PublicCalendar__c = cal.Name;
        newMeeting.Business__c = 'Handset';
        newMeeting.Name = 'Test Meeting';
        newMeeting.Meeting_Start_Date__c = System.now();
        newMeeting.Meeting_End_Date__c = System.now().addHours(1);
        insert newMeeting;
        
        e2.WhatId = newMeeting.Id;
        update e2;
        
        MeetingMethods.updateMeetingFromEvent(e2.Id, newMeeting.id);
        
        // Force an exception by passing null event ID
        MeetingMethods.updateMeetingFromEvent(null, newMeeting.id);
        
        // Test for null meeting ID
		MeetingMethods.updateMeetingFromEvent(e2.Id, null);
    }
}