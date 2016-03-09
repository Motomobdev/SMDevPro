trigger Event_Meeting on Event (after delete, after insert, after update) {
    if(!MeetingMethods.hasAlreadyCreatedMeeting()){
        Set<Id> eventIds = new Set<Id>();
        List<Event> events = new List<Event>();
        MeetingMethods meetingMethodObj = new MeetingMethods();
        if(trigger.isInsert){
			Event newEvent = trigger.new[0];
            if(newEvent.DaScoopComposer__vCal_UID__c != null){
                MeetingMethods.createMeetingFromEvent(newEvent.Id);
            } 
        }
        if(trigger.isUpdate){
			Event newEvent = trigger.new[0];
			Event oldEvent = trigger.old[0];
            if(newEvent.DaScoopComposer__vCal_UID__c != null){
                MeetingMethods.updateMeetingFromEvent(newEvent.Id, oldEvent.WhatId);
            } 
        }
        if(trigger.isDelete){
        	for(Event e : trigger.old){
        		if(e.DaScoopComposer__vCal_UID__c != null){
        			meetingMethodObj.deleteRelatedMeeting(e);
        		}
        	}        	
        }
    }   
}