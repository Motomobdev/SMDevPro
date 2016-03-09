@isTest
public class Account_SA_TrackerTest{
    /*
    * Author: Rajesh Krishnaiah
    * Date  : 04-Dec-2013
    * Desc  : Contains test case for the page that displays ship authorization dates
    *         on the account page layout.
    */
    private static testmethod void testInit() {
    	Account a = new Account(name = 'Dummy Account');
    	insert a;
       	ApexPages.StandardController ctrl1 = new ApexPages.StandardController(a);
        Account_SA_Tracker sa = new Account_SA_Tracker(ctrl1);
        sa.init();

        Key_Account__c ka = new Key_Account__c(name='Dummy Key Account');
        insert ka;
        a.key_account__c = ka.id;
        update a;
       	ApexPages.StandardController ctrl2 = new ApexPages.StandardController(a);
        sa = new Account_SA_Tracker(ctrl2);
        sa.init();
    }
}