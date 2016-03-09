/*
 * Author: Bineet Mishra
 * Date  : 12-Sep-2013
 * Desc  : Methods needed to create Meetings from Events for Scoop integration.
 *
 */ 
public class MeetingMethods{
  
    private static boolean alreadyCreatedMeeting = false;
         
    public static boolean hasAlreadyCreatedMeeting() {
        return alreadyCreatedMeeting;
    }
      
    public static void setAlreadyCreatedMeeting() {
        alreadyCreatedMeeting = true;
    }
      
    //this method as future method?
    public void deleteRelatedMeeting(Event e) {
        try {
            Customer_Meeting__c meeting = [SELECT Id, PublicCalendar__c FROM Customer_Meeting__c 
                                        WHERE Id = :e.WhatId];
            deleteMeetingAndPublicEvent(meeting);
        } catch(Exception ex) {}
    }

    //Create Meeting from Event 
    @future
    public static void createMeetingFromEvent(Id eventId) {     
        Customer_Meeting__c meeting;
        List<EventRelation> attendees;
        User u;
        String calendarName;
      
        try { 
            Event newEvent = [SELECT Id, AccountId, Subject, location, description, 
                              StartDateTime, EndDateTime, Priority_Scope__c, WhatId, OwnerId 
                              FROM Event WHERE Id = :eventId];     
            System.debug('Account Id: ' + newEvent.AccountId);           
            
            List<Account> accounts = [SELECT PublicCalendar__c FROM Account 
                                      WHERE Id = :newEvent.AccountId];
            
            if (accounts != null && accounts.size() > 0) {
                calendarName = accounts[0].PublicCalendar__c;
            } else {
                return;
            }

            meeting = new Customer_Meeting__c(); 
            meeting.Account__c = newEvent.AccountId;
            meeting.PublicCalendar__c = calendarName;
            if (newEvent.Subject.length() > 80)
                meeting.name = newEvent.Subject.substring(0, 80);
            else
                meeting.name = newEvent.Subject;
            meeting.location__c = newEvent.location;
            meeting.agenda__c = newEvent.description;
            meeting.Meeting_Start_Date__c = newEvent.StartDateTime;
            meeting.Meeting_End_Date__c = newEvent.EndDateTime;
            meeting.Priority_Scope__c = newEvent.Priority_Scope__c;
            meeting.Owner__c = newEvent.OwnerId;       
            insert meeting;
            
            attendees = [SELECT Id, RelationId FROM EventRelation WHERE EventId = :eventId];
            
            updateMeetingAttendeesList(newEvent.Id, meeting.Id, attendees);
            
            //Avoid trigger loop
            setAlreadyCreatedMeeting();
            
            //Update Event What Id     
            newEvent.WhatId = meeting.Id;
            update newEvent;  

            if (calendarName != null) {
                CreatePublicEvent(meeting, newEvent, attendees);
            }
        } catch (Exception e) {
            emailAdmins(e, 'createMeetingFromEvent', eventId);
        }        
    }
    
