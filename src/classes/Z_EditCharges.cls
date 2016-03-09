public with sharing class Z_EditCharges {

        // ------------------------------------------------------------------------
        // --- Public VF Attributes ---
        // ------------------------------------------------------------------------

        /* Initialization successful (after validation) */
        public Boolean initSuccess { get; set; }


        /* The quote context */
        public zqu__Quote__c quote { get; set; }


        /* The list of quote amendments associated to the quote */
        public List<zqu__QuoteAmendment__c> quoteAmendmentList { get; set; }


        /* Boolean to indicate if we should display the product catalog */
        public Boolean displayProductCatalog { get; set; }


        /* Get which quote amendment to undo from the VF page */
        public Id quoteAmendmentToUndo { get; set; }


        /* The charge group list on the quote */
        public List<zqu.ZChargeGroup> chargeGroupList { 
        		get; 
        		set;
		}


        /* The charge group that we are working on */
        public String selectedChargeGroup { 
    		get; 
    		set;
    	}


        /* Enumeration to know which state the charge group is in */
        public enum EditMode { NO_EDIT, PARTIAL, FULL }


        /* Map to know which group is in which mode, the second parameter is the
        string value for the ENUM since VisualForce component can't access ENUM */
        public Map<String, String> groupEditMap { get; set; }


        /* To be added to the quote charge group */
        public zqu.ZChargeGroup toBeAddedChargeGroup { get; set; }


        /* For Application picklist */
        public String chosenApplication {get; set;}
		private List<Application__c> applications;
		public String ApplicationName, ApplicationNumber;
        

        // ------------------------------------------------------------------------
        // --- Private Attributes ---
        // ------------------------------------------------------------------------

        /* The controller passed in parameter */
        private ApexPages.StandardController controller;


        /* The map of quote amendments, to avoid querying multiple times */
        private Map<Id, zqu__QuoteAmendment__c> quoteAmendmentMap { get; set; }


        // ------------------------------------------------------------------------
        // --- Public Methods ---
        // ------------------------------------------------------------------------

        /**
         *        Constructor
         */
        public Z_EditCharges(ApexPages.StandardController controller) {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                        	
                // Save the controller in attribute (for validation)
                this.controller = controller;

                // Before validation
                initSuccess = false;

                // Don't display the product catalog initially
                displayProductCatalog = false;

                // Validate the context
                if (!validate())
                        return;

                initSuccess = true;

        }


        /**
         * On load (DML operations here)
         */
        public void onLoad() {
			
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
               // List<Zuora__SubscriptionProductCharge__c> preExistingCharges = getSubscriptionCharge();
                
                // If any, update the charge group
                if (String.isNotBlank(ApexPages.currentPage().getParameters().get('selected'))) {
                        System.debug('##### Trying to refresh ' + ApexPages.currentPage().getParameters().get('selected'));
                        for (zqu.ZChargeGroup cg : chargeGroupList) {
                                if (cg.groupId == ApexPages.currentPage().getParameters().get('selected')) {
                                        zqu.zQuoteUtil.updateChargeGroup(cg);
                                }
                        }
                }
                system.debug('OnLoad called for Z_Edit Charges');
                system.debug('Charge group list value:'+chargeGroupList);
                system.debug('Current quote: '+quote.Id);
                String OppId = [Select zqu__Opportunity__c from zqu__Quote__c where id=:quote.Id limit 1].zqu__Opportunity__c;
                Map<String,Zuora__SubscriptionProductCharge__c> preExistingCharges = getSubscriptionCharges(OppId);
              
                for (zqu.ZChargeGroup cg : chargeGroupList){
                	//Trying to update charge groups via subscription product/charges
                    for(zqu.zCharge charge : cg.zCharges){
                    	System.debug('Charge\'s quote rateplancharge z-id: '+charge.getQuoteRatePlanChargeZuoraId());
                    	String ZuoraId = charge.getQuoteRatePlanChargeZuoraId();
                    	Zuora__SubscriptionProductCharge__c existingCharge = preExistingCharges.get(ZuoraId);
                    	system.debug('Currently Existing Charge: '+existingCharge);
                    	system.debug('Product Rate Plan Charge Id val: '+charge.PRODUCT_RATE_PLAN_CHARGE_ZUORA_ID);
                    	system.debug('Product Rate Plan Charge SFDC Id val: '+charge.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID);
                    	//system.debug('Charge ZuoraID val: '+charge.chargeObject.get('zqu__ZuoraId__c'));
                    	if(existingCharge != null){//existingCharge.getQuoteRatePlanChargeZuoraId() ){
  							system.debug('Existing Charge found, lets reassign some values');
  							charge.chargeObject.put('ApplicationId__c',existingCharge.ApplicationId__c);
  							charge.chargeObject.put('ApplicationName__c',existingCharge.ApplicationName__c);
  							charge.chargeObject.put('ApplicationNumber__c',existingCharge.ApplicationNumber__c);
  							charge.chargeObject.put('CumulativeFrom__c',existingCharge.CumulativeFrom__c);
  							charge.chargeObject.put('CumulativeTo__c',existingCharge.CumulativeTo__c);
  							charge.chargeObject.put('Prepaid__c',existingCharge.Prepaid__c);
  							charge.chargeObject.put('EffectivePrice_Display__c',existingCharge.Zuora__Price__c);
						}
                    }
                }

                refreshAmendmentList();

        }
        /**
         * 		  Get Subscription product charges to repopulate the charge data for amendments
         */
		public static Map<String,Zuora__SubscriptionProductCharge__c> getSubscriptionCharges(String OppId){
			List<Opportunity> Opps = new List<Opportunity>();
			Opps = [SELECT Id, Name, AccountId 
					FROM Opportunity
					WHERE Id=:OppId];
			String AccountId;
			if(Opps.size()>0){
				AccountId = Opps[0].AccountId;
			}
			
			if (AccountId == null){
				appendMessage(ApexPages.Severity.ERROR,
                						'No Account could be retrieved.');
			}
        	system.debug('Account Id: '+AccountId);
	        List<Zuora__Subscription__c> subscriptions = new List<Zuora__Subscription__c>();
	        
	        subscriptions = [SELECT id, Zuora__Account__c 
	          FROM Zuora__Subscription__c
	          WHERE Zuora__Account__c = :AccountId]; 
	        
	        List<Id> subIds = new List<Id>();
	        
	        for(Zuora__Subscription__c sub : subscriptions){
	            subIds.add(sub.Id);
	        }
	        List<Zuora__SubscriptionProductCharge__c>chargeList = [SELECT 
	        														   Id, 
	        														   Zuora__Zuora_Id__c,  
	        														   ApplicationId__c, 
	        														   ApplicationName__c,
	        														   ApplicationNumber__c, 
	        														   ContractNumber__c,
	        														   CumulativeFrom__c,
	        														   CumulativeTo__c,
	        														   Prepaid__c,
	        														   Zuora__Price__c
	            												 FROM  Zuora__SubscriptionProductCharge__c
	            												 WHERE Zuora__Subscription__c IN :subIds]; //a1Le0000000e5VKEAY
	        Map<String,Zuora__SubscriptionProductCharge__c> charges = new Map<String,Zuora__SubscriptionProductCharge__c>();
	        for(Zuora__SubscriptionProductCharge__c SPcharge : chargeList){
	        	charges.put(SPcharge.Zuora__Zuora_Id__c,SPcharge );
	        }
	        system.debug('Map\'s keyset: '+charges.keyset());
	        return charges;
	    }

        /**
         *        Display the product catalog
         */
        public void doDisplayProductCatalog() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                displayProductCatalog = true;

        }


        /**
         *        Cancel display product catalog
         */
        public void cancelDisplayProductCatalog() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                displayProductCatalog = false;

        }


        /**
         *        Undo an amendment in DRAFT mode (not yet sent to Z-Billing)
         */
        public PageReference undoAmendment() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                        	
                System.debug('##### Trying to undo the quote amendment ID = ' + quoteAmendmentToUndo);

                // Get the amendment type
                String amendmentType = quoteAmendmentMap.get(quoteAmendmentToUndo).zqu__Type__c;

                // Retrieve the quote rate plan that correspond to the amendment
                List<zqu__QuoteRatePlan__c> quoteRatePlanList = [
                        SELECT
                                Name,
                                zqu__ProductRatePlanZuoraId__c,
                                zqu__SubscriptionRatePlanZuoraId__c
                        FROM
                                zqu__QuoteRatePlan__c
                        WHERE
                                zqu__QuoteAmendment__c = :quoteAmendmentToUndo
                ];

                // Test what we retrieved at least one quote rate plan
                if (quoteRatePlanList.size() == 0) {
                        // abort
                        appendMessage(ApexPages.Severity.ERROR, 'An error occurred while undoing the '
                                + 'quote amendment. Please contact your administrator.');
                        return null;
                }

                // Condition because the ZChargeGroup.groupId is different if it's of type 
                // Add Product or Update/Remove Product
                if (amendmentType == 'NewProduct') {

                        System.debug('##### This is an amendment of type New Product');

                        // Get the quote rate plan ID since it's an Add Product amendment
                        String quoteRatePlanId = quoteRatePlanList[0].Id;

                        // Loop through the charge group and remove the one corresponding
                        for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                                if (chargeGroup.groupId == quoteRatePlanId) {
                                        // Undo this amendment
                                        zqu.ZQuoteUtil.deleteChargeGroup(chargeGroup);
                                        break;
                                }
                        }

                } else if (amendmentType == 'UpdateProduct' || amendmentType == 'RemoveProduct') {

                        System.debug('##### This is an amendment of type Update/Remove Product');

                        // Get the subscription rate plan ID since it's an Update/Remove Product amendment
                        String subscriptionRatePlanId = quoteRatePlanList[0].zqu__SubscriptionRatePlanZuoraId__c;

                        // Loop through the charge group and remove the one corresponding
                        for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                                if (chargeGroup.groupId == subscriptionRatePlanId) {
                                        // Undo this amendment
                                        zqu.ZQuoteUtil.deleteChargeGroup(chargeGroup);
                                        break;
                                }
                        }

                }

                // Display success message
                appendMessage(ApexPages.Severity.CONFIRM,
                        'You successfuly removed the amendment from the quote');

                // Need to refresh the page because of "uncommitted work pending"
                PageReference pageRef = Page.Z_EditCharges;
                pageRef.getParameters().put('id', quote.Id);
                pageRef.setRedirect(true);

                return pageRef;
        }


        /**
         *        Delete the given charge group
         */
        public PageReference deleteGroup() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                System.System.debug('##### Trying to delete the charge group ' + selectedChargeGroup);

                // appendMessage(ApexPages.Severity.INFO, Trying to delete the charge group ' + selectedChargeGroup);
			
                for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                        if (chargeGroup.groupId == selectedChargeGroup) {
                                // Delete the charge group
                                
								deleteChargeGroups(new List<zqu.ZChargeGroup> { chargeGroup });
                              //  zqu.ZQuoteUtil.deleteChargeGroups(new List<zqu.ZChargeGroup> { chargeGroup } );
                                break;
                        }
                }
			
                // Need to refresh the page because of "uncommitted work pending"
                PageReference pageRef = Page.Z_EditCharges;
                pageRef.getParameters().put('id', quote.Id);
                pageRef.setRedirect(true);
			
                return pageRef;
        }
        
        /* NOTE(chudy): It looks like this is the standard ZQU method in the manage
		 * package for deleting ChargeGroupWrappers. 
		 * @param {List<zqu.ChargeGroup>} cgs The chargegroups we will be removing
		 *   via this method.
		 */
			public void deleteChargeGroups(List<zqu.zChargeGroup> cgs){
			
			/* NOTE(chudy): Null check first. */
			if(!cgs.isEmpty()) {
				
				/* NOTE(chudy): Zuora package throws an exception when trying to
				 * delete a rate plan that does not have a recurring charge. This
				 * is a known bug. This code attempts a standard delete. We catch
				 * the exception with this code and create a remove product 
				 * amendment with the custom method removeChargeGroup() below. */
				try {
					
					/* NOTE(chudy): This does not update the quote charge summary.
		    		 * Fitzgerald said this is not necessary for the delete. */
		    		 
		    		/* NOTE(chudy): Remove the first element of this list and call
		    		 * function recursively until all chargegroups have been 
		    		 * removed via amendments. */
		    		zqu.zChargeGroup deletedChargeGroup = 
		    			zqu.zQuoteUtil.deleteChargeGroup(cgs[0]);
		    		
		    		/* NOTE(chudy): Do not fully understand this. But for charges
		    		 * that have some sort of quantity associated with it, Zuora
		    		 * only decrements by 1 instead of deleting all of it as 
		    		 * explained by Maks. We control for this in next statement. 
		    		 * More info on groupTypes can be found here: 
		    		 * http://knowledgecenter.zuora.com/C_Zuora_User_Guides/
		    		 * B_Commerce/Zuora_for_Salesforce/E_Z-Force_Builder/
		    		 * B_Component_Library/H_Global_Classes/A_zChargeGroup_Class */
		    		if( cgs[0].groupType == 5 && deletedChargeGroup.groupType == 3 ){
						cgs[0] = deletedChargeGroup;
					} else {
						cgs.remove(0);
					}
		    		deleteChargeGroups(cgs);
		    	} catch (zqu.ZQException e) {
		    		/* NOTE(chudy): Print to debug log for error verification. */
		    		System.debug( '##### Caught error while deleting charge group = ' 
		    			+ cgs[0] );
		    			
		    		/* NOTE(chudy): Call our exception method to manually create
		    		 * a remove product amendment for this charge group */
		    		removeChargeGroup(cgs[0]);
		    		
		    		/* NOTE(chudy): Once the charge group that triggered this 
		    		 * exception is passed onto the exception method, continue
		    		 * recursive execution until all chargegroups have been
		    		 * removed via amendments. */
		    		cgs.remove(0);
		    		deleteChargeGroups(cgs);
		    		
		    		/* NOTE(chudy): Add message to page for debugging purposes. 
		    		 * TODO(chudy/ceda): Once confidence achieved in solution we
		    		 * can remove this. */
		    		ApexPages.addMessage(
		    			new ApexPages.Message(
		    			ApexPages.Severity.ERROR, e.getMessage()));
		    	}
			}
		}
		
		/* NOTE(chudy): Custom method that manually creates remove product 
		 * amendments
		 * @param {zqu.ZChargeGroup} cgToRemove The single chargegroup we 
		 *   are removing. */
		 public void removeChargeGroup(zqu.ZChargeGroup cgToRemove) {
		 	zqu__QuoteAmendment__c quoteAmendment = new zqu__QuoteAmendment__c();
		 	quoteAmendment.Name = quote.Name;
		 	quoteAmendment.zqu__Description__c = 'Removed ' 
		 		+ cgToRemove.productName + ', ' + cgToRemove.ratePlanName;
		 	quoteAmendment.zqu__Status__c = 'Draft';
		 	quoteAmendment.zqu__Type__c = 'RemoveProduct';
		 	quoteAmendment.zqu__Quote__c = quote.Id;
		 	insert quoteAmendment;
		
			zqu__QuoteRatePlan__c quoteRatePlan = new zqu__QuoteRatePlan__c();
			quoteRatePlan.Name = cgToRemove.ratePlanName;
			quoteRatePlan.zqu__AmendmentType__c = 'RemoveProduct';
			quoteRatePlan.zqu__ProductRatePlanZuoraId__c = cgToRemove.productRatePlanZuoraID;
			quoteRatePlan.zqu__Quote__c = quote.Id;
			quoteRatePlan.zqu__QuoteAmendment__c = quoteAmendment.Id;
			quoteRatePlan.zqu__QuoteProductName__c = cgToRemove.productName;
			quoteRatePlan.zqu__SubscriptionRatePlanZuoraId__c = cgToRemove.groupId;
			insert quoteRatePlan;
		}


        /**
         *        Undelete the given charge group
         */
        public PageReference unDeleteGroup() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                System.System.debug('##### Trying to undelete the charge group ' + selectedChargeGroup);

                // appendMessage(ApexPages.Severity.INFO, Trying to undelete the charge group ' + selectedChargeGroup);

                for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                        if (chargeGroup.groupId == selectedChargeGroup) {
                                // Delete the charge group
                                zqu.ZQuoteUtil.deleteChargeGroups(new List<zqu.ZChargeGroup> { chargeGroup } );
                                break;
                        }
                }

                // Need to refresh the page because of "uncommitted work pending"
                PageReference pageRef = Page.Z_EditCharges;
                pageRef.getParameters().put('id', quote.Id);
                pageRef.setRedirect(true);

                return pageRef;
        }


        /**
         *        Edit the given charge group
         */
        public void editGroup() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                System.debug('#### Before ' + groupEditMap);

                // Cancel all editing mode for all the other charge group
                for (String groupId : groupEditMap.keySet()) {
                        groupEditMap.put(groupId, EditMode.NO_EDIT.name());
                }

                // Reload the charge groups from the DB
                chargeGroupList = zqu.ZQuoteUtil.getChargeGroups(quote.Id);

                System.debug('#### After ' + groupEditMap);

                for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                        // For the selected charge group
                        if (chargeGroup.groupId == selectedChargeGroup) {
                                // If it's a newly added product, we can edit every field (discount, list price, etc.)
                                if (chargeGroup.groupType == zqu.ZChargeGroup.TYPE_AMENDMENT_NEWPRODUCT) {
                                        groupEditMap.put(selectedChargeGroup, EditMode.FULL.name());
                                }
                                // Else, it's an original/updated product, we can only edit the quantity
                                else {
                                        groupEditMap.put(selectedChargeGroup, EditMode.PARTIAL.name());
                                }
                                break;
                        }
                }

                System.debug('Changed edit mode to ' + groupEditMap.get(selectedChargeGroup)
                        + ' for group ID = ' + selectedChargeGroup);

        }


        /**
         *        Cancel edit charge group
         */
        public void cancelEditGroup() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                        	
                // Cancel all editing mode for all the other charge group
                for (String groupId : groupEditMap.keySet()) {
                        groupEditMap.put(groupId, EditMode.NO_EDIT.name());
                }

                // Reload the charge groups from the DB
                chargeGroupList = zqu.ZQuoteUtil.getChargeGroups(quote.Id);

        }


       /**
         *        Save edited chage group
         */
        public PageReference saveGroup() {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                //appendMessage(ApexPages.Severity.INFO, 'Selected charge group = ' + selectedChargeGroup);
				System.Debug('Edit charges controller save called.');
                zqu.ZChargeGroup cg = null;

                // Retrieve the selected charge group
                for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                        if (chargeGroup.groupId == selectedChargeGroup) {
                                zqu.ZQuoteUtil.updateChargeGroup(chargeGroup);
                                break;
                        }
                }

                //updateQuoteAmendmentTotal(quote.Id, selectedChargeGroup);

                // Need to refresh the page because of "uncommitted work pending"
                PageReference pageRef = Page.Z_EditCharges;
                pageRef.getParameters().put('id', quote.Id);
                pageRef.getParameters().put('selected', selectedChargeGroup);
                pageRef.setRedirect(true);

                return pageRef;
        }


        /**
         *        Update charge group on discount change
         */
        public void onDiscountChange() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                // Retrieve the charge group
                for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                        if (chargeGroup.groupId == selectedChargeGroup) {
                                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnDiscountChange(
                                        chargeGroup.zCharges
                                );
                                chargeGroup.zCharges = charges;
                        }
                }
                
        }


        /**
         *        Update charge group on quantity change
         */
        public void onQuantityChange() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                // Retrieve the charge group
                for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                        if (chargeGroup.groupId == selectedChargeGroup) {
                                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnQuantityChange(
                                        chargeGroup.zCharges
                                );
                                chargeGroup.zCharges = charges;
                        }
                }

        }


        /**
         *        Update charge group on effective price change
         */
        public void onEffectivePriceChange() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                system.debug('Effective price change called in z_editcharges');
                
                // Retrieve the charge group
                for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                        if (chargeGroup.groupId == selectedChargeGroup) {
                                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnEffectivePriceChange(
                                        chargeGroup.zCharges
                                );
                                chargeGroup.zCharges = charges;
                        }
                }

        }


        /**
         *        Update charge group on total change
         */
        public void onTotalChange() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'CumulativeFrom__c', 'CumulativeTo__c', 'Prepaid__c'};
                
                // Retrieve the charge group
                for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                        if (chargeGroup.groupId == selectedChargeGroup) {
                                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnTotalChange(
                                        chargeGroup.zCharges
                                );
                                chargeGroup.zCharges = charges;

                        }
                }

        }


        // ------------------------------------------------------------------------
        // --- Private Methods ---
        // ------------------------------------------------------------------------

        /**
         *        Display an error message back to the VF page
         */
        private static void appendMessage(ApexPages.Severity severity, String message) {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                ApexPages.addMessage(new ApexPages.Message(severity, message));
        }


        /**
         *        Validate the quote context
         */
        private Boolean validate() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                // Validate that we are passing an ID in parameter
                if (null == controller.getRecord() || null == controller.getRecord().Id) {
                        appendMessage(ApexPages.Severity.ERROR,
                                        'Need to specify the quote id to edit the subscription charges');
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
                
                // Validate that we retrieved the quote
                if (1 != quoteList.size()) {
                        appendMessage(ApexPages.Severity.ERROR,
                                        'No quote found with the ID passed in parameter');
                        return false;
                }
                
                this.quote = quoteList[0];

                // Refresh amendment
                refreshAmendmentList();        

                // Get the charge group
                chargeGroupList = zqu.ZQuoteUtil.getChargeGroups(quote.Id);

                // Instantiate the map wich everything in not edit mode at first
                groupEditMap = new Map<String, String>();

                for (zqu.ZChargeGroup chargeGroup : chargeGroupList) {
                        groupEditMap.put(chargeGroup.groupId, EditMode.NO_EDIT.name());
                }

                // Initialization successful
                return true;
        }
 

        /**
         *        Refresh the quote amendment list (for the changes vs. Original section)
         */
        private void refreshAmendmentList() {

                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
                
                // Retrieve the list of amendments associated with the quote
                quoteAmendmentList = [
                        SELECT
                                zqu__Description__c,
                                zqu__TotalAmount__c,
                                zqu__DeltaMRR__c,
                                zqu__Type__c,
                                zqu__DeltaTCV__c
                        FROM
                                zqu__QuoteAmendment__c
                        WHERE
                                zqu__Quote__c = :quote.Id
                ];

                // Set up the map
                quoteAmendmentMap = new Map<Id, zqu__QuoteAmendment__c>(quoteAmendmentList);

        }
        
        /*For Application Picklist*/ 
        public List<selectOption> getapplications() {
        	System.Debug('Get Application Ids');
        	this.applications = new List<Application__c>();
        	String ID;
        	if(!Test.isRunningTest()){
        		ID = ApexPages.currentPage().getParameters().get('id');
        	} else {
        		ID = '123';
        	}
        	System.Debug('Id pulled from page: '+ID);
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
				System.Debug('add applications to select options list');
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
        	system.debug('Added Id to page');
        	system.debug('App ID on page: '+ApexPages.currentPage().getParameters().get('AppId'));
        	
        	return ApexPages.currentPage();
        	
              
        } 
}