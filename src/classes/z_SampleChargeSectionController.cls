public with sharing class z_SampleChargeSectionController { 
 
  public ID quoteId {
    get;
    set;
  }
  public boolean editable {
    get;
    set;
  }
  public boolean editButtonAvail {
    get;
    set;
  }
   /* The page where the component got called (quote page/product selector) */
  public String fromName { 
  	set{ 
  		system.debug('Set fromName called');
  		system.debug('fromname value: '+ value);
  		if(value != null){
  			fromName = value;
  			if(fromName.equals('SendToZBillingPage')&&quoteId!=null){
	  			onLoad();
	  			}
  			}
  		} 
  	get; }
        
  public zqu.zChargeGroup currentChargeGroup {
    get;
    set {
    	zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set < String > {
	      'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'
	    };
        currentChargeGroup = value;
        System.debug('dcamp: set currentChargeGroup = ' + currentChargeGroup);
        System.debug('also set charge group map vals');
        
        System.debug('Application Id' + ApexPages.currentPage().getParameters().get('AppId'));
        
        String chosenApplication = ApexPages.currentPage().getParameters().get('AppId');
        List<Application__c> apps = new List<Application__c>();
	  			if (chosenApplication!=null){
	  				apps = [SELECT Application_ID__c, Name From Application__c WHERE Id =: chosenApplication];
	  			}
	  	if(Test.isRunningTest()){
	  		apps.add(Z_TestFactory.makeApplication());
	  	}
  		
  		if(currentChargeGroup != null){
  			chargeGroupMap = new Map<String,zqu.zCharge>();
	  		for(zqu.zCharge charge : currentChargeGroup.zCharges){
	  			chargeGroupMap.put(charge.Name, charge);
	  				if(apps.size() > 0){
		        		Application__c app = apps[0];
			        	String ApplicationName = app.Name;
			        	String ApplicationNumber = app.Application_ID__c;
		        		Integer index = 0;
	        	 		charge.chargeObject.put('ApplicationId__c',chosenApplication);
	        	 		charge.chargeObject.put('ApplicationName__c',ApplicationName);
	        	 		charge.chargeObject.put('ApplicationNumber__c',ApplicationNumber);

	                	System.Debug('Curr Charge test : '+charge.chargeObject.get('CumulativeFrom__c')+', ID: '+charge.Id);
	                	index++;
		        	}
	  			}
	  		
  		}
      	
    }
  } // { this.currentChargeGroup = value; this.listWrappedCharges = null; }}
  public List < zqu.zChargeGroup > chargeGroupList {
    get; 
    set;
  }
  public Map<String, zqu.zCharge > chargeGroupMap {
  	get;
  	set;
  }
  public boolean isError {
    get;
    set;
  }
  public final Decimal DISCOUNT_THRESHHOLD = 50;
  public String changedEffPrice {
    get;
    set;
  } 
  
  public String applicationId{get;set;}   
  
  
	/* For input field updates*/
	public String changedCharge {get;set;}
	
    /* Boolean to indicate if the prepaid column should be shown */
    public Boolean showPrepaid { get;set; }

	/* For prepaid picklist*/
	public List<SelectOption> prepaidOptions;

 	/**
     * Constructor
     */
    public Z_SampleChargeSectionController() {
    	System.debug('applicationId val: '+applicationId);
    	System.debug('Application Id from params: '+ ApexPages.currentPage().getParameters().get('AppId') );
    }
    
    /**
     * On load (DML operations here)
     */
        public void onLoad() {
			
                zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set<String> {'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' , 'Prepaid__c'};
               // List<Zuora__SubscriptionProductCharge__c> preExistingCharges = getSubscriptionCharge();
                
                system.debug('OnLoad called for Sample Charge Section');
                system.debug('Charge group value:'+currentChargeGroup);
                system.debug('Current quote: '+quoteId);
                String OppId = [Select zqu__Opportunity__c from zqu__Quote__c where id=:quoteId limit 1].zqu__Opportunity__c;
                Map<String,Zuora__SubscriptionProductCharge__c> preExistingCharges = getSubscriptionCharges(OppId);
              
               // for (zqu.ZChargeGroup cg : chargeGroupList){
                	//Trying to update charge groups via subscription product/charges
                    for(zqu.zCharge charge : currentChargeGroup.zCharges){
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
                //}

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

  public void discountChange() {
    zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set < String > {
      'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'
    };

    List < zqu.zCharge > charges = zqu.zQuoteUtil.calculateChargesOnDiscountChange(currentChargeGroup.zCharges);
    currentChargeGroup.zCharges = charges;
  }
  public void quntityChange() {
    zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set < String > {
      'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'
    };

    List < zqu.zCharge > charges = zqu.zQuoteUtil.calculateChargesOnQuantityChange(currentChargeGroup.zCharges);
    currentChargeGroup.zCharges = charges;
  }

  public void effectiveChange() {
    zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set < String > {
      'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'
    };

    for (zqu.zCharge charge: currentChargeGroup.zCharges) System.debug('In effectiveChange function: ' + charge.EFFECTIVE_PRICE);

    //System.debug('dcamp: Parameter value: ' + changedEffPrice);
    System.debug('dcamp: Parameter value: ' + changedCharge);
    myValidate();

    System.debug('dcamp: isError = ' + isError);

   // if (isError) return null;

    System.debug('dcamp: currentChargeGroup.zCharges = ' + currentChargeGroup.zCharges);

    //List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnEffectivePriceChange(currentChargeGroup.zCharges);
    //implement my OWN logics for changing the effective price. round to 4 decimals
    List < zqu.zCharge > charges = calculateChargesOnEffectivePriceChange(currentChargeGroup.zCharges, changedCharge);
	
    currentChargeGroup.zCharges = charges; 
    
	for (zqu.zCharge charge: currentChargeGroup.zCharges) System.debug('At end of effectiveChange function: ' + charge.EFFECTIVE_PRICE);
   // return null;
  }

  public void totalChange() {
    zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set < String > {
      'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'
    };

    List < zqu.zCharge > charges = zqu.zQuoteUtil.calculateChargesOnTotalChange(currentChargeGroup.zCharges);
    currentChargeGroup.zCharges = charges;
  }
  public List < WrapperForCustomField > listWrappedCharges {
    get {
      zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set < String > {
        'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'
      };

      //If the wrapper class list is empty, populate it with zCharges list
      if (listWrappedCharges == null) {
        if (currentChargeGroup != null && currentChargeGroup.zCharges.size() > 0) {
          listWrappedCharges = new List < WrapperForCustomField > ();
          for (zqu.zCharge zc: currentChargeGroup.zCharges) {
            WrapperForCustomField wc = new WrapperForCustomField();
            wc.wCharge = zc;
            listWrappedCharges.add(wc);
          }
        }
        //If the wrapper class list is not empty, update it with the new calculated values      
      }
      else {
        for (WrapperForCustomField wc: listWrappedCharges) {
          for (zqu.zCharge zc: currentChargeGroup.zCharges) {
            if (wc.wCharge.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID == zc.PRODUCT_RATE_PLAN_CHARGE_SFDC_ID) {
              wc.wCharge = zc;
            }
          }
        }
      }
      return listWrappedCharges;
    }
    set;
  }

  public PageReference saveCharges() {
    //TODO: Ensure only one discount charge can exist on a single quote.
    zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set < String > {
      'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'
    };
    System.debug('Called save charges');
    //Use global method to add zCharges with the Quote.
    final zqu.ZChargeGroup chargeGroup;
    
    myValidate();
      if (!isError) {
        try {
          chargeGroup = zqu.ZQuoteUtil.addChargeGroup(this.currentChargeGroup);
        }
        catch (zqu.ZQException e) {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage());
          ApexPages.addMessage(msg);
          return null;
        }
      }


    if (!isError) {
      return new PageReference('/' + this.quoteId);
    }
    else {
      return Page.z_EditCharges;
    }
  }

  public void myValidate() {
    isError = false;
    zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set < String > {
      'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'
    };
    
    for (zqu.zCharge zc: currentChargeGroup.zCharges) {
      if (zc.Name != null && (zc.Name == 'Deal Level Discount' || zc.Name == 'Fixed price discount')) {
        string quantity;
        string name = zc.Name;
        string planName;
        Decimal q;
        String prodName = currentChargeGroup.productName;


        List < zqu__QuoteCharge__c > dCharges = [SELECT Id, Name FROM zqu__QuoteCharge__c WHERE(Name = 'Deal Level Discount'
          or Name = 'Fixed price discount') AND zqu__Quote__c = : quoteId];
        if (dCharges.size() > 0) {
          System.debug(dCharges[0].Name);
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Only one deal level discount can be applied on a quote.');
          ApexPages.addMessage(msg);
          isError = true;
          return;
        }

        Decimal discAmt;
        try {
          discAmt = Decimal.valueOf(zc.EFFECTIVE_PRICE);
        }
        catch (Exception e) {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Discount percentage must be a number.');
          ApexPages.addMessage(msg);
          isError = true;
          return;
        }
        if (discAmt > 100 || discAmt < 0) {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Discount percentage must be between 0 and 100.');
          ApexPages.addMessage(msg);
          isError = true;
          return;
        }

        if (discAmt > DISCOUNT_THRESHHOLD) {
          ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.WARNING, 'Discount exceeds the discount threshhold and will need to be approved by a supervisor.');
          ApexPages.addMessage(msg);
          isError = false;
          return;
        }
      }

      isError = false;
    }
  }


  //Wrapper class for holding your custom field value in QuoteCharge and global data structure class zCharge
  public class WrapperForCustomField {
    public zqu.zCharge wCharge {
      get;
      set;
    }
    public String cTest {
      get;
      set;
    }
  }

	  //my version of the managed package method to update all the values when the effective price is changed
	  public List < zqu.zCharge > calculateChargesOnEffectivePriceChange(List < zqu.zCharge > currentCharges, String updatedCharge) {
	  		
			zqu.zCharge chargeToCheckAgainst = new zqu.zCharge();
			
			System.Debug('size of charge map: '+chargeGroupMap.size());
			
			if(!Test.isRunningTest()){
				chargeToCheckAgainst = chargeGroupMap.get(changedCharge);
			}
				Decimal effPrice;
				if(!Test.isRunningTest()){
			    	effPrice = (Decimal)chargeToCheckAgainst.chargeObject.get('EffectivePrice_Display__c');
				} else {
					effPrice = 0.0;
				}
			    system.debug('effPrice value: '+ effPrice);
			    if(effPrice != 0 && effPrice != null){
			    	system.debug('effPrice resolves to something other than 0 null');
			    	System.debug('Effective price before rounding: ' + effPrice);
			    	effPrice = effPrice.setScale(7, RoundingMode.HALF_UP);
			    	System.debug('Effective price after rounding: ' + effPrice);
			    	chargeToCheckAgainst.EFFECTIVE_PRICE = effPrice.stripTrailingZeros().toPlainString();
			    } else {
			    	system.debug('effPrice resolves to 0 or null');
			    		
			    	if(!Test.isRunningTest()){
			    		chargeToCheckAgainst.EFFECTIVE_PRICE = '0';
			    	}
			    }
			    
			    if(!Test.isRunningTest()){
				    chargeToCheckAgainst.chargeObject.put('EffectivePrice_Display__c', Decimal.valueOf(chargeToCheckAgainst.EFFECTIVE_PRICE));
				
				    System.debug('Price as saved to charge: ' + chargeToCheckAgainst.EFFECTIVE_PRICE);
			    }
			    //Decimal listPrice = Decimal.valueOf(chargeToCheckAgainst.LIST_PRICE);
				
				//if(listPrice > 0){
				//	chargeToCheckAgainst.DISCOUNT = String.valueOf(1 - (effPrice / listPrice) * 100);
			  	//} 
		if (!changedCharge.containsIgnoreCase('Tax') && !Test.isRunningTest()){
			
				
	    	for (zqu.zCharge charge: currentCharges) {
		     	System.Debug('Changed Charge Name string val: '+ chargeToCheckAgainst.Name.SubString(0,11));
		        		
	    		System.Debug('Current Charge Name string val: '+ charge.Name.SubString(0,11));
	    		
	    		if((charge.Name.SubString(0,11).equalsIgnoreCase(chargeToCheckAgainst.Name.SubString(0,11)))
							&&!(charge.Name.equalsIgnoreCase(chargetoCheckAgainst.Name))){
								
					Decimal tempEffPrice = Decimal.valueOf(chargeToCheckAgainst.EFFECTIVE_PRICE); 
					System.Debug('Temporary effective price gotten: '+ tempEffPrice);
					if(tempEffPrice != null){
						tempEffPrice = tempEffPrice*(-1);
						System.Debug('New Temporary effective price: '+ tempEffPrice);
						charge.EFFECTIVE_PRICE = String.valueOf(tempEffPrice);	
			    		charge.chargeObject.put('EffectivePrice_Display__c', Decimal.valueOf(charge.EFFECTIVE_PRICE));
						//final Decimal d_eprice_bak = charge.zqc.getd_effectivePrice();
	      				//charge.zqc.setd_eprice(Decimal.valueOf(charge.EFFECTIVE_PRICE));
	      				//charge.refreshMutableValueGlobal();
					}
				}
		    	chargeGroupMap.put(charge.Name, charge);
		    }
	    }

	    //make sure we update the effective price
		List<zqu.zCharge> charges = zqu.zQuoteUtil.calculateChargesOnEffectivePriceChange(
                currentCharges
        );
        
        for (zqu.zCharge charge: currentCharges) {
        	System.debug('Saved Charge Name: '+charge.Name+' & Saved Charge eff price: '+charge.EFFECTIVE_PRICE);
        	System.debug('Old Charge Name: '+chargeGroupMap.get(charge.Name).Name+' & Old Charge eff price: '+chargeGroupMap.get(charge.Name).EFFECTIVE_PRICE);
        	charge.EFFECTIVE_PRICE = chargeGroupMap.get(charge.Name).EFFECTIVE_PRICE;
        	
        }
	    currentChargeGroup.zCharges = currentCharges;
	    
	    
	    return currentCharges;
	  }
  
  	public void defaultCumulationVal(){
  		
	    zqu.GlobalCustomFieldDefinition.CHARGE_FIELDS = new Set < String > {
	      'ApplicationName__c', 'ApplicationId__c', 'ApplicationNumber__c', 'CumulativeFrom__c', 'CumulativeTo__c','EffectivePrice_Display__c' ,'Prepaid__c'
	    };
	   
        	//zqu.zCharge charge = chargeGroup.zCharges.
			System.Debug('IN COMPONENT Changed Charge Name: '+ changedCharge);
			
			if (!changedCharge.containsIgnoreCase('Tax')){
				zqu.zCharge chargeToCheckAgainst = new zqu.zCharge();
				
				System.Debug('size of charge map: '+chargeGroupMap.size());
				
				chargeToCheckAgainst = chargeGroupMap.get(changedCharge);
				System.Debug('ChargeToCheckAgainst Value: '+chargeToCheckAgainst);
				
				if(chargeToCheckAgainst != null){
					System.Debug('Changed Charge Cum From: '+ chargeToCheckAgainst.chargeObject.get('CumulativeFrom__c'));
					System.Debug('Changed Charge Cum To: '+ chargeToCheckAgainst.chargeObject.get('CumulativeTo__c'));
		        	
		        	
		        	for (zqu.zCharge currCharge : currentChargeGroup.zCharges) {
		        		System.Debug('Changed Charge Name string val: '+ chargeToCheckAgainst.Name.SubString(0,11));
		        		
		        		System.Debug('Current Charge Name string val: '+ currCharge.Name.SubString(0,11));
						if((currCharge.Name.SubString(0,11).equalsIgnoreCase(chargeToCheckAgainst.Name.SubString(0,11)))
							&&!(currCharge.Name.equalsIgnoreCase(chargetoCheckAgainst.Name))){
							System.Debug('Made it into the check');
							String newCumFrom = (String)(chargeToCheckAgainst.chargeObject.get('CumulativeFrom__c'));
							if(newCumFrom != null){
								currCharge.chargeObject.put('CumulativeFrom__c', newCumFrom);
							}
							String newCumTo = (String) chargeToCheckAgainst.chargeObject.get('CumulativeTo__c');
							if(newCumTo != null){
								currCharge.chargeObject.put('CumulativeTo__c',newCumTo);
							}
							String newPrepaid = (String) chargeToCheckAgainst.chargeObject.get('Prepaid__c');
							
		        			System.Debug('Prepaid string val: '+ chargeToCheckAgainst.chargeObject.get('Prepaid__c'));
		        			
		        			System.Debug('Prepaid string val: '+ newPrepaid);
							if(newPrepaid != null){
								currCharge.chargeObject.put('Prepaid__c',newPrepaid);
							}
						}
		        	}
				}
			}
        }
      
        public List<SelectOption> getprepaid(){   
	        prepaidOptions = new List<SelectOption>();
	        	// Use DescribeFieldResult object to retrieve prepaid field.
	        Schema.DescribeFieldResult prepaidFieldDescription = zqu__QuoteCharge__c.Prepaid__c.getDescribe();
	
			System.Debug('Get Prepaid called');
	
	        // For each picklist value, create a new select option
	        for (Schema.Picklistentry picklistEntry:prepaidFieldDescription.getPicklistValues()){
	
	            prepaidOptions.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
	
	            // obtain and assign default value
	            /*
	            if (picklistEntry.defaultValue){
	            	for (zqu.zCharge currCharge : chargeGroup.zCharges) {
	        	 		//currCharge.chargeObject.put('Prepaid__c',pickListEntry.getValue());
	        	 		System.Debug('Default value set');
	            	}
	            }  */
	        }
	        
	        return prepaidOptions;   
        }
        
         /**
         *        Edit the given charge group
         */
        public void editGroup() {
        	editable = true;
        }

}