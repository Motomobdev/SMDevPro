/*
 * @author: Cuauhtemoc Munoz
 * @email:  cmunoz@levementum.com
 * @date:  09/05/14
 * @brief:  Created test class for DealDeepCloneController.cls
 */
@isTest (SeeAllData=true)
public class DealDeepCloneTest
{
    public static testMethod void testConstructor()
     {
     	Test.startTest();     
	    	User user = TestUtilities.createLevUser();
			Product2 prod = TestUtilities.createProduct();
			Account acct = TestUtilities.createAccount();
			Opportunity opp = TestUtilities.createOpp(acct);
			Quote quote = TestUtilities.createQuote(opp);
			Pricebook2 pb = TestUtilities.standardPb;
			PricebookEntry pe = TestUtilities.createPricebookEntry(pb, prod);
	   		QuoteLineItem qli = TestUtilities.createQuotelineItem(quote, prod, pe);
			List<QuoteLineItem> qliList =  new List<QuoteLineItem>();
	    
			Test.setCurrentPage(Page.SoftDealClone);
			ApexPages.currentPage().getParameters().put('quoteId', quote.Id);
	
	        Deal_Stoplight_Standard__c objStandard = new Deal_Stoplight_Standard__c();
	        insert objStandard;
	        
	        Deal_Stoplight_Deviation__c objDeviation = new Deal_Stoplight_Deviation__c();
	        objDeviation.Deal__c = quote.id;
	        insert objDeviation;
        
	       	Task taskClone = new Task();
		    insert taskClone;
		       
	        List<Task> taskListClone = new List<Task>();
	        taskListClone.add(taskClone);
	        upsert taskListClone;
		       
		    Event eventClone = new Event();
		    eventClone.DurationInMinutes = 5;
		    eventClone.ActivityDateTime = Date.today();
		    insert eventClone;
		       
		    List<Event> eventListClone = new List<Event>();
		    eventListClone.add(eventClone);
		    upsert eventListClone;
		       
		    Attachment attachmentClone = new Attachment();
		    attachmentClone.parentId = quote.id;
		    attachmentClone.Name = 'TEST';
		    attachmentClone.Body = Blob.valueOf('Example of IV123');
		    insert attachmentClone;
		       
		    List<Attachment> attachmentListClone = new List<Attachment>();
		    attachmentListClone.add(attachmentClone);
		    upsert attachmentListClone;
		       
		    QuoteLineItem qi = new QuoteLineItem();
		    qi.quoteId = quote.Id;
		    qi.pricebookEntryId = pe.Id;
		    qi.quantity = 3;
		    qi.unitPrice = 10;
		    qi.product2Id = prod.id;
		    insert qi;
		              
	      	List<QuoteLineItem> qiList = new List<QuoteLineItem>();
	        qiList.add(qi);
	        upsert qiList;
	       
	        List<dliWrapper> dilLineItems = new List<dliWrapper>();
	        dliWrapper dil = new dliWrapper();
	        dil.dliSelected = true;
	        dilLineItems.add(dil);
	      
	        ApexPages.StandardController sc = new ApexPages.StandardController(quote);
	        DealDeepCloneController ddC = new DealDeepCloneController(sc);
	        ddC.quoteToClone = quote;
	        ddC.taskToClone = taskListClone;
	        ddC.eventToClone = eventListClone;
	        //ddC.qlisToClone = qiList;
	        ddC.clonedQuoteTemp = quote;
	        ddC.dealLineItems = dilLineItems;
	        
	        ddC.selectedAccount = new List<Account>();
	        ddC.selectedAccount.add(acct);
	        
	        ddC.selectedOpp = new List<Opportunity>();
	        ddC.selectedOpp.add(opp);

	        ddC.runSearch();
	        ddC.fetchAccountName();
	        ddC.executeDeepCLone();
	        ddC.executeSoftCLone();
	        ddC.cancelOperation();
	        dliWrapper dli = new dliWrapper();
	        ddC.cancel();
	        ddC.addToProductSelection();
	        ddC.getYearOptions();
	        ddC.editMode();
	        ddC.checkDealTypes();
	        ddC.validateProductDifferences();
	        ddC.getCloneOptions();
	        ddC.selectCloneOption();
	        ddC.cloneQuoteToNewAccount();
	       
	        ddC.cloneOption = 'TEST';
	        ddC.oppAssociation = true;
	        ddC.selectCloneOption();
	        
	        system.assertEquals(ddC.accountIdTemp.AccountId, ddC.selectedAccountLookUp.AccountId);
	        
	        Account acctNew = TestUtilities.createAccount();
	        ddC.accountIdTemp.AccountId = acctNew.Id;
	        
	        Account acctNewComp = TestUtilities.createAccount();
	        ddC.selectedAccountLookUp.AccountId = acctNewComp.Id;
	        
	        ddC.cloneQuoteToNewAccount();
	        
	        ddC.selectedProducts = new List<dliWrapper>();
	        ddC.addToProductSelection();
       	Test.stopTest();
     }
       
     
}