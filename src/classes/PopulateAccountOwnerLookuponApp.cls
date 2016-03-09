public class PopulateAccountOwnerLookuponApp{
	
	private static boolean istestmode = false;
	
	public static void setPopulateAccountOwneronApp(List<Application__c> app){
		for(Application__c a : app){
			a.AcctOwnerApp__c = a.AcctOwnerAppID__c;
		}
	}
	
	private testmethod static void TestMethodSetAcctOwnerApp() {
	   isTestMode = true;    
	   Account acc = new Account(Name='account');
		insert acc;
	   Application__c a = new Application__c(Name='app', Account__c=acc.Id, Application_Category__c='fakeCategory', Description__c='fakeDescription', Available_For_Use__c=true);    
	   List<Application__c> ds = new List<Application__c>();    
	   ds.add(a);
	   insert ds;    
	   setPopulateAccountOwneronApp(ds);
	   //setPopulateAccountOwneronApp(a);
	
	}
}