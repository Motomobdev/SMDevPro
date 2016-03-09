public with sharing class ContractMethods {
	public static Boolean isContractInInitialLRBApproval(Contract c){
		if(c.Requested_LRB_Initial_Deal_Present_Date__c != null && (c.LRB_Initial_Deal_Decision__c == '' || c.LRB_Initial_Deal_Decision__c == null)){
			return true;
		}
		return false;
	}
	
	public static Boolean isContractInFinalLRBApproval(Contract c){
		if(c.Requested_LRB_Final_Deal_Present_Date__c != null && (c.LRB_Final_Deal_Review_Decision__c == '' || c.LRB_Final_Deal_Review_Decision__c == null)){
			return true;
		}
		return false;
	}
	
	public static Boolean isContractInSOPE1Approval(Contract c){
		if(c.SOP_E_1_Approval_Status__c == 'In Progress'){
			return true;
		}
		return false;
	}
	
	public static void fillMicrogenContractNumber(List<Contract> newList){
		List<Contract> tempList = new List<Contract>();
		for(Contract c : newList){
			tempList.add(new Contract(Id = c.Id, Microgen_Contract_Number__c = c.ContractNumber));
		}
		
		update tempList;
	}
	
	public static void setPhaseCompletionDates(List<Contract> newList, List<Contract> oldList){
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Id == oldList[i].Id && newList[i].Contract_Phase__c != oldList[i].Contract_Phase__c){
				if(oldList[i].Contract_Phase__c == 'Investigating'){
					newList[i].Phase_0_Complete_Date__c = Date.today();
				} else if(oldList[i].Contract_Phase__c == 'Term Sheet'){
					newList[i].Phase_1_Complete_Date__c = Date.today();
				} else if(oldList[i].Contract_Phase__c == 'Initial Legal Draft'){
					newList[i].Phase_3_Complete_Date__c = Date.today();
				} else if(oldList[i].Contract_Phase__c == 'Redlines/Negotiations'){
					newList[i].Phase_4_Complete_Date__c = Date.today();
				} else if(oldList[i].Contract_Phase__c == 'Approvals'){
					newList[i].Phase_5_Complete_Date__c = Date.today();
				}
				
				if(newList[i].Contract_Phase__c == 'Initial Legal Draft' && oldList[i].Contract_Phase__c != 'Term Sheet'){
					if(newlist[i].Phase_1_Complete_Date__c == null){ newList[i].Phase_1_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_2_Complete_Date__c == null){ newList[i].Phase_2_Complete_Date__c = Date.today(); }
										
				} else if(newList[i].Contract_Phase__c == 'Redlines/Negotiations' && oldList[i].Contract_Phase__c != 'Initial Legal Draft'){
					if(newlist[i].Phase_1_Complete_Date__c == null){ newList[i].Phase_1_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_2_Complete_Date__c == null){ newList[i].Phase_2_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_3_Complete_Date__c == null){ newList[i].Phase_3_Complete_Date__c = Date.today(); }
					
				} else if(newList[i].Contract_Phase__c == 'Approvals' && oldList[i].Contract_Phase__c != 'Redlines/Negotiations'){
					if(newlist[i].Phase_1_Complete_Date__c == null){ newList[i].Phase_1_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_2_Complete_Date__c == null){ newList[i].Phase_2_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_3_Complete_Date__c == null){ newList[i].Phase_3_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_4_Complete_Date__c == null){ newList[i].Phase_4_Complete_Date__c = Date.today(); }
					
				} else if(newList[i].Contract_Phase__c == 'Execution and Processing' && oldList[i].Contract_Phase__c != 'Approvals'){
					if(newlist[i].Phase_1_Complete_Date__c == null){ newList[i].Phase_1_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_2_Complete_Date__c == null){ newList[i].Phase_2_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_3_Complete_Date__c == null){ newList[i].Phase_3_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_4_Complete_Date__c == null){ newList[i].Phase_4_Complete_Date__c = Date.today(); }
					if(newlist[i].Phase_5_Complete_Date__c == null){ newList[i].Phase_5_Complete_Date__c = Date.today(); }
				}
			}
		}
	}
	
	public static void setDefaultFields(List<Contract> newList){
		Map<String, User> userMap = UserMethods.getNameUserMap();
		
		for(Contract c : newList){
			c.Finance_Prepay_Minimum_Guarantees__c = 'Exempt/NA';
			
			try{
				c.Finance_Prepay_Min_Guarantees_Approver__c = userMap.get('Lana Blackburn').Id;
				c.Partnership_Mgmt_Pre_Approval_Approver__c = userMap.get('Ingrid Kelly').Id;				
				c.LRB_Initial_Legal_Approver__c = userMap.get('Jeanine Becker').Id;
				c.LRB_Initial_Finance_Approver__c = userMap.get('Lana Blackburn').Id;
				c.LRB_Final_Legal_Approver__c = userMap.get('Jeanine Becker').Id;
				c.LRB_Final_Finance_Approver__c = userMap.get('Lana Blackburn').Id;
						
			} catch (System.Nullpointerexception e){	}
			
			Id partnerManagerId = [SELECT OwnerId FROM Account WHERE Id =: c.AccountId].OwnerId;
			c.LRB_Requester__c = partnerManagerId;
			c.Partner_Manager__c = partnerManagerId;
			
			c.Is_there_a_Cap__c = 'No';
			c.LRB_Initial_Deal_Notes_Action_items__c = 'None';
			
			c.Business_Model__c = 'Minimum guarantee: None\n' + 'Prepay: None' + 'NRE: None\n' + 'Per unit royalty (range): None\n' + 'Exclusivity: None\n' + 'Estimated savings: None';
		}
	}
	
	public static void updateAppNamesField(Set<Id> contractIds){
		List<Contract> contractsToUpdate = new List<Contract>();
		
		Map<Id, List<ContApplAssoc__c>> contractIdConAppMap = new Map<Id, List<ContApplAssoc__c>>();
		
		for(ContApplAssoc__c ca : [SELECT Contract__c, Application__c, Application__r.Name FROM ContApplAssoc__c WHERE Contract__c IN : contractIds]){
			if(contractIdConAppMap.containsKey(ca.Contract__c)){
				List<ContApplAssoc__c> tempList = contractIdConAppMap.get(ca.Contract__c);
				tempList.add(ca);
				contractIdConAppMap.put(ca.Contract__c, tempList);
			} else {
				contractIdConAppMap.put(ca.Contract__c, new List<ContApplAssoc__c>{ca});
			}
		}
		
		for(Id contractId : contractIds){
			if(contractIdConAppMap.containsKey(contractId)){
				String appNames;
				for(ContApplAssoc__c ca : contractIdConAppMap.get(contractId)){
					if(appNames == null){
						appNames = ca.Application__r.Name;
					} else {
						appNames = appNames + ', ' + ca.Application__r.Name;
					}
				}
				contractsToUpdate.add(new Contract(Id = contractId, App_Names__c = appNames));
			}
		} 
		
		if(!contractsToUpdate.isEmpty()){ update contractsToUpdate; }
	}
	
	public static void setSignatoryForSoftwarePartnershipManagement(List<Contract> newList){
		/*
			Above current Paul and Scott limits (which I paste below from the Delegation of Authority that we received earlier this year)...
			Scott has approval limit <=$2M in spend and <=$5M in Unusual Risk.
			Above Scott is Paul with spend <=$5M and Unusual Risk <=$10M. [Note: Christy or one of her VP's must be added if the Unusual Risk in Paul's approval level is above $5M].
			Above Paul is Bob Cash with approval limits of <=$10M and unusual risk <=$10M.
			Above Bob Cash is Trevor Schick up to $150M in spend and up to $50M in Unusual Risk
			Above Trevor Schick is the CFO or the President up to $250M in spend and $100M in Unusual Risk
			Above the CFO or President is the CEO, with unlimited levels.
			
			FYI, here's the wording for the current Paul / Scott limits:
			
			Scott Gleason Software Category not to exceed $2M in
			spend and $5M of Unusual Risk, provided that
			Bob Cash will be advised of such Unusual
			Risk. This delegation excludes Software
			Category contracts or documentation involving
			(i) Semiconductor Software (i.e., software
			from Semiconductor Suppliers or specifically
			for use with Semiconductor products), and (ii)
			any Software take-or-pay arrangement.
			
			Paul Leeper Software Category not to exceed $5M in
			spend and $10M of Unusual Risk, provided
			that Bob Cash will be advised of such Unusual
			Risk and the Software Category
			Vice-President (or higher officer) approves an
			Unusual Risk estimated between $5-10M.
			This delegation excludes Software Category
			contracts or documentation involving (i)
			Semiconductor Software (i.e., software from
			Semiconductor Suppliers or specifically for
			use with Semiconductor products), and (ii) any
			Software take-or-pay arrangement.
		*/
		
		for(Integer i=0; i<newList.size(); i++){
			if(newList[i].Lifetime_Contract_Value__c <= 2000000 && newList[i].Unusual_Risk_Amount__c <= 5000000){
				// Scott Gleason
				try{
					Id userId = [SELECT Id FROM User WHERE Id = '005400000012Vku'].Id;
					newList[i].LRB_Initial_Partnership_Management__c = userId;
					newList[i].LRB_Final_Partnership_Management__c = userId;
				} catch (System.Queryexception e){
					
				}
			} else if(newList[i].Lifetime_Contract_Value__c <= 5000000 && newList[i].Unusual_Risk_Amount__c <= 10000000){
				// Paul Leeper
				try{
					Id userId = [SELECT Id FROM User WHERE Id = '005400000011zLH'].Id;
					newList[i].LRB_Initial_Partnership_Management__c = userId;
					newList[i].LRB_Final_Partnership_Management__c = userId;
				} catch (System.Queryexception e){
					
				}
			} else {
				// Paul Leeper
				try{
					Id userId = [SELECT Id FROM User WHERE Id = '005400000011zLH'].Id;
					newList[i].LRB_Initial_Partnership_Management__c = userId;
					newList[i].LRB_Final_Partnership_Management__c = userId;
				} catch (System.Queryexception e){
					
				}
			}
			 /* else if(newList[i].Lifetime_Contract_Value__c <= 10000000 && newList[i].Unusual_Risk_Amount__c <= 10000000){
				// Bob Cash
				//newList[i].LRB_Final_Partnership_Management__c = [SELECT Id FROM User WHERE Name = 'Bob Cash'].Id;
			} else if(newList[i].Lifetime_Contract_Value__c <= 150000000 && newList[i].Unusual_Risk_Amount__c <= 50000000){
				// Trevor Schick
				// Assign to Bob Cash though as proxy
				//newList[i].LRB_Final_Partnership_Management__c = [SELECT Id FROM User WHERE Name = 'Bob Cash'].Id;
			} else if(newList[i].Lifetime_Contract_Value__c <= 250000000 && newList[i].Unusual_Risk_Amount__c <= 100000000){
				// CFO or President up to 250000000 in spend and 100000000 in Risk
				//newList[i].LRB_Final_Partnership_Management__c = [SELECT Id FROM User WHERE Name = 'Scott Gleason'].Id;
			} else {
				// CEO
				//newList[i].LRB_Final_Partnership_Management__c = [SELECT Id FROM User WHERE Name = 'Scott Gleason'].Id;
			}
			*/
			system.debug('FINAL PARTNERSHIP MANAGEMENT: ' + newList[i].LRB_Final_Partnership_Management__c);
		}
	}
	
	private static testmethod void setSignatoryForSoftwarePartnershipManagementTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contract c = new Contract(Name='setSignatoryForSoftwarePartnershipManagementTest', AccountId=a.Id, startDate=Date.today());
        insert c;
        
        c.Lifetime_Contract_Value__c = 1000000;
        c.Unusual_Risk_Amount__c = 1000000;
        update c;
        
        c.Lifetime_Contract_Value__c = 4000000;
        c.Unusual_Risk_Amount__c = 7000000;
        update c;
        
        c.Lifetime_Contract_Value__c = 7000000;
        c.Unusual_Risk_Amount__c = 7000000;
        update c;
        
        c.Lifetime_Contract_Value__c = 70000000;
        c.Unusual_Risk_Amount__c = 40000000;
        update c;
        
        c.Lifetime_Contract_Value__c = 200000000;
        c.Unusual_Risk_Amount__c = 80000000;
        update c;
        
        c.Lifetime_Contract_Value__c = 300000000;
        c.Unusual_Risk_Amount__c = 200000000;
        update c;
	}
	
	private static testmethod void setPhaseCompletionDatesTest(){
		Account a = new Account(Name='Motorola Mobility fake', Tier__c ='1');
        insert a;
        Contact c = new Contact(FirstName='first', LastName='last', AccountId=a.Id);
        insert c;
        Contract c0 = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c0;
        //Contract c1 = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        //insert c1;
        Contract c2 = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c2;
        Contract c3 = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c3;
        Contract c4 = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c4;
        Contract c5 = new Contract(Name='contract', AccountId=a.Id, startDate=Date.today());
        insert c5;
        
        String s = 'string';
		Blob b = Blob.valueOf(s);		
		Attachment att = new Attachment(Name='att.pdf', ParentId = c5.Id, Body=b);
		insert att;
		Attachment att2 = new Attachment(Name='att.pdf', ParentId = c0.Id, Body=b);
		insert att2;
        
        Test.startTest();
        	c0.Contract_Phase__c = 'Term Sheet';
        	//c1.Contract_Phase__c = '2 - LRB Phase';
        	c2.Contract_Phase__c = 'Initial Legal Draft';
        	c3.Contract_Phase__c = 'Redlines/Negotiations';
        	c4.Contract_Phase__c = 'Approvals';
        	c5.Contract_Phase__c = 'Execution and Processing';
        	c5.ContractTerm = 5;
        	c5.EndDate = Date.today();
        	c5.Contract_Status__c = 'Fully Executed';
        	c5.Moto_Signed__c = true;
        	c5.Partner_Signed__c = true;
        	c5.Contract_Type__c = 'fake';
        	c5.Finance_Owner__c = c.Id;
        	c5.Legal_Owner__c = c.Id;
        	c5.Motorola_Entity__c = 'MMI';
        	c5.SW_Procurement_Owner__c = c.Id;
        	
        	update new List<Contract>{c0, c2, c3 ,c4 ,c5};
        	
        	//c0.Contract_Phase__c = '2 - LRB Phase';
        	//update c0;
        	c0.Contract_Phase__c = 'Initial Legal Draft';
        	update c0;
        	c0.Contract_Phase__c = 'Redlines/Negotiations';
        	update c0;
        	c0.Contract_Phase__c = 'Approvals';
        	update c0;
        	c0.Contract_Phase__c = 'Execution and Processing';
        	c0.ContractTerm = 5;
        	c0.EndDate = Date.today();
        	c0.Contract_Status__c = 'Fully Executed';
        	c0.Moto_Signed__c = true;
        	c0.Partner_Signed__c = true;
        	c0.Contract_Type__c = 'fake';
        	c0.Finance_Owner__c = c.Id;
        	c0.Legal_Owner__c = c.Id;
        	c0.Motorola_Entity__c = 'MMI';
        	c0.SW_Procurement_Owner__c = c.Id;
        	update c0;
		Test.stopTest();
	}
}