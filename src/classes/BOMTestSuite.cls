@isTest
public class BOMTestSuite {

    @isTest
    public static void testBOMDeviceViewController(){

        Device__c d = new Device__c(Device_ID__c='123456',Name='BOM Device');
    	insert d;

        Account a = new Account(Name='testAccount', Tier__c ='1');
        insert a;

        List<Application__c> apps = new List<Application__c>();
        Application__c app1 = new Application__c(Name='app1', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        Application__c app2 = new Application__c(Name='app2', Account__c=a.Id, Application_Type__c='Preload', Application_Sub_Type__c='faketype', Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);
        
        
        insert new List<Application__c>{app1, app2};
        
        Stable__c s1 = new Stable__c(Name='s1');
        //Stable__c s2 = new Stable__c(Name='s2');
        insert s1;

        Stable_Application__c sa  = new Stable_Application__c(Stable__c=s1.Id, Application__c=app1.Id, Stable_App_Status__c='Mandatory');
        Stable_Application__c sa2 = new Stable_Application__c(Stable__c=s1.Id, Application__c=app2.Id, Stable_App_Status__c='Mandatory');
        insert new List<Stable_Application__c>{sa, sa2};
            
            
            
        Core_Device_Package__c cdp = new Core_Device_Package__c(Name='cdp');
		insert cdp;
		
		Stable__c s = new Stable__c(Name='s');
		insert s;

		Program__c program=new Program__c(name='Test Program');
		program.Reviewed_Approved__c = 'No';
		Application__c application=new Application__c(name='Test Application',Application_Type__c='Preload',Application_Sub_Type__c='Data');
        
		insert program;
		insert application;
		Program_Application__c programApplication=new Program_Application__c(program__c=program.id,application__c=application.id,description__c='test description',instructions__c='test instructions');
		insert programApplication;
        
		Stable__c stable=new Stable__c(name='Test Stable');
		insert stable;
        
		Stable_Application__c stableApplication=new Stable_Application__c(stable__c=stable.id,application__c=application.id,source_id__c=program.id);
        stableApplication.Stable_App_Status__c = 'Mandatory';
		insert stableApplication;
        
		Core_Device_Package__c coreDevicePackage=new Core_Device_Package__c(name='Test Core Device Package Application');
		insert coreDevicePackage;
        
		Core_Device_Package_Application__c coreDevicePackageApplication=new Core_Device_Package_Application__c(Core_Device_Package__c=coreDevicePackage.id,application__c=application.id,source_id__c=stable.id);
		insert coreDevicePackageApplication;

        BOMDeviceViewController dev = new BOMDeviceViewController();
        
        dev.deviceFilter.internalName = 'BOM Device';
        dev.searchDevices();
		List<BOMGenericWrapper> devWrapper = dev.getDevices();

        //add devices on selected devices        
        dev.getSelectedDevices().addAll(dev.getDevices());
        
        dev.processSelectedDevices();
        dev.removeSelectedDevices();
		
		//add those devices again
        dev.getSelectedDevices().addAll(dev.getDevices());
        dev.processSelectedDevices();
        
        System.debug('devWrapper size='+devWrapper.size());
        System.assertNotEquals(devWrapper,null);
        if(!devWrapper.isEmpty()){
            BOMGenericWrapper device = devWrapper.get(0);
            device.selected = true;
            dev.getSelectedDevices().add(device);
            
            dev.appFilter.appName = 'app';
            
            //searching apps
            dev.searchApps();
            
            List<BOMGenericWrapper> appsWrapper = dev.getApps();
            
            List<BOMGenericWrapper> selectedApps = new List<BOMGenericWrapper>();
            
            for(BOMGenericWrapper appWrapper : appsWrapper){
                appWrapper.selected = true;
                selectedApps.add(appWrapper);
            }
            
            //BOMUtils Test
            List<SObject> sfObjects = BOMUtils.parseWrapperListToSObject(selectedApps);
            List<BOMGenericWrapper> listWrapperTest = BOMUtils.parseSObjectListToWrapper(sfObjects);

            SObject obj1 = sfObjects.get(0);
            BOMGenericWrapper wrapper1 = listWrapperTest.get(0);
			
			//TWO Overloaded methods Methods            
            BOMUtils.contains(sfObjects, obj1);
            BOMUtils.contains(listWrapperTest, wrapper1);
            
            //TWO Overloaded methods Methods  
			BOMUtils.getObjectPosition(sfObjects, obj1);
            BOMUtils.getObjectPosition(listWrapperTest, wrapper1);
            
            BOMUtils.generateInStatement(sfObjects);
            
            System.assertNotEquals(selectedApps, null);
			            
            System.debug('Device name'+device.getDevice().Name);
            
            dev.getSelectedApps().addAll(selectedApps);
            
            dev.removeSelectedApps();
            
            dev.getSelectedApps().addAll(selectedApps);
            
            dev.processSelectedApps();
            
            //stable
            dev.appFilter = new BOMAppFilter();
            dev.appFilter.device.Stable__c = stable.ID;
            
            dev.searchApps();
            
            dev.removeSelectedStables();
            //end stable
            
            //cdp
            dev.appFilter = new BOMAppFilter();
            dev.appFilter.device.Core_Device_Package__c = coreDevicePackage.Id;
            
            dev.searchApps();
            dev.removeSelectedCDPs();
            //end cdp

            //Add CDP and Stable again
            //stable
            dev.appFilter = new BOMAppFilter();
            dev.appFilter.device.Stable__c = stable.ID;
            
            dev.searchApps();
            //end stable
            
            //cdp
            dev.appFilter = new BOMAppFilter();
            dev.appFilter.device.Core_Device_Package__c = coreDevicePackage.Id;
            dev.searchApps();
            //end cdp

            //Program test
            dev.appFilter = new BOMAppFilter();
			dev.appFilter.programApp.Id = programApplication.Id;
            dev.searchApps();
            dev.removeSelectedPrograms();
            //end prgram

            //Program test
            dev.appFilter = new BOMAppFilter();
			dev.appFilter.programApp.Program__c = program.Id;
            dev.searchApps();
            //end prgram
            //
            //
            dev.getStableLines();
            dev.getCorePacks();
            dev.getProgramApps();
            dev.getUpdatedDevices();
            dev.getApprovedDevices();
            dev.getReprovedDevices();
            dev.sendRedirectToSearchDevice();
            dev.sendRedirectToSelectApp();
 
            
            dev.sendRedirectToApprovalDevice();
            
            dev.approveSelectedDevices();
            
            dev.restartFlow();
            
        }
    }
}