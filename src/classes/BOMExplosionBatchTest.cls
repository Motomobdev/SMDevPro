/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class BOMExplosionBatchTest {
  
  private static Account acct;
  private static Application__c testApp1;
  private static Application__c testApp2;
  private static Application__c testApp3;
  private static Zuora__CustomerAccount__c billingAccount;

   static testMethod void testNoAcctPeriod() {
      Test.startTest();
      createTestData();
      BOMExplosionBatch bomExpBatch = new BOMExplosionBatch();
    //bomExpBatch.BatchId='133231343534';
    ID batchprocessid = Database.executeBatch(bomExpBatch);
      Test.stopTest();
        // TO DO: implement unit test
    }
    
    static testMethod void testWithAcctPeriod() {
      Test.startTest();
      createTestData();
      createAcctCalendar(Date.Today() -5 , Date.Today() + 30);
      BOMExplosionBatch bomExpBatch = new BOMExplosionBatch();
    ID batchprocessid = Database.executeBatch(bomExpBatch);
      Test.stopTest();
        // TO DO: implement unit test
    }
    
    static testMethod void testZUsageWithContractAppGroup() {
      Test.startTest();
      createTestData();     
      Application_Group__c appGrp = createApplicationGroup(acct.Id, 'AppGrpfortestclass');
      createApplicationGroupDateRange(appGrp.Id, Date.Today() -5 , Date.Today() + 30);
      testApp1.Application_Contract_Number__c = createContract(acct.Id).ContractNumber;
      testApp1.Application_Group__c = appGrp.Id;
      update testApp1;
      
      createAcctCalendar(Date.Today() -5 , Date.Today() + 30);
      BOMExplosionBatch bomExpBatch = new BOMExplosionBatch();
    ID batchprocessid = Database.executeBatch(bomExpBatch);
      Test.stopTest();
        // TO DO: implement unit test
    }
    
    testMethod static void testZUsageWithCharges() {
      Test.startTest();
      createTestData();     
      Application_Group__c appGrp = createApplicationGroup(acct.Id, 'AppGrpfortestclass');
      createApplicationGroupDateRange(appGrp.Id, Date.Today() -5 , Date.Today() + 30);
      Contract contract = createContract(acct.Id);
      testApp1.Application_Contract_Number__c = contract.ContractNumber;
      testApp1.Application_Group__c = appGrp.Id;
      update testApp1;
      
      createAcctCalendar(Date.Today() -5 , Date.Today() + 30);
      billingAccount = createBillingAccount(acct.Id);
      Zuora__Subscription__c subscription = createSubscription(acct.Id, billingAccount.Id, contract.ContractNumber);
      Zuora__SubscriptionProductCharge__c subscriptionCharge = createSubscriptionCharges(acct.Id, testApp1.Id, subscription.Id);
      
      BOMExplosionBatch bomExpBatch = new BOMExplosionBatch();
    ID batchprocessid = Database.executeBatch(bomExpBatch);
      Test.stopTest();
        // TO DO: implement unit test
    }
    
    private static Device__c createDevice(Id SWKitId) {
        Device__c testDev = new Device__c();
      testDev.Name = 'TestDevicebatch';
      testDev.SW_Kit__c = SWKitId;
      testDev.SA_Date__c = Date.parse('8/1/2013');
      insert testDev;
      return testDev;
    }
        
    private static Sales_Model__c createSalesModel(String smName) {
        Sales_Model__c testSalesModel = new Sales_Model__c();
      testSalesModel.Name = smName;
      insert testSalesModel;
      return testSalesModel;
    }
    
    private static SW_Kit__c createSWKit() {
        SW_Kit__c testSWKit = new SW_Kit__c();
      testSWKit.Name = 'TestSWKitbatch';
      insert testSWKit;
      return testSWKit;
    }
    
    private static SWKIT_SalesModel_Relationship__c createSWKitSalesModelRelationship(Id swkitId, Id salesModelId)  {
      SWKIT_SalesModel_Relationship__c testSWKitsalesModel = new SWKIT_SalesModel_Relationship__c();
      testSWKitsalesModel.Sales_Model__c = salesModelId;
      testSWKitsalesModel.SW_Kit__c = swkitId;
      testSWKitsalesModel.Current_SWKIT_SM_Mapping__c = 'Y';
      insert testSWKitsalesModel;
      return testSWKitsalesModel;     
    }
    
    private static Application__c createApplication(String appName, Id acctId) {
        Application__c testApp = new Application__c();
        testApp.Account__c = acctId;
        testApp.Name = appName;
        testApp.Application_Type__c = 'fakeValueToSkipSomeSteps';
        testApp.Application_Category__c='fakeCategory';
        testApp.Available_For_Use__c = TRUE;
        testApp.Description__c='fakeDescription';
        insert testApp;
        return testApp;
    }
    
    private static DeviceApplicationAssoc__c createDeviceApplication(Id applicationId, Id deviceId)  {
      DeviceApplicationAssoc__c deviceAppAssoc = new DeviceApplicationAssoc__c();
      deviceAppAssoc.Application__c = applicationId;
      deviceAppAssoc.Device__c = deviceId;
      deviceAppAssoc.Include_in_BOM__c = TRUE;
      insert deviceAppAssoc;
      return deviceAppAssoc;
    }
    
    private static Revenue_Unit__c createRevUnit(String productNumber, String dataSource, String InvoiceNumber, Integer revenueUnits)  {
      Revenue_Unit__c revUnit = new Revenue_Unit__c();
      revUnit.Product_Number__c = productNumber;
      revUnit.Data_Source__c = dataSource;
      revUnit.Invoice_Number__c = InvoiceNumber;
      revUnit.Invoice_Date__c = String.valueOf(Date.today());
      revUnit.Revenue_Units__c = revenueUnits;
      revUnit.Batch_Id__c = '133231343534';
      insert revUnit;
      return revUnit;
    }
    
    private static Acct_Calendar__c createAcctCalendar(Date startDate, Date endDate)  {
      Acct_Calendar__c acctCal = new Acct_Calendar__c();
      acctCal.StartDate__c = startDate;
      acctCal.EndDate__c = endDate;
      acctCal.PeriodName__c = 'TestPeriodnamefortestclass';
      acctCal.QuarterName__c = 'TestquarterforTC';
      insert acctCal;
      return acctCal;
    }
    
    private static Application_Group__c createApplicationGroup(Id accountId, String appgrpName)  {
      Application_Group__c appGrp = new Application_Group__c();
      appGrp.Account__c = accountId;
      appGrp.Name = appgrpName;
      insert appGrp;
      return appGrp;
    }
    
    private static Application_Group_Date_Range__c createApplicationGroupDateRange(Id appGroupId, Date startDate, Date endDate)  {
      Application_Group_Date_Range__c appGrpDtRange = new Application_Group_Date_Range__c();
      appGrpDtRange.Application_Group__c = appGroupId;
      appGrpDtRange.Start_Date__c = startDate;
      appGrpDtRange.End_Date__c = endDate;
      insert appGrpDtRange;
      return appGrpDtRange;
    }
    
    private static Account createAccount()  {
      Account account = new Account();
      account.Tier__c ='1';
      account.Name = 'For Test class';
      insert account;
      return account;
    }
    
    private static Contract createContract(Id accountId)  {
      Contract contract = new Contract();
      contract.AccountId = accountId;
      insert contract;
      return contract;
    }
    
    private static Zuora__CustomerAccount__c createBillingAccount(Id accountId)  {
      Zuora__CustomerAccount__c billingAcct = new Zuora__CustomerAccount__c();
      billingAcct.Zuora__Account__c = accountId;
      insert billingAcct;
      return billingAcct;
    }
    
    private static Zuora__Subscription__c createSubscription(Id accountId, Id billingAcctId, Id contractNumber)  {
      Zuora__Subscription__c subscription = new Zuora__Subscription__c();
      subscription.Zuora__Account__c = accountId;
      subscription.Zuora__CustomerAccount__c = billingAcctId;
      subscription.ContractNumber__c = contractNumber;
      insert subscription;
      return subscription;
    }
    
    private static Zuora__SubscriptionProductCharge__c createSubscriptionCharges(Id accountId, Id applicationId, Id subscriptionId)  {
      Zuora__SubscriptionProductCharge__c subscriptionCharge = new Zuora__SubscriptionProductCharge__c();
      subscriptionCharge.Zuora__Account__c = accountId;
      subscriptionCharge.ApplicationId__c = applicationId;
      subscriptionCharge.Zuora__Price__c = 1;
      subscriptionCharge.Zuora__UOM__c = Constants.UOM_APPSSHIPPED;
      subscriptionCharge.CumulativeFrom__c = '0';
      subscriptionCharge.CumulativeTo__c = '1000';
      subscriptionCharge.Zuora__Subscription__c = subscriptionId;
      insert subscriptionCharge;
      return subscriptionCharge;
    }
        
    private static void createTestData()  {
      Sales_Model__c testSalesModel = createSalesModel('1212123');
      SW_Kit__c testSWKit = createSWKit();
      SWKIT_SalesModel_Relationship__c testSWKitsalesModel = createSWKitSalesModelRelationship(testSWKit.Id, testSalesModel.Id);
      System.debug('SWKIT is ' + testSWKit);
      System.debug('testSWKitsalesModel is ' + testSWKitsalesModel);
      Device__c testDev = createDevice(testSWKit.Id);
      System.debug('testDev is ' + testDev);
      acct = createAccount();
      testApp1 =  createApplication('111222334', acct.Id);
      testApp2 =  createApplication('111222333',acct.Id);
      testApp3 =  createApplication('111222335',acct.Id);
      DeviceApplicationAssoc__c deviceAppAssoc = createDeviceApplication(testApp1.Id, testDev.Id);
      //createAcctCalendar(Date.Today() -5 , Date.Today() + 30);
      createRevUnit(testSalesModel.Name, Constants.REVUNIT_TYPE_BOM, '111343535', 10 );
      createRevUnit(testApp2.Application_ID__c, Constants.REVUNIT_TYPE_ARCTICFOX, '111343535', 10 );
      createRevUnit(testApp3.Application_ID__c, Constants.REVUNIT_TYPE_ARCTICFOX, null, 10 );
    }
    
  
}