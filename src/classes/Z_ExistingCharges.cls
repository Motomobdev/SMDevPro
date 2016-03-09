public with sharing class Z_ExistingCharges {

        /* The Quote ID, set by the VF page calling the custom component */
        public ID quoteIDname { set; get; }
        
        /* The page where the component got called (quote page/product selector) */
        public String fromName { set; get; }
        
        /* ZChargeGroup to remove from the quote */
        public String toDeleteGroupID { set; get; }
        
        /* ZChargeGroup ID to edit (quantities only) */
        public String toEditGroupID { set; get; }
        
        /* Current charge group being edited */
        public zqu.zChargeGroup currentChargeGroup { set; get; }
        
        /* Boolean to know if we are editing a group charge or in read-only */
        public Boolean editMode { set; get; }
        
        /* List of existing charges in the quote */        
        public List<zqu.zChargeGroup> chargeGroupList {
                get {
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                system.debug('Got charge groups via existing charges');
                        if (chargeGroupList == null) {
                                chargeGroupList = zqu.zQuoteUtil.getChargeGroups(this.quoteIDname);
                        }
                        
                		String OppId = [Select zqu__Opportunity__c from zqu__Quote__c where id=:quoteIDname limit 1].zqu__Opportunity__c;
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
                        
                        return chargeGroupList;
                }
                set;
        }
        
        
        /* For Application picklist */
        public String chosenApplication {get; set;}
		private List<Application__c> applications;
		
		
        /* Boolean to indicate if the prepaid column should be shown */
        public Boolean showPrepaid { get;set; }
        
        /**
         * Constructor
         */
        public Z_ExistingCharges() {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                
                
                editMode = false;
                
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
         * Update total price when quantity is changed
         */
        public void quntityChange() {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnQuantityChange(currentChargeGroup.zCharges);
                currentChargeGroup.zCharges = charges;
        }
        
        
        /**
         * On discount change
         */
        public void discountchange() {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnDiscountChange(
                        currentChargeGroup.zCharges
                );
                currentChargeGroup.zCharges = charges;
        }
        
        
        /**
         * On effective price change
         */
        public void effectiveChange() {
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnEffectivePriceChange(
                        currentChargeGroup.zCharges
                );
                currentChargeGroup.zCharges = charges;
        }
        
        
        /**
         * On total price change
         */
        public void totalChange() {
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnTotalChange(
                        currentChargeGroup.zCharges
                );
                currentChargeGroup.zCharges = charges;
        }


        /**
         * Action to remove a product rate plan from the quote
         */
        public PageReference deleteProduct() {
                
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                System.debug('Trying to delete ' + toDeleteGroupID);
                
                zqu.zChargeGroup chargeGroupToDelete = null;
                
                for (zqu.zChargeGroup cg : chargeGroupList) {
                        if (cg.groupID == toDeleteGroupID) {
                                chargeGroupToDelete = cg;
                        }
                }
                
                if (null != chargeGroupToDelete) {
                        System.debug('Deleting the charge group where ID = ' + toDeleteGroupID);
                        zqu.zQuoteUtil.deleteChargeGroup(chargeGroupToDelete);
                }
                
                return new PageReference('/' + quoteIdname);
        }
        
        
        /**
         * Switch the panel to edit mode with one charge group
         */
        public PageReference editProduct() {
                
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                editMode = true;
                
                // Loop through all the charge group to find the one we are editing
                for (zqu.zChargeGroup cg : chargeGroupList) {
                        if (cg.groupID == toEditGroupID) {
                                currentChargeGroup = cg;
                        }
                }
                
                return null;
        }
        
        
        /**
         * Save an updated product to the quote
         */
        public PageReference saveProduct() {
                
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                // Get the updated charge group (from the input in the VF page)
                zqu.ZChargeGroup updatedChargeGroup = zqu.zQuoteUtil.updateChargeGroup(this.currentChargeGroup);
                
                // Then update it in the list (to display the changes back)
                for(Integer i =0 ; i < this.chargeGroupList.size() ; i++){
                        
                        zqu.zChargeGroup zchargeGrp = this.chargeGroupList.get(i);
                        
                        if(updatedChargeGroup.groupId == zchargeGrp.groupId){
                                this.chargeGroupList.set(i, updatedChargeGroup);
                        }
                }
                
                editMode = false; 
                
                return new PageReference('/' + quoteIdname);
        }
        
        
        /**
         * Cancel a product edit action
         */
        public PageReference cancelEditing() {
        	
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'};
                
                editMode = false;
                return null;
        }
        
        /*For Application Picklist */
        public List<selectOption> getapplications() {
        	System.Debug('Get Application Ids');
        	this.applications = new List<Application__c>();
        	String ID = ApexPages.currentPage().getParameters().get('id');
        	System.Debug('Id pulled from page: '+ID);
                if (ID != null){
	                System.Debug('Getting Owner Id');
	                String OwnerId = [Select OwnerId From zqu__Quote__c Where Id = :ID][0].OwnerId;
	                System.Debug('Retrieved Owner Id: '+OwnerId);
	                if (!(OwnerId == null)){
				        this.applications = [SELECT Application_Id__c, Id, Name FROM Application__c WHERE OwnerId =: OwnerId];
	                }
                }
	        List<selectOption> options = new List<selectOption>(); 
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
        public void setApplicationValues(){
        	System.Debug('setApplicationValues Called');
        	String ApplicationName;
        	
        	
        	if (chosenApplication!=null && chosenApplication!=''){
	        	ApplicationName = [SELECT Name From Application__c WHERE Id =: chosenApplication][0].Name;
        	}
        	
        	System.Debug('Application ID: '+chosenApplication);
        	System.Debug('Application Name: '+ApplicationName);
        	if (!(chosenApplication==null)&&!(ApplicationName==null)){
        		Integer index = 0;
	        	 for (zqu.zCharge currCharge : currentChargeGroup.zCharges) {
	        	 		currCharge.chargeObject.put('ApplicationId__c',chosenApplication);
	        	 		currCharge.chargeObject.put('ApplicationName__c',ApplicationName);
	                	System.Debug('Curr Charge test : '+currCharge.chargeObject.get('CumulativeFrom__c')+', ID: '+currCharge.Id);
	                	index++;
	            }
        	}
              
        }
        
        public List<SelectOption> getprepaid(){   
	        List<SelectOption> prepaidOptions = new List<SelectOption>();
	        	// Use DescribeFieldResult object to retrieve prepaid field.
	        Schema.DescribeFieldResult prepaidFieldDescription = zqu__QuoteCharge__c.Prepaid__c.getDescribe();
	
	        // For each picklist value, create a new select option
	        for (Schema.Picklistentry picklistEntry:prepaidFieldDescription.getPicklistValues()){
	
	            prepaidOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
	
	            // obtain and assign default value
	            if (picklistEntry.defaultValue){
	            	//for (zqu.zCharge currCharge : chargeGroup.zCharges) {
	        	 	//	currCharge.chargeObject.put('Prepaid__c',pickListEntry.getValue());
	            	//}
	            }  
	        }
	        
	        return prepaidOptions;   
        }

}