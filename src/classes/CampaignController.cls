public with Sharing class CampaignController {
      
  public Campaign camp{get;set;}
  public Boolean redirect{get;set;}
  public Boolean  direct{get;set;}
  public Boolean  indirect{get;set;}
  public String campaignId = null;
  public Campaign_Product__c camped{get;set;}
  public String rType {get; set;}
  public ID Account {get;set;}
  public ID camparent {get;set;}
    
  public Id accId;
    public CampaignController(ApexPages.StandardController controller) {
   
    List<String> additionalFields = new List<String>();
     
        additionalFields.add('Is_Product_Campaign__c');
        additionalFields.add('Name');
        additionalFields.add('BudgetedCost');
        additionalFields.add('ActualCost');
        additionalFields.add('EndDate');
        additionalFields.add('StartDate');
        additionalFields.add('Category__c');
        additionalFields.add('Description');
        additionalFields.add('Sub_Category__c');
        additionalFields.add('Target__c');
        //additionalFields.add('Contract_Type__c');
        additionalFields.add('Channel_Type__c');
        additionalFields.add('Funded_By__c');
        additionalFields.add('Status');
        additionalFields.add('Account__c');
        additionalFields.add('OwnerId');
         additionalFields.add('ParentId');
          additionalFields.add('IsActive');
           additionalFields.add('ExpectedRevenue');
           additionalFields.add('ExpectedResponse');
           additionalFields.add('NumberSent');
           additionalFields.add('e_Commerce_Promotion_Code__c');
           additionalFields.add('Campaign_Review_Date__c');
           additionalFields.add('Campaign_Review_Required__c');
           additionalFields.add('Campaign_Analytics__c');
           additionalFields.add('Campaign_Analyzed__c');
           additionalFields.add('ActualCost');
           additionalFields.add('Analyzed_By__c');
           additionalFields.add('Country__c');
           additionalFields.add('City__c');
           if(!Test.isRunningTest()) {
        controller.addFields(additionalFields);
    }
    Campaign campacc = (Campaign)controller.getRecord();
    campaignId = ApexPages.currentPage().getParameters().get('id');
   Account = ApexPages.currentPage().getParameters().get('Account__c');
   camparent = ApexPages.currentPage().getParameters().get('Parent');
    rType = ApexPages.currentPage().getParameters().get('RecordType');
   
          camp = (Campaign)controller.getRecord();
           camp.OwnerId = userinfo.getuserId();  
            campacc.Account__c = Account; 
            campacc.ParentId = camparent;
            campacc.RecordTypeId=rType;
            
            
            
            
    }
    
  public PageReference redirectToPage()
{
    Account = ApexPages.currentPage().getParameters().get('CF00N40000002X8D7_lkid');
  String AccountName = ApexPages.currentPage().getParameters().get('CF00N40000002X8D7');
    // Grab the ID (or IDs in a list of the RT we don't want to redirect:
    Id objRTId = [select Id from RecordType where SObjectType = 'Campaign' and DeveloperName = 'Promotion'][0].Id;
    String chosenRT = ApexPages.CurrentPage().GetParameters().Get('RecordType');

    // If no match, then redirect to the standard page by using 'nooverride=1'
   if(chosenRT != objRTID && chosenRT!= null)
    {
        if(Account!=null){
        // redirect to the standard new screen
       String url = '/' + Campaign.SObjectType.GetDescribe().GetKeyPrefix() + '/e?RecordType=' + chosenRT + '&nooverride=1&CF00N40000002X8D7_lkid='+Account+'&CF00N40000002X8D7='+AccountName+'';
        
        return new ApexPages.PageReference(url).SetRedirect(true);
        } else
        {
        String url = '/' + Campaign.SObjectType.GetDescribe().GetKeyPrefix() + '/e?RecordType=' + chosenRT + '&nooverride=1';
        return new ApexPages.PageReference(url).SetRedirect(true);
        }
        }
    else if(chosenRT == objRTID)
    {
        camp.Account__c = Account;
       redirect =true;
     }else {
         redirect =true;
          camp.Account__c = Account;
      }
      
    return null;
}

      
    
        public PageReference Save() {
        PageReference redirecturl=null; 
        String campaignProdURL= '';
        if((camp.Target__c == 'All Customers' || camp.Target__c  == 'New Customers' || camp.Target__c  == 'Existing Customers' ) && camp.Contract_Type__c == null)
            
                   {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Need to identify a Contract Type when the Target is All, New, or Existing Customers.');
            ApexPages.addMessage(myMsg);
            return null;
        } else{
        
        try{
        
        upsert camp;
        }
      
        catch(Exception e) {
 
   return null;
}
      }
        system.debug('camp.Is_Product_Campaign__c --'+camp.Is_Product_Campaign__c);
         if(camp.Is_Product_Campaign__c =='Yes') { 
            system.debug('URL.getSalesforceBaseUrl().toExternalForm()'+URL.getSalesforceBaseUrl().toExternalForm());
            //campaignProdURL = campaignProdURL + URL.getSalesforceBaseUrl().toExternalForm();
            campaignProdURL = campaignProdURL + '/a13/e?';
            campaignProdURL = campaignProdURL + 'CF00N40000002X8D6' + '=' + camp.Name + '&'; //Set Campaign Product Name
            System.debug('prod1'+campaignProdURL); 
            campaignProdURL = campaignProdURL + 'CF00N40000002X8D6_lkid=' + camp.id + '&'; //Set Campaign Product Lookup
            System.debug('prod2'+campaignProdURL);
            campaignProdURL = campaignProdURL + 'retURL=' + camp.id + '&' + 'saveURL=' + camp.id ; //Set Return URL
            System.debug('prod3'+campaignProdURL);
            system.debug('campaignProdURL -- '+campaignProdURL);
           // String encodedCampProdURL = EncodingUtil.urlEncode(campaignProdURL, 'UTF-8');
            //system.debug('encodedCampProdURL -- '+encodedCampProdURL);
           redirecturl = new PageReference(campaignProdURL);
           redirecturl.setRedirect(true);
        return redirecturl;
            
         } 
         else
         {
             campaignProdURL = campaignProdURL + '/' + camp.id;
             redirecturl = new PageReference(campaignProdURL);
          }
                     
         return redirecturl;
}

        public PageReference cancel() {
        String retURL = '/701/o';
        PageReference pageRef = new PageReference(retURL);
        pageRef.setRedirect(true);
        return pageRef; // redirect
    }
     

}