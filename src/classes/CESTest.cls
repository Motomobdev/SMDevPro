@isTest(SeeAllData=true)
private class CESTest
{

    static testMethod void myUnitTest() 
    {

    String userName = UserInfo.getUserName();
    User u = [Select Email From User where Username = :userName limit 1];
        String userEmail = u.email;
        String[] toAddresses = new String[] {userEmail};
        String htmlBody='test';
         Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(toAddresses);
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        
        Account acc1 = new Account();
        acc1.Name = 'testacc';
        acc1.Region__c = 'Latin America';
        acc1.Sub_Region__c = 'Latin America North';
        acc1.Country__c = 'Mexico';
        acc1.Technology_Type__c='CDMA';
        acc1.RecordTypeId = '01240000000DpysAAC';
        acc1.Allow_Opportunities__c = true;
        insert acc1;
    
        customer_meeting__c c = new customer_meeting__c();
        c.Objective__c='test';
        c.Meeting_Start_Date__c =System.today();
        c.Meeting_End_Date__c = System.today();
        c.PublicCalendar__c = 'APAC';
        c.Account__c = acc1.Id;
        
        insert c;
        
         PageReference pageRef = Page.CES;
         Test.setCurrentPage(pageRef);
         
         Test.startTest();
         CES con = new CES();
         
         con.userType ='Current Year Meetings';
        con.publiccalender='APAC';
        con.year = '2015';
         con.search();
         con.sort();
        con.getcalender();
        con.getPubliccalender();

        con.userType ='Last Year Meetings';
        con.publiccalender='APAC';
        con.year = '2014';
         con.search();
         con.sort1();
        con.getcalender();
        con.getPubliccalender();
        Test.stopTest();

        customer_meeting__c selectedSP = [select PublicCalendar__c from customer_meeting__c where Id=:c.Id];
        System.assertEquals('APAC', selectedSP.PublicCalendar__c);

}

}