    //Update Meeting from Event 
    @future
    public static void updateMeetingFromEvent(Id eventId, Id meetingId) {
        Customer_Meeting__c meeting = null;
        List<EventRelation> attendees;
          
        String calendarName;
        try {
            Event newEvent = [SELECT Id, AccountId, Subject, location, description, 
                              StartDateTime, EndDateTime, Priority_Scope__c, WhatId, OwnerId 
                              FROM Event WHERE Id = :eventId];

            //System.Debug('Event WhatId: ' + oldEvent.whatId);      
            System.debug('Account Id: ' + newEvent.AccountId);

            if (meetingId != null) {
                List<Customer_Meeting__c> meetings = 
                [SELECT Account__c, PublicCalendar__c, name, location__c, agenda__c, 
                          Meeting_Start_Date__c, Meeting_End_Date__c, Priority_Scope__c,
                          Internal_Attendees__c, External_Attendees__c
                       FROM Customer_Meeting__c WHERE Id = :meetingId];

                if (!meetings.isEmpty())
                    meeting = meetings[0];
            }
            
            if (newEvent.AccountId == null) {
                if (meetingId != null)
	                deleteMeetingAndPublicEvent(meeting);
                return;
            }

            List<Account> accounts = [SELECT PublicCalendar__c FROM Account 
                                      WHERE Id = :newEvent.AccountId];
                if (accounts != null && accounts.size() > 0) {
                    calendarName = accounts[0].PublicCalendar__c;
            }

            if (meeting != null) {
                              
                meeting.Account__c = newEvent.AccountId;    
                meeting.PublicCalendar__c = calendarName;
                if (newEvent.Subject.length() > 80)
                    meeting.name = newEvent.Subject.substring(0, 80);
                else
                    meeting.name = newEvent.Subject;

                meeting.location__c = newEvent.location;
                meeting.agenda__c = newEvent.description;
                meeting.Meeting_Start_Date__c = newEvent.StartDateTime;
                meeting.Meeting_End_Date__c = newEvent.EndDateTime;
                meeting.Priority_Scope__c = newEvent.Priority_Scope__c;       
                update meeting;
            } else {
                meeting = new Customer_Meeting__c(); 
                meeting.Account__c = newEvent.AccountId;    
                meeting.PublicCalendar__c = calendarName;
                if (newEvent.Subject.length() > 80)
                    meeting.name = newEvent.Subject.substring(0, 80);
                else
                    meeting.name = newEvent.Subject;

                meeting.location__c = newEvent.location;
                meeting.agenda__c = newEvent.description;
                meeting.Meeting_Start_Date__c = newEvent.StartDateTime;
                meeting.Meeting_End_Date__c = newEvent.EndDateTime;
                meeting.Priority_Scope__c = newEvent.Priority_Scope__c; 
                meeting.Owner__c = newEvent.OwnerId;      
                insert meeting;
            }
              
            attendees = [SELECT Id, RelationId FROM EventRelation WHERE EventId = :eventId];
              
            updateMeetingAttendeesList(newEvent.Id, meeting.Id, attendees);
                        
            //Avoid trigger loop
            setAlreadyCreatedMeeting();
              
            //Update Event What Id     
            newEvent.WhatId = meeting.Id;
            update newEvent; 
                      
            if (calendarName != null) {
                CreatePublicEvent(meeting, newEvent, attendees);
            }
        } catch (Exception e) {
            emailAdmins(e, 'updateMeetingFromEvent', eventId);
        }    
    }
    
    public static void updateMeetingAttendeesList(Id eventId, Id meetingId, List<EventRelation> attendees) {
        User u;

        try {
            //Delete existing Attendees from Related lists
            List<Customer_Meeting_Internal_Attendee__c> existingIntAttds = 
                [SELECT Id FROM Customer_Meeting_Internal_Attendee__c 
                 WHERE Customer_Meeting__c = :meetingId];
                                                                  
            delete existingIntAttds; 
            
            List<Customer_Meeting_External_Attendee__c> existingExtAttds = 
                [SELECT Id FROM Customer_Meeting_External_Attendee__c 
                 WHERE Customer_Meeting__c = :meetingId];
                                                                  
            delete existingExtAttds;
          
            //Updated Internal and External attendees
            List<Customer_Meeting_Internal_Attendee__c> updIntAttendees = 
                new List<Customer_Meeting_Internal_Attendee__c>();
            List<Customer_Meeting_External_Attendee__c> updExtAttendees = 
                new List<Customer_Meeting_External_Attendee__c>();
          
            Event event = [SELECT OwnerId FROM Event WHERE Id = :eventId];
          
            //Adding event owner as Attendees
            u = [SELECT Name, Email FROM User WHERE Id = :event.OwnerId];
            Customer_Meeting_Internal_Attendee__c ownerAttendee = 
                new Customer_Meeting_Internal_Attendee__c();
            ownerAttendee.Customer_Meeting__c = meetingId;
            ownerAttendee.Internal_Attendee__c = u.Id;
            updIntAttendees.add(ownerAttendee);
                    
            //Adding rest of the attend
            for (EventRelation er : attendees) {
                try {
                    u = [SELECT Name, Email FROM User WHERE Id = :er.RelationId];
                    if (u != null) {          
                        Customer_Meeting_Internal_Attendee__c attendee = 
                            new Customer_Meeting_Internal_Attendee__c();
                        attendee.Customer_Meeting__c = meetingId;
                        attendee.Internal_Attendee__c = u.Id;
                        updIntAttendees.add(attendee);
                    }
                } catch(Exception ex) {}

                try {
                    Contact c = [SELECT Name, Email, Phone, MobilePhone 
                                 FROM Contact WHERE Id = :er.RelationId];
                    if (c != null) {
                        Customer_Meeting_External_Attendee__c attendee = 
                            new Customer_Meeting_External_Attendee__c();
                        attendee.Customer_Meeting__c = meetingId;
                        attendee.External_Attendee__c = c.Id;
                        updExtAttendees.add(attendee); 
                    }
                } catch(Exception ex) {}
            }
          
            insert updIntAttendees;
            insert updExtAttendees;
        } catch (Exception e) {
            emailAdmins(e, 'updateMeetingAttendeesList', eventId);
        }        
    }
    
