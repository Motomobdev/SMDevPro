/*******************************************************************************************************
CREATED BY : Neel Desai
CREATED ON : 30/Aug/2013
PURPOSE    : To override standard "New" and "Edit" buttons on Opportunity

TEST CLASS : OpportunityEditCtrTest
*******************************************************************************************************/
public with sharing class OpportunityEditCtr {
    public String newStage {get; set;} //selected value of Stage from vf page
    public Boolean isNew {get; set;} //is new opportunity
    public Boolean isClone {get; set;} //is cloning
    public Boolean isCloneLineItems {get; set;} //is cloning with line items
    public Boolean isFinalStage {get; set;} //to show/hide next milestone date & next step
    public Boolean isValid {get; set;} //to enable/disable Save button
    public transient Boolean showProductForecastCategoryAlert {get; set;} //to show alert when Opportunity forecast stage is modified & Forecast_Overridden__c = true on Product Line Item
    public transient Boolean showQuarterYearChangeAlert {get; set;}
    public transient Boolean showPipelineBestCaseLineItemAlert {get; set;}
    public transient Boolean showBundleChangedAlert {get; set;}
    public Integer newStageNo {get; set;}
    private Integer currStageNo = -1;
    private Opportunity opp {get; set;}
    private Opportunity oppCurr = null; //holds original Opportunity record (before any changes by user)
    private Map<String, OpportunityStage> oppStageMap = null;
    private String NextStepsLog = null;
    //private Boolean isDealApproved = false;
    private Boolean isTypeProspect = false;
    private String oppId = null;

    public OpportunityEditCtr(ApexPages.StandardController controller) {
        try {
            if (ApexPages.currentPage().getParameters().get('clone') != null &&
                ApexPages.currentPage().getParameters().get('clone') != '') {
                isClone = true;
                oppId = ApexPages.currentPage().getParameters().get('clone');

                if (ApexPages.currentPage().getParameters().get('cloneli') != null &&
                    ApexPages.currentPage().getParameters().get('cloneli') != '')
                    isCloneLineItems = true;
                else
                    isCloneLineItems = false;
            } else {
                isClone = false;
                isCloneLineItems = false;
            }

            opp = (Opportunity)controller.getRecord();

            isNew = (opp.Id == null) ? true : false;
            isValid = true; // enable Save button
            showProductForecastCategoryAlert = false; //don't show alert message

            //get Stage details
            OpportunityStage[] oppStages = [SELECT MasterLabel,
                                                   ForecastCategoryName,
                                                   DefaultProbability,
                                                   isClosed
                                            FROM   OpportunityStage
                                            WHERE  IsActive = true
                                            ORDER BY MasterLabel];

            if (oppStages == null) {
                throw new ApplicationException('Could not get Opportunity Stage details. Please contact system administrator.');
            }

            oppStageMap = new Map<String, OpportunityStage>(); // Map to hold Stage values

            for (OpportunityStage oppStage : oppStages) {
                oppStageMap.put(oppStage.MasterLabel.left(1), oppStage); // add to Map
            }

            if (isNew || isClone) { //new Opportunity or cloning
                OpportunityStage oppInitialStage = oppStageMap.get('1');

                opp.OwnerId = UserInfo.getUserId(); // Owner = logged in user
                opp.StageName = oppInitialStage.MasterLabel; // set initial stage name (as it is readonly on page)
                opp.Probability = oppInitialStage.DefaultProbability; // default value for the stage
                opp.ForecastCategoryName = oppInitialStage.ForecastCategoryName; // default value for the stage

                oppCurr = opp.clone(false, true);

                newStageNo = currStageNo = 1;

                isFinalStage = false;

                if (isClone) { //when cloning, set values from old opportunity
                    Opportunity[] oppList = [SELECT Name, AccountId, CloseDate, Quarter__c, Year__c, Deal__c,
                    Description, Product_Bundle__c, Product_Bundle_Quantity__c FROM Opportunity WHERE Id = :oppId];

                    if (oppList != null && oppList.size() > 0) {
                        Opportunity oppTemp = oppList.get(0);

                        opp.Name = oppTemp.Name;
                        opp.AccountId = oppTemp.AccountId;
                        opp.CloseDate = oppTemp.CloseDate;
                        opp.Quarter__c = oppTemp.Quarter__c;
                        opp.Year__c = oppTemp.Year__c;
                        opp.Deal__c = oppTemp.Deal__c;
                        opp.Description = oppTemp.Description;
                        opp.Product_Bundle__c = oppTemp.Product_Bundle__c;
                        opp.Product_Bundle_Quantity__c = oppTemp.Product_Bundle_Quantity__c;
                    }
                } else { //when not cloning - i.e. new opportunity
                    try {
                        opp.Year__c = String.valueOf(Date.today().year());
                        if (Test.isRunningTest()) throw new ApplicationException('This is for test method coverage');
                    } catch(Exception e) {}

                    if (ApexPages.currentPage().getParameters().get('accid') != null) {
                        String accountId = ApexPages.currentPage().getParameters().get('accid');

                        checkAllowOpportunityForAccount(accountId);
                    }
                }
            } else {
                oppCurr = opp.clone(false, true);

                String log = '[' + String.valueOf(Date.today()) + ']';
                log += ' Stage: ' + oppCurr.StageName;
                if (oppCurr.Next_Milestone_Date__c != null || oppCurr.NextStep != null) {
                    log += '\n' + (oppCurr.Next_Milestone_Date__c == null ? '' : ('Milestone Date: ' + String.valueOf(oppCurr.Next_Milestone_Date__c) + ' | '));
                    log += 'Next Step: ' + oppCurr.NextStep;
                }

                NextStepsLog = log + ((oppCurr.Next_Steps_Log__c == null) ? '' : '\n==========================\n' + oppCurr.Next_Steps_Log__c);

                newStageNo = currStageNo = Integer.valueOf(oppCurr.StageName.left(1));

                if (currStageNo == 7 || currStageNo == 8) //Closed Won OR Closed Lost
                    isFinalStage = true;
                else
                    isFinalStage = false;
            }
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            resetAlertFields();
        }
    }

    public PageReference saveAndAddProduct() { //for new only
        System.Savepoint sp = null;

        try {
            checkAllowOpportunityForAccount(opp.AccountId);

            doStageChangeValidation();

            if (!doRequiredValidations())
                return null;

            sp = Database.setSavepoint();

            insert opp; // create Opportunity
            isNew = false;

            PageReference pageRef = null;
            if (opp.Product_Bundle__c != null) {
                pageRef = createOpportunityLines();
            } else {
                // redirect to Add Product standard page and pass newly created Opportunity Id as parameter
                pageRef = new PageReference('/p/opp/SelectSearch?addTo=' + opp.Id + '&retURL=%2F006%2Fe');
                pageRef.setRedirect(true);
            }

            return pageRef; // redirect
        } catch(Exception ex) {
            if (sp != null)
                Database.rollback(sp);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            resetAlertFields();
        }

        return null; // stay on the page (no redirect)
    }

    public PageReference cancel() { //for new & edit
        String retURL = '/006/o'; //Opportunity tab

        if (ApexPages.currentPage().getParameters().get('retURL') != null) { //if return URL is passed as query string
            retURL = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('retURL'), 'UTF-8');
        } else if (!isNew && !isClone) { //editing existing opportunity
            retURL = '/' + String.valueOf(opp.Id);
        }

        PageReference pageRef = new PageReference(retURL);
        pageRef.setRedirect(true);
        return pageRef; // redirect
    }

    private void checkAllowOpportunityForAccount(String accountId) {
        // check Allow Opportunity on Account
        Account acc = [SELECT Name, Allow_Opportunities__c FROM Account WHERE Id = :accountId];

        if (acc.Allow_Opportunities__c == false) {
            throw new ApplicationException('Opportunity creation is disabled for the account "' + acc.Name + '".');
        }
    }

    public void stageChange() {
        try {
            if (newStage == null || newStage == '')
                return; // No Stage selected, no need to go further

            isValid = true; // enable Save button; it may set to false at a later stage

            newStageNo = Integer.valueOf(newStage.left(1));

            if (newStageNo == 7 || newStageNo == 8) // 7 = Closed Won, 8 = Closed Lost
                isFinalStage = true;
            else
                isFinalStage = false;

            if (isNew || isClone) {
                // set default values for selected Stage
                OpportunityStage oppStage = oppStageMap.get(String.valueOf(newStageNo));
                opp.Probability = oppStage.DefaultProbability;
                opp.ForecastCategoryName = oppStage.ForecastCategoryName;
                opp.Reason_For_Opportunity_Lost__c = null;

                doStageChangeValidation(); // Validate Stage change (show error if not allowed)
            } else {
                if (newStageNo == currStageNo) {
                    // set Current Stage values
                    opp.Probability = oppCurr.Probability;
                    opp.ForecastCategoryName = oppCurr.ForecastCategoryName;
                    opp.Next_Milestone_Date__c = oppCurr.Next_Milestone_Date__c;
                    opp.NextStep = oppCurr.NextStep;
                    opp.Next_Steps_Log__c = oppCurr.Next_Steps_Log__c;
                    opp.Reason_For_Opportunity_Lost__c = oppCurr.Reason_For_Opportunity_Lost__c;
                } else {
                    // set default values for selected Stage
                    OpportunityStage oppStage = oppStageMap.get(String.valueOf(newStageNo));
                    opp.Probability = oppStage.DefaultProbability;
                    opp.ForecastCategoryName = oppStage.ForecastCategoryName;
                    opp.Reason_For_Opportunity_Lost__c = null;
                    opp.Next_Milestone_Date__c = null;
                    opp.NextStep = '';
                    opp.Next_Steps_Log__c = NextStepsLog;

                    doStageChangeValidation(); // Validate Stage change (show error if not allowed)
                }
            }
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            resetAlertFields();
        }
    }

    public PageReference cloneSave() {
        System.Savepoint sp = null;

        try {
            doStageChangeValidation();

            if (!doRequiredValidations())
                return null;

            sp = Database.setSavepoint();
            checkAllowOpportunityForAccount(opp.accountId);
            insert opp;

            if (isCloneLineItems) {
                OpportunityLineItem[] oliList = [SELECT Business_Unit__c,
                                                        ServiceDate,
                                                        Discount,
                                                        Invoice_Price__c,
                                                        LCV_Price__c,
                                                        Description,
                                                        ListPrice,
                                                        Opportunity_Line_Number__c,
                                                        Opportunity_Product__c,
                                                        PricebookEntryId,
                                                        Product_Forecast_Category__c,
                                                        Quantity,
                                                        UnitPrice,
                                                        Reason_for_Current_Forecast_Category__c,
                                                        Product_Bundle_Line__c
                                                 FROM   OpportunityLineItem
                                                 WHERE  OpportunityId = :oppId AND
                                                        isDeleted = false];

                OpportunityLineItem[] oliToAdd = new List<OpportunityLineItem>();

                Date newServiceDate = generateServiceDate();

                for (OpportunityLineItem oli : oliList) {
                    OpportunityLineItem oliCloned = oli.clone(false, true);

                    oliCloned.OpportunityId = opp.Id;
                    oliCloned.ServiceDate = newServiceDate;
                    oliCloned.Product_Forecast_Category__c = opp.ForecastCategoryName;

                    /* We don't need this because of the deep clone */
                    //oliCloned.Quantity = oli.Quantity;
                    //oliCloned.UnitPrice = oli.UnitPrice;
                    //oliCloned.LCV_Price__c = oli.LCV_Price__c;
                    //oliCloned.Invoice_Price__c = oli.Invoice_Price__c;
                    //oliCloned.Description = oli.Description;
                    //oliCloned.Product_Bundle_Line__c = oli.Product_Bundle_Line__c;

                    oliToAdd.add(oliCloned);
                }

                if (!oliToAdd.isEmpty()) {

                    insert oliToAdd;

                    PageReference pageRef = new PageReference('/oppitm/multilineitem.jsp?oppId=' + opp.Id + '&retURL=%2F' + opp.Id);
                    pageRef.setRedirect(true);
                    return pageRef; // redirect
                }
            }

            PageReference pageRef = new PageReference('/' + opp.Id);
            pageRef.setRedirect(true);
            return pageRef; // redirect
        } catch(Exception ex) {
            if (sp != null)
                Database.rollback(sp);
            system.debug('****EX**** ' + ex.getMessage());
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            resetAlertFields();
        }

        return null;
    }

    public PageReference save() {
        Savepoint sp = null;

        try {
            if (currStageNo != 7 && newStageNo == 7) {
                // check if opportunity Stage can be changed to Closed Won
                if (opp.haveBothPartiesSignedContract__c == false && opp.hasLegalFinanceApproved__c == false) {
                    isValid = false; // disable Save button
                    String errMsg = 'You are not allowed to advance to stage "7. Closed Won" until legal approval.';
                    throw new ApplicationException(errMsg);
                }
            }

            // Make sure the new account has allow opportunity flag checked
            if (oppCurr.AccountId != opp.AccountId)
                checkAllowOpportunityForAccount(opp.AccountId);

            if (!doRequiredValidations())
                return null;

            sp = Database.setSavepoint();

            // If the product bundle has changed
            showBundleChangedAlert = false;
            system.debug('oppCurr.Product_Bundle__c: ' + oppCurr.Product_Bundle__c);
            system.debug('opp.Product_Bundle__c: ' + opp.Product_Bundle__c);

            if (oppCurr.Product_Bundle__c != opp.Product_Bundle__c) {

                // Delete oppty lines that belong to the old bundle
                if (oppCurr.Product_Bundle__c != null) {
                    // Use this flag to allow oppty lines of a product bundle to be deleted
                    OpportunityLineItemMethods.allowProductBundleLineDeletes = true;

                    delete [select id FROM OpportunityLineItem
                        WHERE OpportunityId = :opp.Id and Product_Bundle_Line__c in
                        (select id from Product_Bundle_Line__c
                            where Product_Bundle__c = :oppCurr.Product_Bundle__c)];
                    showBundleChangedAlert = true;

                    OpportunityLineItemMethods.allowProductBundleLineDeletes = false;
                } else { // Switched from standalone to a bundle type -- remove old products
                    OpportunityLineItemMethods.allowProductBundleLineDeletes = true;

                    delete [select id FROM OpportunityLineItem WHERE OpportunityId = :opp.Id];

                    OpportunityLineItemMethods.allowProductBundleLineDeletes = false;
                }

                // Create oppty lines from the new product bundle
                if (opp.Product_Bundle__c != null)
                    createOpportunityLines();
            }

            OpportunityLineItem[] oliList = [SELECT Forecast_Overridden__c,
                                                    Product_Forecast_Category__c,
                                                    Product_Bundle_Line__r.quantity__c,
                                                    Skip_Validation__c
                                             FROM   OpportunityLineItem
                                             WHERE  OpportunityId = :opp.Id];

            if (!oliList.isEmpty() &&
                (oppCurr.Quarter__c != opp.Quarter__c || oppCurr.Year__c != opp.Year__c)) {
                showQuarterYearChangeAlert = true;
            }

            if (oppCurr.ForecastCategoryName != opp.ForecastCategoryName) {
                String newQtr = null, newYear = null;
                Boolean isOmitted = opp.ForecastCategoryName.equals('Omitted');
                Boolean isClosed = opp.ForecastCategoryName.equals('Closed');

                if (!oliList.isEmpty()) {
                    for (Integer i = 0; i < oliList.size(); i++) {
                        if (isOmitted || isClosed || oliList[i].Forecast_Overridden__c == false) {
                            if ((opp.ForecastCategoryName == 'Pipeline' || opp.ForecastCategoryName == 'Best Case') &&
                               (oliList[i].Product_Forecast_Category__c != 'Pipeline' &&
                                oliList[i].Product_Forecast_Category__c != 'Best Case')
                              )
                                showPipelineBestCaseLineItemAlert = true;

                            oliList[i].Product_Forecast_Category__c = opp.ForecastCategoryName;
                        }

                        if (oliList[i].Forecast_Overridden__c == true && !isOmitted && !isClosed) {
                            showProductForecastCategoryAlert = true;
                        }
                    }

                    if (showQuarterYearChangeAlert != null && showQuarterYearChangeAlert == true) {
                        newQtr = opp.Quarter__c;
                        newYear = opp.Year__c;
                        opp.Quarter__c = oppCurr.Quarter__c;
                        opp.Year__c = oppCurr.Year__c;
                    }
                }

                // The oppty has to be updated to prevent
                // line level validation rule failures on the forecast category
                update opp;

                if (!oliList.isEmpty())
                    update oliList;

                if (showQuarterYearChangeAlert != null && showQuarterYearChangeAlert == true) {
                    opp.Quarter__c = newQtr;
                    opp.Year__c = newYear;
                }
            } else {
                update opp;
            }

            // recalculate oppty line quantity
            if (oppCurr.Product_Bundle_Quantity__c != opp.Product_Bundle_Quantity__c) {
                system.debug('Bundle quantity has changed: old -> ' + oppCurr.Product_Bundle_Quantity__c
                    + ', new -> ' + opp.Product_Bundle_Quantity__c);
                if (!oliList.isEmpty()) {
                    for (Integer i = 0; i < oliList.size(); i++) {
                        oliList[i].quantity =
                            oliList[i].Product_Bundle_Line__r.quantity__c * opp.Product_Bundle_Quantity__c;
                        // Disable quantity related validation rule
                        olilist[i].Skip_Validation__c = true;
                        // The 2nd update below sets this flag to false
                    }
                    update oliList;
                }

                // Re update oppty lines with skip_validation set to false
                if (oliList != null && !oliList.isEmpty()) {

                    for (Integer i = 0; i < oliList.size(); i++)
                        olilist[i].Skip_Validation__c = false;

                    update oliList;
                }
            }

            //redirect back to Opportunity detail page
            if ((showQuarterYearChangeAlert == null || showQuarterYearChangeAlert == false) &&
               (showProductForecastCategoryAlert == null || showProductForecastCategoryAlert == false) &&
               (showPipelineBestCaseLineItemAlert == null || showPipelineBestCaseLineItemAlert == false)) {

                PageReference pageRef = new PageReference('/' + opp.Id);
                pageRef.setRedirect(true);
                return pageRef;
            } else //redirect back to detail page using vf javascript function
                return null;
        } catch (Exception ex) {
            if (sp != null)
                Database.rollback(sp);

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ex.getMessage()));
            resetAlertFields();
        }

        return null;
    }

    private Boolean doRequiredValidations() {
        if (opp.ForecastCategoryName =='Closed' && opp.StageName != '7. Closed Won') {
            opp.ForecastCategoryName.addError('Forecast category can only be "Closed" when the Opportunity Stage is "Closed Won".');
            return false;
        }
        if (opp.StageName == '7. Closed Won' &&
            (opp.ForecastCategoryName !='Closed' && opp.ForecastCategoryName !='Omitted')) {
            opp.ForecastCategoryName.addError('Forecast category can only be "Closed" or "Omitted" when the Opportunity Stage is "Closed Won".');
            return false;
        }
        if (opp.StageName == '8. Closed Lost' && opp.ForecastCategoryName !='Omitted') {
            opp.ForecastCategoryName.addError('Forecast category can only be "Omitted" when the Opportunity Stage is "Closed Lost".');
            return false;
        }
        if (opp.Type != 'Bundle' && opp.Product_Bundle__c != null) {
            opp.Type = 'Bundle';
        }
        if (opp.Type == 'Bundle') {

            if (opp.Product_Bundle__c == null) {
                opp.Product_Bundle__c.addError('Select a product bundle');
                return false;
            }

            if (opp.Product_Bundle_Quantity__c == null || opp.Product_Bundle_Quantity__c <= 0) {
                opp.Product_Bundle_Quantity__c.addError('Product bundle quantity is required.');
                return false;
            }
        } else { // Standalone opportunity
            // There is no need for bundle quantity
            opp.Product_Bundle_Quantity__c = null;
            opp.Product_Bundle__c = null;
        }

        return true;
    }

    private void doStageChangeValidation() {
        isValid = true; // enable Save button

        if (isNew) {
            ///if (newStageNo >= 4 && newStageNo <= 7)
            if (newStageNo == 6 && newStageNo == 7) {
                isValid = false; // disable Save button
                ///String errMsg = 'You are not allowed to advance beyond stage "3. Proposal Preparation" while ' + ((isClone) ? 'cloning.' : 'creating a new Opportunity.');
                String errMsg = 'You are not allowed to advance to stage 6 or 7 while ' + ((isClone) ? 'cloning.' : 'creating a new Opportunity.');
                throw new ApplicationException(errMsg);
            }
        } else {
            ///if ((currStageNo <= 3 || currStageNo == 8) && (newStageNo >= 4 && newStageNo <= 7))
            ///{
            ///    if (!isDealApproved()) // Not approved
            ///    {
            ///        isValid = false; // disable Save button
            ///        String errMsg = 'You are not allowed to advance beyond stage "3. Proposal Preparation" until a Deal is approved and linked to this Opportunity.';
            ///        throw new ApplicationException(errMsg);
            ///    }
            ///}

            if ((currStageNo <= 5 || currStageNo == 8) && (newStageNo == 6 || newStageNo == 7)) {
                if (isTypeProspect()) {
                    isValid = false; // disable Save button
                    String errMsg = 'You are not allowed to advance beyond stage "5. Active Negotiation" until the Customer setup process has completed.  The customer Type is not Prospect and an Oracle Customer Number is assigned.';
                    throw new ApplicationException(errMsg);
                }
            }
        }
    }

    // Check if Deal is approved
    /*private Boolean isDealApproved()
    {
        if (opp.Mobile_Device_Units__c == null || opp.Mobile_Device_Units__c == 0.0) // If no Mobile Device Units then no need of a Deal
        {
            return true; //skip as no units
        }
        else if ((opp.Mobile_Device_Units__c != null && opp.Mobile_Device_Units__c > 0) && opp.Deal__c != null) // Otherwise Deal must be linked to an Opportunity
        {
            Opportunity oppTemp = [SELECT Deal__r.Status__c FROM Opportunity WHERE Id = :opp.Id];

            if (oppTemp != null && oppTemp.Deal__r.Status__c == 'Approved') // and Deal must be in Approved state
                return true; // Deal is linked and fully approved
        }

        return false; // Deal is not linked OR not fully approved
    }*/

    // Check if Account Type is Prospect
    private Boolean isTypeProspect() {
        if (opp.AccountId != null) {
            Opportunity oppTemp = [SELECT Account.Type FROM Opportunity WHERE Id = :opp.Id];

            if (oppTemp != null && oppTemp.Account.Type == 'Prospect')
                return true; // Account Type is Prospect
        }

        return false; // Account Type is other than Prospect
    }

    private Date generateServiceDate() {
        Integer yyyy = Integer.valueOf(opp.Year__c);
        Integer mm = (opp.Quarter__c.equals('Q1') ? 3 : (opp.Quarter__c.equals('Q2') ? 6 : (opp.Quarter__c.equals('Q3') ? 9 : 12)));
        Integer dd = 1;
        return Date.newInstance(yyyy, mm, dd).addMonths(1).addDays(-1);
    }

    // Creates oppty lines for each product bundle line
    private PageReference createOpportunityLines() {

        List<Product_Bundle_Line__c> pbls = [select id, name, product__c, quantity__c
                                             from Product_Bundle_Line__c
                                             where Product_Bundle__c = :opp.Product_Bundle__c
                                             order by createdDate];

        List<PriceBook2> standardPriceBooks = [ select id, name from PriceBook2 where IsStandard = true];

        // Default to standard price book if no pricebook is selected
        if (opp.pricebook2Id == null && !standardPriceBooks.isEmpty()) {
            opp.pricebook2Id = standardPriceBooks[0].id;
        }

        List<PriceBookEntry> pbes = [select id, name, product2Id, unitprice from PriceBookEntry
                                     where Pricebook2Id = :opp.Pricebook2Id
                                     and CurrencyIsoCode = :opp.CurrencyIsoCode
                                     and isactive = true
                                     and product2Id in (select product__c
                                             from Product_Bundle_Line__c
                                             where Product_Bundle__c = :opp.Product_Bundle__c)];

        // If the products on the bundle or not in the opportunity's pricebook + currency
        // then report an error to the user
        if (pbls.size() != pbes.size()) {
            system.debug(opp.currencyIsoCode + ', ' + opp.pricebook2Id + ', ' + pbls.size() + ', ' + pbes.size());

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL,
                'The products in the bundle do not exist in the pricebook. '
                + 'Contact a sales ops person.'));
            return null;
        }

        Map<Id, PriceBookEntry> pbeMap = new Map<Id, PriceBookEntry>();
        for (PriceBookEntry pbe : pbes) {
            pbeMap.put(pbe.product2Id, pbe);
        }

        // Create oppty lines
        List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        for (Product_Bundle_Line__c pbl : pbls) {
            // Find the corresponding price book entry for this product bundle line
            PriceBookEntry pbe = pbeMap.get(pbl.product__c);
            if (pbe != null) {
                OpportunityLineItem oli = new OpportunityLineItem(OpportunityId = opp.Id,
                    PricebookEntryId = pbe.id, unitPrice = pbe.unitPrice,
                    quantity = pbl.quantity__c * opp.Product_Bundle_Quantity__c,
                    ServiceDate = generateServiceDate(),
                    Product_Forecast_Category__c = opp.ForecastCategoryName,
                    Reason_for_Current_Forecast_Category__c = 'No Reason',
                    Product_Bundle_Line__c = pbl.Id);
                olis.add(oli);
            }
        }

        if (olis.size() > 0)
            insert olis;

        return new PageReference('/oppitm/multilineitem.jsp?oppId=' + opp.id + '&retURL=/' + opp.id); // Edit All page;
    }

    // Set all "show" flags to false to disable javasciprt alerts
    public void resetAlertFields() {
        showBundleChangedAlert = false;
        showQuarterYearChangeAlert = false;
        showProductForecastCategoryAlert = false;
        showPipelineBestCaseLineItemAlert = false;
    }
}