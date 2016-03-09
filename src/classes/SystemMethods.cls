public with sharing class SystemMethods {
	
	public static Map<String,String> getPrefixNameObjectMap(){
	    Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe(); 
	    Map<String,String> keyPrefixMap = new Map<String,String>{};
	    Set<String> keyPrefixSet = gd.keySet();
	    
	    for(String sObj : Schema.getGlobalDescribe().keySet()){
	       Schema.DescribeSObjectResult r =  Schema.getGlobalDescribe().get(sObj).getDescribe();
	       keyPrefixMap.put(r.getKeyPrefix(),r.getName());
	    }		
		
		return keyPrefixMap;
	}

}