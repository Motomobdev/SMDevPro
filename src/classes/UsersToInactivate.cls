public class UsersToInactivate {

   /*
     * Created by: Rajesh Krishnaiah
     * Creation date: 23-Sep-2013
     * Test Class: UsersToInactivateTest
     * Description: Compiles a list of users to inactivate based on their
     * core directory status and emails the list to the user running this code.
     * Change history:
     * Changed on:
     * Changed by:
     * Description:
     */
    public static void process() {
        List<User> allUsers = 
            [select id, name, email, federationidentifier, profile.name
             from User
             where isactive = true
             and federationidentifier != null];

        Map<String, User> activeCoreIds = new Map<String, User>();
        for (User u : allUsers)
            activeCoreIds.put(u.federationidentifier, u);

        List<Motorola_Core_Directory__c> coreDirUsers =
            [SELECT CoreID__c,DirectoryStatus__c,HRStatus__c,Id,Name
             FROM Motorola_Core_Directory__c
             WHERE DirectoryStatus__c != 'A'
             and coreid__c in :activeCoreIds.keySet()];

        List<User> inactiveUsers = new List<User>();
        for (Motorola_Core_Directory__c mc : coreDirUsers) {
            if (activeCoreIds.containsKey(mc.CoreID__c))
                inactiveUsers.add(activeCoreIds.get(mc.CoreID__c));
        }

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        String[] addresses = new String[] {UserInfo.getUserEmail()};
            email.setSubject('Users to inactivate: ' + system.today().format());
        email.setToAddresses(addresses);
        String body = '';
        String htmlBody = '<html><body>' 
            + '<table border="1" width="100%" style="border-collapse: collapse;border-style: solid;" cellspacing="10">'
            + '<thead><tr><th>User ID</th><th>Name</th><th>Core ID</th><th>Email</th><th>Profile</th></tr></thead>';
        
        for (User u : inactiveUsers) {
            
            body += (u.Id + ',' + u.name + ',' + u.federationIdentifier + ',' + u.email + ',' + u.profile.name + '\n');
            htmlBody += '<tr>'
                + '<td><a href="' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + u.id + '"?noredirect=1>' 
                + u.id + '</a></td>'
                + '<td>' + u.name + '</td>'
                + '<td>' + u.federationIdentifier + '</td>'
                + '<td>' + u.email + '</td>'
                + '<td>' + u.profile.name + '</td>'
                + '</tr>';
        }
        
        htmlBody += '</table>';
        
        htmlBody += '<h2>Number of users to inactivate: ' + inactiveUsers.size() + '</h2>';
        htmlBody += '</body></html>';
        email.setHtmlBody(htmlBody);
        
        Messaging.SendEmailResult [] r =
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}