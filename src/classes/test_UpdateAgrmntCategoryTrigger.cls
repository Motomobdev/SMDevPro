@isTest
private class test_UpdateAgrmntCategoryTrigger
{
    static testmethod void executeTrigger()
    {
        // Negative test
        profile pro=[select id,Name from Profile where Name='Apttus GTM' limit 1];
        User u;
        if (pro.id != null)
        {
            system.assertequals(pro.Name,'Apttus GTM');
            List<User> users = 
                [select Id from user where profileid =: Pro.id and ISActive=true limit 1];
            if (! users.isEmpty()) {
                system.runas(users[0])   
                {
                    Apttus__APTS_Agreement__c agreement=new Apttus__APTS_Agreement__c();
                    insert agreement;
                }
           }
        }
        
        // Positive Test
        pro=[select id from Profile where Name='Apttus Indirect SC Contract Manager' limit 1];
        if (pro.id != null)
        {
            List<User> users = 
                [select Id from user where profileid =: Pro.id and ISActive=true limit 1];
            if (! users.isEmpty()) {
                system.runas(users[0])   
                {
                    Apttus__APTS_Agreement__c agreement=new Apttus__APTS_Agreement__c();
                    insert agreement;
                }
           }
        }       
    }
}