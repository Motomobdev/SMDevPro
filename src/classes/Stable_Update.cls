public with sharing class Stable_Update {
	public static void beforeUpdate(List<Stable__c> newList, List<Stable__c> oldList){
		StableMethods.checkNameChange(newList, oldList);
		
		Map<Id, Stable__c> stableIdMap = new Map<Id, Stable__c>(newList);
		List<Id> newApprovedStableIds = new List<Id>();
		
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Reviewed_Approved__c == 'Yes' && newList[i].Reviewed_Approved__c != oldList[i].Reviewed_Approved__c){
				newApprovedStableIds.add(newList[i].Id);
			}
		}
		
		List<Stable_Program__c> stablePrograms = [SELECT Id, Stable__c, Program__r.Reviewed_Approved__c FROM Stable_Program__c WHERE Stable__c IN : newApprovedStableIds AND Program__r.Reviewed_Approved__c = 'No']; 
		
		for(Stable_Program__c sa : stablePrograms){
			stableIdMap.get(sa.Stable__c).addError('This Stable cannot be approved yet because all of its programs have not yet been approved.');
		}
	}
	
	private static testmethod void beforeUpdateTest(){
		Stable__c s = new Stable__c(Name='testStable');
		insert s;
		Program__c p = new Program__c(Name='testProgram', Reviewed_Approved__c = 'No');
		insert p;
		Stable_Program__c sp = new Stable_Program__c(Stable__c=s.Id, Program__c=p.Id);
		insert sp;
		
		User u = [SELECT Id FROM User WHERE Name = 'Brian Chiang'];
		Test.startTest();
			s.Reviewed_Approved__c = 'Yes';			
			try{
				update s;
			} catch(System.DMLException e){
				System.assert(e.getMessage().contains('This Stable cannot be approved yet because all of its programs have not yet been approved.'));
			}
			
			s.Reviewed_Approved__c = 'No';
			s.Name = 'nameChange';
			try{
				System.runAs(u){
					update s;
				}
			} catch(System.DMLException e){
				System.assert(e.getMessage().contains('You cannot edit the name of this Stable.'));
			}
		Test.stopTest();
	}
}