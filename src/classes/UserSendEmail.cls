public class UserSendEmail {

    public boolean controllerBoolTrueVar { get; set; }
    public boolean headerBoolTrueVar { get; set; }
    
    public UserSendEmail() {
        String featureparam = Apexpages.CurrentPage().getParameters().get('feature');
        if (featureparam=='private'){
            controllerBoolTrueVar = false;
            headerBoolTrueVar = true;
        }
        else {
            headerBoolTrueVar = false;
            controllerBoolTrueVar = true;
        }    
    }

    public PageReference send() {
        
       Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

       String[] addresses = new String[] {'jason.dobbs@motorola.com'};
       
       // Sets the paramaters of the email 
       String uname = 'Feature Request - Missing User: ';
       String subject = uname+emailaddr;
       email.setSubject( subject );
       
       // email.setToAddresses( toAddress );
       email.setToAddresses( addresses );
       email.setPlainTextBody( body );

       // Sends the email 

       Messaging.SendEmailResult [] r = 
       Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
       
       if (controllerBoolTrueVar == false)
           return Page.UserEmailSuccess;
       else
           return Page.UserEmailSuccessPublic;
    }

    public String body { get; set; }

    public String emailaddr { get; set; }

    public String yourname { get; set; }
    
    public PageReference home() {
        if (controllerBoolTrueVar == false){
            PageReference phome = new PageReference('/home/home.jsp');
            return phome;
        }
        else {
            PageReference phome = new PageReference('http://motorolamobility.force.com/featurerequest');
            return phome;
        }
    }
    
    //Unit Test
    static testMethod void UserSendEmail_Test()
    {
        //Test converage for the myPage visualforce page
        PageReference pageRef = Page.MissingUser;
        Test.setCurrentPageReference(pageRef);
        // create an instance of the controller
        UserSendEmail myPageCon = new UserSendEmail();
        myPageCon.body='Test';
        
        // validate PageReference
        PageReference send = myPageCon.send();
        system.assert( send.getUrl().contains('useremailsuccess') ); 
        
          //Test converage for the UserEmailSuccess visualforce page
        PageReference pageRefSuc = Page.UserEmailSuccess;
        Test.setCurrentPageReference(pageRefSuc);
        // create an instance of the controller
        UserSendEmail UserEmailSucCon = new UserSendEmail();
        
        // validate PageReference
        PageReference home = UserEmailSucCon.home();
        
        if (myPageCon.controllerBoolTrueVar == false){
            system.assert( home.getUrl().contains('home') );
        }
     }
    
}