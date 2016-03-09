public with sharing class contractApprovalTab {
	
	public List<cRequestedDate> requestsList {get; set;}
	public List<Contract> sopContracts {get; set;}
	public String contractIdChosen {get; set;}
	public String accountIdChosen {get; set;}
	public String urlChosen {get; set;}

	public contractApprovalTab(){
        requestsList = new List<cRequestedDate>();
        sopContracts = new List<Contract>();
		
		fillApprovalList();
	}
	
	private void fillApprovalList(){
		List<cRequestedDate> tempList;
		
		List<Contract> listofContracts;

		listofContracts = [SELECT Id, ContractNumber, Name, Account.Id, Account.Name, Account.Owner.Name, Updates_since_LB_Initial_Deal_Review__c, Is_there_Royalty__c, Rev_Share__c, Is_there_Prepay__c, Is_there_Minimum_Guarantee__c, Any_Unusual_Risks__c, Requested_LRB_Initial_Deal_Present_Date__c, LRB_Initial_Deal_Decision__c, Requested_LRB_Final_Deal_Present_Date__c, LRB_Final_Deal_Review_Decision__c, SOP_E_1_Approval_Status__c, SOP_Approval_Submission_Date__c, Business_Model__c FROM Contract WHERE (Requested_LRB_Initial_Deal_Present_Date__c != null AND (LRB_Initial_Deal_Decision__c = '' OR LRB_Initial_Deal_Decision__c = null)) OR (Requested_LRB_Final_Deal_Present_Date__c != null AND (LRB_Final_Deal_Review_Decision__c = '' OR LRB_Final_Deal_Review_Decision__c = null)) OR (SOP_E_1_Approval_Status__c = 'In Progress') ORDER BY ContractNumber ASC];
		
		// need to have a version for people line Dan Robo who need to see all contract approvals
		for(Contract c : listofContracts){		
			if(ContractMethods.isContractInInitialLRBApproval(c)){
				Boolean foundExistingList = false;
				for(cRequestedDate rd : requestsList){
					if(c.Requested_LRB_Initial_Deal_Present_Date__c == rd.requestedDate){
						foundExistingList = true;
						rd.contractApprovals.add(new cContractApproval(c, 'Initial'));
					}					
				}
				
				if(!foundExistingList){
					requestsList.add(new cRequestedDate(c.Requested_LRB_Initial_Deal_Present_Date__c, new List<cContractApproval>{new cContractApproval(c, 'Initial')}));
				}
			}
			
			if(ContractMethods.isContractInFinalLRBApproval(c)){
				Boolean foundExistingList = false;
				for(cRequestedDate rd : requestsList){
					if(c.Requested_LRB_Final_Deal_Present_Date__c == rd.requestedDate){
						foundExistingList = true;
						rd.contractApprovals.add(new cContractApproval(c, 'Final'));
					}					
				}
				
				if(!foundExistingList){
					requestsList.add(new cRequestedDate(c.Requested_LRB_Final_Deal_Present_Date__c, new List<cContractApproval>{new cContractApproval(c, 'Final')}));
				}
			}
			
			if(ContractMethods.isContractInSOPE1Approval(c)){
				sopContracts.add(c);
			}

        }
        
        //sortRequestsListByRequestedDate();
	}
	
	public PageReference generateSlides(){
		PageReference pr = new PageReference('/apex/loop__looplus?eid=' + contractIdChosen + '&accountId=' + accountIdChosen);
		//pr.setRedirect(true);
		return pr;
		// + '&sessionId=' + $Api.Session_ID
	}
	
	public void generateSlidesURL(){
		urlChosen = '/apex/loop__looplus?eid=' + contractIdChosen + '&accountId=' + accountIdChosen;
		// + '&sessionId=' + $Api.Session_ID
	}
	
    public void sortRequestsListByRequestedDate(){
    	List<cRequestedDate> newList = requestsList;
    	requestsList.clear();
    	cRequestedDate earliestDate;
    	Integer indexOfEarliestDate;
    	
    	while(newList.size() != 0){
    		earliestDate = newList[0];
    		indexOfEarliestDate=0;
	    	for(Integer i=0; i<newList.size(); i++){
	    		if(earliestDate.requestedDate > newList[i].requestedDate){
	    			earliestDate = newList[i];
	    			indexOfEarliestDate = i;
	    		}
	    	}
	    	
	    	requestsList.add(earliestDate);
	    	newList.remove(indexOfEarliestDate);
    	}    	
    }
    
    public Boolean getshowSOPTable(){
    	if(!sopContracts.isEmpty()){
    		return true;
    	}
    	return false;
    }
    
    public Boolean getNoContractsFound(){
    	if(sopContracts.isEmpty() && requestsList.isEmpty()){
    		return true;
    	}
    	return false;
    }
    
    public class cSOPContracts {
    	public Date submittedDate {get; set;}
    	public Contract contract {get; set;}
    	
    	public cSOPContracts(Date d, Contract c){
    		submittedDate = d;
    		contract = c;
    	}
    }
    
    public class cRequestedDate {
    	public Date requestedDate {get; set;}
    	public List<cContractApproval> contractApprovals {get; set;}
    	
    	public cRequestedDate(Date d, List<cContractApproval> contracts){
    		requestedDate = d;
    		contractApprovals = contracts;
    	}
    }
    
    public class cContractApproval {
    	public Contract contract {get; set;}
    	public String approvalType {get; set;}
    	
    	public cContractApproval(Contract c, String atype){
    		contract = c;
    		approvalType = atype;
    	}
    }
}