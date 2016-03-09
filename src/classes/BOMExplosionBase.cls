public with sharing class BOMExplosionBase {
	
	private Set<Id> swKitList = new Set<Id>();
	private Map<Id, String> applicationContractNumberMap = new Map<Id, String>();
	private Map<Id, Id> applicationAppGroupMap = new Map<Id, Id>();
	Map<Id, List<Id>> deviceApplicationMap = new Map<Id, List<Id>>();
	private Map<String, Application__c> applicationAppIdMap = new Map<String, Application__c>();
	Map<Id, List<Application_Group_Date_Range__c>> appGroupDateRangeMap = new Map<Id, List<Application_Group_Date_Range__c>>();
	Map<Id, Application_Group_Date_Range__c> appGroupDateRangeIdRecordMap = new Map<Id, Application_Group_Date_Range__c>();
	private Set<Id> usageEnhancedApplicationSet = new Set<Id>();
	Map<Id, Revenue_Unit__c> revUnitMap = new Map<Id, Revenue_Unit__c>();
	Map<Id, Contract> contractIdContractNumberMap = new Map<Id, Contract>();
	
	
	//constructor
	public BOMExplosionBase() {
		
	}
	
	/*
		this will update the BOM revUnit record with related SWKit and Device
		We will get the devices from SWKIT_SalesModel_Relationship__c where Current_SWKIT_SM_Mapping__c = 'Y'
		if there is no SWKit we will mark the unit as Invalid
		for Arctic fox units this step is not required
	*/
	public List<Revenue_Unit__c> RevenueUnitEnhance(List<Revenue_Unit__c> newRevenueUnitList)  {
		List<String> salesModelNameList = new List<String>();
		List<Revenue_Unit__c> bomRevUnitList = new List<Revenue_Unit__c>();
		for (Revenue_Unit__c newRevenueUnit : newRevenueUnitList)  {
			//first we will set the status to UnProcessed and Message as null since we are reprocessing these
			newRevenueUnit.status__c = Constants.REVUNIT_STATUS_UNPROCESSED;
			newRevenueUnit.Message__c = null;
			//only for BOM units, the product_number__c is salesModel
			if (newRevenueUnit.Data_Source__c == Constants.REVUNIT_TYPE_BOM) {
				salesModelNameList.add(newRevenueUnit.Product_Number__c);
				bomRevUnitList.add(newRevenueUnit);
			}
		}
		System.debug(' revenue list ' + newRevenueUnitList);
		System.debug('BOM revenue list ' + bomRevUnitList);
		bomRevUnitList = updateSWKit(bomRevUnitList, salesModelNameList);
		bomRevUnitList = updateDevice(bomRevUnitList, swKitList);
		//update newRevenueUnitList;
		return newRevenueUnitList;
	}
	
	/*
		this will get the applications for BOM revUnit records
		this will create the maps for application to its contract and application group which will be used in ZUsageEnhance
		this will also create the ZUsage records for the applications for both BOM and arcticFox
	*/
	public List<Revenue_Unit__c> ZUsageCreate(List<Revenue_Unit__c> newRevenueUnitList, Map<String, List<Export_Batch__c>> exportBatchQuarterMap, Map<String, List<Export_Batch__c>> exportBatchPeriodMap)  {
		List<String> deviceList = new List<String>();
		List<String> articFoxAppIdList = new List<String>();
		List<String> revUnitIdList = new List<String>();
		List<Revenue_Unit__c> bomRevUnitList = new List<Revenue_Unit__c>();
		List<Revenue_Unit__c> arcticFoxRevUnitList = new List<Revenue_Unit__c>();
		for (Revenue_Unit__c newRevenueUnit : newRevenueUnitList)  {
			//only for BOM units, the device is populated
			if (newRevenueUnit.Data_Source__c == Constants.REVUNIT_TYPE_BOM) {
				deviceList.add(newRevenueUnit.Device__c);
				bomRevUnitList.add(newRevenueUnit);
				revUnitIdList.add(newRevenueUnit.Id);
			}
			else {
				arcticFoxRevUnitList.add(newRevenueUnit);
				articFoxAppIdList.add(newRevenueUnit.Product_Number__c);
				revUnitIdList.add(newRevenueUnit.Id);
			}
		}
		System.debug(' revenue list ' + newRevenueUnitList);
		System.debug('BOM revenue list ' + bomRevUnitList);
		
		//delete existing ZUsage records since we want to reprocess all of them
		deleteZUsageRecords(revUnitIdList);
		
		//create the maps for applications to its contract, applicationGroups and applicationGroupDateRange for both BOM and arctic for units
		createApplicationMapsForBOM(deviceList);
		createApplicationMapsForArcticFox(arcticFoxRevUnitList, articFoxAppIdList);
		updateApplicationGroupToDateRangeMap();
		
		//create the ZUsage records 
		List<Z_Usage__c> zUsageList = createZUsageRecords(bomRevUnitList, arcticFoxRevUnitList);
		ZUsageEnhance(newRevenueUnitList, zUsageList);
		ZUsageAccummulate(newRevenueUnitList, exportBatchQuarterMap, exportBatchPeriodMap, zUsageList);
		return newRevenueUnitList;
	}
	
	/*
		this will update the ZUsage records with the accountingPeriod, applicationGroup and contract information
	*/
	public List<Revenue_Unit__c> ZUsageEnhance(List<Revenue_Unit__c> newRevenueUnitList, List<Z_Usage__c> zUsageList)  {
		List<String> revUnitIdList = new List<String>();

		List<String> contractNumberList = applicationContractNumberMap.values();
		//for (String contractNum : contractNumberList)  {
		//	system.debug('contractNum' + contractNum);
		//}
		List<Contract> contractList = [select Id, ContractNumber, CurrencyIsoCode from Contract where ContractNumber in :contractNumberList];
		Map<String, Id> contractIdContractMap = new Map<String, Id>();
		for (Contract contract : contractList) {
			if (!contractIdContractMap.containsKey(contract.ContractNumber))  {
				contractIdContractMap.put(contract.ContractNumber, contract.Id);
			}
			if (!contractIdContractNumberMap.containsKey(contract.Id)) {
				contractIdContractNumberMap.put(contract.Id, contract);
			}
		}
		for (Revenue_Unit__c newRevenueUnit : newRevenueUnitList)  {
			revUnitIdList.add(newRevenueUnit.Id);
			revUnitMap.put(newRevenueUnit.Id, newRevenueUnit);
		}
		//List<Z_Usage__c> zUsageList = [select Id, Revenue_Unit__c, Acct_Calendar__c, Application_Group_Date_Range__c, Revenue_Unit__r.Status__c, Revenue_Unit__r.Message__c, Revenue_Unit__r.Invoice_Number__c, Application__c, Application__r.Application_ID__c  from Z_Usage__c where Revenue_Unit__c in :newRevenueUnitList ];
		for(Z_Usage__c zUsage : zUsageList)  {
			
			//first update the accounting period
			zUsage.Acct_Calendar__c = revUnitMap.get(zUsage.Revenue_Unit__c).Acct_Calendar__c;
			zUsage.Account_Period__c = revUnitMap.get(zUsage.Revenue_Unit__c).Account_Period__c;
			zUsage.QuarterName__c = revUnitMap.get(zUsage.Revenue_Unit__c).Account_Quarter__c;
			Date processedDate = revUnitMap.get(zUsage.Revenue_Unit__c).ProcessedDate__c;
			String applContract = applicationContractNumberMap.get(zUsage.APPLICATION__c);
			zUsage.MESSAGE__c = '';
			//check for valid contract for application
			if (applContract != null && contractIdContractMap.get(applContract) != null) {
				zUsage.Contract__c = contractIdContractMap.get(applContract);
			}
			else {
				zUsage.STATUS__c = Constants.REVUNIT_STATUS_ERROR;
				zUsage.MESSAGE__c =  Constants.ZUSAGE_CONTRACT_NOT_FOUND_STATUS + '\r\n';
				revUnitMap.get(zUsage.Revenue_Unit__c).Status__c = Constants.REVUNIT_STATUS_ERROR;
				revUnitMap.get(zUsage.Revenue_Unit__c).Message__c = Constants.REVUNIT_ERROR_IN_STEP3;
			}
			
			//check for applicationGroup for application and if not found error
			Id applicationGroup = applicationAppGroupMap.get(zUsage.APPLICATION__c);
			if (applicationGroup != null) {
				//check for applicationGroupDateRange for application and processing date. 
				List<Application_Group_Date_Range__c> applGroupDateRangeList = appGroupDateRangeMap.get(applicationGroup);
				//if there are no applicationgroupdateRanges for that application group error out. 
				if (applGroupDateRangeList!= null && !applGroupDateRangeList.isEmpty())  {
					Boolean appGroupDateRangeFound = False;
					String appGroupDateRangeId;
					//loop through to find if there is atleast one record in that dateRange and if found use that, else error out
					for (Application_Group_Date_Range__c applGroupDateRange : applGroupDateRangeList)  {
						//assumption is there is only one record for an applicationgroup in that dateRange and we will pick the first record. 
						if (applGroupDateRange.Start_Date__c <= processedDate && processedDate <= applGroupDateRange.End_Date__c)  {
							appGroupDateRangeFound = True;
							appGroupDateRangeId = applGroupDateRange.Id;
							break;
						}
					}
					if (appGroupDateRangeFound == TRUE)  {
						zUsage.Application_Group_Date_Range__c = appGroupDateRangeId;
						if (!usageEnhancedApplicationSet.contains(zUsage.Application__c))  {
							usageEnhancedApplicationSet.add(zUsage.Application__c);
						}
					}
					else {
						zUsage.STATUS__c = Constants.REVUNIT_STATUS_ERROR;
						zUsage.MESSAGE__c +=  Constants.ZUSAGE_APPGROUP_DATERANGE_EXPIRED_STATUS + '\r\n';
						revUnitMap.get(zUsage.Revenue_Unit__c).Status__c = Constants.REVUNIT_STATUS_ERROR;
						revUnitMap.get(zUsage.Revenue_Unit__c).Message__c = Constants.REVUNIT_ERROR_IN_STEP3;
					}
				}
				else {
					zUsage.STATUS__c = Constants.REVUNIT_STATUS_ERROR;
					zUsage.MESSAGE__c +=  Constants.ZUSAGE_APPGROUP_DATERANGE_NOT_FOUND_STATUS + '\r\n';
					revUnitMap.get(zUsage.Revenue_Unit__c).Status__c = Constants.REVUNIT_STATUS_ERROR;
					revUnitMap.get(zUsage.Revenue_Unit__c).Message__c = Constants.REVUNIT_ERROR_IN_STEP3;
				}
			}
			else {
				zUsage.STATUS__c = Constants.REVUNIT_STATUS_ERROR;
				zUsage.MESSAGE__c +=  Constants.ZUSAGE_APPGROUP_NOT_FOUND_STATUS + '\r\n';
				revUnitMap.get(zUsage.Revenue_Unit__c).Status__c = Constants.REVUNIT_STATUS_ERROR;
				revUnitMap.get(zUsage.Revenue_Unit__c).Message__c = Constants.REVUNIT_ERROR_IN_STEP3;
			}
			
		}
		//upsert zUsageList;
		//update newRevenueUnitList;
		return newRevenueUnitList;
	}
	
	
	/*
		This is the method for calculating cumulatives for usages. 
		Here we first find all the charges for the cumulative for an application for a contract
		if it doesn't exist and if the royaltyamount = 0.0 for that application we will use the royalty free charge for that contract. 
		once we get the corresponding charge update usage with that charge and create new usages for prepaid and cross-spill
		If all the usages in a unit are successfully processed, we will get the exportBatch Ids for quarter and period and update the unit object and mark the unit as processed.
	*/
	public List<Revenue_Unit__c> ZUsageAccummulate(List<Revenue_Unit__c> newRevenueUnitList, Map<String, List<Export_Batch__c>> exportBatchQuarterMap, Map<String, List<Export_Batch__c>> exportBatchPeriodMap, List<Z_Usage__c> zUsageList)  {
		//List<Z_Usage__c> zUsageList = [select Id, Revenue_Unit__c, Application__r.Application_Type__c, Application__r.Royalty_Payment_Attribute__c, Application__r.Royalty_Current__c, Vendor__c, Application_Group_Date_Range__c, QTY__c, Contract__r.CurrencyIsoCode, Revenue_Unit__r.Status__c, Revenue_Unit__r.Message__c, Revenue_Unit__r.Invoice_Number__c, Revenue_Unit__r.Revenue_Units__c, Application__c, Revenue_Unit__r.Revenue_Invoice__r.Status__c, Contract__c, Contract__r.ContractNumber, Account_Period__c, Acct_Calendar__c, QuarterName__c from Z_Usage__c where Revenue_Unit__c in :newRevenueUnitList and Status__c != :Constants.REVUNIT_STATUS_ERROR order by Revenue_Unit__r.Revenue_Invoice__c, Revenue_Unit__c];
		List<Z_Usage__c> upsertedZUsageList = new List<Z_Usage__c> ();
		System.debug('usageEnhancedApplicationSet ' + usageEnhancedApplicationSet);
		//calculate RatePlans & create a map from application to list of all subscriptioncharges for that application
		Map<String, List<Zuora__SubscriptionProductCharge__c>> appSubProdChargeMap = new Map<String, List<Zuora__SubscriptionProductCharge__c>>();
		List<Zuora__SubscriptionProductCharge__c> subscriptionProductCharges = [select Id, ApplicationId__c, Zuora__Account__c, Zuora__RatePlanName__c, Zuora__Subscription__r.Name, Zuora__Subscription__r.Zuora__CustomerAccount__r.Zuora__AccountNumber__c, ContractNumber__c, Cumulative_From_num__c, Cumulative_To_num__c, Zuora__UOM__c, Prepaid__c, Zuora__Price__c, Zuora__ChargeNumber__c from Zuora__SubscriptionProductCharge__c where ApplicationId__c in :usageEnhancedApplicationSet OR Zuora__RatePlanName__c = :Constants.ROYALTY_FREE];
		Map<Id, Application__c> applicationIdApplicationMap = new Map<Id, Application__c>([select Id, Royalty_Current__c, Account__c from Application__c where Id in :usageEnhancedApplicationSet]);
		List<Zuora__SubscriptionProductCharge__c> appsubProdChargeList;
		List<Zuora__SubscriptionProductCharge__c> royaltyFreeChargesList = new List<Zuora__SubscriptionProductCharge__c>();
		List<Zuora__SubscriptionProductCharge__c> royaltyFreeChargesListForAccount;
		Map<String, List<Zuora__SubscriptionProductCharge__c>> royaltyFreeChargeMap = new Map<String, List<Zuora__SubscriptionProductCharge__c>>();
		for (Zuora__SubscriptionProductCharge__c subsProdCharge : subscriptionProductCharges)  { 		
			if (subsProdCharge.Zuora__RatePlanName__c == Constants.ROYALTY_FREE)   {
				royaltyFreeChargesList.add(subsProdCharge);
				if (!royaltyFreeChargeMap.containsKey(subsProdCharge.Zuora__Account__c))  {
					royaltyFreeChargesListForAccount = new List<Zuora__SubscriptionProductCharge__c>();
					royaltyFreeChargesListForAccount.add(subsProdCharge);
					royaltyFreeChargeMap.put(subsProdCharge.Zuora__Account__c, royaltyFreeChargesListForAccount);
				}
				else {
					royaltyFreeChargesListForAccount = royaltyFreeChargeMap.get(subsProdCharge.Zuora__Account__c);
					royaltyFreeChargesListForAccount.add(subsProdCharge);
					royaltyFreeChargeMap.put(subsProdCharge.Zuora__Account__c, royaltyFreeChargesListForAccount);
				}
			}
			else {
				if (!appSubProdChargeMap.containsKey(subsProdCharge.ApplicationId__c))  {
					appsubProdChargeList = new List<Zuora__SubscriptionProductCharge__c>();
					appsubProdChargeList.add(subsProdCharge);
					appSubProdChargeMap.put(subsProdCharge.ApplicationId__c, appsubProdChargeList);
				}
				else {
					appsubProdChargeList = appSubProdChargeMap.get(subsProdCharge.ApplicationId__c);
					appsubProdChargeList.add(subsProdCharge);
					appSubProdChargeMap.put(subsProdCharge.ApplicationId__c, appsubProdChargeList);
				}
			}
		}
		
		system.debug('subscriptionProductCharges ' + subscriptionProductCharges);
		system.debug('appSubProdChargeMap ' + appSubProdChargeMap);
		system.debug('royaltyFreeChargeMap ' + royaltyFreeChargeMap);
		
		//create a map of revInvoices to its usage records and loop through that to error out the whole invoice and revert the cumulatives. 
		Map<String, List<Z_Usage__c>> revUnitZUsageMap = new Map<String, List<Z_Usage__c>>();
		List<Z_Usage__c> revUnitZUsageList;
		for(Z_Usage__c zUsage : zUsageList)  {	
			if (zUsage.STATUS__c != Constants.REVUNIT_STATUS_ERROR)	  {	
				if (!revUnitZUsageMap.containsKey(zUsage.Revenue_Unit__c))  {
					revUnitZUsageList = new List<Z_Usage__c>();
					revUnitZUsageList.add(zUsage);
					revUnitZUsageMap.put(zUsage.Revenue_Unit__c, revUnitZUsageList);
				}
				else {
					revUnitZUsageList = revUnitZUsageMap.get(zUsage.Revenue_Unit__c);
					revUnitZUsageList.add(zUsage);
					revUnitZUsageMap.put(zUsage.Revenue_Unit__c, revUnitZUsageList);
				}
			}
		}
		system.debug('revInvoiceZUsageMap ' + revUnitZUsageMap);
		
		//keep a copy of the cumulatives that will be updated
		Map<Id, Application_Group_Date_Range__c> appGroupDateRangeIdRecordMapCopy = appGroupDateRangeIdRecordMap.deepClone();
		system.debug('appGroupDateRangeIdRecordMap ' + appGroupDateRangeIdRecordMap);
		
		for (String revInvoiceNumber: revUnitZUsageMap.keySet())  {
			Integer zUsageCount = 0;
			String prevRevUnit;
			String currentRevUnit;
			//loop through the zUsage, to get the chargeId based on the cumulative units
			for(Z_Usage__c zUsage : revUnitZUsageMap.get(revInvoiceNumber))  {
				system.debug('Calculating usage for ' + zUsage.Application__c);
				Long alloc = Math.abs(zUsage.Revenue_Units__c).longValue();
				//this is a workaround for this to get into the while loop. Inside the while loop it will be reinitialized to 0. 
				if (Integer.valueOf(zUsage.Revenue_Units__c) == 0)  {
					alloc = 1;
				}
				system.debug('Calculating usage for usage ' + zUsage);
				system.debug('Application_Group_Date_Range__c ' + zUsage.Application_Group_Date_Range__c);
				system.debug('Application_Group_Date_Range__c ' + appGroupDateRangeIdRecordMap.get(zUsage.Application_Group_Date_Range__c));
				Long cumulative = appGroupDateRangeIdRecordMap.get(zUsage.Application_Group_Date_Range__c).Cumulative_Units__c.longValue();
				Decimal cumulativeAmt = appGroupDateRangeIdRecordMap.get(zUsage.Application_Group_Date_Range__c).Cumulative_Amount__c;
				
				String Uom = Constants.UOM_APPSSHIPPED;
				String PrepaidUom = Constants.UOM_APPSSHIPPED_PREPAID;
				if (zUsageCount == 0)  {
					prevRevUnit = zUsage.Revenue_Unit__c;
				}
				currentRevUnit = zUsage.Revenue_Unit__c;
				if (zUsage.Revenue_Units__c < 0)  {
					Uom = Constants.UOM_APPSRETURNED;					
					PrepaidUom = Constants.UOM_APPSRETURNED_PREPAID;
				}
				system.debug('cumulative ' + cumulative);
				
				
				Integer whileLoopCounter = 0;
				//System.debug('whileLoopCounter' + whileLoopCounter);
				while (alloc > 0)  {
					//reupdating it back to 1		
					if (Integer.valueOf(zUsage.Revenue_Units__c) == 0)  {
						alloc = 0;
					}		
					List<Zuora__SubscriptionProductCharge__c> currSubsProdChargeList = appSubProdChargeMap.get(zUsage.Application__c);
					//get the chargeList only for RoyaltyFree
					//if (currSubsProdChargeList == null && zUsage.Application__r.Royalty_Current__c == 0.0)  {
					if (currSubsProdChargeList == null && applicationIdApplicationMap.get(zUsage.Application__c).Royalty_Current__c == 0.0)  {
						currSubsProdChargeList = new List<Zuora__SubscriptionProductCharge__c>();
						List<Zuora__SubscriptionProductCharge__c> currAccoutRoyaltyFreeChargeList =   royaltyFreeChargeMap.get(applicationIdApplicationMap.get(zUsage.Application__c).Account__c);//royaltyFreeChargeMap.get(zUsage.Vendor__c);
						System.debug( 'currAccoutRoyaltyFreeChargeList ' + currAccoutRoyaltyFreeChargeList);
						System.debug( 'zUsage.Vendor__c ' + zUsage.Vendor__c);
						System.debug( 'zUsage.Application__r ' + zUsage.Application__c);
						if (currAccoutRoyaltyFreeChargeList != null && !currAccoutRoyaltyFreeChargeList.isEmpty())  {
							for (Zuora__SubscriptionProductCharge__c royaltyFreeCharges : currAccoutRoyaltyFreeChargeList) {
								currSubsProdChargeList.add(royaltyFreeCharges);
							}
						}
						/*for (Zuora__SubscriptionProductCharge__c royaltyFreeCharges : royaltyFreeChargesList) { 
							if (zUsage.Vendor__c == royaltyFreeCharges.Zuora__Account__c )  {
								currSubsProdChargeList.add(royaltyFreeCharges);
							}
						}*/
						System.debug('Inside royalty for ' + zUsage.Application__c);
					}
					Zuora__SubscriptionProductCharge__c obtainedSubsProdCharge;
					Zuora__SubscriptionProductCharge__c prepaidSubsProdCharge;
					
					Long used;
					Long qtyUsed;
					System.debug('currSubsProdChargeList ' + currSubsProdChargeList);
					if (currSubsProdChargeList != null)  {
						Decimal cumulativeRange = Math.abs(cumulative + 1);
						if (zUsage.Revenue_Units__c < 0)  {
							cumulativeRange = Math.abs(cumulative - 1);
						}
						System.debug('cumulativeRange ' + cumulativeRange);
						for (Zuora__SubscriptionProductCharge__c currSubsProdCharge : currSubsProdChargeList) {
							System.debug('currSubsProdCharge.Cumulative_From_num__c ' + currSubsProdCharge.Cumulative_From_num__c);
							System.debug('currSubsProdCharge.Cumulative_To_num__c ' + currSubsProdCharge.Cumulative_To_num__c);
							System.debug('currSubsProdCharge.ContractNumber__c ' + currSubsProdCharge.ContractNumber__c);
							System.debug('zUsage.ContractNumber__c ' + contractIdContractNumberMap.get(zUsage.Contract__c));
							//if the cumulative range is not 0, then get the corresponding charge
							if (cumulativeRange != 0)  {
								if ((currSubsProdCharge.Cumulative_From_num__c <= cumulativeRange) && (cumulativeRange <= currSubsProdCharge.Cumulative_To_num__c) && (currSubsProdCharge.ContractNumber__c == contractIdContractNumberMap.get(zUsage.Contract__c).ContractNumber))  {
									if (currSubsProdCharge.Zuora__UOM__c == Uom)  {
										obtainedSubsProdCharge = currSubsProdCharge;
									}
									if (currSubsProdCharge.Zuora__UOM__c == PrepaidUom)  {
										prepaidSubsProdCharge = currSubsProdCharge;
									}
								}
							}
							//otherwise get the charge for first tier. first tier is the charge that starts with 1. 
							else {
								if ((currSubsProdCharge.Cumulative_From_num__c == 1) && (currSubsProdCharge.ContractNumber__c == contractIdContractNumberMap.get(zUsage.Contract__c).ContractNumber))  {
									if (currSubsProdCharge.Zuora__UOM__c == Uom)  {
										obtainedSubsProdCharge = currSubsProdCharge;
									}
									if (currSubsProdCharge.Zuora__UOM__c == PrepaidUom)  {
										prepaidSubsProdCharge = currSubsProdCharge;
									}
								}
							}
						} 
						system.debug('obtainedSubsProdCharge ' + obtainedSubsProdCharge);
						system.debug('prepaidSubsProdCharge ' + prepaidSubsProdCharge);
						if (obtainedSubsProdCharge != null)   { //check if there exists a charge in that cumulative range
							if ((zUsage.Revenue_Units__c >= 0) || (zUsage.Revenue_Units__c < 0  && cumulative <= 0) )  {
								used = Math.Min(alloc, (obtainedSubsProdCharge.Cumulative_To_num__c.longValue() - Math.abs(cumulative)));
								alloc -= used;
								if (zUsage.Revenue_Units__c >= 0)  {
									cumulative += used;  
								}
								else {
									cumulative -= used;
								}
								qtyUsed = used;
								Long cumDifference = obtainedSubsProdCharge.Cumulative_To_num__c.longValue() - cumulative;
								Long cumToInteger = obtainedSubsProdCharge.Cumulative_To_num__c.longValue();
								System.debug('obtainedSubsProdCharge.Cumulative_To_num__c ' + cumToInteger);
								System.debug('cumulative ' + cumulative);
								System.debug('cumDifference ' + cumDifference);
								System.debug('usedFormula is ' + cumDifference);
								System.debug('alloc is ' + alloc);
							}
							else if (zUsage.Revenue_Units__c < 0)  {
								if (Integer.valueOf(obtainedSubsProdCharge.Cumulative_From_num__c) == 0)
									used = Math.Min(alloc, (Math.abs(cumulative) - obtainedSubsProdCharge.Cumulative_From_num__c.longValue()));
								else
									used = Math.Min(alloc, (Math.abs(cumulative) - obtainedSubsProdCharge.Cumulative_From_num__c.longValue() + 1));
								alloc -= used;
								cumulative -= used; 
								qtyUsed = used;
							}
							System.debug('whileLoopCounter' + whileLoopCounter);
							System.debug('used is ' + used);
							cumulativeAmt += obtainedSubsProdCharge.Zuora__Price__c * used;
							if (whileLoopCounter == 0)  {  // if there is no cross spill update the same usage record
								zUsage.QTY__c = qtyUsed;
								zUsage.CHARGE_ID__c = obtainedSubsProdCharge.Zuora__ChargeNumber__c;
								zUsage.Account_ID__c = obtainedSubsProdCharge.Zuora__Subscription__r.Zuora__CustomerAccount__r.Zuora__AccountNumber__c;
								zUsage.ContractCurrency__c =  contractIdContractNumberMap.get(zUsage.Contract__c).CurrencyIsoCode;//zUsage.Contract__r.CurrencyIsoCode;
								zUsage.Rate__c = String.valueOf(obtainedSubsProdCharge.Zuora__Price__c);
								zUsage.UOM__c = obtainedSubsProdCharge.Zuora__UOM__c;
								zUsage.Prepaid__c = obtainedSubsProdCharge.Prepaid__c;
								zUsage.Status__c = Constants.REVUNIT_STATUS_PROCESSED;
								zUsage.Message__c = Constants.REVINVOICE_MESSAGE_SUCCESS;
								zUsage.SUBSCRIPTION_ID__c = obtainedSubsProdCharge.Zuora__Subscription__r.Name;
								//upsertedZUsageList.add(zUsage);
							}
							else {   //otherwise we will create a new ZUsage record for the cross spill with the delta units. 
								Z_Usage__c zUsageNew = populateIndividualZUsageRecords(revUnitMap.get(zUsage.Revenue_Unit__c),ZUsage.APPLICATION__c);
								zUsageNew.Application_Group_Date_Range__c = zUsage.Application_Group_Date_Range__c;
								zUsageNew.Contract__c = zUsage.Contract__c;
								zUsageNew.ContractCurrency__c = contractIdContractNumberMap.get(zUsage.Contract__c).CurrencyIsoCode;
								zUsageNew.Acct_Calendar__c = zUsage.Acct_Calendar__c;
								zUsageNew.Account_Period__c = zUsage.Account_Period__c;
								zUsageNew.QuarterName__c = zUsage.QuarterName__c;
								zUsageNew.QTY__c = qtyUsed;
								zUsageNew.CHARGE_ID__c = obtainedSubsProdCharge.Zuora__ChargeNumber__c;
								zUsageNew.Account_ID__c = obtainedSubsProdCharge.Zuora__Subscription__r.Zuora__CustomerAccount__r.Zuora__AccountNumber__c;
								zUsageNew.Rate__c = String.valueOf(obtainedSubsProdCharge.Zuora__Price__c);
								zUsageNew.UOM__c = obtainedSubsProdCharge.Zuora__UOM__c;
								zUsageNew.Prepaid__c = obtainedSubsProdCharge.Prepaid__c;
								zUsageNew.Split__c = TRUE;
								zUsageNew.Status__c = Constants.REVUNIT_STATUS_PROCESSED;
								zUsageNew.Message__c = Constants.REVINVOICE_MESSAGE_SUCCESS;
								zUsageNew.SUBSCRIPTION_ID__c = obtainedSubsProdCharge.Zuora__Subscription__r.Name;
								upsertedZUsageList.add(zUsageNew);							
							}
							//if prepaid is true then we will insert another row with prepaid UOM and set the flag
							if (obtainedSubsProdCharge.Prepaid__c  != null && obtainedSubsProdCharge.Prepaid__c.startsWithIgnoreCase('Y') && prepaidSubsProdCharge != null)  {
								Z_Usage__c zUsageNew = populateIndividualZUsageRecords(revUnitMap.get(zUsage.Revenue_Unit__c),ZUsage.APPLICATION__c);
								zUsageNew.Application_Group_Date_Range__c = zUsage.Application_Group_Date_Range__c;
								zUsageNew.Contract__c = zUsage.Contract__c;
								zUsageNew.ContractCurrency__c = contractIdContractNumberMap.get(zUsage.Contract__c).CurrencyIsoCode;
								zUsageNew.Acct_Calendar__c = zUsage.Acct_Calendar__c;
								zUsageNew.Account_Period__c = zUsage.Account_Period__c;
								zUsageNew.QuarterName__c = zUsage.QuarterName__c;
								zUsageNew.QTY__c = qtyUsed;
								zUsageNew.CHARGE_ID__c = prepaidSubsProdCharge.Zuora__ChargeNumber__c;
								zUsageNew.Account_ID__c = prepaidSubsProdCharge.Zuora__Subscription__r.Zuora__CustomerAccount__r.Zuora__AccountNumber__c;
								zUsageNew.Rate__c = String.valueOf(prepaidSubsProdCharge.Zuora__Price__c);
								zUsageNew.UOM__c = prepaidSubsProdCharge.Zuora__UOM__c;
								zUsageNew.Prepaid__c = prepaidSubsProdCharge.Prepaid__c;
								zUsageNew.Status__c = Constants.REVUNIT_STATUS_PROCESSED;
								zUsageNew.Message__c = Constants.REVINVOICE_MESSAGE_SUCCESS;
								zUsageNew.SUBSCRIPTION_ID__c = obtainedSubsProdCharge.Zuora__Subscription__r.Name;
								upsertedZUsageList.add(zUsageNew);
								//cumulativeAmt -= obtainedSubsProdCharge.Zuora__Price__c * used;
							}
							//put the step for adding cumulative
							appGroupDateRangeIdRecordMap.get(zUsage.Application_Group_Date_Range__c).Cumulative_Units__c = cumulative;
							appGroupDateRangeIdRecordMap.get(zUsage.Application_Group_Date_Range__c).Cumulative_Amount__c = cumulativeAmt;
						}
						else { //if there is no charge found, we will error the Usage, revUnit and the revInvoice records. 
							System.debug('No charge for ' + zUsage.Application__c  + '     cumulativeRange        ' + cumulativeRange);
							zUsage.STATUS__c = Constants.REVUNIT_STATUS_ERROR;
							zUsage.MESSAGE__c =  Constants.ZUSAGE_CHARGEID_NOT_FOUND_STATUS + '\r\n';
							revUnitMap.get(zUsage.Revenue_Unit__c).Status__c = Constants.REVUNIT_STATUS_ERROR;
							revUnitMap.get(zUsage.Revenue_Unit__c).Message__c = Constants.REVUNIT_ERROR_IN_STEP4;
							//upsertedZUsageList.add(zUsage);	
							break;
						}
					}
					else {
						System.debug('No subscriptionproductcharges for ' + zUsage.Application__c);
						zUsage.STATUS__c = Constants.REVUNIT_STATUS_ERROR;
						zUsage.MESSAGE__c =  Constants.ZUSAGE_CHARGEID_NOT_FOUND_STATUS + '\r\n';
						revUnitMap.get(zUsage.Revenue_Unit__c).Status__c = Constants.REVUNIT_STATUS_ERROR;
						revUnitMap.get(zUsage.Revenue_Unit__c).Message__c = Constants.REVUNIT_ERROR_IN_STEP4;
						//upsertedZUsageList.add(zUsage);	
						break;
					}
					whileLoopCounter++;
					if (whileLoopCounter > 5) {
						zUsage.STATUS__c = Constants.REVUNIT_STATUS_ERROR;
						zUsage.MESSAGE__c =  'Error getting the charge ' + '\r\n';
						revUnitMap.get(zUsage.Revenue_Unit__c).Status__c = Constants.REVUNIT_STATUS_ERROR;
						revUnitMap.get(zUsage.Revenue_Unit__c).Message__c = Constants.REVUNIT_ERROR_IN_STEP4;
						//upsertedZUsageList.add(zUsage);	
						break;
					}					
				}	
				system.debug('Previous revUnit ' + prevRevUnit);
				system.debug('Current revUnit ' + currentRevUnit);
				system.debug('zUsage ' + zUsage.Application__c);
					
				zUsageCount++;	
				
				
			}
			
			if (revUnitMap.get(revInvoiceNumber).Status__c == Constants.REVUNIT_STATUS_ERROR)  {
				//revert back the cumulatives
				appGroupDateRangeIdRecordMap = appGroupDateRangeIdRecordMapCopy.deepClone();
			}
			else {
				Boolean revUnitQuarterExportFound = false;
				Boolean revUnitPeriodExportFound = false;
				//here we loop through the exportBatches to see an open batch and if we do not find one, we error the unit with that information again. 
				if (exportBatchQuarterMap.get(revUnitMap.get(revInvoiceNumber).Account_Quarter__c) != null) {
					revUnitMap.get(revInvoiceNumber).AQ_ExportID__c = exportBatchQuarterMap.get(revUnitMap.get(revInvoiceNumber).Account_Quarter__c)[0].Name;
					revUnitQuarterExportFound = true;
				}
				else {
					revUnitMap.get(revInvoiceNumber).Status__c = Constants.REVUNIT_STATUS_ERROR;
					revUnitMap.get(revInvoiceNumber).Message__c = Constants.REVUNIT_ERROR_EXPORT_BATCH_QUARTER + '\r\n';
				}
				
				if (exportBatchPeriodMap.get(revUnitMap.get(revInvoiceNumber).Account_Period__c) != null) {
					revUnitMap.get(revInvoiceNumber).AP_ExportID__c = exportBatchPeriodMap.get(revUnitMap.get(revInvoiceNumber).Account_Period__c)[0].Name;
					revUnitPeriodExportFound = true;
				}
				else {
					revUnitMap.get(revInvoiceNumber).Status__c = Constants.REVUNIT_STATUS_ERROR;
					revUnitMap.get(revInvoiceNumber).Message__c = Constants.REVUNIT_ERROR_EXPORT_BATCH_PERIOD;
				}
				//set the status to processed for revInvoice
				if (revUnitQuarterExportFound == true && revUnitPeriodExportFound == true)  {
					revUnitMap.get(revInvoiceNumber).Status__c = Constants.REVUNIT_STATUS_PROCESSED;
					revUnitMap.get(revInvoiceNumber).Message__c = Constants.REVINVOICE_MESSAGE_SUCCESS;
					//update the cumulatives
					appGroupDateRangeIdRecordMapCopy = appGroupDateRangeIdRecordMap.deepClone();
				}
			}
			system.debug('appGroupDateRangeIdRecordMap ' + appGroupDateRangeIdRecordMap);
		}
		//
		upsert zUsageList;
		upsert upsertedZUsageList;
		//update newRevenueUnitList;
		update appGroupDateRangeIdRecordMap.values();
		return newRevenueUnitList;
	}
	
	/*
		Here we will create a map for an application Group to the list of all applicationGroupDateRange records for that applicationGroup and the mapping for applicationGroupDateRange 
	*/
	public void updateApplicationGroupToDateRangeMap()  {
		//List<Application_Group_Date_Range__c> appGroupDateRangeList = [select Id, Cumulative_Amount__c, Cumulative_Units__c, End_Date__c, Start_Date__c, Application_Group__c from Application_Group_Date_Range__c where Application_Group__c in :applicationAppGroupMap.values()];
		appGroupDateRangeIdRecordMap = new Map<Id, Application_Group_Date_Range__c> ([select Id, Cumulative_Amount__c, Cumulative_Units__c, End_Date__c, Start_Date__c, Application_Group__c from Application_Group_Date_Range__c where Application_Group__c in :applicationAppGroupMap.values()]);
		//System.debug('appGroupDateRangeList ' + appGroupDateRangeList);
		List<Application_Group_Date_Range__c> appGroupDRList;
		for (Application_Group_Date_Range__c agDateRange : appGroupDateRangeIdRecordMap.values())  { 
			
			if (!appGroupDateRangeMap.containsKey(agDateRange.Application_Group__c))  {
				appGroupDRList = new List<Application_Group_Date_Range__c>();
				appGroupDRList.add(agDateRange);
				appGroupDateRangeMap.put(agDateRange.Application_Group__c, appGroupDRList);
			}
			else {
				appGroupDRList = appGroupDateRangeMap.get(agDateRange.Application_Group__c);
				appGroupDRList.add(agDateRange);
				appGroupDateRangeMap.put(agDateRange.Application_Group__c, appGroupDRList);
			}
			//if (!appGroupDateRangeIdRecordMap.containsKey(agDateRange.Id) ) {
			//	appGroupDateRangeIdRecordMap.put(agDateRange.Id,agDateRange);
			//}
		}
	}
	
	/*
		this will update the BOM revUnit records with SWKit
		We will get the SWKit from SWKIT_SalesModel_Relationship__c where Current_SWKIT_SM_Mapping__c = 'Y'
		if there is no SWKit we will mark the unit as Invalid
		with this filter there is always a 1-1 from salesmodel to SWKit
	*/
	private List<Revenue_Unit__c> updateSWKit(List<Revenue_Unit__c> bomRevUnitList, List<String> salesModelNameList)  {
		List<SWKIT_SalesModel_Relationship__c> swKitSalesModelRelationshipList = [select Id, SW_Kit__c, SalesModelName__c, Sales_Model__c from SWKIT_SalesModel_Relationship__c where Current_SWKIT_SM_Mapping__c = 'Y' and SalesModelName__c in :salesModelNameList ];
		Map<String, SWKIT_SalesModel_Relationship__c>  salesModelSWKitMap = new Map<String, SWKIT_SalesModel_Relationship__c>();
		System.debug('swKitSalesModelRelationshipList ' + swKitSalesModelRelationshipList);
		for (SWKIT_SalesModel_Relationship__c swKitSalesModelRelationship : swKitSalesModelRelationshipList)  {
			if (!swKitList.contains(swKitSalesModelRelationship.SW_Kit__c))  {
				swKitList.add(swKitSalesModelRelationship.SW_Kit__c);
			}
			if (!salesModelSWKitMap.containsKey(swKitSalesModelRelationship.SalesModelName__c))  {
				salesModelSWKitMap.put(swKitSalesModelRelationship.SalesModelName__c, swKitSalesModelRelationship);
			}
		}
		System.debug('salesModelSWKitMap ' + salesModelSWKitMap);
		for (Revenue_Unit__c bomRevenueUnit : bomRevUnitList)  {				
			if (salesModelSWKitMap.get(bomRevenueUnit.Product_Number__c) != null)  {	
				bomRevenueUnit.Sales_Model__c = salesModelSWKitMap.get(bomRevenueUnit.Product_Number__c).Sales_Model__c;	
				bomRevenueUnit.SWKit__c   = salesModelSWKitMap.get(bomRevenueUnit.Product_Number__c).SW_Kit__c;	
			}
			else {
				bomRevenueUnit.Status__c = Constants.REVUNIT_STATUS_ERROR;
				bomRevenueUnit.Message__c = Constants.REVUNIT_SWKIT_NOT_FOUND_STATUS + bomRevenueUnit.Product_Number__c;
			}
		}
		System.debug('BOM revenue list in updateSWKit ' + bomRevUnitList);
		return bomRevUnitList;
	}
	
	/*
		this will update the BOM revUnit records with SWKit
		we will get all the devices associated to SWKit and pick any device whose SA_Date__c older than the revUnit's invoice date
		if there is no Device, we will check with SWKiteffectiveDate is older than invoiceDate and use that and if don't find that as well we will mark the unit as Invalid
		there is a one to many from SWKit to Device
	*/
	private List<Revenue_Unit__c> updateDevice(List<Revenue_Unit__c> bomRevUnitList, Set<Id> localSwKitList)  {
		List<Device__c> deviceList = [select Id, SW_Kit__c, SA_Date__c, SW_Kit_Effective_Date__c from Device__c where SW_Kit__c in :localSwKitList order by SW_Kit__c, SA_Date__c desc];
		Map<Id, List<Device__c>> swKitDeviceMap = new Map<Id, List<Device__c>>();
		System.debug('deviceList ' + deviceList);
		List<Device__c> devList;
		for (Device__c device : deviceList)  { 			
			if (!swKitDeviceMap.containsKey(device.SW_Kit__c))  {
				devList = new List<Device__c>();
				devList.add(device);
				swKitDeviceMap.put(device.SW_Kit__c, devList);
			}
			else {
				devList = swKitDeviceMap.get(device.SW_Kit__c);
				devList.add(device);
				swKitDeviceMap.put(device.SW_Kit__c, devList);
			}
		}
		System.debug('swKitDeviceMap ' + swKitDeviceMap);
		
		for (Revenue_Unit__c swKitRevUnit :   bomRevUnitList)  {	
			if (swKitRevUnit.SWKit__c != null)	{
				List<Device__c> swkitDeviceList = swKitDeviceMap.get(swKitRevUnit.SWKit__c);
				if (swkitDeviceList!= null && !swkitDeviceList.isEmpty())  {
					try {
						Boolean deviceFound = FALSE;
						for (Device__c device : swkitDeviceList)  {
							if (device.SA_Date__c <= Date.parse(swKitRevUnit.Invoice_Date__c.substringBefore(' ')))  {
							//if (device.SA_Date__c < DateTime.parse(swKitRevUnit.Invoice_Date__c).date())  {
								swKitRevUnit.Device__c = device.Id;
								deviceFound = TRUE;
								break;
							}
						}
						if (deviceFound == FALSE)  {
							//since we did a SA_DATE__c desc I am getting the last one in the list to get the device with the earliest SA_Date__c
							Integer swkitDeviceListSize = swkitDeviceList.size();
							if (swkitDeviceList[swkitDeviceListSize - 1].SW_Kit_Effective_Date__c < Date.parse(swKitRevUnit.Invoice_Date__c.substringBefore(' ')))  {
								swKitRevUnit.Device__c = swkitDeviceList[swkitDeviceListSize - 1].Id;
								deviceFound = TRUE;
							}
							if (deviceFound == FALSE)  {
								swKitRevUnit.Status__c = Constants.REVUNIT_STATUS_ERROR;
								swKitRevUnit.Message__c = Constants.REVUNIT_DEVICE_NOT_FOUND_STATUS + swKitRevUnit.Product_Number__c;
							}
						}
					}
					catch (Exception ex)  {
						swKitRevUnit.Status__c = Constants.REVUNIT_STATUS_ERROR;
						swKitRevUnit.Message__c = Constants.REVUNIT_ERROR_INVOICE_DATE_IS_NOT_CORRECT;
					}
				}
				else {
					swKitRevUnit.Status__c = Constants.REVUNIT_STATUS_ERROR;
					swKitRevUnit.Message__c = Constants.REVUNIT_DEVICE_NOT_FOUND_STATUS + swKitRevUnit.Product_Number__c;
				}
			}
		}
		System.debug('BOM revenue list in updateDevice ' + bomRevUnitList);
		return bomRevUnitList;
	}
	
	/*  
	    For BOM units, we will get all the applications associated to device  where Include_in_BOM__c  is "TRUE"
		if there is no application we will mark the unit as Invalid
		if there are applications, we will create the maps for the contract to application, application Group to application which will be used later.
	*/
	private void createApplicationMapsForBOM(List<Id> deviceList)  { 
		List<DeviceApplicationAssoc__c> deviceApplicationList = [select Id, Application__c, Device__c, Application_Group__c, AppID__c, Application_Contract_Number__c from DeviceApplicationAssoc__c where Device__c in :deviceList and Include_in_BOM__c = TRUE and App_Available_For_Use__c = 'YES'];
		
		//Set<String> contractNumberList = new Set<String>();
		System.debug('deviceApplicationList ' + deviceApplicationList);
		
		//create a Map for a Device to all its applications
		for (DeviceApplicationAssoc__c deviceApplication : deviceApplicationList)  { 
			List<Id> appList;
			if (!deviceApplicationMap.containsKey(deviceApplication.Device__c))  {
				appList = new List<Id>();
				appList.add(deviceApplication.Application__c);
				deviceApplicationMap.put(deviceApplication.Device__c, appList);
			}
			else {
				appList = deviceApplicationMap.get(deviceApplication.Device__c);
				appList.add(deviceApplication.Application__c);
				deviceApplicationMap.put(deviceApplication.Device__c, appList);
			}
			//create a Map for application to applicationGroup
			if (!applicationAppGroupMap.containsKey(deviceApplication.Application__c))  {
				applicationAppGroupMap.put(deviceApplication.Application__c, deviceApplication.Application_Group__c);
			}
			//create a Map for application to applicationGroup
			if (!applicationContractNumberMap.containsKey(deviceApplication.Application__c) || (applicationContractNumberMap.get(deviceApplication.Application__c) == null))  {
				applicationContractNumberMap.put(deviceApplication.Application__c, deviceApplication.Application_Contract_Number__c);
			}
			
		}
	}
	
	/*  
	    For Arctic fox units, we will get all the applications associated to device  where Include_in_BOM__c  is "TRUE"
		if there is no application we will mark the unit as Invalid
		if there are applications, we will create the maps for the contract to application, application Group to application which will be used later.
	*/
	private void createApplicationMapsForArcticFox(List<Revenue_Unit__c> arcticFoxRevUnitList, List<String> articFoxAppIdList)  { 
		List<Application__c> applicationList = [select Id, Application_Id__c, Application_Group__c, Application_Contract_Number__c from Application__c where Application_Id__c in :articFoxAppIdList];
		//create a Map for a Device to all its applications
		for (Application__c application : applicationList)  { 
			if (!applicationAppIdMap.containsKey(application.Application_Id__c))  {
				applicationAppIdMap.put(application.Application_Id__c,application);
			}	
			//create a Map for application to applicationGroup
			if (!applicationAppGroupMap.containsKey(application.Id))  {
				applicationAppGroupMap.put(application.Id, application.Application_Group__c);
			}
			//create a Map for application to applicationGroup
			if (!applicationContractNumberMap.containsKey(application.Id))  {
				applicationContractNumberMap.put(application.Id, application.Application_Contract_Number__c);
			}
			
		}
	}
	
	/*
		this will delete all the usage records for a set of revUnitIds. 
	*/
	private void deleteZUsageRecords(List<String> revUnitIdList) {
		List<Z_Usage__c> zUsageDeleteList = [select Id from Z_Usage__c where Revenue_Unit__c in :revUnitIdList];
		delete zUsageDeleteList;
	}
	
	/*
		create the ZUsage records for both BOM and arctic fox revUnits for all the applications 
		if there is no relevant applicationID for the articfox revUnit, error that out. 
	*/
	private List<Z_Usage__c> createZUsageRecords(List<Revenue_Unit__c> bomRevUnitList, List<Revenue_Unit__c> arcticFoxRevUnitList)  {
		List<Z_Usage__c> zUsageList = new List<Z_Usage__c>(); 
		List<Id> bomAppIdList = new List<Id>();

		for (Revenue_Unit__c bomRevUnit :   bomRevUnitList)  {
			if (bomRevUnit.Device__c != null)	{
					List<Id> applicationDeviceList = deviceApplicationMap.get(bomRevUnit.Device__c);
					if (!applicationDeviceList.isEmpty())  {
						String unitApplications = '';
						for (Id applicationId : applicationDeviceList)  {
							unitApplications += applicationId + ',';
							Z_Usage__c zUsage = populateIndividualZUsageRecords(bomRevUnit,applicationId);
							zUsageList.add(zUsage);
							bomAppIdList.add(applicationId);
						}
						//bomRevUnit.Applications__c = unitApplications;
					}
					else {
						bomRevUnit.Status__c = Constants.REVUNIT_STATUS_ERROR;
						bomRevUnit.Message__c = Constants.REVUNIT_APPLICATION_NOT_FOUND_STATUS + bomRevUnit.Product_Number__c;
					}
			}
		}
		//some BOM devices are not getting the contract info from previous step. so am doing this here again. 
		/*List<Application__c> applicationList = [select Id, Application_Id__c, Application_Group__c, Application_Contract_Number__c from Application__c where Id in :bomAppIdList];
		system.debug('NEW application BOM list ' + applicationList);
		for (Application__c application : applicationList)  { 
			if (application.Application_Id__c == '82SF00068135')  {
				system.debug('Hey I found application ' + application.Application_Contract_Number__c);
				if (!applicationContractNumberMap.containsKey(application.Id) || (applicationContractNumberMap.get(application.Id) == null))  {
					system.debug('Hey I found application '); 
					applicationContractNumberMap.put(application.Id, application.Application_Contract_Number__c);
				}
				System.debug('Hey I found application ' + applicationContractNumberMap.get(application.Id));
				System.debug('Hey I found application ' + applicationContractNumberMap);
			}
			
		}*/
		system.debug('arcticFoxRevUnitList ' + arcticFoxRevUnitList);
		
		for (Revenue_Unit__c arcticFoxRevUnit :   arcticFoxRevUnitList)  {
			system.debug('arcticFoxRevUnit ' + arcticFoxRevUnit);
			system.debug('applicationAppIdMap is ' + applicationAppIdMap);
			system.debug('arcticFoxRevUnit.Product_Number__c is ' + arcticFoxRevUnit.Product_Number__c);
			system.debug('applicationAppIdMap.get(arcticFoxRevUnit.Product_Number__c) ' + applicationAppIdMap.get(arcticFoxRevUnit.Product_Number__c));
			if (applicationAppIdMap.get(arcticFoxRevUnit.Product_Number__c) == null)  {
				arcticFoxRevUnit.Status__c = Constants.REVUNIT_STATUS_ERROR;
				arcticFoxRevUnit.Message__c = Constants.REVUNIT_APPLICATION_NOT_FOUND_STATUS + arcticFoxRevUnit.Product_Number__c;
			}
			else {
				Z_Usage__c zUsage = populateIndividualZUsageRecords(arcticFoxRevUnit,applicationAppIdMap.get(arcticFoxRevUnit.Product_Number__c).Id);
				zUsageList.add(zUsage);
			}
		}
		//if (!zUsageList.isEmpty())  {
		//	insert zUsageList;
		//}
		//update bomRevUnitList;
		//update arcticFoxRevUnitList;
		return zUsageList;
		//return bomRevUnitList;
	}
	
	/*
		for populating individual zUsage records. this will be updated in other methods. 
	*/
	private Z_Usage__c populateIndividualZUsageRecords(Revenue_Unit__c revUnit, Id applicationId)  {
		Z_Usage__c zUsage = new Z_Usage__c();
		zUsage.APPLICATION__c = applicationId;
		zUsage.Revenue_Unit__c = revUnit.Id;
		//zUsage.STARTDATE__c = Date.parse(revUnit.Invoice_Date__c);
		zUsage.Sales_Model__c = revUnit.Sales_Model__c;
		zUsage.Device__c = revUnit.Device__c;
		zUsage.GL_CC__c = revUnit.GL_CC__c;
		zUsage.GL_APC__c = revUnit.GL_APC__c;
		//zUsage.STARTDATE__c = Date.parse(revUnit.Invoice_Date__c);
		//zUsage.ENDDATE__c = Date.parse(revUnit.Invoice_Date__c);
		zUsage.Revenue_Units__c = revUnit.Revenue_Units__c;
		//zUsage.QTY__c = revUnit.Revenue_Units__c;
		return zUsage;
	}
	
	/*
		this method is called by revUNit trigger to create the RevInvoice records for each revUnit's Invoice_Number with status as Unprocessed. 
		if revUnit's Invoice_Number is null, we will default the invoiceNumber as the revUnit.Id
		if we are inserting revUnit with an invoiceNumber that is already processed, then we will error the revUnit. 
		if we are insertinv revUnit with a batch number that is different from the revInvoice's batch number, then we will error the revUnit
	*/
	public void createRevInvoice(List<Revenue_Unit__c> newRevenueUnitList)  {
		/*List<Revenue_Invoice__c> revInvoiceList = new List<Revenue_Invoice__c>();
		Map<String, Revenue_Invoice__c> revInvoiceMap = new Map<String, Revenue_Invoice__c>();
		Set<String> revInvoiceNumberSet = new Set<String>();
		for (Revenue_Unit__c revUnit : newRevenueUnitList) {
			if (revUnit.Invoice_Number__c != null && !revInvoiceNumberSet.contains(revUnit.Invoice_Number__c))  {
				revInvoiceNumberSet.add(revUnit.Invoice_Number__c);
			}
		}
		List<Revenue_Invoice__c> existingRevInvoiceList = [select Id, Invoice_Number__c, Status__c, Batch_ID__c from Revenue_Invoice__c where Invoice_Number__c in :revInvoiceNumberSet];
		Map<String, Revenue_Invoice__c> invoiceNumberMap = new Map<String, Revenue_Invoice__c> ();
		for (Revenue_Invoice__c existingRevInvoice : existingRevInvoiceList)  {
			invoiceNumberMap.put(existingRevInvoice.Invoice_Number__c, existingRevInvoice);
		}
		for (Revenue_Unit__c revUnit : newRevenueUnitList) { 
			if (revUnit.Invoice_Number__c != null)  {
				if (!invoiceNumberMap.containsKey(revUnit.Invoice_Number__c))  {
					Revenue_Invoice__c revInvoice = new Revenue_Invoice__c();
					revInvoice.Invoice_Number__c = revUnit.Invoice_Number__c;
					revInvoice.Status__c = Constants.REVUNIT_STATUS_UNPROCESSED;
					revInvoice.Batch_Id__c = revUnit.Batch_Id__c;
					revInvoiceList.add(revInvoice);
					invoiceNumberMap.put(revUnit.Invoice_Number__c, revInvoice);
				} 
				else if (invoiceNumberMap.get(revUnit.Invoice_Number__c).Status__c == Constants.REVUNIT_STATUS_PROCESSED)  {
					revUnit.Status__c = Constants.REVUNIT_STATUS_ERROR;
					revUnit.Message__c = Constants.REVUNIT_INVOICE_ALREADY_PROCESSED_STATUS;
				}
				else if (invoiceNumberMap.get(revUnit.Invoice_Number__c).Batch_ID__c != revUnit.Batch_Id__c) {
					revUnit.Status__c = Constants.REVUNIT_STATUS_ERROR;
					revUnit.Message__c = Constants.REVUNIT_INVOICE_ALREADY_IN_DIFFERENT_BATCH;
				}
				
			}
		}
		if (!revInvoiceList.isEmpty())  {
			insert revInvoiceList;
		}
		//we will update the lookup for revenueInvoice in revUnit. 
		for (Revenue_Unit__c revUnit : newRevenueUnitList) { 
			if (revUnit.Invoice_Number__c != null)  {
					revUnit.Revenue_Invoice__c = invoiceNumberMap.get(revUnit.Invoice_Number__c).Id;
			}
		}*/
	}

}