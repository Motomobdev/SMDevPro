/**
 * BOM Core_Device_Package__c DAO
 * @author: Jimens
 * @since: 11/13/2014
 */ 
public class BOMCoreDevPackDAO {
    
    /**
	 * @param ID stable 
	 * @return Core_Device_Package__c 
	 */     
    public Core_Device_Package__c searchByID(ID cdpID){
        try{
        	Core_Device_Package__c cdp = [SELECT Id,Name FROM Core_Device_Package__c WHERE Id = :cdpID];    
            return cdp;
        }catch(Exception e){
			throw e;            
        }
    }
}