    public static void deleteMeetingAndPublicEvent(Customer_Meeting__c meeting) {
        String publicCalendarId = PublicCalendarMethods.getIdByName(meeting.PublicCalendar__c);
        List<Event> publicEvent = [SELECT Id FROM Event 
                                   WHERE WhatId = :meeting.Id 
                                   AND OwnerId = :publicCalendarId];
        
        if (publicEvent.size() > 0)
            delete publicEvent[0];
        
        delete meeting;
    }
    
    public static void CreatePublicEvent(Customer_Meeting__c meeting, Event e, List<EventRelation> attendees) {
        Event publicCalendarEvent;
        String publicCalendarId = PublicCalendarMethods.getIdByName(meeting.PublicCalendar__c);
        List<Event> oldPublicEvent = [SELECT Id FROM Event 
                                      WHERE WhatId = :meeting.Id 
                                      AND OwnerId = :publicCalendarId];
        
        //recreate public event
        publicCalendarEvent = new Event(OwnerId = publicCalendarId);
        populateEventRecord(publicCalendarEvent, meeting);
        insert publicCalendarEvent;
        
        //delete old public event
        
        if (oldPublicEvent.size() > 0) {       
            delete oldPublicEvent;
        }
    }
    
    public static void updateAttendees(Id eventId, List<EventRelation> attendees) { 
        Set<Id> attendeeIds = new Set<Id>();     
        
        for (EventRelation er : attendees) {
            attendeeIds.add(er.RelationId);
        }
              
        for (Id attendeeId : attendeeIds) {
            try {
                System.Debug('AttendeeId: ' + attendeeId);
                EventRelation er = new EventRelation(EventId = eventId, 
                                                     RelationId = attendeeId, 
                                                     IsInvitee = True);
                insert er;
                System.Debug('Attendees Added: ' + er.RelationId);
            } catch(Exception ex) {}
        }
    }
    
    public static void populateEventRecord(Event event, Customer_Meeting__c meeting) {
        Customer_Meeting__c meetingRecordDatesFromDb = getMeetingDates(meeting);
        event.whatId = meeting.id;
        System.Debug('Populate Event: meeting.id: ' + meeting.id);
        System.Debug('Populate Event: event.whatId: ' + event.whatId);
        event.Subject = meeting.name;
        event.location = meeting.location__c;
        event.description = meeting.agenda__c;
        event.StartDateTime = meetingRecordDatesFromDb.Meeting_Start_Date__c;
        event.EndDateTime = meetingRecordDatesFromDb.Meeting_End_Date__c;
        event.Priority_Scope__c = meeting.Priority_Scope__c;
        event.Validation_Override__c = !event.Validation_Override__c;
    }
    
    private static Customer_Meeting__c getMeetingDates(Customer_Meeting__c meeting) {
        List<Customer_Meeting__c> currentMeeting = 
            [SELECT id, Meeting_Start_date__c, Meeting_End_Date__c
            FROM Customer_Meeting__c WHERE Id = :meeting.Id];

        return (currentMeeting.size() > 0) ? currentMeeting[0] : meeting;
    }
    
    private static void emailAdmins(Exception ex, String methodName, Id eventId) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        String[] toAddresses = new String[] {'sfdc@motorola.com'};
        mail.setToAddresses(toAddresses);

        mail.setSubject('Groove Failure: ' + methodName);

        String body = 'Event Id: ' + eventId + '\n' + 
                        'Apex Method Name: ' + methodName + 
                        ' - Line #: ' + ex.getLineNumber() + '\n' + 
                        ex.getMessage() + '\n' + 
                        ex.getStackTraceString();
        mail.setPlainTextBody(body);
        mail.setHtmlBody(body);

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}