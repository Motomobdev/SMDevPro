public class BDSite_Controller {

  private ApexPages.StandardController controller {get; set;}
  public List<Account> searchResults {get;set;}
  public List<Contract> Contracts {get;set;}
  public List<Application__c> Applications {get;set;}
  public List<Contract> NDAS {get;set;}
  public string searchTextAcct {get;set;}
  public string searchTextPN {get;Set;}
  
  public string category {get;Set;}
  public String actid {get; set;}
  
  public string tier {get;Set;}
  public string actname {get;Set;}
  
 
  public BDSite_Controller(ApexPages.StandardController controller) {
    
    Category = 'N/A';

  
  }  

  public PageReference search() {

        if((!SearchTextAcct.equals(''))  && (SearchTextPN.equals('')) && (category=='N/A')){
                String qry = 'select Owner.Name,id,name,Top_Level_Category__c from Account ' + 'where Tier__c != \'\' AND name LIKE \'%'+searchTextAcct+'%\' order by name';
            searchResults = Database.query(qry);
                }
        
        else if((!SearchTextPN.equals('')) && (SearchTextAcct.equals('')) && (category=='N/A')){
            String qry = 'select Owner.Name,id,name,Top_Level_Category__c from Account ' + 'where Tier__c != \'\' AND Owner.Name LIKE \'%'+searchTextPN+'%\' order by name';
            searchResults = Database.query(qry);
                }
        
        else if ((category != 'N/A') && ((SearchTextAcct.equals(''))  && (SearchTextPN.equals(''))))   {                        
                        String qry = 'select Owner.Name,id,name,Top_Level_Category__c from Account ' + 'where Tier__c != \'\' AND Top_Level_Category__c INCLUDES (:category) order by name';
            searchResults = Database.query(qry);
                } 
           
        else if((!SearchTextAcct.equals(''))  && (!SearchTextPN.equals('')) && (category=='N/A')){
                String qry = 'select Owner.Name,id,name,Top_Level_Category__c from Account ' + 'where Tier__c != \'\' AND name LIKE \'%'+searchTextAcct+'%\' AND Owner.Name LIKE \'%'+searchTextPN+'%\' order by name';
            searchResults = Database.query(qry);
                }
                
        else if((!SearchTextAcct.equals(''))  && (SearchTextPN.equals('')) && (category!='N/A')){
                String qry = 'select Owner.Name,id,name,Top_Level_Category__c from Account ' + 'where Tier__c != \'\' AND name LIKE \'%'+searchTextAcct+'%\' And Top_Level_Category__c INCLUDES (:category)  order by name';
            searchResults = Database.query(qry);
                }      
                
        else  if((SearchTextAcct.equals(''))  && (!SearchTextPN.equals('')) && (category!='N/A')){
                String qry = 'select Owner.Name,id,name,Top_Level_Category__c from Account ' + 'where Tier__c != \'\' AND owner.name LIKE \'%'+searchTextPN+'%\'And Top_Level_Category__c INCLUDES (:category) order by name';
            searchResults = Database.query(qry);
                }
                       
        else if((!SearchTextAcct.equals(''))&& (!SearchTextPN.equals(''))  && (category != 'N/A')){
                String qry = 'select Owner.Name,id,name,Top_Level_Category__c from Account ' + 'where Tier__c != \'\' AND name LIKE \'%'+searchTextAcct+'%\' And Top_Level_Category__c INCLUDES (:category) AND Owner.Name LIKE \'%'+searchTextPN+'%\' order by name';
            searchResults = Database.query(qry);
                }
                        
                Return null;
    }
  
        public List<SelectOption> Categories {
        get {
                if (categories == null) {
                categories = new List<SelectOption>();
                Schema.DescribeFieldResult field = Account.Top_Level_Category__c.getDescribe();
 
                for (Schema.PicklistEntry f : field.getPicklistValues()) {
                        categories.add(new SelectOption(f.getLabel(), f.getLabel()));
                }
            }
                return categories;          
        }
        set;
   } 
 
   public PageReference findAccountDetails(){
                String actid = Apexpages.currentPage().getParameters().get('id');
                String AppList = 'SELECT name, Account__c,Application_Category__c, Application_Type__c, Royalty_Description__c, Application_ID__c FROM Application__c WHERE Account__c =: actid   ORDER BY name';
        Applications = Database.query(AppList);
      
                NDAS = [SELECT NDA_Type__c, EndDate,Description,Contract_Phase__c, Contract_Status__c,Contract_Type__c, AccountId, Name From Contract WHERE AccountId=:actid ORDER BY Name];
                //NDAS = [SELECT NDA_Type__c, EndDate,Description,Contract_Phase__c, Contract_Status__c,Contract_Type__c, AccountId, Name From Contract WHERE Contract_Type__c = 'NDA - Non-Disclosure Agreement' AND AccountId=:actid];  
       
            Return Null;
   }        
        
        
// Nominate a New Partner        
public Account accounts {
    get {
        if(accounts == NULL)
        accounts = new Account ();
        Accounts.name = actname;
        Accounts.Tier__c = tier;
     
        return accounts;
    }
        set;
    }
    
public PageReference Save(){
    try{
        insert Accounts;
    }
    
    catch (DMLException e){
      //  ApexPages.addMessage(new ApexPages.Severity.ERROR, 'Error Submitting Account Request.'));
        return null;
    }
    
   return null; 
}   

    
}