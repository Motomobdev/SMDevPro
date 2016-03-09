@isTest(SeeAllData=true)
private class AutomateUserCreationFromCoreDirTest{

static testMethod void fnTest(){
        test.startTest();
          Motorola_Core_Directory__c motoUser = new Motorola_Core_Directory__c();
                motoUser.CoreID__c='asd123';
                motoUser.DirectoryStatus__c='A';
                motoUser.EmployeeType__c='R';
                motoUser.Commerce_ID__c='80000123';
                motoUser.DisplayFirstName__c='TestUser';
                motoUser.DisplayLastName__c='TestUser';
                Insert motoUser;
          AutomateUserCreationFromCoreDirectory objpr = new AutomateUserCreationFromCoreDirectory();
          objpr.process();
                       
        test.stopTest();
    }
}