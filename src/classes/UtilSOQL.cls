public with sharing class UtilSOQL 
{
    // Returns a dynamic SOQL statement for the whole object, includes only creatable fields since we will be inserting a cloned result of this query
    public static string getCreatableFieldsSOQL(String objectName, String whereClause)
    {
    	try
    	{
	        String selects = '';
	         
	        // Get a map of field name and field token
	        Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName.toLowerCase()).getDescribe().Fields.getMap();
	        list<string> selectFields = new list<string>();
	         
	        if (fMap != null)
	        {
	            for (Schema.SObjectField ft : fMap.values())// loop through all field tokens (ft)
	            {
	                Schema.DescribeFieldResult fd = ft.getDescribe(); // describe each field (fd)
	                if (fd.isCreateable()) // field is creatable
	                    selectFields.add(fd.getName());
	            }
	        }
	         
	        if (!selectFields.isEmpty())
	        {
	            for (string s:selectFields)
	            {
	                selects += s + ',';
	            }
	
	            if (selects.endsWith(','))
	            	selects = selects.substring(0,selects.lastIndexOf(','));
	        }
	         
	        if (whereClause == null || whereClause == '')
	        	return 'SELECT ' + selects + ' FROM ' + objectName;
	    	else
	            return 'SELECT ' + selects + ' FROM ' + objectName + ' WHERE ' + whereClause;
    	}
    	catch(Exception ex)
    	{
    		return null;
    	}
    }
}