public class deviceApplicationApprovals {

     /*
     * Created by: Jesse
     * Creation date: Unknown
     * Description: <TO-DO>
     * Change history:
     * Date: 21-Aug-2012 Changed by: Rajesh Krishnaiah
     * Change: Added IsActive = true filter for fetching usersWhoListCurrentUserAsDelegatedApprover
     * == Date: 3-Jun-2012 Big Kite Consulting
     * Change: Added sort function to table column headings.
     * Date: 22/Aug/2012 Changed by: Neel Desai
     * Change: Added new column 'Available For Use' under 'Partner Mngr STEP'
     */
     
    public List<cApproval> LRBList {get; set;}
    public List<cApproval> SDSList {get; set;}
    public List<cApproval> BudgetList {get; set;}
    public List<cApproval> AppMgrList {get; set;}
    public List<cApproval> PartnerList {get; set;}
    public List<cApproval> thirdPartyList {get; set;}
    
    public List<cApproval> delegatedLRBList {get; set;}
    public List<cApproval> delegatedSDSList {get; set;}
    public List<cApproval> delegatedBudgetList {get; set;}
    public List<cApproval> delegatedAppMgrList {get; set;}
    public List<cApproval> delegatedPartnerList {get; set;}
    public List<cApproval> delegatedthirdPartyList {get; set;}
    
    public List<cContractApproval> contractList {get; set;}    
    
    public Map<Id, Id> devAppWorkIdMap = new Map<Id, Id>();
    
    public String name {get; set;}
    
    private Boolean  allLRBSelected = false;
    private Boolean  allSDSSelected = false;
    private Boolean  allAppMgrSelected = false;
    private Boolean  allBudgetSelected = false;
    private Boolean  allPartnerSelected = false;
    private Boolean  allThirdPartySelected = false;
    
    private Boolean  allDelegatedLRBSelected = false;
    private Boolean  allDelegatedSDSSelected = false;
    private Boolean  allDelegatedAppMgrSelected = false;
    private Boolean  allDelegatedBudgetSelected = false;
    private Boolean  allDelegatedPartnerSelected = false;
    private Boolean  allDelegatedThirdPartySelected = false;    
        
    public Boolean showApprovals {get; set;}
    public Boolean showNewApprover {get; set;}
    public Application_Manager_Selection_Matrix__c fakeAppMgnMatrix {get; set;} // used so we can have a user lookup field
    transient private List<ProcessInstance> pi;
    transient private List<ProcessInstance> delegatedPi;
    public String action {get; set;}
    public String selectionChoice {get; set;}
    
    public  List<cApproval> approvalList;
        
    public Boolean showSidebar {get; set;}
    public Boolean showHeader {get; set;}
    public Boolean showFullScreenLink {get; set;}
    
    public Boolean showError {get; set;}
    public string errorMessage {get; set;}
        
    public String generateSlidesId {get; set;}
    
    
    public deviceApplicationApprovals(){            
 
        showError = false;
        if(ApexPages.currentPage().getParameters().get('error') == '1'){
            showError = true;
        }  
      
        showApprovals = true;
        allLRBSelected = false;
        allSDSSelected = false;
        allAppMgrSelected = false;
        allBudgetSelected = false;
        allPartnerSelected = false;
        allThirdPartySelected = false;
        
        allDelegatedLRBSelected = false;
        allDelegatedSDSSelected = false;
        allDelegatedAppMgrSelected = false;
        allDelegatedBudgetSelected = false;
        allDelegatedPartnerSelected = false;
        allDelegatedThirdPartySelected = false;
        
        showSidebar = false;
        showHeader = false;
        showFullScreenLink = true;
      
        showNewApprover=false;
        fakeAppMgnMatrix = new Application_Manager_Selection_Matrix__c();
      
        approvalList = new List<cApproval>();
      
        name=UserInfo.getFirstName();
      
        LRBList = new List<cApproval>();
        SDSList = new List<cApproval>();
        BudgetList = new List<cApproval>();
        AppMgrList = new List<cApproval>();
        PartnerList = new List<cApproval>();
        thirdPartyList = new List<cApproval>();
        
        delegatedLRBList = new List<cApproval>();
        delegatedSDSList = new List<cApproval>();
        delegatedBudgetList = new List<cApproval>();
        delegatedAppMgrList = new List<cApproval>();
        delegatedPartnerList = new List<cApproval>();
        delegatedthirdPartyList = new List<cApproval>();  
        
        contractList = new List<cContractApproval>();      
        
        sortField='Device__r.SA_Date__c';
        sortOrder='asc';
        sortTable='';
        
        fillApprovalLists(UserInfo.getUserId(), LRBList, SDSList, BudgetList, AppMgrList, 
                        PartnerList, thirdPartyList, contractList, 'SADate');

        transient Map<Id, User> usersWhoListCurrentUserAsDelegatedApproverMap = 
            new Map<Id, User>([SELECT Id, Name FROM User 
                                WHERE DelegatedApproverId =: UserInfo.getUserId() 
                                and IsActive = true]);
        system.debug('USERS WHO LIST ME AS DELEGATED APPROVER: ' + usersWhoListCurrentUserAsDelegatedApproverMap);
        transient List<Id> usersWhoListCurrentUserAsDelegatedApproverAndAreOutOfOffice = new List<Id>();
        
        if(usersWhoListCurrentUserAsDelegatedApproverMap != null && 
            usersWhoListCurrentUserAsDelegatedApproverMap.size() > 0){  
            system.debug('got here 1');     
            for(Id userId : usersWhoListCurrentUserAsDelegatedApproverMap.KeySet()){
                system.debug('inside for loop, outofofficemonitor: ' + outOfOfficeMonitor.isUserOutOfOffice(userId));
                if(outOfOfficeMonitor.isUserOutOfOffice(userId)){
                    usersWhoListCurrentUserAsDelegatedApproverAndAreOutOfOffice.add(userId);
                }
            }
        }
        
        system.debug('userwhodelegatetomeandareOOF: ' + usersWhoListCurrentUserAsDelegatedApproverAndAreOutOfOffice);
        if(usersWhoListCurrentUserAsDelegatedApproverAndAreOutOfOffice.size() > 0){
            for(Id userId : usersWhoListCurrentUserAsDelegatedApproverAndAreOutOfOffice){
                fillApprovalLists(userId, delegatedLRBList, delegatedSDSList, delegatedBudgetList, 
                    delegatedAppMgrList, delegatedPartnerList, delegatedthirdPartyList, contractList, 'SADate');
            }
        }
        //sortByDevAppName();
    }
    
