/**
 * BOM Utility methods
 * 
 * @author: Jimens Lima - jimens@motorola.com
 */
public class BOMUtils {

    public static boolean isEmpty(String str){
        
        if(str!=null){
            return false;
        }
        return true;
    }
    
    //Verify if a selected list has an specific object.
    public static boolean contains(List<SObject> objects, SObject obj){

        for(SObject localObject: objects){
            if(localObject.Id.equals(obj.Id)){
                return true;
            }
        }
        return false;
    }
    
    //Verify if a selected Set has an specific object.
    public static boolean contains(Set<SObject> objects, SObject obj){

        for(SObject localObject: objects){
            if(localObject.Id.equals(obj.Id)){
                return true;
            }
        }
        return false;
    }
    
    //Returns the specific object position on selected list.
    public static Integer getObjectPosition(List<SObject> objects,SObject obj){
        Integer position = -1;
        for(SObject localObject: objects){
            position++;
            if(localObject.Id.equals(obj.Id)){
                return position;
            }
        }
        return position;
    }
    
    
    //Verify if a selected list has an specific device.
    //Unfortunatelly, this method is a copy of the above method, but with a different signature.
    public static boolean contains(List<BOMGenericWrapper> objects, BOMGenericWrapper obj){

        for(BOMGenericWrapper localObject: objects){
            if(localObject.getId().equals(obj.getId())){
                return true;
            }
        }
        return false;
    }
    
    
    //Verify if a selected list has an specific device.
    //Unfortunatelly, this method is a copy of the above method, but with a different signature.
    public static boolean contains(Set<BOMGenericWrapper> objects, BOMGenericWrapper obj){

        for(BOMGenericWrapper localObject: objects){
            if(localObject.getId().equals(obj.getId())){
                return true;
            }
        }
        return false;
    }
    
    //Returns the specific object position on selected list.
    //Unfortunatelly, this method is a copy of the above method, but with a different signature.
    public static Integer getObjectPosition(List<BOMGenericWrapper> objects,BOMGenericWrapper obj){
        Integer position = -1;
        for(BOMGenericWrapper localObject: objects){
            position++;
            if(localObject.getId().equals(obj.getId())){
                return position;
            }
        }
        return position;
    }
    
    
    
    
    /**
     * Transform a list in an 'in ()' sql statement.
     *@return 'in ('123','456','789') statement.
     */ 
    public static String generateInStatement(List<String> values){
        try{
            String stmt = '';
            for(String value: values){
                stmt += '\''+value+'\',';
            }
            stmt = 'IN ('+ stmt.substring(0, stmt.length()-1) + ')';
            return stmt;
        }catch(Exception e){
            throw e;
        }
        
        return null;
    }
    
    /**
     * Remove a Wrapper object from parametrized list.
     */
    public static void removeFromList(List<BOMGenericWrapper> wrappers,BOMGenericWrapper wrapper){
       try{
            if(wrappers!=null && !wrappers.isEmpty()){
                Integer position = getObjectPosition(wrappers,wrapper);            
                
                if(position!=-1){
                    wrappers.remove(position);
                }
            }
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        } 
    }
    
    /**
     * Transform a list in an 'in ()' sql statement.
     *@return 'in ('123','456','789') statement.
     */
    public static String generateInStatement(List<SObject> values){
        try{
            String stmt = '';
            for(SObject sObj: values){
                stmt += '\''+sObj.Id+'\',';
            }
            stmt = 'IN ('+ stmt.substring(0, stmt.length()-1) + ')';
            
            return stmt;
        }catch(Exception e){
            throw e;
        }
        
        return null;
    }
    
    /**
     * Extracts SObject List from a Wrapper List
     */
    public static List<SObject> parseWrapperListToSObject(List<BOMGenericWrapper> genericList){
        
        try{
            List<SObject> sObjects = new List<SObject>();
            if(genericList!=null && !genericList.isEmpty()){
                
                for(BOMGenericWrapper wrapper: genericList){
	                sObjects.add(wrapper.sfObject);
                }
            }
            return sObjects;
        }catch(Exception e){
            throw e;
        }
        
        return null;
    }
    
    /**
     * Extracts SObject List from Wrapper List
     */
    public static List<SObject> parseWrapperListToSObject(Set<BOMGenericWrapper> genericList){
        
        try{
            List<SObject> sObjects = new List<SObject>();
            if(genericList!=null && !genericList.isEmpty()){
                
                for(BOMGenericWrapper wrapper: genericList){
	                sObjects.add(wrapper.sfObject);
                }
            }
            return sObjects;
        }catch(Exception e){
            throw e;
        }
        
        return null;
    }
    
    /**
     * @return A List with selected Wrapper Objects
     */
    public static List<BOMGenericWrapper> getSelection(List<BOMGenericWrapper> genericList){
        
        return getSelection(genericList, true);
    }
    
    /**
     * @param A List of BOMGenericWrapper
     * @return A List with selected Wrapper Objects
     */
    public static List<BOMGenericWrapper> getNonSelection(List<BOMGenericWrapper> genericList){
        return getSelection(genericList, false);
    }
    
