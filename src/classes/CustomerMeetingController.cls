/*
 * Author: Rajesh Krishnaiah
 * Date  : 12-Oct-2011
 * Desc  : The Event object doesn't support rich text custom fields. The Meeting object is a wrapper
 *         to the Event object to capture rich text. When a meeting is created, an event is automatically
 *         created in the user's private calendar as well in the team's public calendar.
 *         When a meeting is updated, we look for the first Event relating to the Meeting record and update it
 *         in both public and personal folders.
 * Change history:
 * Date   : 04-Jun-2012
 * Desc   : Added External_Attendees__c field to the creation of customer meeting record
 *          in the test method since this field is required to have a value now.
 * Date   : 27-Jun-2012
 * Desc   : Removed the javascript library to handle date and time, using SalesForce Date as well as a hardcoded
 *          SelectList for time
 * Date   : 30-Aug-2013 [Bineet Mishra]
 * Desc   : Added logic to add/remove attendees from Users and Contacts to Customer Meeting Object as Related List 
            and to Events as Attendees
   Date   : 18-Nov-2013 [Bineet Mishra]
   Desc   : Removed attendees from Public Calendar event to stop duplicate events to show on attendees calendar 
 */
public class CustomerMeetingController {
    ApexPages.StandardController controller;
    public Boolean editing {get; set;}
    public String publicCalendarId = '';
    public String oldPublicCalendarId = '';
    public String selectedStartTime {get; set;}
    public String selectedEndTime {get; set;}
    public ID Account {get;set;}
    public CustomerMeetingController(ApexPages.StandardController ctlr) {
        controller = ctlr;
        Customer_Meeting__c meeting = (Customer_Meeting__c)controller.getRecord();
        setPublicCalendar();
        
        Account = ApexPages.currentPage().getParameters().get('Account__c');
            System.debug('temp'+Account);
        if (ApexPages.currentPage().getParameters().get('id') != null) {
        Customer_Meeting__c meetings = [Select Account__c from Customer_Meeting__c where Id=:ApexPages.currentPage().getParameters().get('id')];
            editing = true;
            Customer_Meeting__c meetingRecordDatesFromDb = getMeetingDates(meeting);
            meeting.StartDate_d__c = meetingRecordDatesFromDb.Meeting_Start_Date__C.date();
            meeting.EndDate_d__c = meetingRecordDatesFromDb.Meeting_End_Date__c.date();
            selectedStartTime = meetingRecordDatesFromDb.Meeting_Start_Date__c.format('H:mm');
            selectedEndTime = meetingRecordDatesFromDb.Meeting_End_Date__c.format('H:mm');
            meeting.Account__c=meetings.Account__c;
            System.debug('acc1'+Account);
            
        } else {
            editing = false;
            DateTime startTimeTmp = system.now();
            Integer seconds = startTimeTmp.second();
            startTimeTmp = startTimeTmp.addSeconds(60-seconds);
            Integer minutes = startTimeTmp.minute();
            startTimeTmp = startTimeTmp.addMinutes(60-minutes);
            meeting.Meeting_Start_Date__c = startTimeTmp;
            meeting.Meeting_End_Date__c = startTimeTmp.addHours(1);
            meeting.StartDate_d__c = meeting.Meeting_Start_Date__c.date();
            meeting.EndDate_d__c = meeting.Meeting_End_Date__c.date();
            selectedStartTime = meeting.Meeting_Start_Date__c.format('H:mm');
            selectedEndTime = meeting.Meeting_End_Date__c.format('H:mm');
            //meeting.account__c = ApexPages.currentPage().getParameters().get('account');
            meeting.ranging_record__c = ApexPages.currentPage().getParameters().get('ranging');
            meeting.meeting_type__c = ApexPages.currentPage().getParameters().get('type');
            setPublicCalendar();
            meeting.Account__c=account;
        } 
    }
      
