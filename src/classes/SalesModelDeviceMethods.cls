public with sharing class SalesModelDeviceMethods {
    public static void setConcatenatedSalesModelListAndNumberOfSalesModelsOnDevice(List<SalesModel_Device__c> smdList){
        Set<Id> deviceIds = new Set<Id>();
        
        for(SalesModel_Device__c smd : smdList){
            deviceIds.add(smd.Device__c);
        }
        
        Map<Id, List<SalesModel_Device__c>> deviceIdSMDListMap = new Map<Id, List<SalesModel_Device__c>>();
        List<SalesModel_Device__c> tempList;
        for(SalesModel_Device__c smd : [SELECT Id, Device__c, Sales_Model__r.Name FROM SalesModel_Device__c WHERE Device__c IN : deviceIds ORDER BY Sales_Model__r.Name ASC]){
            tempList = deviceIdSMDListMap.get(smd.Device__c);
            if(tempList == null){
                tempList = new List<SalesModel_Device__c>{smd};
            } else {
                tempList.add(smd);
            }
            deviceIdSMDListMap.put(smd.Device__c, tempList);
        }
        
        List<Device__c> devicesToUpdate = new List<Device__c>();
        for(Id deviceId : deviceIds){
            if(deviceIdSMDListMap.get(deviceId) == null){
                devicesToUpdate.add(new Device__c(Id = deviceId, Number_of_Sales_Models__c = 0, Sales_Model_List_Concatenated__c = null));
            } else {
            	String concatenatedSMString;
            	for(SalesModel_Device__c smd : deviceIdSMDListMap.get(deviceId)){
            		if(concatenatedSMString == null){
            			concatenatedSMString = smd.Sales_Model__r.Name;
            		} else {
            			concatenatedSMString = concatenatedSMString + ', ' + smd.Sales_Model__r.Name; 
            		}
            	}
                devicesToUpdate.add(new Device__c(Id = deviceId, Number_of_Sales_Models__c = deviceIdSMDListMap.get(deviceId).size(), Sales_Model_List_Concatenated__c = concatenatedSMString));
            }
        }
        
        if(!devicesToUpdate.isEmpty()){ update devicesToUpdate; }
    }
    
    private static testmethod void setNumberOfSalesModelsOnDeviceTest(){
        Device__c d = new Device__c(Name='testDevice');
        insert d;
        
        Sales_Model__c sm1 = new Sales_Model__c(Name='sm1');
        insert sm1;
        Sales_Model__c sm2 = new Sales_Model__c(Name='sm2');
        insert sm2;
        
        SalesModel_Device__c smd1 = new SalesModel_Device__c(Sales_Model__c = sm1.Id, Device__c = d.Id);
        SalesModel_Device__c smd2 = new SalesModel_Device__c(Sales_Model__c = sm2.Id, Device__c = d.Id);
        
        Test.startTest();
            insert new List<SalesModel_Device__c>{smd1, smd2};
            d = [SELECT Id, Sales_Model_List_Concatenated__c FROM Device__c WHERE Id=:d.Id];
            system.debug('THIS IS CONCATENATED LIST: ' + d.Sales_Model_List_Concatenated__c);
            delete smd1;
            delete smd2;
        Test.stopTest();
    }
}