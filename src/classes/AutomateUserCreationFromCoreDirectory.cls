public class AutomateUserCreationFromCoreDirectory {

    /*
     * Created by: Lipsa Mishra 
     * Creation date: 11-10-2014 Test
     * Class:AutomateUserCreationFromCoreDirectory 
     * Description: Creates new
     * salesforce users from motorola core directory 
     * Change history: 
     * Changed on:
     * Changed by:
     */

    public void process() {

        Map<String, User> allCoreIds = new Map<String, User>();
        List<User> allSFUsers = new List<User>();
        List<Motorola_Core_Directory__c> motUsers = new List<Motorola_Core_Directory__c>();
        try {

            // Get all Salesforce users
            allSFUsers =[select id, name, email, federationidentifier, profile.name,isactive 
                         from User
                         where federationidentifier != null];

            for (User u : allSFUsers){
                allCoreIds.put(u.federationidentifier.toUpperCase(), u);

            }

            // Retrieve active employees from CoreDirectory object 
            List<Motorola_Core_Directory__c> coreDirUsers =
                    [SELECT Commerce_ID__c,CoreID__c,Department__c,DirectoryStatus__c,DisplayFirstName__c,DisplayLastName__c,
                     EmployeeType__c,Id,Location__c,Mail__c,Name,SupervisorCommerceID__c 
                     FROM Motorola_Core_Directory__c  WHERE DirectoryStatus__c = 'A' and EmployeeType__c='R' 
                     ];
            System.debug('>>>>>>>>>>>The total count of active users from CoreDirectory  : ' + coreDirUsers.size());

            for (Motorola_Core_Directory__c mc : coreDirUsers) {
                if (!(allCoreIds.containsKey(mc.CoreID__c.toUpperCase())) )                        
                    motUsers.add(mc);
            }

            System.debug('>>>>>>>>>>>>>>The total count of new users to be created : ' + motUsers.size());
    
            createUser(motUsers);

        } catch(Exception e) {
            System.debug('The following exception has occurred : ' + e.getMessage());
            System.debug('Stack trace: ' + e.getStackTraceString());  
        }

    }

    public void createUser(List<Motorola_Core_Directory__c>  motUsers){
        //create users
        User usercreate = new User();
        List<User> newUsers = new List<User>(); 
        String aliasName='';
        Savepoint sp = Database.setSavepoint();
        try {

            for (Motorola_Core_Directory__c u : motUsers) 
            {   
                if(u != null){
                    usercreate = new User();
                    usercreate.isactive=false;
                    usercreate.FirstName = u.DisplayFirstName__c;
                    usercreate.LastName = u.DisplayLastName__c;

                    if (u.DisplayFirstName__c.length() >0 && u.DisplayLastName__c.length() >0 )
                        aliasName=((u.DisplayFirstName__c).substring(0,1))+u.DisplayLastName__c;
                    if (aliasName!= null && aliasName.length() >8)
                        usercreate.Alias=(aliasName.substring(0,7)).toLowerCase();
                    else  usercreate.Alias=aliasName.toLowerCase();

                    usercreate.Email=u.CoreID__c+'@test.com.mduat';
                    usercreate.Username= u.CoreID__c+'@test.com.mduat';
                    usercreate.CommunityNickname=(u.CoreID__c).toLowerCase();

                    usercreate.Department=u.Department__c;
                    usercreate.EmployeeNumber=u.Commerce_ID__c;

                    usercreate.userroleid='00E400000017yxs';
                    usercreate.ProfileId='00e40000001BeY9';

                    usercreate.User_External_Unique_ID__c=(u.CoreID__c).toUpperCase() ;
                    usercreate.FederationIdentifier=(u.CoreID__c).toUpperCase() ;

                    usercreate.TimeZoneSidKey='America/Chicago';
                    usercreate.CurrencyIsoCode = 'USD';
                    usercreate.LocaleSidKey = 'en_US';
                    usercreate.EmailEncodingKey = 'ISO-8859-1';
                    usercreate.LanguageLocaleKey = 'en_US';

                    usercreate.UserPermissionsMobileUser = false;
                    usercreate.ReceivesInfoEmails =false;
                    usercreate.ReceivesAdminInfoEmails =false;
                    usercreate.UserPermissionsSFContentUser = false;
                    usercreate.UserPreferencesContentNoEmail = true;
                    usercreate.UserPreferencesContentEmailAsAndWhen = false;

                    Database.DMLOptions dlo=new Database.DMLOptions();
                    dlo.EmailHeader.triggerUserEmail =false;
                    dlo.EmailHeader.triggerAutoResponseEmail=false;
                    usercreate.setOptions(dlo); 

                    newUsers.add(usercreate);  
                }
            } 
            
            if (newUsers!= null && newUsers.size()>0){
                insert newUsers;  
                System.debug('>>>>>>>>>Users Created ' );
            }

        } catch(DMLException e) {
            Database.rollback(sp);   
            System.debug('The following exception has occurred : ' + e.getMessage());
            System.debug('Cause: ' + e.getCause());    
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());  
        }
    }
}