    /**
        Sort Device Application using existing list instead of refreshing everything in order to reduce sort time.
    */
    public void sortDevApp(){
        Map<id,cApproval> listMap=new Map<id,cApproval>();
        List<cApproval> generalList=null;
        if(sortTable=='LRBList'){
            generalList=LRBList;
        }else if(sortTable=='SDSList'){
            generalList=SDSList;
        }else if(sortTable=='BudgetList'){
            generalList=BudgetList;
        }else if(sortTable=='AppMgrList'){
            generalList=AppMgrList;
        }else if(sortTable=='PartnerList'){
            generalList=PartnerList;
        }else if(sortTable=='ThirdPartyList'){
            generalList=ThirdPartyList;
        }else if(sortTable=='delegatedLRBList'){
            generalList=delegatedLRBList;
        }else if(sortTable=='delegatedSDSList'){
            generalList=delegatedSDSList;
        }else if(sortTable=='delegatedBudgetList'){
            generalList=delegatedBudgetList;
        }else if(sortTable=='delegatedAppMgrList'){
            generalList=delegatedAppMgrList;
        }else if(sortTable=='delegatedPartnerList'){
            generalList=delegatedPartnerList;
        }else if(sortTable=='delegatedthirdPartyList'){
            generalList=delegatedthirdPartyList;
        }
        for(cApproval listItem:generalList){
            listMap.put(listItem.daid,listItem);
        }
        set<id> devAppKeys=listMap.keyset();
        if(sortField!='Name'&&sortField!='Device__r.Device_Name_plus_ID__c'&&sortField!='Device__r.Android_Release__c'&&sortField!='Device__r.Stable_Line__c'&&sortField!='Application__r.Name'&&sortField!='Device__r.SA_Date__c'&&sortField!='Application__r.Account__c'){
            Map<Id,List<DeviceApplicationAssoc__c>> applicationDeviceMap=new Map<Id,List<DeviceApplicationAssoc__c>>();
            set<id> appIds=new set<id>();
            List<DeviceApplicationAssoc__c> tempDevAppList=new List<DeviceApplicationAssoc__c>();
            List<DeviceApplicationAssoc__c> orderedDevAppList=Database.query('SELECT Id,Application__c FROM DeviceApplicationAssoc__c WHERE Id=:devAppKeys ORDER BY Device__r.SA_Date__c ASC');
            for(DeviceApplicationAssoc__c da:orderedDevAppList){
                appIds.add(da.Application__c);
                if(applicationDeviceMap.get(da.application__c)==null){
                    List<DeviceApplicationAssoc__c> devAppList=new List<DeviceApplicationAssoc__c>();
                    devAppList.add(da);
                    applicationDeviceMap.put(da.application__c,devAppList);
                }else{
                    List<DeviceApplicationAssoc__c> devAppList=applicationDeviceMap.get(da.application__c);
                    devAppList.add(da);
                    applicationDeviceMap.put(da.application__c,devAppList);
                }
            }
            List<ContApplAssoc__c> contractApplicationList=Database.query('SELECT Id,Application__c FROM ContApplAssoc__c WHERE Application__c=:appIds AND Governing_End_Date__c = true order by '+sortField+' '+sortOrder);
            orderedDevAppList.clear();
            for(ContApplAssoc__c ca : contractApplicationList){
                tempDevAppList.addAll(applicationDeviceMap.remove(ca.Application__c));
            }
            integer appDevMapSize=applicationDeviceMap.values().size();
            if(sortOrder=='ASC'){
                for(integer i=0;i<appDevMapSize;i++){
                    orderedDevAppList.addAll(applicationDeviceMap.values().get(i));
                }
                orderedDevAppList.addAll(tempDevAppList);
            }else{
                orderedDevAppList.addAll(tempDevAppList);
                for(integer i=0;i<appDevMapSize;i++){
                    orderedDevAppList.addAll(applicationDeviceMap.values().get(i));
                }
            }
            List<cApproval> tempList=new List<cApproval>();
            for(DeviceApplicationAssoc__c devApp:orderedDevAppList){
                tempList.add(listMap.get(devApp.id));
            }
            if(sortTable=='LRBList'){
                LRBList=tempList;
            }else if(sortTable=='SDSList'){
                SDSList=tempList;
            }else if(sortTable=='BudgetList'){
                BudgetList=tempList;
            }else if(sortTable=='AppMgrList'){
                AppMgrList=tempList;
            }else if(sortTable=='PartnerList'){
                PartnerList=tempList;
            }else if(sortTable=='ThirdPartyList'){
                ThirdPartyList=tempList;
            }else if(sortTable=='delegatedLRBList'){
                delegatedLRBList=tempList;
            }else if(sortTable=='delegatedSDSList'){
                delegatedSDSList=tempList;
            }else if(sortTable=='delegatedBudgetList'){
                delegatedBudgetList=tempList;
            }else if(sortTable=='delegatedAppMgrList'){
                delegatedAppMgrList=tempList;
            }else if(sortTable=='delegatedPartnerList'){
                delegatedPartnerList=tempList;
            }else if(sortTable=='delegatedthirdPartyList'){
                delegatedthirdPartyList=tempList;
            }
        }else{
            List<DeviceApplicationAssoc__c> orderedDevAppList=Database.query('SELECT Id FROM DeviceApplicationAssoc__c WHERE Id=:devAppKeys ORDER BY '+sortField+' '+sortOrder);
            List<cApproval> tempList=new List<cApproval>();
            for(DeviceApplicationAssoc__c devApp:orderedDevAppList){
                tempList.add(listMap.get(devApp.id));
            }
            if(sortTable=='LRBList'){
                LRBList=tempList;
            }else if(sortTable=='SDSList'){
                SDSList=tempList;
            }else if(sortTable=='BudgetList'){
                BudgetList=tempList;
            }else if(sortTable=='AppMgrList'){
                AppMgrList=tempList;
            }else if(sortTable=='PartnerList'){
                PartnerList=tempList;
            }else if(sortTable=='ThirdPartyList'){
                ThirdPartyList=tempList;
            }else if(sortTable=='delegatedLRBList'){
                delegatedLRBList=tempList;
            }else if(sortTable=='delegatedSDSList'){
                delegatedSDSList=tempList;
            }else if(sortTable=='delegatedBudgetList'){
                delegatedBudgetList=tempList;
            }else if(sortTable=='delegatedAppMgrList'){
                delegatedAppMgrList=tempList;
            }else if(sortTable=='delegatedPartnerList'){
                delegatedPartnerList=tempList;
            }else if(sortTable=='delegatedthirdPartyList'){
                delegatedthirdPartyList=tempList;
            }
        }
    }
    
