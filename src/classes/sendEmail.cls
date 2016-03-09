public class sendEmail {

    public sendEmail(ApexPages.StandardController controller)
    {       
    }
        
    public String cat;
    
    public String getcat(){
        return cat;
    } 
     
    public void setcat(String cat){
        this.cat = cat;
    }  
    
    public String errorMessage { get; set; }
    public String errorMessageCategory { get; set; }
    public String errorMessageCategoryNull { get; set; }
    public String yourname { get; set; }
    public String emailaddr { get; set; }
    public String accname { get; set; }
    public String body { get; set; }

   public List<SelectOption> getCategory()
   {
        List<SelectOption> options = new List<SelectOption>();    
        options.add(new SelectOption('','--None--'));
        options.add(new SelectOption('Consumer','Consumer'));
        options.add(new SelectOption('Consumer','Content'));
        options.add(new SelectOption('Converged Services & Home','Converged Services & Home'));
        options.add(new SelectOption('Embedded','Embedded'));
        options.add(new SelectOption('Enterprise','Enterprise'));
        options.add(new SelectOption('Other','Other'));
            
    return options;
   }   
 
    public PageReference send() {
    
        if(accname == '' || accname == null){         
           errorMessage='Must enter a value for Account Name';
           return null;
        }
        
        errorMessage='';      
        
        if(cat == '' || cat == null){         
           errorMessageCategoryNull='Please Select a value for Account Category';
           return null;
        }  
        
        List<Partner_Mgr_Account__c> FieldList = [Select Partner_Mgr_Email__c, Partner_Account_Category__c from Partner_Mgr_Account__c 
                                                Where Partner_Account_Category__c=:cat Limit 1];
                                                
        if (FieldList.isEmpty()){
           errorMessageCategory='No Information exists for this Account Category';
           return null;        
        }
        
        errorMessageCategory='';
                                                
// Create a constructor that populates the Account object 
    String toAddress;
    {
    if(FieldList.size()>0)
    {  
        toAddress = FieldList[0].Partner_Mgr_Email__c;
    }
    }
    // Define the email 

    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

    String[] addresses = new String[] {toAddress};

    // Sets the paramaters of the email 
    String aname = 'Missing Account: ';
    String subject = aname+accname;
    
    email.setSubject( subject );
   // email.setToAddresses( toAddress );
   email.setToAddresses( addresses );
    email.setPlainTextBody( body );

    // Sends the email 

    Messaging.SendEmailResult [] r = 
    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
    
    return Page.EmailSuccess;
  }   
}