@isTest(SeeAllData=true)
public class PartnerManagerChecklistApprovalTest{
    public static testMethod void testPartnerManagerChecklistApproval1(){
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Account acc = new Account(Name='account');
        insert acc;
        Application__c app = new Application__c(name='app', Account__c=acc.Id,
                                                Application_Type__c='Embedded',
                                                Application_Contract_Governing_End_Date__c=Date.today().addMonths(7),
                                                Application_Category__c='fakeCategory', Description__c='fakeDescription');
        insert app;
        
        app.Available_For_Use__c = true;
        app.Automate_Partner_Checklist_Approval__c = true;
        update app;
        
        //Application__c app2 = [SELECT id,Application_Contract_Governing_End_Date__c FROM Application__c WHERE id=:app.Id ];
        //system.debug('APP2 contract endate' + app2.Application_Contract_Governing_End_Date__c);
        Device__c d = new Device__c(Name='testD');

        /*Language__c germanfake = new Language__c(Name='germanfake');
        insert germanfake;
        Language_Application__c GermanLanguageApp = new Language_Application__c(application__c=app.Id, Language__c=germanfake.Id);
        Language__c englishfake = new Language__c(Name='englishfake');
        insert englishfake;
        Language_Application__c EnglishLanguageApp = new Language_Application__c(application__c=app.Id, Language__c=englishfake.Id);
        */
        Country__c germanCountry = new Country__c(Name='germanCountry', Region__c='someRegion', Country_Code__c='G9');
        insert germanCountry;
        Country__c usCountry = new Country__c(Name='usCountry', Region__c='someRegion', Country_Code__c='G8');
        insert usCountry;
        Application_Country__c appCountryUSLegal = new Application_Country__c(Application__c=app.Id, 
                                    country__c=usCountry.Id, relationship__c='Legal');
        Application_Country__c appCountryUSAvailable = new Application_Country__c(Application__c=app.Id, 
                                    country__c=usCountry.Id, relationship__c='United States');
        Application_Country__c appCountryGermanyLegal = new Application_Country__c(Application__c=app.Id, 
                                    country__c=germanCountry.Id, relationship__c='Legal');
        Application_Country__c appCountryGermanyAvailable = new Application_Country__c(Application__c=app.Id, 
                                    country__c=germanCountry.Id, relationship__c='Available');

        Test.startTest();
            System.runAs(p){
                insert d;
            }
            d.Country__c='United States';
            update d;
            //Language_Device__c GermanLanguageDev = new Language_Device__c(Device__c=d.Id, Language__c=germanfake.Id);
            //Language_Device__c EnglishLanguageDev = new Language_Device__c(Device__c=d.Id, Language__c=englishfake.Id);

            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c(Application__c=app.Id, Device__c=d.Id, Include_in_BOM__c = false);
            insert devApp;

            app.Automate_Partner_Checklist_Approval__c = false;
            update app;
            app.Automate_Partner_Checklist_Approval__c = true;
            update app;

            /*insert EnglishLanguageApp;
            insert GermanLanguageDev;
            delete GermanLanguageDev;
            insert EnglishLanguageDev;
            */

            //app.Automate_Partner_Checklist_Approval__c = false;
            //update app;

            system.debug('INSERT AppCountryLegal');
            /*insert appCountryUSLegal;

            app.Automate_Partner_Checklist_Approval__c = true;
            update app;

            insert appCountryUSAvailable;

            //delete EnglishLanguageApp;
            delete appCountryUSLegal;

            try{
                DeviceCountryAssoc__c devCountryUS = [SELECT Id, Country__c, Device__c FROM DeviceCountryAssoc__c WHERE Device__c =: d.Id];
                delete devCountryUS;
            } catch(System.QueryException e){

            } */

        Test.stopTest();
    }

