public class AutomateUserLicenceInactivation {

    /*
     * Created by: Lipsa Mishra 
     * Creation date: 09-08-2014 Test Class:
     * AutomateUserLicenceInactivation Description: Compiles a list of users to
     * inactivate based on their core directory status ,deactivate them ,delete
     * managed licenses and emails the list to the user running this code.
     * Change history: 
     * Changed on: 
     * Changed by: 
     */

    public void process() {

        Map<String, User> activeCoreIds = new Map<String, User>();
        List<User> allUsers = new List<User>();
        List<User> inactiveUsers = new List<User>();
        List<UserLogin> userLogin = new List<UserLogin>();
        String result= 'Other';
        String deletePackageLicenseResult='';
        String id='';
        try {

            // Get all active Salesforce users
            allUsers =[select id, name, email, federationidentifier, profile.name,isactive 
                       from User
                       where isactive = true
                       and federationidentifier != null];

            for (User u : allUsers)
                activeCoreIds.put(u.federationidentifier, u);

            // Retrieve inactive users from CoreDirectory object selecting active users from Salesforce
            List<Motorola_Core_Directory__c> coreDirUsers =
                    [SELECT CoreID__c,DirectoryStatus__c,HRStatus__c,Id,Name
                     FROM Motorola_Core_Directory__c
                     WHERE DirectoryStatus__c != 'A'
                     and coreid__c in :activeCoreIds.keySet() LIMIT 50];


            for (Motorola_Core_Directory__c mc : coreDirUsers) {
                if (activeCoreIds.containsKey(mc.CoreID__c))
                    inactiveUsers.add(activeCoreIds.get(mc.CoreID__c));
            }
            
            // Retrieve UserLogin from inactiveUsers from Salesforce
            List<UserLogin> userFreeze = [Select Id, UserId, IsFrozen, IsPasswordLocked From UserLogin where UserId in 
            (Select id from User where isactive = true and federationidentifier != null)]; 

            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] addresses = new String[] {UserInfo.getUserEmail()};
            addresses.add('cpratt@motorola.com');
            addresses.add('michellelu@motorola.com');
            addresses.add('smandava@motorola.com');
            //addresses.add(Instance_Settings__c.Salesforce_Operations_Administration__c);
            email.setSubject('Users to inactivate: ' + system.today().format());
            email.setToAddresses(addresses);
            String htmlBody = '<html><body>' 
                    + '<table border="1" width="100%" style="border-collapse: collapse;border-style: solid;" cellspacing="10">'
                    + '<thead><tr><th>User ID</th><th>Name</th><th>Core ID</th><th>Email</th><th>Profile</th><th>User Status</th><th>User Package Licenses</th><th>Package Licenses Status</th></tr></thead>';

            List<User> deactivateUsers = new List<User>(); 
            List<User> freezedUsers = new List<User>(); 
            List<UserPackageLicense> deletemanagePackageUsers = new List<UserPackageLicense>(); 
            //List<UserPackageLicense> managePackageUsers = [SELECT Id,PackageLicenseId FROM UserPackageLicense where UserId in:inactiveUsers];             


            for (User u : inactiveUsers) {                
                String userId=u.id;                 
                //List<UserLogin> userFreeze = [Select Id, UserId, IsFrozen, IsPasswordLocked From UserLogin where UserId=:userId];  
                for (UserLogin ul : userFreeze) {
                if(ul.UserId == u.Id && !ul.IsFrozen) {

                //if (!userFreeze[0].IsFrozen)  { 
                    u.isactive = false;
                    deactivateUsers.add(u);               
                    result='Deactivated';

                    id=userId.substring(0, 15);
                    htmlBody += '<tr>'
                            + '<td><a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + id + '?noredirect=1">' 
                            + u.id + '</a></td>'
                            + '<td>' + u.name + '</td>'
                            + '<td>' + u.federationIdentifier + '</td>'
                            + '<td>' + u.email + '</td>'
                            + '<td>' + u.profile.name + '</td>';
                    htmlBody+=  '<td nowrap>' + result + '</td>'; 
                    htmlBody += '<td>';

                    List<UserPackageLicense> managePackageUsers = [SELECT Id,PackageLicenseId FROM UserPackageLicense where UserId =:userId]; 
                    for (UserPackageLicense userPacLicense : managePackageUsers ) {                    
                        htmlBody += '<a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + userPacLicense.PackageLicenseId + '?noredirect=1">' 
                                + userPacLicense.PackageLicenseId + '</a> ';
                        deletemanagePackageUsers.add(userPacLicense);
                    }                
                    htmlBody += '</td>';
                    deletePackageLicenseResult='Package License deleted for User: ' + u.name;
                    htmlBody+=  '<td>' + deletePackageLicenseResult + '</td>';
                    htmlBody += '</tr>';
                } 
            }   
                //else {
                //    freezedUsers.add(u); 
                //}
            }            

            // Update users as inactive if matched inactive in coredirectory 
            Savepoint sp = Database.setSavepoint();
            try {
                // Remove managed package licences for all users inactivated 
                    delete deletemanagePackageUsers;  
                
                // deactivate users
                    update deactivateUsers;                                 
            } catch(Exception e) {
                Database.rollback(sp);
                result='Deactivation Failed';             
                // Send email
                String errorhtmlBody = '<html><body>';
                errorhtmlBody += 'The following exception has occurred : ' + e.getMessage();
                errorhtmlBody += '</body></html>'; 
                email.setHtmlBody(errorhtmlBody);
                Messaging.SendEmailResult [] r =
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
                //System.debug('The following exception has occurred : ' + e.getMessage());
            }

            htmlBody += '</table>';
            htmlBody += '<h2>Total Number of Inactive Users : ' + deactivateUsers.size() + '</h2>';
            //htmlBody += '<h2>Total Number of Freezed Users : ' + freezedUsers.size() + '</h2>';
            htmlBody += '</body></html>';        
            email.setHtmlBody(htmlBody);
            Messaging.SendEmailResult [] r =
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});  
        } catch(Exception e) {
            System.debug('The following exception has occurred : ' + e.getMessage());
        }

    }
}