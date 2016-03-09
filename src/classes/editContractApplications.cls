public with sharing class editContractApplications {

    public Contract contract{get; set;}
    public List<applicationWrapper> applications;
    public ApexPages.StandardController stdController {get; set;}
    public String searchAccount {get; set;}
    public String Id{get; set;}
    public Set<Id> currAppIds = new Set<Id>();
    public Set<Id> newAppIds = new Set<Id>();
    public Set<Id> droppedAppIds = new Set<Id>(); 

    public editContractApplications(ApexPages.StandardController controller) {
    
        this.stdController = controller;
        contract = (Contract) stdController.getRecord();
        this.Id = ApexPages.currentPage().getParameters().get('id');

    }
    
    public List<applicationWrapper> getApplications(){
        
        applications = new List<applicationWrapper>();
        Account account = ((Contract) stdController.getRecord()).Account;
        searchAccount = account.Name;
        
        /*show existing applications as checked */
        
        for(ContApplAssoc__c ContApp : [select id, Application__c, Application__r.Id, Application__r.Name, Contract__r.Id from ContApplAssoc__c where contract__r.id = :Id]){
            if(!currAppIds.contains(ContApp.Application__c)){currAppIds.add(ContApp.Application__c);}
        }
        
        String soql= 'SELECT     Id, ' +
                       '         Name, ' +
                       '         Account__r.Name ' +
                       'FROM     Application__c ' +
                       'WHERE    Account__r.Name LIKE \'%' + searchAccount + '%\'' +
                       'ORDER BY Name ' +
                       'LIMIT    100';
                       
        /*
        for(Application__c application : database.query(soql)) {
            applications.add(new applicationWrapper(application));        
        }
        */
        
        for(Application__c application : database.query(soql)) {
            if(currAppIds.contains(application.Id)){
                applications.add(new applicationWrapper(application, true));
            }
            else{
                applications.add(new applicationWrapper(application));
            }
          
        }
         
            
        return applications;
    }

    
    public void search() {
        getApplications();
    }
    
    public PageReference save() {
    
        for(ContApplAssoc__c ContApp : [select id, Application__c, Application__r.Id, Application__r.Name, Contract__r.Id from ContApplAssoc__c where contract__r.id = :Id]){
            if(!currAppIds.contains(ContApp.Application__c)){currAppIds.add(ContApp.Application__c);}
        }
        
        for(applicationWrapper appWrapper : applications){
            if(appWrapper.isSelected == true){
                if(!currAppIds.contains(appWrapper.Application.Id) && !newAppIds.contains(appWrapper.Application.Id)){newAppIds.add(appWrapper.Application.Id);}
            }
            else{
                 if(currAppIds.contains(appWrapper.Application.Id) && !droppedAppIds.contains(appWrapper.Application.Id)){droppedAppIds.add(appWrapper.Application.Id);}
            }
        }
        
        for(Application__c newApp: [select id, name from Application__c where id IN :newAppIds]){
            ContApplAssoc__c newContApp = new ContApplAssoc__c();
            newContApp.Contract__c = Id;
            newContApp.Application__c =  newApp.Id;
            newContApp.Governing_End_Date__c = false;
            insert(newContApp);    
        }
        
        for(ContApplAssoc__c contApp: [select id from ContApplAssoc__c where Application__c IN :droppedAppIds]){
            delete(contApp);
        }
        
        return new PageReference('javascript:window.top.close();');    
    }
    
    public PageReference cancel() {
        return new PageReference('javascript:window.top.close();');
    }
    
    public static testMethod void testEditContarctApplications(){
        
        Test.startTest();
        Account newAcct = new Account(name='TestAppAccnt');
        newAcct.OwnerId = UserInfo.getUserId();
        insert newAcct;
        
        Application__c newApp = new Application__c(name='testApp',Application_Type__c='Embedded');
        newApp.Account__c = newAcct.id;
        insert newApp;
        
        Contract newCont = new Contract(name='testContract', StartDate = datetime.now().Date()); 
        newCont.Account = newAcct;
        newCont.AccountId = newAcct.id;
        insert newCont;
        
        ContApplAssoc__c newContApp = new ContApplAssoc__c();
        newContApp.Contract__c = newCont.id;
        newContApp.Application__c = newApp.Id;
        insert newContApp;
            
        PageReference pageRef = Page.editContractApplications;
        Test.setCurrentPage(pageRef);
            
        ApexPages.currentPage().getParameters().put('id', newCont.id);
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(newCont);
        
        List<applicationWrapper> applications = new List<applicationWrapper>();
        
        
        editContractApplications controller = new editContractApplications(stdController);
        applications = controller.getApplications();
        
        PageReference nextPageRef = controller.save();
        PageReference cancelPageRef = controller.cancel();
        controller.search();
        Test.stopTest();
        
        PageReference newPageRef =  new PageReference('javascript:window.top.close();');   
        System.assertEquals((new PageReference('javascript:window.top.close();')).getUrl(), nextPageRef.getUrl());
        
    }
}