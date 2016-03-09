trigger WeeklyReport on Weekly_Report_Item__c (after insert, after update) {
	if(!WeeklyReportMethods.hasAlreadyUpdated()){
		for(Weekly_Report_Item__c wi : trigger.new)
			WeeklyReportMethods.UpdateFields(wi);
	}
	
}