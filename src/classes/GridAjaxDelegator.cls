/**
 * This class is used for custom Ajax requests made from GridBuddy grids
 */ 
public with sharing class GridAjaxDelegator {
    
    public String jsonResponse {get; private set;}
    
    public void processRequest() {
        // determine what the ajax request is for
        String reqType = ApexPages.CurrentPage().getParameters().get('reqType');
        
        if (reqType == 'trackGridView') {
            trackGridView();
        } else if (reqType == 'trackGridSave') {
            trackGridSave();
        } else if (reqType == 'trackGridExport') {
            trackSimpleAction('Grid Export');
        } else if (reqType == 'trackReorderColumns') {
            trackSimpleAction('Reorder/Hide Columns');
        } 
    }
    
    /**
     * Inserts a record in the Click-Through Analytics object (GridBuddy_Usage_Analytics__c) 
     *   the first time a grid has been accessed in the user's session
     */
    public void trackGridView() {         
        String sessionId = UserInfo.getSessionId();
        String gridName = getGridNameParam();
        
        if (gridName != null && gridName.length() > 0) {
        
            List<GridBuddy_Usage_Analytics__c> recordsForSession = [select Id from GridBuddy_Usage_Analytics__c 
                                                            where Session__c = :sessionId 
                                                            and Grid_Name__c = :gridName
                                                            limit 1];
    
            if (recordsForSession.size() == 0) {
                // insert a record for this session
                GridBuddy_Usage_Analytics__c record = new GridBuddy_Usage_Analytics__c(
                    Type__c = 'Grid View',
                    Grid_Name__c = gridName,
                    Session__c = sessionId,
                    User__c = UserInfo.getUserId()
                );
                
                try {
                    insert record;                
                } catch (Exception e) {
                    System.debug('*** GridAjaxDelegator.trackGridView: Failed to insert tracking record: '+e.getMessage()+', '+e);
                }            
            }
        }
        
        // return an empty response
        this.jsonResponse = '{}';
    }
    
    /**
     * Inserts a record in the Click-Through Analytics object (Usage_Analytics__c) 
     *   when the user has saved on the grid
     */
    public void trackGridSave() {
        String gridName = getGridNameParam();
        String fieldAPINames = getFieldAPINamesParam();
                
        // insert a record for the save action
        GridBuddy_Usage_Analytics__c record = new GridBuddy_Usage_Analytics__c(
            Type__c = 'Grid Save',
            Grid_Name__c = gridName,
            Field_API_Names__c = fieldAPINames,
            User__c = UserInfo.getUserId()
        );
        
        try {
            insert record;                
        } catch (Exception e) {
            System.debug('*** GridAjaxDelegator.trackGridSave: Failed to insert tracking record: '+e.getMessage()+', '+e);
        }
        
        // return an empty response
        this.jsonResponse = '{}';    
    }  
    
    /**
     * Inserts a record in the Click-Through Analytics object (Usage_Analytics__c) 
     *   when the user clicks a simple grid action, such as Export or Reorder/Hide Columns
     */
    public void trackSimpleAction(String actionType) {
        
        String gridName = getGridNameParam();
        
        // insert a record for the action
        GridBuddy_Usage_Analytics__c record = new GridBuddy_Usage_Analytics__c(
            Type__c = actionType,
            Grid_Name__c = gridName,
            User__c = UserInfo.getUserId()
        );
        
        try {
            insert record;                
        } catch (Exception e) {
            System.debug('*** GridAjaxDelegator.trackSimpleAction: Failed to insert tracking record for actionType ['+actionType+']: '+e.getMessage()+', '+e);
        }
        
        // return an empty response
        this.jsonResponse = '{}';
        
    }       
       
    private String getGridNameParam() {
        return ApexPages.CurrentPage().getParameters().get('gname');    
    }
    
    private String getFieldAPINamesParam() {
        return ApexPages.CurrentPage().getParameters().get('fieldNames');        
    }        
    
    
    @isTest
    public static void testAll() {
        
        // test grid view tracking
        ApexPages.CurrentPage().getParameters().put('reqType', 'trackGridView');
        ApexPages.CurrentPage().getParameters().put('gname', 'Test Grid');
        
        GridAjaxDelegator delegator = new GridAjaxDelegator();
        delegator.processRequest();
        
        List<GridBuddy_Usage_Analytics__c> trackingRecord = [select Id from GridBuddy_Usage_Analytics__c 
            where Grid_Name__c = 'Test Grid'
            and Type__c = 'Grid View' 
            and Session__c != null
            limit 1];
        
        System.assert(trackingRecord.size() > 0);
                
        // test grid save tracking
        ApexPages.CurrentPage().getParameters().put('reqType', 'trackGridSave'); 
        
        String fieldNamesJSON = '{"Case:Service_Renewal_Opportunity__c":["SuppliedName"],"Opportunity":["Name"]}';
        ApexPages.CurrentPage().getParameters().put('fieldNames', fieldNamesJSON);
        delegator.processRequest();
        
        trackingRecord = [select Id, Field_API_Names__c from GridBuddy_Usage_Analytics__c 
            where Grid_Name__c = 'Test Grid' 
            and Type__c = 'Grid Save'
            and Session__c = null
            limit 1];
           
        System.assert(trackingRecord.size() > 0);        
        System.assertEquals(fieldNamesJSON, trackingRecord[0].Field_API_Names__c);
        
        // test grid export tracking
        ApexPages.CurrentPage().getParameters().put('reqType', 'trackGridExport');
        delegator.processRequest();
        
        trackingRecord = [select Id, Field_API_Names__c from GridBuddy_Usage_Analytics__c 
            where Grid_Name__c = 'Test Grid' 
            and Type__c = 'Grid Export'
            limit 1];
           
        System.assert(trackingRecord.size() > 0);  
    }

}