    /**
    Date: June 3, 2012
    Modified by: Andy Leung, Big Kite Consulting
    Change:
    - Updated the query on LRBList based on passing in parameter sort field.
    */
    private void fillApprovalLists(Id userId, List<cApproval> lrbList, List<cApproval> sdsList, List<cApproval> budgetList, List<cApproval> appMgrList, List<cApproval> partnerList, List<cApproval> thirdPartyList, List<cContractApproval> contractList, String sortBy){
        //List<ProcessInstanceStep> pisList = [SELECT Id, ActorId, StepStatus, CreatedDate FROM ProcessInstanceStep WHERE StepStatus = 'Pending' AND ActorId =: userId]; 
        transient Map<Id, User> userMap = UserMethods.getIdUserMap();
        transient Map<String,String> keyPrefixMap = SystemMethods.getPrefixNameObjectMap(); 
        
        if(userMap.get(userId).userName == 'datafeed@motorola.com'){
            pi = [SELECT id, Status, TargetObjectId, (SELECT Id, StepStatus, Comments, ActorId, IsPending, CreatedDate FROM StepsAndWorkitems WHERE IsPending=true AND StepStatus='Pending') FROM ProcessInstance WHERE Status='Pending' LIMIT 500];
        }
        else{
            List<ProcessInstanceWorkitem> piwiList = [SELECT Id, ActorId, CreatedDate, ProcessInstanceId FROM ProcessInstanceWorkitem WHERE ActorId =: userId];
            List<Id> processInstanceIds = new List<Id>();
            for(ProcessInstanceWorkitem piwi : piwiList){ processInstanceIds.add(piwi.ProcessInstanceId); }
            pi = [SELECT id, Status, TargetObjectId, (SELECT Id, StepStatus, Comments, ActorId, IsPending, CreatedDate FROM StepsAndWorkitems WHERE ActorId =: userId AND IsPending=true AND StepStatus='Pending') FROM ProcessInstance WHERE Status='Pending' AND Id IN : processInstanceIds  LIMIT 500]; 
        }       
            
        List<Id> devAppIds = new List<Id>();
        integer piSize=pi.size();
        for(Integer i=0; i<piSize; i++){
            String Id = pi[i].TargetObjectId;
            System.debug('TargetObject Id[' + Id + '] is associated to Object of Type: ' + keyPrefixMap.get(Id.subString(0,3)));
            if(keyPrefixMap.get(Id.subString(0,3)) == 'DeviceApplicationAssoc__c'){     
                system.debug('size of stepandworkitems: ' + pi[i].StepsAndWorkitems.size());
                for(Integer z=0; z<pi[i].StepsAndWorkitems.size(); z++){
                    if((pi[i].StepsAndWorkitems[z].ActorId == userId && pi[i].StepsAndWorkitems[z].IsPending==true) || (userMap.get(userId).userName == 'datafeed@motorola.com' && pi[i].StepsAndWorkitems[z].IsPending==true)){
                        devAppIds.add(pi[i].TargetObjectId);
                        devAppWorkIdMap.put(pi[i].TargetObjectId, pi[i].StepsAndWorkitems[z].Id);
                        System.debug('THIS IS pi.steps[i].status/createdDate/ActorId/IsPending/target: ' + pi[i].StepsAndWorkitems[z].StepStatus + ', ' + pi[i].StepsAndWorkitems[z].CreatedDate  + ', ' + pi[i].StepsAndWorkItems[z].ActorId  + ', ' + pi[i].StepsAndWorkItems[z].IsPending + ', ' + pi[i].TargetObjectId);
                    }  
                }   
            }
        }
    
        transient DeviceApplicationApprovalProcess daap = new DeviceApplicationApprovalProcess(devAppIds);
    
        transient List<DeviceApplicationAssoc__c> daList;
        Set<Id> appIds = new Set<Id>();
        // Use it to query from ContApplAssoc for sorting function only.  It is used to rebuilt daList.  Id is Application ID because daList may have repeating Application ID.
        Map<Id,List<DeviceApplicationAssoc__c>> applicationDeviceMap=new Map<Id,List<DeviceApplicationAssoc__c>>();
        Map<Id, String> appContractStatusMap = new Map<Id, String>();
        Map<Id, Date> appContractEndDateMap = new Map<Id, Date>();
        Map<Id, Boolean> appContractAutoRenewalMap = new Map<Id, Boolean>();
        Map<Id, String> appContractDecisionMap = new Map<Id, String>();
        Map<Id, String> appContractPreReviewMeetingMap = new Map<Id, String>();
        if(sortField!='Name'&&sortField!='Device__r.Device_Name_plus_ID__c'&&sortField!='Device__r.Android_Release__c'&&sortField!='Device__r.Stable_Line__c'&&sortField!='Application__r.Name'&&sortField!='Device__r.SA_Date__c'&&sortField!='Application__r.Account__c'){
                List<DeviceApplicationAssoc__c> tempDevAppList=new List<DeviceApplicationAssoc__c>();
                daList=Database.query('SELECT Id, Device__c, Device__r.Device_Name_plus_ID__c, Device__r.Android_Release__c,Device__r.Stable_Line__c, Name, Application__c, Application__r.Name, Application__r.Account__c, Account__c, Device__r.SA_Date__c, Royalty_Low__c, Royalty_High__c, DTS_Support__c, Application_Manager__c, Application_Manager_Selection_Approver__c FROM DeviceApplicationAssoc__c WHERE Id IN : devAppIds ORDER BY Device__r.SA_Date__c ASC');
                for(DeviceApplicationAssoc__c da : daList){
                    appIds.add(da.Application__c);
                    if(applicationDeviceMap.get(da.application__c)==null){
                        List<DeviceApplicationAssoc__c> devAppList=new List<DeviceApplicationAssoc__c>();
                        devAppList.add(da);
                        applicationDeviceMap.put(da.application__c,devAppList);
                    }else{
                        List<DeviceApplicationAssoc__c> devAppList=applicationDeviceMap.get(da.application__c);
                        devAppList.add(da);
                        applicationDeviceMap.put(da.application__c,devAppList);
                    }
                }
                List<ContApplAssoc__c> contractApplicationList=Database.query('SELECT Id, Application__c, ContractStatusonCA__c, Contract__r.Auto_Renewal__c, Contract__r.EndDate, Contract__r.Decision__c, Contract__r.LRB_Initial_Deal_Decision__c FROM ContApplAssoc__c WHERE Application__c IN : appIds AND Governing_End_Date__c = true order by '+sortField+' '+sortOrder);
                daList.clear();
                for(ContApplAssoc__c ca : contractApplicationList){
                    if(ca.ContractStatusonCA__c != null){ appContractStatusMap.put(ca.Application__c, ca.ContractStatusonCA__c); }
                    if(ca.Contract__r.EndDate != null){ appContractEndDateMap.put(ca.Application__c, ca.Contract__r.EndDate); }
                    if(ca.Contract__r.Auto_Renewal__c != null){ appContractAutoRenewalMap.put(ca.Application__c, ca.Contract__r.Auto_Renewal__c); }
                    if(ca.Contract__r.Decision__c != null){ appContractDecisionMap.put(ca.Application__c, ca.Contract__r.Decision__c); }
                    if(ca.Contract__r.LRB_Initial_Deal_Decision__c != null){ appContractPreReviewMeetingMap.put(ca.Application__c, ca.Contract__r.LRB_Initial_Deal_Decision__c);}
                    tempDevAppList.addAll(applicationDeviceMap.remove(ca.Application__c));
                }
                integer appDevMapSize=applicationDeviceMap.values().size();
                if(sortOrder=='ASC'){
                    for(integer i=0;i<appDevMapSize;i++){
                        daList.addAll(applicationDeviceMap.values().get(i));
                    }
                    daList.addAll(tempDevAppList);
                }else{
                    daList.addAll(tempDevAppList);
                    for(integer i=0;i<appDevMapSize;i++){
                        daList.addAll(applicationDeviceMap.values().get(i));
                    }
                }
        }else{
                daList=Database.query('SELECT Id, Device__c, Device__r.Device_Name_plus_ID__c, Device__r.Android_Release__c,Device__r.Stable_Line__c, Name, Application__c, Application__r.Name, Application__r.Account__c, Account__c, Device__r.SA_Date__c, Royalty_Low__c, Royalty_High__c, DTS_Support__c, Application_Manager__c, Application_Manager_Selection_Approver__c, Application__r.Available_For_Use__c FROM DeviceApplicationAssoc__c WHERE Id IN : devAppIds ORDER BY '+sortField+' '+sortOrder);
                for(DeviceApplicationAssoc__c da : daList){
                    appIds.add(da.Application__c);
                }
                for(ContApplAssoc__c ca : [SELECT Id, Application__c, ContractStatusonCA__c, Contract__r.Auto_Renewal__c, Contract__r.EndDate, Contract__r.Decision__c, Contract__r.LRB_Initial_Deal_Decision__c FROM ContApplAssoc__c WHERE Application__c IN : appIds AND Governing_End_Date__c = true]){
                    if(ca.ContractStatusonCA__c != null){ appContractStatusMap.put(ca.Application__c, ca.ContractStatusonCA__c); }
                    if(ca.Contract__r.EndDate != null){ appContractEndDateMap.put(ca.Application__c, ca.Contract__r.EndDate); }
                    if(ca.Contract__r.Auto_Renewal__c != null){ appContractAutoRenewalMap.put(ca.Application__c, ca.Contract__r.Auto_Renewal__c); }
                    if(ca.Contract__r.Decision__c != null){ appContractDecisionMap.put(ca.Application__c, ca.Contract__r.Decision__c); }
                    if(ca.Contract__r.LRB_Initial_Deal_Decision__c != null){ appContractPreReviewMeetingMap.put(ca.Application__c, ca.Contract__r.LRB_Initial_Deal_Decision__c);}
                }
        }
        
        String appManager;
        for(DeviceApplicationAssoc__c da : daList){
            if(da.Application_Manager__c == null || userMap.get(da.Application_Manager__c) == null) { appManager = ''; } 
            else { appManager = userMap.get(da.Application_Manager__c).Name; }
            
            system.debug('NEW DA: ' + da.Id + ', ' + devAppWorkIdMap.get(da.Id) + ', ' + da.Device__c + ', ' + da.Device__r.Device_Name_plus_ID__c + ', ' + da.Name + ', ' + da.Application__c + ', ' + da.Application__r.Name + ', ' + da.Application__r.Account__c + ', ' + da.Account__c + ', ' + da.Device__r.SA_Date__c + ', ' + appManager);
            if(daap.isThisLRBApprovalStep(da.Id)){
                system.debug('THIS IS IN LRB STEP');
                LRBList.add(new cApproval(da.Id, devAppWorkIdMap.get(da.Id), da.Device__c, da.Device__r.Device_Name_plus_ID__c,da.Device__r.Android_Release__c,da.Device__r.Stable_Line__c, da.Name, da.Application__c, da.Application__r.Name, da.Application__r.Account__c, da.Account__c, da.Device__r.SA_Date__c, 'LRB Approval', da.Royalty_Low__c, da.Royalty_High__c, da.DTS_Support__c, appManager, appContractStatusMap.get(da.Application__c), appContractEndDateMap.get(da.Application__c), appContractAutoRenewalMap.get(da.Application__c), appContractPreReviewMeetingMap.get(da.Application__c), appContractDecisionMap.get(da.Application__c)));
            }           
            else if(daap.isThisSDSApprovalStep(da.Id)){
                system.debug('THIS IS IN SDS STEP');
                SDSList.add(new cApproval(da.Id, devAppWorkIdMap.get(da.Id), da.Device__c, da.Device__r.Device_Name_plus_ID__c,da.Device__r.Android_Release__c,da.Device__r.Stable_Line__c, da.Name, da.Application__c, da.Application__r.Name, da.Application__r.Account__c, da.Account__c, da.Device__r.SA_Date__c, 'SDS Approval', da.Royalty_Low__c, da.Royalty_High__c, da.DTS_Support__c, appManager, appContractStatusMap.get(da.Application__c), appContractEndDateMap.get(da.Application__c), appContractAutoRenewalMap.get(da.Application__c), appContractPreReviewMeetingMap.get(da.Application__c), appContractDecisionMap.get(da.Application__c)));
            }
            else if(daap.isThisApplicationManagerSelectionApproval(da.Id)){
                system.debug('THIS IS IN AppMgr STEP');
                AppMgrList.add(new cApproval(da.Id, devAppWorkIdMap.get(da.Id), da.Device__c, da.Device__r.Device_Name_plus_ID__c,da.Device__r.Android_Release__c,da.Device__r.Stable_Line__c, da.Name, da.Application__c, da.Application__r.Name, da.Application__r.Account__c, da.Account__c, da.Device__r.SA_Date__c, 'App Manager Selection Approval', da.Royalty_Low__c, da.Royalty_High__c, da.DTS_Support__c, appManager, appContractStatusMap.get(da.Application__c), appContractEndDateMap.get(da.Application__c), appContractAutoRenewalMap.get(da.Application__c), appContractPreReviewMeetingMap.get(da.Application__c), appContractDecisionMap.get(da.Application__c)));
            }
            else if(daap.isThisBudgetRoyaltiesApproval(da.Id)){
                system.debug('THIS IS IN Budget STEP');
                BudgetList.add(new cApproval(da.Id, devAppWorkIdMap.get(da.Id), da.Device__c, da.Device__r.Device_Name_plus_ID__c,da.Device__r.Android_Release__c,da.Device__r.Stable_Line__c, da.Name, da.Application__c, da.Application__r.Name, da.Application__r.Account__c, da.Account__c, da.Device__r.SA_Date__c, 'Budget Royalties Approval', da.Royalty_Low__c, da.Royalty_High__c, da.DTS_Support__c, appManager, appContractStatusMap.get(da.Application__c), appContractEndDateMap.get(da.Application__c), appContractAutoRenewalMap.get(da.Application__c), appContractPreReviewMeetingMap.get(da.Application__c), appContractDecisionMap.get(da.Application__c)));
            }
            else if(daap.isThisPartnerManagerChecklistApproval(da.Id)){
                system.debug('THIS IS IN Partner Mngr STEP');

                // Begin:: Changed by Neel Desai | 22/Aug/2012 | VHD Ticket #39089 | FR124104
                //PartnerList.add(new cApproval(da.Id, devAppWorkIdMap.get(da.Id), 
                // da.Device__c, da.Device__r.Device_Name_plus_ID__c,
                //da.Device__r.Android_Release__c,da.Device__r.Stable_Line__c, 
                //da.Name, da.Application__c, da.Application__r.Name, 
                //da.Application__r.Account__c, da.Account__c, 
                //da.Device__r.SA_Date__c, 'Partner Manager Checklist Approval', 
                //da.Royalty_Low__c, da.Royalty_High__c, da.DTS_Support__c, 
                //appManager, appContractStatusMap.get(da.Application__c), 
                //appContractEndDateMap.get(da.Application__c), 
                //appContractAutoRenewalMap.get(da.Application__c), 
                //appContractPreReviewMeetingMap.get(da.Application__c), 
                //appContractDecisionMap.get(da.Application__c)));
                PartnerList.add(new cApproval(da.Id, devAppWorkIdMap.get(da.Id),
                    da.Device__c, da.Device__r.Device_Name_plus_ID__c,
                    da.Device__r.Android_Release__c,da.Device__r.Stable_Line__c, 
                    da.Name, da.Application__c, da.Application__r.Name, 
                    da.Application__r.Account__c, da.Account__c, 
                    da.Device__r.SA_Date__c, 
                    'Partner Manager Checklist Approval', 
                    da.Royalty_Low__c, da.Royalty_High__c, 
                    da.DTS_Support__c, appManager, 
                    appContractStatusMap.get(da.Application__c), 
                    appContractEndDateMap.get(da.Application__c),
                    appContractAutoRenewalMap.get(da.Application__c), 
                    appContractPreReviewMeetingMap.get(da.Application__c), 
                    appContractDecisionMap.get(da.Application__c), 
                    da.Application__r.Available_For_Use__c));
                // End:: Changed by Neel Desai | 22/Aug/2012 | VHD Ticket #39089 | FR124104
            }
            else if(daap.isThis3rdPartyPartnerApproval(da.Id)){
                system.debug('THIS IS IN 3rdParty STEP');
                thirdPartyList.add(new cApproval(da.Id, devAppWorkIdMap.get(da.Id), da.Device__c, da.Device__r.Device_Name_plus_ID__c,da.Device__r.Android_Release__c,da.Device__r.Stable_Line__c, da.Name, da.Application__c, da.Application__r.Name, da.Application__r.Account__c, da.Account__c, da.Device__r.SA_Date__c, '3rd Party Partner Approval', da.Royalty_Low__c, da.Royalty_High__c, da.DTS_Support__c, appManager, appContractStatusMap.get(da.Application__c), appContractEndDateMap.get(da.Application__c), appContractAutoRenewalMap.get(da.Application__c), appContractPreReviewMeetingMap.get(da.Application__c), appContractDecisionMap.get(da.Application__c)));
            }
            else{
                system.debug('Could not determine step for this record: ' + da.Id);
            }
        }
    }
    
