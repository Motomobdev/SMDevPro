@isTest
private class WeeklyReportGridCtrTest {
	
	@isTest static void unitTestMethod() {
		PageReference pref = Page.WeeklyReportGrid;
		Test.setCurrentPage(pref);

		Weekly_Report__c wr = WeeklyReport.createWeekly('GTM', date.today());

		WeeklyReportGridCtr ctr = new WeeklyReportGridCtr();
		ctr.weekEnding = string.valueOf(date.today());
		ctr.function = 'GTM';

		ctr.getAccountIdsList();
		ctr.getweeklyReport();
		ctr.toggleWeeklyView();
	}	
}