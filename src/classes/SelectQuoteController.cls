public class SelectQuoteController {

    public List<Quote> quotes {get;set;}
    public Integer quoteCount {get;set;}
    public Id opptId {get;set;}
    public Id acctId {get;set;}
    
    public SelectQuoteController(){
        if(ApexPages.currentPage().getParameters().get('oppId') != null){
            opptId = ApexPages.currentPage().getParameters().get('oppId');
        }
        else if(ApexPages.currentPage().getParameters().get('acctId') != null){
            acctId = ApexPages.currentPage().getParameters().get('acctId');
        }
        quoteCount = 0;
        getQuotes(opptId,acctId);
    }
    
    public void getQuotes(Id oId, Id aId){
        if(oId != null){
            quotes = [select id, name, CreatedDate from quote where opportunityId = :oId ORDER BY CreatedDate DESC];
            quoteCount = quotes.size();
            if(quoteCount < 1){
                ApexPages.addMessage(New ApexPages.message(ApexPages.Severity.INFO,'No Deals Found for this Opportunity'));
            }
        }
        else if(aId != null){
            set<Id> opptIDs = new set<Id>();
            for(Opportunity oppt : [select id from Opportunity where accountid = :aId]){
                opptIDs.add(oppt.Id);
            }
            quotes = [select id, name, CreatedDate from quote where opportunityId in :opptIDs ORDER BY CreatedDate DESC];
            quoteCount = quotes.size();
            if(quoteCount < 1){
                ApexPages.addMessage(New ApexPages.message(ApexPages.Severity.INFO,'No Deals Found for this Account'));
            }
        }
        else{
            ApexPages.addMessage(New ApexPages.message(ApexPages.Severity.ERROR,'Unable to locate an Opportunity or Account ID'));
        }
    }
}