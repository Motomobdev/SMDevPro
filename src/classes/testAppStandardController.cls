@isTest
public class testAppStandardController{

    public static testMethod void testConstructor(){
    	
        Test.startTest();
 	       AppStandardController apsc = new AppStandardController();
        Test.stopTest();
    
        System.assertEquals(apsc.verified,false);
        System.assertEquals(apsc.MMID,null);
        System.assertEquals(apsc.hasNext,false);
        System.assertEquals(apsc.hasPrevious,false);
    }
    
    public static testMethod void testRestartSearchWithNullInputName(){
    	
        AppStandardController apsc = new AppStandardController();
    
        Test.startTest();
        	apsc.inputName = null;
        	apsc.restartSearch();
        Test.stopTest();
        
        System.assert(ApexPages.hasMessages());
    
    }
    
    public static testMethod void testRestartSearchWithValidInputName(){
    	
        List<Application__c> newApps = new List<Application__c>();
        for(Integer itr = 0; itr < 50; itr++){
            newApps.add(new Application__c(Name='Test App' + itr, Application_Type__c='Yes',Carrier_Branded__c='Yes', Carrier_Furnished__c='Yes', Carrier_Mandated__c='Yes' ));
        }
        insert newApps;    
        
        AppStandardController apsc = new AppStandardController();
        
        
        Test.startTest();
        	apsc.inputName = 'Test';
        	apsc.restartSearch();
        Test.stopTest();
        
        System.assertEquals(apsc.getApps().size(),20);
        System.assertEquals(apsc.verified,false);
        System.assertEquals(apsc.MMID,null);
        System.assertEquals(apsc.hasNext,true);
        System.assertEquals(apsc.hasPrevious,false);
    
    }
    
    public static testMethod void testNextAndPrevious(){
    	
        List<Application__c> newApps = new List<Application__c>();
        for(Integer itr = 0; itr < 50; itr++){
            newApps.add(new Application__c(Name='Test App' + itr, Application_Type__c='Yes',Carrier_Branded__c='Yes', Carrier_Furnished__c='Yes', Carrier_Mandated__c='Yes' ));
        }
        insert newApps;    
        
        AppStandardController apsc = new AppStandardController();
        
        
        Test.startTest();
        	apsc.inputName = 'Test';
        	apsc.restartSearch();
        	apsc.next();
        	apsc.previous();
        Test.stopTest();
        
        System.assertEquals(apsc.getApps().size(),20);
        System.assertEquals(apsc.verified,false);
        System.assertEquals(apsc.MMID,null);
        System.assertEquals(apsc.hasNext,true);
        System.assertEquals(apsc.hasPrevious,false);
    
    }
    
    public static testMethod void testValidateMMID(){
        AppStandardController apsc = new AppStandardController();
        Motorola_Core_Directory__c MMCore = new Motorola_Core_Directory__c(MMID__c='GRAM',DirectoryStatus__c = 'A');
     	insert MMCore;
        
        Test.startTest();
        apsc.MMID = 'GRAM';
        apsc.validateMMIDInput();
        Test.stopTest();
        
        
    }
    
    public static testMethod void testValidateMMIDWithoutValidMMID(){
        AppStandardController apsc = new AppStandardController();
        Motorola_Core_Directory__c MMCore = new Motorola_Core_Directory__c(MMID__c='GRAM',DirectoryStatus__c = 'A');
     	insert MMCore;
        
        Test.startTest();
        apsc.MMID = 'DAVE';
        apsc.validateMMIDInput();
        Test.stopTest();
        
        System.assert(ApexPAges.hasMessages());
    }
    
}