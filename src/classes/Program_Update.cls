public with sharing class Program_Update {
	public static void beforeUpdate(List<Program__c> newList, List<Program__c> oldList){
		ProgramMethods.validateUpdateWithApprovedState(newList, oldList);
		
		Map<Id, Program__c> programIdMap = new Map<Id, Program__c>(newList);
		List<Id> newApprovedProgramIds = new List<Id>();
				
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Reviewed_Approved__c == 'Yes' && newList[i].Reviewed_Approved__c != oldList[i].Reviewed_Approved__c){
				newApprovedProgramIds.add(newList[i].Id);
			}
		}
				
		List<Program_Application__c> candidateProgramApps = [SELECT Id, Program__c FROM Program_Application__c WHERE Program__c IN : newApprovedProgramIds AND Status__c = 'Candidate']; 
		
		for(Program_Application__c pa : candidateProgramApps){
			programIdMap.get(pa.Program__c).addError('This program cannot be approved yet because it still has applications with the status candidate.');
		}
	}
	
	public static void afterUpdate(List<Program__c> newList, List<Program__c> oldList){
		List<Program__c> programsWithUpdatedStables = new List<Program__c>();
		List<Program__c> programsWithUpdatedStablesOldList = new List<Program__c>();
		List<Program__c> programsWithTheNameChange = new List<Program__c>();
            
		for(Integer i=0; i<newList.size(); i++){
                    if(newList[i].Stables__c != oldList[i].Stables__c && (oldList[i].Stables__c != null || oldList[i].Stables__c != '')){
                        programsWithUpdatedStablesOldList.add(oldList[i]);
                    }
			
                    if(newList[i].Stables__c != oldList[i].Stables__c && (newList[i].Stables__c != null && newList[i].Stables__c != '')){
                        programsWithUpdatedStables.add(newList[i]);
                    } 

                    if(newList[i].name != oldList[i].name){
                        programsWithTheNameChange.add(newList[i]);
                    }
                }
            
		if(!programsWithUpdatedStablesOldList.isEmpty()){ ProgramMethods.removeOldProgramFromStable(programsWithUpdatedStablesOldList); }
		if(!programsWithUpdatedStables.isEmpty()){ ProgramMethods.associateProgramToStable(programsWithUpdatedStables); }
                if(!programsWithTheNameChange.isEmpty()){ ProgramMethods.updateStableApplicationSourceName(programsWithTheNameChange); }
	}
	
	private static testmethod void beforeUpdateTest(){
		Program__c p = new Program__c(Name='testProgram', Reviewed_Approved__c = 'No');
		insert p;
		
		Account a = new Account(Name='testAccount', Tier__c ='1');
		insert a;
		Application__c app = new Application__c(Name='app', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
		insert app;
		Contract c = new Contract(Name='contract', StartDate = Date.today(), AccountId=a.Id);
		insert c;
		ContApplAssoc__c ca = new ContApplAssoc__c(Contract__c=c.Id, Application__c=app.Id, Governing_End_Date__c=true);
		insert ca;
		
		Program_Application__c pa = new Program_Application__c(Program__c=p.Id, Application__c=app.Id);
		insert pa;
		
		User u = [SELECT Id FROM User WHERE Name = 'Brian Chiang'];
		Test.startTest();
			p.Reviewed_Approved__c = 'Yes';			
			try{
				update p;
			} catch(System.DMLException e){
				System.assert(e.getMessage().contains('This program cannot be approved yet because it still has applications with the status candidate.'));
			}
			
			p.Reviewed_Approved__c = 'No';
			p.Name = 'nameChange';
			try{
				System.runAs(u){
					update p;
				}
			} catch(System.DMLException e){
				System.assert(e.getMessage().contains('You cannot edit the name of this Program.'));
			}
			
			p.Stables__c = 'stable';
			update p;
			
			delete pa;
			p.Reviewed_Approved__c = 'Yes';
			update p;
			u = [SELECT Id FROM User WHERE isActive=true AND profileId !=  : [SELECT Id FROM Profile WHERE Name = 'MotoDev - SysAdmin'].Id LIMIT 1];
			try{
				System.runAs(u){
					p.Type__c = 'try to update a approved program';
				}
			} catch(System.DMLException e){
				System.assert(e.getMessage().contains('You cannot edit this Reviewed And Approved Program.'));
			}

		Test.stopTest();
	}
}