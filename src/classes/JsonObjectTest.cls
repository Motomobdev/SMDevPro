/**********************************************************/
// Created by: Luiz Borba
// Created Date: 04/02/2014
//
// Description:
// This test class contains methods to test the
//functionality of class JsonObject.
/**********************************************************/
@isTest
public class JsonObjectTest {
    
    // Description:  
    // Test if JsonObject getString works using a first level key path. 
    //
    // Input: none
    //
    // Returns: none  
    public static testMethod void testGetFirstLevelString() {
        // setup
        Map<String, Object> sampleMap = new Map<String, Object>();
        sampleMap.put('stringKey', 'aString');
        JsonObject jsonObject = new JsonObject(sampleMap);

        // test execution
        Test.startTest();
        String returnedValue = jsonObject.getString('stringKey');
        Test.stopTest();
        
        // asserts
        System.assertEquals('aString', returnedValue);
    }

    // Description:  
    // Test if JsonObject getList and getString works using a first level 
    // key path and using key indexes. 
    //
    // Input: none
    //
    // Returns: none  
    public static testMethod void testGetFirstLevelList() {
        // setup
        Map<String, Object> sampleMap = new Map<String, Object>();
        List<Object> sampleList = new List<Object>();
        sampleList.add('teste1');
        sampleList.add('teste2');
        sampleMap.put('listKey', sampleList);
        JsonObject jsonObject = new JsonObject(sampleMap);

        // test execution
        Test.startTest();
        List<Object> returnedList = jsonObject.getList('listKey');
        String firstElement = jsonObject.getString('listKey[0]');
        String secondElement = jsonObject.getString('listKey[1]');
        Test.stopTest();
        
        // asserts
        System.assert(returnedList.size() == 2);
        System.assertEquals('teste1', firstElement);
        System.assertEquals('teste2', secondElement);
    }
    
    // Description:  
    // Test if JsonObject getString works using a nested key path. 
    //
    // Input: none
    //
    // Returns: none  
    public static testMethod void testGetStringFromMapInsideList() {
        // setup
        Map<String, Object> sampleMap = new Map<String, Object>();
        Map<String, Object> innerMap = new Map<String, Object>();
        innerMap.put('stringKey', 'success');
        List<Object> sampleList = new List<Object>();
        sampleList.add(innerMap);
        sampleMap.put('listKey', sampleList);

        JsonObject jsonObject = new JsonObject(sampleMap);

        // test execution
        Test.startTest();
        String returnedValue = jsonObject.getString('listKey[0].stringKey');
        Test.stopTest();
        
        // asserts
        System.assertEquals('success', returnedValue);
    }

    // Description:  
    // Test if JsonObject getString works using a nested map with a list. 
    //
    // Input: none
    //
    // Returns: none  
    public static testMethod void testGetStringFromListInsideMap() {
        // setup
        Map<String, Object> sampleMap = new Map<String, Object>();
        List<Object> innerList = new List<Object>();
        innerList.add('success');
        Map<String, Object> innerMap = new Map<String, Object>();
        innerMap.put('listKey', innerList);
        sampleMap.put('mapKey', innerMap);

        JsonObject jsonObject = new JsonObject(sampleMap);

        // test execution
        Test.startTest();
        String returnedValue = jsonObject.getString('mapKey.listKey[0]');
        Test.stopTest();
        
        // asserts
        System.assertEquals('success', returnedValue);
    }

}