    public List<SelectOption> getSelectTimes() {
        List<SelectOption> options = new List<SelectOption>();
        String half;
        Integer displayHour;

        for(Integer i = 0; i < 24; i++) {
            // Show the hour portion of the time in 12-hour format (also make sure that 0 is rendered as 12)
            displayHour = ((i == 0) || (i == 12)) ? 12 : math.mod(i, 12);
            // Determine whether the time is AM or PM (AM: hour < 12, PM: hour >= 12)
            half = (i < 12) ? 'AM' : 'PM';
            options.add(new SelectOption(i + ':00', displayHour + ':00 ' + half));
            options.add(new SelectOption(i + ':30', displayHour + ':30 ' + half));
        }

        return options;
    }
    
    public void setPublicCalendar() {
        try {
            Customer_Meeting__c mobj = (Customer_Meeting__c)controller.getRecord();
            
            if (mobj.Account__c != null) {
                Account acct = [SELECT PublicCalendar__c, RecordType.Name FROM Account WHERE Id = :mobj.Account__c];
                
                if (acct.RecordType.Name == 'Supplier')
                    mobj.PublicCalendar__c = 'Procurement';
                else if (acct.PublicCalendar__c != null && mobj.PublicCalendar__c == null)
                    mobj.PublicCalendar__c = acct.PublicCalendar__c;
                    
                    
            } else {
               mobj.PublicCalendar__c = null;
               
            }
            
        } catch(Exception ex) { }
    }
    
    
    public void updatePublicCalendar() {
        try {
            Customer_Meeting__c mobj = (Customer_Meeting__c)controller.getRecord();
            Account acct = [SELECT PublicCalendar__c, RecordType.Name,id FROM Account WHERE Id = :mobj.Account__c];
            if (mobj.Account__c != null) {
                
                
                if (acct.RecordType.Name == 'Supplier')
                    mobj.PublicCalendar__c = 'Procurement';
                    
                else
                
                    mobj.PublicCalendar__c = acct.PublicCalendar__c;
                    mobj.Account__c = acct.id;
            } else {
               mobj.PublicCalendar__c = null;
               mobj.Account__c = acct.id;
               
            }
        } catch(Exception ex) { }
    }
    
