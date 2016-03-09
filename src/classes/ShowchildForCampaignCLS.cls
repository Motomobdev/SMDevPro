public class ShowchildForCampaignCLS {
Private Id campID;

 public List<Campaign> campaignList{get;set;}

    public ShowchildForCampaignCLS(ApexPages.StandardController controller) {
    campaignList = new List<Campaign>();
   campID=  ApexPages.currentPage().getParameters().get('Id');
   campaignList = [Select id,StartDate,EndDate,Parentid,Name,Parent.Name,Category__c,Sub_Category__c,parent.HierarchyBudgetedCost,ExpectedRevenue,BudgetedCost,ActualCost,HierarchyExpectedRevenue,HierarchyActualCost FROM Campaign WHERE Parentid = :campID];
   
   
}
}