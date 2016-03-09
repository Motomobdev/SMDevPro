public with sharing class Program_Clone {
    public Program__c originalProgram {get; set;}
    public Program__c newProgram {get; set;}
    
    public String errorMessage {get; set;}
    public String originalOwnerMessage {get; set;}
    // should only be able to clone a baseline
    
    public Program_Clone(ApexPages.StandardController controller){
        errorMessage = null;
        originalOwnerMessage = null;
        originalProgram = [SELECT Id, Name, OwnerId, Description__c, State__c, Reviewed_Approved__c, SW_Apps_Instructions__c, Tech_Team__c, Type__c FROM Program__c WHERE Id =: controller.getId()];
        if(originalProgram.Type__c == 'Delta'){
            errorMessage = 'This Program cannot be cloned because it is of type Delta.';
        } else {
            newProgram = new Program__c(Name=originalProgram.Name+'-CLONE', OwnerId=originalProgram.OwnerId, Description__c=originalProgram.Description__c, State__c=originalProgram.State__c, Reviewed_Approved__c='No', SW_Apps_Instructions__c=originalProgram.SW_Apps_Instructions__c, Tech_Team__c=originalProgram.Tech_Team__c, Type__c=originalProgram.Type__c);
			if([SELECT Id, isActive FROM User WHERE Id =: originalProgram.OwnerId].isActive == true){
				newProgram.OwnerId = originalProgram.OwnerId;
			} else {
				newProgram.OwnerId = UserInfo.getUserId();
				originalOwnerMessage = 'The owner of the original program is no longer active. You have been set as the default owner.';
			}
        }
        system.debug('THIS IS ERROR MESSAGE' + errorMessage);
    }
    
    public PageReference completeClone(){
        insert newProgram;
        
        List<Program_Application__c> newProgApps = new List<Program_Application__c>();
        for(Program_Application__c pa : [SELECT Id, Program__c, Application__c, Description__c, Instructions__c, Status__c FROM Program_Application__c WHERE Program__c =: originalProgram.Id]){
                newProgApps.add(new Program_Application__c(Program__c=newProgram.Id, Application__c=pa.Application__c, Description__c=pa.Description__c, Instructions__c=pa.Instructions__c, Status__c=pa.Status__c));
        }
        insert newProgApps;
        
        return new PageReference('/' + newProgram.Id);
    }
    
    public PageReference cancel(){
        return new PageReference('/' + originalProgram.Id);
    }
    
    private static testmethod void Program_CloneTest(){
		Program__c p = new Program__c(Name='testProgram', Type__c='Baseline');
		insert p;
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='testApp', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		insert ca;

		Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=app.Id, Status__c = 'Optional');

		insert pa;
		
		PageReference pageRef = Page.Program_Clone;
		Apexpages.StandardController Program_CloneController = new Apexpages.standardController(p);
        pageRef.getParameters().put('id', p.id);
        test.setCurrentPage(pageRef);
        Program_Clone myPageCon = new Program_Clone(Program_CloneController);
        PageReference pf = myPageCon.cancel();
        pf = myPageCon.completeClone();
        
        p.Type__c = 'Delta';
        update p; 
        Program_CloneController = new Apexpages.standardController(p);
        myPageCon = new Program_Clone(Program_CloneController);
	}
}