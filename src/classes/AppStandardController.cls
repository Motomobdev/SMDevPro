public class AppStandardController{
    
    public String MMID {get;set;}
    public Boolean verified {get;set;}
	private Motorola_Core_Directory__c MMIDusr;
    
    public String inputName {get;set;}
    public String likeName {get;set;}
    public Boolean hasNext {get;set;}
    public Boolean hasPrevious {get;set;}
    
    private List<Application__c> apps;
    
    
    public AppStandardController(){
        verified = false;
        MMID = ApexPages.CurrentPage().getParameters().get('MMID');
		if(MMID != null) verified = validateMMID(MMID);
        
    	apps = new List<Application__c>();
        hasNext = false;
        hasPrevious = false;
    }
    
    public void restartSearch(){
        if(inputName == null || inputName.trim() == ''){
        	ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Search criteria cannot be blank.'));
        	apps =  new List<Application__c>();
            hasNext = false;
        	hasPrevious = false;
            return;
        }
        likeName = inputName + '%';
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT id,Name,Application_ID__c,Market_Name__c FROM Application__c Where Name like :likeName or Market_Name__c like :likeName]));
        apps = (List<Application__c>) setCon.getRecords();
        hasNext = setCon.getHasNext();
        hasPrevious = setCon.getHasPrevious();
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT id,Name,Application_ID__c,Market_Name__c FROM Application__c Where Name like :likeName or Market_Name__c like :likeName]));
            }
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<Application__c> getApps() {
        return apps;
    }
    
    public void next(){
    	setCon.next();
        apps = (List<Application__c>) setCon.getRecords();
        hasNext = setCon.getHasNext();
        hasPrevious = setCon.getHasPrevious();
    }
    
    public void previous(){
    	setCon.previous();
        apps = (List<Application__c>) setCon.getRecords();
        hasNext = setCon.getHasNext();
        hasPrevious = setCon.getHasPrevious();
    }
    
    /*****************************/
    //
    // MMID Verifier
    //
    /*****************************/
    
    public void validateMMIDInput(){
		verified = validateMMID(MMID);
	}
	
	// Copied from ContractRequestFormCtr.cls
	public Boolean validateMMID(String MMIDInput) 
    {
        try
        {
            MMIDInput = MMIDInput.toUpperCase();
                
            Motorola_Core_Directory__c[] usr = [SELECT Id,
                                                       Name,
                                                       MMID__c,
                                                       MobilePhone__c,
                                                       WorkPhone__c,
                                                       OrgLevel1__c, 
                                                       OrgLevel2__c, 
                                                       OrgLevel3__c
                                                FROM   Motorola_Core_Directory__c
                                                WHERE  MMID__c = :MMIDInput AND
                                                       DirectoryStatus__c = 'A'];
            if(usr.size() == 1)
            { 
            	MMIDusr = usr.get(0);
            	return true;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'MMID is invalid or inactive.'));
            }
            
        }
        catch(Exception ex)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()); 
        	ApexPages.addMessage(msg);
        }
        
        return false;
    }
    
}