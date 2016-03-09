@isTest
private class WeeklyReportMenuCtrTest {
	
	@isTest static void unitTestMethod() {
		PageReference pref = Page.WeeklyReportMenu;
		Test.setCurrentPage(pref);

		Weekly_Report__c wr = WeeklyReport.createWeekly('GTM', date.today());
		
		WeeklyReportMenuCtr ctr = new WeeklyReportMenuCtr();
		//ctr.getLatestWeeklyList();
		ctr.getLatestWeeklyLinks();
	}	
}