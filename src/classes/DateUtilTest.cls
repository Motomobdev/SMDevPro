@isTest
private class DateUtilTest {

    static testMethod void myUnitTest() {
		DateUtil.getCurrQuarter();
		DateUtil.getNextPlusQuarter();
		DateUtil.getNextQuarter();
		DateUtil.getPrevQuarter();
    }
}