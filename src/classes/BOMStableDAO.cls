/***
 * BOM Stable__c DAO
 * @author: Jimens Lima - jimens@motorola.com
 */ 
public class BOMStableDAO {

	/**
	 * @param ID stable 
	 * @return Stable__c 
	 */     
    public Stable__c searchByID(ID stableID){
        try{
            Stable__c stable = [SELECT Id,Name,Number_of_Apps_on_Stable__c FROM Stable__c WHERE Id = :stableID];
            
            return stable;
        }catch(Exception e){
            throw e;
        }
    }
}