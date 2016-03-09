public with sharing class CoreDevicePackageAppDesc {
    private Core_Device_Package_Application__c controller {get;set;}
    public Program_Application__c description{get;set;}
    public boolean isPgmAppDescription{get;set;}
    public boolean isPgmAppInstructions{get;set;}
	public CoreDevicePackageAppDesc(ApexPages.StandardController controller){
        this.controller=(Core_Device_Package_Application__c)controller.getRecord();
		String query=null;
	    List<String> allFields=new List<String>();
	    allFields.addAll(Core_Device_Package_Application__c.getSObjectType().getDescribe().fields.getMap().keyset());
	    query='select '+allFields.get(0);
	    for(integer i=1;i<allFields.size();i++){
			query+=','+allFields.get(i);
		}
		query+=' from Core_Device_Package_Application__c where id=\''+this.controller.id+'\'';
		this.controller=Database.query(query);
		isPgmAppDescription=false;
		isPgmAppInstructions=false;
		description=new Program_Application__c(Application_Description__c='',Application_Instructions__c='',Description__c='',Instructions__c='');
		// Core Device Package Application may have source pointing to Stable or Program directly
		// If it is pointing to Stable, it requires to query Stable Application first, then get the Source as Program, and use that to query Program Application
		Program_Application__c programApplication=null;
		try{
			programApplication=[select Application_Description__c,Application_Instructions__c,Instructions__c,Description__c from Program_Application__c where Program__c=:this.controller.Source_Id__c and Application__c=:this.controller.Application__c limit 1];
		}catch(QueryException qe){
			// Source may point to stable, try below.
		}
    	if(programApplication==null){
    		try{
    			Stable_Application__c stableApplication=[select Source_Id__c from Stable_Application__c where Application__c=:this.controller.Application__c and Stable__c=:this.controller.Source_Id__c and source_id__c!=null limit 1];
    			programApplication=[select Application_Description__c,Application_Instructions__c,Instructions__c,Description__c from Program_Application__c where Program__c=:stableApplication.Source_Id__c and Application__c=:this.controller.Application__c limit 1];
    		}catch(QueryException qe){
    			// Source is pointing to somewhere undefined.  Need investigation.  Blank out description and instruction.
    			
    		}
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
	public static testmethod void testCoreDevicePackageAppDesc(){
		Test.startTest();
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
		Core_Device_Package__c coreDevicePackage=new Core_Device_Package__c(name='Test Core Device Package Application');
		insert coreDevicePackage;
		Core_Device_Package_Application__c coreDevicePackageApplication=new Core_Device_Package_Application__c(Core_Device_Package__c=coreDevicePackage.id,application__c=application.id,source_id__c=stable.id);
		insert coreDevicePackageApplication;
		ApexPages.Standardcontroller coreDevicePackageController=new ApexPages.Standardcontroller(coreDevicePackageApplication);
		CoreDevicePackageAppDesc coreDevicePackageAppDesc=new CoreDevicePackageAppDesc(coreDevicePackageController);
		Test.stopTest();
	}
}