    public static testMethod void testPartnerManagerChecklistApproval2(){
        User p = [SELECT ID, Username From User Where username LIKE 'datafeed@motorola.com%' LIMIT 1];
        Account acc = new Account(Name='account');
        insert acc;
        Application__c app = new Application__c(name='app', Account__c=acc.Id,
                                                Application_Type__c='Embedded',
                                                Application_Contract_Governing_End_Date__c=Date.today().addMonths(7),
                                                Application_Category__c='fakeCategory',
                                                Description__c='fakeDescription');
        insert app;
        
        app.Available_For_Use__c = true;
        app.Automate_Partner_Checklist_Approval__c = true;
        update app;

        //Application__c app2 = [SELECT id,Application_Contract_Governing_End_Date__c FROM Application__c WHERE id=:app.Id ];
        //system.debug('APP2 contract endate' + app2.Application_Contract_Governing_End_Date__c);
        Device__c d = new Device__c(Name='testD');

        /*Language__c germanfake = new Language__c(Name='germanfake');
        insert germanfake;
        Language_Application__c GermanLanguageApp = new Language_Application__c(application__c=app.Id, Language__c=germanfake.Id);
        Language__c englishfake = new Language__c(Name='englishfake');
        insert englishfake;
        Language_Application__c EnglishLanguageApp = new Language_Application__c(application__c=app.Id, Language__c=englishfake.Id);
        */
        Country__c germanCountry = new Country__c(Name='germanCountry', Region__c='someRegion', Country_Code__c='G9');
        insert germanCountry;
        Country__c usCountry = new Country__c(Name='usCountry', Region__c='someRegion', Country_Code__c='G8');
        insert usCountry;
        Application_Country__c appCountryUSLegal = new Application_Country__c(Application__c=app.Id, country__c=usCountry.Id, relationship__c='Legal');
        Application_Country__c appCountryUSAvailable = new Application_Country__c(Application__c=app.Id, country__c=usCountry.Id, relationship__c='United States');
        Application_Country__c appCountryGermanyLegal = new Application_Country__c(Application__c=app.Id, country__c=germanCountry.Id, relationship__c='Legal');
        Application_Country__c appCountryGermanyAvailable = new Application_Country__c(Application__c=app.Id, country__c=germanCountry.Id, relationship__c='Available');

        Test.startTest();
            System.runAs(p){
                insert d;
            }
            d.Country__c='United States';
            update d;
            //Language_Device__c GermanLanguageDev = new Language_Device__c(Device__c=d.Id, Language__c=germanfake.Id);
            //Language_Device__c EnglishLanguageDev = new Language_Device__c(Device__c=d.Id, Language__c=englishfake.Id);

            DeviceApplicationAssoc__c devApp = new DeviceApplicationAssoc__c(Application__c=app.Id, Device__c=d.Id, Include_in_BOM__c = false);
            insert devApp;

            /*app.Automate_Partner_Checklist_Approval__c = false;
            update app;
            app.Automate_Partner_Checklist_Approval__c = true;
            update app;*/

            /*insert EnglishLanguageApp;
            insert GermanLanguageDev;
            delete GermanLanguageDev;
            insert EnglishLanguageDev;
            */

            //app.Automate_Partner_Checklist_Approval__c = false;
            //update app;

            system.debug('INSERT AppCountryLegal');
            insert appCountryUSLegal;

            app.Automate_Partner_Checklist_Approval__c = true;
            update app;

            insert appCountryUSAvailable;

            //delete EnglishLanguageApp;
            delete appCountryUSLegal;

            try{
                DeviceCountryAssoc__c devCountryUS = [SELECT Id, Country__c, Device__c FROM DeviceCountryAssoc__c WHERE Device__c =: d.Id];
                delete devCountryUS;
            } catch(System.QueryException e){

            }

        Test.stopTest();
    }

    /************************************************
    Added by: Neel Desai
    Date    : 28/Aug/2012
    ************************************************/
    public static testmethod void testSyncCountries()
    {
        Account acc = new Account(Name='test_account');
        insert acc;
        
        Application__c app = new Application__c(name='app', Account__c=acc.Id, 
                                                Application_Type__c='Embedded',
                                                Application_Contract_Governing_End_Date__c=Date.today().addMonths(7),
                                                Application_Category__c='fakeCategory', Description__c='fakeDescription');
        insert app;

        app.Automate_Partner_Checklist_Approval__c = true;
        app.Available_For_Use__c = true;
        update app;
        
        Device__c d1 = new Device__c(Name='test_device 1');
        insert d1;
        
        Device__c d2 = new Device__c(Name='test_device 2');
        insert d2;

        Country__c germanCountry = new Country__c(Name='germanCountry', Region__c='someRegion', Country_Code__c='G9');
        insert germanCountry;
        
        Country__c usCountry = new Country__c(Name='usCountry', Region__c='someRegion', Country_Code__c='G8');
        insert usCountry;
        
        Application_Country__c appCountryUSLegal = new Application_Country__c(Application__c=app.Id, country__c=usCountry.Id, relationship__c='Legal');
        insert appCountryUSLegal;
        Application_Country__c appCountryUSAvailable = new Application_Country__c(Application__c=app.Id, country__c=usCountry.Id, relationship__c='United States');
        insert appCountryUSAvailable;
        Application_Country__c appCountryGermanyLegal = new Application_Country__c(Application__c=app.Id, country__c=germanCountry.Id, relationship__c='Legal');
        insert appCountryGermanyLegal;
        Application_Country__c appCountryGermanyAvailable = new Application_Country__c(Application__c=app.Id, country__c=germanCountry.Id, relationship__c='Available');
        insert appCountryGermanyAvailable;
        
        DeviceApplicationAssoc__c devApp1 = new DeviceApplicationAssoc__c(Application__c=app.Id, Device__c=d1.Id, Include_in_BOM__c = false);
        insert devApp1;

        DeviceApplicationAssoc__c devApp2 = new DeviceApplicationAssoc__c(Application__c=app.Id, Device__c=d2.Id, Include_in_BOM__c = false);
        insert devApp2;

        DeviceCountryAssoc__c devCon1 = new DeviceCountryAssoc__c(Device__c=d1.Id, Country__c=germanCountry.Id);
        insert devCon1;
        
        DeviceCountryAssoc__c devCon2 = new DeviceCountryAssoc__c(Device__c=d2.Id, Country__c=usCountry.Id);
        insert devCon2;

        Map<Id, Application__c> appIdMap = new Map<Id, Application__c>();
        Set<Id> deviceIds = new Set<Id>();
        
        appIdMap.put(app.Id, app);
        deviceIds.add(d1.Id);
        deviceIds.add(d2.Id);
        
        Test.startTest();                
            PartnerManagerChecklistApproval.syncCountries(appIdMap, deviceIds);        
        Test.stopTest();
    }
 }