    public void sortByDevAppName(){
        List<cApproval> tempList = LRBList;
        LRBList.clear();
        cApproval firstByName;
        
        Integer tempInteger;
        while(tempList.size() != 0){
            firstByName = tempList[0];
            tempInteger = 0;
            for(Integer i=0; i<tempList.size(); i++){
                system.debug('THESE ARE TWO DEVAP NAME VALUES TO COMPARE: ' + firstByName.devAppName.substring(7) + ', ' + tempList[i].devAppName.substring(7));
                if(firstByName.devAppName.substring(7) > tempList[i].devAppName.substring(7)){
                    firstByName = tempList[i];
                    tempInteger = i;
                }
            }
            LRBList.add(firstByName);
            tempList.remove(tempInteger);
        } 
    }
    
    public void sortByAppName(){
        LRBList = new List<cApproval>();
        SDSList = new List<cApproval>();
        BudgetList = new List<cApproval>();
        AppMgrList = new List<cApproval>();
        PartnerList = new List<cApproval>();
        thirdPartyList = new List<cApproval>();
        
        delegatedLRBList = new List<cApproval>();
        delegatedSDSList = new List<cApproval>();
        delegatedBudgetList = new List<cApproval>();
        delegatedAppMgrList = new List<cApproval>();
        delegatedPartnerList = new List<cApproval>();
        delegatedthirdPartyList = new List<cApproval>();
        
        fillApprovalLists(UserInfo.getUserId(), LRBList, SDSList, BudgetList, AppMgrList, PartnerList, thirdPartyList, contractList, 'ApplicationName');
    }
    
    public Boolean getShowLRB(){
        if(LRBList.size() > 0){
            return true;
        }
        return false;
    }

    public Boolean getshowSDS(){
        if(SDSList.size() > 0){
            return true;
        }
        return false;
    }
  
    public Boolean getshowAppMgr(){
        if(AppMgrList.size() > 0){
            return true;
        }
        return false;
    }
  
    public Boolean getshowBudget(){
        if(BudgetList.size() > 0){
            return true;
        }
        return false;
    }
  
    public Boolean getshowPartner(){
        if(PartnerList.size() > 0){
            return true;
        }
        return false;
    }      

    public Boolean getshowThirdParty(){
        if(thirdPartyList.size() > 0){
            return true;
        }
        return false;
    } 
    
    public Boolean getShowDelegatedLRB(){
        if(delegatedLRBList.size() > 0){
            return true;
        }
        return false;
    }

    public Boolean getshowDelegatedSDS(){
        if(delegatedSDSList.size() > 0){
            return true;
        }
        return false;
    }
  
    public Boolean getshowDelegatedAppMgr(){
        if(delegatedAppMgrList.size() > 0){
            return true;
        }
        return false;
    }
  
    public Boolean getshowDelegatedBudget(){
        if(delegatedBudgetList.size() > 0){
            return true;
        }
        return false;
    }
  
    public Boolean getshowDelegatedPartner(){
        if(delegatedPartnerList.size() > 0){
            return true;
        }
        return false;
    }      

    public Boolean getshowDelegatedThirdParty(){
        if(delegatedthirdPartyList.size() > 0){
            return true;
        }
        return false;
    }
    
