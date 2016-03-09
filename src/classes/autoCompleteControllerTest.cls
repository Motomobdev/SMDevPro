@isTest
private class autoCompleteControllerTest{
    static testMethod void acTest(){
        Account a = new Account(Name = 'Test Account');
        insert a;
        // Test with a basic search 
        sObject[] s1 = autoCompleteController.findSObjects('Account', 'test', '');
        System.assert(s1.size() > 0);

        // Test with an additional field
        sObject[] s2 = autoCompleteController.findSObjects('Account', 'test', 'TickerSymbol');
        System.assert(s2.size() > 0);

        // Test with an invalid object name
        try {
            sObject[] s3 = autoCompleteController.findSObjects('InvalidObject', 'test', '');
        }
        catch (Exception e) {   
          System.assertEquals(e.getMessage(), 'Object name InvalidObject not valid');
        }

        // Test with a valid object and invalid field
        try {
            sObject[] s4 = autoCompleteController.findSObjects('Account', 'test', 'InvalidField');
        }
        catch (Exception e) { 
          System.assertEquals(e.getMessage(), 'Additional Field InvalidField not valid for object Account');  
        }
    }
}