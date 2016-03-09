public class submitEIS {
	private Boolean showPage1 = true;
	private Boolean showForm = false;
	private Boolean showPage2 = false;

	public Boolean acceptedTerms{get;set;} 
	
	private External_Idea_Submission__c hiddenEIS;
	
    public External_Idea_Submission__c eis{get;set;}
	
	public Attachment attachment {
	get {
	    if (attachment == null)
	      attachment = new Attachment();
	    return attachment;
	  }
	set;
	}	
	public List<String> aNames{get;set;}

    public submitEIS(ApexPages.StandardController controller) {
    	eis = new External_Idea_Submission__c();
    	eis.Idea_Status__c = 'Submitted';
    	acceptedTerms = false;
    	aNames = new List<String>();
    }
    
    public void accept(){
    	if(acceptedTerms) {
    		acceptedTerms = false;
    	}
    	else acceptedTerms = true;
    }    
    
    public Boolean getShowPage1(){
    	return showPage1;
    }
    
    public Boolean getShowForm(){
    	return showForm;
    }
    
    public Boolean getShowPage2(){
    	return showPage2;
    }    
        
    public void goToForm(){
    	showPage1 = false;
    	showForm = true;
    }
    
    public void add_attachment() {
    	if(hiddenEIS == null){
    		hiddenEIS = new External_Idea_Submission__c();
    		insert hiddenEIS;
    	}
    	
    	if(attachment.Body != null && attachment.Name != null){
    		attachment.ParentId = hiddenEIS.Id;
    		aNames.add(attachment.Name);
    		insert attachment;
    		attachment = new Attachment();    		
    	}
	}
	
	public void submit(){
		insert eis;
		
		if(hiddenEIS != null){
			system.debug('hiddenEIS is not null');
			List<Attachment> tempAttachments = [SELECT id, parentId, Body, Name FROM Attachment WHERE parentId =: hiddenEIS.Id];
			List<Attachment> finalAttachments = new List<Attachment>();
			for(Attachment ta : tempAttachments){
				Attachment na = new Attachment(name=ta.Name, body=ta.Body, parentId = eis.Id);
				finalAttachments.add(na);
			}
			delete tempAttachments;			
			delete hiddenEIS;
			hiddenEIS=null;
			insert finalAttachments;
		}
				
		showForm = false;
		showPage2 = true;
	}     
    
    public PageReference cancel(){
		if(hiddenEIS != null){
			system.debug('hiddenEIS is not null');
			List<Attachment> attachments = [SELECT id, parentId FROM Attachment WHERE parentId =: hiddenEIS.Id]; 
			delete attachments;		
			delete hiddenEIS;
		}    	    	
    	return new PageReference('http://www.motorola.com');
    }
    
	public static testMethod void testSubmitEIS(){
		//List<DeviceApplicationAssoc__c> DAlist = [SELECT id FROM DeviceApplicationAssoc__c WHERE Approval_Status__c = 'In Progress' LIMIT 1];
		External_Idea_Submission__c eis = new External_Idea_Submission__c();
		ApexPages.StandardController setCon = new ApexPages.StandardController(eis);
		submitEIS sEIS = new submitEIS(setCon);
		Blob b = Blob.valueOf('body');
		sEIS.attachment.Body = b;
		sEIS.attachment.Name = 'name';
		sEIS.add_attachment();
		Boolean showForm = sEIS.getShowForm();
		Boolean showPage1 = sEIS.getShowPage1();
		Boolean showPage2 = sEIS.getShowPage2();
		sEIS.goToForm();
		sEIS.accept();
		sEIS.accept();
		sEIS.submit();
		
		sEIS = new submitEIS(setCon);
		sEIS.attachment.Body = b;
		sEIS.attachment.Name = 'name';
		sEIS.add_attachment();
		PageReference pr = sEIS.cancel();		
	}

}