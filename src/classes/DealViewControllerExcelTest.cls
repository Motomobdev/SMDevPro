@isTest (SeeAllData=TRUE)
private class DealViewControllerExcelTest {

    static Pricebook2 standardPb = createStdPricebook();
    
    @isTest static void test_dealviewQ1() {
        User levUser = createLevUser();
        
        System.runAs(levUser){
            Account testAcct = createAccount();
            System.debug('############### testAcct:' + testAcct);
            
            Opportunity testOpp = createOpp(testAcct, 'Q1');
           
            System.debug('############### testOpp:' + testOpp);
            
            Quote testQot = createQuote(testOpp);
            System.debug('############### testQot:' + testQot);
            
            Product2 p = createProduct('Agate');
            Product2 p2 = createProduct('Test');
            Product2 p3 = createProduct('Agate');
            //Pricebook2 p2 = createPricebook();
            Pricebook2 pbook = standardPb;
            PricebookEntry pe = createPricebooKEntry(pbook, p);
            PricebookEntry pe2 = createPricebooKEntry(pbook, p2);
            PricebookEntry pe3 = createPricebooKEntry(pbook, p3);
            
            createQuoteLineItem(testQot, p, pe, 'Q1');
            createQuoteLineItem(testQot, p3, pe3, 'Q2');
            createQuoteLineItem(testQot, p2, pe2, 'Q1');
            system.test.startTest();
            ApexPages.currentPage().getParameters().put('qId', testQot.Id);
    
            DealViewControllerExcel  dvc = new DealViewControllerExcel();

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
            dvc.selectedIdString = p.Id + ',' + p2.Id;
            
            //TEST CONTROLLER FUNCTIONS
            dvc.getAllProductOptions();
            dvc.goToNextPage();
            dvc.checkQuarterQ1();
            dvc.createLineItemsFromQueue();
            dvc.getAvailableProductOptions();
            dvc.getSelected();
            dvc.loadTable();
            dvc.getProducts();
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
            dvc.checkQuarterQ1();
            dvc.checkQuarterQ2();
            dvc.checkQuarterQ3();
            dvc.checkQuarterQ4();
            dvc.addProductsToQueue(2014, 'Q2');
            dvc.removeProductsFromQueue();
            dvc.createLineItemsFromQueue();
            //dvc.sortQuoteLineItems(null);
            dvc.removeQuarterFromName('Agate - Q2');
            dvc.getProducts();
            dvc.addProductsToQueue(2014, 'Q3');
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
            DealViewControllerExcel.ExecutiveNoteWrapper enw = new DealViewControllerExcel.ExecutiveNoteWrapper(null, null);
            DealViewControllerExcel.ProductQueueWrapper pqw = new DealViewControllerExcel.ProductQueueWrapper(pe, 2014, 'Q1');
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
            dvc.workItems = [SELECT Id,ActorId,ProcessInstance.TargetObjectId,ProcessInstance.Status 
                            FROM ProcessInstanceWorkitem LIMIT 1];

            dvc.acceptWorkItem();
            dvc.rejectWorkItem();
            dvc.recallProcess();

           DealViewControllerExcel.ProductQueueWrapper pqw2 = new DealViewControllerExcel.ProductQueueWrapper(pe, 2014, 'Q2');
            dvc.productsQueue.add(pqw);
            dvc.productsQueue.add(pqw2);
            dvc.createLineItemsFromQueue();
            dvc.addProductsToQueue(2014, 'Q1');
            dvc.addProductsToQueue(2014, 'Q2');
            dvc.addProductsToQueue(2014, 'Q3');
            dvc.addProductsToQueue(2014, 'Q4');
            dvc.getProducts();

            // ctalladen@levementum.com 19feb .
         /*   dvc.quarterVal = 'Q1';
            dvc.calculateFiscalYear();
            dvc.quarterVal = 'Q2';
            dvc.calculateFiscalYear();
            dvc.quarterVal = 'Q3';
            dvc.calculateFiscalYear();
            dvc.quarterVal = 'Q4';
            dvc.calculateFiscalYear(); */

            QuoteLineItem qli3 = createQuoteLineItem(testQot, p2,pe, 'Q4');
            lineItemCol lic = new lineItemCol();
            List<QuoteLineItem> qliL = new List<QuoteLineItem>();
            qliL.add(qli3);
            dvc.sortQuoteLineItems(qliL);
            dvc.selectedKeywords = 'TEST';

            dvc.lineItemColumns = new List<lineItemCol>();
            lineItemCol col = new lineItemCol();
            col.name = 'TEST';
            col.Year = '2014';
            dvc.lineItemColumns.add(col);

            Quote qot2 = createQuote(testOpp);
            testQot.Name = 'tested update';
            testQot.ParentQuote__c = qot2.Id;
            testQot.HasStoplight__c = true;
            testQot.HasSummary__c = true;
            //upsert testQot;

            dvc.productMap  = new Map<String,SummaryCol>();

            SummaryCol sc2 = new SummaryCol();
            sc2.cwvLineItem = new totalColItem();
            sc2.porLineItem = new totalColItem();
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

            sc5.porLineItem.units += 1;
            sc5.porLineItem.minCommit += 1;
            sc5.porLineItem.nsbd += 1;
            sc5.porLineItem.discount += 1;
            sc5.porLineItem.nsad += 1;
            sc5.porLineItem.grossMargin += 1;
            sc5.porLineItem.aAndP += 1;
            sc5.porLineItem.motoagents += 1;
            sc5.porLineItem.contributionMargin += 1;

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

            //dvc = new DealViewControllerExcel();
            //dvc.productMap = new Map<String,SummaryCol>();
            dvc.productMap.put('', sc5 );
            dvc.getProducts();

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
            system.test.stopTest();
        }

    }


