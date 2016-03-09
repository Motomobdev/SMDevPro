/**
 * @author           Gangadhar Rachakonda
 * @version          1.0 
 * @date             8/5/2014
 * @Status           Developed
 * @description      The main purpose of this class is for performing DML operations in objects  for the Test Class Data
 */

global class PR_DataFactory_Utility_Test
{
  // <OBJECTIVE>
   // This method  will Fetch a Record From the Profile object   
   // </OBJECTIVE>   
   // <RETURNS>
   //    Profile
   // </RETURNS> 
    public static Profile getProfile()
     {
        
        return [select id from profile where name='System Administrator'];
     }
   // <OBJECTIVE>
   // This method  will create or Insert a Record into the User object   
   // </OBJECTIVE>   
   // <RETURNS>
   //    USER
   // </RETURNS>  
  Public static User createTestUser(string alias,string email,string emailkey,string lastname,string langlockey,
                             string localsidekey,Id ProfileId,string country,string timezone, string usrname)
  {
     List<User> userList = [Select id from User where username = :usrname LIMIT 1];
     User usr = null;
     if (userList.size() == 0)
     {
         usr = new User(alias = alias, 
                         email= email,
                         emailencodingkey = emailkey, 
                         lastname = lastname, 
                         languagelocalekey =langlockey,
                         localesidkey =localsidekey, 
                         profileid = ProfileId, 
                         country = country,
                         timezonesidkey = timezone , 
                         username = usrname
                         );
         insert usr;
      }
      else
      {
         usr = userList.get(0); 
      }
      return usr;
  }
  // <OBJECTIVE>
   // This method  will create or Insert a Record into the User object  with ManagerId
   // </OBJECTIVE>   
   // <RETURNS>
   //    USER
   // </RETURNS>  
  Public static  User createTestUserhavingManager(string alias,string email,string emailkey,string lastname,string langlockey,
                             string localsidekey,Id ProfileId,string country,string timezone, string usrname,Id ManagerId)
  {
     List<User> userList = [Select id from User where username = :usrname LIMIT 1];
     User usr = null;
     if (userList.size() == 0)
     {

         usr = new User(alias = alias, 
                         email= email,
                         emailencodingkey = emailkey, 
                         lastname = lastname, 
                         languagelocalekey =langlockey,
                         localesidkey =localsidekey, 
                         profileid = ProfileId, 
                         country = country,
                         timezonesidkey = timezone , 
                         username = usrname,
                         ManagerId = ManagerId
                         );
        insert usr;
     } 
     else
     {
        usr = userList.get(0);
        usr.ManagerId = ManagerId;
        update usr;
     }
     return usr;
  }
  // <OBJECTIVE>
   // This method  will create or Insert a Record into the Account object   
   // </OBJECTIVE>   
   // <RETURNS>
   //    Account
   // </RETURNS>  
  
  Public static  Account createTestAccount(string Name,string Region,string BussinessOutlook,string Industrytrends,string Keycustomers,
                                string PositionInMarket,string EntityEstab,string DecMaking,string BussEntityType,
                                 string HeadQutrLoc, string TechType)
  {
     Account acc = new Account(Name = Name,
                                Region__c = Region,
                                General_Business_Outlook__c = BussinessOutlook,
                                General_industry_trends__c = Industrytrends,
                                Key_customers__c =Keycustomers,
                                Position_In_Market__c=PositionInMarket,                        
                                Entity_Established_State_Country__c = EntityEstab,
                                Decision_Making_Philosophy__c = DecMaking,
                                Business_Entity_Type__c = BussEntityType,
                                Head_Quarter_Location__c  = HeadQutrLoc,
                                Technology_Type__c = TechType
                                );
          insert acc;
          return acc;  
  }
  // <OBJECTIVE>
   // This method  will create or Insert a Record into the PMD_Program__c object   
   // </OBJECTIVE>   
   // <RETURNS>
   //    PMD_Program__c
   // </RETURNS>  
  Public static  PMD_Program__c createProgramrecord(string Name)
  {
     PMD_Program__c prgm = new PMD_Program__c(Name = Name);    
    insert prgm;
    return prgm;
  }
  // <OBJECTIVE>
   // This method  will create or Insert a Record into the PMD_Project__c object   
   // </OBJECTIVE>   
   // <RETURNS>
   //  PMD_Project__c 
   // </RETURNS>  
  Public static  PMD_Project__c createProjectrecord(string Name, Id ProgramId )
  {
    PMD_Project__c prj = new PMD_Project__c(Name = Name,
                                             Program_ID__c = ProgramId 
                                             ); 
    insert prj; 
    return prj;
  }
  // <OBJECTIVE>
   // This method  will create or Insert a Record into the Project_Ranging__c object   
   // </OBJECTIVE>   
   // <RETURNS>
   //    Project_Ranging__c
   // </RETURNS>  
   Public static  Project_Ranging__c  createProjectRanging( Id AccountId,Id OwnerId,Id ProjectId,string Status,Date NxtMilestoneDate )
  {
   Project_Ranging__c pr = new Project_Ranging__c(Account__c = AccountId,
                                                   Owner__c = OwnerId,
                                                   Project__c = ProjectId,
                                                   Status__c = Status,
                                                   Next_Milestone_Date__c = NxtMilestoneDate 
                                                   
                                                   );
                 insert pr;
                 return pr;
                                      
  } 
  // <OBJECTIVE>
   // This method  will create or Insert a Record into the Project_Ranging__c object   with Owner__C Is Null 
   // </OBJECTIVE>   
   // <RETURNS>
   //    Project_Ranging__c
   // </RETURNS>  
  Public static  Project_Ranging__c  createProjectRangingNoOwner( Id AccountId,Id ProjectId,string Status,Date NxtMilestoneDate )
  {
   Project_Ranging__c pr = new Project_Ranging__c(Account__c = AccountId,
                                                   
                                                   Project__c = ProjectId,
                                                   Status__c = Status,
                                                   Next_Milestone_Date__c = NxtMilestoneDate 
                                                   
                                                   );
                 insert pr;
                 return pr;
                                      
  }
  // <OBJECTIVE>
   // This method  will create  a Record in  PR_Status__c Custom setting    
   // </OBJECTIVE>   
   
  public static void insertStatuses(List<string> listOfStatus) 
  {
      List<PR_Status__c> listOfPrStatus = new List<PR_Status__c>();
      integer i = 0;
      
      for(string status: listOfStatus)
      {
          PR_Status__c prStatus = new PR_Status__c();
          
          prStatus.Name = 'TestStatus' + i++;
          prStatus.PR_FieldStatus__c = status;
          
          listOfPrStatus.add(prStatus);
      }
      
      insert listOfPrStatus;
  }
  // <OBJECTIVE>
   // This method  will create or Insert a Record in PR_Inline__c custom setting  
   // </OBJECTIVE>   
   // <RETURNS>
   //    PR_Inline__c 
   // </RETURNS> 
  public static PR_Inline__c insertInlineBody(string Message) 
  {
    PR_Inline__c prInline = new PR_Inline__c ();
    prInline.Name  = 'TextMessage';
    prInline.Message__c =Message;
    insert prInline;
    return prInline;
   }
 }