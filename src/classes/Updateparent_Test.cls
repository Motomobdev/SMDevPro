@isTest (SeeAllData=True)
public class Updateparent_Test{
     
    static testMethod void testupdatingdate(){

    test.startTest(); 
 Account ac1 = new Account(name = 'CampaignProductMethodsTest');
 
  Campaign campaigns = new Campaign();
     campaigns.RecordTypeId='01240000000DuXb';
   campaigns.Status = 'Planned';
   campaigns.Name ='Test';
   insert campaigns;
   
    Campaign childcampaigns = new Campaign();
  childcampaigns.StartDate=system.today()+1;
   childcampaigns.EndDate=system.today()+91;
    childcampaigns.Name ='Test12';
   childcampaigns.RecordTypeId='01240000000DuXb';
   childcampaigns.ParentId = campaigns.Id;
    childcampaigns.Status = 'Planned';
   insert childcampaigns;
   campaigns.StartDate=childcampaigns.StartDate;
   campaigns.EndDate= childcampaigns.EndDate;
   update childcampaigns;
     Test.stopTest();  
     }
     }