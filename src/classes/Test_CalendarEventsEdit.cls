@isTest
private class Test_CalendarEventsEdit {
	static testMethod void test(){
		Legal_Case__c lgCaseObj = new Legal_Case__c();
		lgCaseObj.Name = 'test lc1';
		insert lgCaseObj;
		
		Patent__c patObj = new Patent__c();
		patObj.Name = 'Test pat1';
		patObj.Legal_Case__c = lgCaseObj.id;
		insert patObj;
		
		Calendar_Event__c event = new Calendar_Event__c(Legal_Case__c = lgCaseObj.Id, Patent__c = patObj.Id, Date__c = Date.today()); 
		insert event;
		
		PageReference aPage = Page.Calendar_Events_Edit;
		aPage.getParameters().put('legal_case_id', lgCaseObj.Id);
		test.setCurrentPage(aPage);
		
		Test.startTest();
		
		ApexPages.StandardController sc = new ApexPages.standardController(event);
		Calendar_Events_Edit_Ext calendarEventsTest = new Calendar_Events_Edit_Ext(sc);
		calendarEventsTest.doAction();
		
		system.assertNotEquals(null, calendarEventsTest.events);
		system.assertEquals(1, calendarEventsTest.events.size());
		
		system.assertNotEquals(null, calendarEventsTest.patents);
		system.assertEquals(2, calendarEventsTest.patents.size()); // 2 because the first option is --NONE--
		SelectOption so = calendarEventsTest.patents.get(1);
		system.assertEquals(patObj.Id, so.getValue());
		system.assertEquals(patObj.Name, so.getLabel());
		
		calendarEventsTest.addEvent();
		aPage.getParameters().put('index', '0'); // clone the first event
		calendarEventsTest.cloneEvent();
		system.assertEquals(3, calendarEventsTest.events.size());
		
		aPage.getParameters().put('index', '0'); // clone the first event
		calendarEventsTest.removeEvent();
		aPage.getParameters().put('index', '1'); // clone the first event
		calendarEventsTest.removeEvent();
		
		system.assertEquals(1, calendarEventsTest.events.size());
		
		calendarEventsTest.save();
		Test.stopTest();
		
		List<Calendar_Event__c> events = [SELECT Id, Legal_Case__c, Patent__c FROM Calendar_Event__c];
		
		system.assertEquals(1, events.size());
		event = events.get(0);
		system.assertEquals(lgCaseObj.Id, event.Legal_Case__c);
		system.assertEquals(null, event.Patent__c);
	}
}