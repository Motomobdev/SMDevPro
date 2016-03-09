public class AutomateManagerUpdateFromCoreDirectory {

    /*
     * Created by: Lipsa Mishra 
     * Creation date: 12-09-2014 Test
     * Class:AutomateManagerUpdateFromCoreDirTest
     * Description: Update salesforce users with data from motorola core directory 
     * Change history: 
     * Changed on:
     * Changed by:
     */

    public void process() {

        try {
            updateMotCoreDir();
            updateManagerCoreID();
            updateManagerID();
        } catch(Exception e) {
            System.debug('The following exception has occurred : ' + e.getMessage());
            System.debug('Stack trace: ' + e.getStackTraceString());  
        }

    }

    private void updateMotCoreDir() {

        list<Motorola_Core_Directory__c> motCoreA = new list<Motorola_Core_Directory__c>();
        list<Motorola_Core_Directory__c> motCoreC = new list<Motorola_Core_Directory__c>();
        Map<String,Motorola_Core_Directory__c> myBMap = new Map<String,Motorola_Core_Directory__c>();
        try {

            // Retrieve active employees from CoreDirectory object 
            motCoreA = [SELECT Commerce_ID__c,CoreID__c,Manager_Core_ID__c,SupervisorCommerceID__c 
                        FROM Motorola_Core_Directory__c  WHERE DirectoryStatus__c = 'A' and EmployeeType__c='R' and SupervisorCommerceID__c !=null];


            for (Motorola_Core_Directory__c b : motCoreA){
                myBMap.put(b.Commerce_ID__c, b);
            }

            for (Motorola_Core_Directory__c a: motCoreA){
                if(myBMap.containsKey(a.SupervisorCommerceID__c)){  
                    if ( null != myBMap.get(a.SupervisorCommerceID__c) && null != myBMap.get(a.SupervisorCommerceID__c).CoreID__c ) {         
                        a.Manager_Core_ID__c=myBMap.get(a.SupervisorCommerceID__c).CoreID__c;
                        motCoreC.add(a);
                    }
                }
            }

            if (motCoreC!= null && motCoreC.size()>0){

                System.debug('updateMotCoreDir :: '+motCoreC.size());
                update motCoreC;
                System.debug('Motorola_Core_Directory :: Manager Core Id Updated');
            }

        } catch(Exception e) {            
            System.debug('Motorola_Core_Directory  :: Update Manager Core Id Failed');
            System.debug('The following exception has occurred : ' + e.getMessage());   
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());  
        }         

    }

    private void updateManagerCoreID() {

        List<User> allSFUsers = new List<User>();
        List<User> updatedUsers = new List<User>(); 
        list<Motorola_Core_Directory__c> motCoreUsers = new list<Motorola_Core_Directory__c>();    
        Map<String,Motorola_Core_Directory__c> myCMap = new Map<String,Motorola_Core_Directory__c>();
        Savepoint sp1;

        try {

            allSFUsers = [select id, federationidentifier, ManagerId, Manager_Core_ID__c  
                          from User where federationidentifier!=null and isactive = true ];
            motCoreUsers = [SELECT Commerce_ID__c,CoreID__c,Manager_Core_ID__c,SupervisorCommerceID__c 
                            FROM Motorola_Core_Directory__c  WHERE DirectoryStatus__c = 'A' and EmployeeType__c='R' and CoreID__c !=null and Manager_Core_ID__c !=null ];


            for (Motorola_Core_Directory__c b : motCoreUsers){
                myCMap.put((b.CoreID__c).toUpperCase(), b);
            }

            for (User a: allSFUsers){
                if( myCMap.containsKey(a.federationidentifier) ){ 

                    if (null != myCMap.get(a.federationidentifier) && null != myCMap.get(a.federationidentifier).Manager_Core_ID__c ) {                            
                        a.Manager_Core_ID__c=myCMap.get(a.federationidentifier).Manager_Core_ID__c;
                        updatedUsers.add(a);
                    }
                }
            }

            if (updatedUsers!= null && updatedUsers.size()>0){
                System.debug('updateManagerCoreID :: '+updatedUsers.size());
                sp1 = Database.setSavepoint();
                update updatedUsers;
                System.debug('User :: Manager Core Id Updated');
            }

        } catch(Exception e) {
            Database.rollback(sp1);
            System.debug('User :: Update Manager Core Id Failed');
            System.debug('The following exception has occurred : ' + e.getMessage());    
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());  
        }  


    }

    private void updateManagerID() {

        List<User> allSFUsers1 = new List<User>();
        List<User> allSFUsers2 = new List<User>();
        List<User> allSFUsers3 = new List<User>();
        Map<String,User> allUserMap = new Map<String,User>();
        Savepoint sp2;
        try {

            // Get all Salesforce users
            allSFUsers1 = [select id, federationidentifier, ManagerId, Manager_Core_ID__c  
                           from User where federationidentifier!=null and Manager_Core_ID__c!=null and isactive = true ];
            allSFUsers2=allSFUsers1;

            for (User user : allSFUsers2){
                allUserMap.put(user.federationidentifier, user);
            }

            for (User usr: allSFUsers1){
                if(allUserMap.containsKey(usr.Manager_Core_ID__c)){  
                    if ( null != allUserMap.get(usr.Manager_Core_ID__c)  && null != allUserMap.get(usr.Manager_Core_ID__c).id ) { 
                        if (usr.federationidentifier !=usr.Manager_Core_ID__c){                 
                            usr.ManagerId=allUserMap.get(usr.Manager_Core_ID__c).id;
                            allSFUsers3.add(usr);
                        }
                    }
                }
            }
            if (allSFUsers3!= null && allSFUsers3.size()>0){
                System.debug('updateManagerID :: '+allSFUsers3.size());
                sp2 = Database.setSavepoint();
                update allSFUsers3;
                System.debug('User :: Manager Id Updated');
            }

        } catch(Exception e) {
            Database.rollback(sp2);
            System.debug('User :: Update ManagerId Failed');
            System.debug('The following exception has occurred : ' + e.getMessage());   
            System.debug('Line number: ' + e.getLineNumber());    
            System.debug('Stack trace: ' + e.getStackTraceString());  
        }  

    }
}