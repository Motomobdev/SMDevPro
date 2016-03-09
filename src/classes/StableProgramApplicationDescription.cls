/**
Program Application Description is an extension of stable program that retrieves Program Application
Description and Instruction and display on Stable Program.  The pages that are using this controller
are to display the Program_Application_Description__c, and Program_Application_instruction__c fields.
If Program Application Description and Instruction fields are empty, use Application Description and
Instruction field value. 
*/
public with sharing class StableProgramApplicationDescription {
    private Stable_Application__c controller {get;set;}
    public Program_Application__c description{get;set;}
    public boolean isPgmAppDescription{get;set;}
    public boolean isPgmAppInstructions{get;set;}
    public StableProgramApplicationDescription(ApexPages.StandardController controller){
        this.controller=(Stable_Application__c)controller.getRecord();
		String query=null;
	    List<String> allFields=new List<String>();
	    allFields.addAll(Stable_Application__c.getSObjectType().getDescribe().fields.getMap().keyset());
	    query='select '+allFields.get(0);
	    for(integer i=1;i<allFields.size();i++){
			query+=','+allFields.get(i);
		}
		query+=' from Stable_Application__c where id=\''+this.controller.id+'\'';
		this.controller=Database.query(query);
		isPgmAppDescription=false;
		isPgmAppInstructions=false;
		description=new Program_Application__c(Application_Description__c='',Application_Instructions__c='',Description__c='',Instructions__c='');
    	Program_Application__c programApplication=null;
    	try{
    		programApplication=[select Application_Description__c,Application_Instructions__c,Instructions__c,Description__c from Program_Application__c where Program__c=:this.controller.Source_Id__c and Application__c=:this.controller.Application__c limit 1];
    	}catch(QueryException qe){
    	}
    	if(programApplication!=null){
			// Display the first one if there is more than one record.
			if(programApplication.Description__c!=null&&programApplication.Description__c.length()>0){
				description.Description__c=programApplication.Description__c;
				isPgmAppDescription=true;
			}else{
				description.Application_Description__c=programApplication.Application_Description__c;
				isPgmAppDescription=false;
			}
			if(programApplication.Instructions__c!=null&&programApplication.Instructions__c.length()>0){
				description.Instructions__c=programApplication.Instructions__c;
				isPgmAppInstructions=true;
			}else{
				description.Application_Instructions__c=programApplication.Application_Instructions__c;
				isPgmAppInstructions=false;
			}
    	}
    }
	public static testmethod void testStableProgramApplicationDescription(){
		Test.startTest();
		Test.setCurrentPageReference(Page.StableProgramApplicationDescription);
		Program__c program=new Program__c(name='Test Program');
		Application__c application=new Application__c(name='Test Application',Application_Type__c='Preload',Application_Sub_Type__c='Data');
		insert program;
		insert application;
		Program_Application__c programApplication=new Program_Application__c(program__c=program.id,application__c=application.id,description__c='test description',instructions__c='test instructions');
		insert programApplication;
		Stable__c stable=new Stable__c(name='Test Stable');
		insert stable;
		Stable_Application__c stableApplication=new Stable_Application__c(stable__c=stable.id,application__c=application.id,source_id__c=program.id);
		insert stableApplication;
		ApexPages.Standardcontroller stableApplicationController=new ApexPages.Standardcontroller(stableApplication);
		StableProgramApplicationDescription stableAppDesc=new StableProgramApplicationDescription(stableApplicationController);
		Test.stopTest();
	}
}