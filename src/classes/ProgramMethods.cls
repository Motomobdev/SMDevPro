public with sharing class ProgramMethods {	
    
    /*
     * Created by: Jesse
     * Creation date: Unknown
     * Description: <TO-DO>
     * Change history:
     * Date: 16-May-2012
     * Changed by: Rajesh Krishnaiah
     * Changes: Added updateStableApplicationSourceName method for 
     *          updating the source name on stable applications
     *          when the program name changes.
     */
   
    public static void updateStableApplicationSourceName(List<Program__c> newList) {
        Set<Id> programIds = new Set<Id>();
        Map<Id, String> programNames = new Map<Id, String>();
        Map<Id, String> stableKeyProgramName = new Map<Id, String>();
        
        for (Program__c p : newList) {
            programIds.add(p.id);
            programNames.put(p.id, p.name);
        }

        List<Stable_Application__c> stableApps = 
            [select id, name, stable__c, Source_Name__c, Source_Id__c
             from Stable_Application__c
             where Source_Id__c in :programIds];

        for (Stable_Application__c sa : stableApps) {
            sa.source_name__c = programNames.get(sa.Source_Id__c);
        }

        update stableApps;
    }
    
    public static void validateInsertAndsetTypeToDeltaForDatafeedEnteredPrograms(List<Program__c> newList){
		//User dataFeed = [SELECT Id FROM User WHERE Name = 'Automated Data Feed'];
		
		for(Program__c p : newList){
			if(p.Type__c == 'Delta' && UserInfo.getName() != 'Automated Data Feed'){
				p.addError('You cannot create a Delta Program.');
			} 
		}
		
		if(UserInfo.getName() == 'Automated Data Feed'){
			for(Program__c p : newList){
				p.Type__c = 'Delta';
			}
		}
	}
	
	public static void validateUpdateWithApprovedState(List<Program__c> newList, List<Program__c> oldList){
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Name != oldList[i].Name && UserInfo.getUserId() != newList[i].CreatedById && newList[i].Type__c == 'Delta'){
				newList[i].addError('You cannot edit the name of this Program.');
			}
			
			if(newList[i].Reviewed_Approved__c == 'Yes' && oldList[i].Reviewed_Approved__c == 'Yes' && UserInfo.getProfileId() != [SELECT Id FROM Profile WHERE Name = 'MotoDev - SysAdmin'].Id){
				if(newList[i].Tech_Team__c != oldList[i].Tech_Team__c || newList[i].Type__c != oldList[i].Type__c || newList[i].MOT_Id__c != oldList[i].MOT_Id__c )
				newList[i].addError('You cannot edit this Reviewed And Approved Program.');
			}
		}
	}
	
	public static void removeOldProgramFromStable(List<Program__c> oldList){
		List<Stable_Program__c> oldSP = [SELECT Id FROM Stable_Program__c WHERE Program__c IN : oldList];
		delete oldSP;
	}
	 
	public static void associateProgramToStable(List<Program__c> newList){
		Set<String> stablePDWIds = new Set<String>();
		for(Program__c p : newList){
			if(p.Stables__c != null){
				stablePDWIds.addAll(p.Stables__c.split(','));
				system.debug('THIS IS stablePDWIds: ' + stablePDWIds);
			}			
		}
		
		if(!stablePDWIds.isEmpty()){
			Map<String, Stable__c> stableMOTIdMap = new Map<String, Stable__c>();
			for(Stable__c stable : [SELECT Id, MOT_Id__c FROM Stable__c WHERE MOT_Id__c IN : stablePDWIds]){
				stableMOTIdMap.put(stable.MOT_Id__c, stable);
			}
			
			Map<String, Stable__c> stablesToInsertMap = new Map<String, Stable__c>();
			List<Program__c> programsWithUnknownStables = new List<Program__c>();
			List<Stable_Program__c> stableProgramsToInsert = new List<Stable_Program__c>();
			
			for(Program__c p : newList){
				if(p.Stables__c != null){
					for(String motId : p.Stables__c.split(',')){
						if(stableMOTIdMap.get(motId) != null){
							stableProgramsToInsert.add(new Stable_Program__c(Stable__c = stableMOTIdMap.get(motId).Id, Program__c = p.Id));
						} else {
							stablesToInsertMap.put(motId, new Stable__c(Name = motId, MOT_Id__c = motId));
							programsWithUnknownStables.add(p);
						}
					}
				}
			}
					
			if(!stablesToInsertMap.isEmpty()) {
				insert stablesToInsertMap.Values();
				for(Program__c p : programsWithUnknownStables){
					for(String motId : p.Stables__c.split(',')){
						if(stablesToInsertMap.containsKey(motId)){
							stableProgramsToInsert.add(new Stable_Program__c(Stable__c = stablesToInsertMap.get(motId).Id, Program__c = p.Id));
						}
					}				
				}
			}
			
			if(!stableProgramsToInsert.isEmpty()){
				insert stableProgramsToInsert;
			}
		}
	}
	
	public static void associateProgramToTechTeam(List<Program__c> newList){		
		Set<String> techTeamIds = new Set<String>();
		for(Program__c p : newList){
			if(p.Tech_Team_MOT_Id__c != null){
				techTeamIds.add(p.Tech_Team_MOT_Id__c);
			}
		}
		
		if(!techTeamIds.isEmpty()){
			
			Map<String, Tech_Team__c> techTeamMOTIdMap = new Map<String, Tech_Team__c>();
			for(Tech_Team__c techTeam : [SELECT Id, Name, MOT_Id__c, OwnerId FROM Tech_Team__c WHERE MOT_Id__c IN : techTeamIds]){
				techTeamMOTIdMap.put(techTeam.MOT_Id__c, techTeam);
			}
			
			Map<String, Tech_Team__c> techTeamsToInsertMap = new Map<String, Tech_Team__c>();
	
			List<Program__c> programsWithUnknownTechTeam = new List<Program__c>();
			
			for(Program__c p : newList){
				if(p.Tech_Team_MOT_Id__c != null && techTeamMOTIdMap.get(p.Tech_Team_MOT_Id__c) != null){
					p.Tech_Team__c = techTeamMOTIdMap.get(p.Tech_Team_MOT_Id__c).Id;
					p.OwnerId = techTeamMOTIdMap.get(p.Tech_Team_MOT_Id__c).OwnerId;				
				} else if(p.Tech_Team_MOT_Id__c != null && techTeamMOTIdMap.get(p.Tech_Team_MOT_Id__c) == null){
					techTeamsToInsertMap.put(p.Tech_Team_MOT_Id__c, new Tech_Team__c(Name=p.Tech_Team_MOT_Id__c, Mot_ID__c=p.Tech_Team_MOT_Id__c));
					programsWithUnknownTechTeam.add(p);
				}
			}
			
			if(!techTeamsToInsertMap.isEmpty()) {
				insert techTeamsToInsertMap.Values();
				for(Program__c p : programsWithUnknownTechTeam){
					p.Tech_Team__c = techTeamsToInsertMap.get(p.Tech_Team_MOT_Id__c).Id;
				}
			}
		}
	}	
	
	private static testmethod void associateProgramToStableTest(){		
		Stable__c s = new Stable__c(Name='s', MOT_Id__c = 's');
		insert s;
		
		Program__c p = new Program__c(Name='p', Stables__c='s', Type__c = 'Baseline');
		Program__c p2 = new Program__c(Name='p', Stables__c='s2', Type__c = 'Baseline');
		
		Test.startTest();
			insert new List<Program__c>{p, p2};
			
			p.Stables__c = 's2';
			update p;
            
                        // Simulate name change
                        p.name = 'P2';
                        update p;
		Test.stopTest();
	}
	
	private static testmethod void associateProgramToTechTeamTest(){		
		Tech_Team__c tt = new Tech_Team__c(Name='tt', MOT_Id__c = 'tt');
		insert tt;
		
		Program__c p = new Program__c(Name='p', Tech_Team_MOT_Id__c='tt', Type__c = 'Baseline');
		Program__c p2 = new Program__c(Name='p2', Tech_Team_MOT_Id__c='tt2', Type__c = 'Baseline');
		Program__c p3 = new Program__c(Name='p3', Tech_Team_MOT_Id__c='tt2', Type__c = 'Baseline');
		
		Test.startTest();
			insert new List<Program__c>{p, p2, p3};
		Test.stopTest();
	}
	
	private static testmethod void validateInsertAndsetTypeToDeltaForDatafeedEnteredProgramsTest(){
		User u = [SELECT Id FROM User WHERE Name = 'Automated Data Feed'];
		Program__c p = new Program__c(Name='p');
		Program__c p2 = new Program__c(Name='p', Type__c='Delta');
		Test.startTest();
			System.runAs(u){
				insert p;
			}
			
			try{
				insert p2;
			} catch(System.DMLException e){
				System.assert(e.getMessage().contains('You cannot create a Delta Program.'));
			}
		Test.stopTest();
	}	
}