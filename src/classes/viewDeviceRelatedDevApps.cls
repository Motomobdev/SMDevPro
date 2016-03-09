/*
 * Test code for this class is found in deviceApplicationApprovalsTest
 */
 /*
 Last Modified: 30/Aug/2012 | Neel Desai | for VHD ticket #62679
 */

public with sharing class viewDeviceRelatedDevApps 
{
    public List<cDevApp> finalList {get; set;}
    public String recordId {get; set;}
    public String recordName {get; set;}
    public Boolean isDevice {get; set;}
    
    Map<Id, DeviceApplicationAssoc__c> devAppIdMap = new Map<Id, DeviceApplicationAssoc__c>();
    List<DeviceApplicationAssoc__c> devApps;
    DeviceApplicationApprovalProcess daap;
    Map<Id, ProcessInstance> piMap = new Map<Id, ProcessInstance>();

    public viewDeviceRelatedDevApps(ApexPages.StandardSetController controller) 
    {
        finalList = new List<cDevApp>();
        recordId = ApexPages.currentPage().getParameters().get('Id');

        getListOfRelatedDevApps();
               
        system.debug('THIS IS devApps size: ' + devApps.size());
                
        for(ProcessInstance pi : [SELECT id, Status, TargetObjectId, (SELECT Id, StepStatus, Comments, ActorId, IsPending, CreatedDate FROM StepsAndWorkitems WHERE IsPending=true AND StepStatus='Pending') FROM ProcessInstance WHERE Status='Pending' AND TargetObjectId IN : devAppIdMap.keySet()]){
            system.debug('THIS IS PI: ' + pi.status + ', ' + pi.StepsAndWorkitems);
            piMap.put(pi.TargetObjectId, pi);
        }
        
        fillListOfcDevApps();

    }
    
    public void getListOfRelatedDevApps()
    {
        transient Map<String,String> keyPrefixMap = SystemMethods.getPrefixNameObjectMap();
        
        if(keyPrefixMap.get(recordId.subString(0,3)) == 'Device__c')
        {
            isDevice = true;
            devApps = [SELECT Id, Name, Device__r.Name, Application__r.Id, Application__r.Name, AcctOwner__r.Name, Approval_Status__c, CreatedById, LRB_Approver__r.Name, DTS_Approver__r.Name, Application_Manager_Selection_Approver__r.Name, Finance_Approver__r.Name, X3rd_Party_Approval_Required__c, X3rd_Party_Approval_Status__c FROM DeviceApplicationAssoc__c WHERE Device__c =: recordId AND (Include_in_BOM__c = true OR Include_on_SD_Card__c = true)];
            if(devApps.size() > 0)
            {
                devAppIdMap.putAll(devApps);
                recordName = devApps[0].Device__r.Name;
                daap = new DeviceApplicationApprovalProcess(devApps);
            }
        }
        else if(keyPrefixMap.get(recordId.subString(0,3)) == 'Application__c')
        {
            isDevice = false;
            devApps = [SELECT Id, Name, Device__r.Name, Application__r.Id, Application__r.Name, AcctOwner__r.Name, Approval_Status__c, CreatedById, LRB_Approver__r.Name, DTS_Approver__r.Name, Application_Manager_Selection_Approver__r.Name, Finance_Approver__r.Name, X3rd_Party_Approval_Required__c, X3rd_Party_Approval_Status__c FROM DeviceApplicationAssoc__c WHERE Application__c =: recordId AND (Include_in_BOM__c = true OR Include_on_SD_Card__c = true)];
            if(devApps.size() > 0)
            {
                devAppIdMap.putAll(devApps);
                recordName = devApps[0].Application__r.Name;
                daap = new DeviceApplicationApprovalProcess(devApps);
            }
        }       
    }
    
    public void fillListOfcDevApps()
    {
        transient Map<Id, User> userMap = UserMethods.getIdUserMap();
        
        for(DeviceApplicationAssoc__c da : devApps)
        {
            if(da.Approval_Status__c == 'Not Submitted')
            {
                system.debug('THIS DA is: Not Submitted' + da.Id);
                finalList.add(new cDevApp(da, 'Not Submitted', 'N/A', null));
            }
            else if(da.Approval_Status__c == 'Approved')
            {
                system.debug('THIS DA is: Approved' + da.Id);
                finalList.add(new cDevApp(da, 'Approved', 'N/A', null));
            }
            else if(daap.isThisLRBApprovalStep(da.Id))
            {
                system.debug('THIS DA is: LRB Approval' + da.Id);
                finalList.add(new cDevApp(da, 'LRB Approval', userMap.get(piMap.get(da.Id).StepsAndWorkitems[0].ActorId).Name, piMap.get(da.Id).StepsAndWorkitems[0].CreatedDate));
            }
            else if(daap.isThisSDSApprovalStep(da.Id))
            {
                system.debug('THIS DA is: SDS Approval' + da.Id);
                finalList.add(new cDevApp(da, 'SDS Approval', userMap.get(piMap.get(da.Id).StepsAndWorkitems[0].ActorId).Name, piMap.get(da.Id).StepsAndWorkitems[0].CreatedDate));
            }
            else if(daap.isThisApplicationManagerSelectionApproval(da.Id))
            {
                system.debug('THIS DA is: App MGR Approval' + da.Id);
                finalList.add(new cDevApp(da, 'Application Manager Selection Approval', userMap.get(piMap.get(da.Id).StepsAndWorkitems[0].ActorId).Name, piMap.get(da.Id).StepsAndWorkitems[0].CreatedDate));
            }
            else if(daap.isThisBudgetRoyaltiesApproval(da.Id))
            {
                system.debug('THIS DA is: Budget Approval' + da.Id);
                finalList.add(new cDevApp(da, 'Budget Royalties Approval', userMap.get(piMap.get(da.Id).StepsAndWorkitems[0].ActorId).Name, piMap.get(da.Id).StepsAndWorkitems[0].CreatedDate));
            }
            else if(daap.isThisPartnerManagerChecklistApproval(da.Id))
            {
                system.debug('THIS DA is: Partner MGR Approval' + da.Id);
                finalList.add(new cDevApp(da, 'Partner Manager Approval', userMap.get(piMap.get(da.Id).StepsAndWorkitems[0].ActorId).Name, piMap.get(da.Id).StepsAndWorkitems[0].CreatedDate));
            }
            else if(daap.isThis3rdPartyPartnerApproval(da.Id))
            {
                system.debug('THIS DA is: 3rd Party Approval' + da.Id);
                finalList.add(new cDevApp(da, '3rd Party Partner Approval', userMap.get(piMap.get(da.Id).StepsAndWorkitems[0].ActorId).Name, piMap.get(da.Id).StepsAndWorkitems[0].CreatedDate));
            }
            
            /*************************************************
            * Begin: VHD ticket #62679
            * Requested By: Brian Chiang
            * Modified By: Neel Desai
            * Modified On: 30/Aug/2012
            * Reason: Rejected status items were not shown 
            **************************************************/
            else if(da.Approval_Status__c == 'Rejected')
            {
                system.debug('THIS DA is: Rejected' + da.Id);
                finalList.add(new cDevApp(da, 'Rejected', 'N/A', null));
            }
            /* End: VHD ticket #62679 */
            
            else
            {
                system.debug('DO NOT KNOW THE STEP FOR THIS DA : ' + da.Id);
            }
        }       
    }
      
    public class cDevApp
    {
        public DeviceApplicationAssoc__c devApp {get; set;}
        public String currentStep {get; set;}
        public String currentApprover {get; set;}
        public Datetime queueDate {get; set;}
        
        public cDevApp(DeviceApplicationAssoc__c da, String step, String approver, Datetime qdate)
        {
                devApp = da;
                currentStep = step;
                currentApprover = approver;
                queueDate = qdate;
        }
    }
}