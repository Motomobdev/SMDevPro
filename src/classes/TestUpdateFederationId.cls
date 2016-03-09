@IsTest

/*
 * Author: Rajesh Krishnaiah
 * Creation Date: 23-Mar-2011
 * Description: Test cases for testing update federation trigger id on the user object.
 *              The federation field should be in uppercase for the single sign on to work.
 */
private class TestUpdateFederationId {

    static testMethod void updatefederation_id() {       

        Profile standardProfile = [Select Id from Profile Where Name = 'Standard User' LIMIT 1];
        
        User u = new User();
            u.FirstName = 'Test';
            u.LastName = 'User';
            u.FederationIdentifier = 'test123';
            
            u.Username = 'test123@motorola.com';
            u.Email ='test123@motorola.com';
            u.Alias = 'tstusr';
            u.CommunityNickname = 'tuser';
            u.TimeZoneSidKey = 'America/Chicago';
            u.LocaleSidKey ='en_US';
            u.EmailEncodingKey ='ISO-8859-1';
            u.ProfileId = standardProfile.Id;
            u.LanguageLocaleKey = 'en_US';
           
        Insert u;
       
        String fedId = [Select FederationIdentifier From User Where Id = :u.id LIMIT 1].FederationIdentifier;
        
        System.assertEquals(fedId, 'TEST123');   
    }
}