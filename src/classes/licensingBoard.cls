public class licensingBoard {
    
    public List<cContract> allContracts {get; set;}
    
    private String sortDirection = 'ASC';
    private String sortExp = 'name';
    
    public PageReference redirect(){
        PageReference pr = new PageReference('/800?fcf=00BQ0000000NkHK');
        pr.setRedirect(true);
        return pr;
    }

    public String sortExpression {
        get{
            return sortExp;
        }
     
        set{
        //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }

    public String getSortDirection() {
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    public void setSortDirection(String value){  
        sortDirection = value;
    }
    
    public licensingBoard(){
        allContracts = new List<cContract>();
        
        List<Contract> initialContractsUnsorted = new List<Contract>();
        List<Contract> finalContractsUnsorted = new List<Contract>();
        
        List<Contract> initialContracts = new List<Contract>();
        List<Contract> finalContracts = new List<Contract>();
        
        for(Contract c : [SELECT Id, ContractNumber, Account.Owner.Name, Requested_LRB_Initial_Deal_Present_Date__c, Requested_LRB_Final_Deal_Present_Date__c, LRB_Initial_Deal_Decision__c, LRB_Final_Deal_Review_Decision__c  FROM Contract WHERE Requested_LRB_Initial_Deal_Present_Date__c != null AND LRB_Final_Deal_Review_Decision__c != 'Pass']){
            if(c.Requested_LRB_Initial_Deal_Present_Date__c != null && c.Requested_LRB_Final_Deal_Present_Date__c == null){
                initialContractsUnsorted.add(c);
            } else if(c.Requested_LRB_Final_Deal_Present_Date__c != null && (c.LRB_Initial_Deal_Decision__c == 'Pass' || c.LRB_Initial_Deal_Decision__c == 'Conditional Approval')){
                finalContractsUnsorted.add(c);
            }
        }
        
        
        
        if(!initialContractsUnsorted.isEmpty()){
            Date earliestDate = null;
            Integer earliestDateIndex;
            do{
                earliestDate = null;
                for(Integer i=0; i < initialContractsUnsorted.size(); i++){
                    if(earliestDate == null){
                        system.debug('ENTER FIRST INITIAL CONTRACT AS EARLIEST DATE');
                        earliestDate = initialContractsUnsorted[i].Requested_LRB_Initial_Deal_Present_Date__c;
                        earliestDateIndex = i;
                    } else if(earliestDate >= initialContractsUnsorted[i].Requested_LRB_Initial_Deal_Present_Date__c){
                        system.debug('EARLIEST DATE IS >= Requested INitial Date: ' + earliestDate + ' >= ' +  initialContractsUnsorted[i].Requested_LRB_Initial_Deal_Present_Date__c);
                        earliestDate = initialContractsUnsorted[i].Requested_LRB_Initial_Deal_Present_Date__c;
                        earliestDateIndex = i;
                    }
                }

                system.debug('INDEX TO REMOVE: ' + earliestDateIndex);
                
                initialContracts.add(initialContractsUnsorted.remove(earliestDateIndex));
                
            } while(!initialContractsUnsorted.isEmpty());
        }
        
        
        if(!finalContractsUnsorted.isEmpty()){
            Date earliestDate = null;
            Integer earliestDateIndex;        
            do{      
                for(Integer i=0; i < finalContractsUnsorted.size(); i++){
                    if(earliestDate == null){
                        earliestDate = finalContractsUnsorted[i].Requested_LRB_Final_Deal_Present_Date__c;
                        earliestDateIndex = i;
                    } else if(earliestDate >= finalContractsUnsorted[i].Requested_LRB_Final_Deal_Present_Date__c){
                        earliestDate = finalContractsUnsorted[i].Requested_LRB_Final_Deal_Present_Date__c;
                        earliestDateIndex = i;
                    }
                }
                
                finalContracts.add(finalContractsUnsorted.remove(earliestDateIndex));
                
            } while(!finalContractsUnsorted.isEmpty());
        }
        
        for(Contract initial : initialContracts){
            if(!finalContracts.isEmpty()){
                for(Integer k=0; k<finalContracts.size(); k++){
                    if(initial.Requested_LRB_Initial_Deal_Present_Date__c > finalContracts[k].Requested_LRB_Final_Deal_Present_Date__c){
                        allContracts.add(new cContract('Final', finalContracts[k].ContractNumber, finalContracts[k].Id, finalContracts[k].Account.owner.Name, finalContracts[k].Requested_LRB_Final_Deal_Present_Date__c));
                        finalContracts.remove(k);
                    } else {
                        allContracts.add(new cContract('Initial', initial.ContractNumber, initial.Id, initial.Account.owner.Name, initial.Requested_LRB_Initial_Deal_Present_Date__c));
                    }
                }
            } else {
                allContracts.add(new cContract('Initial', initial.ContractNumber, initial.Id, initial.Account.owner.Name, initial.Requested_LRB_Initial_Deal_Present_Date__c));
            }
        }
    }
    
    
    public class cContract{
        public String reviewType {get; set;}
        public String contractNumber {get; set;}
        public Id contractId {get; set;}
        public String aOwner {get; set;}
        public Date requestedDate {get; set;}
        
        public cContract(String reviewType , String contractNum, Id cId, String aOwner, Date rDate){
            this.reviewType = reviewType;
            this.contractNumber = contractNum;
            this.contractId = cId;
            this.aOwner = aOwner;
            this.requestedDate = rDate;
        }
    }    
}