/*
 * Called by Contract.trigger
*/
public without sharing class Contract_Update {
    public static void beforeUpdate(List<Contract> newContracts, List<Contract> oldContracts){
        Set<Id> contractsSetToFullyExecuted = new Set<Id>();
        List<Contract> contractsWithUpdatedValueOrRiskAmounts = new List<Contract>();
        
        Map<Id, List<Attachment>> parentIdListMap = new Map<Id, List<Attachment>>(); 
        for(Attachment at : [SELECT Id, ParentId, Name FROM Attachment WHERE ParentId IN : newContracts]){
            List<Attachment> tempList = parentIdListMap.get(at.ParentId);
            if(tempList == null){
                tempList = new List<Attachment>{at};
            } else {
                tempList.add(at);
            }
            parentIdListMap.put(at.ParentId, tempList);
        }
        
        for(Integer i=0; i<newContracts.size(); i++){
            // validate contract status based on contract pdf attachment
            if(newContracts[i].Contract_Status__c != oldContracts[i].Contract_Status__c && newContracts[i].Contract_Status__c=='Fully Executed' && (newContracts[i].BLUR_Contract__c != 'Yes' && newContracts[i].BLUR_Type__c != 'Feed')){
                if(parentIdListMap.get(newContracts[i].Id) == null){
                    // This Contract has no attachments at all
                    newContracts[i].addError('This Contract cannot be set to Fully Executed because there has been no copy of the contract attached. Attached Contracts must be in .pdf format to be detected.');
                } else {
                    Boolean hasOnePDFAttachment = false;
                    for(Attachment a : parentIdListMap.get(newContracts[i].Id)){
                        if(a.Name.contains('.pdf') || a.Name.contains('.PDF')){
                            hasOnePDFAttachment = true;
                        }
                    }
                    
                    if(!hasOnePDFAttachment){
                        newContracts[i].addError('This Contract cannot be set to Fully Executed because there has been no copy of the contract attached. Attached Contracts must be in .pdf format to be detected.');
                    }
                }
            }           
    
            // Use Finance Approval Type selection to find User for Business Unit Finance Approver
            if(newContracts[i].Business_Unit_Type__c != oldContracts[i].Business_Unit_Type__c){
                if(newContracts[i].Business_Unit_Type__c != null){
                    Integer startOfName = newContracts[i].Business_Unit_Type__c.indexOf(' - ') + 3;
                    String name = newContracts[i].Business_Unit_Type__c.substring(startOfName);
                    try{
                        newContracts[i].Business_Unit_Finance_Approver__c = [SELECT Id FROM User WHERE Name =: name].Id;
                    } catch (System.QueryException e){  }
                } else {
                    newContracts[i].Business_Unit_Finance_Approver__c = null;
                }
            }
            
            // if spend or Unusual Risk have changed decide who should be Signatory for Software Partnership Managment step in SOP
            if((newContracts[i].Lifetime_Contract_Value__c != oldContracts[i].Lifetime_Contract_Value__c) || (newContracts[i].Unusual_Risk_Amount__c != oldContracts[i].Unusual_Risk_Amount__c)){
                contractsWithUpdatedValueOrRiskAmounts.add(newContracts[i]);
            }                       
        }
        
        if(!contractsWithUpdatedValueOrRiskAmounts.isEmpty()){ ContractMethods.setSignatoryForSoftwarePartnershipManagement(contractsWithUpdatedValueOrRiskAmounts); }
        
        ContractMethods.setPhaseCompletionDates(newContracts, oldContracts);
    }
    
    public static void afterUpdate(List<Contract> newContracts, List<Contract> oldContracts)
    {
        Set<Id> contractIdsToCalculatePercentageOnDevice = new Set<Id>();
        List<Contract> updatedContractsForAccountContractList = new List<Contract>();
        List<Contract> contractsToCreateZuoraOpportunity = new List<Contract>();
        
        for(Integer i=0; i<newContracts.size(); i++)
        {
            if(newContracts[i].Contract_Status__c != oldContracts[i].Contract_Status__c && (newContracts[i].Contract_Status__c=='Fully Executed' || newContracts[i].Contract_Status__c!='Fully Executed'))
            {
                contractIdsToCalculatePercentageOnDevice.add(newContracts[i].Id);
            }
            
            if(newContracts[i].Contract_Status__c != oldContracts[i].Contract_Status__c || newContracts[i].Contract_Type__c != oldContracts[i].Contract_Type__c)
            {
                updatedContractsForAccountContractList.add(newContracts[i]);
            }
            
            /********************************************************************
             Added by Neel on 31/Oct/2013. Requested by Brian Chiang
             VHD # 
             
            ********************************************************************/
            if(newContracts[i].Contract_Phase__c != oldContracts[i].Contract_Phase__c && newContracts[i].Contract_Phase__c == 'Execution and Processing')
            {
            	contractsToCreateZuoraOpportunity.add(newContracts[i]);
            }
        }

        if(!contractIdsToCalculatePercentageOnDevice.isEmpty()) // calculate percentage of BOM/SD executed apps
        { 
            DevAppsOnBomSDWithExecutedContracts.calculatePercentOfExecutedContractsOnBomOrSDCardFromContractId(contractIdsToCalculatePercentageOnDevice);
        }
        
        if(!updatedContractsForAccountContractList.isEmpty())
        {
            AccountMethods.collectContractInformationIntoTextFieldForLRBSlides(updatedContractsForAccountContractList);
        }
        
        if(!contractsToCreateZuoraOpportunity.isEmpty())
        {
        	OpportunityMethods.createZuoraOpportunity(contractsToCreateZuoraOpportunity);
        }
    }
    
    public static testmethod void Contract_UpdateTest(){
        Account a; 
        Contact con;    
        //try{
        //    a = [SELECT Id FROM Account WHERE Name LIKE 'Motorola Mobility, Inc%'];
        //    con = [SELECT Id FROM Contact WHERE AccountId =: a.Id LIMIT 1];
        //}
        //catch(System.QueryException e){
            a = new Account(Name='Motorola Mobility, LLC', Tier__c = '1');
            insert a;
            con = new Contact(lastName='contact', Account=a);
            insert con;
        //}
        Contract c = new Contract(Name='Contract', AccountId=a.Id, StartDate=Date.today());
        insert c;
        String s = 'string';
        Blob b = Blob.valueOf(s);
        
        Attachment att = new Attachment(Name='att', ParentId = c.Id, Body=b);
        Attachment att2 = new Attachment(Name='att.pdf', ParentId = c.Id, Body=b);
        
        
        Test.startTest();
            c.Contract_Status__c = 'Fully Executed';
            c.Contract_Phase__c = '6 - Fully Executed Contract Phase';
            c.EndDate = Date.today().addDays(1);
            c.Contract_Type__c = 'ADA - Application Distribution Agreement';
            c.Moto_Signed__c = true;
            c.Partner_Signed__c = true;
            c.Motorola_Entity__c = 'Motorola Mobility Inc';
            c.ContractTerm = 1;
            c.Finance_Owner__c = con.Id;
            c.Legal_Owner__c = con.Id;
            c.SW_Procurement_Owner__c = con.Id;
            
            c.Business_Unit_Type__c = 'Other - Lana Blackburn';
            c.Lifetime_Contract_Value__c = 1000000;
            
            try{
                update c;
            } catch(System.DMLException e){
                System.assert(e.getMessage().contains('This Contract cannot be set to Fully Executed because there has been no copy of the contract attached.'));
            }
            
            insert att;
            try{
                update c;
            } catch(System.DMLException e){
                System.assert(e.getMessage().contains('This Contract cannot be set to Fully Executed because there has been no copy of the contract attached.'));
            }
            
            insert att2;
            try{
                update c;
            } catch(System.DMLException e){
                
            }
            
            try{
            c.Business_Unit_Type__c = 'Fake - Perry Como';
            update c;
            } catch(System.DMLException e){
            }
            
            try{
            c.Business_Unit_Type__c = null;
            update c;
            } catch(System.DMLException e){
            }
        Test.stopTest();
    }
}