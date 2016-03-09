public class DealViewControllerExcel  {

    public Quote thisQuote {get;set;} 
    public Boolean inApprovalProccess {get;set;} 
    public List<ProcessInstanceWorkitem> workItems {get;set;}
    public List<ProcessInstanceWorkitem> workItemActorIds {get;set;}
    public List<ProcessInstanceWorkitem> workItemsSubmitter {get;set;}
    public Boolean submitterWorkItems {get;set;}
    public Boolean hasWorkItems {get;set;}
    public List<Attachment> availableAttachments {get;set;}
    public List<Note> availableNotes {get;set;}
    public Boolean hasNewAttachments {get;set;}
    public Boolean hasAttachments {get;set;}
    public Boolean attachmentsPopUpShow {get;set;}
    public Boolean notesPopUpShow {get;set;} 
    public Boolean editModeNote {get;set;}
    public Note note {get; set;} 

    public Boolean isExcelRender {get;set;}
    public Boolean summary {get;set;}
    public String tabPosition{get;set;}
    public List<totalCol> totalColumns {get;set;}
    public Integer totalItemCount {get;set;}
    public List<lineItemCol> lineItemColumns {get;set;}
    public SummaryCol summaryColumns {get;set;}
    public List<SummaryCol> summaryProductColumns {get;set;}
    public Integer summaryProductCount {get;set;}
    
    public List<lineItemCol> quoteComment {get;set;}
    
    public Integer lineItemCount {get;set;}
    public List<SelectOption> availableOptions {get;set;}
    public List<SelectOption> selectedOptions {get;set;}
    public Boolean showTable {get;set;}
    public List<SelectOption> productOptions {get;set;}
    public String selectedNewProduct {get;set;}
    public String selectedNewQuarter {get;set;}
    public Boolean showCWVs {get;set;}
    public Boolean showPORs {get;set;}
    //add for other column, modified by qucw@lenovo.com   16 Jun 2015
    public Boolean showOTHs {get;set;}

    public Boolean visibleOrNot1 {get;set;}
    public Boolean visibleOrNot2 {get;set;}
    public Boolean visibleOrNot3 {get;set;}
    public Boolean visibleOrNot4 {get;set;}
    public Boolean visibleOrNot5 {get;set;}
    public Boolean visibleOrNot6 {get;set;}
    public Boolean visibleOrNot7 {get;set;}
    public Boolean visibleOrNot8 {get;set;}
    public Boolean visibleOrNot9 {get;set;}
    public Boolean visibleOrNot10 {get;set;}
    public Boolean visibleOrNot11 {get;set;}
    public Boolean visibleOrNot12 {get;set;}
    public Boolean visibleOrNot13 {get;set;}
    public Boolean visibleOrNotSDF {get;set;}
    
    public String COOPLabel  {get;set;}
    public String MDFLabel  {get;set;}
    public String iMDFLabel  {get;set;}
    public String SVMLabel  {get;set;}
    public String IPPLabel  {get;set;}
    public String NationalLabel  {get;set;}
    public String CSATLabel  {get;set;}
    public String QPLabel  {get;set;}
    public String TCLabel  {get;set;}
    public String ILWLabel  {get;set;}
    public String TDFLabel  {get;set;}
    public String FeesLabel  {get;set;}
    public String NegotiationLabel  {get;set;}
    public String SDFLabel {get;set;}
    public String recId {get;set;}
    
    
    public string selectedKeywords {get;set;}
    public List<List<PricebookEntry>> serarchResults {get;set;}
    public List<PriceBookEntry> currentList {get;set;}
    public List<ProductQueueWrapper> productsQueue {get;set;} // jescamilla@levementum.com 9/24/14 Description: Enable a Product Queue to be able to add products to different quarters.
    public string sortBy {get;set;}
   
    public Integer pageSize {get;set;}
    public Integer currentPage {get;set;}
    public Integer totalPages {get;set;}
    

    public Boolean onFirstPage {get;set;}
    public Boolean onLastPage {get;set;}
    
    public String currencyFormay {get; set;}

    public List<Note> summaryNotes {get; set;} // jescamilla@levementum.com 9/18/14 Description: Summary Notes.
    Public String feedbackMsg {get; set;} // jescamilla@levementum.com 9/18/14 Description: feedback.
    Public Boolean vfpEditMode {get; set;} // jescamilla@levementum.com 9/18/14 Description: Enable Edit All on page load.
    Public Boolean vfpViewAllMode {get; set;} // jescamilla@levementum.com 10/29/14 Description: Enable View All on page load.
    
    /* 
     * @email:  cmunoz@levementum.com
     * @date:   09/03/14
     * @brief:  Maintains control of Product selection forms (drop downs at the top of DealView.page) if product exists for a specific quote item.
     */
     public Boolean hasProducts {get; set;}
     public Boolean isVisible {get; set;}
     public Boolean isTableVisible {get; set;}
     public Boolean displayPanel {get; set;}
     public String errorMsg {get; set;}
     
     /* 
     * @email:  cmunoz@levementum.com
     * @date:   09/04/14
     * @brief:  Adds fiscal year to quarter buttons (q1, q2, q3, and q4)
     */
     public String fiscalYearValueQ1 {get; set;}
     public String fiscalYearValueQ2 {get; set;}
     public String fiscalYearValueQ3 {get; set;}
     public String fiscalYearValueQ4 {get; set;}
     /**
     * @author: jescamilla@levementum.com
     * @date: 9/24/14
     * @brief: Track the Years on the Add To Buttons in the VFP
     */
     public Integer fiscalYearQ1 {get; set;}
     public Integer fiscalYearQ2 {get; set;}
     public Integer fiscalYearQ3 {get; set;}
     public Integer fiscalYearQ4 {get; set;}
     
     public Boolean formulaError  {get; set;}
     
     /* */
     public Boolean listEmpty  {get; set;}
     public Id qId = null;
   
   
    public string selectedIdString {get;set;}
    public List<Id> selectedId {get;set;}
    public  Map<String,List<QuoteLineItem>> lineItemsByQuoteId;
    
    public List<lineItemCol> cols;
    
    public PageReference currentUrl {get; set;}
    
    //cmunoz@levementum.com. 09/19/14. Description: Summary notes and deal staus tasks
    public List<Note> notesExecSummary {get; set;}
    public List<ExecutiveNoteWrapper> summaryExecNotes {get; set;}
    public Quote quoteStatus {get; set;}
    public Boolean isExecNotes {get; set;}
    public Boolean isSummaryNotes {get; set;}
    public String fiscalYear = '';
    public String quarterVal = '';
    public User createdBy {get; set;}
    public ExecutiveNoteWrapper execWrapper {get;set;}
    public Boolean editExecutiveSummaryNote {get;set;}

    public Map<String,SummaryCol> productMap;

    public DealViewControllerExcel(){
        editExecutiveSummaryNote = true;
        hasWorkItems = false;
        inApprovalProccess = false;
        hasNewAttachments = false;
        hasAttachments = false;
        notesPopUpShow = false;
        listEmpty = false;
        displayPanel = false;
        isVisible = false;
        hasProducts = false;
        showTable = false;
        isExcelRender = false;
        tabPosition = 'Deal View';
        summary = false; 
        editModeNote = false;
        qId = null;
        currentUrl = ApexPages.currentPage();
        note = new Note();
        summaryNotes = new List<Note>();
        summaryExecNotes = new List<ExecutiveNoteWrapper>();
        createdBy = new User();
        a = new Attachment();
        productsQueue = new List<ProductQueueWrapper>();
       // feedbackMsg = '';

        system.debug('?? ' + ApexPages.currentPage().getParameters().get('qId'));
       if(ApexPages.currentPage().getParameters().get('qId') != null){
        qId = ApexPages.currentPage().getParameters().get('qId');
            recId = qId;// jgarcia@levementum.com 9/8/2014. Variable used to pass the id parameter to the DealAttachment.page when click on the attachment button
            
            
            thisQuote = [select id, name, pricebook2Id, Status, CreatedById, CreatedDate, ExecutiveSUmmary__c, Opportunity.CurrencyIsoCode,HasStoplight__c from quote where id = :qId limit 1];
            
            system.debug(thisQuote + '----------------');
            getAvailableProductOptions();
            calculateFiscalYear();
            setQuoteStatus(qId);
        }
        
        //cmunoz@levementum.com. 09/23/14. Added validation for null values.
        if(thisQuote != null)
        {
            //jgarcia@levementum.com 9/18/2014. If Submitted for Approval, run query to get the work items that are in process for this quote nad store it in workitems variable to use it
            //in acceptWorkItem or rejectWorkItem functions and set hasWorkItems to true to lock the VF page
            workItemActorIds = [SELECT Id,ActorId,ProcessInstance.TargetObjectId,ProcessInstance.Status FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :qId AND ActorId = :UserInfo.getUserId()];
            
           
            if(workItemActorIds.size() > 0){
                hasWorkItems = true;
            }
            workItems = [SELECT Id,ActorId,ProcessInstance.TargetObjectId,ProcessInstance.Status FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :qId];
            

            if(workItems.size() > 0){
                inApprovalProccess = true;
            }
            
            workItemsSubmitter = [SELECT Id,ActorId,ProcessInstance.TargetObjectId,ProcessInstance.Status FROM ProcessInstanceWorkitem WHERE ProcessInstance.TargetObjectId = :qId AND CreatedById = :UserInfo.getUserId()];
           
            if(workItemsSubmitter.size() > 0){
                submitterWorkItems = true;
            }
        }

        //jgarcia@levementum.com 9/18/2014. function to bring all of the notes related to the quote
        availableNotes =  getNotes();
        availableAttachments = getAttachments();

        showCWVs = true;
        showPORs = true;
        //Add for other column, modified by qucw@lenovo.com  16 jun 2015
        showOTHs = true;
        COOPLabel = '- COOP';  
        MDFLabel = '- MDF'; 
        iMDFLabel = '- iMDF'; 
        SVMLabel = '- SVM';  
        IPPLabel = '- IPP';  
        NationalLabel = '- National Retail';  
        CSATLabel = '- CSAT';  
        QPLabel = '- QP';  
        TCLabel = '- TC';  
        ILWLabel = '- ILW';  
        TDFLabel = '- TDF'; 
        FeesLabel = '- Fees'; 
        NegotiationLabel = '- Negotiation Buffer';
        SDFLabel = '- SDF'; 
        
        selectedKeywords = '';
        sortBy = 'product2.Name';
        serarchResults = new List<List<PricebookEntry>>();
        pageSize = 50;
        currentPage = 1;
        totalPages = 0;
        onFirstPage = true;
        onLastPage = true;
        
        doSearch();
        setDisplayTable();

        /**
        * @author: jescamilla@levementum.com
        * @date: 9/18/14
        * @brief: Add Notes to the Summary Section
        */

        if(thisQuote != null)
        {
            if(thisQuote.Id != null)
            {
                summaryNotes = [SELECT Body, Title, CreatedDate, Owner.FirstName, Owner.LastName FROM Note Where ParentId = :thisQuote.Id AND (NOT Title LIKE '%Executive Summary%') ORDER BY CreatedDate];
                notesExecSummary = [SELECT Body, Title, CreatedDate, Owner.FirstName, Owner.LastName FROM Note Where ParentId = :thisQuote.Id and Title LIKE '%Executive Summary%' ORDER BY CreatedDate];
            }
            
            createdBy = [SELECT FirstName, LastName FROM User where id=: thisQuote.createdById limit 1];
        
            execWrapper = new ExecutiveNoteWrapper(thisQuote, createdBy);
            checkNotesRendering();
        }
        
         /**
        * @author: jgarcia@levementum.com
        * @date: 9/25/14
        * @brief: trigger edit mode if vfpEditMode == 'true';
        */
        if(thisQuote != null)
        {
            if(ApexPages.currentPage().getParameters().get('vfpEditMode') != null && ApexPages.currentPage().getParameters().get('vfpEditMode') == 'true'){
                vfpEditMode = true;
                }else{
                    vfpEditMode = false;
                }
                
                vfpEditMode = true;
    
                if(vfpEditMode == true){
                    availableOptions = new List<SelectOption>();
                    selectedOptions = new List<SelectOption>();
                    set<String> nameSet = new set<String>();
                    for(QuoteLineItem qli : [select id, product2.Id, product2.Name,Total_CM__c,Units__c,Total_Fees__c,Total_Contribution_Margin__c,Total_Motoagents__c,Total_A_P__c,Total_GM__c,Total_Gross_Margin__c,Total_Negotiation_Buffer__c,Total_TDF__c,Total_ILW__c,Total_QP__c,Total_TC__c,Total_CSAT__c,Total_SVM__c,Total_National_Retail__c,Total_IPP__c,Total_NSAD__c,Total_Aggregate_Discounts__c,Total_COOP__c,Total_iMDF__c, Name__c,InvoicePrice__c,Total_MDF__c, MCPU__c, MinimumCommitQuantity__c, Quantity__c, Quarter__c, TotalAPAmount__c, Year__c from QuoteLineItem where quoteId = :thisQuote.Id]){
                        nameSet.add(qli.Name__c);
                    }
                    for(String s : nameSet){
                        selectedOptions.add(new selectOption(s,s));
                    }
                    system.debug('****selectedOptions****'+selectedOptions);
                    getProducts();
                }
        }
    }  //end of constructor
    
    /* 
     * @email:  cmunoz@levementum.com
     * @date:   09/19/14
     * @description:    Gets quote status
     */
     public void setQuoteStatus(Id quoteId)
     {
        try
        {
            quoteStatus = [SELECT Id, Status from Quote where id =: quoteId limit 1];
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
     }
    
    /* 
     * @email:  cmunoz@levementum.com
     * @date:   09/08/14
     * @description:    Calculates Fiscal Year for both new and exisitng Deals
     * @description:    // jescamilla@levementum.com 9/24/14 Description: Modified this function to track the year configured for the buttons via fiscalYearQx variables.
     */
    public String calculateFiscalYear()
    {
        try
        {
            List<Opportunity> selectedfiscalYear = new List<Opportunity>();
                selectedfiscalYear = [Select Year__c, Quarter__c from Opportunity where id in (Select opportunityId from Quote where id =: qId) limit 1];
                fiscalYear = selectedfiscalYear[0].Year__c;
                quarterVal = selectedfiscalYear[0].Quarter__c;
            
            Integer year = Integer.valueOf(fiscalYear);
            
            if(quarterVal.contains('4'))
            {
                fiscalYearValueQ1 = 'Add Q4 ' + year; fiscalYearQ1 = year;
                fiscalYearValueQ2 = 'Add Q1 ' + (year + 1); fiscalYearQ2 = year+1;
                fiscalYearValueQ3 = 'Add Q2 ' + (year + 1); fiscalYearQ3 = year+1;
                fiscalYearValueQ4 = 'Add Q3 ' + (year + 1); fiscalYearQ4 = year+1;
            } 
            else if(quarterVal.contains('3'))
            {
                fiscalYearValueQ1 = 'Add Q3 ' + year; fiscalYearQ1 = year;
                fiscalYearValueQ2 = 'Add Q4 ' + year; fiscalYearQ2 = year;
                fiscalYearValueQ3 = 'Add Q1 ' + (year + 1); fiscalYearQ3 = year+1;
                fiscalYearValueQ4 = 'Add Q2 ' + (year + 1); fiscalYearQ4 = year+1;
            } 
            else if(quarterVal.contains('2'))
            {
                fiscalYearValueQ1 = 'Add Q2 ' + year; fiscalYearQ1 = year;
                fiscalYearValueQ2 = 'Add Q3 ' + year; fiscalYearQ2 = year;
                fiscalYearValueQ3 = 'Add Q4 ' + year; fiscalYearQ3 = year;
                fiscalYearValueQ4 = 'Add Q1 ' + (year + 1); fiscalYearQ4 = year+1;
            } 
            else
            {
                fiscalYearValueQ1 = 'Add Q1 ' + year; fiscalYearQ1 = year;
                fiscalYearValueQ2 = 'Add Q2 ' + year; fiscalYearQ2 = year;
                fiscalYearValueQ3 = 'Add Q3 ' + year; fiscalYearQ3 = year;
                fiscalYearValueQ4 = 'Add Q4 ' + year; fiscalYearQ4 = year;
            }
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return fiscalYear;
    }
    
    /*
     * @author: Cuauhtemoc Munoz
     * @date:   09/08/14
     * @email:  cmunoz@levementum.com
     * @description:    Calculates current quarter based on current date (Today's date)
     */
    public Integer getQuarter()
    {
        return ((Date.today().month() - 1) / 3) + 1;
    }
    
    /* 
     * @email:  cmunoz@levementum.com
     * @date:   09/08/14
     * @brief:  Defines visibility of search result window window when creating a new deal
     */
    public pageReference setDisplayPanelVisibility()
    {
        displayPanel = true; 
        isVisible = true;
        return null;
    }
    
    /* 
     * @email:  cmunoz@levementum.com
     * @date:   09/08/14
     * @brief:  Defines visibility of search result window when creating a new deal
     */
    public void setDisplayTable()
    {
        isTableVisible =  ((showTable && !isExcelRender) || hasProducts) || !hasProducts;
    }
    
    public void getAllProductOptions(){
        productOptions = new List<SelectOption>();
        Set<Id> prodIDs = new Set<Id>();
        for(PricebookEntry pbe : [select product2Id from PricebookEntry where product2.IsActive = true order by product2.name limit 100]){
            prodIDs.add(pbe.product2Id);
        }
        for(Product2 p : [select id,name from product2 where isActive = true and Id in :prodIDs order by name]){
            productOptions.add(new selectOption(p.Id,p.Name));
        }
    }
    
    // cmunoz@levementum.com. 10/07/14. Keeps track of current products to avoid adding the same product with the same year and same quarter on products queue
    public Map<String, String> selectedProductsForQueue = new Map<String, String>();
    public void getAvailableProductOptions(){
        try
        {
            availableOptions = new List<SelectOption>();
            selectedOptions = new List<SelectOption>();
            set<String> nameSet = new set<String>();
            for(QuoteLineItem qli : [select id, product2.Id, product2.Name,Total_CM__c,Units__c,Total_Fees__c,Total_Contribution_Margin__c,Total_Motoagents__c,Total_A_P__c,Total_GM__c,Total_Gross_Margin__c,Total_Negotiation_Buffer__c,Total_TDF__c,Total_ILW__c,Total_QP__c,Total_TC__c,Total_CSAT__c,Total_SVM__c,Total_National_Retail__c,Total_IPP__c,Total_NSAD__c,Total_Aggregate_Discounts__c,Total_COOP__c,Total_iMDF__c, Name__c,InvoicePrice__c,Total_MDF__c, MCPU__c, MinimumCommitQuantity__c, Quantity__c, Quarter__c, TotalAPAmount__c, Year__c from QuoteLineItem where quoteId = :thisQuote.Id]){
                selectedProductsForQueue.put(qli.product2.Id+'-'+qli.Year__c+'-'+qli.Quarter__c, qli.product2.Id+'-'+qli.Year__c+'-'+qli.Quarter__c); // cmunoz@levementum.com. 10/07/14. Populates current products used in products queue comparison
                nameSet.add(qli.Name__c);
            }
            for(String s : nameSet){
                availableOptions.add(new selectOption(s,s));
            }
            
            
            /*
             * BEGINS CHANGE
             * @email:  cmunoz@levementum.com
             * @date:   09/03/14
             * @brief:  Hides Product Selection form if no poroducts available
             */
            if(nameSet.size() <= 0)
            {
                hasProducts = false; 
                isVisible = true;
            }
            else
            {
                hasProducts = true;
            }
            system.debug('size prods ' + nameSet.size() + ' ' + hasProducts);
            /* ENDS CHANGE */
            }
        catch(Exception ex){}
    }
    
    public PageReference cancelQueue()
    {
        try
        {
            displayPanel = false;
            
            if(availableOptions.size() > 0 || selectedOptions.size() > 0)
            {
                isTableVisible = true;
                isVisible = false; 
            }
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return null;
    }
    
    public pageReference loadTable(){
        getProducts();
        displayPanel = false;
        isVisible = false;
        return null;
    }
    
    public pageReference stopEditMode(){
        ApexPages.currentPage().getParameters().put('vfpEditMode','false');
        vfpEditMode = false;
        return null;
    }
    
    /*
     * @author: Cuauhtemoc Munoz
     * @date:   10/09/14
     * @email:  cmunoz@levementum.com
     * @description: Removes duplicates from products queue
     * @date:   10/10/14 -- Fixed duplicates issue. Removde for loop and changed it into a while lopp to update counter iff we don't remove an element from the queue.
     * Also added error message when a duplicate is added to the queue. Modified DealView.page by moving Message block to the top of the form.
     */
     public void removeDuplicateProduct()
     {
        try
        {
            system.debug('size ' + productsQueue.size());
            Set<String> nonDuplicateProducts = new Set<String>();
            if(productsQueue != null)
            {
                Integer i = 0;
                Boolean dupVal = false;
                String msg = 'An attempt to add duplicate products was detected. The following products were not added to the queue: <br/><br/>';
                while(i < productsQueue.size())
                {
                    ProductQueueWrapper currentProduct = productsQueue.get(i);
                    if(currentProduct != null)
                    {
                        if(!nonDuplicateProducts.add(currentProduct.pbe.product2.Name+'-'+currentProduct.year+'-'+currentProduct.quarter))
                        {
                            //remove duplicate from queue
                            productsQueue.remove(i);
                            msg+= '['+currentProduct.quarter+'-'+currentProduct.year+'-'+currentProduct.pbe.product2.Name+'] <br/>';
                            dupVal = true;
                        }
                        else
                        {
                            i++;
                        }
                    }
                    else
                    {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'An error has ocurred. Please contact your administrator.'));
                    }
                }
                if(dupVal)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, msg));
                }
            }
            system.debug('size ' + productsQueue.size());
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
     }
    
    
    /*
     * @author: Cuauhtemoc Munoz
     * @date:   09/08/14
     * @email:  cmunoz@levementum.com
     * @description:    Redirects quarter calculation for Q1
     */
    public PageReference checkQuarterQ1()
    {
        /*if(fiscalYearValueQ1.contains('Q1')){return addProductsQ1();}
        else if(fiscalYearValueQ1.contains('Q2')){return addProductsQ2();}
        else if(fiscalYearValueQ1.contains('Q3')){return addProductsQ3();}
        else{return addProductsQ4();}*/
        System.debug('############### check quarter 1 called fiscalYearValueQ1:' + fiscalYearValueQ1);
        
         if(fiscalYearValueQ1.contains('Q1')){return addProductsToQueue(fiscalYearQ1, 'Q1');}
        else if(fiscalYearValueQ1.contains('Q2')){return addProductsToQueue(fiscalYearQ1, 'Q2');}
        else if(fiscalYearValueQ1.contains('Q3')){return addProductsToQueue(fiscalYearQ1, 'Q3');}
        else{return addProductsToQueue(fiscalYearQ1, 'Q4');}
    }
    
    /*
     * @author: Cuauhtemoc Munoz
     * @date:   09/08/14
     * @email:  cmunoz@levementum.com
     * @description:    Redirects quarter calculation for Q2
     */
    public PageReference checkQuarterQ2()
    {
        /*if(fiscalYearValueQ2.contains('Q1')){return addProductsQ1();}
        else if(fiscalYearValueQ2.contains('Q2')){return addProductsQ2();}
        else if(fiscalYearValueQ2.contains('Q3')){return addProductsQ3();}
        else{return addProductsQ4();}*/

        if(fiscalYearValueQ2.contains('Q1')){return addProductsToQueue(fiscalYearQ2, 'Q1');}
        else if(fiscalYearValueQ2.contains('Q2')){return addProductsToQueue(fiscalYearQ2, 'Q2');}
        else if(fiscalYearValueQ2.contains('Q3')){return addProductsToQueue(fiscalYearQ2, 'Q3');}
        else{return addProductsToQueue(fiscalYearQ2, 'Q4');}
    }
    
    /*
     * @author: Cuauhtemoc Munoz
     * @date:   09/08/14
     * @email:  cmunoz@levementum.com
     * @description:    Redirects quarter calculation for Q3
     */
    public PageReference checkQuarterQ3()
    {
 /*       if(fiscalYearValueQ3.contains('Q1')){return addProductsQ1();}
        else if(fiscalYearValueQ3.contains('Q2')){return addProductsQ2();}
        else if(fiscalYearValueQ3.contains('Q3')){return addProductsQ3();}
        else{return addProductsQ4();}*/
        if(fiscalYearValueQ3.contains('Q1')){return addProductsToQueue(fiscalYearQ3, 'Q1');}
        else if(fiscalYearValueQ3.contains('Q2')){return addProductsToQueue(fiscalYearQ3, 'Q2');}
        else if(fiscalYearValueQ3.contains('Q3')){return addProductsToQueue(fiscalYearQ3, 'Q3');}
        else{return addProductsToQueue(fiscalYearQ3, 'Q4');}
    }
    
    /*
     * @author: Cuauhtemoc Munoz
     * @date:   09/08/14
     * @email:  cmunoz@levementum.com
     * @description:    Redirects quarter calculation for Q4
     */
    public PageReference checkQuarterQ4()
    {
       /* if(fiscalYearValueQ4.contains('Q1')){return addProductsQ1();}
        else if(fiscalYearValueQ4.contains('Q2')){return addProductsQ2();}
        else if(fiscalYearValueQ4.contains('Q3')){return addProductsQ3();}
        else{return addProductsQ4();}
*/
        if(fiscalYearValueQ4.contains('Q1')){return addProductsToQueue(fiscalYearQ4, 'Q1');}
        else if(fiscalYearValueQ4.contains('Q2')){return addProductsToQueue(fiscalYearQ4, 'Q2');}
        else if(fiscalYearValueQ4.contains('Q3')){return addProductsToQueue(fiscalYearQ4, 'Q3');}
        else{return addProductsToQueue(fiscalYearQ4, 'Q4');}
    }
    
    /** 
    * @author: jescamilla@levementum.com
    * @date: 9/24/14
    * @brief: Reroute to products to Queue Instead of creation.
    */
    public pageReference addProductsToQueue(Integer prodYear, String prodQuarter){

        System.debug('############### prodYear:' + prodYear);
        System.debug('############### prodQuarter:' + prodQuarter);
        List<PriceBookEntry> pbes = new List<PriceBookEntry>();
        
        Set<Id> selectedId = new Set<Id>();
        if(!string.isEmpty(selectedIdString)){
            if(selectedIdString.contains(',')){
                for(string s : selectedIdString.split(',')){
                    selectedId.add((ID)s);
                }
            }
            else{
                selectedId.add((ID)selectedIdString);
            }
            system.debug('selectedId='+selectedId);
            }else{
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please Select a Product'));
                //errorMsg =' Please Select a Product';
                return null;
            }

            //CHECK FOR DUPLICATES IN QUEUE
            for(ProductQueueWrapper pqw : productsQueue){
                if(selectedId.contains(pqw.pbe.product2Id) && pqw.year == prodYear && pqw.quarter == prodQuarter){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Your selection contains a duplicate item, please try again.'));
                    return null;
                }
            }


    
            pbes = [select 
            id, 
            product2Id, 
            product2.Name, 
            product2.ProductCode, 
            product2.Project__c, 
            product2.Program__c,
            product2.Family, 
            product2.Business_Unit__c, 
            UnitPrice 
            FROM PriceBookEntry WHERE product2ID = :selectedId and CurrencyIsoCode = :thisQuote.Opportunity.CurrencyIsoCode];

            //CHECK FOR DUPLICATES IN THE DEAL
            for(QuoteLineItem qli : [Select Id, Name__c, Year__c, Quarter__c, PricebookEntryId  From QuoteLineItem Where QuoteId = : thisQuote.Id]){
                for(PriceBookEntry pbe : pbes){
                    if(qli.PricebookEntryId == pbe.Id && qli.Year__c == String.valueOf(prodYear) && qli.Quarter__c == prodQuarter){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, 'The Deal Already Contains: ' + qli.Name__c + ' Remove and Try Again. '));
                        return null;
                    }
                }
            }

       /* if(Test.isRunningTest()){ //Get 3 available PBEs
           pbes = [select 
           id, 
           product2Id, 
           product2.Name, 
           product2.ProductCode, 
           product2.Project__c, 
           product2.Program__c,
           product2.Family, 
           product2.Business_Unit__c, 
           UnitPrice 
           FROM PriceBookEntry 
           WHERE isActive = true Limit 3];

           System.debug('############### pbes:' + pbes);

       } */

       for(PriceBookEntry pbe : pbes){
           productsQueue.add(new ProductQueueWrapper(pbe, prodYear, prodQuarter));
       }
        
        //cmunoz@levementum.com. 10/09/14. Removes duplicate from Products Queue
        //removeDuplicateProduct();

        System.debug('############### productsQueue:' + productsQueue);
        

       return null;
            }
    /**
    * @author: jescamilla@levementum.com
    * @date: 9/24/14
    * @brief: Remove Products from Queue
    */
    public pageReference removeProductsFromQueue(){
        try
        {
            Integer c = 0;
            while(c < productsQueue.size()){
                if(productsQueue[c].remove){
                    productsQueue.remove(c);
                }else{
                    c++;
                }
            }
        }
        catch(Exception ex)
        {
            system.debug(ex.getMessage());
        }
        return null;
    }
    /**
    * @author: jescamilla@levementum.com
    * @date: 9/24/14
    * @brief: Add Queued products to the Deal. productsQueue is the list that holds the queue.
    */
    public pageReference createLineItemsFromQueue(){
        //Validate we have products to add.
        try
        {
            if(productsQueue.size() <= 0)
            {
                //errorMsg =' Please Select a Product';
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR,'Please Select a Product'));
                 return null; 
            }
            List<QuoteLineItem> items = new List<QuoteLineItem>();
            String nonSelectedProductsMessage = 'The following item(s) already exist(s): '+ ' <br/>';
            //getAvailableProductOptions();
            Boolean duplicateProducts = false;
            for(ProductQueueWrapper pqw : productsQueue)
            {
                // cmunoz@levementum.com. 10/07/14. Checks wheter a product already exists. If so, provide error message to user.
                if(pqw.year != null && pqw.quarter != null)
                {
                    if(selectedProductsForQueue.get(pqw.pbe.product2Id+'-'+pqw.year+'-'+pqw.quarter) != null)
                    {
                        String[] splitter = selectedProductsForQueue.get(pqw.pbe.product2Id+'-'+pqw.year+'-'+pqw.quarter).split('-');
                        system.debug('splitter ' + splitter);
                        if(splitter.size() >= 3)
                        {
                            if(splitter[1] == String.valueOf(pqw.year) && splitter[2] == pqw.quarter)
                            {
                                duplicateProducts = true;
                                nonSelectedProductsMessage += pqw.pbe.Product2.Name + ' ' + pqw.quarter + ' ' + String.valueOf(pqw.year) + '<br/>'; 
                                continue;                   
                            }
                        }
                    }
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Year and/or Quarter not available for product ' + pqw.pbe.Product2.Name));
                    //throw new Exception('Year and/or Quarter not available for product ' + pqw.pbe.Product2.Name);
                    pageReference goEditMode = ApexPages.currentPage();
                    ApexPages.currentPage().getParameters().put('vfpEditMode','true'); 
                     ApexPages.currentPage().getParameters().put('qId', thisQuote.Id); //cmunoz@levementum.com.10/09/14. qid is lost on refresh. Added back here.
                    goEditMode.setRedirect(true);
                    return goEditMode;
                }
                
                QuoteLineItem cwv = new QuoteLineItem();
                QuoteLineItem por = new QuoteLineItem();
                //Add for other column, modified by qucw@lenovo.com    16 jun 2015
                QuoteLineItem oth = new QuoteLineItem();
                cwv.Deal_Type__c = 'Proposal';
                POR.Deal_Type__c = 'Plan';
                //Add for other column, modified by qucw@lenovo.com    16 jun 2015
                oth.Deal_Type__c = 'Other';
                
                cwv.Product2ID = pqw.pbe.product2Id;
                cwv.QuoteId = thisQuote.Id;
                cwv.Quarter__c = pqw.quarter;
                cwv.Quantity = 1;
                cwv.UnitPrice = 0;
                cwv.PricebookEntryId = pqw.pbe.Id;
                cwv.Approval_Status__c = 'Pending';
                cwv.Year__c = String.valueOf(pqw.year);
                items.add(cwv);
                por.QuoteId = thisQuote.Id;
                por.Product2ID = pqw.pbe.product2Id;
                por.Quarter__c = pqw.quarter;
                por.Quantity = 1;
                por.UnitPrice = 0;
                por.PricebookEntryId = pqw.pbe.Id;
                por.Approval_Status__c = 'Not Submitted';
                por.Year__c = String.valueOf(pqw.year);
                items.add(por);
                //Add for other column, modified by qucw@lenovo.com    16 jun 2015
                oth.QuoteId = thisQuote.Id;
                oth.Product2ID = pqw.pbe.product2Id;
                oth.Quarter__c = pqw.quarter;
                oth.Quantity = 1;
                oth.UnitPrice = 0;
                oth.PricebookEntryId = pqw.pbe.Id;
                oth.Approval_Status__c = 'Not Submitted';
                oth.Year__c = String.valueOf(pqw.year);
                items.add(oth);
            }
            if(duplicateProducts)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, nonSelectedProductsMessage + '<br/> Please remove conflicting products and try again.'));
                return null;
            }
            insert items;
            QuoteLineItem qliFromDB = [select name__c from QuoteLineItem where id = :items[0].id limit 1];
            //selectedOptions.add(new selectOption(qliFromDB.Name__c,qliFromDB.Name__c));
            //getProducts();
            getAvailableProductOptions(); // jescamilla@levementum.com 9/24/14 Description: Refresh the available products list.
             productsQueue = new List<ProductQueueWrapper>(); //Clear the Queue after products have been added.
            }
        catch(Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            system.debug('Error creating quote line items: ' + ex.getMessage());
            pageReference goEditMode = ApexPages.currentPage();
            ApexPages.currentPage().getParameters().put('vfpEditMode','true'); 
             ApexPages.currentPage().getParameters().put('qId', thisQuote.Id);//cmunoz@levementum.com.10/09/14. qid is lost on refresh. Added back here.
            goEditMode.setRedirect(true);
            return goEditMode;
        }

        pageReference goEditMode = ApexPages.currentPage();
        ApexPages.currentPage().getParameters().put('vfpEditMode','true'); 
         ApexPages.currentPage().getParameters().put('qId', thisQuote.Id);//cmunoz@levementum.com.10/09/14. qid is lost on refresh. Added back here.
        goEditMode.setRedirect(true);
        return goEditMode;
    }
    
    //!!!!!DEPRECATED!!!!! jescamilla@levementum.com 9/24/14 Description: THIS FUNCTION IS DEPRECATED DO NOT USE.
    //public void createLineItems(List<Id> prodIds, Integer quater){
    //    try
    //    {
    //    if(prodIds.size() <= 0)
    //    {
    //        errorMsg =' Please Select a Product';
    //        return;
    //    }
        
    //    List<QuoteLineItem> items = new List<QuoteLineItem>();
    //    List<PriceBookEntry> pbes = [select id, product2Id from PriceBookEntry where product2ID = :prodIds and CurrencyIsoCode = :thisQuote.Opportunity.CurrencyIsoCode];
    //    Map<Id, Id> mapPbe = new Map<Id, Id>();
    //    for(PriceBookEntry pbe : pbes){
    //        //Store a map with product Id matching to correct PriceBook entry Id
    //        mapPbe.put(pbe.product2Id, pbe.Id);
    //    }
    //    for(Id prodId : prodIds){
    //        QuoteLineItem cwv = new QuoteLineItem();
    //        QuoteLineItem por = new QuoteLineItem();
            
    //        cwv.Deal_Type__c = 'Proposal';
    //        POR.Deal_Type__c = 'Plan';
            
    //        cwv.Product2ID = prodId;
    //        cwv.QuoteId = thisQuote.Id;
    //        cwv.Quarter__c = 'Q' + quater;
    //        cwv.Quantity = 1;
    //        cwv.UnitPrice = 0;
    //        cwv.PricebookEntryId = mapPbe.get(prodId);
    //        cwv.Approval_Status__c = 'Pending';
    //        cwv.Year__c = String.valueOf(Date.today().year()); /* Cuauhtemoc Munoz 09/08/14 */
    //        items.add(cwv);
            
            
    //        por.QuoteId = thisQuote.Id;
    //        por.Product2ID = prodId;
    //        por.Quarter__c = 'Q' + quater;
    //        por.Quantity = 1;
    //        por.UnitPrice = 0;
    //        por.PricebookEntryId = mapPbe.get(prodId);
    //        por.Approval_Status__c = 'Not Submitted';
    //        por.Year__c = String.valueOf(Date.today().year()); /* Cuauhtemoc Munoz 09/08/14 */
    //        items.add(por);
    //    }
    //    insert items;
    //    QuoteLineItem qliFromDB = [select name__c from QuoteLineItem where id = :items[0].id limit 1];
    //    selectedOptions.add(new selectOption(qliFromDB.Name__c,qliFromDB.Name__c));
    //    getProducts();
    //    }
    //    catch(Exception ex)
    //    {
    //        system.debug(ex.getMessage());
    //    }
    //}
    
    // jescamilla@levementum.com 10-2-2014 Description: Re-Engineered to use Year AND Quarter Values to Sort the Items in the VFP.
    //jgarcia@levementum.com 9/22/2014. Method to sort by quarter name
    public Map<String, String> sortedTotalColumnValues {get; set;}
    public Map<String, String> cleanMap {get; set;}
    public List<String> keySetList {get; set;}
    public List<String> sortQuoteLineItems(List<QuoteLineItem> qLineItems)
    {
        try
        {
            keySetList = new List<String>();
            sortedTotalColumnValues = new Map<String, String>();
            List<String> products = new List<String>();
            List<String> sortedNames = new List<String>();
            List<Integer> qliYears = new List<Integer>(); //Lists to Sort.
            List<String> qliQuarters = new List<String>();
            Set<Integer> qliYearsSet = new Set<Integer>(); //Sets to check if the value exists.
            Set<String> qliQuartersSet = new Set<String>();

            for(QuoteLineItem qli: qLineItems)
            {
                // We only need one item, evern deal is going to have 2 products of the same brand one for CWV and one for POR we just need the Year and Quarter so we ignore one of the two.
               if(!qliYearsSet.contains(Integer.valueOf(qli.Year__c))){
                   qliYears.add(Integer.valueOf(qli.Year__c));
                   qliYearsSet.add(Integer.valueOf(qli.Year__c));

               }
                if(!qliQuartersSet.contains(qli.Quarter__c)){
                    qliQuarters.add(qli.Quarter__c);
                    qliQuartersSet.add(qli.Quarter__c);
                }
                
            }

            //Use the previously sorter years and quarters to provide the sortedNames list and minimize code change impact.
            //TODO: What happens if the user adds ProductX-Q4 (2014) AND ProductX-Q4 (2015) how is this algorithm going to know which one comes first?
            qliYears.sort(); qliQuarters.sort();

            Integer i = 0;
            for(Integer qliYear : qliYears){
                for(String qliQuarter : qliQuarters){
                    for(QuoteLineItem qli: qLineItems){
                        if(qli.Year__c == String.valueOf(qliYear) && qli.Quarter__c == qliQuarter && qli.Deal_Type__c == 'Proposal'){
                                sortedNames.add(qli.Name__c);
                        }
                        if(sortedTotalColumnValues.get(qli.Year__c + '-' + i) == null)
                        {
                            sortedTotalColumnValues.put(qli.Year__c  + '-' + i, qli.Quarter__c);
                        }
                       i++;
                    }
                }
            }
            
            Set<String> nonDuplicates = new Set<String>();
            for(String str: sortedTotalColumnValues.keySet())
            {
                if(sortedTotalColumnValues.get(str) != null)
                {
                    String key = str.substring(0, str.indexOf('-'));
                    String val = sortedTotalColumnValues.get(str);
                    system.debug(val);
                    nonDuplicates.add(key + '-' + val);
                }
            }
            
            system.debug('?? ' + nonDuplicates);
            cleanMap = new Map<String, String>();
            Integer counter = 0;
            for(String str: nonDuplicates)
            {
                String[] splitter = str.split('-');
                if(splitter.size() >= 2)
                { 
                    cleanMap.put(splitter[0] + '-'+ splitter[1], splitter[1]);
                    counter++;
                }
            }
            
            system.debug('??? ' + cleanMap);
            keySetList.addAll(cleanMap.keySet());
            keySetList.sort();
            
            return sortedNames;
        }catch(Exception ex){ 
            system.debug(ex.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getMessage()));

        }
        return null;
    }
    
    //TODO: Write Comment.
    public String removeQuarterFromName(String name)
    {
        try
        {
            return name.replaceAll('- Q1', '').replaceAll('- Q2', '').replaceAll('- Q3', '').replaceAll('- Q4', '');
        }
        catch(exception ex)
        {
            return '';
        }
    }
    
    /**
     * @author: Cuauhtemoc Munoz
     * @date: 09/24/14
     * @email: cmunoz@levementum.com
     * @description: Add fiscal year to cwv and por line item columns
     */
    public String getProductFiscalYear(String quarter)
    {
        String quarterVal = 'NA';
        try
        {
            if(fiscalYearValueQ1.contains(quarter)){return fiscalYearValueQ1.substring(fiscalYearValueQ1.indexOf(quarter)+3);}
            else if(fiscalYearValueQ2.contains(quarter)){return fiscalYearValueQ2.substring(fiscalYearValueQ2.indexOf(quarter)+3);}
            else if(fiscalYearValueQ3.contains(quarter)){return fiscalYearValueQ3.substring(fiscalYearValueQ3.indexOf(quarter)+3);}
            else if(fiscalYearValueQ4.contains(quarter)){return fiscalYearValueQ4.substring(fiscalYearValueQ4.indexOf(quarter)+3);}
            else{return quarterVal;}
        }
        catch(Exception ex)
        {
            return quarterVal;
        }
        return quarterVal;
    }

    public void getProducts()
    {
        /*
         * @author: Cuauhtemoc Munoz
         * @date:   09/08/14
         * @email:  cmunoz@levementum.com
         * @description:    Added try-catch statement to avoid errors when clicking on the "View Deal products" button with no products selected.
         */
        try
        {
            if(selectedOptions.size() < = 0)
            {
                listEmpty = true;
                return;
            }
            listEmpty = false;
            Set<String> quoteNames = new Set<String>();
            for(selectOption so : selectedOptions){
                quoteNames.add(so.getValue());
            }
            system.debug('quoteNames='+quoteNames);
            
             cols = new List<lineItemCol>();
           lineItemsByQuoteId = new Map<String,List<QuoteLineItem>>();
           List<QuoteLineItem> lineItemsByQuoteName = new List<QuoteLineItem>([select id, quoteId,quarter__c, Year__c, name__c,Discount_total__c,Fees__c,GM__c,CM__c,Motoagents__c,Contribution_Margin__c,AP__c,Gross_Margin__c,Negotiation_Buffer__c,NSAD__c,TC__c,QP__c,Total_NSBD__c,
                                     Total_CM__c,Units__c,Total_Fees__c,Total_Contribution_Margin__c,Total_Motoagents__c,Total_A_P__c,Total_GM__c,Total_Gross_Margin__c,Total_Negotiation_Buffer__c,Total_TDF__c,
                                     Total_ILW__c,Total_QP__c,Total_TC__c,Total_CSAT__c,Total_SVM__c,Total_National_Retail__c,Total_IPP__c,Total_NSAD__c,Total_Aggregate_Discounts__c,Total_COOP__c,Total_iMDF__c,InvoicePrice__c,Total_MDF__c,
                                     ILW__c,MCPU__c,TDF__c,COOP__c,CSAT__c,MDF__c,iMDF__c,SVM__c,IPP__c,National_Retail__c, Deal_Type__c,Approval_Status__c,NSBD__c,MinimumCommitQuantity__c,Total_SDF__c,SDF__c, NSBDComment__c,
                                     coopComment__c, negotiationBufferComment__c, feesComment__c, tdfComment__c, ilwComment__c, tcComment__c, qpComment__c, csatComment__c, nationalRetailComment__c, 
                                     ippComment__c, svmComment__c, imdfComment__c, mdfComment__c, discountComment__c, nsadComment__c,  mcpuComment__c, minimumCommitOpComment__c,Total_Discounts__c,
                                     nsbdOpComment__c, sdfOpComment__c, coopOpComment__c, mdfOpComment__c, imdfOpComment__c, svmOpComment__c, ippOpComment__c, nationalRetailOpComment__c,
                                     csatOpComment__c, qpOpComment__c, tcOpComment__c, ilwOpComment__c, tdfOpComment__c, feesOpComment__c, negotiationBufferOpComment__c, invoicePriceCommentU__c, Actual_Selling_Price_ASP__c,sdfComment__c
                                     from quoteLineItem where name__c in :quoteNames AND QuoteId = :thisQuote.Id ORDER BY Name__c]);

         /*   if(Test.isRunningTest())
            {
                lineItemsByQuoteName = new List<QuoteLineItem>([select id, quoteId,quarter__c, Year__c, name__c,Discount_total__c,Fees__c,GM__c,CM__c,Motoagents__c,Contribution_Margin__c,AP__c,Gross_Margin__c,Negotiation_Buffer__c,NSAD__c,TC__c,QP__c,Total_NSBD__c,
                                     Total_CM__c,Units__c,Total_Fees__c,Total_Contribution_Margin__c,Total_Motoagents__c,Total_A_P__c,Total_GM__c,Total_Gross_Margin__c,Total_Negotiation_Buffer__c,Total_TDF__c,
                                     Total_ILW__c,Total_QP__c,Total_TC__c,Total_CSAT__c,Total_SVM__c,Total_National_Retail__c,Total_IPP__c,Total_NSAD__c,Total_Aggregate_Discounts__c,Total_COOP__c,Total_iMDF__c,InvoicePrice__c,Total_MDF__c,
                                     ILW__c,MCPU__c,TDF__c,COOP__c,CSAT__c,MDF__c,iMDF__c,SVM__c,IPP__c,National_Retail__c, Deal_Type__c,Approval_Status__c,NSBD__c,MinimumCommitQuantity__c,Total_SDF__c,SDF__c, NSBDComment__c,
                                     coopComment__c, negotiationBufferComment__c, feesComment__c, tdfComment__c, ilwComment__c, tcComment__c, qpComment__c, csatComment__c, nationalRetailComment__c, 
                                     ippComment__c, svmComment__c, imdfComment__c, mdfComment__c, discountComment__c, nsadComment__c,  mcpuComment__c, minimumCommitOpComment__c,Total_Discounts__c,
                                     nsbdOpComment__c, sdfOpComment__c, coopOpComment__c, mdfOpComment__c, imdfOpComment__c, svmOpComment__c, ippOpComment__c, nationalRetailOpComment__c,
                                     csatOpComment__c, qpOpComment__c, tcOpComment__c, ilwOpComment__c, tdfOpComment__c, feesOpComment__c, negotiationBufferOpComment__c, invoicePriceCommentU__c, Actual_Selling_Price_ASP__c,sdfComment__c
                                     from quoteLineItem where name__c in :quoteNames AND QuoteId = :thisQuote.Id ORDER BY Name__c]);
            } */

            for(QuoteLineItem qli : lineItemsByQuoteName){
                if(lineItemsByQuoteId.containsKey(qli.Name__c)){
                    lineItemsByQuoteId.get(qli.Name__c).add(qli);
                }   
                else{
                    lineItemsByQuoteId.put(qli.Name__c,new List<QuoteLineItem>{qli});
                }
            }
            system.debug('lineItemsByQuoteId='+lineItemsByQuoteName);
            lineItemColumns = new List<lineItemCol>();
            lineItemCount = 0;
            totalItemCount = 0;

            List<String> sortedNames = sortQuoteLineItems(lineItemsByQuoteName);

            for(String name : sortedNames){
                lineItemCol col = new lineItemCol();
                for(QuoteLineItem qli : lineItemsByQuoteId.get(name)){
                    if(qli.Deal_Type__c == 'Plan'){
                        col.porLineItem = qli;
                        col.name = removeQuarterFromName(qli.name__c);
                        col.quarter = qli.quarter__c;
                        col.Year = getProductFiscalYear(col.quarter);
                        
                        //Cody Sechelski 10/23/2014 added code to populate new properties
                        col.quarterNumber = integer.valueOf(col.quarter.replace('Q',''));
                        col.yearNumber = integer.valueOf(col.year);
                        col.sortingExpresion = integer.valueOf(string.valueOf(col.yearNumber) + string.valueOf(col.quarterNumber));
                    }
                    else if(qli.Deal_Type__c == 'Proposal' && qli.Approval_Status__c == 'Pending'){
                        col.cwvLineItem = qli; 
                        col.name = removeQuarterFromName(qli.name__c);
                        col.quarter = qli.quarter__c; 
                        col.Year = getProductFiscalYear(col.quarter);
                        
                        //Cody Sechelski 10/23/2014 added code to populate new properties
                        col.quarterNumber = integer.valueOf(col.quarter.replace('Q',''));
                        col.yearNumber = integer.valueOf(col.year);
                        col.sortingExpresion = integer.valueOf(string.valueOf(col.yearNumber) + string.valueOf(col.quarterNumber));
                    }else if(qli.Deal_Type__c == 'Other'){
                        col.othLineItem = qli; 
                        col.name = removeQuarterFromName(qli.name__c);
                        col.quarter = qli.quarter__c; 
                        col.Year = getProductFiscalYear(col.quarter);
                        
                        //Cody Sechelski 10/23/2014 added code to populate new properties
                        col.quarterNumber = integer.valueOf(col.quarter.replace('Q',''));
                        col.yearNumber = integer.valueOf(col.year);
                        col.sortingExpresion = integer.valueOf(string.valueOf(col.yearNumber) + string.valueOf(col.quarterNumber));
                    }
                    
                    /**
                     * BEGINS CHANGE
                     * @email:  cmunoz@levementum.com
                     * @date:   09/02/14
                     * @brief:  Gets newly added comment field values from database and store them in their respective text fields under the "Per Unit" section
                     */
                    col.commentField = qli.NSBDComment__c;
                    col.coopCommentField = qli.coopComment__c;
                    col.negotiationBufferCommentField = qli.negotiationBufferComment__c;
                    col.feesCommentField = qli.feesComment__c;
                    col.tdfCommentField = qli.tdfComment__c;
                    col.ilwCommentField = qli.ilwComment__c;
                    col.tcCommentField = qli.tcComment__c;
                    col.qpCommentField = qli.qpComment__c;
                    col.csatCommentField = qli.csatComment__c;
                    col.nationalRetailCommentField = qli.nationalRetailComment__c;
                    col.ippCommentField = qli.ippComment__c;
                    col.svmCommentField = qli.svmComment__c;
                    col.imdfCommentField = qli.imdfComment__c;
                    col.mdfCommentField = qli.mdfComment__c;
                    col.discountCommentField = qli.discountComment__c;
                    col.nsadCommentField = qli.nsadComment__c;
                    col.mcpuCommentField = qli.mcpuComment__c;
                    col.invoiceCommentField = qli.invoicePriceCommentU__c;
                    col.sdfCommentField = qli.sdfComment__c;
                    /* ENDS CHANGE */
                    
                    /**
                     * BEGINS CHANGE
                     * @email:  cmunoz@levementum.com
                     * @date:   09/03/14
                     * @brief:  Gets newly added comment field values from database and store them in their respective text fields under the "Operator/Retail" section
                     */
                    col.minimumCommitOpCommentField = qli.minimumCommitOpComment__c;
                    col.nsbdOpCommentField = qli.nsbdOpComment__c;
                    col.sdfOpCommentField = qli.sdfOpComment__c;
                    col.coopOpCommentField = qli.coopOpComment__c;
                    col.mdfOpCommentField = qli.mdfOpComment__c;
                    col.imdfOpCommentField = qli.imdfOpComment__c;
                    col.svmOpCommentField = qli.svmOpComment__c;
                    col.ippOpCommentField = qli.ippOpComment__c;
                    col.nationalRetailOpCommentField = qli.nationalRetailOpComment__c;
                    col.csatOpCommentField = qli.csatOpComment__c;
                    col.qpOpCommentField = qli.qpOpComment__c;
                    col.tcOpCommentField = qli.tcOpComment__c;
                    col.ilwOpCommentField = qli.ilwOpComment__c;
                    col.tdfOpCommentField = qli.tdfOpComment__c;
                    col.feesOpCommentField = qli.feesOpComment__c;
                    col.negotiationBufferOpCommentField = qli.negotiationBufferOpComment__c;                                 
                    /* ENDS CHANGE */
                    
                }
                
                lineItemColumns.add(col);
                    lineItemCount++;
            }
            system.debug('lineItemCount='+lineItemCount);  
            
            //calculate the total columns for the details tab
            Map<Integer,totalCol> totalColumnsMap = new Map<Integer,totalCol>();
            for(lineItemCol col : lineItemColumns){
                if(col.cwvLineItem.MCPU__c == null){col.cwvLineItem.MCPU__c = 0;}
                if(col.cwvLineItem.COOP__c == null){col.cwvLineItem.COOP__c = 0;}
                if(col.cwvLineItem.MDF__c == null){col.cwvLineItem.MDF__c = 0;}
                if(col.cwvLineItem.iMDF__c == null){col.cwvLineItem.iMDF__c = 0;}
                if(col.cwvLineItem.SVM__c == null){col.cwvLineItem.SVM__c = 0;}
                if(col.cwvLineItem.IPP__c == null){col.cwvLineItem.IPP__c = 0;}
                if(col.cwvLineItem.National_Retail__c == null){col.cwvLineItem.National_Retail__c = 0;}
                if(col.cwvLineItem.CSAT__c == null){col.cwvLineItem.CSAT__c = 0;}
                if(col.cwvLineItem.QP__c == null){col.cwvLineItem.QP__c = 0;}
                if(col.cwvLineItem.TC__c == null){col.cwvLineItem.TC__c = 0;}
                if(col.cwvLineItem.TDF__c == null){col.cwvLineItem.TDF__c = 0;}
                if(col.cwvLineItem.ILW__c == null){col.cwvLineItem.ILW__c = 0;}
                if(col.cwvLineItem.Fees__c == null){col.cwvLineItem.Fees__c = 0;}
                if(col.cwvLineItem.Negotiation_Buffer__c == null){col.cwvLineItem.Negotiation_Buffer__c = 0;}
                if(col.cwvLineItem.Motoagents__c == null){col.cwvLineItem.Motoagents__c = 0;}
                if(col.cwvLineItem.Units__c == null){col.cwvLineItem.Units__c = 0;}
                if(col.cwvLineItem.MinimumCommitQuantity__c == null){col.cwvLineItem.MinimumCommitQuantity__c = 0;}
                if(col.cwvLineItem.SDF__c == null){col.cwvLineItem.SDF__c = 0;}
                if(col.cwvLineItem.InvoicePrice__c == null){col.cwvLineItem.InvoicePrice__c = 0;} 
                if(col.cwvLineItem.AP__c == null){col.cwvLineItem.AP__c = 0;}
                
                if(col.porLineItem.MCPU__c == null){col.porLineItem.MCPU__c = 0;}
                if(col.porLineItem.COOP__c == null){col.porLineItem.COOP__c = 0;}
                if(col.porLineItem.MDF__c == null){col.porLineItem.MDF__c = 0;}
                if(col.porLineItem.iMDF__c == null){col.porLineItem.iMDF__c = 0;}
                if(col.porLineItem.SVM__c == null){col.porLineItem.SVM__c = 0;}
                if(col.porLineItem.IPP__c == null){col.porLineItem.IPP__c = 0;}
                if(col.porLineItem.National_Retail__c == null){col.porLineItem.National_Retail__c = 0;}
                if(col.porLineItem.CSAT__c == null){col.porLineItem.CSAT__c = 0;}
                if(col.porLineItem.QP__c == null){col.porLineItem.QP__c = 0;}
                if(col.porLineItem.TC__c == null){col.porLineItem.TC__c = 0;}
                if(col.porLineItem.TDF__c == null){col.porLineItem.TDF__c = 0;}
                if(col.porLineItem.ILW__c == null){col.porLineItem.ILW__c = 0;}
                if(col.porLineItem.Fees__c == null){col.porLineItem.Fees__c = 0;}
                if(col.porLineItem.Negotiation_Buffer__c == null){col.porLineItem.Negotiation_Buffer__c = 0;}
                if(col.porLineItem.Motoagents__c == null){col.porLineItem.Motoagents__c = 0;}
                if(col.porLineItem.Units__c == null){col.porLineItem.Units__c = 0;}
                if(col.porLineItem.MinimumCommitQuantity__c == null){col.porLineItem.MinimumCommitQuantity__c = 0;}
                if(col.porLineItem.SDF__c == null){col.porLineItem.SDF__c = 0;}
                if(col.porLineItem.InvoicePrice__c == null){col.porLineItem.InvoicePrice__c = 0;}
                if(col.porLineItem.AP__c == null){col.porLineItem.AP__c = 0;}

                //add for other column, modified by qucw@lenovo.com    16 jun 2015
                if(col.othLineItem.MCPU__c == null){col.othLineItem.MCPU__c = 0;}
                if(col.othLineItem.COOP__c == null){col.othLineItem.COOP__c = 0;}
                if(col.othLineItem.MDF__c == null){col.othLineItem.MDF__c = 0;}
                if(col.othLineItem.iMDF__c == null){col.othLineItem.iMDF__c = 0;}
                if(col.othLineItem.SVM__c == null){col.othLineItem.SVM__c = 0;}
                if(col.othLineItem.IPP__c == null){col.othLineItem.IPP__c = 0;}
                if(col.othLineItem.National_Retail__c == null){col.othLineItem.National_Retail__c = 0;}
                if(col.othLineItem.CSAT__c == null){col.othLineItem.CSAT__c = 0;}
                if(col.othLineItem.QP__c == null){col.othLineItem.QP__c = 0;}
                if(col.othLineItem.TC__c == null){col.othLineItem.TC__c = 0;}
                if(col.othLineItem.TDF__c == null){col.othLineItem.TDF__c = 0;}
                if(col.othLineItem.ILW__c == null){col.othLineItem.ILW__c = 0;}
                if(col.othLineItem.Fees__c == null){col.othLineItem.Fees__c = 0;}
                if(col.othLineItem.Negotiation_Buffer__c == null){col.othLineItem.Negotiation_Buffer__c = 0;}
                if(col.othLineItem.Motoagents__c == null){col.othLineItem.Motoagents__c = 0;}
                if(col.othLineItem.Units__c == null){col.othLineItem.Units__c = 0;}
                if(col.othLineItem.MinimumCommitQuantity__c == null){col.othLineItem.MinimumCommitQuantity__c = 0;}
                if(col.othLineItem.SDF__c == null){col.othLineItem.SDF__c = 0;}
                if(col.othLineItem.InvoicePrice__c == null){col.othLineItem.InvoicePrice__c = 0;}
                if(col.othLineItem.AP__c == null){col.othLineItem.AP__c = 0;}
                
                if(totalColumnsMap.containsKey(col.sortingExpresion)){
                    totalCol tc = totalColumnsMap.get(col.sortingExpresion);
       
                    tc.cwvLineItem.nsbd += col.cwvLineItem.NSBD__c;
                    tc.cwvLineItem.discount += col.cwvLineItem.Discount_total__c;
                    tc.cwvLineItem.coop += col.cwvLineItem.COOP__c;
                    tc.cwvLineItem.mdf += col.cwvLineItem.MDF__c;
                    tc.cwvLineItem.imdf += col.cwvLineItem.iMDF__c;
                    tc.cwvLineItem.svm += col.cwvLineItem.SVM__c;
                    tc.cwvLineItem.ipp += col.cwvLineItem.IPP__c;
                    tc.cwvLineItem.nationalRetail += col.cwvLineItem.National_Retail__c;
                    tc.cwvLineItem.csat += col.cwvLineItem.CSAT__c;
                    tc.cwvLineItem.qp += col.cwvLineItem.QP__c;
                    tc.cwvLineItem.tc += col.cwvLineItem.TC__c;
                    tc.cwvLineItem.tdf += col.cwvLineItem.TDF__c;
                    tc.cwvLineItem.ilw += col.cwvLineItem.ILW__c;
                    tc.cwvLineItem.fees += col.cwvLineItem.Fees__c;
                    tc.cwvLineItem.negotiationBuffer += col.cwvLineItem.Negotiation_Buffer__c;
                    tc.cwvLineItem.nsad += col.cwvLineItem.NSAD__c;
                    tc.cwvLineItem.aspnsad += col.cwvLineItem.Actual_Selling_Price_ASP__c;
                    tc.cwvLineItem.grossMargin += col.cwvLineItem.Gross_Margin__c;
                    tc.cwvLineItem.gm += col.cwvLineItem.GM__c;
                    tc.cwvLineItem.aAndP += col.cwvLineItem.AP__c;
                    tc.cwvLineItem.motoagents += col.cwvLineItem.Motoagents__c;
                    tc.cwvLineItem.contributionMargin += col.cwvLineItem.Contribution_Margin__c;
                    tc.cwvLineItem.cm += col.cwvLineItem.CM__c;
                    tc.cwvLineItem.invoice += col.cwvLineItem.InvoicePrice__c;
                    tc.cwvLineItem.sdf += col.cwvLineItem.SDF__c;
                    tc.cwvLineItem.mcpu += col.cwvLineItem.MCPU__c;
                    
                    tc.porLineItem.nsbd += col.porLineItem.NSBD__c;
                    tc.porLineItem.discount += col.porLineItem.Discount_total__c;
                    tc.porLineItem.coop += col.porLineItem.COOP__c;
                    tc.porLineItem.mdf += col.porLineItem.MDF__c;
                    tc.porLineItem.imdf += col.porLineItem.iMDF__c;
                    tc.porLineItem.svm += col.porLineItem.SVM__c;
                    tc.porLineItem.ipp += col.porLineItem.IPP__c;
                    tc.porLineItem.nationalRetail += col.porLineItem.National_Retail__c;
                    tc.porLineItem.csat += col.porLineItem.CSAT__c;
                    tc.porLineItem.qp += col.porLineItem.QP__c;
                    tc.porLineItem.tc += col.porLineItem.TC__c;
                    tc.porLineItem.tdf += col.porLineItem.TDF__c;
                    tc.porLineItem.ilw += col.porLineItem.ILW__c;
                    tc.porLineItem.fees += col.porLineItem.Fees__c;
                    tc.porLineItem.negotiationBuffer += col.porLineItem.Negotiation_Buffer__c;
                    tc.porLineItem.nsad += col.porLineItem.NSAD__c;
                    tc.porLineItem.aspnsad += col.porLineItem.Actual_Selling_Price_ASP__c;
                    tc.porLineItem.grossMargin += col.porLineItem.Gross_Margin__c;
                    tc.porLineItem.gm += col.porLineItem.GM__c;
                    tc.porLineItem.aAndP += col.porLineItem.AP__c;
                    tc.porLineItem.motoagents += col.porLineItem.Motoagents__c;
                    tc.porLineItem.contributionMargin += col.porLineItem.Contribution_Margin__c;
                    tc.porLineItem.cm += col.porLineItem.CM__c;
                    tc.porLineItem.invoice += col.porLineItem.InvoicePrice__c;
                    tc.porLineItem.sdf += col.porLineItem.SDF__c;
                    tc.porLineItem.mcpu += col.porLineItem.MCPU__c;

                    //add for other column, modified by qucw@lenovo.com    16 jun 2015
                    tc.othLineItem.nsbd += col.othLineItem.NSBD__c;
                    tc.othLineItem.discount += col.othLineItem.Discount_total__c;
                    tc.othLineItem.coop += col.othLineItem.COOP__c;
                    tc.othLineItem.mdf += col.othLineItem.MDF__c;
                    tc.othLineItem.imdf += col.othLineItem.iMDF__c;
                    tc.othLineItem.svm += col.othLineItem.SVM__c;
                    tc.othLineItem.ipp += col.othLineItem.IPP__c;
                    tc.othLineItem.nationalRetail += col.othLineItem.National_Retail__c;
                    tc.othLineItem.csat += col.othLineItem.CSAT__c;
                    tc.othLineItem.qp += col.othLineItem.QP__c;
                    tc.othLineItem.tc += col.othLineItem.TC__c;
                    tc.othLineItem.tdf += col.othLineItem.TDF__c;
                    tc.othLineItem.ilw += col.othLineItem.ILW__c;
                    tc.othLineItem.fees += col.othLineItem.Fees__c;
                    tc.othLineItem.negotiationBuffer += col.othLineItem.Negotiation_Buffer__c;
                    tc.othLineItem.nsad += col.othLineItem.NSAD__c;
                    tc.othLineItem.aspnsad += col.othLineItem.Actual_Selling_Price_ASP__c;
                    tc.othLineItem.grossMargin += col.othLineItem.Gross_Margin__c;
                    tc.othLineItem.gm += col.othLineItem.GM__c;
                    tc.othLineItem.aAndP += col.othLineItem.AP__c;
                    tc.othLineItem.motoagents += col.othLineItem.Motoagents__c;
                    tc.othLineItem.contributionMargin += col.othLineItem.Contribution_Margin__c;
                    tc.othLineItem.cm += col.othLineItem.CM__c;
                    tc.othLineItem.invoice += col.othLineItem.InvoicePrice__c;
                    tc.othLineItem.sdf += col.othLineItem.SDF__c;
                    tc.othLineItem.mcpu += col.othLineItem.MCPU__c;


                    tc.TotalCwvLineItem.nsbd += col.cwvLineItem.Total_NSBD__c;
                    tc.TotalCwvLineItem.discount += col.cwvLineItem.Total_Aggregate_Discounts__c;
                    tc.TotalCwvLineItem.coop += col.cwvLineItem.Total_COOP__c;
                    tc.TotalCwvLineItem.mdf += col.cwvLineItem.Total_MDF__c;
                    tc.TotalCwvLineItem.imdf += col.cwvLineItem.Total_iMDF__c;
                    tc.TotalCwvLineItem.svm += col.cwvLineItem.Total_SVM__c;
                    tc.TotalCwvLineItem.ipp += col.cwvLineItem.Total_IPP__c;
                    tc.TotalCwvLineItem.nationalRetail += col.cwvLineItem.Total_National_Retail__c;
                    tc.TotalCwvLineItem.csat += col.cwvLineItem.Total_CSAT__c;
                    tc.TotalCwvLineItem.qp += col.cwvLineItem.Total_QP__c;
                    tc.TotalCwvLineItem.tc += col.cwvLineItem.Total_TC__c;
                    tc.TotalCwvLineItem.tdf += col.cwvLineItem.Total_TDF__c;
                    tc.TotalCwvLineItem.ilw += col.cwvLineItem.Total_ILW__c;
                    tc.TotalCwvLineItem.fees += col.cwvLineItem.Total_Fees__c;
                    tc.TotalCwvLineItem.negotiationBuffer += col.cwvLineItem.Total_Negotiation_Buffer__c;
                    tc.TotalCwvLineItem.nsad += col.cwvLineItem.Total_NSAD__c;
                    tc.TotalCwvLineItem.grossMargin += col.cwvLineItem.Total_Gross_Margin__c;
                    tc.TotalCwvLineItem.gm += col.cwvLineItem.Total_GM__c;
                    tc.TotalCwvLineItem.aAndP += col.cwvLineItem.Total_A_P__c;
                    tc.TotalCwvLineItem.motoagents += col.cwvLineItem.Total_Motoagents__c;
                    tc.TotalCwvLineItem.contributionMargin += col.cwvLineItem.Total_Contribution_Margin__c;
                    tc.TotalCwvLineItem.cm += col.cwvLineItem.Total_CM__c;
                    tc.TotalCwvLineItem.units += col.cwvLineItem.Units__c;
                    tc.TotalCwvLineItem.minCommit += col.cwvLineItem.MinimumCommitQuantity__c;
                    tc.TotalCwvLineItem.sdf += col.cwvLineItem.Total_SDF__c;
                    tc.TotalCwvLineItem.invoice += col.cwvLineItem.InvoicePrice__c;
                    
                    tc.TotalPorLineItem.nsbd += col.porLineItem.Total_NSBD__c;
                    tc.TotalPorLineItem.discount += col.porLineItem.Total_Aggregate_Discounts__c;
                    tc.TotalPorLineItem.coop += col.porLineItem.Total_COOP__c;
                    tc.TotalPorLineItem.mdf += col.porLineItem.Total_MDF__c;
                    tc.TotalPorLineItem.imdf += col.porLineItem.Total_iMDF__c;
                    tc.TotalPorLineItem.svm += col.porLineItem.Total_SVM__c;
                    tc.TotalPorLineItem.ipp += col.porLineItem.Total_IPP__c;
                    tc.TotalPorLineItem.nationalRetail += col.porLineItem.Total_National_Retail__c;
                    tc.TotalPorLineItem.csat += col.porLineItem.Total_CSAT__c;
                    tc.TotalPorLineItem.qp += col.porLineItem.Total_QP__c;
                    tc.TotalPorLineItem.tc += col.porLineItem.Total_TC__c;
                    tc.TotalPorLineItem.tdf += col.porLineItem.Total_TDF__c;
                    tc.TotalPorLineItem.ilw += col.porLineItem.Total_ILW__c;
                    tc.TotalPorLineItem.fees += col.porLineItem.Total_Fees__c;
                    tc.TotalPorLineItem.negotiationBuffer += col.porLineItem.Total_Negotiation_Buffer__c;
                    tc.TotalPorLineItem.nsad += col.porLineItem.Total_NSAD__c;
                    tc.TotalPorLineItem.grossMargin += col.porLineItem.Total_Gross_Margin__c;
                    tc.TotalPorLineItem.gm += col.porLineItem.Total_GM__c;
                    tc.TotalPorLineItem.aAndP += col.porLineItem.Total_A_P__c;
                    tc.TotalPorLineItem.motoagents += col.porLineItem.Total_Motoagents__c;
                    tc.TotalPorLineItem.contributionMargin += col.porLineItem.Total_Contribution_Margin__c;
                    tc.TotalPorLineItem.cm += col.porLineItem.Total_CM__c;
                    tc.TotalPorLineItem.units += col.porLineItem.Units__c;
                    tc.TotalPorLineItem.minCommit += col.porLineItem.MinimumCommitQuantity__c;
                    tc.TotalPorLineItem.sdf += col.porLineItem.Total_SDF__c;
                    tc.TotalPorLineItem.invoice += col.porLineItem.InvoicePrice__c;

                    //add for other column, modified by qucw@lenovo.com    16 jun 2015
                    tc.TotalothLineItem.nsbd += col.othLineItem.Total_NSBD__c;
                    tc.TotalothLineItem.discount += col.othLineItem.Total_Aggregate_Discounts__c;
                    tc.TotalothLineItem.coop += col.othLineItem.Total_COOP__c;
                    tc.TotalothLineItem.mdf += col.othLineItem.Total_MDF__c;
                    tc.TotalothLineItem.imdf += col.othLineItem.Total_iMDF__c;
                    tc.TotalothLineItem.svm += col.othLineItem.Total_SVM__c;
                    tc.TotalothLineItem.ipp += col.othLineItem.Total_IPP__c;
                    tc.TotalothLineItem.nationalRetail += col.othLineItem.Total_National_Retail__c;
                    tc.TotalothLineItem.csat += col.othLineItem.Total_CSAT__c;
                    tc.TotalothLineItem.qp += col.othLineItem.Total_QP__c;
                    tc.TotalothLineItem.tc += col.othLineItem.Total_TC__c;
                    tc.TotalothLineItem.tdf += col.othLineItem.Total_TDF__c;
                    tc.TotalothLineItem.ilw += col.othLineItem.Total_ILW__c;
                    tc.TotalothLineItem.fees += col.othLineItem.Total_Fees__c;
                    tc.TotalothLineItem.negotiationBuffer += col.othLineItem.Total_Negotiation_Buffer__c;
                    tc.TotalothLineItem.nsad += col.othLineItem.Total_NSAD__c;
                    tc.TotalothLineItem.grossMargin += col.othLineItem.Total_Gross_Margin__c;
                    tc.TotalothLineItem.gm += col.othLineItem.Total_GM__c;
                    tc.TotalothLineItem.aAndP += col.othLineItem.Total_A_P__c;
                    tc.TotalothLineItem.motoagents += col.othLineItem.Total_Motoagents__c;
                    tc.TotalothLineItem.contributionMargin += col.othLineItem.Total_Contribution_Margin__c;
                    tc.TotalothLineItem.cm += col.othLineItem.Total_CM__c;
                    tc.TotalothLineItem.units += col.othLineItem.Units__c;
                    tc.TotalothLineItem.minCommit += col.othLineItem.MinimumCommitQuantity__c;
                    tc.TotalothLineItem.sdf += col.othLineItem.Total_SDF__c;
                    tc.TotalothLineItem.invoice += col.othLineItem.InvoicePrice__c;
                    
                    totalColumnsMap.put(tc.sortingExpresion,tc);
                    system.debug('totalColumnsMap ' + totalColumnsMap);
                }
                else{
                    totalCol tc = new totalCol();
                    tc.quarter = col.quarter;
                    tc.quarterNumber = col.quarterNumber;
                    tc.year = col.yearNumber;
                    tc.sortingExpresion = col.sortingExpresion;
                    
                    tc.cwvLineItem = new totalColItem();
                    tc.cwvLineItem.nsbd = col.cwvLineItem.NSBD__c;
                    tc.cwvLineItem.discount = col.cwvLineItem.Discount_total__c;
                    tc.cwvLineItem.coop = col.cwvLineItem.COOP__c;
                    tc.cwvLineItem.mdf = col.cwvLineItem.MDF__c;
                    tc.cwvLineItem.imdf = col.cwvLineItem.iMDF__c;
                    tc.cwvLineItem.svm = col.cwvLineItem.SVM__c;
                    tc.cwvLineItem.ipp = col.cwvLineItem.IPP__c;
                    tc.cwvLineItem.nationalRetail = col.cwvLineItem.National_Retail__c;
                    tc.cwvLineItem.csat = col.cwvLineItem.CSAT__c;
                    tc.cwvLineItem.qp = col.cwvLineItem.QP__c;
                    tc.cwvLineItem.tc = col.cwvLineItem.TC__c;
                    tc.cwvLineItem.tdf = col.cwvLineItem.TDF__c;
                    tc.cwvLineItem.ilw = col.cwvLineItem.ILW__c;
                    tc.cwvLineItem.fees = col.cwvLineItem.Fees__c;
                    tc.cwvLineItem.negotiationBuffer = col.cwvLineItem.Negotiation_Buffer__c;
                    tc.cwvLineItem.nsad = col.cwvLineItem.NSAD__c;
                    tc.cwvLineItem.aspnsad = col.cwvLineItem.Actual_Selling_Price_ASP__c;
                    tc.cwvLineItem.grossMargin = col.cwvLineItem.Gross_Margin__c;
                    tc.cwvLineItem.gm = col.cwvLineItem.GM__c;
                    tc.cwvLineItem.aAndP = col.cwvLineItem.AP__c;
                    tc.cwvLineItem.motoagents = col.cwvLineItem.Motoagents__c;
                    tc.cwvLineItem.contributionMargin = col.cwvLineItem.Contribution_Margin__c;
                    tc.cwvLineItem.cm = col.cwvLineItem.CM__c;
                    tc.cwvLineItem.invoice = col.cwvLineItem.InvoicePrice__c;
                    tc.cwvLineItem.sdf += col.cwvLineItem.SDF__c;
                    tc.cwvLineItem.mcpu += col.cwvLineItem.MCPU__c;
                    
                    tc.porLineItem = new totalColItem();
                    tc.porLineItem.nsbd = col.porLineItem.NSBD__c;
                    tc.porLineItem.discount = col.porLineItem.Discount_total__c;
                    tc.porLineItem.coop = col.porLineItem.COOP__c;
                    tc.porLineItem.mdf = col.porLineItem.MDF__c;
                    tc.porLineItem.imdf = col.porLineItem.iMDF__c;
                    tc.porLineItem.svm = col.porLineItem.SVM__c;
                    tc.porLineItem.ipp = col.porLineItem.IPP__c;
                    tc.porLineItem.nationalRetail = col.porLineItem.National_Retail__c;
                    tc.porLineItem.csat = col.porLineItem.CSAT__c;
                    tc.porLineItem.qp = col.porLineItem.QP__c;
                    tc.porLineItem.tc = col.porLineItem.TC__c;
                    tc.porLineItem.tdf = col.porLineItem.TDF__c;
                    tc.porLineItem.ilw = col.porLineItem.ILW__c;
                    tc.porLineItem.fees = col.porLineItem.Fees__c;
                    tc.porLineItem.negotiationBuffer = col.porLineItem.Negotiation_Buffer__c;
                    tc.porLineItem.nsad = col.porLineItem.NSAD__c;
                    tc.porLineItem.aspnsad = col.porLineItem.Actual_Selling_Price_ASP__c;
                    tc.porLineItem.grossMargin = col.porLineItem.Gross_Margin__c;
                    tc.porLineItem.gm = col.porLineItem.GM__c;
                    tc.porLineItem.aAndP = col.porLineItem.AP__c;
                    tc.porLineItem.motoagents = col.porLineItem.Motoagents__c;
                    tc.porLineItem.contributionMargin = col.porLineItem.Contribution_Margin__c;
                    tc.porLineItem.cm = col.porLineItem.CM__c;
                    tc.porLineItem.invoice = col.porLineItem.InvoicePrice__c;
                    tc.porLineItem.sdf += col.porLineItem.SDF__c;
                    tc.porLineItem.mcpu += col.porLineItem.MCPU__c;

                    //add for other column, modified by qucw@lenovo.com    16 jun 2015
                    tc.othLineItem = new totalColItem();
                    tc.othLineItem.nsbd = col.othLineItem.NSBD__c;
                    tc.othLineItem.discount = col.othLineItem.Discount_total__c;
                    tc.othLineItem.coop = col.othLineItem.COOP__c;
                    tc.othLineItem.mdf = col.othLineItem.MDF__c;
                    tc.othLineItem.imdf = col.othLineItem.iMDF__c;
                    tc.othLineItem.svm = col.othLineItem.SVM__c;
                    tc.othLineItem.ipp = col.othLineItem.IPP__c;
                    tc.othLineItem.nationalRetail = col.othLineItem.National_Retail__c;
                    tc.othLineItem.csat = col.othLineItem.CSAT__c;
                    tc.othLineItem.qp = col.othLineItem.QP__c;
                    tc.othLineItem.tc = col.othLineItem.TC__c;
                    tc.othLineItem.tdf = col.othLineItem.TDF__c;
                    tc.othLineItem.ilw = col.othLineItem.ILW__c;
                    tc.othLineItem.fees = col.othLineItem.Fees__c;
                    tc.othLineItem.negotiationBuffer = col.othLineItem.Negotiation_Buffer__c;
                    tc.othLineItem.nsad = col.othLineItem.NSAD__c;
                    tc.othLineItem.aspnsad = col.othLineItem.Actual_Selling_Price_ASP__c;
                    tc.othLineItem.grossMargin = col.othLineItem.Gross_Margin__c;
                    tc.othLineItem.gm = col.othLineItem.GM__c;
                    tc.othLineItem.aAndP = col.othLineItem.AP__c;
                    tc.othLineItem.motoagents = col.othLineItem.Motoagents__c;
                    tc.othLineItem.contributionMargin = col.othLineItem.Contribution_Margin__c;
                    tc.othLineItem.cm = col.othLineItem.CM__c;
                    tc.othLineItem.invoice = col.othLineItem.InvoicePrice__c;
                    tc.othLineItem.sdf += col.othLineItem.SDF__c;
                    tc.othLineItem.mcpu += col.othLineItem.MCPU__c;

                    tc.TotalCwvLineItem = new totalColItem();
                    tc.TotalCwvLineItem.nsbd = col.cwvLineItem.Total_NSBD__c;
                    tc.TotalCwvLineItem.discount = col.cwvLineItem.Total_Aggregate_Discounts__c;
                    tc.TotalCwvLineItem.coop = col.cwvLineItem.Total_COOP__c;
                    tc.TotalCwvLineItem.mdf = col.cwvLineItem.Total_MDF__c;
                    tc.TotalCwvLineItem.imdf = col.cwvLineItem.Total_iMDF__c;
                    tc.TotalCwvLineItem.svm = col.cwvLineItem.Total_SVM__c;
                    tc.TotalCwvLineItem.ipp = col.cwvLineItem.Total_IPP__c;
                    tc.TotalCwvLineItem.nationalRetail = col.cwvLineItem.Total_National_Retail__c;
                    tc.TotalCwvLineItem.csat = col.cwvLineItem.Total_CSAT__c;
                    tc.TotalCwvLineItem.qp = col.cwvLineItem.Total_QP__c;
                    tc.TotalCwvLineItem.tc = col.cwvLineItem.Total_TC__c;
                    tc.TotalCwvLineItem.tdf = col.cwvLineItem.Total_TDF__c;
                    tc.TotalCwvLineItem.ilw = col.cwvLineItem.Total_ILW__c;
                    tc.TotalCwvLineItem.fees = col.cwvLineItem.Total_Fees__c;
                    tc.TotalCwvLineItem.negotiationBuffer = col.cwvLineItem.Total_Negotiation_Buffer__c;
                    tc.TotalCwvLineItem.nsad = col.cwvLineItem.Total_NSAD__c;
                    tc.TotalCwvLineItem.grossMargin = col.cwvLineItem.Total_Gross_Margin__c;
                    tc.TotalCwvLineItem.gm = col.cwvLineItem.Total_GM__c;
                    tc.TotalCwvLineItem.aAndP = col.cwvLineItem.Total_A_P__c;
                    tc.TotalCwvLineItem.motoagents = col.cwvLineItem.Total_Motoagents__c;
                    tc.TotalCwvLineItem.contributionMargin = col.cwvLineItem.Total_Contribution_Margin__c;
                    tc.TotalCwvLineItem.cm = col.cwvLineItem.Total_CM__c;
                    tc.TotalCwvLineItem.units = col.cwvLineItem.Units__c;
                    tc.TotalCwvLineItem.minCommit = col.cwvLineItem.MinimumCommitQuantity__c;
                    tc.TotalCwvLineItem.sdf = col.cwvLineItem.Total_SDF__c;
                    tc.TotalCwvLineItem.invoice = col.cwvLineItem.InvoicePrice__c;
                    
                    tc.TotalPorLineItem = new totalColItem();
                    tc.TotalPorLineItem.nsbd = col.porLineItem.Total_NSBD__c;
                    tc.TotalPorLineItem.discount = col.porLineItem.Total_Aggregate_Discounts__c;
                    tc.TotalPorLineItem.coop = col.porLineItem.Total_COOP__c;
                    tc.TotalPorLineItem.mdf = col.porLineItem.Total_MDF__c;
                    tc.TotalPorLineItem.imdf = col.porLineItem.Total_iMDF__c;
                    tc.TotalPorLineItem.svm = col.porLineItem.Total_SVM__c;
                    tc.TotalPorLineItem.ipp = col.porLineItem.Total_IPP__c;
                    tc.TotalPorLineItem.nationalRetail = col.porLineItem.Total_National_Retail__c;
                    tc.TotalPorLineItem.csat = col.porLineItem.Total_CSAT__c;
                    tc.TotalPorLineItem.qp = col.porLineItem.Total_QP__c;
                    tc.TotalPorLineItem.tc = col.porLineItem.Total_TC__c;
                    tc.TotalPorLineItem.tdf = col.porLineItem.Total_TDF__c;
                    tc.TotalPorLineItem.ilw = col.porLineItem.Total_ILW__c;
                    tc.TotalPorLineItem.fees = col.porLineItem.Total_Fees__c;
                    tc.TotalPorLineItem.negotiationBuffer = col.porLineItem.Total_Negotiation_Buffer__c;
                    tc.TotalPorLineItem.nsad = col.porLineItem.Total_NSAD__c;
                    tc.TotalPorLineItem.grossMargin = col.porLineItem.Total_Gross_Margin__c;
                    tc.TotalPorLineItem.gm = col.porLineItem.Total_GM__c;
                    tc.TotalPorLineItem.aAndP = col.porLineItem.Total_A_P__c;
                    tc.TotalPorLineItem.motoagents = col.porLineItem.Total_Motoagents__c;
                    tc.TotalPorLineItem.contributionMargin = col.porLineItem.Total_Contribution_Margin__c;
                    tc.TotalPorLineItem.cm = col.porLineItem.Total_CM__c;
                    tc.TotalPorLineItem.units = col.porLineItem.Units__c;
                    tc.TotalPorLineItem.minCommit = col.porLineItem.MinimumCommitQuantity__c;
                    tc.TotalPorLineItem.sdf = col.porLineItem.Total_SDF__c;
                    tc.TotalPorLineItem.invoice = col.porLineItem.InvoicePrice__c;

                    //add for other column, modified by qucw@lenovo.com    16 jun 2015
                    tc.TotalothLineItem = new totalColItem();
                    tc.TotalothLineItem.nsbd = col.othLineItem.Total_NSBD__c;
                    tc.TotalothLineItem.discount = col.othLineItem.Total_Aggregate_Discounts__c;
                    tc.TotalothLineItem.coop = col.othLineItem.Total_COOP__c;
                    tc.TotalothLineItem.mdf = col.othLineItem.Total_MDF__c;
                    tc.TotalothLineItem.imdf = col.othLineItem.Total_iMDF__c;
                    tc.TotalothLineItem.svm = col.othLineItem.Total_SVM__c;
                    tc.TotalothLineItem.ipp = col.othLineItem.Total_IPP__c;
                    tc.TotalothLineItem.nationalRetail = col.othLineItem.Total_National_Retail__c;
                    tc.TotalothLineItem.csat = col.othLineItem.Total_CSAT__c;
                    tc.TotalothLineItem.qp = col.othLineItem.Total_QP__c;
                    tc.TotalothLineItem.tc = col.othLineItem.Total_TC__c;
                    tc.TotalothLineItem.tdf = col.othLineItem.Total_TDF__c;
                    tc.TotalothLineItem.ilw = col.othLineItem.Total_ILW__c;
                    tc.TotalothLineItem.fees = col.othLineItem.Total_Fees__c;
                    tc.TotalothLineItem.negotiationBuffer = col.othLineItem.Total_Negotiation_Buffer__c;
                    tc.TotalothLineItem.nsad = col.othLineItem.Total_NSAD__c;
                    tc.TotalothLineItem.grossMargin = col.othLineItem.Total_Gross_Margin__c;
                    tc.TotalothLineItem.gm = col.othLineItem.Total_GM__c;
                    tc.TotalothLineItem.aAndP = col.othLineItem.Total_A_P__c;
                    tc.TotalothLineItem.motoagents = col.othLineItem.Total_Motoagents__c;
                    tc.TotalothLineItem.contributionMargin = col.othLineItem.Total_Contribution_Margin__c;
                    tc.TotalothLineItem.cm = col.othLineItem.Total_CM__c;
                    tc.TotalothLineItem.units = col.othLineItem.Units__c;
                    tc.TotalothLineItem.minCommit = col.othLineItem.MinimumCommitQuantity__c;
                    tc.TotalothLineItem.sdf = col.othLineItem.Total_SDF__c;
                    tc.TotalothLineItem.invoice = col.othLineItem.InvoicePrice__c;

                    totalColumnsMap.put(tc.sortingExpresion,tc);
                    system.debug('totalColumnsMap ' + totalColumnsMap);
                }
            }
            totalColumns = totalColumnsMap.values();
            //Cody Sechelski 10/23/2014: added a sort command
            totalColumns.sort();
            totalItemCount = totalColumns.size();
            
            //cmunoz@levementum.com. 09/17/14. Description: Added validation for null values.
            //9/11-Cody-Added logic to fix the percentage fields
            for(totalCol tc : totalColumns){
                if(tc.cwvLineItem.nsad != null)
                {
                    if(tc.cwvLineItem.nsad != 0){
                            tc.cwvLineItem.gm = (tc.cwvLineItem.grossMargin / tc.cwvLineItem.nsad)*100;
                            tc.cwvLineItem.cm = (tc.cwvLineItem.contributionMargin / tc.cwvLineItem.nsad)*100;
                    }
                    else{
                        if(tc.cwvLineItem.gm != null && tc.cwvLineItem.cm != null)
                        {
                            tc.cwvLineItem.gm = 0;
                            tc.cwvLineItem.cm = 0;
                        }
                    }
                    if(tc.porLineItem.nsad != 0){
                        tc.porLineItem.gm = (tc.porLineItem.grossMargin / tc.porLineItem.nsad)*100;
                            tc.porLineItem.cm = (tc.porLineItem.contributionMargin / tc.porLineItem.nsad)*100;
                    }
                    else{
                            tc.porLineItem.gm = 0;
                            tc.porLineItem.cm = 0;
                    }

                    //add for other column, modified by qucw@lenovo.com    16 jun 2015
                    if(tc.othLineItem.nsad != 0){
                        tc.othLineItem.gm = (tc.othLineItem.grossMargin / tc.othLineItem.nsad)*100;
                            tc.othLineItem.cm = (tc.othLineItem.contributionMargin / tc.othLineItem.nsad)*100;
                    }
                    else{
                            tc.othLineItem.gm = 0;
                            tc.othLineItem.cm = 0;
                    }
                }
            }
            
            //9/10-Cody-Create Summary Columns by adding all of the quarters for all of the products
            summaryColumns = new SummaryCol();
            summaryColumns.cwvLineItem = new totalColItem();
            summaryColumns.porLineItem = new totalColItem();
            summaryColumns.othLineItem = new totalColItem();
            
            //cmunoz@levementum.com
            Decimal totalASPCWV = 0;
            Decimal totalASPPOR = 0; 
            Decimal totalASPOTH = 0;           
            
            for(totalCol tc : totalColumns){
                summaryColumns.cwvLineItem.units += tc.totalCwvLineItem.units;
                summaryColumns.cwvLineItem.minCommit += tc.totalCwvLineItem.minCommit;
                summaryColumns.cwvLineItem.nsbd += tc.totalCwvLineItem.nsbd;
                summaryColumns.cwvLineItem.discount += tc.totalCwvLineItem.discount;
                summaryColumns.cwvLineItem.nsad += tc.totalCwvLineItem.nsad;
                summaryColumns.cwvLineItem.grossMargin += tc.totalCwvLineItem.grossMargin;
                summaryColumns.cwvLineItem.aAndP += tc.totalCwvLineItem.aAndP;
                summaryColumns.cwvLineItem.motoagents += tc.totalCwvLineItem.motoagents;
                summaryColumns.cwvLineItem.contributionMargin += tc.totalCwvLineItem.contributionMargin;
                                
                summaryColumns.porLineItem.units += tc.totalPorLineItem.units;
                summaryColumns.porLineItem.minCommit += tc.totalPorLineItem.minCommit;
                summaryColumns.porLineItem.nsbd += tc.totalPorLineItem.nsbd;
                summaryColumns.porLineItem.discount += tc.totalPorLineItem.discount;
                summaryColumns.porLineItem.nsad += tc.totalPorLineItem.nsad;
                summaryColumns.porLineItem.grossMargin += tc.totalPorLineItem.grossMargin;
                summaryColumns.porLineItem.aAndP += tc.totalPorLineItem.aAndP;
                summaryColumns.porLineItem.motoagents += tc.totalPorLineItem.motoagents;
                summaryColumns.porLineItem.contributionMargin += tc.totalPorLineItem.contributionMargin;

                //add for other column, modified by qucw@lenovo.com    16 jun 2015
                summaryColumns.othLineItem.units += tc.totalothLineItem.units;
                summaryColumns.othLineItem.minCommit += tc.totalothLineItem.minCommit;
                summaryColumns.othLineItem.nsbd += tc.totalothLineItem.nsbd;
                summaryColumns.othLineItem.discount += tc.totalothLineItem.discount;
                summaryColumns.othLineItem.nsad += tc.totalothLineItem.nsad;
                summaryColumns.othLineItem.grossMargin += tc.totalothLineItem.grossMargin;
                summaryColumns.othLineItem.aAndP += tc.totalothLineItem.aAndP;
                summaryColumns.othLineItem.motoagents += tc.totalothLineItem.motoagents;
                summaryColumns.othLineItem.contributionMargin += tc.totalothLineItem.contributionMargin;
            }
            
            if(summaryColumns.porLineItem.nsad == 0)
            {
                summaryColumns.porLineItem.totalGMPercentage = 0;
                summaryColumns.porLineItem.totalCMPercentage = 0;
            }
            else
            {
                summaryColumns.porLineItem.totalGMPercentage = (summaryColumns.porLineItem.grossMargin/summaryColumns.porLineItem.nsad);
                summaryColumns.porLineItem.totalCMPercentage = (summaryColumns.porLineItem.contributionMargin/summaryColumns.porLineItem.nsad);
            }
            
            if(summaryColumns.cwvLineItem.nsad == 0)
            {
                summaryColumns.cwvLineItem.totalGMPercentage = 0;
                summaryColumns.cwvLineItem.totalCMPercentage = 0;
            }
            else
            {
                summaryColumns.cwvLineItem.totalGMPercentage = (summaryColumns.cwvLineItem.grossMargin/summaryColumns.cwvLineItem.nsad);
                summaryColumns.cwvLineItem.totalCMPercentage = (summaryColumns.cwvLineItem.contributionMargin/summaryColumns.cwvLineItem.nsad);
            }
            //add for other column, modified by qucw@lenovo.com    16 jun 2015
            if(summaryColumns.othLineItem.nsad == 0)
            {
                summaryColumns.othLineItem.totalGMPercentage = 0;
                summaryColumns.othLineItem.totalCMPercentage = 0;
            }
            else
            {
                summaryColumns.othLineItem.totalGMPercentage = (summaryColumns.othLineItem.grossMargin/summaryColumns.othLineItem.nsad);
                summaryColumns.othLineItem.totalCMPercentage = (summaryColumns.othLineItem.contributionMargin/summaryColumns.othLineItem.nsad);
            }
            showTable = true;
            formulaError = false;
            
            //10/24-Cody-Add logic to aggrate the totals for all products for the summary tab
            summaryProductColumns = new List<SummaryCol>();
            productMap = new Map<String,SummaryCol>();
            system.debug('***lineItemColumns***'+lineItemColumns);
            for(lineItemCol col : lineItemColumns){
                String prodName = col.Name.split('-')[0].trim();
                system.debug('***ProdName***'+prodName);
                system.debug('***productMap***'+productMap);
                if(productMap.containsKey(prodName)){
                    SummaryCol sc = productMap.get(prodName);
                    
                    if(col.cwvLineItem.Units__c != null){
                        sc.cwvLineItem.units += col.cwvLineItem.Units__c;
                    }
                    if(col.cwvLineItem.MinimumCommitQuantity__c != null){
                        sc.cwvLineItem.minCommit += col.cwvLineItem.MinimumCommitQuantity__c;
                    }
                    if(col.cwvLineItem.Total_NSBD__c != null){
                        sc.cwvLineItem.nsbd += col.cwvLineItem.Total_NSBD__c;
                    }
                    if(col.cwvLineItem.Total_Discounts__c != null){
                        sc.cwvLineItem.discount += col.cwvLineItem.Total_Discounts__c;
                    }
                    if(col.cwvLineItem.Total_COOP__c != null){
                        sc.cwvLineItem.coop += col.cwvLineItem.Total_COOP__c;
                    }
                    if(col.cwvLineItem.Total_MDF__c != null){
                        sc.cwvLineItem.mdf += col.cwvLineItem.Total_MDF__c;
                    }
                    if(col.cwvLineItem.Total_iMDF__c != null){
                        sc.cwvLineItem.imdf += col.cwvLineItem.Total_iMDF__c;
                    }
                    if(col.cwvLineItem.Total_SVM__c != null){
                        sc.cwvLineItem.svm += col.cwvLineItem.Total_SVM__c;
                    }
                    if(col.cwvLineItem.Total_IPP__c != null){
                        sc.cwvLineItem.ipp += col.cwvLineItem.Total_IPP__c;
                    }
                    if(col.cwvLineItem.Total_National_Retail__c != null){
                        sc.cwvLineItem.nationalRetail += col.cwvLineItem.Total_National_Retail__c;
                    }
                    if(col.cwvLineItem.Total_CSAT__c != null){
                        sc.cwvLineItem.csat += col.cwvLineItem.Total_CSAT__c;
                    }
                    if(col.cwvLineItem.Total_QP__c != null){
                        sc.cwvLineItem.qp += col.cwvLineItem.Total_QP__c;
                    }
                    if(col.cwvLineItem.Total_TC__c != null){
                        sc.cwvLineItem.tc += col.cwvLineItem.Total_TC__c;
                    }
                    if(col.cwvLineItem.Total_TDF__c != null){
                        sc.cwvLineItem.tdf += col.cwvLineItem.Total_TDF__c;
                    }
                    if(col.cwvLineItem.Total_ILW__c != null){
                        sc.cwvLineItem.ilw += col.cwvLineItem.Total_ILW__c;
                    }
                    if(col.cwvLineItem.Total_Fees__c != null){
                        sc.cwvLineItem.fees += col.cwvLineItem.Total_Fees__c;
                    }
                    if(col.cwvLineItem.Total_Negotiation_Buffer__c != null){
                        sc.cwvLineItem.negotiationBuffer += col.cwvLineItem.Total_Negotiation_Buffer__c;
                    }
                    if(col.cwvLineItem.Total_NSAD__c != null){
                        sc.cwvLineItem.nsad += col.cwvLineItem.Total_NSAD__c;
                    }
                    if(col.cwvLineItem.Total_Gross_Margin__c != null){
                        sc.cwvLineItem.grossMargin += col.cwvLineItem.Total_Gross_Margin__c;
                    }
                    if(col.cwvLineItem.Total_A_P__c != null){
                        sc.cwvLineItem.aAndP += col.cwvLineItem.Total_A_P__c;
                    }
                    if(col.cwvLineItem.Total_Motoagents__c != null){
                        sc.cwvLineItem.motoagents += col.cwvLineItem.Total_Motoagents__c;
                    }
                    if(col.cwvLineItem.Total_Contribution_Margin__c != null){
                        sc.cwvLineItem.contributionMargin += col.cwvLineItem.Total_Contribution_Margin__c;
                    }
                    if(col.cwvLineItem.Total_SDF__c != null){
                        sc.cwvLineItem.sdf += col.cwvLineItem.Total_SDF__c;
                    }
                    
                    
                    if(col.porLineItem.Units__c != null){
                        sc.porLineItem.units += col.porLineItem.Units__c;
                    }
                    if(col.porLineItem.MinimumCommitQuantity__c != null){
                        sc.porLineItem.minCommit += col.porLineItem.MinimumCommitQuantity__c;
                    }
                    if(col.porLineItem.Total_NSBD__c != null){
                        sc.porLineItem.nsbd += col.porLineItem.Total_NSBD__c;
                    }
                    if(col.porLineItem.Total_Discounts__c != null){
                        sc.porLineItem.discount += col.porLineItem.Total_Discounts__c;
                    }
                    if(col.porLineItem.Total_COOP__c != null){
                        sc.porLineItem.coop += col.porLineItem.Total_COOP__c;
                    }
                    if(col.porLineItem.Total_MDF__c != null){
                        sc.porLineItem.mdf += col.porLineItem.Total_MDF__c;
                    }
                    if(col.porLineItem.Total_iMDF__c != null){
                        sc.porLineItem.imdf += col.porLineItem.Total_iMDF__c;
                    }
                    if(col.porLineItem.Total_SVM__c != null){
                        sc.porLineItem.svm += col.porLineItem.Total_SVM__c;
                    }
                    if(col.porLineItem.Total_IPP__c != null){
                        sc.porLineItem.ipp += col.porLineItem.Total_IPP__c;
                    }
                    if(col.porLineItem.Total_National_Retail__c != null){
                        sc.porLineItem.nationalRetail += col.porLineItem.Total_National_Retail__c;
                    }
                    if(col.porLineItem.Total_CSAT__c != null){
                        sc.porLineItem.csat += col.porLineItem.Total_CSAT__c;
                    }
                    if(col.porLineItem.Total_QP__c != null){
                        sc.porLineItem.qp += col.porLineItem.Total_QP__c;
                    }
                    if(col.porLineItem.Total_TC__c != null){
                        sc.porLineItem.tc += col.porLineItem.Total_TC__c;
                    }
                    if(col.porLineItem.Total_TDF__c != null){
                        sc.porLineItem.tdf += col.porLineItem.Total_TDF__c;
                    }
                    if(col.porLineItem.Total_ILW__c != null){
                        sc.porLineItem.ilw += col.porLineItem.Total_ILW__c;
                    }
                    if(col.porLineItem.Total_Fees__c != null){
                        sc.porLineItem.fees += col.porLineItem.Total_Fees__c;
                    }
                    if(col.porLineItem.Total_Negotiation_Buffer__c != null){
                        sc.porLineItem.negotiationBuffer += col.porLineItem.Total_Negotiation_Buffer__c;
                    }
                    if(col.porLineItem.Total_NSAD__c != null){
                        sc.porLineItem.nsad += col.porLineItem.Total_NSAD__c;
                    }
                    if(col.porLineItem.Total_Gross_Margin__c != null){
                        sc.porLineItem.grossMargin += col.porLineItem.Total_Gross_Margin__c;
                    }
                    if(col.porLineItem.Total_A_P__c != null){
                        sc.porLineItem.aAndP += col.porLineItem.Total_A_P__c;
                    }
                    if(col.porLineItem.Total_Motoagents__c != null){
                        sc.porLineItem.motoagents += col.porLineItem.Total_Motoagents__c;
                    }
                    if(col.porLineItem.Total_Contribution_Margin__c != null){
                        sc.porLineItem.contributionMargin += col.porLineItem.Total_Contribution_Margin__c;
                    }
                    if(col.porLineItem.Total_SDF__c != null){
                        sc.porLineItem.sdf += col.porLineItem.Total_SDF__c;
                    }

                    //add for other column, modified by qucw@lenovo.com    16 jun 2015      
                    if(col.othLineItem.Units__c != null){
                        sc.othLineItem.units += col.othLineItem.Units__c;
                    }                    if(col.othLineItem.MinimumCommitQuantity__c != null){
                        sc.othLineItem.minCommit += col.othLineItem.MinimumCommitQuantity__c;
                    }                    if(col.othLineItem.Total_NSBD__c != null){
                        sc.othLineItem.nsbd += col.othLineItem.Total_NSBD__c;
                    }                    if(col.othLineItem.Total_Discounts__c != null){
                        sc.othLineItem.discount += col.othLineItem.Total_Discounts__c;
                    }                    if(col.othLineItem.Total_COOP__c != null){
                        sc.othLineItem.coop += col.othLineItem.Total_COOP__c;
                    }                    if(col.othLineItem.Total_MDF__c != null){
                        sc.othLineItem.mdf += col.othLineItem.Total_MDF__c;
                    }                    if(col.othLineItem.Total_iMDF__c != null){
                        sc.othLineItem.imdf += col.othLineItem.Total_iMDF__c;
                    }                    if(col.othLineItem.Total_SVM__c != null){
                        sc.othLineItem.svm += col.othLineItem.Total_SVM__c;
                    }                    if(col.othLineItem.Total_IPP__c != null){
                        sc.othLineItem.ipp += col.othLineItem.Total_IPP__c;
                    }                    if(col.othLineItem.Total_National_Retail__c != null){
                        sc.othLineItem.nationalRetail += col.othLineItem.Total_National_Retail__c;
                    }                    if(col.othLineItem.Total_CSAT__c != null){
                        sc.othLineItem.csat += col.othLineItem.Total_CSAT__c;
                    }                    if(col.othLineItem.Total_QP__c != null){
                        sc.othLineItem.qp += col.othLineItem.Total_QP__c;
                    }                    if(col.othLineItem.Total_TC__c != null){
                        sc.othLineItem.tc += col.othLineItem.Total_TC__c;
                    }                    if(col.othLineItem.Total_TDF__c != null){
                        sc.othLineItem.tdf += col.othLineItem.Total_TDF__c;
                    }                    if(col.othLineItem.Total_ILW__c != null){
                        sc.othLineItem.ilw += col.othLineItem.Total_ILW__c;
                    }                    if(col.othLineItem.Total_Fees__c != null){
                        sc.othLineItem.fees += col.othLineItem.Total_Fees__c;
                    }                    if(col.othLineItem.Total_Negotiation_Buffer__c != null){
                        sc.othLineItem.negotiationBuffer += col.othLineItem.Total_Negotiation_Buffer__c;
                    }                    if(col.othLineItem.Total_NSAD__c != null){
                        sc.othLineItem.nsad += col.othLineItem.Total_NSAD__c;
                    }                    if(col.othLineItem.Total_Gross_Margin__c != null){
                        sc.othLineItem.grossMargin += col.othLineItem.Total_Gross_Margin__c;
                    }                    if(col.othLineItem.Total_A_P__c != null){
                        sc.othLineItem.aAndP += col.othLineItem.Total_A_P__c;
                    }                    if(col.othLineItem.Total_Motoagents__c != null){
                        sc.othLineItem.motoagents += col.othLineItem.Total_Motoagents__c;
                    }                    if(col.othLineItem.Total_Contribution_Margin__c != null){
                        sc.othLineItem.contributionMargin += col.othLineItem.Total_Contribution_Margin__c;
                    }                    if(col.othLineItem.Total_SDF__c != null){
                        sc.othLineItem.sdf += col.othLineItem.Total_SDF__c;
                    }

                    productMap.put(prodName,sc);
                }
                else{
                    SummaryCol sc = new SummaryCol();
                    sc.productName = prodName;
                    sc.cwvLineItem = new totalColItem();
                    sc.porLineItem = new totalColItem();
                    //Add for other column. by qucw@lenovo.com    18 jun 2015
                    sc.othLineItem = new totalColItem();
                    
                    if(col.cwvLineItem.Units__c != null){
                        sc.cwvLineItem.units = col.cwvLineItem.Units__c;
                    }
                    if(col.cwvLineItem.MinimumCommitQuantity__c != null){
                        sc.cwvLineItem.minCommit = col.cwvLineItem.MinimumCommitQuantity__c;
                    }
                    if(col.cwvLineItem.Total_NSBD__c != null){
                        sc.cwvLineItem.nsbd = col.cwvLineItem.Total_NSBD__c;
                    }
                    if(col.cwvLineItem.Total_Discounts__c != null){
                        sc.cwvLineItem.discount = col.cwvLineItem.Total_Discounts__c;
                    }
                    if(col.cwvLineItem.Total_COOP__c != null){
                        sc.cwvLineItem.coop = col.cwvLineItem.Total_COOP__c;
                    }
                    if(col.cwvLineItem.Total_MDF__c != null){
                        sc.cwvLineItem.mdf = col.cwvLineItem.Total_MDF__c;
                    }
                    if(col.cwvLineItem.Total_iMDF__c != null){
                        sc.cwvLineItem.imdf = col.cwvLineItem.Total_iMDF__c;
                    }
                    if(col.cwvLineItem.Total_SVM__c != null){
                        sc.cwvLineItem.svm = col.cwvLineItem.Total_SVM__c;
                    }
                    if(col.cwvLineItem.Total_IPP__c != null){
                        sc.cwvLineItem.ipp = col.cwvLineItem.Total_IPP__c;
                    }
                    if(col.cwvLineItem.Total_National_Retail__c != null){
                        sc.cwvLineItem.nationalRetail = col.cwvLineItem.Total_National_Retail__c;
                    }
                    if(col.cwvLineItem.Total_CSAT__c != null){
                        sc.cwvLineItem.csat = col.cwvLineItem.Total_CSAT__c;
                    }
                    if(col.cwvLineItem.Total_QP__c != null){
                        sc.cwvLineItem.qp = col.cwvLineItem.Total_QP__c;
                    }
                    if(col.cwvLineItem.Total_TC__c != null){
                        sc.cwvLineItem.tc = col.cwvLineItem.Total_TC__c;
                    }
                    if(col.cwvLineItem.Total_TDF__c != null){
                        sc.cwvLineItem.tdf = col.cwvLineItem.Total_TDF__c;
                    }
                    if(col.cwvLineItem.Total_ILW__c != null){
                        sc.cwvLineItem.ilw = col.cwvLineItem.Total_ILW__c;
                    }
                    if(col.cwvLineItem.Total_Fees__c != null){
                        sc.cwvLineItem.fees = col.cwvLineItem.Total_Fees__c;
                    }
                    if(col.cwvLineItem.Total_Negotiation_Buffer__c != null){
                        sc.cwvLineItem.negotiationBuffer = col.cwvLineItem.Total_Negotiation_Buffer__c;
                    }
                    if(col.cwvLineItem.Total_NSAD__c != null){
                        sc.cwvLineItem.nsad = col.cwvLineItem.Total_NSAD__c;
                    }
                    if(col.cwvLineItem.Total_Gross_Margin__c != null){
                        sc.cwvLineItem.grossMargin = col.cwvLineItem.Total_Gross_Margin__c;
                    }
                    if(col.cwvLineItem.Total_A_P__c != null){
                        sc.cwvLineItem.aAndP = col.cwvLineItem.Total_A_P__c;
                    }
                    if(col.cwvLineItem.Total_Motoagents__c != null){
                        sc.cwvLineItem.motoagents = col.cwvLineItem.Total_Motoagents__c;
                    }
                    if(col.cwvLineItem.Total_Contribution_Margin__c != null){
                        sc.cwvLineItem.contributionMargin = col.cwvLineItem.Total_Contribution_Margin__c;
                    }
                    if(col.cwvLineItem.Total_SDF__c != null){
                        sc.cwvLineItem.sdf = col.cwvLineItem.Total_SDF__c;
                    }
                    
                    
                    if(col.porLineItem.Units__c != null){
                        sc.porLineItem.units = col.porLineItem.Units__c;
                    }
                    if(col.porLineItem.MinimumCommitQuantity__c != null){
                        sc.porLineItem.minCommit = col.porLineItem.MinimumCommitQuantity__c;
                    }
                    if(col.porLineItem.Total_NSBD__c != null){
                        sc.porLineItem.nsbd = col.porLineItem.Total_NSBD__c;
                    }
                    if(col.porLineItem.Total_Discounts__c != null){
                        sc.porLineItem.discount = col.porLineItem.Total_Discounts__c;
                    }
                    if(col.porLineItem.Total_COOP__c != null){
                        sc.porLineItem.coop = col.porLineItem.Total_COOP__c;
                    }
                    if(col.porLineItem.Total_MDF__c != null){
                        sc.porLineItem.mdf = col.porLineItem.Total_MDF__c;
                    }
                    if(col.porLineItem.Total_iMDF__c != null){
                        sc.porLineItem.imdf = col.porLineItem.Total_iMDF__c;
                    }
                    if(col.porLineItem.Total_SVM__c != null){
                        sc.porLineItem.svm = col.porLineItem.Total_SVM__c;
                    }
                    if(col.porLineItem.Total_IPP__c != null){
                        sc.porLineItem.ipp = col.porLineItem.Total_IPP__c;
                    }
                    if(col.porLineItem.Total_National_Retail__c != null){
                        sc.porLineItem.nationalRetail = col.porLineItem.Total_National_Retail__c;
                    }
                    if(col.porLineItem.Total_CSAT__c != null){
                        sc.porLineItem.csat = col.porLineItem.Total_CSAT__c;
                    }
                    if(col.porLineItem.Total_QP__c != null){
                        sc.porLineItem.qp = col.porLineItem.Total_QP__c;
                    }
                    if(col.porLineItem.Total_TC__c != null){
                        sc.porLineItem.tc = col.porLineItem.Total_TC__c;
                    }
                    if(col.porLineItem.Total_TDF__c != null){
                        sc.porLineItem.tdf = col.porLineItem.Total_TDF__c;
                    }
                    if(col.porLineItem.Total_ILW__c != null){
                        sc.porLineItem.ilw = col.porLineItem.Total_ILW__c;
                    }
                    if(col.porLineItem.Total_Fees__c != null){
                        sc.porLineItem.fees = col.porLineItem.Total_Fees__c;
                    }
                    if(col.porLineItem.Total_Negotiation_Buffer__c != null){
                        sc.porLineItem.negotiationBuffer = col.porLineItem.Total_Negotiation_Buffer__c;
                    }
                    if(col.porLineItem.Total_NSAD__c != null){
                        sc.porLineItem.nsad = col.porLineItem.Total_NSAD__c;
                    }
                    if(col.porLineItem.Total_Gross_Margin__c != null){
                        sc.porLineItem.grossMargin = col.porLineItem.Total_Gross_Margin__c;
                    }
                    if(col.porLineItem.Total_A_P__c != null){
                        sc.porLineItem.aAndP = col.porLineItem.Total_A_P__c;
                    }
                    if(col.porLineItem.Total_Motoagents__c != null){
                        sc.porLineItem.motoagents = col.porLineItem.Total_Motoagents__c;
                    }
                    if(col.porLineItem.Total_Contribution_Margin__c != null){
                        sc.porLineItem.contributionMargin = col.porLineItem.Total_Contribution_Margin__c;
                    }
                    if(col.porLineItem.Total_SDF__c != null){
                        sc.porLineItem.sdf = col.porLineItem.Total_SDF__c;
                    }
                    //Add for other column, by qucw@lenovo.com    18 jun 2015
                    if(col.othLineItem.Units__c != null){
                        sc.othLineItem.units = col.othLineItem.Units__c;
                    }
                    if(col.othLineItem.MinimumCommitQuantity__c != null){
                        sc.othLineItem.minCommit = col.othLineItem.MinimumCommitQuantity__c;
                    }
                    if(col.othLineItem.Total_NSBD__c != null){
                        sc.othLineItem.nsbd = col.othLineItem.Total_NSBD__c;
                    }
                    if(col.othLineItem.Total_Discounts__c != null){
                        sc.othLineItem.discount = col.othLineItem.Total_Discounts__c;
                    }
                    if(col.othLineItem.Total_COOP__c != null){
                        sc.othLineItem.coop = col.othLineItem.Total_COOP__c;
                    }
                    if(col.othLineItem.Total_MDF__c != null){
                        sc.othLineItem.mdf = col.othLineItem.Total_MDF__c;
                    }
                    if(col.othLineItem.Total_iMDF__c != null){
                        sc.othLineItem.imdf = col.othLineItem.Total_iMDF__c;
                    }
                    if(col.othLineItem.Total_SVM__c != null){
                        sc.othLineItem.svm = col.othLineItem.Total_SVM__c;
                    }
                    if(col.othLineItem.Total_IPP__c != null){
                        sc.othLineItem.ipp = col.othLineItem.Total_IPP__c;
                    }
                    if(col.othLineItem.Total_National_Retail__c != null){
                        sc.othLineItem.nationalRetail = col.othLineItem.Total_National_Retail__c;
                    }
                    if(col.othLineItem.Total_CSAT__c != null){
                        sc.othLineItem.csat = col.othLineItem.Total_CSAT__c;
                    }
                    if(col.othLineItem.Total_QP__c != null){
                        sc.othLineItem.qp = col.othLineItem.Total_QP__c;
                    }
                    if(col.othLineItem.Total_TC__c != null){
                        sc.othLineItem.tc = col.othLineItem.Total_TC__c;
                    }
                    if(col.othLineItem.Total_TDF__c != null){
                        sc.othLineItem.tdf = col.othLineItem.Total_TDF__c;
                    }
                    if(col.othLineItem.Total_ILW__c != null){
                        sc.othLineItem.ilw = col.othLineItem.Total_ILW__c;
                    }
                    if(col.othLineItem.Total_Fees__c != null){
                        sc.othLineItem.fees = col.othLineItem.Total_Fees__c;
                    }
                    if(col.othLineItem.Total_Negotiation_Buffer__c != null){
                        sc.othLineItem.negotiationBuffer = col.othLineItem.Total_Negotiation_Buffer__c;
                    }
                    if(col.othLineItem.Total_NSAD__c != null){
                        sc.othLineItem.nsad = col.othLineItem.Total_NSAD__c;
                    }
                    if(col.othLineItem.Total_Gross_Margin__c != null){
                        sc.othLineItem.grossMargin = col.othLineItem.Total_Gross_Margin__c;
                    }
                    if(col.othLineItem.Total_A_P__c != null){
                        sc.othLineItem.aAndP = col.othLineItem.Total_A_P__c;
                    }
                    if(col.othLineItem.Total_Motoagents__c != null){
                        sc.othLineItem.motoagents = col.othLineItem.Total_Motoagents__c;
                    }
                    if(col.othLineItem.Total_Contribution_Margin__c != null){
                        sc.othLineItem.contributionMargin = col.othLineItem.Total_Contribution_Margin__c;
                    }
                    if(col.othLineItem.Total_SDF__c != null){
                        sc.othLineItem.sdf = col.othLineItem.Total_SDF__c;
                    }
                    
                    productMap.put(prodName,sc);
                }
            }
            
            summaryProductColumns = productMap.values();
            summaryProductColumns.sort();
            
            summaryProductCount = summaryProductColumns.size();
            
            //calculate the total percentages
            for(SummaryCol sc : summaryProductColumns){
                if(sc.cwvLineItem.nsad != null)
                {
                    if(sc.cwvLineItem.nsad != 0){
                            sc.cwvLineItem.gm = (sc.cwvLineItem.grossMargin / sc.cwvLineItem.nsad)*100;
                            sc.cwvLineItem.cm = (sc.cwvLineItem.contributionMargin / sc.cwvLineItem.nsad)*100;
                    }
                    else{
                        if(sc.cwvLineItem.gm != null && sc.cwvLineItem.cm != null)
                        {
                            sc.cwvLineItem.gm = 0;
                            sc.cwvLineItem.cm = 0;
                        }
                    }
                    if(sc.porLineItem.nsad != 0){
                        sc.porLineItem.gm = (sc.porLineItem.grossMargin / sc.porLineItem.nsad)*100;
                            sc.porLineItem.cm = (sc.porLineItem.contributionMargin / sc.porLineItem.nsad)*100;
                    }
                    else{
                            sc.porLineItem.gm = 0;
                            sc.porLineItem.cm = 0;
                    }
                    //Add for other column, by qucw@lenovo.c om   18 jun 2015
                    if(sc.othLineItem.nsad != 0){
                        sc.othLineItem.gm = (sc.othLineItem.grossMargin / sc.othLineItem.nsad)*100;
                            sc.othLineItem.cm = (sc.othLineItem.contributionMargin / sc.othLineItem.nsad)*100;
                    }
                    else{
                            sc.othLineItem.gm = 0;
                            sc.othLineItem.cm = 0;
                    }
                }
            }
            
            
        }
        catch(Exception ex)
        {
            
             // * @author: Cuauhtemoc Munoz
             // * @date:   09/08/14
             // * @email:  cmunoz@levementum.com
             // * @description:    Adds error message if no products selected
             
            system.debug('View Deal Products ' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
            showTable = true;
        }
    }
    
    public pageReference saveChanges()
    {
        ApexPages.currentPage().getParameters().put('vfpEditMode','false'); //jescamilla@levementum.com 9/25/14 Prevent page from opening in Edit Mode after saving changes.
     try
     {   
            /**
             * BEGINS CHANGE
             * @email:  cmunoz@levementum.com
             * @date:   09/02/14
             * @brief:  Updates text field comment values into the database
             */
            
            for(String name : lineItemsByQuoteId.keySet()){
                lineItemCol col = new lineItemCol();
                for(QuoteLineItem qli : lineItemsByQuoteId.get(name)){
                    
                    qli.NSBDComment__c = lineItemColumns[0].commentField;
                    qli.coopComment__c = lineItemColumns[0].coopCommentField;
                    qli.negotiationBufferComment__c = lineItemColumns[0].negotiationBufferCommentField;
                    qli.feesComment__c = lineItemColumns[0].feesCommentField;
                    qli.tdfComment__c = lineItemColumns[0].tdfCommentField;
                    qli.ilwComment__c = lineItemColumns[0].ilwCommentField;
                    qli.tcComment__c = lineItemColumns[0].tcCommentField;
                    qli.qpComment__c = lineItemColumns[0].qpCommentField;
                    qli.csatComment__c = lineItemColumns[0].csatCommentField;
                    qli.nationalRetailComment__c = lineItemColumns[0].nationalRetailCommentField;
                    qli.ippComment__c = lineItemColumns[0].ippCommentField;
                    qli.svmComment__c = lineItemColumns[0].svmCommentField;
                    qli.imdfComment__c = lineItemColumns[0].imdfCommentField;
                    qli.mdfComment__c = lineItemColumns[0].mdfCommentField;
                    qli.discountComment__c = lineItemColumns[0].discountCommentField;
                    qli.nsadComment__c = lineItemColumns[0].nsadCommentField;
                    qli.mcpuComment__c = lineItemColumns[0].mcpuCommentField;
                    qli.invoicePriceCommentU__c = lineItemColumns[0].invoiceCommentField;
                    
                    qli.minimumCommitOpComment__c = lineItemColumns[0].minimumCommitOpCommentField;
                    qli.NSBDOpComment__c = lineItemColumns[0].nsbdOpCommentField;
                    qli.sdfOpComment__c = lineItemColumns[0].sdfOpCommentField;
                    qli.coopOpComment__c = lineItemColumns[0].coopOpCommentField;
                    qli.mdfOpComment__c = lineItemColumns[0].mdfOpCommentField;
                    qli.imdfOpComment__c = lineItemColumns[0].imdfOpCommentField;
                    qli.svmOpComment__c = lineItemColumns[0].svmOpCommentField;
                    qli.ippOpComment__c = lineItemColumns[0].ippOpCommentField;
                    qli.nationalRetailOpComment__c = lineItemColumns[0].nationalRetailOpCommentField;
                    qli.csatOpComment__c = lineItemColumns[0].csatOpCommentField;
                    qli.qpOpComment__c = lineItemColumns[0].qpOpCommentField;
                    qli.tcOpComment__c = lineItemColumns[0].tcOpCommentField;
                    qli.ilwOpComment__c = lineItemColumns[0].ilwOpCommentField;
                    qli.tdfOpComment__c = lineItemColumns[0].tdfOpCommentField;
                    qli.feesOpComment__c = lineItemColumns[0].feesOpCommentField;
                    qli.negotiationBufferOpComment__c = lineItemColumns[0].negotiationBufferOpCommentField;                
                }
            }
            /* ENDS CHANGE */
            List<QuoteLineItem> qlisToUpdate = new List<QuoteLineItem>();
            for(lineItemCol col : lineItemColumns){
                qlisToUpdate.add(col.cwvLineItem);
                qlisToUpdate.add(col.porLineItem);
            }
            if(!qlisToUpdate.isEmpty()){
                update qlisToUpdate;
            }
            getProducts();
     }
     catch(exception ex)
     {}
     return null;
    }
    
    public String getCustomRender() {
        if (ApexPages.currentPage().getParameters().get('rerenderPageToExcel') != null){
            return 'application/vnd.ms-excel#Deal Products_'+ Date.today().format() +'.xls';
        }else{
            return null;
        }
    }
    
    public pageReference exportToExcel(){
        //PageReference myVFP =  Apexpages.currentPage();
         PageReference myVFP =  new PageReference('/apex/DealViewExcel');
         myVFP.getParameters().put('qId',thisQuote.Id);
         List<String> selectedIds = new LIst<String>();
            for(selectOption so : selectedOptions){
                selectedIds.add(so.getValue());
            }
         myVFP.getParameters().put('selectedIDs',String.join(selectedIds,','));
        
         return myVFP;
       
    }
    
    
    
    public class totalCol implements Comparable{
        public totalColItem cwvLineItem {get;set;}
        public totalColItem porLineItem {get;set;}
        //Add for other column, modified by qucw@lenovo.com    16 Jun 2015
        public totalColItem othLineItem {get;set;}
        public totalColItem totalCwvLineItem {get;set;}
        public totalColItem totalPorLineItem {get;set;}
        //Add for other column, modified by qucw@lenovo.com    16 Jun 2015
        public totalColItem totalOthLineItem {get;set;}
        public string quarter {get;set;}
        public Integer quarterNumber {get;set;}
        public Integer year {get;set;}
        public Integer sortingExpresion {get;set;}
        
        //Cody Sechelski 10/23/2014 Added custom sorting method
        public Integer compareTo (Object compareTo){
            totalCol tc = (totalCol)compareTo;
            string compString = string.valueOf(this.year) + string.valueOf(this.quarterNUmber);
            string compStringCompareTo = string.valueOf(tc.year) + string.valueOf(tc.quarterNUmber);
            Integer val = 0;
            
            if(compString < compStringCompareTo){
                val = -1;
            }
            if(compString > compStringCompareTo){
                val = 1;
            }
            
            return val;
        }
    }
    
    
    
    
    public pageReference getSelected(){
        system.debug('selectedIdString='+selectedIdString);
        selectedId = new List<Id>();
        if(!string.isEmpty(selectedIdString)){
            if(selectedIdString.contains(',')){
                for(string s : selectedIdString.split(',')){
                    selectedId.add((ID)s);
                }
            }
            else{
                selectedId.add((ID)selectedIdString);
            }
            system.debug('selectedId='+selectedId);
        }
        return null;
    }
    public pageReference goToNextPage(){
        try
        {
            currentPage++;
            currentList = serarchResults[currentPage-1];
            checkPageStatus();
        }
        catch(exception ex){}
        return null;
    }
    public pageReference goToPreviousPage(){
        try
        {
            currentPage--;
            currentList = serarchResults[currentPage-1];
            checkPageStatus();
        }
        catch(Exception ex){}
        return null;
    }
    
    public void checkPageStatus(){
        try
        {
            if(currentPage == serarchResults.size()){
                onLastPage = true;
            }
            else{
                onLastPage = false;
            }
            
            if(CurrentPage == 1){
                onFirstPage = true;
            }
            else{
                onFirstPage = false;
            }
        }
        catch(exception ex){}
    }
    
    public pageReference searchButtonClick(){
        doSearch();
        return null;
    }
    
    public void doSearch(){
        try
        {
            serarchResults.clear();
            List<PriceBookEntry> tempList = new List<PriceBookEntry>();
            system.debug('selectedKeywords='+selectedKeywords);
            if(string.isEmpty(selectedKeywords)){
                for(PricebookEntry pbe : [select   product2Id,
                                                   product2.Name, 
                                                   product2.ProductCode, 
                                                   product2.Project__c, 
                                                   product2.Program__c,
                                                   product2.Family, 
                                                   product2.Business_Unit__c, 
                                                   UnitPrice 
                                          from     PricebookEntry 
                                          where    product2.IsActive = true
                                          and      isActive = true
                                          and      CurrencyIsoCode = :thisQuote.Opportunity.CurrencyIsoCode
                                          order by product2.Name
                                          limit    10000])
                {
                    
                    if(tempList.size() < pageSize){
                        tempList.add(pbe);
                    }
                    else{
                        serarchResults.add(tempList);
                        tempList = new LIst<PriceBookEntry>();
                    }
                }
                if(tempList.size() > 0){
                    serarchResults.add(tempList);
                }
                totalPages = serarchResults.size();
            }
            else{
                Set<id> prodIds = new Set<Id>();
                String query = 'FIND {' + selectedKeywords + '} IN ALL Fields Returning Product2(Id)';
                for(sObject so : search.query(query)[0]){
                    Product2 prod = (Product2)so;
                    prodIds.add(prod.Id);
                }
                system.debug('prodIds='+prodIds);
                for(PricebookEntry pbe : [select   product2Id,
                                                   product2.Name, 
                                                   product2.ProductCode, 
                                                   product2.Project__c, 
                                                   product2.Program__c,
                                                   product2.Family, 
                                                   product2.Business_Unit__c, 
                                                   UnitPrice 
                                          from     PricebookEntry 
                                          where    product2.IsActive = true
                                          and      isActive = true
                                          and      product2Id in :prodIds
                                          and      CurrencyIsoCode = :thisQuote.Opportunity.CurrencyIsoCode
                                          order by product2.Name
                                          limit    10000])
                {
                    
                    if(tempList.size() < pageSize){
                        tempList.add(pbe);
                    }
                    else{
                        serarchResults.add(tempList);
                        tempList = new LIst<PriceBookEntry>();
                    }
                }
                if(tempList.size() > 0){
                    serarchResults.add(tempList);
                }
                totalPages = serarchResults.size();
            }
            currentList = serarchResults[currentPage-1];
            checkPageStatus();
        }
        catch(Exception ex)
        {
            system.debug('ERROR' + ex.getMessage());
        }
    }
    
    /*jgarcia@levementum.com 9/4/2014. Moved checkboxes functionality from Jquery to Apex controller so the checkboxes labes can be rerender in the excel file
     * I had to do a function for each checkbox so all of them get their independent values in excel, otherwise, with just one function for all of them
     * as soon as we click on one of them, all are false or true(they all have the same value) */
    public pageReference setCheckBoxVisibleOrNot()
    {
        if(visibleOrNot1 == true){
            COOPLabel = '- Visible COOP';
        }
        if(visibleOrNot1 == false){
            COOPLabel = '- Non Visible COOP';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot2()
    {
        if(visibleOrNot2 == true){
            MDFLabel = '- Visible MDF';
        }
        if(visibleOrNot2 == false){
            MDFLabel = '- Non Visible MDF';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot3()
    {
        if(visibleOrNot3 == true){
            iMDFLabel = '- Visible iMDF';
        }
        if(visibleOrNot3 == false){
            iMDFLabel = '- Non Visible iMDF';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot4()
    {
        if(visibleOrNot4 == true){
            SVMLabel = '- Visible SVM';
        }
        if(visibleOrNot4 == false){
            SVMLabel = '- Non Visible SVM';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot5()
    {
        if(visibleOrNot5 == true){
            IPPLabel = '- Visible IPP';
        }
        if(visibleOrNot5 == false){
            IPPLabel = '- Non Visible IPP';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot6()
    {
        if(visibleOrNot6 == true){
            NationalLabel = '- Visible National Retail';
        }
        if(visibleOrNot6 == false){
            NationalLabel = '- Non Visible National Retail';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot7()
    {
        if(visibleOrNot7 == true){
            CSATLabel = '- Visible CSAT';
        }
        if(visibleOrNot7 == false){
            CSATLabel = '- Non Visible CSAT';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot8()
    {
        if(visibleOrNot8 == true){
            QPLabel = '- Visible QP';
        }
        if(visibleOrNot8 == false){
            QPLabel = '- Non Visible QP';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot9()
    {
        if(visibleOrNot9 == true){
            TCLabel = '- Visible TC';
        }
        if(visibleOrNot9 == false){
            TCLabel = '- Non Visible TC';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot10()
    {
        if(visibleOrNot10 == true){
            ILWLabel = '- Visible ILW';
        }
        if(visibleOrNot10 == false){
            ILWLabel = '- Non Visible ILW';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot11()
    {
        if(visibleOrNot11 == true){
            TDFLabel = '- Visible TDF';
        }
        if(visibleOrNot11 == false){
            TDFLabel = '- Non Visible TDF';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot12()
    {
        if(visibleOrNot12 == true){
            FeesLabel = '- Visible Fees';
        }
        if(visibleOrNot12 == false){
            FeesLabel = '- Non Visible Fees';
        }
        return null;
    }
    public pageReference setCheckBoxVisibleOrNot13()
    {
        if(visibleOrNot13 == true){
            NegotiationLabel = '- Visible Negotiation Buffer';
        }
        if(visibleOrNot13 == false){
            NegotiationLabel = '- Non Visible Negotiation Buffer';
        } 
        return null; 
    }

    public pageReference setCheckBoxVisibleOrNotSDF(){
        if(visibleOrNotSDF == true){
            SDFLabel = '- Visible SDF';
        }
        if(visibleOrNotSDF == false){
            SDFLabel = '- Non Visible SDF';
        } 
        return null; 
    }


   //jgarcia@levementum.com 9/18/2014. method to open the Attachments popup
  public void attachmentsPopUp(){
        attachmentsPopUpShow = true;
  }
  //jgarcia@levementum.com 9/18/2014. method to close the Attachments popup
    public PageReference closeAttachmentsPopUp(){
        attachmentsPopUpShow = false;
        return null;
    }

    public Attachment a {get{
        if(a == null)
            a = new Attachment();
            return a;
        } set;}
   
  //jgarcia@levementum.com. 9/8/2014. Method to Uplaod Attachments to Deal
  public PageReference upload() {

    //recId = ApexPages.currentPage().getParameters().get('qId');
    system.debug('recId ' + recId);
    a.OwnerId = UserInfo.getUserId();
    a.ParentId = recId; // the record the file is attached to
    a.IsPrivate = true;
   
    try {
      insert a;
      a = new Attachment();
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
    return null;
    } 

    getAttachments();
    attachmentsPopUpShow = false;
    return null;
  }

  public pageReference approvalProcess(){
    system.debug('Approval Fired');
    system.debug('recId ' + recId);
    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
    try{
        // Create an approval request for the Quote
    req1.setComments('Submitting request for approval.');
    req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});
    system.debug('req1 ' + req1);
    req1.setObjectId(recId);

    // Submit the approval request for the Quote
    Approval.ProcessResult result = Approval.process(req1);
    }catch(DMLException e){
        if(recId != null)
        {
            String message = ' The following fields are required: ';
            Quote q = [SELECT hasSummary__c, hasStopLight__c, hasExecutiveSummary__c from Quote where id =: recId limit 1];
            if(q != null)
            {
                if(q.hasSummary__c == False)
                {
                    message += 'Has Summary, ';
                }
                if(q.hasExecutiveSummary__c == False)
                {
                    message += 'Has Executive Summary, ';
                }
                if(q.hasStopLight__c == False)
                {
                    message += 'Has Stop Light.';
                }
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'This deal does not meet the approval criteria.  Please try again, once the criteria has been met.' + message));
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'An error has ocurred. Please contact your administrator.'));
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO, 'This deal does not meet the approval criteria.  Please try again, once the criteria has been met.'));
        }
        return null;
    }

    currentUrl.setRedirect(true);
    return currentUrl;
    
    }

    public pageReference acceptWorkItem(){
        try
        {
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Approved.');
            req2.setAction('Approve');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            
            // Use the ID from the newly created item to specify the item to be worked
            req2.setWorkitemId(workItems[0].Id);
            
            // Submit the request for Approve
            Approval.ProcessResult result2 =  Approval.process(req2);
    
            currentUrl.setRedirect(true);
        }
        catch(Exception ex){}
    return currentUrl;
    }

    public pageReference rejectWorkItem(){
        try
        {
            Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
            req2.setComments('Rejected.');
            req2.setAction('Reject');
            req2.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            
            // Use the ID from the newly created item to specify the item to be worked
            req2.setWorkitemId(workItems[0].Id);
            
            // Submit the request for Reject
            Approval.ProcessResult result2 =  Approval.process(req2);
    
            currentUrl.setRedirect(true);
        }
        catch(Exception ex){}
    return currentUrl;
    }
    
    public pageReference recallProcess(){
        try
        {
            Approval.ProcessWorkitemRequest req3 = new Approval.ProcessWorkitemRequest();
            req3.setAction('Removed');
            
            // Use the ID from the newly created item to specify the item to be worked
            req3.setWorkitemId(workItems[0].Id);
            
            // Submit the request for Recall
            Approval.ProcessResult result3 =  Approval.process(req3);
    
            currentUrl.setRedirect(true);
        }
        catch(Exception ex){
            system.debug('ERROR' + ex.getMessage());
        }
    return currentUrl;
    }

    //jgarcia@levementum.com 9/18/2014. method to open the notes popup
    public void notesPopUp(){
        notesPopUpShow = true;
        note = new Note();
        editModeNote = false;
        //parameter pass via ajax. this will help to know if this is a new note or an existing one
        string noteId=Apexpages.currentPage().getParameters().get('noteId');
        string Editable=Apexpages.currentPage().getParameters().get('Editable');
        system.debug('Editable ' + Editable);
        if(noteId != null){

            if(Editable != null){
                editModeNote = true;
                system.debug(editModeNote);
            }
            //if an existing note, then run query to bring all of its info and populate the popup with it
            note = [SELECT Body, Title, IsPrivate, CreatedById, CreatedDate, ParentId FROM Note WHERE Id =: noteId];
            note.title = note.title;
            note.body = note.body;
            note.IsPrivate = note.IsPrivate;
        }
    }

    //jgarcia@levementum.com 9/18/2014. method to close the notes popup
    public void closenotesPopUp(){
        notesPopUpShow = false;
    }

    //jgarcia@levementum.com 9/18/2014. method to save a notes 
    public void saveNote(){
        try
        {
            //if note already exist, update it with the new chages from the popup, else create the new note
            if(note.parentId != null){
                update note;
                
            }else{
                note.parentId = recId;
                note.OwnerId = UserInfo.getUserId();
                insert note; //insert the record
            }
    
            notesPopUpShow = false;//close the popup after save
            note = new Note();//empty the note so the popup is ready for a new one
            getNotes();//function to bring all of the notes related to the quote after rerender the notes tab
        }
        catch(Exception ex){}
    }

    //jgarcia@levementum.com 9/18/2014. function to bring all of the notes related to the quote after rerender the notes tab and 
    //is also called on the constructor 
    public List<Note> getNotes(){

        availableNotes = new List<Note>();
        availableNotes = [SELECT Body, Title, IsPrivate, CreatedById, CreatedDate FROM Note WHERE ParentId =: recId AND (NOT Title LIKE '%Executive Summary%')];
        
        if(thisQuote != null)
        {
            if(thisQuote.Id != null)
            {
                notesExecSummary = [SELECT Body, Title, CreatedDate, Owner.FirstName, Owner.LastName FROM Note Where ParentId = :thisQuote.Id and Title LIKE '%Executive Summary%' ORDER BY CreatedDate];
                summaryNotes =[SELECT Body, Title, CreatedDate, Owner.FirstName, Owner.LastName FROM Note Where ParentId = :thisQuote.Id AND (NOT Title LIKE '%Executive Summary%') ORDER BY CreatedDate DESC];
            }
        }
        
               
        checkNotesRendering();
        
        //t = Math.Random() + ' ';
        return availableNotes;
    }
    
    public void checkNotesRendering()
    {
        isExecNotes = true;
        isSummaryNotes = true;
        if(summaryExecNotes.size() <= 0)
        {
            isExecNotes = false;
        }
        
        if(summaryNotes.size() <= 0)
        {
            isSummaryNotes = false;
        }
    }
    
    /**
    * @author: jescamilla@levementum.com 
    * @date: 9/18/14
    * @brief: Summary Notes Refresh Function
    */
    public pageReference refreshSummary(){ 
        summaryNotes = [SELECT Body, Title, CreatedDate, Owner.FirstName, Owner.LastName FROM Note Where ParentId = :thisQuote.Id AND (NOT Title LIKE '%Executive Summary%') ORDER BY CreatedDate DESC];
        notesExecSummary = [SELECT Body, Title, CreatedDate, Owner.FirstName, Owner.LastName FROM Note Where ParentId = :thisQuote.Id and Title LIKE '%Executive Summary%' ORDER BY CreatedDate];
        //feedbackMsg += '\n\n thisQuote: ' + JSON.serializePretty(thisQuote);    
        return null;
    }

    //jgarcia@levementum.com 9/18/2014. function to bring all of the attachments related to the quote after rerender the attachments tab and 
    //is also called on the constructor
    public List<Attachment> getAttachments(){
        //jgarcia@levementum.com 9/18/2014. Query to bring attachments related to this quote and display them in the Attachments Tab
        availableAttachments  = [SELECT Id, Body, BodyLength, ContentType, CreatedById, CreatedDate, IsDeleted, Description, Name, IsPartnerShared
                                ,LastModifiedById, LastModifiedDate, OwnerId, ParentId, IsPrivate, ConnectionReceivedId, ConnectionSentId, SystemModstamp 
                                    FROM Attachment WHERE ParentId = :qId];

        if(availableAttachments.size() > 0){
            hasAttachments = true;
            for(Attachment attachments : availableAttachments){
                
                    Date dToday = Date.today();
                    DateTime myDateTime = DateTime.newInstance(dToday.year(), dToday.month(),dToday.day());

                    //Calculate the difference between today and the date the attachment was created. If the difference is less than 1 day, Tab show be color green
                    Integer Days = Integer.valueOf((myDateTime.getTime() - attachments.CreatedDate.getTime())/(1000*60*60*24));

                    system.debug('Today ' + dToday);
                    system.debug('attachments.CreatedDate ' + attachments.CreatedDate);
                    system.debug('Days ' + Days);

                    if(Days == 0){
        
                        hasNewAttachments = true;
                    }
                    
                    system.debug('availableAttachments ' + availableAttachments);
            }
        }else{
        hasAttachments = false;
        }
        return availableAttachments;
    }

    public PageReference editExecutiveSummaryNote(){
        editExecutiveSummaryNote = false;
        return null;
    }

    public PageReference SaveExecutiveSummaryNote(){
        editExecutiveSummaryNote = true;
        update thisQuote;
        
        return null;
    }


    
    public class ExecutiveNoteWrapper
    {
        public Quote q {get; set;}
        public User u {get; set;}
        
        public ExecutiveNoteWrapper(Quote q, User u)
        {
            this.q = q;
            this.u = u;
        }
    }

    public class ProductQueueWrapper
    {
        public PricebookEntry pbe {get; set;}
        public Integer year {get; set;}
        public String quarter {get; set;}
        public Boolean remove {get; set;}
        public ProductQueueWrapper(PricebookEntry pbe, Integer year, String quarter)
        {
            this.pbe = pbe;
            this.year = year;
            this.quarter = quarter;
            this.remove = false;
        }
    }
}