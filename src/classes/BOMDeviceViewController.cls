/***
 * Controller class for
 * BOMSearchDevice.vfp
 * BOMSelectApp.vfp
 * BOMApprovalDevice.vfp
 * BOMApprovalDeviceWithProgress.vfp
 * BOMSummaryApprovalDevice.vfp
 * 
 * @author: Jimens Lima
 * @since: 10/03/2014
 */
public with sharing class BOMDeviceViewController {
    
    //Form parameters
    //This attribute represents a POJO Parameter.
    public BOMDeviceFilter deviceFilter {get;set;}
    
    //Form parameter
    //This attribute represents an App Parameter.
    public BOMAppFilter appFilter  {get;set;}
    
    //Device DAO
    private BOMDeviceDAO deviceDAO {get;set;}
    
    //Application DAO
    private BOMApplicationDAO appDAO {get;set;}
    
    //DeviceApplication DAO
    private BOMDevAppDAO devAppDAO {get;set;}
    
    //Stable DAO
    private BOMStableDAO stableDAO   {get;set;}
    
    //Core_Device_Package__c DAO
    private BOMCoreDevPackDAO cdpDAO {get;set;}

    //Devices Filter Screen
    //Used to display Device and Selected Device List Views
    public Boolean hasDevices          {get;set;}
    public Boolean hasSelectedDevices  {get;set;}

    //Devices Filter Screen
    //Used to display Apps and Selected Apps in the List Views
    public Boolean hasApps          {get;set;}
    public Boolean hasSelectedApps  {get;set;}
    
    //The selected device Id on datagrid.
    public String selectedDeviceId {get;set;}
    
    //The selected App Id on datagrid.
    public String selectedAppId    {get;set;}
    
    //Initial device on search result - Used on Screen 1.1
    private List<BOMGenericWrapper> devices;

    //Selected Devices on Data Grid   - Used on Screen 1.1
    private List<BOMGenericWrapper> selectedDevices;

    //Initial apps on search result   - Used on Screen 1.2
    private List<BOMGenericWrapper> apps;
    
    //Selected apps on Data Grid 	  - Used on Screen 1.2
    private List<BOMGenericWrapper> selectedApps;
    public Boolean canSubmitApps	   {get;set;}
    
    //Final List of Devices to Approve.
    private List<BOMGenericWrapper> updatedDevices;

    //Summary List of Approved Devices.
    private List<BOMGenericWrapper> approvedDevices;
    public Boolean hasApprovedDevices {get;set;}
    
    //Summary List of Reproved Devices.
    private List<BOMGenericWrapper> reprovedDevices;
    public Boolean hasReprovedDevices {get;set;}
    
    //This Map is composed by a Stable__c (as the Key) and a List of Application__c (as the Value)
    private Map<BomGenericWrapper,List<BOMGenericWrapper>> stableLines;
    public Boolean hasStableLines {get;set;}
    
    //This Map is composed by a Core_Device_Package__c (as the Key) and a List of Application__c (as the value)
    private Map<BOMGenericWrapper,List<BOMGenericWrapper>> corePacks;
    public Boolean hasCorePacks {get;set;}
    
    //This Map is composed by a Program__c (as the Key) and a List of Application__c (as the value)
    private Map<BOMGenericWrapper,List<BOMGenericWrapper>> programApps;
    public Boolean hasProgramApps {get;set;}
     
    public Long devAppCurrentPercentage     {get;set;} //Used in BOMApprovalDeviceWithProgress
    public Boolean isDevAppActionPollerEnabled {get;set;} //Used in BOMApprovalDeviceWithProgress
    
    private BOMDevAppResult devAppResult;
    
    //Variables to show the number of apps loaded on screen
    public Integer programAppsSize {get;set;}
    public Integer stableAppsSize {get; set;}
    public Integer coreDeviceAppsSize {get; set;}
    
	//Default constructor
    public BOMDeviceViewController(){
        appDAO         = new BOMApplicationDAO();
        deviceDAO      = new BOMDeviceDAO();
        devAppDAO      = new BOMDevAppDAO();
        stableDAO      = new BOMStableDAO();
        cdpDAO		   = new BOMCoreDevPackDAO();
        deviceFilter   = new BOMDeviceFilter();
        appFilter      = new BOMAppFilter();
        resetEntireFlow();
    }

    //A Generic list with Device__c 
    public List<BOMGenericWrapper> getDevices(){
        return devices;
    }
    
    //A Generic list with selected Device__c
    public List<BOMGenericWrapper> getSelectedDevices(){
        return selectedDevices;
    }
    
    //A Generic List with Application__c
    public List<BOMGenericWrapper> getApps(){
        return apps;
    }
    
    //A generic List with selected Application__c
    public List<BOMGenericWrapper> getSelectedApps(){
        return selectedApps;
    }

    //This Map is composed a Stable__c (as the Key) and a List of Application__c (as the Value)
    public Map<BOMGenericWrapper,List<BOMGenericWrapper>> getStableLines(){
        return stableLines;
    }

    //This Map is composed by a Core_Device_Package__c (as the Key) and a List of Application__c (as the value)
    public Map<BOMGenericWrapper,List<BOMGenericWrapper>> getCorePacks(){
        return corePacks;
    }
    
    //This Map is composed by a Program__c (as the Key) and a List of Application__c (as the value)
    public Map<BOMGenericWrapper,List<BOMGenericWrapper>> getProgramApps(){
        return programApps;
    }
    
    //A List of selected Device__c on Screen BOMApprovalDevice 
    public List<BOMGenericWrapper> getUpdatedDevices(){
        return updatedDevices;
    }
    
    //A List of approved Device__c on Screen BOMSummaryApprovalDevice	
    public List<BOMGenericWrapper> getApprovedDevices(){
        return approvedDevices;
    }
    
    
    //A List of approved Device__c on Screen BOMSummaryApprovalDevice	
    public List<BOMGenericWrapper> getReprovedDevices(){
        return reprovedDevices;
    }
    
	/**
	 * Reset the entire flow filters.
	 */    
    private void resetFilters(){
        deviceFilter   = new BOMDeviceFilter();
        appFilter      = new BOMAppFilter();
    }
    
    /***
     * Reset entire objects used on BOM Flow 
     */ 
    private void resetEntireFlow(){
        deviceFilter    = new BOMDeviceFilter(); 		 //BOMSearchDevice
        appFilter       = new BOMAppFilter();   		 //BOMSelectApp	
        devices         = new List<BOMGenericWrapper>(); //BOMSelectApp
        selectedDevices = new List<BOMGenericWrapper>(); //BOMSearchDevice
        apps            = new List<BOMGenericWrapper>(); //BOMSelectApp
        selectedApps    = new List<BOMGenericWrapper>(); //BOMSelectApp
        updatedDevices  = new List<BOMGenericWrapper>(); //BOMApprovalDevice
        approvedDevices = new List<BOMGenericWrapper>(); //BOMSummaryApprovalDevice 
        reprovedDevices = new List<BOMGenericWrapper>(); //BOMSummaryApprovalDevice 

        stableLines     = new Map<BOMGenericWrapper,List<BOMGenericWrapper>>(); //BOMSelectApp
        corePacks       = new Map<BOMGenericWrapper,List<BOMGenericWrapper>>(); //BOMSelectApp
        programApps     = new Map<BOMGenericWrapper,List<BOMGenericWrapper>>(); //BOMSelectApp
        
        //Screen Flags
        hasDevices         = FALSE;//BOMSearchDevice
        hasSelectedDevices = FALSE;//BOMSearchDevice

        hasApps 		   = FALSE;//BOMSelectApp
        hasSelectedApps    = FALSE;//BOMSelectApp
        hasCorePacks       = FALSE;//BOMSelectApp
		hasStableLines     = FALSE;//BOMSelectApp
        hasProgramApps     = FALSE;//BOMSelectApp
		
        canSubmitApps      = FALSE;//BOMSelectApp
        hasApprovedDevices = FALSE;//BOMSummaryApprovalDevice
        hasReprovedDevices = FALSE;//BOMSummaryApprovalDevice
        
    }
    
    /**
     * Handle the search device button on screen BOMSearchDevice.
     */
    public void searchDevices(){
        try{
            List<Device__c> localDevices = deviceDAO.searchDevices(deviceFilter);
            devices = new List<BOMGenericWrapper>();
            if(!localDevices.isEmpty()){
				devices = BOMUtils.parseSObjectListToWrapper(localDevices);
                hasDevices = TRUE;
            }else{
                hasDevices = FALSE;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No records were found based on your criteria.'));
            }
            
            resetFilters();
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        }
    }
    
    /**
     * 
     * Handle search App button on screen BOMSelectApp
     */
    public void searchApps(){

        try{
            List<BOMGenericWrapper> genericAppsWrapper = new List<BOMGenericWrapper>();

            if(!appFilter.isEmpty()){

                if(!String.isEmpty(appFilter.appName)){
                 	
                    populateAppList(appFilter);
                    
                }else if(appFilter.device.Stable__c!=null){
                    apps = new List<BOMGenericWrapper>();
                    hasApps = FALSE;
                    populateStable(appFilter); 
                   
                }else if(appFilter.device.Core_Device_Package__c!=null){
                    apps = new List<BOMGenericWrapper>();
                    hasApps = FALSE;
				    populateCDP(appFilter);
                    
                }else if(appFilter.programApp.Program__c!=null){
                    apps = new List<BOMGenericWrapper>();
                    hasApps = FALSE;
					populateProgramApp(appFilter);                    
                }

                resetFilters();
            }else{
                throw new ApplicationException('Please fill App Filters');
            }
            
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()));
        }
    }
    
    //Populate App List view on Screen BOMSelectApp
    private void populateAppList(BOMAppFilter appFilter){
                    
        List<Application__c> filteredApps = appDAO.searchAppsByFilter(appFilter);
        
        if(!filteredApps.isEmpty()){
            hasApps = TRUE;
            
            List<BOMGenericWrapper> appGenericWrapper = new List<BOMGenericWrapper>();
            
            for(Application__c app : filteredApps){
                Boolean isAppAvailable = app.Available_For_Use__c;
                BOMGenericWrapper appGenWrapper = new BOMGenericWrapper(app);
                if(isAppAvailable==null || !isAppAvailable){
                    appGenWrapper.disableCheck = true;
                }
                appGenericWrapper.add(appGenWrapper);
            }
            
            apps = appGenericWrapper;
        }else{
            hasApps = FALSE;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'No records were found based on your criteria.'));
        }
    }
    
    //Populate stable List view on Screen BOMSelectApp
    private void populateStable(BOMAppFilter appFilter){
        
        Stable__c stable = stableDAO.searchByID(appFilter.device.Stable__c);
        if(stable!=null){
            
            //Right now, the current relationship between Device__c and Stable__c is (One to One).
            //But, in the future, should be (One to Many).
            //if(stableLines==null){
                stableLines = new Map<BOMGenericWrapper,List<BOMGenericWrapper>>();
            //}
            
            BOMGenericWrapper stableWrapper = new BOMGenericWrapper(stable);

            if(!BOMUtils.contains(stableLines.keySet(), stableWrapper)){
                List<BOMGenericWrapper> applications = appDAO.searchByStableLine(stable.Id);
                if(applications!=null && !applications.isEmpty()){
                    stableLines.put(stableWrapper, applications);
                    canSubmitApps = TRUE;
                    stableAppsSize = applications.size();
                }
            }else{
                throw new ApplicationException('You already have selected this Stable.');
            }
            
            hasStableLines = TRUE;
        }else{
            hasStableLines = FALSE;
            throw new ApplicationException('No records were found based on your criteria');
        }
    }
    
    /**
     * @param appFilter - Filter with Program__c filled.
     * 
     * Populate ProgramApp list on BOMSelectApp Screen
     */
    private void populateProgramApp(BOMAppFilter appFilter){

        Program__c program = appDAO.searchProgramByID(appFilter.programApp.Program__c);
        
        if(program!=null){
            if(program.Reviewed_Approved__c.equals('No')){
                throw new ApplicationException('Program not allowed. It have to be Reviewed & Approved.');
            }
            if(programApps==null){
            	programApps = new Map<BOMGenericWrapper,List<BOMGenericWrapper>>();
            }
            
            BOMGenericWrapper programWrapper = new BOMGenericWrapper(program);
            
            if(!BOMUtils.contains(programApps.keySet(), programWrapper)){
               List<BOMGenericWrapper> applications = appDAO.searchAppsByProgram(program.Id);
               if(applications!=null && !applications.isEmpty()){
                   programApps.put(programWrapper, applications);
                   canSubmitApps = TRUE;
                   programAppsSize = 0;
                   for(List<BOMGenericWrapper> apps : programApps.values()){
                        programAppsSize += apps.size();
                   }
               }
            }else{
                throw new ApplicationException('You already have selected this Program.');
            }


            hasProgramApps = TRUE;
        }else{
            hasProgramApps = FALSE;
            throw new ApplicationException('No records were found based on your criteria.');
        }
    }
    
    //Populate CDP List view on Screen BOMSelectApp
    private void populateCDP(BOMAppFilter appFilter){

        Core_Device_Package__c cdp = cdpDAO.searchByID(appFilter.device.Core_Device_Package__c);
        if(cdp!=null){
            
            //Right now, the current relationship between Device__c and Core_Device_Package__c is (One to One).
            //But, in the future, should be (One to Many).
            //if(corePacks==null){
                corePacks = new Map<BOMGenericWrapper,List<BOMGenericWrapper>>();
            //}
            
            BOMGenericWrapper cdpWrapper = new BOMGenericWrapper(cdp);
            
             if(!BOMUtils.contains(corePacks.keySet(), cdpWrapper)){
                List<BOMGenericWrapper> applications = appDAO.searchAppsByCoreDevicePackage(cdp.Id);
                if(applications!=null && !applications.isEmpty()){
                    corePacks.put(cdpWrapper, applications);
                    canSubmitApps = TRUE;
                    coreDeviceAppsSize = applications.size();
                }
            }else{
                throw new ApplicationException('You already have selected this Core Dev Pack.');
            }

            hasCorePacks = TRUE;
        }else{
            hasCorePacks = FALSE;
            throw new ApplicationException('No records were found based on your criteria.');
        }
    }
    
    
    /**
     * Process selected devices on screen BOMSearchDevice.
     */
    public void processSelectedDevices(){
        
        try{
            
            if(selectedDevices==null || selectedDevices.isEmpty()){
                selectedDevices = new List<BOMGenericWrapper>();
            }
            
            if(!devices.isEmpty()){
                
                Integer numberOfSelectedDevices = 0;

                List<BOMGenericWrapper> devicesToRemove = new List<BOMGenericWrapper>();
                
                //validate if a device was added on selected devices list
                if(!selectedDevices.isEmpty()){
                    for(BOMGenericWrapper deviceWrapper: devices){
                        if(deviceWrapper.isSelected()){
                            Boolean existsOnSelectedDev = BOMUtils.contains(selectedDevices, deviceWrapper);
                            
                            if(existsOnSelectedDev){
                                throw new ApplicationException('Duplicated entries were not added to the selected devices, but the others were.');
                            }
                        }
                    }
                }
                
                for(BOMGenericWrapper deviceWrapper: devices){
                    if(deviceWrapper.isSelected()){
                        
                        numberOfSelectedDevices++;
                        BOMGenericWrapper wrapper = new BOMGenericWrapper(deviceWrapper.sfObject);
                        selectedDevices.add(wrapper);
                        devicesToRemove.add(deviceWrapper);
                    }
                }
                
                //validate if on devices list contains at least one selected device.
                if(numberOfSelectedDevices==0){
                    throw new ApplicationException('Please select at least one Device');                    
                }
                
                for(BOMGenericWrapper devWrapper: devicesToRemove){
                    BOMUtils.removeFromList(devices,devWrapper);
                }
                
                if(devices.isEmpty()){
                    hasDevices = FALSE;
                }
                
                hasSelectedDevices = TRUE;
            }
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        }
    }
    
    /**
     * Handle remove device action on Screen BOMSearchDevice.
     */
    public void removeSelectedDevices(){
        
        try{

            if(selectedDevices!=null && !selectedDevices.isEmpty()){

                List<BOMGenericWrapper> selectedDevicesToRemove = new List<BOMGenericWrapper>();
                for(BOMGenericWrapper deviceWrapper: selectedDevices){
                    
                    if(deviceWrapper.isSelected()){
                        
                        BOMGenericWrapper wrapper = new BOMGenericWrapper(deviceWrapper.sfObject);
                        devices.add(wrapper);
                        selectedDevicesToRemove.add(wrapper);
                    }
                }
                
                //validate if on devices list contains at least one selected device.
                if(selectedDevicesToRemove.isEmpty()){
                    throw new ApplicationException('Please select at least one Device');                    
                }
                
                //removes selected elements from selected devices.
                for(BOMGenericWrapper deviceWrapper: selectedDevicesToRemove){
                    Integer position = BOMUtils.getObjectPosition(selectedDevices,deviceWrapper);
                    if(position!=-1){
                        selectedDevices.remove(position);
                    }
                }
                
                if(!devices.isEmpty()){
                    hasDevices = TRUE;
                }
                
                if(selectedDevices.isEmpty()){
                    hasSelectedDevices = FALSE; 
                }
            }
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        }
    }

    /**
     * Process Apps devices on screen BOMSelectApp.
     */
    public void processSelectedApps(){
        
        try{
            
            if(selectedApps==null || selectedApps.isEmpty()){
                selectedApps = new List<BOMGenericWrapper>();
            }
            
            if(!apps.isEmpty()){
                
                if(!selectedApps.isEmpty()){
                    for(BOMGenericWrapper appWrapper: apps){
                        if(appWrapper.isSelected()){
                            Boolean existsOnSelectedApps = BOMUtils.contains(selectedApps, appWrapper);
                            
                            if(existsOnSelectedApps){
                                throw new ApplicationException('Duplicated entries were not added to the selected Apps, but the others were.');
                            }
                        }
                    }
                }
                
                List<BOMGenericWrapper> appsToRemove = new List<BOMGenericWrapper>();
                for(BOMGenericWrapper appWrapper: apps){
                    if(appWrapper.isSelected()){
                        BOMGenericWrapper wrapper = new BOMGenericWrapper(appWrapper.sfObject);
                        selectedApps.add(wrapper);
                        appsToRemove.add(appWrapper);
                    }
                }
                
                //validate if contains at least one selected App on Apps list.
                if(appsToRemove.isEmpty()){
                    throw new ApplicationException('Please select at least one App');                    
                }
                
                for(BOMGenericWrapper appWrapper: appsToRemove){
                    BOMUtils.removeFromList(apps,appWrapper);
                }
                
                if(apps.isEmpty()){
                    hasApps = FALSE;
                }
                
                hasSelectedApps = TRUE;
                canSubmitApps   = TRUE;
            }
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        }
    }

    /**
     * Verify is the page is available to submit apps.
     */
    private void canSubmitApps(){
        if(selectedApps.isEmpty() && stableLines.isEmpty() && corePacks.isEmpty()){
            canSubmitApps = false;
        }else{
            canSubmitApps = true;
        }
    }
    
    /**
     * Handle remove device action on Screen BOMSearchDevice.
     */
    public void removeSelectedApps(){
        
        try{

            if(selectedApps!=null && !selectedApps.isEmpty()){

                List<BOMGenericWrapper> selectedAppsToRemove = new List<BOMGenericWrapper>();
                for(BOMGenericWrapper appWrapper: selectedApps){
                    
                    if(appWrapper.isSelected()){

                        BOMGenericWrapper wrapper = new BOMGenericWrapper(appWrapper.sfObject);
                        apps.add(wrapper);
                        
                        selectedAppsToRemove.add(wrapper);
                    }
                }
                
                //validate if on devices list contains at least one selected App.
                if(selectedAppsToRemove.isEmpty()){
                    throw new ApplicationException('Please select at least one App');                    
                }
                
                //removes selected elements from selected apps.
                for(BOMGenericWrapper appWrapper: selectedAppsToRemove){
                    Integer position = BOMUtils.getObjectPosition(selectedApps,appWrapper);
                    if(position!=-1){
                        selectedApps.remove(position);
                    }
                }
                
                if(!apps.isEmpty()){
                    hasApps = TRUE;
                }
                
                if(selectedApps.isEmpty()){
                    hasSelectedApps = FALSE;
                }
                
                
            }
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        }
    }
    
    /**
     * Handle remove Stables action on Screen BOMSelectApp.
     */
    public void removeSelectedStables(){
        
        try{

            if(stableLines!=null && !stableLines.isEmpty()){

                stableLines.clear();
                hasStableLines = FALSE;
                
                canSubmitApps();
            }
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        }
    }
    
    /**
     * Handle remove CDP's action on Screen BOMSelectApp.
     */
    public void removeSelectedCDPs(){
        
        try{

            if(corePacks!=null && !corePacks.isEmpty()){

                corePacks.clear();
                hasCorePacks = FALSE;
                
                canSubmitApps();
            }
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        }
    }
    
    
    /**
     * Handle remove Program action on Screen BOMSelectApp.
     */
    public void removeSelectedPrograms(){
        
        try{

            List<BOMGenericWrapper> selectedProgToRemove = new List<BOMGenericWrapper>();
            for(BOMGenericWrapper programWrapper: programApps.keySet()){
                
                if(programWrapper.isSelected()){
                    selectedProgToRemove.add(programWrapper);
                }
            }
            
            //validate if on selected Program list contains at least one Program.
            if(selectedProgToRemove.isEmpty()){
                throw new ApplicationException('Please select at least one Program');                    
            }
            
            //removes selected elements from selected apps.
            for(BOMGenericWrapper programWrapper: selectedProgToRemove){
                programApps.remove(programWrapper);
            }
            
            if(!programApps.isEmpty()){
                hasProgramApps = TRUE;
            }else{
                hasProgramApps = FALSE;
            }
            
            canSubmitApps();
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        }
    }
    
    /*
     * Redirect to BOMSearchDevice - Screen 1.1
     * This method is used to control page flow.
     */
    public Pagereference sendRedirectToSearchDevice(){
        return Page.BOMSearchDevice;
    }
    
    /*
     * Submit current page data to BOMSelectApp - Screen 1.2
     * This method is used to control page flow.
     */
    public Pagereference sendRedirectToSelectApp(){
        return Page.BOMSelectApp;
    }
    
    /**
     * Submit current page data to DevApp Approval
     */
    public PageReference sendRedirectToApprovalDevice(){
        
        try{
            return createDevApp();
        }catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage()); 
            ApexPages.addMessage(msg);
        }
        
        return null;
    }

     /**
     * Creates DevApp Junction Data.
     */
    private PageReference createDevApp(){
        
        try{
          
            if(selectedApps.isEmpty() && stableLines.isEmpty() && corePacks.isEmpty() && programApps.isEmpty()){
                throw new ApplicationException('Please talk with Salesforce Admin');
            }
            
            //1st step - Filter Approval List
            List<BOMApplicationApproval> appApprovals = appDAO.getAutoApproval(selectedApps, stableLines, corePacks,programApps);
            
            Set<ID> appsIds = new Set<ID>();
            for(BOMApplicationApproval appApproval : appApprovals){
				appsIds.add(appApproval.application.ID);
            }
                  
            List<Device__c> tempDevices   = null;
            List<Stable__c> tempStables   = null;
            List<Program__c> tempPrograms = null;
            List<Core_Device_Package__c> tempCorePacks = null;

            if(selectedDevices!=null && !selectedDevices.isEmpty()){
                tempDevices = BOMUtils.parseWrapperListToSObject(selectedDevices);
            }
            
            if(stableLines!=null){
            	tempStables = BOMUtils.parseWrapperListToSObject(stableLines.keySet());
            }
            
            if(corePacks!=null && !corePacks.isEmpty()){
                tempCorePacks = BOMUtils.parseWrapperListToSObject(corePacks.keySet());
            }
            
            if(programApps!=null && !programApps.isEmpty()){
				tempPrograms = BOMUtils.parseWrapperListToSObject(programApps.keySet());                
            }
            
            //2nd step - update selected devices with selected stable and core device packages.
            deviceDAO.updateDeviceWithCoreAndStables(tempDevices, tempStables, tempCorePacks,tempPrograms);
            
            //3rd step - create DevApp Junction based on Approval List
            devAppResult = devAppDAO.createDevAppJunction(tempDevices, appApprovals);

            //Final Step - Filter the updated devices and your status.
            String inStmt = BOMUtils.generateInStatement(tempDevices);
            List<Device__c> tempUpdatedDevices = deviceDAO.searchDevicesByInStmt(inStmt);
            
            //Device list with a final status for approval
            updatedDevices = getDevicesToApprove(tempUpdatedDevices);
             
            if(devAppResult.getCount()>90){
                updatePercentage();
                isDevAppActionPollerEnabled = true;
                return Page.BOMApprovalDeviceWithProgress;
            }
            

        }catch(Exception e){
            throw e;
        }
        
        return Page.BOMApprovalDevice;
    }
    
    /**
	 * Refresh device list on BOMApprovalDeviceWithProgress page.
     */
    public PageReference refreshDevices(){
        try{
            
			List<Device__c> devices = BOMUtils.parseWrapperListToSObject(updatedDevices);
            String inStmt 		    = BOMUtils.generateInStatement(devices);
            devices 	   			= deviceDAO.searchDevicesByInStmt(inStmt);
            updatedDevices 		    = getDevicesToApprove(devices);

            updatePercentage();
						
        }catch(Exception e){
			System.debug('BOMDeviceViewController.refreshDevices: '+e.getStackTraceString());
        }
        
        return null;
    }
	
	/**
	 * Uptade the percentage of created DevApps, upon Devices and Apps
	 */    
    private void updatePercentage(){
        try{
            devAppCurrentPercentage = devAppDAO.getPercentageOfJobsDone(devAppResult.numberOfJobs,devAppResult.scheduledTime);
            
            if(devAppCurrentPercentage>=100){
                isDevAppActionPollerEnabled = false;
                devAppCurrentPercentage = 100;
            }
        }catch(Exception e){
			System.debug('updatePercentage '+BOMUtils.getStackTrace(e));            
        }
    }
    
    /**
     * @return A List of BOMGenericWrapper where apps on Device__c level is 100% approved.
     */
    private List<BOMGenericWrapper> getDevicesToApprove(List<Device__c> devices){
        try{
			List<BOMGenericWrapper> devicesToApprove = new List<BOMGenericWrapper>();
            
            if(devices!=null && !devices.isEmpty()){
                
                for(Device__c device: devices){
					BOMGenericWrapper wrapper = new BOMGenericWrapper(device);
                    
                    //If the number of Approved Apps on Device
                    //is less then 100, this Device can not be approved.
                    if(device.of_Apps_Approved_on_BOM__c<100){
                        wrapper.disableCheck = TRUE;
                    }else{
                        wrapper.selected = TRUE;
                    }
                    devicesToApprove.add(wrapper);
                }
            }
            return devicesToApprove;
        }catch(Exception e){
			throw e;            
        }
        return null;
    }
    
    
    /**
     * Approve selected Devices on Screen BOMApprovalDevApp
     */
    public PageReference approveSelectedDevices(){
        try{
            
            if(approveDevices()){
                return Page.BOMSummaryApprovalDevice;
            }
            
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage())); 
        }
        
        return null;
    }
    
    /**
     * Approve selected Devices on Screen BOMApprovalDevApp
     */
    public PageReference restartFlow(){
        try{
            resetEntireFlow();
            return Page.BOMSearchDevice;
        }catch(Exception e){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, e.getMessage())); 
        }
        
        return null;
    }
    
    /**
     * Approve selected devices that are 100% on field of_Apps_Approved_on_BOM__c
     */
    private boolean approveDevices(){
        
        try{
            if(updatedDevices!=null && !updatedDevices.isEmpty()){
                
                List<BOMGenericWrapper> selectedDevWrappersToApprove = BOMUtils.getSelection(updatedDevices);
                
                reprovedDevices = BOMUtils.getNonSelection(updatedDevices);
                
                if(!reprovedDevices.isEmpty()){
                    hasReprovedDevices = TRUE;
                }
                
                if(!selectedDevWrappersToApprove.isEmpty()){
                    List<Device__c> selectedDevices = BOMUtils.parseWrapperListToSObject(selectedDevWrappersToApprove);
                    deviceDAO.approveDevices(selectedDevices);
                    approvedDevices = BOMUtils.parseSObjectListToWrapper(selectedDevices);
                    hasApprovedDevices = TRUE;
                }
                
                return true;
            }
        }catch(Exception e){
            throw e;
        }
        
        return false;
    }
}