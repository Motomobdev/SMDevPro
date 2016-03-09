public with sharing class contractApprovals {
	
	public List<cRequestedDate> requestsList {get; set;}
	public List<Contract> sopContracts {get; set;}
	public Boolean showSidebar {get; set;}
    public Boolean showHeader {get; set;}
	public Boolean showFullScreenLink {get; set;}
	public String contractIdChosen {get; set;}
	public String accountIdChosen {get; set;}
	public String urlChosen {get; set;}
	
	public boolean displayPopup {get; set;}

	public contractApprovals(){
        requestsList = new List<cRequestedDate>();
        sopContracts = new List<Contract>();
        
        showSidebar = false;
        showHeader = false;
		showFullScreenLink = true;
		
		displayPopup = false;
		
		fillApprovalList();
	}
	
	private void fillApprovalList(){
		List<cRequestedDate> tempList;
		
		List<Contract> listofContracts;
		
		if(UserInfo.getLastName() == 'Quicker' || UserInfo.getLastName() == 'Rowe' || UserInfo.getLastName() == 'Ahluwalia'){
			listofContracts = [SELECT Id, ContractNumber, Name, Account.Id, Account.Name, Account.Owner.Name, Updates_since_LB_Initial_Deal_Review__c, Is_there_Royalty__c, Rev_Share__c, Is_there_Prepay__c, Is_there_Minimum_Guarantee__c, Any_Unusual_Risks__c, Requested_LRB_Initial_Deal_Present_Date__c, LRB_Initial_Deal_Decision__c, Requested_LRB_Final_Deal_Present_Date__c, LRB_Final_Deal_Review_Decision__c, SOP_E_1_Approval_Status__c, SOP_Approval_Submission_Date__c, Business_Model__c FROM Contract WHERE (Requested_LRB_Initial_Deal_Present_Date__c != null AND (LRB_Initial_Deal_Decision__c = '' OR LRB_Initial_Deal_Decision__c = null)) OR (Requested_LRB_Final_Deal_Present_Date__c != null AND (LRB_Final_Deal_Review_Decision__c = '' OR LRB_Final_Deal_Review_Decision__c = null)) OR (SOP_E_1_Approval_Status__c = 'In Progress') ORDER BY ContractNumber ASC];
		} else {
			listofContracts = [SELECT Id, ContractNumber, Name, Account.Id, Account.Name, Account.Owner.Name, Updates_since_LB_Initial_Deal_Review__c, Is_there_Royalty__c, Rev_Share__c, Is_there_Prepay__c, Is_there_Minimum_Guarantee__c, Any_Unusual_Risks__c, Requested_LRB_Initial_Deal_Present_Date__c, LRB_Initial_Deal_Decision__c, Requested_LRB_Final_Deal_Present_Date__c, LRB_Final_Deal_Review_Decision__c, SOP_E_1_Approval_Status__c, SOP_Approval_Submission_Date__c, Business_Model__c FROM Contract WHERE Partner_Manager__c =: UserInfo.getUserId() OR LRB_Initial_Finance_Approver__c =: UserInfo.getUserId() OR LRB_Initial_Legal_Approver__c =: UserInfo.getUserId() OR LRB_Initial_Partnership_Management__c =: UserInfo.getUserId() OR Business_Owner__c =: UserInfo.getUserId() OR Business_Unit_Finance_Approver__c =: UserInfo.getUserId() OR Business_Unit_VP_Officer__c =: UserInfo.getUserId() OR LRB_Final_Finance_Approver__c =: UserInfo.getUserId() OR LRB_Final_Legal_Approver__c =: UserInfo.getUserId() OR LRB_Final_Partnership_Management__c =: UserInfo.getUserId() ORDER BY ContractNumber ASC];
		}
		
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
			
        	//contractList.add(new cContractApproval(c.Id, c.ContractNumber, c.Name, c.Owner.Name, c.Initial_Final_or_SOP_E_1__c, c.Account.Id, c.Account.Name, c.Requested_LRB_Initial_Deal_Present_Date__c, c.Requested_LRB_Final_Deal_Present_Date__c));
            /*if(c.Initial_Final_or_SOP_E_1__c == 'Initial'){
                contractList.add(new cContractApproval(c.Id, c.ContractNumber, c.Name, c.Initial_Final_or_SOP_E_1__c, c.Account.Id, c.Account.Name, c.Account.Owner.Name, c.Requested_LRB_Initial_Deal_Present_Date__c, c.Requested_LRB_Final_Deal_Present_Date__c));
            } else if(c.Initial_Final_or_SOP_E_1__c == 'Final'){
                contractList.add(new cContractApproval(c.Id, c.ContractNumber, c.Name, c.Initial_Final_or_SOP_E_1__c, c.Account.Id, c.Account.Name, c.Account.Owner.Name, c.Requested_LRB_Initial_Deal_Present_Date__c, c.Requested_LRB_Final_Deal_Present_Date__c));
            } else if(c.Initial_Final_or_SOP_E_1__c == 'SOP E-1'){
                contractList.add(new cContractApproval(c.Id, c.ContractNumber, c.Name, c.Initial_Final_or_SOP_E_1__c, c.Account.Id, c.Account.Name, c.Account.Owner.Name, c.Requested_LRB_Initial_Deal_Present_Date__c, c.Requested_LRB_Final_Deal_Present_Date__c));
            } */
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
	
	public PageReference fullScreen(){
        showHeader = true;
        showSidebar = true;
        showFullScreenLink = false;
          
        PageReference pr = ApexPages.currentPage();
        //PageReference pr = new PageReference('/apex/DeviceApplicationApprovals'); 
        //pr.setRedirect(true);
        return pr; 
    }
    
    public void closePopup() {
        displayPopup = false;
    }
 
    public void showPopup() {
        displayPopup = true;
    }
	
	/*public Boolean getshowInitialList(){
        if(!initialContractList.isEmpty()){
            return true;
        }
        return false;
    }
    
    public Boolean getshowFinalList(){
        if(!finalContractList.isEmpty()){
            return true;
        }
        return false;
    } 
    
    public Boolean getshowSOPList(){
        if(!sopContractList.isEmpty()){
            return true;
        }
        return false;
    }
    */
    
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
	
    /*public class cContractApproval {
        public Id contractId {get; set;}
        public String contractNumber {get; set;}
        public String contractName {get; set;}
        public String contractOwner {get; set;}
        public String approvalType {get; set;}
        public Id accountId {get; set;}
        public String accountName {get; set;}
        
        public Date requestedInitialDate {get; set;}
        public Date requestedFinalDate {get; set;}
        
        public cContractApproval(Id contractId, String contractNumber, String contractName, String contractOwner, String approvalType, Id accountId, String accountName, Date requestedInitialDate, Date requestedFinalDate){
            this.contractId = contractId;
            this.contractNumber = contractNumber;
            this.contractName = contractName;
            this.contractOwner = contractOwner;
            this.approvalType = approvalType;
            this.accountId = accountId;
            this.accountName = accountName;
            this.requestedInitialDate = requestedInitialDate;
            this.requestedFinalDate = requestedFinalDate;
        }
    }*/

/*
<!-- <apex:column headerValue="Generate Slides">
		                    <apex:commandButton action="{!generateSlides}" value="Generate" id="theButton">
		                        <apex:param name="contractId" value="{!a.contractId}"/>
		                        <apex:param name="accountId" value="{!a.accountId}"/>
		                        -->
		                        <!--assignTo="{!generateSlidesId}"  assignTo="{!generateSlidesId2}" -->
		                 <!--     </apex:commandButton>
		                </apex:column>
		                 -->*/


}