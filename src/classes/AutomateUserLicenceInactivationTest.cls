@isTest(SeeAllData=true)
private class AutomateUserLicenceInactivationTest {
    static testMethod void fnTest(){
        test.startTest();
            AutomateUserLicenceInactivation objpr = new AutomateUserLicenceInactivation();
            objpr.process();
        test.stopTest();
    }
}