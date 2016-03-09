/*
 * Author: Bineet Mishra
 * Date  : 28-Nov-2013
 * Desc  : Controller class for CustomerMeetingAttendees page
 */
public without sharing class MeetingAttendeesController {
    ApexPages.StandardController controller;
    public Id meetingId;
    public Boolean editing {get; set;}
    
    public String publicCalendarId = '';
    public String oldPublicCalendarId = '';
    
    public String selectedStartTime {get; set;}
    public String selectedEndTime {get; set;}
    
    public Set<Id> intAttendeeIds = new Set<Id>();
    public Set<Id> extAttendeeIds = new Set<Id>();
    
    public SelectOption[] internalAttendees { get; set; }
    private SelectOption[] allUsers;
    public SelectOption[] externalAttendees { get; set; }
    private SelectOption[] allContacts;
    
    private Set<Id> currentIntAttds;
    private Set<Id> currentExtAttds;
    
    public string searchTextUser {get; set;}
    public string searchTextContact {get; set;}
    private boolean unrestrictedContacts = false;
        
    Customer_Meeting__c meeting;
    List<User> users;
    //List<Contact> contacts;
    
    public with sharing class MeetingContacts{
    	
    	public List<Contact> getAvailableContacts(Id meetingAcctId, Boolean accountFilterflag, String searchText, Set<Id> currentAttds){
    		List<Contact> contacts = new List<Contact>();
    		If(!accountFilterflag){
        		Set<Id> accountIds = new Set<Id>();
		        List<Account> parentAccount;
		        List<Account> siblingAccounts;
		        List<Account> childAccounts;
		        List<Account> activeAccounts;
	        
	        	accountIds.add(meetingAcctId);
		        parentAccount = [SELECT Id, parentId FROM Account WHERE id = :meetingAcctId];
		        if(parentAccount[0].parentId != null){
		        	siblingAccounts = [SELECT Id, parentId FROM Account WHERE parentid = :parentAccount[0].parentId AND Active__c = True];
		        }   
		        childAccounts = [SELECT Id, parentId FROM Account WHERE parentid = :meetingAcctId AND Active__c = True];
		        
		        if(childAccounts.size() > 0){
			        for(Account acct : childAccounts){
			        	accountIds.add(acct.Id);
			        }
		        }
		        if(parentAccount.size() > 0 && parentAccount[0].parentId != null){
			        accountIds.add(parentAccount[0].parentId);
		        }
		        if(siblingAccounts != null && siblingAccounts.size() > 0){
			        for(Account acct : siblingAccounts){
			        	accountIds.add(acct.Id);
			        }
		        }
		        
			    if(searchText != null){
		    		String condition = '%' + searchText + '%';
		    		contacts = [SELECT Id, Name, Account.Name 
		                                  FROM Contact 
		                                  WHERE   AccountId IN :accountIds 
		                                      AND Id NOT IN : currentAttds
		                                      AND Name LIKE :condition
		                                  ORDER BY Account.Name, Name
		                                  LIMIT 1000];
		    	}
		    	else{
		    		contacts = [SELECT Id, Name, Account.Name 
		                                  FROM Contact 
		                                  WHERE AccountId IN :accountIds 
		                                      AND Id NOT IN : currentAttds
		                                  ORDER BY Account.Name, Name
		                                  LIMIT 1000];
		    	}
        	}
	        else{
	        	if(searchText != null){
		    		String condition = '%' + searchText + '%';
		    		contacts = [SELECT Id, Name, Account.Name 
		                                  FROM Contact 
		                                  WHERE AccountId != null
		                                  	AND Id NOT IN : currentAttds
		                                    AND Name LIKE :condition
		                                  ORDER BY Account.Name, Name
		                                  LIMIT 1000];
		    	}
		    	else{
		    		contacts = [SELECT Id, Name, Account.Name 
		                                  FROM Contact 
		                                  WHERE AccountId != null 
		                                  	AND Id NOT IN : currentAttds
		                                  ORDER BY Account.Name, Name
		                                  LIMIT 1000];
		    	}
	        }   			        
	        return contacts;
    	}
    }
    
    public MeetingAttendeesController(ApexPages.StandardController ctlr)
    {
        controller = ctlr;
        meetingId = ApexPages.currentPage().getParameters().get('id');
        meeting = [SELECT Id, Name, Account__c FROM Customer_Meeting__c WHERE Id = :meetingId];
           	
        internalAttendees = new List<SelectOption>();
        externalAttendees = new List<SelectOption>();
        
        currentIntAttds = new Set<Id>();
        currentExtAttds = new Set<Id>();
                          
        List<Customer_Meeting_Internal_Attendee__c> currIntAttendees = [SELECT Id, Internal_Attendee__c, Internal_Attendee__r.Name 
                                                                            FROM Customer_Meeting_Internal_Attendee__c 
                                                                            WHERE Customer_Meeting__c = :meeting.Id];
        if(currIntAttendees != null){
            for(Customer_Meeting_Internal_Attendee__c attendee : currIntAttendees){
                internalAttendees.add(new SelectOption(attendee.Internal_Attendee__c, attendee.Internal_Attendee__r.Name));
                currentIntAttds.add(attendee.Internal_Attendee__c);
            }
        }
            
        List<Customer_Meeting_External_Attendee__c> currExtAttendees = [SELECT Id, External_Attendee__c, External_Attendee__r.Name, External_Attendee__r.Account.Name
                                                                            FROM Customer_Meeting_External_Attendee__c 
                                                                            WHERE Customer_Meeting__c = :meeting.Id];
        if(currExtAttendees != null){
            for(Customer_Meeting_External_Attendee__c attendee : currExtAttendees){
                externalAttendees.add(new SelectOption(attendee.External_Attendee__c, attendee.External_Attendee__r.Account.Name + ' : ' + attendee.External_Attendee__r.Name));
                currentExtAttds.add(attendee.External_Attendee__c);
            }
        }          
    }
    
    public boolean getUnrestrictedContacts(){
    	return unrestrictedContacts;
    }
    
    public void setUnrestrictedContacts(boolean value){
    	unrestrictedContacts = value;
    }
       
    public List<SelectOption> getAllUsers(){
    	if(searchTextUser != null){
    		System.Debug('search Text User: ' + searchTextUser);
	    	String condition = '%' + searchTextUser + '%';
	    	users = [SELECT Name, Id FROM User 
	                                WHERE   IsActive = True
	                                    AND Id NOT IN : currentIntAttds
	                                    AND UserType IN ('Standard')
	                                    AND Name LIKE :condition
	                                ORDER BY Name
	                                LIMIT 1000];    	        	        
    	}
    	else{
    		users = [SELECT Name, Id FROM User 
	                                WHERE   IsActive = True
	                                    AND Id NOT IN : currentIntAttds
	                                    AND UserType IN ('Standard')	                                    
	                                ORDER BY Name
	                                LIMIT 1000];
    	}
    	allUsers = new List<SelectOption>();
    	for(User u : users){
	    	allUsers.add(new SelectOption(u.Id, u.Name));
	    }   	              
        return allUsers;
    }
    
    
    public List<SelectOption> getAllContacts(){    	
        MeetingContacts meetingConts = new MeetingContacts();
        List<Contact> contacts = meetingConts.getAvailableContacts(meeting.Account__c, unrestrictedContacts, searchTextContact, currentExtAttds);           
    	allContacts  = new List<SelectOption>();
        for (Contact c : contacts){
            allContacts.add(new SelectOption(c.Id, c.Account.Name + ' : ' + c.Name));
        }       
        return allContacts;
    }
        
    public PageReference attendeesSave() {

        Event personalEvent = null;
        Event publicCalendarEvent = null;

        Boolean hasPersonalEvent = false;
        Boolean hasPublicEvent = false;

        PageReference returnPage = null;

        meeting = [SELECT Id, Name, Account__c, 
        PublicCalendar__c, Location__c, Agenda__c, Priority_Scope__c FROM Customer_Meeting__c WHERE Id = :meetingId];
        publicCalendarId = PublicCalendarMethods.getIdByName(meeting.PublicCalendar__c);
        
        List<Customer_Meeting_Internal_Attendee__c> existingIntAttds = [SELECT Id 
                                                              FROM Customer_Meeting_Internal_Attendee__c 
                                                              WHERE Customer_Meeting__c = :meeting.Id];
                                                              
        delete existingIntAttds;
                                                            
        List<Customer_Meeting_Internal_Attendee__c> updIntAttendees = new List<Customer_Meeting_Internal_Attendee__c>();
        for(SelectOption so: internalAttendees){
            Id userId = so.getValue();           
            Customer_Meeting_Internal_Attendee__c attendee = new Customer_Meeting_Internal_Attendee__c();
            attendee.Customer_Meeting__c = meeting.Id;
            attendee.Internal_Attendee__c = userId;
            updIntAttendees.add(attendee);
            //Attendees in String Format
            User u = [SELECT Name, Email FROM User WHERE Id = :userId];         
        }       
        insert updIntAttendees;
        
        List<Customer_Meeting_External_Attendee__c> existingExtAttds = [SELECT Id 
                                                              FROM Customer_Meeting_External_Attendee__c 
                                                              WHERE Customer_Meeting__c = :meeting.Id];
                                                              
        delete existingExtAttds;
        
        List<Customer_Meeting_External_Attendee__c> updExtAttendees = new List<Customer_Meeting_External_Attendee__c>();
        for(SelectOption so: externalAttendees){           
            Id userId = so.getValue();
            Customer_Meeting_External_Attendee__c attendee = new Customer_Meeting_External_Attendee__c();
            attendee.Customer_Meeting__c = meeting.Id;
            attendee.External_Attendee__c = userId;
            updExtAttendees.add(attendee);
            //Attendees text format
            Contact c = [SELECT Name, Email FROM Contact WHERE Id = :userId];
        }
        insert updExtAttendees;
        
        // Save changes to the meeting
        PageReference saveRef = controller.save();
        //meeting = (Customer_Meeting__c)controller.getRecord();
                        
        if (saveRef == null) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Save failed');
            ApexPages.addMessage(myMsg);
            return returnPage;
        }
                      
        setAttendeeIDs(meeting);


        // Check if this meeting already has events.
        // If not, create one in personal calendar and another one in public calendar
        List<Event> events = [SELECT id, subject, location, description, StartDateTime,
                                    ownerId, Priority_Scope__c, Validation_Override__c, IsChild
                              FROM Event WHERE whatId = :meeting.Id];

        for (Event e : events) {
            //Adding Attendees to public and personal Events       
            setAttendeeIDs(meeting);
            if(!e.isChild){
                if (String.valueOf(e.ownerId).left(15) == publicCalendarId && hasPublicEvent == false) {
                    hasPublicEvent = true;
                    publicCalendarEvent = e;
                    //updateEventAttendees(publicCalendarEvent);
                    populateEventRecord(publicCalendarEvent, meeting);
                    update publicCalendarEvent;                                 
                }
    
                if (String.valueOf(e.ownerId).left(15) != publicCalendarId && hasPersonalEvent == false) {
                    hasPersonalEvent = true;
                    personalEvent = e;
                    updateEventAttendees(personalEvent);
                    populateEventRecord(personalEvent, meeting);
                    update personalEvent;                
                }
            }
        }

        if (hasPublicEvent == false && publicCalendarId != null) {
            publicCalendarEvent = new Event(OwnerId = publicCalendarId);
            populateEventRecord(publicCalendarEvent, meeting);
            insert publicCalendarEvent;
            //updateEventAttendees(publicCalendarEvent);
        }

        if (hasPersonalEvent == false) {
            personalEvent = new Event();
            populateEventRecord(personalEvent, meeting);
            insert personalEvent;
            updateEventAttendees(personalEvent);
        }
        
        // Default return page to meeting view page.
        returnPage = new ApexPages.StandardController(meeting).view();

        return returnPage;
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
    
    private void setAttendeeIDs(Customer_Meeting__c meeting){
        intAttendeeIds.clear();
        extAttendeeIds.clear();
        for(SelectOption so : internalAttendees){
           intAttendeeIDs.add(so.getValue());
        }
        for(SelectOption so : externalAttendees){
            extAttendeeIDs.add(so.getValue());
        }                
    }
    
    public void updateEventAttendees(Event e){
        //Update Attendee List       
        List<EventRelation> attendees = [SELECT Id, RelationId, IsInvitee from EventRelation WHERE EventId = :e.Id];        
        for(EventRelation er : attendees){
            Id tempId = (Id)((string)er.RelationId).substring(0,15);
            if(er.IsInvitee){
                if(!intAttendeeIds.contains(tempId) && tempId != e.Id){
                    delete er;               
                    intAttendeeIds.remove(tempId);
                    System.Debug('AttendeeIDs Deleted and Removed: ' + tempId);
                }
                else{
                    intAttendeeIds.remove(tempId);
                    System.Debug('AttendeeIDs Removed: ' + tempId);
                }
            }
            else{
                if(!extAttendeeIds.contains(tempId) && tempId != e.Id){
                    delete er;               
                    extAttendeeIds.remove(tempId);
                    System.Debug('AttendeeIDs Deleted and Removed: ' + tempId);
                }
                else{
                    extAttendeeIds.remove(tempId);
                    System.Debug('AttendeeIDs Removed: ' + tempId);
                }
            }
        }
        //Remove the event owner from the AttendeesList
        Id tempOwnerId = (Id)((string)e.OwnerId).substring(0,15);
        if(intAttendeeIds.contains(tempOwnerId)){           
            intAttendeeIds.remove(tempOwnerId);
        }
        //System.Debug('AttendeeIDs Size: ' + attendeeIds.size()); 
                    
        for(Id attendeeId : intAttendeeIds){
            try{
                EventRelation er = new EventRelation(EventId = e.Id, RelationId = attendeeId, IsInvitee = True);
                insert er;
                System.Debug('Attendees Added: ' + er.RelationId); 
            }
            catch(Exception ex){
                //Do Nothing
            }           
            
        }
        for(Id attendeeId : extAttendeeIds){
            try{
                EventRelation er = new EventRelation(EventId = e.Id, RelationId = attendeeId, IsInvitee = False, IsParent = True);
                insert er;
                System.Debug('Attendees Added: ' + er.RelationId); 
            }
            catch(Exception ex){
                //Do Nothing
            }                       
        }
    }
}