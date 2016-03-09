trigger SalesModelDevice on SalesModel_Device__c (after delete, after insert) {
	if(trigger.isAfter && trigger.isInsert){		
		SalesModelDeviceMethods.setConcatenatedSalesModelListAndNumberOfSalesModelsOnDevice(trigger.new);
	}
	
	if(trigger.isAfter && trigger.isDelete){		
		SalesModelDeviceMethods.setConcatenatedSalesModelListAndNumberOfSalesModelsOnDevice(trigger.old);
	}
}