    @isTest static void test_dealviewQ2() {
        User levUser = createLevUser();
        
        System.runAs(levUser){
            Account testAcct = createAccount();
            System.debug('############### testAcct:' + testAcct);
            
            Opportunity testOpp = createOpp(testAcct, 'Q2');
            System.debug('############### testOpp:' + testOpp);
            
            Quote testQot = createQuote(testOpp);
            System.debug('############### testQot:' + testQot);
            
            Product2 p = createProduct('Agate');
            Product2 p2 = createProduct('Test');
            
            //Pricebook2 p2 = createPricebook();
            Pricebook2 pbook = standardPb;
            PricebookEntry pe = createPricebooKEntry(pbook, p);
            PricebookEntry pe2 = createPricebooKEntry(pbook, p2);

            List<QuoteLineItem> listQli = new List<QuoteLineItem>();
            
            createQuoteLineItem(testQot, p, pe, 'Q1');
            createQuoteLineItem(testQot, p2, pe2, 'Q1');
            
    
            ApexPages.currentPage().getParameters().put('qId', testQot.Id);
            //ApexPages.currentPage().getParameters().put('vfpEditMode', 'true');
    
            DealViewControllerExcel  dvc = new DealViewControllerExcel();

            dvc.thisQuote = testQot;

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
            dvc.getAvailableProductOptions();
            dvc.getProducts();

            System.debug('############### listQli:' + listQli);
            

            dvc.goToNextPage();
            dvc.checkQuarterQ1();
            
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
            //dvc.saveExecutiveSummaryNote();
            
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
            dvc.addProductsToQueue(2014, 'Q2');
            dvc.removeProductsFromQueue();
            dvc.sortQuoteLineItems(null);
            dvc.removeQuarterFromName('Agate - Q2');
            dvc.getAvailableProductOptions();
            
            dvc.getCustomRender();
            lineItemCol lI = new lineItemCol();
            totalCol tC = new totalCol();
            summaryCol sC = new summaryCol();
            totalColItem tCI = new totalColItem();
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
            DealViewControllerExcel.ExecutiveNoteWrapper enw = new DealViewControllerExcel.ExecutiveNoteWrapper(null, null);
            DealViewControllerExcel.ProductQueueWrapper pqw = new DealViewControllerExcel.ProductQueueWrapper(null, 2014, 'Q3');
            
            dvc.productsQueue.add(pqw);
            dvc.addProductsToQueue(2014, 'Q4');

            dvc.createLineItemsFromQueue();


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



        }

    }

