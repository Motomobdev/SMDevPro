public class applicationWrapper {
    public boolean isSelected{get;set;}
    public Application__c application{get;set;}
    
    public applicationWrapper(){
        application = new Application__c();
        isSelected = false;
    }
    
    public applicationWrapper(Application__c app) {
        application = app;
        isSelected = false;
    }
    
    public applicationWrapper(Application__c app, boolean selected) {
        application = app;
        isSelected = selected;
    }
    
    public static testMethod void testApplicationWrapper(){
        
        
        Test.startTest();
        Account newAcct = new Account(name='TestAppAccnt');
        newAcct.OwnerId = UserInfo.getUserId();
        insert newAcct;
        
        Application__c newApp = new Application__c(name='testApp',Application_Type__c='Embedded');
        newApp.Account__c = newAcct.id;
        insert newApp;
        
        applicationWrapper appWrap1 = new applicationWrapper();
        applicationWrapper appWrap2 = new applicationWrapper(newApp);
        applicationWrapper appWrap3 = new applicationWrapper(newApp, true);
        
    }
}