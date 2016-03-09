@isTest (SeeAllData=true)
private class DealViewControllerTEST {

    static Pricebook2 standardPb = [select id, name, isActive from Pricebook2 where isStandard=true];
    
    @isTest static void test_dealview() {
        User levUser = createLevUser();
        
        System.runAs(levUser){
            Account testAcct = createAccount();
            System.debug('############### testAcct:' + testAcct);
            
            Opportunity testOpp = createOpp(testAcct);
           
            System.debug('############### testOpp:' + testOpp);
            
            Quote testQot = createDealQuote(testOpp);
            System.debug('############### testQot:' + testQot);
            
            Product2 p = createProduct('Agate');
            Product2 p2 = createProduct('Test');
            
            //Pricebook2 p2 = createPricebook();
            Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true and isActive = true limit 1];
            PricebookEntry pe = createPricebooKEntry(pbook, p);
            PricebookEntry pe2 = createPricebooKEntry(pbook, p2);
            
            //Add by qucw@lenovo.com   2015/8/3
            // createQuoteLineItem(testQot, p, pe);
            // createQuoteLineItem(testQot, p2, pe2);
            List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem> {
                initiateQuoteLineItem(testQot, p, pe, 'Proposal'),
                initiateQuoteLineItem(testQot, p, pe, 'Plan'),
                initiateQuoteLineItem(testQot, p, pe, 'Other'),
                initiateQuoteLineItem(testQot, p2, pe2, 'Proposal'),
                initiateQuoteLineItem(testQot, p2, pe2, 'Plan'),
                initiateQuoteLineItem(testQot, p2, pe2, 'Other')
            };
            insert quoteLineItems;
    
            ApexPages.currentPage().getParameters().put('qId', testQot.Id);
    
            DealViewController  dvc = new DealViewController();

            List<PriceBookEntry> pbes = [select 
            id, 
            product2Id, 
            product2.Name, 
            product2.ProductCode, 
            product2.Project__c, 
            product2.Program__c,
            product2.Family, 
            product2.Business_Unit__c, 
            UnitPrice 
            FROM PriceBookEntry Limit 5];

            System.debug('############### pbes:' + pbes);

            //dvc.getProducts();
            //TEST CONTROLLER FUNCTIONS
            dvc.getAllProductOptions();
            dvc.goToNextPage();
            dvc.checkQuarterQ1();
            dvc.createLineItemsFromQueue();
            dvc.getAvailableProductOptions();
            dvc.getSelected();
            dvc.loadTable();
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
            dvc.saveChanges();
            dvc.exportToExcel();
            dvc.approvalProcess();
            dvc.acceptWorkItem();
            dvc.rejectWorkItem();
            dvc.notesPopUp();
            dvc.saveNote();
            dvc.refreshSummary();
            dvc.editExecutiveSummaryNote();
            dvc.SaveExecutiveSummaryNote();
            
            dvc.stopEditMode();
            dvc.setQuoteStatus(testQot.status);
            dvc.calculateFiscalYear();
            dvc.getQuarter();
            dvc.setDisplayPanelVisibility();
            dvc.setDisplayTable();
            dvc.cancelQueue();
            dvc.stopEditMode();
            dvc.removeDuplicateProduct();
            dvc.checkQuarterQ1();
            dvc.checkQuarterQ2();
            dvc.checkQuarterQ3();
            dvc.checkQuarterQ4();
            dvc.addProductsToQueue(2014, 'Q1');
            dvc.removeProductsFromQueue();
            dvc.createLineItemsFromQueue();
            //dvc.sortQuoteLineItems(null);
            dvc.removeQuarterFromName('Agate - Q1');
            dvc.getProducts();
            dvc.getCustomRender();
            dvc.getSelected();
            dvc.goToPreviousPage();
            dvc.checkPageStatus();
            dvc.searchButtonClick();
            dvc.doSearch();
            dvc.setCheckBoxVisibleOrNotSDF();
            dvc.attachmentsPopUp();
            dvc.closeAttachmentsPopUp();
            dvc.upload();
            dvc.approvalProcess();
            dvc.acceptWorkItem();
            dvc.rejectWorkItem();
            dvc.recallProcess();
            dvc.notesPopUp();
            dvc.closenotesPopUp();
            dvc.saveNote();
            dvc.note.parentId = null;
            dvc.saveNote();
            dvc.getNotes();
            dvc.checkNotesRendering();
            dvc.refreshSummary();
            dvc.getAttachments();
            dvc.editExecutiveSummaryNote();
            //dvc.SaveExecutiveSummaryNote();
            DealViewController.ExecutiveNoteWrapper enw = new DealViewController.ExecutiveNoteWrapper(null, null);
            DealViewController.ProductQueueWrapper pqw = new DealViewController.ProductQueueWrapper(null, 2014, 'Q1');
            dvc.setCheckBoxVisibleOrNotSDF();
            
            dvc.visibleOrNotSDF = true;
            dvc.VisibleOrNot1 = true;
            dvc.VisibleOrNot2 = true;
            dvc.VisibleOrNot3 = true;
            dvc.VisibleOrNot4 = true;
            dvc.VisibleOrNot5 = true;
            dvc.VisibleOrNot6 = true;
            dvc.VisibleOrNot7 = true;
            dvc.VisibleOrNot8 = true;
            dvc.VisibleOrNot9 = true;
            dvc.VisibleOrNot10 = true;
            dvc.VisibleOrNot11 = true;
            dvc.VisibleOrNot12 = true;
            dvc.VisibleOrNot13 = true;
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
            
            dvc.VisibleOrNotSDF = false;
            dvc.VisibleOrNot1 = false;
            dvc.VisibleOrNot2 = false;
            dvc.VisibleOrNot3 = false;
            dvc.VisibleOrNot4 = false;
            dvc.VisibleOrNot5 = false;
            dvc.VisibleOrNot6 = false;
            dvc.VisibleOrNot7 = false;
            dvc.VisibleOrNot8 = false;
            dvc.VisibleOrNot9 = false;
            dvc.VisibleOrNot10 = false;
            dvc.VisibleOrNot11 = false;
            dvc.VisibleOrNot12 = false;
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


            // ctalladen@levementum.com 17feb Description: .
            dvc.createBundleLineItemsFromQueue();
            dvc.approvalBundleDealsProcess();
            dvc.bundleDeal =true;
            dvc.parentDeal = true;
            dvc.workItems = [SELECT Id,ActorId,ProcessInstance.TargetObjectId,ProcessInstance.Status 
                            FROM ProcessInstanceWorkitem LIMIT 1];

            dvc.acceptWorkItem();
            dvc.rejectWorkItem();
            dvc.recallProcess();

            DealViewController.ProductQueueWrapper pqw2 = new DealViewController.ProductQueueWrapper(pe, 1990, 'Q1');
            dvc.productsQueue.add(pqw);
            dvc.productsQueue.add(pqw2);
            dvc.isBundleParent = true;
            dvc.createLineItemsFromQueue();
            dvc.createBundleLineItemsFromQueue();
            dvc.addProductsToQueue(1990, 'Q1');
            dvc.addProductsToQueue(1990, 'Q2');
            dvc.addProductsToQueue(1990, 'Q3');
            dvc.addProductsToQueue(1990, 'Q4');
            dvc.getProducts();
            dvc.checkCustomQY();

            // ctalladen@levementum.com 19feb .
            dvc.quarterVal = 'Q1';
            dvc.calculateFiscalYear();
            dvc.quarterVal = 'Q2';
            dvc.calculateFiscalYear();
            dvc.quarterVal = 'Q3';
            dvc.calculateFiscalYear();
            dvc.quarterVal = 'Q4';
            dvc.calculateFiscalYear();

            //Add by qucw@lenovo.com   2015/8/3
            // QuoteLineItem qli3 = createQuoteLineItem(testQot, p2,pe);
            // QuoteLineItem qli2 = createQuoteLineItem(testQot, p2,pe);
            // QuoteLineItem qli4 = createQuoteLineItem(testQot, p2,pe);

            QuoteLineItem qli3 = initiateQuoteLineItem(testQot, p2,pe,'Proposal');
            QuoteLineItem qli2 = initiateQuoteLineItem(testQot, p2,pe,'Plan');
            QuoteLineItem qli4 = initiateQuoteLineItem(testQot, p2,pe,'Other');
            insert new List<QuoteLineItem>{qli2, qli3, qli4};

            lineItemCol lic = new lineItemCol();
            List<QuoteLineItem> qliL = new List<QuoteLineItem>();
            qliL.add(qli2);
            qliL.add(qli3);
            qliL.add(qli4);
            dvc.sortQuoteLineItems(qliL);
            dvc.selectedKeywords = 'TEST';

            dvc.lineItemColumns = new List<lineItemCol>();
            lineItemCol col = new lineItemCol();
            col.name = 'TEST';
            col.Year = '1990';
            dvc.lineItemColumns.add(col);

            BundleDealHandler.aggregateFields( qli2,  qli3);
            BundleDealHandler.resetFields(  qli4);

            Quote qot2 = createDealQuote(testOpp);
            testQot.Name = 'tested update';
            testQot.ParentQuote__c = qot2.Id;
            testQot.HasStoplight__c = true;
            testQot.HasSummary__c = true;
            //upsert testQot;

            dvc.availableOptions = new List<SelectOption>();
            dvc.selectedOptions = new List<SelectOption>();
            set<String> nameSet = new set<String>();
            for(QuoteLineItem qli : [select id, product2.Id, product2.Name,Total_CM__c,Units__c,Total_Fees__c,Total_Contribution_Margin__c,Total_Motoagents__c,Total_A_P__c,Total_GM__c,Total_Gross_Margin__c,Total_Negotiation_Buffer__c,Total_TDF__c,Total_ILW__c,Total_QP__c,Total_TC__c,Total_CSAT__c,Total_SVM__c,Total_National_Retail__c,Total_IPP__c,Total_NSAD__c,Total_Aggregate_Discounts__c,Total_COOP__c,Total_iMDF__c, Name__c,InvoicePrice__c,Total_MDF__c, MCPU__c, MinimumCommitQuantity__c, Quantity__c, Quarter__c, TotalAPAmount__c, Year__c from QuoteLineItem limit 2]){
                nameSet.add(qli.Name__c);
            }
            for(String s : nameSet){
                dvc.availableOptions.add(new selectOption(s,s));
            }

            dvc.productMap  = new Map<String,SummaryCol>();

            SummaryCol sc2 = new SummaryCol();
            sc2.cwvLineItem = new totalColItem();
            sc2.porLineItem = new totalColItem();
            //add by qucw@lenovo  2015/8/3
            sc2.othLineItem = new totalColItem();
                  
            
            sc2.cwvLineItem.units += 1;
            sc2.cwvLineItem.minCommit += 1;
            sc2.cwvLineItem.nsbd += 1;
            sc2.cwvLineItem.discount += 1;
            sc2.cwvLineItem.nsad += 1;
            sc2.cwvLineItem.grossMargin += 1;
            sc2.cwvLineItem.aAndP += 1;
            sc2.cwvLineItem.motoagents += 1;
            sc2.cwvLineItem.contributionMargin += 1;
                            
            sc2.porLineItem.units += 1;
            sc2.porLineItem.minCommit += 1;
            sc2.porLineItem.nsbd += 1;
            sc2.porLineItem.discount += 1;
            sc2.porLineItem.nsad += 1;
            sc2.porLineItem.grossMargin += 1;
            sc2.porLineItem.aAndP += 1;
            sc2.porLineItem.motoagents += 1;
            sc2.porLineItem.contributionMargin += 1;
            //add by qucw@lenovo.com   2015/8/3
            sc2.othLineItem.units += 1;
            sc2.othLineItem.minCommit += 1;
            sc2.othLineItem.nsbd += 1;
            sc2.othLineItem.discount += 1;
            sc2.othLineItem.nsad += 1;
            sc2.othLineItem.grossMargin += 1;
            sc2.othLineItem.aAndP += 1;
            sc2.othLineItem.motoagents += 1;
            sc2.othLineItem.contributionMargin += 1;

            SummaryCol sc5 = new SummaryCol();
            sc5.cwvLineItem = new totalColItem();
            sc5.porLineItem = new totalColItem();
            //add by qucw@lenovo.com   2015/8/3
            sc5.othLineItem = new totalColItem();
            
            sc5.cwvLineItem.units += 1;
            sc5.cwvLineItem.minCommit += 1;
            sc5.cwvLineItem.nsbd += 1;
            sc5.cwvLineItem.discount += 1;
            sc5.cwvLineItem.nsad += 1;
            sc5.cwvLineItem.grossMargin += 1;
            sc5.cwvLineItem.aAndP += 1;
            sc5.cwvLineItem.motoagents += 1;
            sc5.cwvLineItem.contributionMargin += 1; 
            //add by qucw@lenovo.com   2015/8/3 
            sc5.porLineItem.units += 1;
            sc5.porLineItem.minCommit += 1;
            sc5.porLineItem.nsbd += 1;
            sc5.porLineItem.discount += 1;
            sc5.porLineItem.nsad += 1;
            sc5.porLineItem.grossMargin += 1;
            sc5.porLineItem.aAndP += 1;
            sc5.porLineItem.motoagents += 1;
            sc5.porLineItem.contributionMargin += 1;
            //add by qucw@lenovo.com   2015/8/3 
            sc5.othLineItem.units += 1;
            sc5.othLineItem.minCommit += 1;
            sc5.othLineItem.nsbd += 1;
            sc5.othLineItem.discount += 1;
            sc5.othLineItem.nsad += 1;
            sc5.othLineItem.grossMargin += 1;
            sc5.othLineItem.aAndP += 1;
            sc5.othLineItem.motoagents += 1;
            sc5.othLineItem.contributionMargin += 1;
            

            dvc.productMap.put('Agate', sc2 );
            dvc.getProducts();

            //dvc = new DealViewController();
            //dvc.productMap = new Map<String,SummaryCol>();
            // dvc.productMap.put('', sc5 );
            // dvc.getProducts();
            dvc.saveChanges();

            //dvc.deleteSelectedColumns();
            //dvc.deleteBundleSelectedColumns();

            List<SummaryCol> sumList = new List<SummaryCol>();
            SummaryCol sc1 = new SummaryCol();
            SummaryCol sc3 = new SummaryCol();
            sumList.add(sc1);
            sumList.add(sc3);
            sumList.sort();

            List<totalCol> tcList = new List<totalCol>();
            totalCol tc1 = new totalCol();
            totalCol tc2 = new totalCol();
            tcList.add(tc1);
            tcList.add(tc2);
            tcList.sort();

            totalColItem tci = new totalColItem();

            dvc.selectedBundleDeal = 'TEST';
            dvc.openRelativeDeal();
            createOpp2(testAcct, 'Q1');
            createOpp2(testAcct, 'Q2');
            createOpp2(testAcct, 'Q4');
        }
    }

     @isTest static void test_dealviewJE() {
        User levUser = createLevUser();
        
        System.runAs(levUser){
            Account testAcct = createAccount();
            System.debug('############### testAcct:' + testAcct);
            
            Opportunity testOpp = createOpp(testAcct);
            System.debug('############### testOpp:' + testOpp);
            
            Quote testQot = createDealQuote(testOpp);
            System.debug('############### testQot:' + testQot);
            
            Product2 p = createProduct('Agate');
            Product2 p2 = createProduct('Test');
            
            //Pricebook2 p2 = createPricebook();
            Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true and isActive = true limit 1];
            PricebookEntry pe = createPricebooKEntry(pbook, p);
            PricebookEntry pe2 = createPricebooKEntry(pbook, p2);

            //Add by qucw@lenovo.com   2015/8/3
            // createQuoteLineItem(testQot, p, pe);
            // createQuoteLineItem(testQot, p2, pe2);
            List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem> {
                initiateQuoteLineItem(testQot, p, pe, 'Proposal'),
                initiateQuoteLineItem(testQot, p, pe, 'Plan'),
                initiateQuoteLineItem(testQot, p, pe, 'Other'),
                initiateQuoteLineItem(testQot, p2, pe2, 'Proposal'),
                initiateQuoteLineItem(testQot, p2, pe2, 'Plan'),
                initiateQuoteLineItem(testQot, p2, pe2, 'Other')
            };
            insert quoteLineItems;
    
            ApexPages.currentPage().getParameters().put('qId', testQot.Id);
            ApexPages.currentPage().getParameters().put('vfpEditMode', 'true');
            ApexPages.currentPage().getParameters().put('vfpViewAllMode', 'true');
    
            DealViewController  dvc = new DealViewController();

            List<PriceBookEntry> pbes = [select 
            id, 
            product2Id, 
            product2.Name, 
            product2.ProductCode, 
            product2.Project__c, 
            product2.Program__c,
            product2.Family, 
            product2.Business_Unit__c, 
            UnitPrice 
            FROM PriceBookEntry Limit 5];

            System.debug('############### pbes:' + pbes);

            //dvc.getProducts();
            //TEST CONTROLLER FUNCTIONS
            dvc.getAllProductOptions();
            dvc.goToNextPage();
            dvc.checkQuarterQ1();
            dvc.createLineItemsFromQueue();
            dvc.getAvailableProductOptions();
            dvc.getSelected();
            dvc.loadTable();
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
            dvc.saveChanges();
            dvc.exportToExcel();
            dvc.approvalProcess();
            dvc.acceptWorkItem();
            dvc.rejectWorkItem();
            dvc.notesPopUp();
            dvc.saveNote();
            dvc.refreshSummary();
            dvc.editExecutiveSummaryNote();
            //dvc.SaveExecutiveSummaryNote();
            
            dvc.stopEditMode();
            dvc.setQuoteStatus(testQot.status);
            dvc.calculateFiscalYear();
            dvc.getQuarter();
            dvc.setDisplayPanelVisibility();
            dvc.setDisplayTable();
            dvc.cancelQueue();
            dvc.stopEditMode();
            dvc.removeDuplicateProduct();
            dvc.selectedIdString = p.Id + ',' + p2.Id;
            dvc.checkQuarterQ1();
            dvc.checkQuarterQ2();
            dvc.checkQuarterQ3();
            dvc.checkQuarterQ4();
            dvc.addProductsToQueue(2014, 'Q1');
            dvc.removeProductsFromQueue();
            dvc.createLineItemsFromQueue();
            //dvc.sortQuoteLineItems(null);
            dvc.removeQuarterFromName('Agate - Q1');
            dvc.getProducts();
            dvc.getCustomRender();
            dvc.getSelected();
            dvc.goToPreviousPage();
            dvc.checkPageStatus();
            dvc.searchButtonClick();
            dvc.selectedKeywords = 'Agate';
            Test.setFixedSearchResults(new List<String>{p.Id, p2.Id});
            dvc.doSearch();
            dvc.setCheckBoxVisibleOrNotSDF();
            dvc.attachmentsPopUp();
            dvc.closeAttachmentsPopUp();
            dvc.upload();
            dvc.approvalProcess();
            dvc.acceptWorkItem();
            dvc.rejectWorkItem();
            dvc.recallProcess();
            dvc.notesPopUp();
            dvc.closenotesPopUp();
            dvc.saveNote();
            dvc.note.parentId = null;
            dvc.saveNote();
            dvc.getNotes();
            dvc.checkNotesRendering();
            dvc.refreshSummary();
            dvc.getAttachments();
            dvc.editExecutiveSummaryNote();
            //dvc.SaveExecutiveSummaryNote();
            DealViewController.ExecutiveNoteWrapper enw = new DealViewController.ExecutiveNoteWrapper(null, null);
            DealViewController.ProductQueueWrapper pqw = new DealViewController.ProductQueueWrapper(null, 2014, 'Q1');
            dvc.setCheckBoxVisibleOrNotSDF();
            
            dvc.visibleOrNotSDF = true;
            dvc.VisibleOrNot1 = true;
            dvc.VisibleOrNot2 = true;
            dvc.VisibleOrNot3 = true;
            dvc.VisibleOrNot4 = true;
            dvc.VisibleOrNot5 = true;
            dvc.VisibleOrNot6 = true;
            dvc.VisibleOrNot7 = true;
            dvc.VisibleOrNot8 = true;
            dvc.VisibleOrNot9 = true;
            dvc.VisibleOrNot10 = true;
            dvc.VisibleOrNot11 = true;
            dvc.VisibleOrNot12 = true;
            dvc.VisibleOrNot13 = true;
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
            
            dvc.VisibleOrNotSDF = false;
            dvc.VisibleOrNot1 = false;
            dvc.VisibleOrNot2 = false;
            dvc.VisibleOrNot3 = false;
            dvc.VisibleOrNot4 = false;
            dvc.VisibleOrNot5 = false;
            dvc.VisibleOrNot6 = false;
            dvc.VisibleOrNot7 = false;
            dvc.VisibleOrNot8 = false;
            dvc.VisibleOrNot9 = false;
            dvc.VisibleOrNot10 = false;
            dvc.VisibleOrNot11 = false;
            dvc.VisibleOrNot12 = false;
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


            // ctalladen@levementum.com 17feb Description: .
            dvc.createBundleLineItemsFromQueue();
            dvc.approvalBundleDealsProcess();
            dvc.bundleDeal =true;
            dvc.parentDeal = false;
            dvc.acceptWorkItem();
            dvc.rejectWorkItem();
            DealViewController.ProductQueueWrapper pqw2 = new DealViewController.ProductQueueWrapper(pe, 1990, 'Q1');
            dvc.productsQueue.add(pqw);
            dvc.productsQueue.add(pqw2);
            dvc.isBundleParent = true;
            dvc.createLineItemsFromQueue();
            dvc.createBundleLineItemsFromQueue();
            dvc.addProductsToQueue(1990, 'Q1');
            dvc.getProducts();
            dvc.checkCustomQY();

            // ctalladen@levementum.com 19feb .
            // QuoteLineItem qli3 = createQuoteLineItem(testQot, p2,pe);
            // QuoteLineItem qli2 = createQuoteLineItem(testQot, p2,pe);
            // QuoteLineItem qli4 = createQuoteLineItem(testQot, p2,pe);

            //Add by qucw@lenovo.com   2015/8/3
            QuoteLineItem qli3 = createQuoteLineItem(testQot, p2,pe,'Proposal');
            QuoteLineItem qli2 = createQuoteLineItem(testQot, p2,pe,'Plan');
            QuoteLineItem qli4 = createQuoteLineItem(testQot, p2,pe,'Other');

            lineItemCol lic = new lineItemCol();
            List<QuoteLineItem> qliL = new List<QuoteLineItem>();
            qliL.add(qli2);
            qliL.add(qli3);
            qliL.add(qli4);
            dvc.sortQuoteLineItems(qliL);
            dvc.selectedKeywords = 'TEST';

            dvc.lineItemColumns = new List<lineItemCol>();
            lineItemCol col = new lineItemCol();
            col.name = 'TEST';
            col.Year = '1990';
            dvc.lineItemColumns.add(col);

            BundleDealHandler.aggregateFields( qli2,  qli3);
            BundleDealHandler.resetFields(  qli4);

            Quote qot2 = createDealQuote(testOpp);
            testQot.Name = 'tested update';
            testQot.ParentQuote__c = qot2.Id;
            testQot.HasStoplight__c = true;
            testQot.HasSummary__c = true;
            //upsert testQot;

            dvc.availableOptions = new List<SelectOption>();
            dvc.selectedOptions = new List<SelectOption>();
            set<String> nameSet = new set<String>();
            for(QuoteLineItem qli : [select id, product2.Id, product2.Name,Total_CM__c,Units__c,Total_Fees__c,Total_Contribution_Margin__c,Total_Motoagents__c,Total_A_P__c,Total_GM__c,Total_Gross_Margin__c,Total_Negotiation_Buffer__c,Total_TDF__c,Total_ILW__c,Total_QP__c,Total_TC__c,Total_CSAT__c,Total_SVM__c,Total_National_Retail__c,Total_IPP__c,Total_NSAD__c,Total_Aggregate_Discounts__c,Total_COOP__c,Total_iMDF__c, Name__c,InvoicePrice__c,Total_MDF__c, MCPU__c, MinimumCommitQuantity__c, Quantity__c, Quarter__c, TotalAPAmount__c, Year__c from QuoteLineItem limit 2]){
                nameSet.add(qli.Name__c);
            }
            for(String s : nameSet){
                dvc.availableOptions.add(new selectOption(s,s));
            }

            dvc.productMap  = new Map<String,SummaryCol>();

            SummaryCol sc2 = new SummaryCol();
            sc2.cwvLineItem = new totalColItem();
            sc2.porLineItem = new totalColItem();
            //add by qucw@lenovo   2015/8/3
            sc2.othLineItem = new totalColItem();
                  
            
            sc2.cwvLineItem.units += 1;
            sc2.cwvLineItem.minCommit += 1;
            sc2.cwvLineItem.nsbd += 1;
            sc2.cwvLineItem.discount += 1;
            sc2.cwvLineItem.nsad += 1;
            sc2.cwvLineItem.grossMargin += 1;
            sc2.cwvLineItem.aAndP += 1;
            sc2.cwvLineItem.motoagents += 1;
            sc2.cwvLineItem.contributionMargin += 1;
                            
            sc2.porLineItem.units += 1;
            sc2.porLineItem.minCommit += 1;
            sc2.porLineItem.nsbd += 1;
            sc2.porLineItem.discount += 1;
            sc2.porLineItem.nsad += 1;
            sc2.porLineItem.grossMargin += 1;
            sc2.porLineItem.aAndP += 1;
            sc2.porLineItem.motoagents += 1;
            sc2.porLineItem.contributionMargin += 1;
            //add by qucw@lenovo  2015/8/3
            sc2.othLineItem.units += 1;
            sc2.othLineItem.minCommit += 1;
            sc2.othLineItem.nsbd += 1;
            sc2.othLineItem.discount += 1;
            sc2.othLineItem.nsad += 1;
            sc2.othLineItem.grossMargin += 1;
            sc2.othLineItem.aAndP += 1;
            sc2.othLineItem.motoagents += 1;
            sc2.othLineItem.contributionMargin += 1;

            SummaryCol sc5 = new SummaryCol();
            sc5.cwvLineItem = new totalColItem();
            sc5.porLineItem = new totalColItem();
            //add by qucw@lenovo  2015/8/3
            sc5.othLineItem = new totalColItem();
                  
            
            sc5.cwvLineItem.units += 1;
            sc5.cwvLineItem.minCommit += 1;
            sc5.cwvLineItem.nsbd += 1;
            sc5.cwvLineItem.discount += 1;
            sc5.cwvLineItem.nsad += 1;
            sc5.cwvLineItem.grossMargin += 1;
            sc5.cwvLineItem.aAndP += 1;
            sc5.cwvLineItem.motoagents += 1;
            sc5.cwvLineItem.contributionMargin += 1;    
            //add by qucw@lenovo  2015/8/3
            sc5.porLineItem.units += 1;
            sc5.porLineItem.minCommit += 1;
            sc5.porLineItem.nsbd += 1;
            sc5.porLineItem.discount += 1;
            sc5.porLineItem.nsad += 1;
            sc5.porLineItem.grossMargin += 1;
            sc5.porLineItem.aAndP += 1;
            sc5.porLineItem.motoagents += 1;
            sc5.porLineItem.contributionMargin += 1;  
            //add by qucw@lenovo  2015/8/3
            sc5.othLineItem.units += 1;
            sc5.othLineItem.minCommit += 1;
            sc5.othLineItem.nsbd += 1;
            sc5.othLineItem.discount += 1;
            sc5.othLineItem.nsad += 1;
            sc5.othLineItem.grossMargin += 1;
            sc5.othLineItem.aAndP += 1;
            sc5.othLineItem.motoagents += 1;
            sc5.othLineItem.contributionMargin += 1;         
            

            dvc.productMap.put('Agate', sc2 );
            dvc.getProducts();

            //dvc = new DealViewController();
            //dvc.productMap = new Map<String,SummaryCol>();
            dvc.productMap.put('', sc5 );
            dvc.getProducts();

            //dvc.saveChanges();

            //dvc.deleteSelectedColumns();
            //dvc.deleteBundleSelectedColumns();

            List<SummaryCol> sumList = new List<SummaryCol>();
            SummaryCol sc1 = new SummaryCol();
            SummaryCol sc3 = new SummaryCol();
            sumList.add(sc1);
            sumList.add(sc3);
            sumList.sort();

            List<totalCol> tcList = new List<totalCol>();
            totalCol tc1 = new totalCol();
            totalCol tc2 = new totalCol();
            tcList.add(tc1);
            tcList.add(tc2);
            tcList.sort();

            totalColItem tci = new totalColItem();
        }
    }

    static testMethod void testEditInExcel_Deal() {
        User levUser = createLevUser();
        
        System.runAs(levUser){
            Account testAcct = createAccount();
            Opportunity testOpp = createOpp(testAcct);
            Quote dealQuote = createDealQuote(testOpp);
            Product2 p = createProduct('Agate');
            Product2 p2 = createProduct('Test');
            Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true and isActive = true limit 1];
            PricebookEntry pe = createPricebooKEntry(pbook, p);
            PricebookEntry pe2 = createPricebooKEntry(pbook, p2);
            
            //Add by qucw@lenovo.com   2015/8/3
            List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem> {
                initiateQuoteLineItem(dealQuote, p, pe, 'Proposal'),
                initiateQuoteLineItem(dealQuote, p, pe, 'Plan'),
                initiateQuoteLineItem(dealQuote, p, pe, 'Other'),
                initiateQuoteLineItem(dealQuote, p2, pe2, 'Proposal'),
                initiateQuoteLineItem(dealQuote, p2, pe2, 'Plan'),
                initiateQuoteLineItem(dealQuote, p2, pe2, 'Other')
            };
            insert quoteLineItems;
    
            ApexPages.currentPage().getParameters().put('qId', dealQuote.Id);
            DealViewController dvc = new DealViewController();
            dvc.EditinExcel();
        }
    }

    static testMethod void testEditInExcel_BundleDeal() {
        User levUser = createLevUser();
        
        System.runAs(levUser){
            Account testAcct = createAccount();
            Opportunity testOpp = createOpp(testAcct);
            Quote dealQuote = createDealQuote(testOpp);
            Quote bundleQuote = createBundleQuote(testOpp, dealQuote);
            Product2 p = createProduct('Agate');
            Product2 p2 = createProduct('Test');
            Pricebook2 pbook = [select id from Pricebook2 where IsStandard = true and isActive = true limit 1];
            PricebookEntry pe = createPricebooKEntry(pbook, p);
            PricebookEntry pe2 = createPricebooKEntry(pbook, p2);
            
            //Add by qucw@lenovo.com   2015/8/3
            List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem> {
                initiateQuoteLineItem(bundleQuote, p, pe, 'Proposal'),
                initiateQuoteLineItem(bundleQuote, p, pe, 'Plan'),
                initiateQuoteLineItem(bundleQuote, p, pe, 'Other'),
                initiateQuoteLineItem(bundleQuote, p2, pe2, 'Proposal'),
                initiateQuoteLineItem(bundleQuote, p2, pe2, 'Plan'),
                initiateQuoteLineItem(bundleQuote, p2, pe2, 'Other')
            };
            insert quoteLineItems;
    
            ApexPages.currentPage().getParameters().put('qId', bundleQuote.Id);
            DealViewController dvc = new DealViewController();
            dvc.EditinExcel();
        }
    }

    public static void createOpp2(Account act, String Quar){
        Opportunity oppo = new Opportunity();
        oppo.Name = 'Test Lev Opp';
        oppo.stageName = 'New';
        oppo.closeDate = System.today();
        oppo.Account = act;
        oppo.Year__c = '2014';
        oppo.Quarter__c = Quar;
        oppo.Pricebook2Id = standardPb.Id;
        insert oppo;
    }

    public static Account createAccount(){
        Account act = new Account();
        act.Name = 'Test Lev Account';
        insert act;
        return act;
    }
    
    public static Pricebook2 createPricebook() {
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = 'Agate Pricebook';
        insert pb2;
        return pb2;
    }
    
    public static PricebookEntry createPricebookEntry(Pricebook2 pb, Product2 pr)
    {
        PricebookEntry pe = new PricebookEntry();
        pe.UnitPrice = 50;
        pe.Pricebook2Id = pb.Id;
        pe.Product2Id = pr.Id;
        pe.IsActive = true;
        pe.CurrencyIsoCode = 'USD';
        
        insert pe;
        return pe;
    }
    
    public static Opportunity createOpp(Account act){
        Opportunity oppo = new Opportunity();
        oppo.Name = 'Test Lev Opp';
        oppo.stageName = 'New';
        oppo.closeDate = System.today();
        oppo.Account = act;
        oppo.Year__c = '2014';
        oppo.Quarter__c = 'Q3';
        oppo.Pricebook2Id = standardPb.Id;
        insert oppo;
        return oppo;
    }
    
    public static Product2 createProduct(string name)
    {
        Product2 p = new Product2();
        p.Name = name;
        insert p;
        return p;
    }
    
    //  public static QuoteLineItem createQuoteLineItem(Quote q, Product2 p, PricebookEntry pe){
    //     QuoteLineItem qot = new QuoteLineItem();
    //     qot.quoteId = q.Id;
    //     qot.PricebooKEntryId = pe.Id;
    //     qot.Quantity = 5;
    //     qot.UnitPrice = 50;
    //     qot.Product2Id = p.Id;
    //     qot.Quarter__c = 'Q4';
    //     qot.Year__C = '2014';
    //     qot.Approval_Status__c = 'Approved';
    //     qot.Units__c = 1111;
    //     qot.MinimumCommitQuantity__c = 1111;
    //     qot.InvoicePrice__c = 10;
    //     qot.SDF__c = 10;
    //     qot.iMDF__c = 10;
    //     qot.COOP__c = 10;
    //     qot.MDF__c = 10;
    //     qot.SVM__c = 10;
    //     qot.IPP__c = 10;
    //     qot.National_Retail__c = 10;
    //     qot.CSAT__c = 10;
    //     qot.QP__c = 10;
    //     qot.TC__c = 10;
    //     qot.ILW__c = 10;
    //     qot.TDF__c = 10;
    //     qot.Fees__c = 10;
    //     qot.Negotiation_Buffer__c = 10;
    //     qot.MCPU__c = 10;
    //     qot.AP__c = 10;
    //     qot.motoagents__c = 10;
    //     insert qot;
    //     return qot;
    // }
    //Add by qucw@lenovo.com  2015/8/3
    public static QuoteLineItem createQuoteLineItem(Quote q, Product2 p, PricebookEntry pe, String type){
        QuoteLineItem qot = new QuoteLineItem();
        qot.quoteId = q.Id;
        qot.PricebooKEntryId = pe.Id;
        qot.Quantity = 5;
        qot.UnitPrice = 50;
        qot.Product2Id = p.Id;
        qot.Quarter__c = 'Q4';
        qot.Year__C = '2014';
        qot.Approval_Status__c = 'Pending';
        qot.Units__c = 1111;
        qot.MinimumCommitQuantity__c = 1111;
        qot.InvoicePrice__c = 10;
        qot.SDF__c = 10;
        qot.iMDF__c = 10;
        qot.COOP__c = 10;
        qot.MDF__c = 10;
        qot.SVM__c = 10;
        qot.IPP__c = 10;
        qot.National_Retail__c = 10;
        qot.CSAT__c = 10;
        qot.QP__c = 10;
        qot.TC__c = 10;
        qot.ILW__c = 10;
        qot.TDF__c = 10;
        qot.Fees__c = 10;
        qot.Negotiation_Buffer__c = 10;
        qot.MCPU__c = 10;
        qot.AP__c = 10;
        qot.motoagents__c = 10;
        qot.Deal_Type__c = type;
        insert qot;
        return qot;
    }

    public static QuoteLineItem initiateQuoteLineItem(Quote q, Product2 p, PricebookEntry pe, String type){
        QuoteLineItem qot = new QuoteLineItem();
        qot.quoteId = q.Id;
        qot.PricebooKEntryId = pe.Id;
        qot.Quantity = 5;
        qot.UnitPrice = 50;
        qot.Product2Id = p.Id;
        qot.Quarter__c = 'Q4';
        qot.Year__C = '2014';
        qot.Approval_Status__c = 'Pending';
        qot.Units__c = 1111;
        qot.MinimumCommitQuantity__c = 1111;
        qot.InvoicePrice__c = 10;
        qot.SDF__c = 10;
        qot.iMDF__c = 10;
        qot.COOP__c = 10;
        qot.MDF__c = 10;
        qot.SVM__c = 10;
        qot.IPP__c = 10;
        qot.National_Retail__c = 10;
        qot.CSAT__c = 10;
        qot.QP__c = 10;
        qot.TC__c = 10;
        qot.ILW__c = 10;
        qot.TDF__c = 10;
        qot.Fees__c = 10;
        qot.Negotiation_Buffer__c = 10;
        qot.MCPU__c = 10;
        qot.AP__c = 10;
        qot.motoagents__c = 10;
        qot.Deal_Type__c = type;
        return qot;
    }

    public static Quote createBundleQuote(Opportunity opp, Quote parent) {
        RecordType bundleDealRT = [
            SELECT Id FROM RecordType 
            WHERE RecordType.DeveloperName = 'BundleDeal'
            AND SObjectType = 'Quote'
        ];
        Quote qot = new Quote();
        qot.ParentQuote__c = parent.Id;
        qot.RecordTypeId = bundleDealRT.Id;
        qot.Portfolio_Segment__c = 'Authentication;Chargers & Cables;Core BT';
        qot.Name = 'Test Lev Quote';
        qot.OpportunityID = opp.Id;
        qot.Deal_Review_Date__c = System.today();
        qot.Pricebook2Id = standardPb.Id;
        insert qot;
        return qot;
    }

    // Create a quote which RecordType is Deal
    public static Quote createDealQuote(Opportunity opp) {
        RecordType dealRT = [
            SELECT Id FROM RecordType 
            WHERE RecordType.DeveloperName = 'Deal'
            AND SObjectType = 'Quote'
        ];
        Quote qot = new Quote();
        qot.RecordTypeId = dealRT.Id;
        qot.Portfolio_Segment__c = 'Authentication;Chargers & Cables;Core BT';
        qot.Name = 'Test Lev Quote';
        qot.OpportunityID = opp.Id;
        qot.Deal_Review_Date__c = System.today();
        qot.Pricebook2Id = standardPb.Id;
        insert qot;
        return qot;
    }
    
    public static User createLevUser(){
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
      User u = new User(Alias = 'stdlev', Email='standarduser@levementum.com', 
      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
      LocaleSidKey='en_US', ProfileId = p.Id, 
      TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@levementum.com');
      return u;
    }
}