/**
 * App filter parameter.
 * Used in BOMSelectApp.vfp
 * @author: Jimens Lima - jimens@motorola.com
 */ 
public class BOMAppFilter {

    public String appName    				 {get;set;}
    public Device__c device  				 {get;set;}
    public Program_Application__c programApp {get;set;}
    
    public BOMAppFilter(){
       appName      = '';
       device       = new Device__c();
       programApp   = new Program_Application__c();
    }
    
    public boolean isEmpty(){
        
        try{
            if(!BOMUtils.isEmpty(appName) || !BOMUtils.isEmpty(device.Core_Device_Package__c) || !BOMUtils.isEmpty(device.Stable__c) ||!BOMUtils.isEmpty(programApp.Program__c)){
                return false;
            }
        }catch(Exception e){
            throw e;
        }
        return true;
    }
}