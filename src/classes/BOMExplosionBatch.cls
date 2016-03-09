global class BOMExplosionBatch implements Database.Batchable<sObject>, Database.Stateful {

	
	//global List<Revenue_Unit__c> revUnitSizeList;
	//global Integer revUnitListSize;
	//Integer batchSize = 25;
	//Integer retryWindow = 24;
	
	global BOMExplosionBatch()  {
	}

	/*
		if the BatchId is not specified, we will process all revInvoices with status as error
		if the batchId is specified and ErrorFlag is false, we will process all revInvoices with that particular batchId
		if the batchId is specified and ErrorFlag is true, we will process all revInvoices with that particular batchId or revInvoices with status as error
	*/
	global Database.QueryLocator start(Database.BatchableContext BC){
		
		String query;	
		
		//query = 'select Id, Account_Quarter__c, Account_Period__c, Acct_Calendar__c, AP_ExportID__c, ProcessedDate__c, BackDate__c, AQ_ExportID__c, DATA_SOURCE__c, TRANSACTION_TYPE__c, REGION__c, COUNTRY__c, CUSTOMER_FTT__c, Customer_Name__c, CUSTOMER_NUMBER__c, SALES_ORDER_NUMBER__c, Order_Line_Number__c, INVOICE_NUMBER__c, PACK_DATE__c, SHIP_DATE__c, INVOICE_DATE__c, PACKING_LIST_NUMBER__c, PRODUCT_NUMBER__c, Product_Description__c, INTERNAL_NAME__c, ITEM_MARKET_NAME__c, GL_LEGAL_ENTITY__c, GL_BUSINESS_GROUP__c, GL_ACCOUNT__c, GL_TOS__c, GL_CC__c, GL_APC__c, Intercompany__c, FUTURE_1__c, FUTURE_2__c, APC_DESCRIPTION__c, CurrencyIsoCode, Item_Type_Description__c, REVENUE_UNITS__c, ON_INVOICE_UNITS__c, NSAD__c, REVENUE_SOURCE__c, FISCAL_MONTH__c, Status__c, Stage__c, Message__c, SWKit__c, Device__c, Sales_Model__c from Revenue_Unit__c where Status__c = \'' + Constants.REVUNIT_STATUS_UNPROCESSED + '\'' + ' OR Status__c = \'' + Constants.REVUNIT_STATUS_REPROCESS + '\'' + ' OR (LastModifiedDate < ' + DateStr + ' AND Status__c = \'' + Constants.REVUNIT_STATUS_ERROR + '\') order by Status__c desc, LastModifiedDate LIMIT ' + batchSize;
		//system.debug('Query is ' + query);
		if (!Test.isRunningTest())   {
			query = 'select Id, Account_Quarter__c, Account_Period__c, Acct_Calendar__c, AP_ExportID__c, ProcessedDate__c, BackDate__c, AQ_ExportID__c, DATA_SOURCE__c, TRANSACTION_TYPE__c, REGION__c, COUNTRY__c, CUSTOMER_FTT__c, Customer_Name__c, CUSTOMER_NUMBER__c, SALES_ORDER_NUMBER__c, Order_Line_Number__c, INVOICE_NUMBER__c, PACK_DATE__c, SHIP_DATE__c, INVOICE_DATE__c, PACKING_LIST_NUMBER__c, PRODUCT_NUMBER__c, Product_Description__c, INTERNAL_NAME__c, ITEM_MARKET_NAME__c, GL_LEGAL_ENTITY__c, GL_BUSINESS_GROUP__c, GL_ACCOUNT__c, GL_TOS__c, GL_CC__c, GL_APC__c, Intercompany__c, FUTURE_1__c, FUTURE_2__c, APC_DESCRIPTION__c, CurrencyIsoCode, Item_Type_Description__c, REVENUE_UNITS__c, ON_INVOICE_UNITS__c, NSAD__c, REVENUE_SOURCE__c, FISCAL_MONTH__c, Status__c, Stage__c, Message__c, SWKit__c, Device__c, Sales_Model__c from Revenue_Unit__c where Status__c = \'' + Constants.REVUNIT_STATUS_UNPROCESSED + '\'' + ' OR Status__c = \'' + Constants.REVUNIT_STATUS_REPROCESS + '\'' + ' OR Status__c = \'' + Constants.REVUNIT_STATUS_ERROR + '\' order by Status__c desc, LastModifiedDate';
		}
		else {
			query = 'select Id, Account_Quarter__c, Account_Period__c, Acct_Calendar__c, AP_ExportID__c, ProcessedDate__c, BackDate__c, AQ_ExportID__c, DATA_SOURCE__c, TRANSACTION_TYPE__c, REGION__c, COUNTRY__c, CUSTOMER_FTT__c, Customer_Name__c, CUSTOMER_NUMBER__c, SALES_ORDER_NUMBER__c, Order_Line_Number__c, INVOICE_NUMBER__c, PACK_DATE__c, SHIP_DATE__c, INVOICE_DATE__c, PACKING_LIST_NUMBER__c, PRODUCT_NUMBER__c, Product_Description__c, INTERNAL_NAME__c, ITEM_MARKET_NAME__c, GL_LEGAL_ENTITY__c, GL_BUSINESS_GROUP__c, GL_ACCOUNT__c, GL_TOS__c, GL_CC__c, GL_APC__c, Intercompany__c, FUTURE_1__c, FUTURE_2__c, APC_DESCRIPTION__c, CurrencyIsoCode, Item_Type_Description__c, REVENUE_UNITS__c, ON_INVOICE_UNITS__c, NSAD__c, REVENUE_SOURCE__c, FISCAL_MONTH__c, Status__c, Stage__c, Message__c, SWKit__c, Device__c, Sales_Model__c from Revenue_Unit__c where Status__c = \'' + Constants.REVUNIT_STATUS_UNPROCESSED + '\'' + ' OR Status__c = \'' + Constants.REVUNIT_STATUS_REPROCESS + '\'' + ' OR Status__c = \'' + Constants.REVUNIT_STATUS_ERROR + '\' order by Status__c desc, LastModifiedDate desc limit 100';
		}
		//query = 'select Id, Account_Quarter__c, Account_Period__c, Acct_Calendar__c, AP_ExportID__c, ProcessedDate__c, BackDate__c, AQ_ExportID__c, DATA_SOURCE__c, TRANSACTION_TYPE__c, REGION__c, COUNTRY__c, CUSTOMER_FTT__c, Customer_Name__c, CUSTOMER_NUMBER__c, SALES_ORDER_NUMBER__c, Order_Line_Number__c, INVOICE_NUMBER__c, PACK_DATE__c, SHIP_DATE__c, INVOICE_DATE__c, PACKING_LIST_NUMBER__c, PRODUCT_NUMBER__c, Product_Description__c, INTERNAL_NAME__c, ITEM_MARKET_NAME__c, GL_LEGAL_ENTITY__c, GL_BUSINESS_GROUP__c, GL_ACCOUNT__c, GL_TOS__c, GL_CC__c, GL_APC__c, Intercompany__c, FUTURE_1__c, FUTURE_2__c, APC_DESCRIPTION__c, CurrencyIsoCode, Item_Type_Description__c, REVENUE_UNITS__c, ON_INVOICE_UNITS__c, NSAD__c, REVENUE_SOURCE__c, FISCAL_MONTH__c, Status__c, Stage__c, Message__c, SWKit__c, Device__c, Sales_Model__c from Revenue_Unit__c where Batch_Id__c = \'111\' AND (LastModifiedDate < ' + DateStr + ' OR Status__c = \'' + Constants.REVUNIT_STATUS_ERROR + '\'' + ') order by Status__c desc, LastModifiedDate LIMIT ' + batchSize;
		system.debug('Query is ' + query);
		
		return Database.getQueryLocator(query);
		
	}
   
    
    global void execute(Database.BatchableContext BC, List<Revenue_Unit__c> revUnitList){
    	
    	if (revUnitList != null && !revUnitList.isEmpty())  {
    		
    		Integer i = 0;
    		//get the open account calendar period where StartDate < currentProcessingDate < EndDate
	    	List<Acct_Calendar__c> acctCalendarList = [select Id, PeriodName__c, QuarterName__c, StartDate__c, EndDate__c from Acct_Calendar__c where ClosedFlag__c = FALSE];
	    	List<Export_Batch__c> exportBatchList = [select Name, Export_Date__c, Tag__c, Type__c from Export_Batch__c where Export_Date__c = null];
	    	Map<String, List<Export_Batch__c>> exportBatchQuarterMap = new Map<String, List<Export_Batch__c>>();
	    	Map<String, List<Export_Batch__c>> exportBatchPeriodMap = new Map<String, List<Export_Batch__c>>();
	    	//find the open exportBatch entries for a quarter and for a period and store them in two separate maps. 
	    	for (Export_Batch__c exportBatch : exportBatchList)  { 
	    		if (exportBatch.Type__c == Constants.EXPORT_BATCH_ACCOUNT_QUARTER)  {
					List<Export_Batch__c> expList;
					if (!exportBatchQuarterMap.containsKey(exportBatch.Tag__c))  {
						expList = new List<Export_Batch__c>();
						expList.add(exportBatch);
						exportBatchQuarterMap.put(exportBatch.Tag__c, expList);
					}
					else {
						expList = exportBatchQuarterMap.get(exportBatch.Tag__c);
						expList.add(exportBatch);
						exportBatchQuarterMap.put(exportBatch.Tag__c, expList);
					}
	    		}
	    		else if (exportBatch.Type__c == Constants.EXPORT_BATCH_ACCOUNT_PERIOD)  {
	    			List<Export_Batch__c> expList;
					if (!exportBatchPeriodMap.containsKey(exportBatch.Tag__c))  {
						expList = new List<Export_Batch__c>();
						expList.add(exportBatch);
						exportBatchPeriodMap.put(exportBatch.Tag__c, expList);
					}
					else {
						expList = exportBatchPeriodMap.get(exportBatch.Tag__c);
						expList.add(exportBatch);
						exportBatchPeriodMap.put(exportBatch.Tag__c, expList);
					}
	    		}
	    	}
	    	List<Revenue_Unit__c> successfulRevUnitList = new List<Revenue_Unit__c>();
			for (Revenue_Unit__c revUnit : revUnitList)  {
				Date currentProcessingDate = System.today();
				if (revUnit.BackDate__c != null)  {
					currentProcessingDate = revUnit.BackDate__c;
				}
				revUnit.ProcessedDate__c = currentProcessingDate;
				Boolean calendarFound = false;
				//get the open account calendar period where StartDate <= currentProcessingDate-1 <= EndDate
				for (Acct_Calendar__c acctCalendar : acctCalendarList)  {
					if (acctCalendar.StartDate__c <= currentProcessingDate - 1 && acctCalendar.EndDate__c >= currentProcessingDate - 1)  {
						revUnit.Acct_Calendar__c = acctCalendar.Id;
						revUnit.Account_Period__c = acctCalendar.PeriodName__c;
						revUnit.Account_Quarter__c = acctCalendar.QuarterName__c;
						calendarFound = true;
						break;
					}
				}
				if (calendarFound == false)  {
					revUnit.status__c = Constants.REVUNIT_STATUS_ERROR;
					revUnit.Message__c = Constants.REVINVOICE_ERROR_ACCOUNTING_CALENDAR;
				}
				else {
					successfulRevUnitList.add(revUnit);
				}
			}
	
	    	BOMExplosionBase bomexplosionBase = new BOMExplosionBase();
			//try {
				bomexplosionBase.RevenueUnitEnhance(successfulRevUnitList);
				bomexplosionBase.ZUsageCreate(successfulRevUnitList, exportBatchQuarterMap, exportBatchPeriodMap);
			
				//bomexplosionBase.ZUsageEnhance(revUnitList, currentProcessingDate, acctCalendarList[0]);
				//bomexplosionBase.ZUsageAccummulate(successfulRevUnitList, exportBatchQuarterMap, exportBatchPeriodMap);
				update revUnitList;
			//}
			//catch (Exception ex) {
			//	System.debug('Error in batch process is ' + ex.getMessage());
			//}
    	}
    }

	global void finish(Database.BatchableContext BC){
		/*system.debug('revUnitListSize' + revUnitListSize);
		System.debug('revUnitSizeList ' + revUnitSizeList);
		System.debug('revUnitSizeList ' + revUnitSizeList.size());
		system.debug('batchSize' + batchSize);
		if (revUnitListSize > 0)  {
			BOMExplosionBatch bomExpBatch = new BOMExplosionBatch();
			ID batchprocessid = Database.executeBatch(bomExpBatch);
		}*/
	}
}