/***************************
// Created By: Gram Bischof
// Last Modified: 6/7/2014
// Description:
// Controller class for 
// CreateProjectSpend.page and
// ProjectSpendSummary.page
//
// Test Class:
// TestCreateProjectSpendController.cls
****************************/

public class CreateProjectSpendController {

    public Project_Spend__c primaryRecord {get;set;}
    public String addedMilestone {get;set;}
    public String MMID {get;set;}
    public String TypeName {get;set;} 
    public Boolean verified {get;set;}
    public Boolean nonSoftware {get;set;}
    public List<Spend_Milestone__c> milestones {get;set;}
    private Motorola_Core_Directory__c MMIDusr;
    
    public static List<JIRA_Project__c> SWProjects = [Select id,Name From JIRA_Project__c];

    public static List<JIRA_Project__c> getSWProjects(){
        return SWProjects;
    }
    
    // Non-standard Controller constructor for CreateProjectSpend
    public CreateProjectSpendController(){
        primaryRecord = new Project_Spend__c();
        milestones = new List<Spend_Milestone__c>();
        verified = false;
        TypeName = ApexPages.CurrentPage().getParameters().get('Type');
        if(TypeName == null || TypeName.trim() == ''){
            TypeName = 'SW';
            nonSoftware = false;
        } 
        setUpType();
        
        MMID = ApexPages.CurrentPage().getParameters().get('MMID');
        if(MMID != null) verified = validateMMID(MMID);
        
    }
    
    // Standard Controller extension constructor for ProjectSpendSummary
    public CreateProjectSpendController(ApexPages.StandardController stdController){
        primaryRecord = (Project_Spend__c)stdController.getRecord();
        milestones = new List<Spend_Milestone__c>();
        verified = false;
        TypeName = ApexPages.CurrentPage().getParameters().get('Type');
        if(TypeName == null || TypeName.trim() == ''){
            TypeName = 'SW';
            nonSoftware = false;
        } 
        setUpType();
        
        if(primaryRecord.Requester__c != null) MMIDUsr = [Select id,MMID__c From Motorola_Core_Directory__c Where id = :primaryRecord.Requester__c];
        if(MMIDUsr != null) MMID = MMIDUsr.MMID__c;
        
    }
    
    public void validateMMIDInput(){
        verified = validateMMID(MMID);
    } 
    
    public PageReference updatePrimaryRecord(){
        try{
            update primaryRecord;
            return new PageReference('/ProjectSpend/ProjectSpendSummary?id='+primaryRecord.id+'&Type='+TypeName);
        }
        catch(Exception e){
          
        }
        
        return null;
    }
    
    // Copied from ContractRequestFormCtr.cls
    public Boolean validateMMID(String MMIDInput) 
    {
        try
        {
            MMIDInput = MMIDInput.toUpperCase();
                
            Motorola_Core_Directory__c[] usr = [SELECT Id,
                                                       Name,
                                                       MMID__c,
                                                       MobilePhone__c,
                                                       WorkPhone__c,
                                                       OrgLevel1__c, 
                                                       OrgLevel2__c, 
                                                       OrgLevel3__c
                                                FROM   Motorola_Core_Directory__c
                                                WHERE  MMID__c = :MMIDInput AND
                                                       DirectoryStatus__c = 'A'];
            if(usr.size() == 1)
            { 
                MMIDusr = usr.get(0);
                primaryRecord.Requester__c = MMIDusr.id;
                return true;
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'MMID is invalid or inactive.'));
            }
            
        }
        catch(Exception ex)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()); 
            ApexPages.addMessage(msg);
        }
        
        return false;
    }
    
    
    public PageReference createRecord(){
        try{
            insert primaryRecord;
            for(Spend_Milestone__c ms: milestones){
                ms.Project_Spend__c = primaryRecord.id;
            }
            if(milestones.size() > 0 )insert milestones;
        }
        catch(Exception e){

        }
        
        if(!ApexPages.hasMessages()) return new PageReference('/ProjectSpend/ProjectSpendSummary?id='+primaryRecord.id+'&Type='+TypeName);
        return null;
    }
    
    public void updateMilstoneList(){
        try{
            milestones.addAll((List<Spend_Milestone__c>)JSON.deserialize(addedMilestone, List<Spend_Milestone__c>.class));
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()); 
            ApexPages.addMessage(msg);
        }
    }
    
    public PageReference insertMilestones(){
        try{
            milestones = (List<Spend_Milestone__c>)JSON.deserialize(addedMilestone, List<Spend_Milestone__c>.class);
            if(milestones.size() == 0 ) return null;
            insert milestones;
        }
        catch(Exception e){
        }
        PageReference p = ApexPages.currentPage();
        return p.setRedirect(true);
        
    }
    
    public PageReference editMilestones(){
        milestones = (List<Spend_Milestone__c>)JSON.deserialize(addedMilestone, List<Spend_Milestone__c>.class);
        if(milestones.size() == 0 ) return null;
        try{
            update milestones;
        }
        catch(Exception e){
        }
        PageReference p = ApexPages.currentPage();
        return p.setRedirect(true);
    }
    
     public PageReference removeMilestones(){
        milestones = (List<Spend_Milestone__c>)JSON.deserialize(addedMilestone, List<Spend_Milestone__c>.class);
        if(milestones.size() == 0 ) return null;
        try{
            delete milestones;
        }
        catch(Exception e){
        }
        PageReference p = ApexPages.currentPage();
        return p.setRedirect(true);
     }
    
    public List<Schema.FieldSetMember> getFieldSet(){
        return SObjectType.Spend_Milestone__c.FieldSets.CreateSpend.getFields();
    }
    
    public String getFieldJSON(){
        return JSON.serialize(SObjectType.Spend_Milestone__c.FieldSets.CreateSpend.getFields());
    }
    
    public List<Spend_Milestone__c> getExistingMilestones(){
        if(milestones.size() == 0) milestones = [Select id,Project_Spend__c,Name,Description__c,Start_Date__c,End_Date__c,Acceptance_Criteria__c From Spend_Milestone__c Where Project_Spend__c = :primaryRecord.id];
        return milestones;
    }
    
    public void setUpType(){
      Map<String,RecordType> nameToRecordTypeMap = new Map<String,RecordType>();
      for(RecordType rt: [Select id,Name From RecordType Where SobjectType = 'Project_Spend__c']) nameToRecordTypeMap.put(rt.Name,rt);
      if(nameToRecordTypeMap.containsKey(TypeName)){
            primaryRecord.RecordTypeId = nameToRecordTypeMap.get(TypeName).Id;
      } 
      if(TypeName != 'SW') nonSoftware = true;  
    
    }

}