    public Boolean getshowLRBContractApprovals(){
        if(!contractList.isEmpty()){
            return true;
        }
        return false;
    }   
  
    public void selectAll(){
        system.debug('THIS IS selectionChoice: ' + selectionChoice);
        if(selectionChoice == 'LRB'){
            for(Integer i=0; i<LRBList.size(); i++){
                if(!allLRBSelected){
                    LRBList[i].selected = true;
                }
                else{
                    LRBList[i].selected = false;
                }
            }
            allLRBSelected = !allLRBSelected;  
        }   
    
        if(selectionChoice == 'SDS'){
            for(Integer i=0; i<SDSList.size(); i++){
                if(!allSDSSelected){
                    SDSList[i].selected = true;
                }
                else{
                    SDSList[i].selected = false;
                }
            }  
            allSDSSelected = !allSDSSelected;    
        }
    
        if(selectionChoice == 'AppMgr'){
            for(Integer i=0; i<AppMgrList.size(); i++){
                if(!allAppMgrSelected){
                    AppMgrList[i].selected = true;
                }
                else{
                    AppMgrList[i].selected = false;
                }
            }
            allAppMgrSelected = !allAppMgrSelected;      
        }
    
        if(selectionChoice == 'Budget'){
            for(Integer i=0; i<BudgetList.size(); i++){
                if(!allBudgetSelected){
                    BudgetList[i].selected = true;
                }
                else{
                    BudgetList[i].selected = false;
                }
            }    
            allBudgetSelected = !allBudgetSelected;  
        }
    
        if(selectionChoice == 'Partner'){
            for(Integer i=0; i<PartnerList.size(); i++){
                if(!allPartnerSelected){
                    PartnerList[i].selected = true;
                }
                else{
                    PartnerList[i].selected = false;
                }
            }
            allPartnerSelected = !allPartnerSelected;      
        }          
    
        if(selectionChoice == 'ThirdParty'){
            for(Integer i=0; i<thirdPartyList.size(); i++){
                if(!allThirdPartySelected){
                    thirdPartyList[i].selected = true;
                }
                else{
                    thirdPartyList[i].selected = false;
                }
            }
            allThirdPartySelected = !allThirdPartySelected;      
        }  

        if(selectionChoice == 'delegatedLRB'){
            for(Integer i=0; i<delegatedLRBList.size(); i++){
                if(!allDelegatedLRBSelected){
                    delegatedLRBList[i].selected = true;
                }
                else{
                    delegatedLRBList[i].selected = false;
                }
            }
            allDelegatedLRBSelected = !allDelegatedLRBSelected;  
        }   
    
        if(selectionChoice == 'delegatedSDS'){
            for(Integer i=0; i<delegatedSDSList.size(); i++){
                if(!allDelegatedSDSSelected){
                    delegatedSDSList[i].selected = true;
                }
                else{
                    delegatedSDSList[i].selected = false;
                }
            }  
            allDelegatedSDSSelected = !allDelegatedSDSSelected;    
        }
    
        if(selectionChoice == 'delegatedAppMgr'){
            for(Integer i=0; i<delegatedAppMgrList.size(); i++){
                if(!allDelegatedAppMgrSelected){
                    delegatedAppMgrList[i].selected = true;
                }
                else{
                    delegatedAppMgrList[i].selected = false;
                }
            }
            allDelegatedAppMgrSelected = !allDelegatedAppMgrSelected;      
        }
    
        if(selectionChoice == 'delegatedBudget'){
            for(Integer i=0; i<delegatedBudgetList.size(); i++){
                if(!allDelegatedBudgetSelected){
                    delegatedBudgetList[i].selected = true;
                }
                else{
                    delegatedBudgetList[i].selected = false;
                }
            }    
            allDelegatedBudgetSelected = !allDelegatedBudgetSelected;  
        }
    
        if(selectionChoice == 'delegatedPartner'){
            for(Integer i=0; i<delegatedPartnerList.size(); i++){
                if(!allDelegatedPartnerSelected){
                    delegatedPartnerList[i].selected = true;
                }
                else{
                    delegatedPartnerList[i].selected = false;
                }
            }
            allDelegatedPartnerSelected = !allDelegatedPartnerSelected;      
        }          
    
        if(selectionChoice == 'delegatedThirdParty'){
            for(Integer i=0; i<delegatedthirdPartyList.size(); i++){
                if(!allDelegatedThirdPartySelected){
                    delegatedthirdPartyList[i].selected = true;
                }
                else{
                    delegatedthirdPartyList[i].selected = false;
                }
            }
            allDelegatedThirdPartySelected = !allDelegatedThirdPartySelected;      
        }  

    }
  
    private void buildApprovalList(){
        for(Integer i=0; i<LRBList.size(); i++){
            if(LRBList[i].selected == true){
            approvalList.add(LRBList[i]);
            system.debug('added 1 to approval list');
            }
        }

        for(Integer i=0; i<SDSList.size(); i++){
            if(SDSList[i].selected == true){
                approvalList.add(SDSList[i]);
            }
        }
    
        for(Integer i=0; i<AppMgrList.size(); i++){
            if(AppMgrList[i].selected == true){
                approvalList.add(AppMgrList[i]);
            }
        }
    
        for(Integer i=0; i<BudgetList.size(); i++){
            if(BudgetList[i].selected == true){
                approvalList.add(BudgetList[i]);
            }
        }
    
        for(Integer i=0; i<PartnerList.size(); i++){
            if(PartnerList[i].selected == true){
                approvalList.add(PartnerList[i]);
            }
        }
        
        for(Integer i=0; i<thirdPartyList.size(); i++){
            if(thirdPartyList[i].selected == true){
                approvalList.add(thirdPartyList[i]);
            }
        }
        
        for(Integer i=0; i<delegatedLRBList.size(); i++){
            if(delegatedLRBList[i].selected == true){
            approvalList.add(delegatedLRBList[i]);
            system.debug('added 1 to approval list');
            }
        }

        for(Integer i=0; i<delegatedSDSList.size(); i++){
            if(delegatedSDSList[i].selected == true){
                approvalList.add(delegatedSDSList[i]);
            }
        }
    
        for(Integer i=0; i<delegatedAppMgrList.size(); i++){
            if(delegatedAppMgrList[i].selected == true){
                approvalList.add(delegatedAppMgrList[i]);
            }
        }
    
        for(Integer i=0; i<delegatedBudgetList.size(); i++){
            if(delegatedBudgetList[i].selected == true){
                approvalList.add(delegatedBudgetList[i]);
            }
        }
    
        for(Integer i=0; i<delegatedPartnerList.size(); i++){
            if(delegatedPartnerList[i].selected == true){
                approvalList.add(delegatedPartnerList[i]);
            }
        }
        
        for(Integer i=0; i<delegatedthirdPartyList.size(); i++){
            if(delegatedthirdPartyList[i].selected == true){
                approvalList.add(delegatedthirdPartyList[i]);
            }
        }                       
    }
  
    public PageReference processSelected(){
        system.debug('THI IS ACTION: ' + action);
        List<Approval.ProcessWorkitemRequest> pwir = new List<Approval.processWorkitemRequest>();
        Approval.ProcessWorkitemRequest req;
        
        buildApprovalList();
        
        for(Integer i=0; i<approvalList.size(); i++){
            if(approvalList[i].selected == true){
                req = new Approval.ProcessWorkitemRequest();
                req.setAction(action);
                req.setWorkitemId(approvalList[i].stepId);
                pwir.add(req);
            }
        }
        
        List<Approval.Processresult> approvalResult = new List<Approval.Processresult>();
        if(pwir.size() != 0){
            try{
                approvalResult = Approval.process(pwir);
            }
            catch(System.DmlException e){
                system.debug('THIS IS SYSTEM ERROR: ' + e.getMessage());
                showError = true;
            }       
        }
        
        PageReference pr;

        if(showFullScreenLink == false){
            // if currently viewing page in full screen
            pr = new PageReference('/home/home.jsp');   
        }
        else{
            pr = new PageReference('/apex/DeviceApplicationApprovals');
        } 
        if(showError == true){
            pr.getParameters().put('error', '1');           
        }
        pr.setRedirect(true);
        return pr;
  }
  
    public void reassignSelected(){
        showApprovals = false;
        showNewApprover = true;  
    }
  
