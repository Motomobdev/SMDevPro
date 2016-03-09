public with sharing class Constants {
	
	public static final String REVUNIT_TYPE_BOM = 'MDW';
	public static final String REVUNIT_TYPE_ARCTICFOX = 'MDW_ArcticFox';
	
	public static final String REVUNIT_STATUS_ERROR = 'Error';
	public static final String REVUNIT_STATUS_UNPROCESSED = 'Unprocessed';
	public static final String REVUNIT_STATUS_PROCESSED = 'Processed';
	public static final String REVUNIT_STATUS_REPROCESS = 'Reprocess';
	public static final String REVUNIT_STATUS_INVALID = 'Invalid';
	
	public static final String REVUNIT_STAGE_STAGE0 = 'Stage0';
	public static final String REVUNIT_STAGE_STAGE1 = 'Stage1';
	public static final String REVUNIT_STAGE_STAGE2 = 'Stage2';
	public static final String REVUNIT_STAGE_STAGE3 = 'Stage3';
	public static final String REVUNIT_STAGE_STAGE4 = 'Stage4';
	
	public static final String REVUNIT_SWKIT_NOT_FOUND_STATUS = 'No SWKit or Valid SalesModel is Found for Sales Model ';
	public static final String REVUNIT_DEVICE_NOT_FOUND_STATUS = 'No Device is Found for Sales Model ';
	public static final String REVUNIT_APPLICATION_NOT_FOUND_STATUS = 'No Application is Found for Sales Model ';
	public static final String REVUNIT_INVOICE_ALREADY_PROCESSED_STATUS = 'Invoice is already processed for this unit';
	public static final String REVUNIT_INVOICE_ALREADY_IN_DIFFERENT_BATCH = 'Invoice of this unit is already being processed in a different batch';
	public static final String REVUNIT_ERROR_IN_STEP2 = 'Error in Step 2 - ZUsage Create - unit does not have applications associated to their SalesModel';
	public static final String REVUNIT_ERROR_IN_STEP3 = 'Error in Step 3 - ZUsage Enhance - some applications do not have contract or applicationGroup associated';
	public static final String REVUNIT_ERROR_IN_STEP4 = 'Error in Step 4 - ZUsage Accummulate - some applications do not have charges for the accumulated total or for the prepaid';
	public static final String REVUNIT_ERROR_EXPORT_BATCH_QUARTER = 'Error  - Export Batch is not open for this Quarter';
	public static final String REVUNIT_ERROR_EXPORT_BATCH_PERIOD = 'Error  - Export Batch is not open for this Period';
	public static final String REVUNIT_ERROR_INVOICE_DATE_IS_NOT_CORRECT = 'Error  - Invoice Date is not in correct format';
	
	public static final String ZUSAGE_CONTRACT_NOT_FOUND_STATUS = 'No Contract is Found for Application ';
	public static final String ZUSAGE_APPGROUP_NOT_FOUND_STATUS = 'No ApplicationGroup is Found for the Application ';
	public static final String ZUSAGE_APPGROUP_DATERANGE_NOT_FOUND_STATUS = 'No ApplicationGroup Date Range is Found for Application ';
	public static final String ZUSAGE_APPGROUP_DATERANGE_EXPIRED_STATUS = 'ApplicationGroup Date Range is either Expired or Invalid for that Application ';
	public static final String ZUSAGE_CHARGEID_NOT_FOUND_STATUS = 'No chargeId found for the cumulative for this application ';
		
	public static final String REVINVOICE_ERROR = 'Error in RevUnits.';
	public static final String REVINVOICE_ERROR_ACCOUNTING_CALENDAR = 'Processing Date is not within the Open Accounting Period.';
	public static final String REVINVOICE_MESSAGE_SUCCESS = 'Success';
	
	public static final String UOM_APPSSHIPPED = 'AppsShipped';
	public static final String UOM_APPSRETURNED = 'AppsReturned';
	public static final String UOM_APPSSHIPPED_PREPAID = 'PrePaidAppsShipped';
	public static final String UOM_APPSRETURNED_PREPAID = 'PrePaidAppsReturned';
	
	public static final String PREPAID_YES = 'Yes';
	public static final String PREPAID_NO = 'No';
	
	public static final String ROYALTY_FREE = 'R00 - Royalty Free';
	public static final String ROYALTY_PAYMENT_PREPAID = 'Prepaid';
	public static final String APPLICATION_TYPE_IP_SETTLEMENT = 'IP Settlement';
	
	public static final String SCHEDULE_BOM_EXPLOSION = 'BOMExplosionBatch';
	public static final String SCHEDULE_BOM_REVINVOICEEXPORT = 'BOMRevInvoiceExportBatch';
	public static final String JOBNAME_BOM_EXPLOSION = 'Manual JOB BOMExplosion';
	public static final String JOBNAME_BOM_REVINVOICEEXPORT = 'Manual JOB REVINVOICEEXPORT';
	
	public static final String BATCHID_REQUIRED = 'BatchID is a required field for BOMExplosion process';
	public static final String QUARTERNAME_REQUIRED = 'QuarterName is a required field for BOMRevInvoiceExportBatch process';
	
	public static final String EXPORT_BATCH_ACCOUNT_QUARTER = 'Account Quarter';
	public static final String EXPORT_BATCH_ACCOUNT_PERIOD = 'Account Period';
}