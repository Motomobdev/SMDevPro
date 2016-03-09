@isTest
private class UtilGUIDTest 
{

    static testMethod void myUnitTest() 
    {
    	Test.startTest();
    	
        String guid1 = UtilGUID.NewGUID();
        
        string[] s = guid1.split('-');
        
        System.assertEquals(s.size(), 5);
        System.assertEquals(s[0].length(), 8);
        System.assertEquals(s[1].length(), 4);
        System.assertEquals(s[2].length(), 4);
        System.assertEquals(s[3].length(), 4);
        System.assertEquals(s[4].length(), 12);
        
        String guid2 = UtilGUID.NewGUID();
        
        System.assertEquals(guid1.equals(guid2), false);
        
        Test.stopTest();
    }
}