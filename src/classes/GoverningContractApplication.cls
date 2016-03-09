/*
     * Created by: Jesse
     * Creation date: Unknown
     * Description: <TO-DO>
     * Change history:
     * Date: 1-May-2012
     * Changed by: Rajesh Krishnaiah
     * Changes: Removed Available_For_Use__c from the initialization. The user didn't wanted the apex 
     *          code to control the Available_For_Use__c flag.
     */
public without sharing class GoverningContractApplication {
    
    public static void contractApplicationInsert(Set<ContApplAssoc__c> newGoverningConApps, 
                                Set<Id> relatedContractIds){        
        Map<Id, Contract> contractMap = new Map<Id, Contract>();
        List<Application__c> appListToUpdate = new List<Application__c>();
        
        contractMap.putAll([SELECT Id, Let_Expire__c, StartDate, Contract_Type__c, EndDate, 
                                Contract_Phase__c, Contract_Status__c, Name, ContractNumber, 
                                OwnerId, LRB_Pipeline_ID__c, Decision__c, LRB_Approved_Region__c, 
                                LRB_Approved_Device__c FROM Contract WHERE Id IN : relatedContractIds]);
        
        for(ContApplAssoc__c ca : newGoverningConApps){
            appListToUpdate.add(new Application__c(Id=ca.Application__c, 
                Application_Contract_Governing_End_Date__c = contractMap.get(ca.Contract__c).EndDate,
                Application_Contract_Phase__c = contractMap.get(ca.Contract__c).Contract_Phase__c ,
                Application_Contract_Status__c = contractMap.get(ca.Contract__c).Contract_Status__c, 
                Application_Contract_Name__c = contractMap.get(ca.Contract__c).Name,
                Application_Contract_Number__c = contractMap.get(ca.Contract__c).ContractNumber, 
                Application_Contract_Owner__c = contractMap.get(ca.Contract__c).OwnerId,
                Application_Contract_LRB_Pipeline_ID__c = contractMap.get(ca.Contract__c).LRB_Pipeline_ID__c, 
                Application_Contract_Decision__c = contractMap.get(ca.Contract__c).Decision__c, 
                Application_Contract_LRB_Approved_Region__c = contractMap.get(ca.Contract__c).LRB_Approved_Region__c,
                Application_Contract_LRB_Approved_Device__c = contractMap.get(ca.Contract__c).LRB_Approved_Device__c,
                Application_Contract_Let_Expire__c = contractMap.get(ca.Contract__c).Let_Expire__c,
                Application_Contract_Start_Date__c = contractMap.get(ca.Contract__c).StartDate,
                Application_Contract_Type__c = contractMap.get(ca.Contract__c).Contract_Type__c));
                //,Available_For_Use__c = true));           
        }
        
        update appListToUpdate;
    }
    
    public static void contractApplicationUpdate(Set<Id> appIdsWithChangedGoverningContract){
        List<Application__c> appListToUpdate = new List<Application__c>();
        
        List<ContApplAssoc__c> contractAppsList = [SELECT Id, Contract__r.StartDate, Contract__r.Contract_Type__c, 
            Governing_End_Date__c, Application__c, Contract__c, Contract__r.EndDate, 
            Contract__r.Contract_Phase__c, Contract__r.Contract_Status__c, 
            Contract__r.Name, Contract__r.ContractNumber, Contract__r.OwnerId, 
            Contract__r.LRB_Pipeline_ID__c, Contract__r.Decision__c, 
            Contract__r.LRB_Approved_Region__c, Contract__r.LRB_Approved_Device__c, 
            Contract__r.Let_Expire__c FROM ContApplAssoc__c 
            WHERE Application__c IN : appIdsWithChangedGoverningContract 
            AND Governing_End_Date__c = true];
        
        Boolean foundGoverningContract = false;
        for(Id appId : appIdsWithChangedGoverningContract){
            foundGoverningContract = false;
            for(ContApplAssoc__c ca : contractAppsList){
                if(appId == ca.Application__c){
                    appListToUpdate.add(new Application__c(Id=appId,
                        Application_Contract_Governing_End_Date__c = ca.Contract__r.EndDate,
                        Application_Contract_Phase__c = ca.Contract__r.Contract_Phase__c ,
                        Application_Contract_Status__c = ca.Contract__r.Contract_Status__c, 
                        Application_Contract_Name__c = ca.Contract__r.Name,
                        Application_Contract_Number__c = ca.Contract__r.ContractNumber, 
                        Application_Contract_Owner__c = ca.Contract__r.OwnerId,
                        Application_Contract_LRB_Pipeline_ID__c = ca.Contract__r.LRB_Pipeline_ID__c, 
                        Application_Contract_Decision__c = ca.Contract__r.Decision__c, 
                        Application_Contract_LRB_Approved_Region__c = ca.Contract__r.LRB_Approved_Region__c,
                        Application_Contract_LRB_Approved_Device__c = ca.Contract__r.LRB_Approved_Device__c,
                        Application_Contract_Let_Expire__c = ca.Contract__r.Let_Expire__c,
                        Application_Contract_Start_Date__c = ca.Contract__r.StartDate,
                        Application_Contract_Type__c = ca.Contract__r.Contract_Type__c));
                        //,Available_For_Use__c = true));
                    
                    
                    foundGoverningContract = true;                  
                }
            }
            
            if(!foundGoverningContract && contractAppsList.size() >= 0){
                appListToUpdate.add(new Application__c(Id=appId,
                    Application_Contract_Governing_End_Date__c = null,
                    Application_Contract_Phase__c = null ,
                    Application_Contract_Status__c = null, 
                    Application_Contract_Name__c = null,
                    Application_Contract_Number__c = null, 
                    Application_Contract_Owner__c = null,
                    Application_Contract_LRB_Pipeline_ID__c = null, 
                    Application_Contract_Decision__c = null, 
                    Application_Contract_LRB_Approved_Region__c = null,
                    Application_Contract_LRB_Approved_Device__c = null,
                    Application_Contract_Let_Expire__c = false,
                    Application_Contract_Start_Date__c = null,
                    Application_Contract_Type__c = null));
                    //,Available_For_Use__c = false));             
            }
        }
        
        if(!appListToUpdate.isEmpty()){
            update appListToUpdate;
        }
    }
}