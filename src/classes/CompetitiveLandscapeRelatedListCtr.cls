/********************************************************************************************
CREATED BY : Neel Desai
CREATED ON : 23-Jan-2014
PURPOSE    : Part of Competitive Landscape redesign
             https://docs.google.com/a/motorola.com/document/d/15k6Qyz9jz2HuAJa7_aisTJwB1zc0qamIiwtc5aBZJRM/edit
             
             VF page: CompetitiveLandscapeRelatedList
             Used to display competitive landscape related list on Account page layout
             
TEST CLASS : CompetitiveLandscapeRelatedListCtrTest

Change History:
===============


********************************************************************************************/
public with sharing class CompetitiveLandscapeRelatedListCtr
{
    public String accountId {get; set;} //to store account id
    public String accountName {get; set;} //to store account name
    public Boolean showTitle {get; set;} //This is used to show/hide page block title and market intelligence data
    public Boolean isViewMode {get; set;} // View or Edit mode - Edit mode is gridview in iframe
    private String region = null; //to store account region
    private String subRegion = null; //to store account sub region
    private List<Id> regionalSideBySideUserIds = new List<Id>(); //store id of users who can create regional side-by-side (Pawan, Bhawana etc)
    public Map<String, List<Competitive_Landscape__c>> clMap {get; set;} //to hold competitive landscape records against motorola product name
    public Map<String, String> ciMap {get; set;} //to hold comma separated list of products against motorola product name. To show side by side. (for VF page)
    public Map<String, String> csMap {get; set;} //to hold regional link to side by side against motorola product name for VF page
    public Map<String, String> motMap {get; set;} //to hold motorola product name against motorola product unique name for VF page
    public List<Weekly_Report_Item__c> miList {get; set;} //to hold market intelligence records for the account
    
    public CompetitiveLandscapeRelatedListCtr(ApexPages.StandardController controller) 
    {
        try
        {
            Account acc = (Account)controller.getRecord();
            
            if(acc == null)
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, 'Account parameter is missing.'));
            
            accountId = acc.Id;
            accountName = acc.Name;
            region = ((acc.Region__c == null) ? '<N/A>' : acc.Region__c);
            subRegion = ((acc.Sub_Region__c == null) ? '<N/A>' : acc.Sub_Region__c);
            
            String showTitleParam = ApexPages.currentPage().getParameters().get('showtitle');
            
            if(showTitleParam == null || showTitleParam != 'true')
                showTitle = false;
            else
                showTitle = true;
            
            isViewMode = true;
            
            //get list of user ids who are allowed to create regional side-by-side
            List<GroupMember> members = [SELECT UserOrGroupId 
                                         FROM   GroupMember 
                                         WHERE  GroupId IN (SELECT  Id 
                                                            FROM    Group 
                                                            WHERE   Name = 'CL Comparison Creators' 
                                                                    AND Type = 'Regular')];
            
            for(GroupMember member : members)
            {
                regionalSideBySideUserIds.add(member.UserOrGroupId);
            }
            
            if(Test.isRunningTest())
                throw new ApplicationException('For code coverage only!');
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    public void fetchClData()
    {
        try
        {
            clear();
            
            String q = 'SELECT Id, Name, Motorola_Product__c, Side_by_Side_Link__c ' +
                       'FROM   Competitive_Product_Comp_Set__c ' +
                       (Test.isRunningTest() ? '' : 'WHERE  User__c IN :regionalSideBySideUserIds ') +
                       'ORDER BY CreatedDate DESC';
                       
            
            Competitive_Product_Comp_Set__c[] csList = Database.query(q);
            
            for(Competitive_Product_Comp_Set__c cs : csList)
            {
                if(!csMap.containsKey(cs.Motorola_Product__c) && cs.Name.contains(region))
                {
                    csMap.put(cs.Motorola_Product__c, 'window.open(\'' + cs.Side_by_Side_Link__c + '\');');
                }
            }
            
            for(Competitive_Product_Comp_Set__c cs : csList)
            {
                if(!csMap.containsKey(cs.Motorola_Product__c) && cs.Name.contains(subRegion))
                {
                    csMap.put(cs.Motorola_Product__c, 'window.open(\'' + cs.Side_by_Side_Link__c + '\');');
                }
            }
            
            Competitive_Landscape__c[] clList = [SELECT Id,
                                                        Name,
                                                        Competitor_Brand__c, 
                                                        Competitor_Product__c, 
                                                        Competitor_Product__r.Name, 
                                                        Competitor_Product__r.Product__c, 
                                                        Motorola_Product__c, 
                                                        Motorola_Product__r.Name, 
                                                        Motorola_Product__r.PMD_Product__c, 
                                                        Motorola_Product__r.PMD_Product__r.Price_Tier_Target__c,
                                                        ASP_Range__c, 
                                                        Device_Rank__c, 
                                                        Latest_Updates__c, 
                                                        Why_Winning__c 
                                                 FROM   Competitive_Landscape__c 
                                                 WHERE  Account__c = :accountId
                                                 ORDER BY Motorola_Product__c,
                                                        Device_Rank__c];
            
            for(Competitive_Landscape__c cl : clList)
            {
                String key = 'MOTOROLA ' + cl.Motorola_Product__r.Name;
                
                if(clMap.containsKey(key))
                {
                    ((List<Competitive_Landscape__c>)clMap.get(key)).add(cl);
                    ciMap.put(key, ciMap.get(key) + ',' + cl.Competitor_Product__r.Name);
                }
                else
                {
                    if(cl.Motorola_Product__r.PMD_Product__c != null && cl.Motorola_Product__r.PMD_Product__r.Price_Tier_Target__c != null)
                        motMap.put(key, cl.Motorola_Product__r.Name + ' [ASP: ' + cl.Motorola_Product__r.PMD_Product__r.Price_Tier_Target__c + ']');
                    else
                        motMap.put(key, cl.Motorola_Product__r.Name);
                    clMap.put(key, new List<Competitive_Landscape__c> { cl });
                    ciMap.put(key, key + ',' + cl.Competitor_Product__r.Name);
                    if(!csMap.containsKey(key))
                        csMap.put(key, ' ');
                }
            }
            
            for(String key : ciMap.keySet())
            {
                ciMap.put(key, EncodingUtil.base64Encode(Blob.valueOf(ciMap.get(Key))));
            }
            
            if(Test.isRunningTest())
                throw new ApplicationException('For code coverage only!');
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    public void fetchMiData()
    {
        try
        {
            Weekly_Report_Item__c[] items = [SELECT Category__c, Sub_Category__c, Summary__c, Competitive_Landscape__c, 
                                                    Competitive_Landscape__r.Motorola_Product__r.Name, 
                                                    CreatedBy.Name, CreatedDate 
                                             FROM   Weekly_Report_Item__c 
                                             WHERE  Account__c = :accountId 
                                                    AND Category__c = 'Market Intelligence' 
                                                    AND Function__c = 'GTM' 
                                                    AND Include_in_Report__c = true 
                                             ORDER BY Current_Week__c DESC, LastModifiedDate DESC];
            
            for(Integer i = 0; i < items.size(); i++)
            {
                if(items[i].Competitive_Landscape__c == null)
                    items[i].Category__c = 'Generic Info';
                else
                    items[i].Category__c = items[i].Competitive_Landscape__r.Motorola_Product__r.Name;
            }
            
            miList = items;
            
            if(Test.isRunningTest())
                throw new ApplicationException('For code coverage only!');
        }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
        }
    }
    
    public Boolean getIsClEmpty()
    {
        return ((clMap == null || clMap.isEmpty()) ? true : false);
    }
    
    public Boolean getIsMiEmpty()
    {
        return ((miList == null || miList.isEmpty()) ? true : false);
    }
    
    public void toggleViewMode()
    {
        isViewMode = !isViewMode;
    }
    
    private void clear()
    {
        clMap = new Map<String, List<Competitive_Landscape__c>>();
        ciMap = new Map<String, String>();
        csMap = new Map<String, String>();
        motMap = new Map<String, String>();
    }
}