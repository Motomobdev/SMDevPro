public with sharing class Z_ProductSelector {

        // ------------------------------------------------------------------------
        // --- Public Constants ---
        // ------------------------------------------------------------------------
        
        /* Pagination for the select table for products */
        public final static Integer PRODUCT_TABLE_PAGE_SIZE = 10;
        
        
        /* Pagination for the select table for rate plans */
        public final static Integer RATEPLAN_TABLE_PAGE_SIZE = 10;
        

        // ------------------------------------------------------------------------
        // --- Public VF Attributes ---
        // ------------------------------------------------------------------------

        /* Boolean to render the main form if init successful */
        public Boolean initSuccess { get; set; }
        
        
        /* The quote context */
        public zqu__Quote__c quote { get; set; }
        
        
        /* Query String for product search */
        public String productSearchString { get; set; }
        
        
        /* Product List to display */
        public List<zqu__ZProduct__c> productList {
                get {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                        return productSet.getRecords();
                }
                set;
        }
        
        
        /* Product set to display (with pagination) */
        public ApexPages.StandardSetController productSet { get; set; }
        
        
        /* Product section info */
        public String productSectionInfo {
                get {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                        Integer upperProduct = 0;
                        
                        if (productSet.getPageNumber() * productSet.getPageSize() < productSet.getResultSize())
                                upperProduct = productSet.getPageNumber() * productSet.getPageSize();
                        else
                                upperProduct = productSet.getResultSize();
                        
                        return 'Showing ' + ((productSet.getPageNumber() - 1) * productSet.getPageSize() + 1)
                                        + ' to ' + upperProduct + ' of ' + productSet.getResultSize();
                }
                set;
        }
        
        
        /* Product pagination previous */
        public Boolean productHasPrevious {
                get {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'CumulativeFrom__c', 'CumulativeTo__c', 'Prepaid__c'};
                
                        return productSet.getHasPrevious();
                }
                set;
        }
        
        
        /* Product pagination next */
        public Boolean productHasNext {
                get {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'CumulativeFrom__c', 'CumulativeTo__c', 'Prepaid__c'};
                
                        return productSet.getHasNext();
                }
                set;
        }
        
        
        /* Product ID (SFDC) selected */
        public String selProductId { get; set; }
        
        
        /* Rate Plan List to display */
        public List<zqu__ProductRatePlan__c> ratePlanList {
                get {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                        if (ratePlanSet != null) {
                                return ratePlanSet.getRecords();
                        }
                        return null;
                }
                set;
        }
        
        
        /* Rate plan set to display (with pagination) */
        public ApexPages.StandardSetController ratePlanSet { get; set; }
        
        
        /* Rate Plan section info */
        public String ratePlanSectionInfo {
                get {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                        Integer upperRatePlan = 0;
                        
                        if (ratePlanSet.getPageNumber() * ratePlanSet.getPageSize() < ratePlanSet.getResultSize())
                                upperRatePlan = ratePlanSet.getPageNumber() * ratePlanSet.getPageSize();
                        else
                                upperRatePlan = ratePlanSet.getResultSize();
                                
                        return 'Showing ' + ((ratePlanSet.getPageNumber() - 1) * ratePlanSet.getPageSize() + 1)
                                        + ' to ' + upperRatePlan + ' of ' + ratePlanSet.getResultSize();
                }
                set;
        }
        
        
        /* Rate Plan pagination previous */
        public Boolean ratePlanHasPrevious {
                get {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                        return ratePlanSet.getHasPrevious();
                }
                set;
        }
        
        
        /* Product pagination next */
        public Boolean ratePlanHasNext {
                get {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                        return ratePlanSet.getHasNext();
                }
                set;
        }
        
        
        /* Rate Plan ID (SFDC) selected */
        public String selRatePlanId { get; set; }
        
        
        /* Boolean to indicate to render the rate plan panel */
        public Boolean showRatePlan { get; set; }
        
        /* Boolean to indicate if the prepaid column should be shown */
        public Boolean showPrepaid { get;set; }
        
        /* Rate Plan search string */
        public String ratePlanSearchString { get; set; }
        
        
        /* Boolean to indicate to render the quote charge panel */
        public Boolean showChargeGroup { get; set; }
        
        
        /* The charge group for the selected rate plan */
        public zqu.ZChargeGroup chargeGroup { 
        	get; 
        	set;
        }
        
        
		/* For prepaid picklist*/
		public List<SelectOption> prepaidOptions;
		/* For input field updates*/
        public String changedCharge {get;set;}

        // ------------------------------------------------------------------------
        // --- Private Attributes ---
        // ------------------------------------------------------------------------
        
        /* Standard Controller for context validation */
        private ApexPages.StandardController controller;
        
        /* For Application picklist */
        public String chosenApplication {get; set;}
		private List<Application__c> applications;
		public String ApplicationName, ApplicationNumber;
		
        
        // ------------------------------------------------------------------------
        // --- Public Methods ---
        // ------------------------------------------------------------------------
        
        /**
         *        Constructor
         */
        public Z_ProductSelector(ApexPages.StandardController stdController) {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                // First, do not display the form
                initSuccess = false;
                
                this.controller = stdController;
                
                if (!validate())
                        return;
                
                refreshProducts();
                
                showRatePlan = false;
                
                showChargeGroup = false;
                
                initSuccess = true;
                
                
        }
        
        
        
        
        /**
         *        Refresh products in the catalog
         */
        public void refreshProducts() {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                // Retrieve the list of product to query
                List<Id> productIds = getFilteredZProductIds(
                        quote.zqu__Currency__c,
                        quote.zqu__StartDate__c
                );
                
                // Filter this initial list if a search is entered
                if (String.isNotBlank(productSearchString)) {
                        productIds = searchProducts(productIds, quote.zqu__StartDate__c);
                }
                
                // Get the list of product to display
                productSet = new ApexPages.StandardSetController([
                        SELECT
                                Name,
                                zqu__SKU__c,
                                zqu__Description__c
                        FROM
                                zqu__ZProduct__c
                        WHERE
                                Id IN :productIds
                        ORDER BY
                                TECH_Display__c DESC, Name ASC
                ]);
                
                productSet.setPageSize(PRODUCT_TABLE_PAGE_SIZE);
                
                // Don't display the rate plan panel
                showRatePlan = false;
                
                showChargeGroup = false;
                
                // Refresh the selected product
                selProductId = '';
                
                System.debug('SelRatePlanId = ' + selRatePlanId);
                
        }
        
        
        /**
         *        Move the product set forward (next page)
         */
        public void nextProductPage() {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                if (productSet.getHasNext()) {
                        productSet.next();
                }
                
        }
        
        
        /**
         *        Move the product set backward (previous page)
         */
        public void previousProductPage() {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                if (productSet.getHasPrevious()) {
                        productSet.previous();
                }
                
        }
        
        
        /**
         *        Refresh the rate plans panel
         */
        public void refreshRatePlans() {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                // Get the IDs for all the product rate plans corresponding
                List<Id> ratePlanIds = getFilteredRatePlanIds(
                        selProductId,
                        quote.zqu__Currency__c,
                        quote.zqu__StartDate__c
                );
                
                // Filter this initial list if a search is entered
                if (String.isNotBlank(ratePlanSearchString)) {
                        ratePlanIds = searchRatePlans(ratePlanIds, quote.zqu__StartDate__c);
                }
                
                // Get the list of rate plan to display
                ratePlanSet = new ApexPages.StandardSetController([
                        SELECT
                                Name,
                                zqu__Description__c
                        FROM
                                zqu__ProductRatePlan__c
                        WHERE
                                Id IN :ratePlanIds
                        ORDER BY
                                Name ASC
                ]);
                
                ratePlanSet.setPageSize(RATEPLAN_TABLE_PAGE_SIZE);
                
                showRatePlan = true;
                
                showChargeGroup = false;
                
                // Make sure no rate plan is selected
                selRatePlanId = '';
                
                
        }
        
        
        /**
         *        Move the rate plan set forward (next page)
         */
        public void nextRatePlanPage() {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c',  'ApplicationNumber__c','CumulativeFrom__c', 'CumulativeTo__c', 'Prepaid__c'};
                
                if (ratePlanSet.getHasNext()) {
                        ratePlanSet.next();
                }
                
        }
        
        
        /**
         *        Move the product set backward (previous page)
         */
        public void previousRatePlanPage() {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                if (ratePlanSet.getHasPrevious()) {
                        ratePlanSet.previous();
                }
                
        }
        
        
        /**
         *        Refresh the charge group panel
         */
        public void refreshChargeGroup() {
                
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                chargeGroup = zqu.ZQuoteUtil.getChargeGroup(quote.Id, selRatePlanId);
                
                
            List<zqu__ProductRatePlan__c> prodRatePlan = new List<zqu__ProductRatePlan__c>();
            prodRatePlan = [SELECT Prepaid__c FROM zqu__ProductRatePlan__c Where Id =: selRatePlanId];
        	System.Debug('Prod Rate Plans size: ' + prodRatePlan.size());
        	if(prodRatePlan.size()>0){
        		System.Debug('Prod Rate Plan Val: '+ String.valueOf(prodRatePlan[0].Prepaid__c));
        		String prepaidFlag = ''; 
        		prepaidFlag = String.valueOf(prodRatePlan[0].Prepaid__c);
        		if(prepaidFlag!=null){
        			if(prepaidFlag.equalsIgnoreCase('Yes')){
	        			System.Debug('prepaid val equals yes');
	        			showPrepaid = true;
	        			System.Debug('Show Prepaid val: ' + showPrepaid);
        			}
        		} else {
        			showPrepaid = false;
        		}
        	}
                
                showChargeGroup = true;
                
        }
        
        
        // --- Methods called by JS onChange ---

        /**
         * On discount change
         */
        public void discountChange() {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnDiscountChange(
                        chargeGroup.zCharges
                );
                chargeGroup.zCharges = charges;
        }
        
        
        /**
         * On quantity change
         */
        public void quantityChange() {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnQuantityChange(
                        chargeGroup.zCharges
                );
                chargeGroup.zCharges = charges;
        }
        
        
        /**
         * On effective price change
         */
        /*public void effectiveChange() {
                
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                for(zqu.zCharge charge :  chargeGroup.zCharges ){
                	System.debug('Current Effective Price Value : '+charge.EFFECTIVE_PRICE);
                	Decimal effPrice = Decimal.valueOf(charge.EFFECTIVE_PRICE);
    				effPrice = effPrice.setScale(4, RoundingMode.HALF_UP);
    				charge.EFFECTIVE_PRICE = String.ValueOf(effPrice);
    				
                	System.debug('New Current Effective Price Value : '+charge.EFFECTIVE_PRICE);
                }
                
                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnEffectivePriceChange(
                        chargeGroup.zCharges
                );
                chargeGroup.zCharges = charges;
                
                System.Debug('calling defaultCumulationVal; changed charge is: '+ changedCharge);
                if (changedCharge != null){
                	defaultCumulationVal();
                }
        }*/
        
        
        /**
         * On total price change
         */
        public void totalChange() {
 
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                               
                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnTotalChange(
                        chargeGroup.zCharges
                );
                chargeGroup.zCharges = charges;
        }


        /**
         *        Save the charge groups to the quote
         */
        public PageReference saveCharges() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                System.debug('Product Selector save called');
                
                Boolean allowSave = true;
                
                //Create Map<String, zCharge> of old zcharges, using PRODUCT_RATE_PLAN_CHARGE_SFDC_ID as key
                Map<String, zqu.zCharge> oldCharges = new Map<String, zqu.zCharge>();
                for (zqu.zCharge currCharge : chargeGroup.zCharges) {
                	Decimal effPrice = (Decimal)currCharge.chargeObject.get('EffectivePrice_Display__c');
		    		
                	if (effPrice == null || 
                		currCharge.chargeObject.get('CumulativeFrom__c') == null ||
                		currCharge.chargeObject.get('CumulativeFrom__c') == null ){
                		appendMessage(ApexPages.Severity.ERROR,
                						'You must fill out all Cumulation and Price values before saving the charge.');
                		allowSave = false;
                	}
                	//chargeGroup.zCharges.get(currCharge.Id).ApplicationId__c = chosenApplication;
                	//chargeGroup.zCharges.get(currCharge.Id).ApplicationName__c =[SELECT Name From Application__c WHERE Id =: chosenApplication][0].Name;
                	//System.Debug('Curr Charge test : '+currCharge.chargeObject.get('CumulativeFrom__c')+', ID: '+currCharge.Id);
                	if(effPrice == null || effPrice == 0){
		    			effPrice = 0;
		    			currCharge.EFFECTIVE_PRICE = '0.0';
		    		} else {
		    			currCharge.EFFECTIVE_PRICE = String.valueOf(effPrice);
		    		}
                	System.debug('Price Check: '+ currCharge.EFFECTIVE_PRICE);
                	oldCharges.put(currCharge.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID,currCharge);
                }
                
                // Add the charges to the quote
                if(allowSave){
	                try {
	                        List<zqu.ZChargeGroup> chargeGroupAdded = zqu.ZQuoteUtil.addChargeGroups(
	                                new List<zqu.ZChargeGroup> { chargeGroup }
	                        );
	                } catch (zqu.ZQException e) {
	                        appendMessage(ApexPages.Severity.ERROR, e.getMessage());
	                        return null;
	                }
	                // Get back to the quote
	                PageReference pageRef = new PageReference('/' + quote.Id);
	                return pageRef;
                } else {
                	return null;
                }
                
                
        }


        /**
         *        Save the charge groups and return to the product selector
         */
        public PageReference saveAndNewCharges() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                Boolean allowSave = true;
                for (zqu.zCharge currCharge : chargeGroup.zCharges) {
                	Decimal effPrice = (Decimal)currCharge.chargeObject.get('EffectivePrice_Display__c');
		    		
                	if (effPrice == null || 
                		currCharge.chargeObject.get('CumulativeFrom__c') == null ||
                		currCharge.chargeObject.get('CumulativeFrom__c') == null ){
                		appendMessage(ApexPages.Severity.ERROR,
                						'You must fill out all Cumulation and Price values before saving the charge.');
                		allowSave = false;
                	}
                }
                // Add the charges to the quote
                if(allowSave){
	              try {
                        List<zqu.ZChargeGroup> chargeGroupAdded = zqu.ZQuoteUtil.addChargeGroups(
                                new List<zqu.ZChargeGroup> { chargeGroup }
                        );
	                } catch (zqu.ZQException e) {
	                        appendMessage(ApexPages.Severity.ERROR, e.getMessage());
	                        return null;
	                }
                	 // Get back to the quote
	                PageReference pageRef = Page.Z_ProductSelector;
	                pageRef.getParameters().put('Id', quote.Id);
	                pageRef.setRedirect(true);
	                
	                return pageRef;
                } else {
                	return null;
                }

               
        }


        /**
         *        Note – This function is ONLY used from the Z_EditCharges VF page and will
         *        add a charge group to it.
         */
        public PageReference addGroup() {
				System.debug('Now we add a new charge Group');
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
            	
                Boolean allowSave = true;
                
            	for(zqu.zCharge charge : chargeGroup.zCharges){
            		System.debug('Application Name value: '+ charge.chargeObject.get('ApplicationName__c'));
            		System.debug('Application Id value: '+ charge.chargeObject.get('ApplicationId__c'));
            		System.debug('Effective Price value: '+ charge.EFFECTIVE_PRICE);
                	Decimal effPrice = (Decimal)charge.chargeObject.get('EffectivePrice_Display__c');
            		
            		if (effPrice == null || 
                		charge.chargeObject.get('CumulativeFrom__c') == null ||
                		charge.chargeObject.get('CumulativeFrom__c') == null ){
                		appendMessage(ApexPages.Severity.ERROR,
                						'You must fill out all Cumulation and Price values before saving the charge.');
                		//appendMessage(ApexPages.Severity.INFO, 'The application name and Id are: ' +charge.chargeObject.get('ApplicationName__c')+', '+charge.chargeObject.get('ApplicationId__c') );
                		allowSave = false;
                	}
            		 
            	}
                // Add the charges to the quote
                if(allowSave){
	              try {
	                        List<zqu.ZChargeGroup> chargeGroupAdded = zqu.ZQuoteUtil.addChargeGroups(
	                                new List<zqu.ZChargeGroup> { chargeGroup }
	                               
	                        );
	                } catch (zqu.ZQException e) {
	                        appendMessage(ApexPages.Severity.ERROR, e.getMessage());
	                        return null;
	                }
                
	                for(zqu.zCharge charge : chargeGroup.zCharges){
	            		System.debug('Effective Price value: '+ charge.EFFECTIVE_PRICE);
	            		System.debug('Charge id: '+charge.Id);
	            		System.debug('Charge SFDC ID: '+charge.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID);
	            		System.debug('Charge Zuora ID: '+charge.PRODUCT_RATE_PLAN_CHARGE_ZUORA_ID);
	            		//System.debug('Charge Zuora id: '+charge.zqu__ProductRatePlanChargeZuoraId__c);
	            	}
	                System.debug('Charge Group rateplan ID: ' + chargeGroup.productRateplanZuoraID);
	                System.debug('Charge group id: '+ chargeGroup.groupID);
	                // Get back to the quote
	                PageReference pageRef = Page.Z_EditCharges;
	                pageRef.getParameters().put('id', quote.Id);
	                pageRef.setRedirect(true);
	                
	                
	                return pageRef;
	                
                } else {
                	return null;
                }
	                

        }
        
        
        
        // ------------------------------------------------------------------------
        // --- Private Methods ---
        // ------------------------------------------------------------------------
        
        /**
         * Display an error message back to the VF page
         */
        private static void appendMessage(ApexPages.Severity severity, String message) {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                ApexPages.addMessage(new ApexPages.Message(severity, message));
        }
        
        
        /**
         *        Validate the context
         */
        private Boolean validate() {
                
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                if (null == controller.getRecord() || null == controller.getRecord().Id) {
                        appendMessage(ApexPages.Severity.ERROR,
                                        'Need to specify the quote id to select products');
                        return false;
                }
                
                ID quoteId = controller.getRecord().Id;
                
                // Query the quote (for the context)
                List<zqu__Quote__c> quoteList = [
                        SELECT
                                Name,
                                zqu__Currency__c,
                                zqu__Status__c,
                                zqu__StartDate__c
                        FROM
                                zqu__Quote__c
                        WHERE
                                Id = :quoteId
                ];
                
                if (1 != quoteList.size()) {
                        appendMessage(ApexPages.Severity.ERROR,
                                        'No quote found with the ID passed in parameter');
                        return false;
                }
                
                this.quote = quoteList[0];
                
                return true;
        }
        
        
        /**
         * Return the list of IDs from product found by the search
         */
        private List <Id> searchProducts(List <Id> prodids, Date zqStartDate) {
                
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                List <Id> productIds = new List <Id>();
                
                try {
                        String searchQuery = '*' + productSearchString + '*';
                        
                        searchQuery = 'FIND \'' + searchQuery + '\' IN ALL FIELDS RETURNING '
                                        + 'zqu__zProduct__c(Id, Name, zqu__SKU__c, zqu__Description__c, '
                                        + 'zqu__ZuoraId__c WHERE id in :prodids AND zqu__Deleted__c = false '
                                        + 'AND zqu__EffectiveStartDate__c <= :zQStartDate AND '
                                        +'zqu__EffectiveEndDate__c >= :zQStartDate ORDER BY Name ASC)';
                        
                        List < SObject > results = search.query(searchQuery)[0];
                        
                        for (SObject sobj: results) {
                                productIds.add(sobj.Id);
                        }
                        
                } catch (Exception e) {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                        ApexPages.addMessage(msg);
                }
                return productIds;
        }
        
        
        /**
         * Filter the product list
         */
        private List < Id > getFilteredZProductIds(String zCurrency, Date zStartDate) {
                
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                List < zqu__ZProduct__c > products;
                
                AggregateResult[] groupedResults = [
                        SELECT
                                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.Id
                        FROM
                                zqu__ProductRatePlanChargeTier__c
                        WHERE
                                zqu__Currency__c = : zCurrency
                        AND
                                zqu__Deleted__c = false
                        		
                        GROUP BY
                                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.Id
                ];

                List < Id > productIds = new List < Id > ();
                
                for (AggregateResult result: groupedResults) {
                        productIds.add(result.Id);
                }

                String baseSoql = 'SELECT Id FROM zqu__ZProduct__c WHERE Id IN :productIds '
                                + 'AND zqu__Deleted__c = false AND zqu__EffectiveStartDate__c <= :zStartDate '
                                + 'AND zqu__EffectiveEndDate__c >= :zStartDate ';
                
                //baseSoql += productFilterFragment;
                baseSoql += ' ORDER BY zqu__SKU__c DESC LIMIT 10000 ';
                
                System.debug('#### soql query = ' + baseSoql);

                products = Database.query(baseSoql);
                productIds = new List < Id > ();
                
                for (zqu__zProduct__c product: products) {
                        productIds.add(product.Id);
                }

                return productIds;
        }
        
        
        /**
         * Return the list of IDs from rate plan found by the search
         */
        private List <Id> searchRatePlans(List <Id> rpIds, Date zqStartDate) {
                
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                List <Id> ratePlanIds = new List <Id>();
                
                try {
                        String searchQuery = '*' + ratePlanSearchString + '*';
                        
                        searchQuery = 'FIND \'' + searchQuery + '\' IN ALL FIELDS RETURNING '
                                        + 'zqu__ProductRatePlan__c(Id, Name, zqu__Description__c, '
                                        + 'zqu__ZuoraId__c WHERE id in :rpIds AND zqu__Deleted__c = false '
                                        + 'AND zqu__EffectiveStartDate__c <= :zQStartDate AND '
                                        +'zqu__EffectiveEndDate__c >= :zQStartDate ORDER BY Name ASC)';
                        
                        List < SObject > results = search.query(searchQuery)[0];
                        
                        for (SObject sobj: results) {
                                ratePlanIds.add(sobj.Id);
                        }
                        
                } catch (Exception e) {
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
                        ApexPages.addMessage(msg);
                }
                
                return ratePlanIds;
        }
         
        
        /**
         * Return the list of filtered product rate plan Ids
         */
        private List < Id > getFilteredRatePlanIds(Id zProductId, String zCurrency, Date zStartDate) {
            
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                AggregateResult[] groupedResults = [
                        SELECT
                                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.Id
                        FROM
                                zqu__ProductRatePlanChargeTier__c
                        WHERE
                                zqu__Currency__c = : zCurrency
                        AND
                                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.zqu__zProduct__r.Id = : zProductID
                        GROUP BY
                                zqu__ProductRatePlanCharge__r.zqu__ProductRatePlan__r.Id
                ];
                
                List < ID > ratePlanIds = new List < ID > ();
                
                for (AggregateResult gr: groupedResults) {
                        ratePlanIds.add(gr.Id);
                }

                String baseSoql = 'SELECT Id FROM zqu__ProductRatePlan__c WHERE Id IN :ratePlanIds '
                                + 'AND zqu__Deleted__c = false AND zqu__EffectiveStartDate__c <= :zStartDate '
                                + 'AND zqu__EffectiveEndDate__c >= :zStartDate ';
                                
                //baseSoql += rateplanFilterFragment;
                baseSoql += ' ORDER BY Name ASC LIMIT 10000 ';

                List < zqu__ProductRatePlan__c > ratePlans = Database.query(baseSoql);
                ratePlanIds = new List < Id > ();
                
                for (zqu__ProductRatePlan__c ratePlan: ratePlans) {
                        ratePlanIds.add(ratePlan.Id);
                }
                
                System.debug('##### Retrieved ' + ratePlanIds.size() + ' rate plan(s)');

                return ratePlanIds;
        }
        
        /*For Application Picklist */
        public List<selectOption> getapplications() {
        	System.Debug('Get Application Ids');
        	this.applications = new List<Application__c>();
        	String ID = ApexPages.currentPage().getParameters().get('id');
        	System.Debug('Id pulled from page: '+ID);
                /*if (ID != null){
	                System.Debug('Getting Owner Id');
	                String OwnerId = [Select OwnerId From zqu__Quote__c Where Id = :ID][0].OwnerId;
	                System.Debug('Retrieved Owner Id: '+OwnerId);
	                if (!(OwnerId == null)){
				        this.applications = [SELECT Application_Id__c, Id, Name FROM Application__c WHERE OwnerId =: OwnerId];
	                }
                }*/
	        List<selectOption> options = new List<selectOption>(); 
	        if(ID != null) {					//!(this.applications.size()>0)
	        	String OppId, ContractId, ContractNum;
	        	List<zqu__Quote__c> quoteOppIds = [Select zqu__Opportunity__c From zqu__Quote__c Where Id =: ID];
	        	if(quoteOppIds.size()>0){
					OppId = quoteOppIds[0].zqu__Opportunity__c;
	        	}
	        	System.Debug('Opportunity Id: '+OppId);
	        	List<Opportunity> oppContractIds = [Select Contract__c From Opportunity Where Id =: OppId];
	        	if(oppContractIds.size()>0){
					ContractId = oppContractIds[0].Contract__c; 
	        	}
	        	System.Debug('Contract Id: '+ContractId);
	        	List<Contract> Contracts = [Select ContractNumber From Contract Where Id =: ContractId];
	        	if(Contracts.size()>0){
					ContractNum = Contracts[0].ContractNumber;
	        	}
	        	System.Debug('Contract Number: '+ContractNum);
	        	if(ContractNum != null){
					this.applications = [Select Application_Id__c, Id, Name From Application__c Where Application_Contract_Number__c =: ContractNum];
	        	}
	        	System.Debug('Num Apps: '+applications.size());
			}
		//new list for holding all of the picklist options
			options.add(new selectOption('','   - None -   '));
			if(this.applications.size()>0){
				for (Application__c application : this.applications){
					options.add(new selectOption(application.Id, application.Name));
				}
			}
			
			return options;
		}
		
		
        /*For Application Picklist */
        public PageReference setApplicationValues(){
        	System.Debug('setApplicationValues Called');
        	ApexPages.currentPage().getParameters().put('AppId',chosenApplication);
        	        	
        	return ApexPages.currentPage();
              
        }
        
        public List<SelectOption> getprepaid(){   
	        prepaidOptions = new List<SelectOption>();
	        	// Use DescribeFieldResult object to retrieve prepaid field.
	        Schema.DescribeFieldResult prepaidFieldDescription = zqu__QuoteCharge__c.Prepaid__c.getDescribe();
	
			System.Debug('Get Prepaid called');
	
	        // For each picklist value, create a new select option
	        for (Schema.Picklistentry picklistEntry:prepaidFieldDescription.getPicklistValues()){
	
	            prepaidOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
	
	        }
	        
	        return prepaidOptions;   
        }
        
        
}