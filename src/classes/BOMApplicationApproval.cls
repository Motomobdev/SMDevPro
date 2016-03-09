/**
 * This Wrapper class, facilitates DevApp record creation with a previous analyses
 * with each tied App and / or with your own group of Apps (Stable OR Core Dev Pack).
 * @author: Jimens
 * @since: 11/18/2014
 */
public class BOMApplicationApproval {
    public boolean autoApprove 				 {get;set;}
    public boolean includeInBOM				 {get;set;}
    public Application__c application        {get;set;}
    public Stable__c stable					 {get;set;}
    public Core_Device_Package__c  corePack  {get;set;}
    public Program__c  program			  	 {get;set;}
    
    public BOMApplicationApproval(){
        application  = new Application__c();
        corePack     = new Core_Device_Package__c();
        stable       = new Stable__c();
        program      = new Program__c();
        autoApprove  = FALSE;
		includeInBOM = TRUE;        
    }
	
	/**
	 * @return Source ID used in DevApp
	 */
    public ID getSourceID(){
        if(corePack.Id !=null){
            return corePack.Id;
        }else if(stable.Id !=null){
            return stable.Id;
        }else if(program.Id !=null){
            return program.Id;
        }
        return null;
    }

    /**
	 * @return Source ID used in DevApp
	 */    
    public String getSourceName(){
        if(corePack.Id !=null){
            return corePack.Name;
        }else if(stable.Id !=null){
            return stable.Name;
        }else if(program.Id !=null){
            return program.Name;
        }
        return null;
    }
}