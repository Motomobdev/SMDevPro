@isTest
private class Test_CalendarEventsExt {
	static testMethod void test(){
		Legal_Case__c lgCaseObj = new Legal_Case__c();
		lgCaseObj.Name = 'test lc1';
		insert lgCaseObj;
		
		Patent__c patObj = new Patent__c();
		patObj.Name = 'Test pat1';
		patObj.Legal_Case__c = lgCaseObj.id;
		insert patObj;
		
		List<Calendar_Event__c> events = new List<Calendar_Event__c>();
		
		Calendar_Event__c event1 = new Calendar_Event__c(Legal_Case__c = lgCaseObj.Id, Patent__c = patObj.Id, Date__c = Date.today()); 
		events.add(event1);
		
		Calendar_Event__c event2 = new Calendar_Event__c(Legal_Case__c = lgCaseObj.Id, Patent__c = patObj.Id, Date__c = Date.today().addDays(2));
		events.add(event2);
		
		Calendar_Event__c event3 = new Calendar_Event__c(Legal_Case__c = lgCaseObj.Id, Patent__c = patObj.Id, Date__c = Date.today().addDays(1));
		events.add(event3);
		
		insert events;
		
		Test.startTest();
		
		ApexPages.StandardController sc = new ApexPages.standardController(lgCaseObj);
		Calendar_Events_Ext calendarEventsRLTest = new Calendar_Events_Ext(sc);
		calendarEventsRLTest.doAction();
		
		system.assertNotEquals(null, calendarEventsRLTest.events);
		system.assertEquals(events.size(), calendarEventsRLTest.events.size());
		
		system.assertEquals(event1.Id, calendarEventsRLTest.events.get(2).Id); // closest date should appear last
		system.assertEquals(event2.Id, calendarEventsRLTest.events.get(0).Id); // farthest date should appear first
		system.assertEquals(event3.Id, calendarEventsRLTest.events.get(1).Id);
		
		calendarEventsRLTest.ParamID = event1.id;
		calendarEventsRLTest.deleteAction();
		
		system.assertNotEquals(null, calendarEventsRLTest.events);
		system.assertEquals(events.size()-1, calendarEventsRLTest.events.size());
		
		Test.stopTest(); 
	}
}