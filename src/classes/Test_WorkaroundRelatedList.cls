@isTest
private class Test_WorkaroundRelatedList {
	static testMethod void test(){
		Legal_Case__c lgCaseObj = new Legal_Case__c();
		lgCaseObj.Name = 'test lc1';
		insert lgCaseObj;
		
		Patent__c patObj = new Patent__c();
		patObj.Name = 'Test pat1';
		patObj.Legal_Case__c = lgCaseObj.id;
		insert patObj;
		
		List<Patent_Device__c> devices = new List<Patent_Device__c>();
		
		Id workaroundRTId = Schema.SObjectType.Patent_Device__c.getRecordTypeInfosByName().get('Workaround').getRecordTypeId();
		Id patentDeviceRTId = Schema.SObjectType.Patent_Device__c.getRecordTypeInfosByName().get('Patent Device').getRecordTypeId();
		
		Patent_Device__c patDeviceObj = new Patent_Device__c();
		patDeviceObj.Name = 'Pat Dev 1';
		patDeviceObj.Patent__c = patObj.id;
		patDeviceObj.RecordTypeId = workaroundRTId;
		devices.add(patDeviceObj);
		
		Patent_Device__c patDeviceObj2 = new Patent_Device__c();
		patDeviceObj2.Name = 'Pat Dev 2';
		patDeviceObj2.Patent__c = patObj.id;
		patDeviceObj2.RecordTypeId = workaroundRTId;
		devices.add(patDeviceObj2);
		
		Patent_Device__c patDeviceObj3 = new Patent_Device__c();
		patDeviceObj3.Name = 'Pat Dev 3';
		patDeviceObj3.Patent__c = patObj.id;
		patDeviceObj3.RecordTypeId = patentDeviceRTId;
		devices.add(patDeviceObj3);
		
		insert devices;
		
		Test.startTest();
		
		ApexPages.StandardController sc = new ApexPages.standardController(patObj);
		WorkaroundRelatedListExt workaroundRLTest = new WorkaroundRelatedListExt(sc);
		workaroundRLTest.doAction();
		
		system.assertNotEquals(null, workaroundRLTest.lstPatentDevices);
		system.assertEquals(2, workaroundRLTest.lstPatentDevices.size());
		
		workaroundRLTest.ParamID = patDeviceObj.id;
		workaroundRLTest.deleteAction();
		
		system.assertNotEquals(null, workaroundRLTest.lstPatentDevices);
		system.assertEquals(1, workaroundRLTest.lstPatentDevices.size());
		
		Test.stopTest(); 
	}
}