    /**
     * @param A List with BOMGenericWrapper
     * @param selected - To return only checked or unckecked on List view component.
     * @return A List with selected BOMGenericWrapper Objects
     */
    private static List<BOMGenericWrapper> getSelection(List<BOMGenericWrapper> genericList,boolean selected){
        
        try{
            List<BOMGenericWrapper> wrappers = new List<BOMGenericWrapper>();
            if(genericList!=null && !genericList.isEmpty()){
                
                for(BOMGenericWrapper wrapper: genericList){
                    if(wrapper.isSelected()==selected){
	                	wrappers.add(wrapper);                        
                    }
                }
            }
            return wrappers;
        }catch(Exception e){
            throw e;
        }
        
        return null;
    }
    
    /**
     * Transform an SObject List in an BOMGenericWrapper List
     * @param A List with SObject values
     * @return A List of BOMGenericWrapper
     */
    public static List<BOMGenericWrapper> parseSObjectListToWrapper(List<SObject> sObjects){
        
        try{
			List<BOMGenericWrapper> wrapperList = new List<BOMGenericWrapper>();
            
            if(sObjects!=null && !sObjects.isEmpty()){
                
                for(SObject sObj: sObjects){
					BOMGenericWrapper wrapper = new BOMGenericWrapper(sObj);
                    wrapperList.add(wrapper);
                }
            }
            return wrapperList;
        }catch(Exception e){
			throw e;            
        }
        return null;
    }
    
    /**
     * @param elements - A List of SObject elements.
     * @param LIMIT_OF_RECORDS - Range of records.
     * @return: A sublist ob elements based on limit of records.
     */
    public static List<List<SObject>> subList(List<SObject> elements, Integer LIMIT_OF_RECORDS){
        
        List<List<SObject>> fullList =  new List<List<SObject>>();
        try{

            List<SObject> splitedList = new List<SObject>();
            for (SObject splitedElement : elements) {

                if(splitedList.size() < LIMIT_OF_RECORDS){
                    splitedList.add(splitedElement); 
                }else if(LIMIT_OF_RECORDS == splitedList.size()){
                    fullList.add(splitedList);
                    splitedList = new List<SObject>();
                    splitedList.add(splitedElement); 
                }
            }
            
            if(splitedList.size()<=LIMIT_OF_RECORDS){
                fullList.add(splitedList);
            }
            
            return fullList;

        }catch(Exception e){
            System.debug('Exception on BOMUtils.subList: '+e.getStackTraceString());
        }
        
        return null;
    }
    
    /**
     * @param elements - A Set of ID elements.
     * @param LIMIT_OF_RECORDS - Range of records.
     * @return: A subset of elements based on record limits.
     */
    public static Set<Set<ID>> subSet(Set<ID> elements, Integer LIMIT_OF_RECORDS){
        
        Set<Set<ID>> fullSet = new Set<Set<ID>>();
        try{

            Set<ID> splitedSet = new Set<ID>();
            for (ID splitedElement : elements) {

                if(splitedSet.size() < LIMIT_OF_RECORDS){
                    splitedSet.add(splitedElement);
                }else if(LIMIT_OF_RECORDS == splitedSet.size()){
                    fullSet.add(splitedSet);
                    splitedSet = new Set<ID>();
                    splitedSet.add(splitedElement); 
                }
            }
            
            if(splitedSet.size()<=LIMIT_OF_RECORDS){
                fullSet.add(splitedSet);
            }
            
            return fullSet;

        }catch(Exception e){
            System.debug('Exception on BOMUtils.subSet: '+e.getStackTraceString());
        }
        
        return null;
    }
	
	/**
	 * @param A List of SObject
	 * @return A Set<ID> with all ID's.
	 */    
    public static Set<ID> getIDs(List<SObject> values){
        Set<ID> ids = new Set<ID>();
        for(SObject obj : values){
            ids.add(obj.ID);
        }
        return ids;
    }
    
    /**
     * @param A List of BOMGenericWrapper
     * @return A Set<ID> with all ID's.
     */    
    public static Set<ID> getIDs(List<BOMGenericWrapper> values){
        Set<ID> ids = new Set<ID>();
        for(BOMGenericWrapper obj : values){
            ids.add(obj.getId());
        }
        return ids;
    }
    
    public static String getStackTrace(Exception e){
        
        String stackTrace  = 'Message: '+e.getMessage();
        	   stackTrace += '\n Cause: '+e.getCause();
        	   stackTrace += '\n Line Number: '+e.getLineNumber();	
        	   stackTrace += '\n Entire Stack: '+e.getStackTraceString();
        
        return stackTrace;
    }
    
    /**
     * @return BOM Mass Creation Limit of records.
     */
    public static Integer getMassCreationRecordsLimit(){
        try{
            BulkDataSize__c data = BulkDataSize__c.getValues('LIMITS');
            Decimal bomLimit = data.BOM_MASS_RECORDS_LIMIT__c;
            return bomLimit.intValue();
        }catch(Exception e){
            System.debug(getStackTrace(e));
        }
        
        return 90;
    }
    
    /**
     * @return Contract App Limit of records.
     */
    public static Integer getContractAppRecordsLimit(){
        try{
            BulkDataSize__c data = BulkDataSize__c.getValues('LIMITS');
            Decimal contractLimit = data.CONTRACT_APP_RECORDS_LIMIT__c;
            return contractLimit.intValue();
        }catch(Exception e){
            System.debug(getStackTrace(e));
        }
        
        return 100;
    }
}