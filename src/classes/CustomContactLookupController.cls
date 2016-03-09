public with sharing class CustomContactLookupController {
    
  public Contact contact{get;set;} // new account to create
  public List<Contact> results{get;set;} // search results
  public string searchString{get;set;} // search keyword
  public string searchAccount{get;set;} // search Account
  
  public CustomContactLookupController() {
    contact = new Contact();
    // get the current search string
    searchString = System.currentPageReference().getParameters().get('lksrch');
    searchAccount= System.currentPageReference().getParameters().get('accid');
    runSearch();  
  }
   
  // performs the keyword search
  public PageReference search() {
    runSearch();
    return null;
  }
  
  // prepare the query and issue the search command
  private void runSearch() {
    // TODO prepare query string for complex serarches & prevent injections
    results = performSearch(searchString, searchAccount);               
  } 
  
  // run the search and return the records found. 
  private List<Contact> performSearch(string searchString, string searchAccount) {
    String soql = 'select id, name,Account.name,title from Contact where Account.id = \'' + searchAccount +'\'';
    if(searchString != '' && searchString != null)
      soql = soql +  ' and name LIKE \'%' + searchString +'%\'';
    soql = soql + ' limit 25';
    System.debug(soql);
    return database.query(soql); 
  }
  
  // save the new account record
  public PageReference saveContact() {
    try {
        contact.accountId = searchAccount;
        upsert contact;
        runSearch();
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Contact has been created already. Click on Search and select contact to return');
        ApexPages.addMessage(myMsg); 
    } catch(Exception e){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
        ApexPages.addMessage(myMsg);
    }
    // reset the account
    contact = new Contact();
    return null;
  }
    
  // used by the visualforce page to send the link to the right dom element
  public string getFormTag() {
    return System.currentPageReference().getParameters().get('frm');
  }
    
  // used by the visualforce page to send the link to the right dom element for the text box
  public string getTextBox() {
    return System.currentPageReference().getParameters().get('txt');
  }
 
}