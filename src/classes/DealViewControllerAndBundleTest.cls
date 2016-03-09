@isTest (SeeAllData = false)
public with sharing class DealViewControllerAndBundleTest {
	 
	Public Static Account testAcct = new Account();
	Public Static Account parentAcct = new Account();
	Public Static Opportunity testOpp = new Opportunity();
	Public Static Quote testQot = new Quote();
	Public Static Quote childQot = new Quote();
	Public Static PricebookEntry pEntry = new PricebookEntry();
	Public Static PricebookEntry pEntry2 = new PricebookEntry();
	Public Static Product2 prod = new Product2();
	Public Static Product2 prod2 = new Product2();
	Public Static QuoteLineItem qliCWV1 = new QuoteLineItem();
	Public Static QuoteLineItem qliPOR1 = new QuoteLineItem();
	Public Static PMD_Product__c pmdProd = new PMD_Product__c();
	Public Static DealViewController  dvC = new DealViewController();
	Public Static Id oppSgRt = null;
	Public Static Id oppBungRt = null;
	Public Static Id qSgRt = null;
	Public Static Id qBunRt = null;

	@isTest static void test_newBundle(){
	 	User levUser = createLevUser();
	 	
	 	System.runAs(levUser){
			Id standardPbId = Test.getStandardPriceBookId();
			createRecords(); //Create all necesary records
			setupController(); //Setup the page and instantiate the controller
			/* Test Controller Internal Functions */
			dvC.getProducts();
			dvC.saveChanges();
			dvC.refreshSummary();
			dvC.openRelativeDeal();
			dvC.approvalBundleDealsProcess();

			//Testing Delete Selected Columns
			//dvC.deleteBundleSelectedColumns();
		}
	}

	@isTest static void test_SingleDeal(){
	 	User levUser = createLevUser();
	 	
	 	System.runAs(levUser){
			Id standardPbId = Test.getStandardPriceBookId();
			createRecordsSingleDeal(); //Create all necesary records
			setupController(); //Setup the page and instantiate the controller
			//Test Controller Internal Functions

			dvC.getProducts();

			//Test Single Deal Approval Process
			dvC.approvalProcess();
			dvC.acceptWorkItem();
			//dvC.rejectWorkItem();
			dvC.recallProcess();

			//Test NotePopup
			Note myNote = createNote('Test Note');
			Apexpages.currentPage().getParameters().put('noteId', myNote.Id);
			Apexpages.currentPage().getParameters().put('Editable', 'true');
			dvC.notesPopUp();
			dvC.closenotesPopUp();
			dvC.saveNote();
			dvC.editExecutiveSummaryNote();
			dvC.saveExecutiveSummaryNote();

			//Test Attachments
			dvC.attachmentsPopUp();
			dvC.upload();
			dvC.closeAttachmentsPopUp();

			//Test DoSearch with a Keyword Selected
			dvC.selectedKeywords = 'Agate';
			dvC.searchButtonClick();

			//Testing Navigation
			dvc.goToNextPage();
			dvc.goToPreviousPage();

			//Testing Delete Selected Columns
			dvc.getCustomRender();
			dvC.selectedIdString = String.valueOf(testQot.Id);
			dvc.getSelected();
			//dvc.deleteSelectedColumns();

		}
	}

	@isTest static void test_singleAddProductsToQueue(){
	 	User levUser = createLevUser();
	 	
	 	System.runAs(levUser){
			Id standardPbId = Test.getStandardPriceBookId();
			createRecordsSingleDeal(); //Create all necesary records
			setupController(); //Setup the page and instantiate the controller
			
			dvC.fiscalYear = '2016';
			//Test Adding Products to the Queue
			dvC.addProductsToQueue(2015, 'Q1'); //Test with no String
			dvC.selectedIdString = String.valueOf(prod.Id);
			dvC.addProductsToQueue(2015, 'Q1'); //Test With String

			//Test CheckCustomQY
			dvC.customYear = 2016;
			dvC.customQuarter = 'Q1';
			dvC.checkCustomQY();
			dvC.calculateFiscalYear();
			dvC.checkQuarterQ1();
			dvC.checkQuarterQ2();
			dvC.checkQuarterQ3();
			dvC.checkQuarterQ4();
			dvC.removeDuplicateProduct();
			dvC.removeProductsFromQueue();

		}
	}

	@isTest static void test_visibleElements(){
	 	User levUser = createLevUser();
	 	
	 	System.runAs(levUser){
			Id standardPbId = Test.getStandardPriceBookId();
			createRecordsSingleDeal(); //Create all necesary records
			setupController(); //Setup the page and instantiate the controller
			
			//Test visible Elements
			dvC.getAllProductOptions();
			dvC.setDisplayPanelVisibility();
			dvC.cancelQueue();
			dvC.loadTable();
			dvC.stopEditMode();
			dvC.visibleOrNot1 = true;
			dvC.visibleOrNot2 = true;
			dvC.visibleOrNot3 = true;
			dvC.visibleOrNot4 = true;
			dvC.visibleOrNot5 = true;
			dvC.visibleOrNot6 = true;
			dvC.visibleOrNot7 = true;
			dvC.visibleOrNot8 = true;
			dvC.visibleOrNot9 = true;
			dvC.visibleOrNot10 = true;
			dvC.visibleOrNot11 = true;
			dvC.visibleOrNot12 = true;
			dvC.visibleOrNot13 = true;
			dvC.visibleOrNotSDF = true;
			dvc.setCheckBoxVisibleOrNot();
            dvc.setCheckBoxVisibleOrNot2();
            dvc.setCheckBoxVisibleOrNot3();
            dvc.setCheckBoxVisibleOrNot4();
            dvc.setCheckBoxVisibleOrNot5();
            dvc.setCheckBoxVisibleOrNot6();
            dvc.setCheckBoxVisibleOrNot7();
            dvc.setCheckBoxVisibleOrNot8();
            dvc.setCheckBoxVisibleOrNot9();
            dvc.setCheckBoxVisibleOrNot10();
            dvc.setCheckBoxVisibleOrNot11();
            dvc.setCheckBoxVisibleOrNot12();
            dvc.setCheckBoxVisibleOrNot13();
            dvc.setCheckBoxVisibleOrNotSDF();
            dvC.visibleOrNot1 = false;
			dvC.visibleOrNot2 = false;
			dvC.visibleOrNot3 = false;
			dvC.visibleOrNot4 = false;
			dvC.visibleOrNot5 = false;
			dvC.visibleOrNot6 = false;
			dvC.visibleOrNot7 = false;
			dvC.visibleOrNot8 = false;
			dvC.visibleOrNot9 = false;
			dvC.visibleOrNot10 = false;
			dvC.visibleOrNot11 = false;
			dvC.visibleOrNot12 = false;
			dvC.visibleOrNot13 = false;
			dvC.visibleOrNotSDF = false;
			dvc.setCheckBoxVisibleOrNot();
            dvc.setCheckBoxVisibleOrNot2();
            dvc.setCheckBoxVisibleOrNot3();
            dvc.setCheckBoxVisibleOrNot4();
            dvc.setCheckBoxVisibleOrNot5();
            dvc.setCheckBoxVisibleOrNot6();
            dvc.setCheckBoxVisibleOrNot7();
            dvc.setCheckBoxVisibleOrNot8();
            dvc.setCheckBoxVisibleOrNot9();
            dvc.setCheckBoxVisibleOrNot10();
            dvc.setCheckBoxVisibleOrNot11();
            dvc.setCheckBoxVisibleOrNot12();
            dvc.setCheckBoxVisibleOrNot13();
            dvc.setCheckBoxVisibleOrNotSDF();
			dvc.checkNotesRendering();
            dvc.exportToExcel();

		}
	}

	@isTest static void test_createLineItemsFromQueue(){
	 	User levUser = createLevUser();
	 	
	 	System.runAs(levUser){
			Id standardPbId = Test.getStandardPriceBookId();
			createRecordsSingleDeal(); //Create all necesary records
			childQot = createChildQuote(testOpp, testQot);
			setupController(); //Setup the page and instantiate the controller


			//Test createLineItemsFromQueue
			dvC.selectedIdString = String.valueOf(prod.Id);
			dvC.addProductsToQueue(2015, 'Q1'); //Test With String
			dvC.createLineItemsFromQueue();
		}
	}

	@isTest static void test_createBundleLineItemsFromQueue(){
	 	User levUser = createLevUser();
	 	
	 	System.runAs(levUser){
			Id standardPbId = Test.getStandardPriceBookId();
			createRecords(); //Create all necesary records
			childQot = createChildQuote(testOpp, testQot);
			setupController(); //Setup the page and instantiate the controller


			//Test createLineItemsFromQueue
			dvC.selectedIdString = String.valueOf(prod.Id);

			dvC.addProductsToQueue(2016, 'Q1'); //Test With String
			dvC.createBundleLineItemsFromQueue();
		}
	}

	

	/********************************************** UTILITY ************************************************/
	public static void setupController(){
	 	PageReference dealViewPage = Page.DealView;
		system.Test.setCurrentPage(dealViewPage);
		ApexPages.currentPage().getParameters().put('qId', testQot.Id);
		//ApexPages.currentPage().getParameters().put('vfpViewAllMode', 'true'); //for some reason this resets the available options and the get products function doesnt fire correctly.
		dvC = new DealViewController();
	}

	public static void setupRecordType(){
		oppSgRt = [select id from RecordType where sobjecttype = 'Opportunity' and DeveloperName = 'Deal' limit 1].Id;
		oppBungRt = [select id from RecordType where sobjecttype = 'Opportunity' and DeveloperName = 'BundleDeal' limit 1].Id;
		qSgRt = [select id from RecordType where sobjecttype = 'Quote' and DeveloperName = 'Deal' limit 1].Id;
		qBunRt = [select id from RecordType where sobjecttype = 'Quote' and DeveloperName = 'BundleDeal' limit 1].Id;
	}

	public static void createRecords(){
		setupRecordType();
		testAcct = createAccount();
        testOpp = createOpp(testAcct);
        parentAcct = createAccount();
        pmdProd = createPmdProduct(); //Need this PMD Product to map the Portfolio Segment Field
        prod = createProduct('Agate');
        prod2 = createProduct('Agate');
        pEntry = createPricebooKEntry(prod);
        pEntry2 = createPricebooKEntry(prod2);
        testQot = createBundleQuote(testOpp);
        //QLI 1
        qliCWV1 = createQuoteLineItem(testQot, prod, pEntry, 'Proposal');
        qliPOR1 = createQuoteLineItem(testQot, prod, pEntry, 'Plan'); 
        //QLI 2
        qliCWV1 = createQuoteLineItem(testQot, prod2, pEntry, 'Proposal');
        qliPOR1 = createQuoteLineItem(testQot, prod2, pEntry, 'Plan');
	}

	public static void createRecordsDifProds(){
		setupRecordType();
		testAcct = createAccount();
        testOpp = createOpp(testAcct);
        parentAcct = createAccount();
        pmdProd = createPmdProduct(); //Need this PMD Product to map the Portfolio Segment Field
        prod = createProduct('Agate');
        prod2 = createProduct('Test');
        pEntry = createPricebooKEntry(prod);
        pEntry2 = createPricebooKEntry(prod2);
        testQot = createBundleQuote(testOpp);
        //QLI 1
        qliCWV1 = createQuoteLineItem(testQot, prod, pEntry, 'Proposal');
        qliPOR1 = createQuoteLineItem(testQot, prod, pEntry, 'Plan'); 
        //QLI 2
        qliCWV1 = createQuoteLineItem(testQot, prod2, pEntry, 'Proposal');
        qliPOR1 = createQuoteLineItem(testQot, prod2, pEntry, 'Plan');
	}

	public static void createRecordsSingleDeal(){
		setupRecordType();
		testAcct = createAccount();
        testOpp = createOpp(testAcct);
        parentAcct = createAccount();
        pmdProd = createPmdProduct(); //Need this PMD Product to map the Portfolio Segment Field
        prod = createProduct('Agate');
        prod2 = createProduct('Test');
        pEntry = createPricebooKEntry(prod);
        pEntry2 = createPricebooKEntry(prod2);
        testQot = createSingleQuote(testOpp);
        //QLI 1
        qliCWV1 = createQuoteLineItem(testQot, prod, pEntry, 'Proposal');
        qliPOR1 = createQuoteLineItem(testQot, prod, pEntry, 'Plan'); 
        //QLI 2
        qliCWV1 = createQuoteLineItem(testQot, prod2, pEntry, 'Proposal');
        qliPOR1 = createQuoteLineItem(testQot, prod2, pEntry, 'Plan');
	}

	public static Account createAccount(){
        Account act = new Account();
        act.Name = 'Test Lev Account ' + Math.random();
        act.Type = 'Prospect';
        act.Account_Subtype__c = 'Retailer';
        act.Country__c = 'US';
        act.Sub_Region__c = 'North America';
        act.Region__c = 'North America';
        act.Active__c = true;
        act.Allow_Opportunities__c = true;
        insert act;
        return act;
    }

    public static Opportunity createOpp(Account act, Boolean parentOpp){
            Opportunity oppo = new Opportunity();
            oppo.Name = 'Test Lev Opp ' + Math.random();
            oppo.stageName = 'New';
            oppo.closeDate = System.today();
            oppo.Account = act;
            oppo.Year__c = '2014';
            oppo.Quarter__c = 'Q3';
            oppo.Pricebook2Id = Test.getStandardPriceBookId();
            oppo.Pricebook2Id = Test.getStandardPriceBookId();
            oppo.CurrencyIsoCode = 'USD';
            insert oppo;
            return oppo;
    }

    public static Opportunity createOpp(Account act){
            Opportunity oppo = new Opportunity();
            oppo.Name = 'Test Lev Opp';
            oppo.stageName = 'New';
            oppo.closeDate = System.today();
            oppo.Account = act;
            oppo.Year__c = '2014';
            oppo.Quarter__c = 'Q3';
            oppo.Pricebook2Id = Test.getStandardPriceBookId();
            insert oppo;
            return oppo;
    }
    
    public static Product2 createProduct(string name){
        Product2 p = new Product2();
        p.Name = name;
        p.PMD_Product__c = pmdProd.Id;
        p.IsActive = true;
        insert p;
        return p;
    }

    public static Note createNote(string name){
        Note nt = new Note();
        nt.Title = name;
        nt.Body = name;
        nt.ParentId = testQot.Id;
        insert nt;
        return nt;
    }

    public static PMD_Product__c createPmdProduct(){
    	PMD_Program__c program = new PMD_Program__c(name = 'Test Program');
        insert program;

        PMD_Project__c project = new PMD_Project__c(name = 'Test Project', Program_ID__c = program.id);
        insert project;


        PMD_Product__c tempPmdProd = new PMD_Product__c(name = 'Test PMD Product ' + Math.random(), Project_ID__c = project.id, Product_Segment__c = 'Premium');
        insert tempPmdProd;        
        return tempPmdProd;
    } 

    public static QuoteLineItem createQuoteLineItem(Quote q, Product2 p, PricebookEntry pe, String dealType){
        QuoteLineItem qotLi = new QuoteLineItem();
        qotLi.quoteId = q.Id;
        qotLi.PricebooKEntryId = pe.Id;
        qotLi.Quantity = 5;
        qotLi.UnitPrice = 50;
        qotLi.Product2Id = p.Id;
        qotLi.Quarter__c = 'Q4';
        qotLi.Year__C = '2014';
        qotLi.Units__c = 1111;
        qotLi.MinimumCommitQuantity__c = 1111;
        qotLi.InvoicePrice__c = 10;
        qotLi.SDF__c = 10;
        qotLi.iMDF__c = 10;
        qotLi.COOP__c = 10;
        qotLi.MDF__c = 10;
        qotLi.SVM__c = 10;
        qotLi.IPP__c = 10;
        qotLi.National_Retail__c = 10;
        qotLi.CSAT__c = 10;
        qotLi.QP__c = 10;
        qotLi.TC__c = 10;
        qotLi.ILW__c = 10;
        qotLi.TDF__c = 10;
        qotLi.Fees__c = 10;
        qotLi.Negotiation_Buffer__c = 10;
        qotLi.MCPU__c = 10;
        qotLi.AP__c = 10;
        qotLi.Deal_Type__c = dealType;
        qotLi.Approval_Status__c  = 'Pending';

        insert qotLi;
        return qotLi;
    }

    public static Quote createSingleQuote(Opportunity opp){
        Quote qot = new Quote();
        qot.Name = 'Test Lev Quote ' + Math.random();
        qot.OpportunityID = opp.Id;
        qot.Deal_Review_Date__c = System.today();
        qot.Pricebook2Id = Test.getStandardPriceBookId();
        qot.Portfolio_Segment__c = 'Premium;Value;N/A';
        qot.RecordTypeId = qSgRt;
        insert qot;
        return qot;
    }

    public static Quote createBundleQuote(Opportunity opp){
        Quote qot = new Quote();
        qot.Name = 'Test Lev Quote ' + Math.random();
        qot.OpportunityID = opp.Id;
        qot.Deal_Review_Date__c = System.today();
        qot.Pricebook2Id = Test.getStandardPriceBookId();
        qot.Portfolio_Segment__c = 'Premium;Value;N/A';
        qot.RecordTypeId = qBunRt;
        insert qot;
        return qot;
    }
 
 	public static Quote createChildQuote(Opportunity opp, Quote parentQuote){
        Quote qot = new Quote();
        qot.Name = 'Test Lev Child Quote ' + Math.random();
        qot.OpportunityID = opp.Id;
        qot.ParentQuote__c = parentQuote.Id;
        qot.Deal_Review_Date__c = System.today();
        qot.Pricebook2Id = Test.getStandardPriceBookId();
        qot.Portfolio_Segment__c = 'Premium;Value;N/A';
         qot.RecordTypeId = qBunRt;
        insert qot;
        return qot;
    }

    public static PricebookEntry createPricebookEntry(Product2 pr){
        PricebookEntry pe = new PricebookEntry();
        pe.UnitPrice = 50;
        pe.Pricebook2Id = Test.getStandardPriceBookId();
        pe.Product2Id = pr.Id;
        pe.IsActive = true;
        pe.CurrencyIsoCode  = 'USD';
        insert pe;
        return pe;
    }

    public static User createLevUser(){
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'stdlev', Email='standarduser@levementum.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@levementum.com',
      DefaultCurrencyIsoCode ='USD', CurrencyIsoCode ='USD');
      return u;
    }
}