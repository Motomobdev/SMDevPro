@isTest(SeeAllData=true)
public class ShowchildForCampaignCLStest {
     
     static testMethod void testShowchild() {
     
     Campaign c = new Campaign();
           ApexPages.StandardController sc = new ApexPages.StandardController(c);
        ShowchildForCampaignCLS sph = new ShowchildForCampaignCLS (sc);

        PageReference pageRef = Page.CampaignHierarchy;
        pageRef.getParameters().put('id', String.valueOf(c.Id));
        Test.setCurrentPage(pageRef);
     
        }
    
 }