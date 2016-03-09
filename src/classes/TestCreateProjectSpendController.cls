@isTest
public class TestCreateProjectSpendController{

    public static testMethod void testNonStandardConstructor(){
        
        CreateProjectSpendController cpsc;
        
        Test.startTest();
        cpsc = new CreateProjectSpendController();
        Test.stopTest();
        
        System.assertNotEquals(null,cpsc.primaryRecord);
        System.assertNotEquals(null,cpsc.milestones);
        System.assertEquals(false,cpsc.verified);
        
    }
    
    public static testMethod void testStandardControllerConstructor(){
        
        Project_Spend__c pjs = new Project_Spend__c(start_date__c=Date.today(),end_Date__c=Date.today().addMonths(1),Name__c='Test Project',Estimated_Spend__c=15000.00);
        insert pjs;
        ApexPages.StandardController stdController = new ApexPages.StandardController(pjs);
        
        CreateProjectSpendController cpsc;
        
        Test.startTest();
        cpsc = new CreateProjectSpendController(stdController);
        Test.stopTest();
        
        System.assertNotEquals(null,cpsc.primaryRecord);
        System.assertNotEquals(null,cpsc.milestones);
        System.assertEquals(0,cpsc.milestones.size());
        System.assertEquals(false,cpsc.verified);
    }
    
    public static testMethod void testValidateMMID(){
        CreateProjectSpendController cpsc = new CreateProjectSpendController();
        Motorola_Core_Directory__c MMCore = new Motorola_Core_Directory__c(MMID__c='GRAM',DirectoryStatus__c = 'A');
     	insert MMCore;
        
        Test.startTest();
        cpsc.MMID = 'GRAM';
        cpsc.validateMMIDInput();
        Test.stopTest();
        
        System.assertEquals(true,cpsc.verified);
        System.assertEquals(MMCore.id,cpsc.primaryRecord.Requester__c);
        
    }
    
    public static testMethod void testValidateMMIDWithoutCorrectMMID(){
        CreateProjectSpendController cpsc = new CreateProjectSpendController();
        Motorola_Core_Directory__c MMCore = new Motorola_Core_Directory__c(MMID__c='GRAM',DirectoryStatus__c = 'A');
     	insert MMCore;
        
        Test.startTest();
        cpsc.MMID = 'DAVE';
        cpsc.validateMMIDInput();
        Test.stopTest();
        
        System.assertEquals(false,cpsc.verified);
        System.assert(ApexPages.hasMessages());
        
    }
    
    public static testMethod void testUpdateMilstoneList(){
        CreateProjectSpendController cpsc = new CreateProjectSpendController();
        
        Test.startTest();
        	cpsc.addedMilestone = '[{"Description__c":"Some Description","Start_Date__c":"2013-08-14","End_Date__c":"2013-08-14"}]';
    		cpsc.updateMilstoneList();
        Test.stopTest();
        
        System.assertNotEquals(null,cpsc.milestones);
        System.assertEquals(1,cpsc.milestones.size());
    }
    
    public static testMethod void testCreateRecordwithoutMilstones(){
        CreateProjectSpendController cpsc = new CreateProjectSpendController();
        
        Test.startTest();
        	cpsc.primaryRecord = new Project_Spend__c(start_date__c=Date.today(),end_Date__c=Date.today().addMonths(1),Name__c='Test Project',Estimated_Spend__c=15000.00);
        	cpsc.createRecord();
        Test.stopTest();
    }
    
    public static testMethod void testCreateRecordwithMilstones(){
        CreateProjectSpendController cpsc = new CreateProjectSpendController();
        cpsc.addedMilestone = '[{"Description__c":"Some Description","Start_Date__c":"2013-08-14","End_Date__c":"2013-08-14"}]';
    	cpsc.updateMilstoneList();
        
        Test.startTest();
        	cpsc.primaryRecord = new Project_Spend__c(start_date__c=Date.today(),end_Date__c=Date.today().addMonths(1),Name__c='Test Project',Estimated_Spend__c=15000.00);
        	cpsc.createRecord();
        Test.stopTest();
    }
    
    public static testMethod void testInsertMilstones(){
        
        Project_Spend__c swproject = new Project_Spend__c();
        insert swproject;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(swproject);
        CreateProjectSpendController cpsc = new CreateProjectSpendController(stdController);
        
        Test.startTest();
        	cpsc.addedMilestone = '[{"Project_Spend__c":"'+swproject.id+'","Description__c":"Some Description","Start_Date__c":"2013-08-14","End_Date__c":"2013-08-14"}]';
    		cpsc.insertMilestones();
        Test.stopTest();
    }
    
    public static testMethod void testUpdateMilstones(){
        Project_Spend__c swproject = new Project_Spend__c();
        insert swproject;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(swproject);
        CreateProjectSpendController cpsc = new CreateProjectSpendController(stdController);
        
        cpsc.addedMilestone = '[{"Project_Spend__c":"'+swproject.id+'","Description__c":"Some Description","Start_Date__c":"2013-08-14","End_Date__c":"2013-08-14"}]';
    	cpsc.insertMilestones();
        
        Spend_Milestone__c milestone = [Select id From Spend_Milestone__c];
        
        Test.startTest();
        	cpsc.addedMilestone = '[{"Project_Spend__c":"'+swproject.id+'","Id":"'+milestone.id+'","Description__c":"Some Description","Start_Date__c":"2013-08-14","End_Date__c":"2013-08-14"}]';
    		cpsc.editMilestones();
        Test.stopTest();
    }
    
    public static testMethod void testDeleteMilstones(){
        Project_Spend__c swproject = new Project_Spend__c();
        insert swproject;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(swproject);
        CreateProjectSpendController cpsc = new CreateProjectSpendController(stdController);
        
        cpsc.addedMilestone = '[{"Project_Spend__c":"'+swproject.id+'","Description__c":"Some Description","Start_Date__c":"2013-08-14","End_Date__c":"2013-08-14"}]';
    	cpsc.insertMilestones();
        
        Spend_Milestone__c milestone = [Select id From Spend_Milestone__c];
        
        Test.startTest();
        	cpsc.addedMilestone = '[{"Project_Spend__c":"'+swproject.id+'","Id":"'+milestone.id+'","Description__c":"Some Description","Start_Date__c":"2013-08-14","End_Date__c":"2013-08-14"}]';
    		cpsc.removeMilestones();
        Test.stopTest();
    }
    
    public static testMethod void testGetFieldSet(){
    	CreateProjectSpendController cpsc = new CreateProjectSpendController();
        
		Test.startTest();
			cpsc.getFieldSet();
		Test.stopTest();      
    }
    
    public static testMethod void testgetFieldJSON(){
		CreateProjectSpendController cpsc = new CreateProjectSpendController();
        
		Test.startTest();
			cpsc.getFieldJSON();
		Test.stopTest();        
    }
    
    public static testMethod void testgetExistingMilestonesWithOneMilestone(){
        CreateProjectSpendController cpsc = new CreateProjectSpendController();
        cpsc.addedMilestone = '[{"Description__c":"Some Description","Start_Date__c":"2013-08-14","End_Date__c":"2013-08-14"}]';
    	cpsc.updateMilstoneList();
        
        List<Spend_Milestone__c> milestones = new List<Spend_Milestone__c>();
        
        Test.startTest();
        	milestones = cpsc.getExistingMilestones();
        Test.stopTest();
        
        System.assertEquals(1,milestones.size());
    }
}