    @isTest static void test_dealviewQ3() {
        User levUser = createLevUser();
        
        System.runAs(levUser){
            Account testAcct = createAccount();
            System.debug('############### testAcct:' + testAcct);
            
            Opportunity testOpp = createOpp(testAcct, 'Q3');
            System.debug('############### testOpp:' + testOpp);
            
            Quote testQot = createQuote(testOpp);
            System.debug('############### testQot:' + testQot);
            
            Product2 p = createProduct('Agate');
            Product2 p2 = createProduct('Test');
            
            //Pricebook2 p2 = createPricebook();
            Pricebook2 pbook = standardPb;
            PricebookEntry pe = createPricebooKEntry(pbook, p);
            PricebookEntry pe2 = createPricebooKEntry(pbook, p2);

            List<QuoteLineItem> listQli = new List<QuoteLineItem>();
            
            createQuoteLineItem(testQot, p, pe, 'Q1');
            createQuoteLineItem(testQot, p2, pe2, 'Q1');
            
    
            ApexPages.currentPage().getParameters().put('qId', testQot.Id);
            //ApexPages.currentPage().getParameters().put('vfpEditMode', 'true');
    
            DealViewControllerExcel  dvc = new DealViewControllerExcel();

            dvc.thisQuote = testQot;

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
            dvc.getAvailableProductOptions();
            dvc.getProducts();

            System.debug('############### listQli:' + listQli);
            

            dvc.goToNextPage();
            dvc.checkQuarterQ1();
            
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
            dvc.saveExecutiveSummaryNote();
            
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
            dvc.sortQuoteLineItems(null);
            dvc.removeQuarterFromName('Agate - Q1');
            dvc.getAvailableProductOptions();
            
            dvc.getCustomRender();
            lineItemCol lI = new lineItemCol();
            totalCol tC = new totalCol();
            summaryCol sC = new summaryCol();
            totalColItem tCI = new totalColItem();
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
            DealViewControllerExcel.ExecutiveNoteWrapper enw = new DealViewControllerExcel.ExecutiveNoteWrapper(null, null);
            DealViewControllerExcel.ProductQueueWrapper pqw = new DealViewControllerExcel.ProductQueueWrapper(null, 2014, 'Q2');
            
            dvc.productsQueue.add(pqw);
            dvc.addProductsToQueue(2014, 'Q3');

            dvc.createLineItemsFromQueue();


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



        }

    }

    @isTest static void test_dealviewQ4() {
        User levUser = createLevUser();
        
        System.runAs(levUser){
            Account testAcct = createAccount();
            System.debug('############### testAcct:' + testAcct);
            
            Opportunity testOpp = createOpp(testAcct, 'Q4');
            System.debug('############### testOpp:' + testOpp);
            
            Quote testQot = createQuote(testOpp);
            System.debug('############### testQot:' + testQot);
            
            Product2 p = createProduct('Agate');
            Product2 p2 = createProduct('Test');
            
            //Pricebook2 p2 = createPricebook();
            Pricebook2 pbook = standardPb;
            PricebookEntry pe = createPricebooKEntry(pbook, p);
            PricebookEntry pe2 = createPricebooKEntry(pbook, p2);

            List<QuoteLineItem> listQli = new List<QuoteLineItem>();
            
            createQuoteLineItem(testQot, p, pe, 'Q1');
            createQuoteLineItem(testQot, p2, pe2, 'Q1');
            
    
            ApexPages.currentPage().getParameters().put('qId', testQot.Id);
            //ApexPages.currentPage().getParameters().put('vfpEditMode', 'true');
    
            DealViewControllerExcel  dvc = new DealViewControllerExcel();

            dvc.thisQuote = testQot;

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
            dvc.getAvailableProductOptions();
            dvc.getProducts();

            System.debug('############### listQli:' + listQli);
            

            dvc.goToNextPage();
            dvc.checkQuarterQ1();
            
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
            dvc.saveExecutiveSummaryNote();
            
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
            dvc.sortQuoteLineItems(null);
            dvc.removeQuarterFromName('Agate - Q1');
            dvc.getAvailableProductOptions();
            
            dvc.getCustomRender();
            lineItemCol lI = new lineItemCol();
            totalCol tC = new totalCol();
            summaryCol sC = new summaryCol();
            totalColItem tCI = new totalColItem();
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
            DealViewControllerExcel.ExecutiveNoteWrapper enw = new DealViewControllerExcel.ExecutiveNoteWrapper(null, null);
            DealViewControllerExcel.ProductQueueWrapper pqw = new DealViewControllerExcel.ProductQueueWrapper(null, 2014, 'Q2');
            
            dvc.productsQueue.add(pqw);
            dvc.addProductsToQueue(2014, 'Q3');

            dvc.createLineItemsFromQueue();


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
        }

    }


