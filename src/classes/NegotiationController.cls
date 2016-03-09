public with sharing class NegotiationController{
    public Negotiation_Profile__c contact {get;set;}
    public NegotiationController(ApexPages.StandardController controller) {
        contact = new Negotiation_Profile__c();
    }    
    
     public PageReference save() {  
            try{
                insert this.contact;
                }catch(exception e){
                }
                PageReference page = new Pagereference('/' + contact.Id);
            page.setRedirect(true);
            return page;
 }

 public Pagereference cancel(){

        PageReference newpage = new Pagereference('/a7h');
        newpage.setRedirect(true);
        return newpage;
 }

    
}