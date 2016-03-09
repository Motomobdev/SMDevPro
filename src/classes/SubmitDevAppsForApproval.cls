public class SubmitDevAppsForApproval {

   /*
     * Created by: Jesse A
     * Creation date: Unknown
     * Test Class: SubmitDevAppsForApproval
     * Description:
     *
     * Change history:
     * Changed on: 29-Oct-2013
     * Changed by: Rajesh Krishnaiah
     * Description: Enabled any user to submit the device app for approval.
     *              (Removed profile based restriction from the constructor)
     */

    private List<DeviceApplicationAssoc__c> allAvailableDevApps;
    private List<DeviceApplicationAssoc__c> preSelectedDevAppList;
    private Map<Id, DeviceApplicationAssoc__c> preSelectedDevAppMap;

    public List<cDevApp> cDevAppList {get; set;}
    public Boolean DisplaySelectionError {
        get{
            if(DisplaySelectionError == null) { DisplaySelectionError = false; }
            return  DisplaySelectionError;
        }
        set;
        }
    
    private Boolean submitted;

    List<Profile> profiles;
    private Boolean selectAll = false;

    public SubmitDevAppsForApproval(ApexPages.StandardSetController controller) {       
        
        submitted = false;
        preSelectedDevAppList = controller.getSelected();
        preSelectedDevAppMap = new Map<Id, DeviceApplicationAssoc__c>(preSelectedDevAppList);

        fillcDevAppList();
    
    }
    
    public Boolean getDeviceCancelled(){
        transient Map<String,String> keyPrefixMap = SystemMethods.getPrefixNameObjectMap();
        String devId = ApexPages.currentPage().getParameters().get('Id');
        if(keyPrefixMap.get(devId.subString(0,3)) == 'Device__c'){
            if([SELECT Id, Cancelled__c FROM Device__c WHERE Id =: devId].Cancelled__c == true){
                return true;
            }
        }
        return false;
    }
    

    public Boolean getShowMainWindow(){
        if(!getDeviceCancelled()){
            return true;
        }
        return false;
    }
     
    public void selectAll() {
        if(!selectAll){
             for(cDevApp entry : cDevAppList){
                entry.selected = true;
             }
        } else {
            for(cDevApp entry : cDevAppList){
                entry.selected = false;
             }
        }
        selectAll = !selectAll;
    }
    
    public PageReference submit(){
        submitted = true;
        
        List<Approval.ProcessSubmitRequest> requests = new List<Approval.ProcessSubmitRequest>();
        List<Approval.ProcessResult> results;
        Approval.ProcessSubmitRequest req;
        for(cDevApp da : cDevAppList){
            if(da.selected == true){
                // Create an approval request for the DevApp  
                req = new Approval.ProcessSubmitRequest();
                req.setObjectId(da.devAppId);
                requests.add(req);
            }
        }
         if(requests.size() == 0) { return null; }
        //try{
            // Submit the approval request for the account              
        results = Approval.process(requests, false);
        /*}
        catch(System.DmlException e){
            system.debug('inside catch');
        } */
                    
        for(Approval.ProcessResult result : results){
            if(!result.isSuccess()){
                fillcDevAppList();
                DisplaySelectionError = true;
                return null;
            }
        }
        
        return cancel();
        
    }
    
    public PageReference cancel(){
        try{
            PageReference pr = new PageReference(ApexPages.currentPage().getParameters().get('retURL'));
            pr.setRedirect(true);
            return pr;
        }
        catch(System.NullPointerException e){
            return ApexPages.currentPage();
        }       
    }
        
    private void fillcDevAppList(){
        transient Map<String,String> keyPrefixMap = SystemMethods.getPrefixNameObjectMap();
        String Id = ApexPages.currentPage().getParameters().get('Id');
        // Use record id to determine type
        if(keyPrefixMap.get(Id.subString(0,3)) == 'Device__c'){
            allAvailableDevApps = [SELECT id, name, device__c, device__r.name, application__c, application__r.name, Approval_Status__c FROM DeviceApplicationAssoc__c WHERE (Approval_Status__c='Not Submitted' OR Approval_Status__c='Rejected') AND device__c =: Id AND Include_in_BOM__c = true];         
        } else {
            allAvailableDevApps = [SELECT id, name, device__c, device__r.name, application__c, application__r.name, Approval_Status__c FROM DeviceApplicationAssoc__c WHERE (Approval_Status__c='Not Submitted' OR Approval_Status__c='Rejected') AND application__c =: Id AND Include_in_BOM__c = true];
        }       
        
        cDevAppList = new List<cDevApp>();
        
        if(preSelectedDevAppMap.size() != 0){
            for(DeviceApplicationAssoc__c devApp : allAvailableDevApps){
                if(preSelectedDevAppMap.keySet().contains(devApp.Id)){
                    cDevAppList.add(new cDevApp(devApp.Id, devApp.Name, devApp.Device__c, devApp.Device__r.Name, devApp.Application__c, devApp.Application__r.Name, devApp.Approval_Status__c, true));
                } else {
                    cDevAppList.add(new cDevApp(devApp.Id, devApp.Name, devApp.Device__c, devApp.Device__r.Name, devApp.Application__c, devApp.Application__r.Name, devApp.Approval_Status__c, false));
                }
            }
        } else {
            for(DeviceApplicationAssoc__c devApp : allAvailableDevApps){
                cDevAppList.add(new cDevApp(devApp.Id, devApp.Name, devApp.Device__c, devApp.Device__r.Name, devApp.Application__c, devApp.Application__r.Name, devApp.Approval_Status__c, false));
            }
        }           
        
    }
    
    public class cDevApp{
        public Id devAppId {get; set;}
        public String devAppName {get; set;}
        public Id deviceId {get; set;}
        public String deviceName {get; set;}
        public Id applicationId {get; set;}
        public String applicationName {get; set;}
        public String approvalStatus {get; set;}
        public Boolean selected {get; set;}
        
        public cDevApp(Id daId, String daName, Id dId, String dName, Id aId, String aName, String status, Boolean selected){
            devAppId = daId;
            devAppName = daName;
            deviceId = dId;
            deviceName = dName;
            applicationId = aId;
            applicationName = aName;
            approvalStatus = status;
            this.selected = selected;
        }
    }
    
    
    public static testMethod void testSubmitDevAppsForApproval(){
        List<DeviceApplicationAssoc__c> DAlist = [SELECT id, Device__c, Application__c FROM DeviceApplicationAssoc__c WHERE Approval_Status__c = 'Not Submitted' LIMIT 1];
        ApexPages.StandardSetController setCon = new ApexPages.StandardSetController(DAlist);
        setCon.setSelected(DAlist); 
        ApexPages.currentPage().getParameters().put('Id', DAlist[0].Device__c);
        SubmitDevAppsForApproval dafa = new SubmitDevAppsForApproval(setCon);
        //List<DeviceApplicationAssoc__c> devApps = dafa.getDevApps();

        //Boolean test2 = dafa.DisplaySelectionError;


        //List<DeviceApplicationAssoc__c> list1 = dafa.getDeviceApplicationAssoc();
        //List<DeviceApplicationAssoc__c> list2 = dafa.getInvalidSelections();
        PageReference pr = dafa.submit();
        ApexPages.currentPage().getParameters().put('retURL', '/');
        pr = dafa.submit(); 
        dafa = new SubmitDevAppsForApproval(setCon);    
        dafa.cancel();
        
        DAlist = [SELECT id FROM DeviceApplicationAssoc__c WHERE Approval_Status__c='Not Submitted' LIMIT 51];
        setCon = new ApexPages.StandardSetController(DAlist);
        setCon.setSelected(DAlist); 
        dafa = new SubmitDevAppsForApproval(setCon);

        dafa.selectAll();
        dafa.selectAll();
        
        DAlist = [SELECT id FROM DeviceApplicationAssoc__c WHERE Approval_Status__c = 'Approved' LIMIT 1];
        setCon = new ApexPages.StandardSetController(DAlist);
        dafa = new SubmitDevAppsForApproval(setCon);
        //Boolean test5 = dafa.getDisplaySelectionError();
        //Boolean test6 = dafa.gettooManySelected();
        pr = dafa.submit();
        ApexPages.currentPage().getParameters().put('retURL', '/');
        pr = dafa.submit();
    }               
}