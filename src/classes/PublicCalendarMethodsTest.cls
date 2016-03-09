@isTest
private class PublicCalendarMethodsTest 
{
    static testMethod void myUnitTest() 
    {
        PublicCalendar__c[] pubCal = [SELECT Name, ID__c FROM PublicCalendar__c LIMIT 1];
        
        if(pubCal == null || pubCal.isEmpty()) // no records in database
            return;
        
        Test.startTest();
        
        // Test null & blank values
        PublicCalendarMethods.getIdByName(null);
        PublicCalendarMethods.getNameById('');
        
        // Test methods
        String pubCalId = PublicCalendarMethods.getIdByName(pubCal[0].Name);
        String pubCalName = PublicCalendarMethods.getNameById(pubCal[0].ID__c);
        
        Test.stopTest();
        
        // Assert statements
        System.assertEquals(pubCalId, pubCal[0].ID__c);
        System.assertEquals(pubCalName, pubCal[0].Name);
    }
}