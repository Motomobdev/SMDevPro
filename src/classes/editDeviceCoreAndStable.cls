public with sharing class editDeviceCoreAndStable {
        
    private Device__c device;
    private Device__c originalDevice;
    private Core_Device_Package__c newCore;
    private Core_Device_Package__c originalCore;
    
    public Boolean disableCore {get; set;}
    public Boolean disableStable {get; set;}
        
    boolean originalStableCameFromOriginalCore;
    boolean newStableCameFromNewCore;
        
    private Id originalCoreId;
    private Id originalStableId;
    
    private Stable__c originalStable;
    
    public Boolean showUpdateError {get; set;}
    public String updateError {get; set;}

    public editDeviceCoreAndStable(ApexPages.StandardController controller){               
        device = [SELECT Id, Core_Device_Package__c, Stable__c, Name, 
                  	SWBOM_Reviewed_and_Approved__c 
                  FROM Device__c WHERE Id = :ApexPages.currentPage().getParameters().get('Id')];
        originalDevice = device;
        system.debug('originalStableId FROM VERY BEGINING: ' + device.Stable__c);
        if (device.SWBOM_Reviewed_and_Approved__c != 'Yes'){       
        	disableCore = false; 
	        if (device.Core_Device_Package__c != null) { 
                originalCore = [SELECT Id, Stable__c FROM Core_Device_Package__c 
                                WHERE Id =: device.Core_Device_Package__c];
                newCore = originalCore;
	        }
	
	        if(originalCore != null && originalCore.Stable__c != null){        	
	            // the orignal core's stable is the stable on the device
	            disableStable = true;              
	            originalStableId = originalcore.Stable__c;
	            originalStableCameFromOriginalCore = true;
	        } else {
	        	disableStable = false;
	        	originalStableCameFromOriginalCore = false;
	            if(device.Stable__c != null){
	                // the device had a stable that is not a part of the original core
	                originalStableId = device.Stable__c;
	            }
	        }
	        
	        showUpdateError = false;
	        updateError = null;
        } else {
        	disableStable = true;
        	disableCore = true;
        }
    }
    
    public Boolean getIsDeviceSWApproved(){
    	if(device.SWBOM_Reviewed_and_Approved__c == 'Yes'){
    		return true;
    	}
    	return false;
    }
        
    public void newCore(){
        system.debug('NEW CORE BEFORE NEWCORE(): ' + newCore);
        if(device.Core_Device_Package__c != null){
            newCore = [SELECT Id, Stable__c FROM Core_Device_Package__c 
                       WHERE Id =: device.Core_Device_Package__c];
            if(newCore.Stable__c != null){
            	device.Stable__c = newCore.Stable__c;
            	newStableCameFromNewCore = true;
            	disableStable = true;
            }
        } else {
        	newCore = null;
        	if (disableStable == true){
        		disableStable = false;
        		device.Stable__c = null;
        	}
        }    
    }
    
    public void newStable(){
        if(device.Stable__c != null){
        	system.debug('this is device.Stable__c' + device.Stable__c);
			newStableCameFromNewCore = false;
        }
    }

    public Device__c getDevice(){
        return device;
    }

    public PageReference mySave(){

        newCore();
        newStable();
        
        system.debug('SAVE');
        system.debug('device.core' + device.Core_Device_Package__c);
        system.debug('newCore: ' + newCore);
        system.debug('originalCore: ' + originalCore);
        system.debug('originalStableId: ' + originalStableId);
        system.debug('device.stable: ' + device.Stable__c);

        showUpdateError = false; // Assume everything executes without any errors
        
        if(device.Stable__c != null){
        	Stable__c s = [SELECT Id, Reviewed_Approved__c 
                           FROM Stable__c WHERE Id =:device.Stable__c];
    		device.Stable__c = s.Id;
            String stableReviewedAndApproved = s.Reviewed_Approved__c;
            system.debug('s.Reviewed_Approved__c: ' + s.Reviewed_Approved__c);
            if (s.Reviewed_Approved__c != 'Yes') {
                showUpdateError = true;
        		updateError = 'This stable is NOT Reviewed & Approved. ' +
                    'Please select a different stable.';
                return null;
            }
        }
   		
   		try{   			
	    	if(disableStable == true){
	    		// The new Core has its own Stable  		
	    		// If there was an original Stable Not a Part of the Original Core remove it
	    		if(!originalStableCameFromOriginalCore && originalStableId != null){
	    			StableDeviceMethods.removeStableElementsFromDevice(originalDevice, originalStableId);
	    		}
	    		
	    		if(newCore != null){
		            if(originalCore == null){
		                system.debug('ADD NEW CORE');
		                // new core has been selected
		                // add core to device
		                CoreDeviceMethods.addCoreElementsToDevice(device);
		            }
		            if(originalCore != null && originalCore.Id != newCore.Id){  
			    		// remove original core
			    		CoreDeviceMethods.removeCoreDevicePackageElementsFromDevice(device, originalCore);
			    		// add new core
			    		CoreDeviceMethods.addCoreElementsToDevice(device);
		            } else if(newCore == null && originalCore != null){
			            // remove core from device
			            CoreDeviceMethods.removeCoreDevicePackageElementsFromDevice(device, originalCore);
			        }
	    		}		
	    	} else if(disableStable == false){
	    		
	    		// The new Core does not have its own stable, and stable has changed  		
	    		// If there was an original Stable Not a Part of the Original Core remove it
	    		if(originalStableId != null && 
                   (device.Stable__c == null || device.Stable__c != originalStableId)) {
                    System.debug('Removing stable elements');
	    			StableDeviceMethods.removeStableElementsFromDevice(originalDevice, originalStableId);
	    		}
	    		system.debug('STABLE ID BEFORE METHOD: ' + device.Stable__c);
	    		if (device.Stable__c != null && 
                   device.Stable__c != originalStableId && 
                   (newCore == null || newCore.Stable__c == null)){
                	System.debug('Adding stable elements');
                    StableDeviceMethods.addStableElementsToDevice(device);
	    		}
	    		
	    		system.debug('NEWCORE - ORIGINALCORE: ' + newCore + ', ' + originalCore);
		        if(newCore != null){
		            if(originalCore == null){
		                system.debug('ADD NEW CORE');
		                // new core has been selected
		                // add core to device
		                CoreDeviceMethods.addCoreElementsToDevice(device);
		            }
		            if(originalCore != null && originalCore.Id != newCore.Id){                
	                    // remove original core elements
	                    CoreDeviceMethods.removeCoreDevicePackageElementsFromDevice(device, originalCore);
	                    // add new core 
	                    CoreDeviceMethods.addCoreElementsToDevice(device);
		            }
		        } else if(newCore == null && originalCore != null){
		            // remove core from device
		            system.debug('REMOVE CORE FROM DEVICE');
		            CoreDeviceMethods.removeCoreDevicePackageElementsFromDevice(device, originalCore);
		        }
	    	}

			update device;
        } catch(System.DMLException e){
        	showUpdateError = true;
        	updateError = e.getMessage();
        	return ApexPages.currentPage();
        }
        
		return returnUserBackToDevice();
    }
    
    public PageReference returnUserBackToDevice(){
        PageReference pr = new PageReference('/' + device.Id);
        pr.setRedirect(true);
        return pr;      
    }
    
    private static testmethod void editDeviceCoreAndStableTest(){
    	Stable__c s = new Stable__c(Name='stable');
    	insert s;
    	Core_Device_Package__c cdp = new Core_Device_Package__c(Name='core');
    	insert cdp;
    	Device__c d = new Device__c(Name='d');
    	insert d;
    	
        Test.startTest();
	        ApexPages.StandardController setCon = new ApexPages.StandardController(d);  
	        ApexPages.currentPage().getParameters().put('Id', d.Id);
	        editDeviceCoreAndStable edcas = new editDeviceCoreAndStable(setCon);
	        Device__c device = edcas.getDevice();
	        PageReference pr = edcas.returnUserBackToDevice();
	        d.Core_Device_Package__c = cdp.Id;
	        edcas.newCore();
	        d.Stable__c = s.Id;
	        edcas.newStable();
	        pr = edcas.mySave();
        Test.stopTest();       
    }
}