    public PageReference mySave() {

        Event personalEvent = null;
        Event publicCalendarEvent = null;

        Boolean hasPersonalEvent = false;
        Boolean hasPublicEvent = false;

        PageReference returnPage = null;

        Customer_Meeting__c meeting = (Customer_Meeting__c)controller.getRecord();
        String[] splitStartTime = selectedStartTime.split(':');
        meeting.Meeting_Start_Date__c = DateTime.newInstance(meeting.StartDate_d__c.year(), meeting.StartDate_d__c.month(),
            meeting.StartDate_d__c.day(), integer.valueOf(splitStartTime[0]), integer.valueOf(splitStartTime[1]), 0);
        String[] splitEndTime = selectedEndTime.split(':');
        meeting.Meeting_End_Date__c = DateTime.newInstance(meeting.EndDate_d__c.year(), meeting.EndDate_d__c.month(),
            meeting.EndDate_d__c.day(), integer.valueOf(splitEndTime[0]), integer.valueOf(splitEndTime[1]), 0);
        
        try {
            if (meeting.Id != null) {
                for (Customer_Meeting__c cm : [SELECT PublicCalendar__c FROM Customer_Meeting__c WHERE Id = :meeting.Id]) {
                    oldPublicCalendarId = PublicCalendarMethods.getIdByName(cm.PublicCalendar__c);
                    break;
                }                   
            }
        } catch(Exception ex) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Save failed: ' + ex.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        PageReference saveRef = null;
        
        try {
            if (meeting.Owner__c == null)
                meeting.Owner__c = UserInfo.getUserId();

            saveRef = controller.save();
            meeting = (Customer_Meeting__c)controller.getRecord();
        } catch(Exception ex) { 
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Save failed: ' + ex.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }

/*
        system.debug('Meeting: ' + meeting);
        meeting = (Customer_Meeting__c)controller.getRecord();
        Customer_Meeting__c mTemp = [SELECT PublicCalendar__c, Owner__c, CreatedById FROM Customer_Meeting__c WHERE Id = :meeting.Id];
        //Added to populate new Owner__c field
        mTemp.Owner__c = mTemp.CreatedById;
        update mTemp;//Update new field to store the Meeting creator : Owner__c
*/
        publicCalendarId = PublicCalendarMethods.getIdByName(meeting.PublicCalendar__c);

        if (saveRef == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Save failed:');
            ApexPages.addMessage(myMsg);
            return returnPage;
        }

        // Check if this meeting already has events.
        // If not, create one in personal calendar and another one in public calendar
        List<Event> events = [SELECT id, subject, location, description, StartDateTime,
                                    ownerId, Priority_Scope__c, Validation_Override__c, IsChild
                              FROM Event WHERE whatId = :meeting.Id];

        for (Event e : events) {
            if (!e.isChild) {
                if (publicCalendarId != oldPublicCalendarId && oldPublicCalendarId != null) {
                    hasPersonalEvent = true;
                    if (String.valueOf(e.ownerId).left(15) == oldPublicCalendarId && hasPublicEvent == false) {
                        hasPublicEvent = true;
                        publicCalendarEvent = new Event(OwnerId = publicCalendarId);
                        populateEventRecord(publicCalendarEvent, meeting);
                        insert publicCalendarEvent;
                        //delete old event 
                        delete e;                                     
                    }
                } else {
                    if (String.valueOf(e.ownerId).left(15) == publicCalendarId && hasPublicEvent == false) {
                        hasPublicEvent = true;
                        publicCalendarEvent = e;
                        populateEventRecord(publicCalendarEvent, meeting);
                        update publicCalendarEvent;               
                    }
        
                    if (String.valueOf(e.ownerId).left(15) != publicCalendarId && hasPersonalEvent == false) {
                        hasPersonalEvent = true;
                        personalEvent = e;
                        populateEventRecord(personalEvent, meeting);
                        update personalEvent;                
                    }
                }
            }
        }

        if (hasPublicEvent == false && publicCalendarId != null) {
            publicCalendarEvent = new Event(OwnerId = publicCalendarId);
            populateEventRecord(publicCalendarEvent, meeting);
            insert publicCalendarEvent;
        }

        // Default return page to meeting view page.
        returnPage = new ApexPages.StandardController(meeting).view();

        if (hasPersonalEvent == false) {
            personalEvent = new Event();
            populateEventRecord(personalEvent, meeting);
            insert personalEvent;
        }

        return returnPage;
    }

    public PageReference addAttendees() {

        PageReference saveRef = mySave();       
        //Id meetingId = ApexPages.currentPage().getParameters().get('id');
        Customer_Meeting__c meeting = (Customer_Meeting__c)controller.getRecord();

        if (saveRef == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Save failed');
            ApexPages.addMessage(myMsg);
            return null;
        }
        
        PageReference attendeesPage = Page.CustomerMeetingAttendees;
        attendeesPage.getParameters().put('id', meeting.Id);
        attendeesPage.setRedirect(true);
        return attendeesPage;       
        //return new PageReference('/apex/CustomerMeetingAttendees?id=' + meeting.Id);
    }
    
    private static Customer_Meeting__c getMeetingDates(Customer_Meeting__c meeting) {
        List<Customer_Meeting__c> currentMeeting = [SELECT id, Meeting_Start_date__c, Meeting_End_Date__c
            FROM Customer_Meeting__c WHERE Id = :meeting.Id];

        return (currentMeeting.size() > 0) ? currentMeeting[0] : meeting;
    }

    public void populateEventRecord(Event event, Customer_Meeting__c meeting) {
        Customer_Meeting__c meetingRecordDatesFromDb = getMeetingDates(meeting);
        event.whatId = meeting.id;
        event.Subject = meeting.name;
        event.location = meeting.location__c;
        event.description = meeting.agenda__c;
        event.StartDateTime = meetingRecordDatesFromDb.Meeting_Start_Date__c;
        event.EndDateTime = meetingRecordDatesFromDb.Meeting_End_Date__c;
        event.Priority_Scope__c = meeting.Priority_Scope__c;
        event.Validation_Override__c = !event.Validation_Override__c;
    }
}