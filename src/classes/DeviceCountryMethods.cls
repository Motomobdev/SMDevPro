public with sharing class DeviceCountryMethods {
	/*public static void setMicrogenCountriesOnDevice(Set<Id> deviceIds){
		Map<Id, List<DeviceCountryAssoc__c>> deviceIdDevCountryListMap = new Map<Id, List<DeviceCountryAssoc__c>>();
		String microgenCountries;
		List<Device__c> devicesToUpdate = new List<Device__c>();
		
		// create map of each device with a list of related devicecountries
		for(DeviceCountryAssoc__c dc : [SELECT Device__c, Country__c, Country__r.Country_Code__c FROM DeviceCountryAssoc__c WHERE Device__c IN : deviceIds]){
			List<DeviceCountryAssoc__c> tempList = deviceIdDevCountryListMap.get(dc.Device__c);
			if(tempList == null){
				tempList = new List<DeviceCountryAssoc__c>{dc};
			} else {
				tempList.add(dc);
			}
			deviceIdDevCountryListMap.put(dc.Device__c, tempList);
		}
		
		for(Id deviceId : deviceIds){
			microgenCountries = null;
			if(deviceIdDevCountryListMap.get(deviceId) != null){
				for(DeviceCountryAssoc__c dc : deviceIdDevCountryListMap.get(deviceId)){
					if(microgenCountries == null){
						microgenCountries = dc.Country__r.Country_Code__c;
					} else {
						microgenCountries = microgenCountries + ', ' + dc.Country__r.Country_Code__c;
					} 
				}
			}
			devicesToUpdate.add(new Device__c(Id=deviceId, Microgen_Countries__c=microgenCountries));
		}
		
		if(!devicesToUpdate.isEmpty()){ update devicesToUpdate; }
	}*/
	
	private static testmethod void setMicrogenCountriesOnDeviceTest(){
		Device__c d = new Device__c(Name='d');
		insert d;
		
		Country__c c = new Country__c(Name='fakeC', Country_Code__c='fc', Region__c='North America');
		insert c;
		
		// create a device country so that test will test for multiple countries on a device
		DeviceCountryAssoc__c dc = new DeviceCountryAssoc__c(Device__c=d.Id, Country__c=c.Id);
		insert dc;
		
		Test.startTest();
			d.Country__c = 'fakeC';
			update d;
			
			d.Country__c = null;
			update d;
		Test.stopTest();
	}
}