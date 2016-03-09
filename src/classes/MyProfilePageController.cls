/**
 * An apex class that keeps updates of a portal user in sync with its corresponding contact.
   Guest users are never able to access this page.
 */
public class MyProfilePageController {
/*
    private User user;
    private boolean isEdit = false;
    
    public User getUser() {
        return user;
    }

    public MyProfilePageController() {
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }
    
    public Boolean getIsEdit() {
        return isEdit;
    }
    
    public void edit() {
        isEdit=true;
    }    
    
    public void save() {
        if (user.contact != null) {              
            setContactFields(user.contact);
        }
        
        try {
            update user;
            if (user.contact != null) { 
                update user.contact;
            }
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }
    
    public PageReference changePassword() {
        return Page.ChangePassword;
    }
    
    public void cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User
                WHERE id = :UserInfo.getUserId()];
    }
    
    private void setContactFields(Contact c) {
        c.title = user.title;
        c.firstname = user.firstname;
        c.lastname = user.lastname;
        c.email = user.email;
        c.phone = user.phone;
        c.mobilephone = user.mobilephone;
        c.fax = user.fax;
        c.mailingstreet = user.street;
        c.mailingcity = user.city;
        c.mailingstate = user.state;
        c.mailingpostalcode = user.postalcode;
        c.mailingcountry = user.country;
    }

    static testMethod void testSave() {         
        // Modify the test to query for a portal user that exists in your org
        User existingPortalUser = [SELECT id, profileId, userRoleId FROM User WHERE UserRoleId <> null AND UserType='CustomerSuccess' LIMIT 1];
        System.assert(existingPortalUser != null, 'This test depends on an existing test portal user to run');
        
        String randFax = Math.rint(Math.random() * 1000) + '5551234';
        
        System.runAs(existingPortalUser) {
            MyProfilePageController controller = new MyProfilePageController();
            System.assertEquals(existingPortalUser.Id, controller.getUser().Id, 'Did not successfully load the current user');
            System.assert(controller.isEdit == false, 'isEdit should default to false');
            controller.edit();
            System.assert(controller.isEdit == true);
            
            controller.cancel();
            System.assert(controller.isEdit == false);
            
            controller.getUser().Fax = randFax;
            controller.save();
            System.assert(controller.isEdit == false);
        }
        
        // verify that the user and contact were updated
        existingPortalUser = [Select id, fax, Contact.Fax from User where id =: existingPortalUser.Id];
        System.assert(existingPortalUser.fax == randFax);
        System.assert(existingPortalUser.Contact.fax == randFax);
    }
*/
}