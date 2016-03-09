public class Account_SA_Tracker {

    /*
     * Created by: Rajesh Krishnaiah
     * Creation date: 02-Dec-2013
     * Test Class: Account_SA_TrackerTest
     * Description: Display NPI SA Tracker data
     *
     * Change history:
     * Changed on:
     * Changed by:
     * Description:
     */
    public List<NPI_Customer_SA_Tracker__c> sa_tracker_data {get; set;}
	private Id keyAccountId = null;
    
    public Account_SA_Tracker(ApexPages.StandardController controller) {
    	Account a = (Account)controller.getRecord();
        List<Account> accounts = [select id, key_account__c from Account where id = :a.id];
		if (!accounts.isEmpty())
        	keyAccountId = accounts[0].key_account__c;
    }
    
    public void init() {
        if (keyAccountId != null) {
            sa_tracker_data = [SELECT Business_Unit__c,Product__r.name,NPI_APC__c,
                    NPI_Country__c, SA_Status__c,
                    NPI_SA_Date__c,NPI_Segment_Code__c, NPI_In_Market_Date__c,
                    NPI_FCS_Qty__c,NPI_FSC_Date__c
             FROM NPI_Customer_SA_Tracker__c 
             WHERE Key_Account__c = :keyAccountId
             AND NPI_SA_Date__c >= LAST_N_DAYS:180
             ORDER BY NPI_SA_Date__c DESC];
        }
    }
}