    public PageReference saveReassignment(){
        buildApprovalList();
        List<Id> stepIds = new List<Id>();
        for(Integer i=0; i<approvalList.size(); i++){
            if(approvalList[i].selected == true){
                stepIds.add(approvalList[i].stepId);
            }
        }
        List<ProcessInstanceWorkitem> piwi = [SELECT Id, actorid FROM ProcessInstanceWorkitem WHERE id IN : stepIds];
        for(Integer i=0; i<piwi.size(); i++){
            piwi[i].actorId = fakeAppMgnMatrix.Application_Manager__c;
        }
        
        update piwi;
        
        PageReference pr;
        if(showFullScreenLink == false){
            // if currently viewing page in full screen
            pr = new PageReference('/home/home.jsp');   
        }
        else{
            pr = new PageReference('/apex/DeviceApplicationApprovals');
        } 
        
        pr.setRedirect(true);
        return pr;    
    }  

    public PageReference cancel(){
        PageReference pr;
        if(showFullScreenLink == false){
            // if currently viewing page in full screen
            pr = new PageReference('/home/home.jsp');   
        }
        else{
            pr = new PageReference('/apex/DeviceApplicationApprovals');
        } 
        pr.setRedirect(true);
        return pr;    
    }
  
    public PageReference fullScreen(){
        showHeader = true;
        showSidebar = true;
        showFullScreenLink = false;
          
        PageReference pr = ApexPages.currentPage();
        return pr; 
    }
    
    public PageReference generateSlides(){
        PageReference pr = new PageReference('/apex/loop__looplus?eid=' + generateSlidesId);
        return pr;
        
    }
  
        /************************************************************************************************
        Big Kite Consulting Code Starts Below
        Date: June 3, 2012
        *************************************************************************************************/  
        public void resetLists(){
            if(LRBList==null){
                    LRBList = new List<cApproval>();
            }else{
                    LRBList.clear();
            }
            if(SDSList==null){
                    SDSList = new List<cApproval>();
            }else{
                    SDSList.clear();
            }
            if(BudgetList==null){
                    BudgetList = new List<cApproval>();
            }else{
                    BudgetList.clear();
            }
            if(AppMgrList==null){
                    AppMgrList = new List<cApproval>();
            }else{
                    AppMgrList.clear();
            }
            if(PartnerList==null){
                    PartnerList = new List<cApproval>();
            }else{
                    PartnerList.clear();
            }
            if(thirdPartyList==null){
                    thirdPartyList = new List<cApproval>();
            }else{
                    thirdPartyList.clear();
            }
            
            if(delegatedLRBList==null){
                    delegatedLRBList = new List<cApproval>();
            }else{
                    delegatedLRBList.clear();
            }
            if(delegatedSDSList==null){
                    delegatedSDSList = new List<cApproval>();
            }else{
                    delegatedSDSList.clear();
            }
            if(delegatedBudgetList==null){
                    delegatedBudgetList = new List<cApproval>();
            }else{
                    delegatedBudgetList.clear();
            }
            if(delegatedAppMgrList==null){
                    delegatedAppMgrList = new List<cApproval>();
            }else{
                    delegatedAppMgrList.clear();
            }
            if(delegatedPartnerList==null){
                    delegatedPartnerList = new List<cApproval>();
            }else{
                    delegatedPartnerList.clear();
            }
            if(delegatedthirdPartyList==null){
                    delegatedthirdPartyList = new List<cApproval>();
            }else{
                    delegatedthirdPartyList.clear();
            }
        }
    public String sortOrder{get;set;}
    public String sortField{get;set;}
    public String sortTable{get;set;}
    public String previousSortField {get; set;}
    public PageReference doSort(){
        sortOrder='asc';
        if(previousSortField==sortField){
            sortOrder='desc';
            previousSortField=null;
        }else{
            previousSortField=sortField;
        }
        sortDevApp();
        return null;
    }
    public String SDSsortOrder{get;set;}
    public String SDSsortField{get;set;}
    public String SDSpreviousSortField {get; set;}
    public PageReference SDSdoSort(){
        SDSsortOrder='asc';
        if(SDSpreviousSortField==SDSsortField){
            SDSsortOrder='desc';
            SDSpreviousSortField=null;
        }else{
            SDSpreviousSortField=SDSsortField;
        }
        resetLists();
        fillApprovalLists(UserInfo.getUserId(), LRBList, SDSList, BudgetList, AppMgrList, PartnerList, thirdPartyList, contractList, sortField);
        return null;
    }
    public String BudgetsortOrder{get;set;}
    public String BudgetsortField{get;set;}
    public String BudgetpreviousSortField {get; set;}
    public PageReference BudgetdoSort(){
        BudgetsortOrder='asc';
        if(BudgetpreviousSortField==BudgetsortField){
            BudgetsortOrder='desc';
            BudgetpreviousSortField=null;
        }else{
            BudgetpreviousSortField=BudgetsortField;
        }
        resetLists();
        fillApprovalLists(UserInfo.getUserId(), LRBList, SDSList, BudgetList, AppMgrList, PartnerList, thirdPartyList, contractList, sortField);
        return null;
    }
    public String AppMgrsortOrder{get;set;}
    public String AppMgrsortField{get;set;}
    public String AppMgrpreviousSortField {get; set;}
    public PageReference AppMgrdoSort(){
        AppMgrsortOrder='asc';
        if(AppMgrpreviousSortField==AppMgrsortField){
            AppMgrsortOrder='desc';
            AppMgrpreviousSortField=null;
        }else{
            AppMgrpreviousSortField=AppMgrsortField;
        }
        resetLists();
        fillApprovalLists(UserInfo.getUserId(), LRBList, SDSList, BudgetList, AppMgrList, PartnerList, thirdPartyList, contractList, sortField);
        return null;
    }
    public String PartnersortOrder{get;set;}
    public String PartnersortField{get;set;}
    public String PartnerpreviousSortField {get; set;}
    public PageReference PartnerdoSort(){
        PartnersortOrder='asc';
        if(PartnerpreviousSortField==PartnersortField){
            PartnersortOrder='desc';
            PartnerpreviousSortField=null;
        }else{
            PartnerpreviousSortField=PartnersortField;
        }
        resetLists();
        fillApprovalLists(UserInfo.getUserId(), LRBList, SDSList, BudgetList, AppMgrList, PartnerList, thirdPartyList, contractList, sortField);
        return null;
    }
    public String ThirdPartysortOrder{get;set;}
    public String ThirdPartysortField{get;set;}
    public String ThirdPartypreviousSortField {get; set;}
    public PageReference ThirdPartydoSort(){
        ThirdPartysortOrder='asc';
        if(ThirdPartypreviousSortField==ThirdPartysortField){
            ThirdPartysortOrder='desc';
            ThirdPartypreviousSortField=null;
        }else{
            ThirdPartypreviousSortField=ThirdPartysortField;
        }
        resetLists();
        fillApprovalLists(UserInfo.getUserId(), LRBList, SDSList, BudgetList, AppMgrList, PartnerList, thirdPartyList, contractList, sortField);
        return null;
    }
    
    public class LRBDevApp{
        
    }
  
    public class cApproval {
        public Id daId {get; set;}
        public Id stepId {get; set;}
        public Id deviceId {get; set;}
        public String deviceName {get; set;}
        public String devAppName {get; set;}
        public Id appId {get; set;}
        public String appName {get; set;}
        public String platformRelease {get; set;}
        public String stableLine {get; set;}
        public Id accountId {get; set;}
        public String accountName {get; set;}
        public Date devSADate {get; set;}
        public String approvalStep {get; set;}
        public Boolean selected {get; set;}
        public Decimal royaltyLow {get; set;}
        public Decimal royaltyHigh {get; set;}
        public String SDSSupport {get; set;}
        public String ApplicationManager {get; set;}
        public String contractStatus {get; set;}
        public Date endDate {get; set;}
        public Boolean autoRenewal {get; set;}
        public String contractPreReviewMeeting {get; set;}
        public String contractDecision {get; set;}
        
