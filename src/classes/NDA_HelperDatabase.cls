public class NDA_HelperDatabase {
/*
* Created by: BigKite Consulting
* Creation date: 30-Sep-2013
* Test Class: NDA_HelperDatabaseTest
* Description: This is a helper class which contains utility methods related to querying the
               salesforce database using SOQL/ getting picklist values etc.
*
* Change history:
* Changed on:
* Changed by:
* Description:
*/

    //Return query to retrieve all the columns of the specified object filtered by ID
    public static String fnAllColumnsById(String sObj, String objectId){
        map<String, schema.sobjecttype> mapAllSObjects = schema.getglobaldescribe();
        schema.sobjecttype sObjType = mapAllSObjects.get(sObj);
        schema.describesobjectresult sObjectDecription = sObjType.getdescribe();
        map<String, schema.sobjectfield> sObjectFieldMap = sObjectDecription.fields.getmap();
        set<String> sObjetFieldsSet = sObjectFieldMap.keyset();
        String strQuery = '';
        for(String strFieldName : sObjetFieldsSet){
            strQuery = strQuery+strFieldName+', ';
        }
        strQuery = strQuery.substring(0,strQuery.length()-2);
        return ('SELECT ' + strQuery + ' FROM ' + sObj + ' WHERE ID=\'' + objectId + '\'');
    }
    
    //Return query to retrieve all the columns of the specified object filtered by fieldName
    public static String fnAllColumnsByFieldName(String sObj, String fieldName, String fieldValue){
        map<String, schema.sobjecttype> mapAllSObjects = schema.getglobaldescribe();
        schema.sobjecttype sObjType = mapAllSObjects.get(sObj);
        schema.describesobjectresult sObjectDecription = sObjType.getdescribe();
        map<String, schema.sobjectfield> sObjectFieldMap = sObjectDecription.fields.getmap();
        set<String> sObjetFieldsSet = sObjectFieldMap.keyset();
        String strQuery = '';
        for(String strFieldName : sObjetFieldsSet){
            strQuery = strQuery+strFieldName+', ';
        }
        strQuery = strQuery.substring(0,strQuery.length()-2);
        return ('SELECT ' + strQuery + ' FROM ' + sObj + ' WHERE ' + fieldName + '=\'' + fieldValue + '\'');
    }
    
    //Return query to retrieve all the columns of the specified object filtered by the where clause passed
    public static String fnAllColumnsByCustomQuery(String sObj, String whereClause){
        map<String, schema.sobjecttype> mapAllSObjects = schema.getglobaldescribe();
        schema.sobjecttype sObjType = mapAllSObjects.get(sObj);
        schema.describesobjectresult sObjectDecription = sObjType.getdescribe();
        map<String, schema.sobjectfield> sObjectFieldMap = sObjectDecription.fields.getmap();   
        set<String> sObjetFieldsSet = sObjectFieldMap.keyset();    
        String strQuery = '';
        for(String strFieldName : sObjetFieldsSet){
            strQuery = strQuery+strFieldName+', ';
        }
        strQuery = strQuery.substring(0,strQuery.length()-2);
        return ('SELECT ' + strQuery + ' ' + whereClause);
        
    }
    
    //Returns the query for retrieving picklist values of the specified field of the specified object
    public static List<SelectOption> fnPicklistValues(String sObj, String fieldName ){
        List <SelectOption> orderTypeList = new List<SelectOption>();
        Map<String, Schema.SObjectType> m = Schema.getGlobalDescribe() ;
        Schema.SObjectType s = m.get(sObj) ;
        Schema.DescribeSObjectResult r = s.getDescribe() ;
        Map<String, Schema.SObjectField> fields = r.fields.getMap() ;   
        Schema.SObjectField f1 = fields.get(fieldName);
        Schema.DescribeFieldResult fieldResult1 =f1.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();

        for( Schema.PicklistEntry f : ple1){
            orderTypeList.add(new SelectOption(f.getLabel(), f.getValue()));
        }          
        return orderTypeList;
    }
    
    public static list<NDA_Notifier__c> fnShowIndividualList(String strNDAId){
        list<NDA_Notifier__c> lstNdaNotifier = new list<NDA_Notifier__c> ();
        lstNdaNotifier = [select id, name,NDA__c,Notifier__c, Notifier__r.DisplayFirstName__c, Notifier__r.DisplayLastName__c, Notifier__r.FriendlyEmailAddress__c from NDA_Notifier__c where NDA__c =: strNDAId];  
                
        return lstNdaNotifier;
     }    

}