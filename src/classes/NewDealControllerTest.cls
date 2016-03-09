@isTest
public class NewDealControllerTest 
{
	public static testMethod void testConstructor() 
	{
		Test.startTest();
		NewDealController ndc = new NewDealController();
		Test.stopTest();
	}
	
	public static testMethod void testCreateDeal()
	{
		Test.startTest();
		PageReference vfPage = new PageReference('/apex/NewDealController'); 
		vfPage.getParameters().put('ID','0014000000nNCxL');   
		Test.setCurrentPage(vfPage);
		NewDealController ndc = new NewDealController();
		ndc.pageIsValid = true;

		Account acct = new Account();
		acct.Name = 'BRIGHTSTAR';
		
		Opportunity oppt = new Opportunity();
		oppt.Name = 'Test SA Data';
        oppt.RecordTypeId = '012M00000004k7GIAQ';
        oppt.AccountId = '0014000000Hr1JCAAZ';
        oppt.CloseDate = Date.today().AddYears(1);
        oppt.StageName = '1. Prospecting';
        
        List<Pricebook2> standardPb = new List<Pricebook2>();
        Pricebook2 pb = new Pricebook2();
        pb.Id = '01s400000006B0eAAE';
        pb.Name = 'Standard Price Book';
        pb.isActive = true;
        standardPb.add(pb);
        upsert standardPb;
        
        oppt.Pricebook2Id = standardPb[0].Id;
		
		ndc.oppt = oppt;
		ndc.acct = acct;
		ndc.createDeal();
		ndc.opportunityCreation = true;
		ndc.createDeal();
		Test.stopTest();
	} 	
	
	public static testMethod void testCancel()
	{
		Test.startTest();
		NewDealController ndc = new NewDealController();
		ndc.cancel();
		Test.stopTest();
	} 	
}