        // Neel Desai | 22/Aug/2012
        public Boolean availableForUse {get; set;}

        
        //(da.Id, devAppWorkIdMap.get(da.Id), da.Device__c, 
        //da.Device__r.Device_Name_plus_ID__c, da.Name, 
        //da.Application__c, da.Application__r.Name, 
        //da.Application__r.Account__c, da.Account__c, 
        //da.Device__r.SA_Date__c, 'LRB Approval', da.Royalty_Low__c, 
        //da.Royalty_High__c, da.DTS_Support__c, 
        //userMap.get(da.Application_Manager__c), 
        //appContractStatusMap.get(da.Application__c), 
        //appContractEndDateMap.get(da.Application__c),
        // appContractAutoRenewalMap.get(da.Application__c)));                                      
        public cApproval(Id daId, Id stepId, Id deviceId, String deviceName, 
        		String platformRelease,String stableLine,String DevAppName, 
        		Id appId, String appName, Id accountId, String accountName, 
        		Date saDate, String approvalStep, Decimal low, Decimal high, 
        		String sds, String appMgr, String contractStatus, Date endDate, 
        		Boolean autoRenewal, String preReview, String contractDecision){
            this.daId = daid;
            this.stepId = stepId;
            this.deviceId = deviceId;
            this.deviceName = deviceName;
            this.devAppName = devAppName;
            this.platformRelease=platformRelease;
            this.stableLine=stableLine;
            this.appId = appId;
            this.appName = appName;
            this.accountId = accountId;
            this.accountName = accountName;
            this.devSADate = saDate;
            this.approvalStep = approvalStep;
            this.royaltyLow = low;
            this.royaltyHigh = high;
            this.SDSSupport = sds;
            this.ApplicationManager = appMgr;
            this.contractStatus = contractStatus;
            this.endDate = endDate;
            this.autoRenewal = autoRenewal;
            this.contractPreReviewMeeting = preReview;
            this.contractDecision = contractDecision;
            selected = false;
        }

        // Neel Desai | 22/Aug/2012
        // Added one more parameter to constructor (Available For Use)
        public cApproval(Id daId, Id stepId, Id deviceId, String deviceName, 
        	String platformRelease,String stableLine,String DevAppName, 
        	Id appId, String appName, Id accountId, String accountName, 
        	Date saDate, String approvalStep, Decimal low, Decimal high, 
        	String sds, String appMgr, String contractStatus, Date endDate, 
        	Boolean autoRenewal, String preReview, String contractDecision, 
        	Boolean availableForUse)
        {
            this.daId = daid;
            this.stepId = stepId;
            this.deviceId = deviceId;
            this.deviceName = deviceName;
            this.devAppName = devAppName;
            this.platformRelease=platformRelease;
            this.stableLine=stableLine;
            this.appId = appId;
            this.appName = appName;
            this.accountId = accountId;
            this.accountName = accountName;
            this.devSADate = saDate;
            this.approvalStep = approvalStep;
            this.royaltyLow = low;
            this.royaltyHigh = high;
            this.SDSSupport = sds;
            this.ApplicationManager = appMgr;
            this.contractStatus = contractStatus;
            this.endDate = endDate;
            this.autoRenewal = autoRenewal;
            this.contractPreReviewMeeting = preReview;
            this.contractDecision = contractDecision;
            this.availableForUse = availableForUse; // this is new line in above constructor
            selected = false;
        }
    }
    
    public class cContractApproval {
        public Id contractId {get; set;}
        public String contractNumber {get; set;}
        public String contractName {get; set;}
        public String approvalType {get; set;}
        public Id accountId {get; set;}
        public String accountName {get; set;}
        public String accountOwner {get; set;}
        public Date requestedInitialDate {get; set;}
        public Date requestedFinalDate {get; set;}
        
        public cContractApproval(Id contractId, String contractNumber, 
        	String contractName, String approvalType, Id accountId, 
        	String accountName, String accountOwner, Date requestedInitialDate, 
        	Date requestedFinalDate){
            this.contractId = contractId;
            this.contractNumber = contractNumber;
            this.contractName = contractName;
            this.approvalType = approvalType;
            this.accountId = accountId;
            this.accountName = accountName;
            this.accountOwner = accountOwner;
            this.requestedInitialDate = requestedInitialDate;
            this.requestedFinalDate = requestedFinalDate;
        }
    }
  
