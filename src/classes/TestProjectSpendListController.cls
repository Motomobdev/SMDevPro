@isTest
public class TestProjectSpendListController{

    public static testMethod void testConstructor(){
     	ProjectSpendListController psc;
        
        Test.startTest();
        	psc = new ProjectSpendListController();
        Test.stopTest();
    }
    
     public static testMethod void testValidateMMID(){
        ProjectSpendListController cpsc = new ProjectSpendListController();
        Motorola_Core_Directory__c MMCore = new Motorola_Core_Directory__c(MMID__c='GRAM',DirectoryStatus__c = 'A');
     	insert MMCore;
        
        Test.startTest();
        cpsc.MMID = 'GRAM';
        cpsc.validateMMIDInput();
        Test.stopTest();
        
        System.assertNotEquals(null,cpsc.projects);
    }
    
    public static testMethod void testValidateMMIDWithoutValidMMID(){
        ProjectSpendListController cpsc = new ProjectSpendListController();
        Motorola_Core_Directory__c MMCore = new Motorola_Core_Directory__c(MMID__c='GRAM',DirectoryStatus__c = 'A');
     	insert MMCore;
        
        Test.startTest();
        cpsc.MMID = 'DAVE';
        cpsc.validateMMIDInput();
        Test.stopTest();
        
        System.assert(ApexPAges.hasMessages());
    }
    
}