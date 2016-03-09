/**
 * Generic BOM Wrapper that helps user selection on list views.
 * For every List View on BOM Flow, this object abstracts the Screen data manipulation.
 * @author: Jimens Lima - jimens@motorola.com
 */
public class BOMGenericWrapper implements Comparable {

    public Boolean selected 	    {get;set;}
    public Boolean disableCheck     {get;set;}
    public Boolean includeInBOM     {get;set;}
    public String  status  		    {get;set;}
    public String  additionalStatus {get;set;}
    public SObject sfObject 	    {get;set;}
    
    public BOMGenericWrapper(SObject sfObject){
        this.sfObject   = sfObject;
        selected 		= FALSE;
        disableCheck    = FALSE;
        includeInBOM    = TRUE;
        status  		= '';
    }
    
    public ID getId(){
        
        if(sfObject!=null){
           return sfObject.ID;  
        }
        
        return null;
    }
    
    /**
     * Comparable method used to sort items on Visual Pages.
     */
    public Integer compareTo(Object obj){
        BOMGenericWrapper wrapper = (BOMGenericWrapper)obj;
        
        if(getId()!=null){
            
            if(getId().equals(wrapper.getId())){
                return 0;
            }else{
                return 1;
            }
        }
        
        return -1;
    }
    
    public Boolean isSelected(){
        return selected == TRUE;
    }
    
    public Boolean isIncludedInBOM(){
        return includeInBOM == TRUE;
    }
    
    public Device__c getDevice(){
        if(sfObject instanceof Device__c){
            return (Device__c)sfObject;
        }
        return null;
    }
    
    public Application__c getApp(){
        if(sfObject instanceof Application__c){
            return (Application__c)sfObject;
        }
        return null;
    }
    
    public DeviceApplicationAssoc__c getDevApp(){
        if(sfObject instanceof DeviceApplicationAssoc__c){
            return (DeviceApplicationAssoc__c)sfObject;
        }
        return null;
    }
    
    public Stable__c getStable(){
        if(sfObject instanceof Stable__c){
            return (Stable__c)sfObject;
        }
        return null;
    }
    
    public Core_Device_Package__c getCDP(){
        if(sfObject instanceof Core_Device_Package__c){
            return (Core_Device_Package__c)sfObject;
        }
        return null;
    }
    
    public Program__c getProgram(){
        if(sfObject instanceof Program__c){
            return (Program__c)sfObject;
        }
        return null;
    }
}