    public static testMethod void deviceApplicationApprovalsTest(){
        // neds to be split into two tests because of the number of queries 
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        
        Account a1 = new Account(Name='Account1', ownerId = p.Id);
        insert a1;
        
        Contract c1 = new Contract(Name='Contract1', AccountId=a1.Id, 
        	StartDate=DATE.today());
        insert c1;
        
        List<Application__c> apps = new List<Application__c>();
        apps.add(new Application__c(Name='App', application_type__c = 'Preload', 
        	Application_Sub_Type__c='Content', Royalty_Low__c=5, Royalty_High__c=25,
        	 Account__c=a1.Id, X3rd_Party_Approval_Required__c=true, 
        	 AcctOwnerApp__c='005400000012v9N', Available_For_Use__c=true, 
        	 Application_Category__c='Content', Description__c='Test'));
        apps.add(new Application__c(Name='App-delegated', 
        	application_type__c = 'Preload', Application_Sub_Type__c='Content', 
        	Royalty_Low__c=5, Royalty_High__c=25, Account__c=a1.Id, 
        	X3rd_Party_Approval_Required__c=true, 
        	AcctOwnerApp__c='005400000012v9N', Available_For_Use__c=true, 
        	Application_Category__c='Content', Description__c='Test'));
        apps.add(new Application__c(Name='TestApp', application_type__c = 'Preload', 
        	Application_Sub_Type__c='Content', Royalty_Low__c=5, 
        	Royalty_High__c=25, Account__c=a1.Id, X3rd_Party_Approval_Required__c=true, 
        	AcctOwnerApp__c='005400000012v9N', Available_For_Use__c=true, 
        	Application_Category__c='Content', Description__c='Test'));
        insert apps;
        
        ContApplAssoc__c conApp = new ContApplAssoc__c(
        	application__c=apps[0].Id, contract__c = c1.Id);
        insert conApp;
        
        // Rajesh -- Added Cancelled__c = False
        Device__c dev = new Device__c(Name='Dev1', Cancelled__c = false);
        
        System.runAs(p) {        
            insert dev;
        }
        system.debug('TEST CODE');
        
        List<DeviceApplicationAssoc__c> devApps = new List<DeviceApplicationAssoc__c>();
        devApps.add(new DeviceApplicationAssoc__c(Device__c=dev.Id, 
        	Application__c=apps[0].Id, Approval_Status__c='Rejected'));
        devApps.add(new DeviceApplicationAssoc__c(Device__c=dev.Id, 
        	Application__c=apps[1].Id));
        devApps.add(new DeviceApplicationAssoc__c(Device__c=dev.Id, 
        	Application__c=apps[2].Id, Approval_Status__c='Approved'));
        insert devApps;
        
        User automatedDatafeed = [SELECT Id, delegatedApproverId FROM User WHERE username LIKE 'datafeed@motorola.com%'];
        Out_Of_Office__c oof = new Out_Of_Office__c(Start_Time__c = DateTime.now().addDays(-1), 
        	End_Time__c = DateTime.now().addDays(1), Active__c = true, 
        	User__c = automatedDatafeed.Id);
        System.runAs(automatedDatafeed){
            insert oof;
        }

        //'005400000012v9N' = Motorola Partnership Management    
        devApps[0].LRB_Approver__c = '005400000012v9N';
        devApps[0].DTS_Approver__c = '005400000012v9N';
        devApps[0].Application_Manager_Selection_Approver__c = '005400000012v9N';
        devApps[0].Finance_Approver__c = '005400000012v9N';
        devApps[0].AcctOwner__c = '005400000012v9N';                
            devApps[0].include_in_bom__c = true;
            devApps[0].Skip_Partner_Manager_Approval_Country__c = false;
            devApps[0].Past_Partner_Manager_Approval__c = false;
            devApps[0].X3rd_Party_Approval_Required__c = true;
            devApps[0].X3rd_Party_Approval_Status__c = 'In Progress';
            devApps[0].Approval_Status__c = 'Not Submitted';
            
        devApps[1].LRB_Approver__c = automatedDatafeed.Id;
        devApps[1].DTS_Approver__c = automatedDatafeed.Id;
        devApps[1].Application_Manager_Selection_Approver__c = automatedDatafeed.Id;
        devApps[1].Finance_Approver__c = automatedDatafeed.Id;
        devApps[1].AcctOwner__c = automatedDatafeed.Id;                 
        //devApp.Application_Manager__c = '005400000012v9N'; 
        
            devApps[1].include_in_bom__c = true;
            devApps[1].Skip_Partner_Manager_Approval_Country__c = false;
            devApps[1].Past_Partner_Manager_Approval__c = false;
            devApps[1].X3rd_Party_Approval_Required__c = true;
            devApps[1].X3rd_Party_Approval_Status__c = 'In Progress';
            devApps[1].Approval_Status__c = 'Not Submitted';
        
            devApps[2].include_in_bom__c = true;
            devApps[2].Skip_Partner_Manager_Approval_Country__c = false;
            devApps[2].Past_Partner_Manager_Approval__c = false;
            devApps[2].X3rd_Party_Approval_Required__c = true;
            devApps[2].X3rd_Party_Approval_Status__c = 'In Progress';
            devApps[2].Approval_Status__c = 'Not Submitted';
        update devApps;
        
        p = [SELECT ID, Username From User Where username LIKE 'mpm@motorola.com%' LIMIT 1];
        dev.OwnerId = p.Id;
        update dev;
        
        automatedDatafeed.DelegatedApproverId = p.Id;
        update automatedDatafeed;

        test.starttest();        
                /* Test for viewDeviceRelatedDevApps */
                
                /***** Added by Neel on 31/Aug/2012 for more code coverage *****/ 
                List<Application__c> appList = new List<Application__c>{apps[1]};
                Apexpages.StandardSetController stanConTemp = new Apexpages.standardSetController(appList);
                PageReference prTemp = new PageReference('/' + apps[1].Id);
                prTemp.getParameters().put('id', apps[1].Id);
                test.setCurrentPage(prTemp);
                viewDeviceRelatedDevApps vdrdaTemp = new viewDeviceRelatedDevApps(stanConTemp);
                /**********************/
                
                List<Device__c> devList = new List<Device__c>{dev};
                Apexpages.StandardSetController stanCon = new Apexpages.standardSetController(devList);      
                PageReference prVDRDA = new PageReference('/' + dev.Id);
                prVDRDA.getParameters().put('id', dev.Id);
                test.setCurrentPage(prVDRDA);
                viewDeviceRelatedDevApps vdrda = new viewDeviceRelatedDevApps(stanCon);       


        System.runAs(p) {
            // Test If devApp.Approval_Status__c=rejected
            //devApps[0].Approval_Status__c = 'Rejected';
            //devApps[0].Approval_Status__c = 'Not Submitted';
            //update devApps[0];
            
            // Debug
            for (Integer i=0; i<devApps.size(); i++) {
            	system.debug(i + ' - Device : Device Cancelled or Deleted from NPI?: ' + devApps[i].device__r.Cancelled__c);
            	system.debug(i + ' - Device Application : Include in BOM equals true: ' + devApps[i].Include_in_BOM__c);
            	system.debug(i + ' - Device Application : Skip Partner Manager Approval - Country: ' + 
            		devApps[i].Skip_Partner_Manager_Approval_Country__c);
            	system.debug(i + ' - Device Application : Past Partner Manager Approval: ' +
            		devApps[i].Past_App_Mgr_Approval__c);
            	system.debug(i + ' - Device Application : 3rd Party Approval Required: ' +
            		devApps[i].X3rd_Party_Approval_Required__c);
            	system.debug(i + ' - Device Application : 3rd Party Approval Status: ' +
            		devApps[i].X3rd_Party_Approval_Status__c);
            }
            // create the new approval request to submit
            Approval.ProcessSubmitRequest req;
            Approval.ProcessResult result;
            for(Integer i=0; i<devApps.size(); i++){
                req = new Approval.ProcessSubmitRequest();
                req.setComments('Submitted for approval.TEST.');
                req.setObjectId(devApps[i].Id);
                req.setNextApproverIds(new List<Id>{UserInfo.getUserId()});
                
                //try {
                	system.debug('RKRISHN1: ' + i);
                    // submit the approval request for processing
                    result = Approval.process(req);
                    // display if the reqeust was successful
                    System.debug('Submitted for approval successfully: '+result.isSuccess());
                    System.debug('result.actors: '+result.getActorIds());
                //} catch (System.DmlException e) {
                        // Ignore NO_SUCH_PROCESS error
                //}
            }
            //all devapps have been submitted, they should all be in LRB stage
            
            // LRB    
                /* Test for viewDeviceRelatedDevApps */     
                //vdrda = new viewDeviceRelatedDevApps(stanCon);
            
            deviceApplicationApprovals daa = new deviceApplicationApprovals();
                  
            Boolean testBoolean;
            testBoolean = daa.getShowLRB();
            testBoolean = daa.getShowSDS();
            testBoolean = daa.getshowAppMgr();
            testBoolean = daa.getshowBudget();
            testBoolean = daa.getshowPartner();
            testBoolean = daa.getshowthirdparty();
            testBoolean = daa.getShowDelegatedLRB();
            testBoolean = daa.getShowDelegatedSDS();
            testBoolean = daa.getshowDelegatedAppMgr();
            testBoolean = daa.getshowDelegatedBudget();
            testBoolean = daa.getshowDelegatedPartner();
            testBoolean = daa.getshowDelegatedthirdparty();
                    
            daa.selectionChoice = 'LRB';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
            daa.selectionChoice = 'delegatedLRB';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
            
            daa.fakeAppMgnMatrix.Application_Manager__c = '005400000011zLR';  
            daa.saveReassignment();
            PageReference pr = daa.fullScreen();
            //daa.saveReassignment();
            //pr = daa.fullScreen();            
          
            daa.action = 'Approve';
            pr = daa.processSelected();
            daa.reassignSelected();
            pr = daa.cancel();
            pr = daa.fullScreen();
            pr = daa.cancel();
          
            // SDS    
                /* Test for viewDeviceRelatedDevApps */     
                //vdrda = new viewDeviceRelatedDevApps(stanCon);
                            
            daa = new deviceApplicationApprovals();
      
            testBoolean = daa.getShowLRB();
            testBoolean = daa.getShowSDS();
            testBoolean = daa.getShowDelegatedLRB();
            testBoolean = daa.getShowDelegatedSDS();

            daa.selectionChoice = 'SDS';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
            daa.selectionChoice = 'delegatedSDS';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
          
            daa.action = 'Approve';
            pr = daa.processSelected();
          
            // AppMgr    
                /* Test for viewDeviceRelatedDevApps */     
                //vdrda = new viewDeviceRelatedDevApps(stanCon);
                            
            daa = new deviceApplicationApprovals();
      
            testBoolean = daa.getshowAppMgr();
            testBoolean = daa.getshowDelegatedAppMgr();
            
            daa.selectionChoice = 'AppMgr';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
            daa.selectionChoice = 'delegatedAppMgr';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
          
            daa.action = 'Approve';
            pr = daa.processSelected();
          
          
            // Budget    
                /* Test for viewDeviceRelatedDevApps */     
                //vdrda = new viewDeviceRelatedDevApps(stanCon);
                
                            
            /*daa = new deviceApplicationApprovals();
            
            testBoolean = daa.getshowBudget();
            testBoolean = daa.getshowDelegatedBudget();
            
            daa.selectionChoice = 'Budget';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
            daa.selectionChoice = 'delegatedBudget';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
          
            daa.action = 'Approve';
            pr = daa.processSelected();
          */
            // Partner    
                /* Test for viewDeviceRelatedDevApps */     
            //  prVDRDA = new PageReference('/' + apps[0].Id);
            //    prVDRDA.getParameters().put('id', apps[0].Id);
            //    test.setCurrentPage(prVDRDA);             
            //  vdrda = new viewDeviceRelatedDevApps(stanCon);
                
                            
          /*    daa = new deviceApplicationApprovals();
      
            testBoolean = daa.getshowPartner();
            testBoolean = daa.getshowDelegatedPartner();
            
            daa.selectionChoice = 'Partner';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
            daa.selectionChoice = 'delegatedPartner';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
          
            daa.action = 'Approve';
            pr = daa.processSelected();
          */
            // 3rd Party    
                /* Test for viewDeviceRelatedDevApps */     
                /*
                vdrda = new viewDeviceRelatedDevApps(stanCon); */
                            
            /*daa = new deviceApplicationApprovals();
      
            testBoolean = daa.getshowthirdparty();
            testBoolean = daa.getshowDelegatedthirdparty();
            
            daa.selectionChoice = 'ThirdParty';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
            daa.selectionChoice = 'delegatedThirdParty';
            daa.selectAll();
            daa.selectAll();
            daa.selectAll();
          
            daa.action = 'Approve';
            pr = daa.processSelected();     */  

        }
        
        // to test ContractDataToDeviceApplication
            c1.Name = 'testUpdate';
            update c1;      
        
        test.stoptest();
    }
}