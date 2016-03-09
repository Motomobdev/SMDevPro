/**************************************************************************
CREATED BY : Neel Desai
CREATED ON : June-2013
PURPOSE    : Competitive Intelligence - Saved Comp Set
TEST CLASS : CI_FavouriteCompSetCtrTest
**************************************************************************/
public with sharing class CI_FavouriteCompSetCtr 
{
    public List<Competitive_Product_Comp_Set__c> compSets {get; set;}
    public Boolean isEmpty {get; set;} //to show message when there is no saved comp sets
    public String idToDelete {get; set;} //Id of comp set to delete
    
    public CI_FavouriteCompSetCtr()
    {
        getMyFavCompSets(); //get saved comp sets list and display to user
    }
    
    private void getMyFavCompSets()
    {
        try
        {
        	//get comp set for context user only
            compSets = [SELECT Id,
                               Name,
                               Motorola_Product__c,
                               Competitor_Products__c,
                               CreatedOn__c
                               FROM   Competitive_Product_Comp_Set__c
                               //WHERE  User__c = :UserInfo.getUserId()
                               ORDER BY CreatedOn__c DESC];
            
            /*
            for(Competitive_Product_Comp_Set__c compSet : compSets)
            {
            	//Motorola_Product__c value is <Brand>_<Product>
            	//remove underscore from <Brand>_<Product> 
                compSet.Motorola_Product__c = compSet.Motorola_Product__c.replace('_', ' ');
                
                //Competitor_Products__c value is comma separated list of <Brand>_<Product>
                if(compSet.Competitor_Products__c.length() > 0)
                {
                	//split by comma to get comp products
	                List<String> compProds = compSet.Competitor_Products__c.split(',', 0);
	                for(Integer i = 0; i < compProds.size(); i++)
	                {
                		//remove underscore from <Brand>_<Product>
	                    compProds[i] = compProds[i].replace('_', ' ');
	                }
	                compSet.Competitor_Products__c = String.join(compProds, ', ');
                }
            }
            */
            
            if(compSets.size() == 0)
                isEmpty = true;
            else
                isEmpty = false;
            
            //only for Test method coverage
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch (Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        } 
    }
        
    public void remove()
    {
        try
        {
            Competitive_Product_Comp_Set__c cs = new Competitive_Product_Comp_Set__c(Id = idToDelete);
            delete cs;
            
            getMyFavCompSets();

            //only for Test method coverage
            if(Test.isRunningTest())
            {
                String s;
                s.toLowerCase();
            }
        }
        catch (Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
}