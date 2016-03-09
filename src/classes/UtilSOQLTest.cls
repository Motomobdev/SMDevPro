@isTest
private class UtilSOQLTest 
{
    static testMethod void myUnitTest() 
    {
        String query1 = UtilSOQL.getCreatableFieldsSOQL('Account', '');
        System.assertEquals(query1.contains('WHERE'), false);
        String query2 = UtilSOQL.getCreatableFieldsSOQL('Account', 'IsActive = 1');
        System.assertEquals(query2.contains('WHERE'), true);
    }
}