    public static Account createAccount(){
        Account act = new Account();
        act.Name = 'Test Lev Account';
        insert act;
        return act;
    }
    
    public static Pricebook2 createPricebook()
    {
        Pricebook2 pb2 = new Pricebook2();
        pb2.Name = 'Agate Pricebook';
        insert pb2;
        return pb2;
    }
    
    public static Pricebook2 createStdPricebook()
    {
        //Pricebook2 pb2 = new Pricebook2();
        Pricebook2 pb2 = [select id, name, isActive from Pricebook2 where isStandard=true LIMIT 1];
        //pb2.Name = 'Standard Price Book';
        //pb2.isActive = true;
        //pb2.isStandard=true;
        //insert pb2;
        return pb2;
    }
    
    public static PricebookEntry createPricebookEntry(Pricebook2 pb, Product2 pr)
    {
        PricebookEntry pe = new PricebookEntry();
        pe.UnitPrice = 50;
        pe.Pricebook2Id = pb.Id;
        pe.Product2Id = pr.Id;
        pe.IsActive = true;
        insert pe;
        return pe;
    }
    
    public static Opportunity createOpp(Account act, String Quar){
            Opportunity oppo = new Opportunity();
            oppo.Name = 'Test Lev Opp';
            oppo.stageName = 'New';
            oppo.closeDate = System.today();
            oppo.Account = act;
            oppo.Year__c = '2014';
            oppo.Quarter__c = Quar;
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
    
     public static QuoteLineItem createQuoteLineItem(Quote q, Product2 p, PricebookEntry pe, String Qut){
        QuoteLineItem qot = new QuoteLineItem();
        qot.quoteId = q.Id;
        qot.PricebooKEntryId = pe.Id;
        qot.Quantity = 5;
        qot.UnitPrice = 50;
        qot.Product2Id = p.Id;
        qot.Quarter__c = Qut;
        qot.Year__C = '2014';
        qot.Deal_Type__c = 'Proposal';
        qot.Approval_Status__c  = 'Pending';
        insert qot;

        qot = new QuoteLineItem();
        qot.quoteId = q.Id;
        qot.PricebooKEntryId = pe.Id;
        qot.Quantity = 5;
        qot.UnitPrice = 50;
        qot.Product2Id = p.Id;
        qot.Quarter__c = Qut;
        qot.Year__C = '2014';
        qot.Deal_Type__c = 'Plan';
        insert qot;

        qot = new QuoteLineItem();
        qot.quoteId = q.Id;
        qot.PricebooKEntryId = pe.Id;
        qot.Quantity = 5;
        qot.UnitPrice = 50;
        qot.Product2Id = p.Id;
        qot.Quarter__c = Qut;
        qot.Year__C = '2014';
        qot.Deal_Type__c = 'Other';
        insert qot;

        return qot;
    
    }


    public static Quote createQuote(Opportunity opp){
        Quote qot = new Quote();
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