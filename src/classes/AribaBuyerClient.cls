public class AribaBuyerClient {   

    Blob bl = Blob.valueOf('sfdc' + ':' + 'go2motorola123');
    String authToken = 'Basic ' + EncodingUtil.base64Encode(bl);
    External_Spend_Request__c esr = null;
    
    // Input: The ID of the external spend request record
    public AribaBuyerClient(String esrId) {
    
        esr  = [select id, name, Account__c, Agreement__c, Total_Cost__c,
                    Convert_this_to_master_agreement__c, Deal_Description__c,
                    currencyIsoCode, contract_status__c,
                    contract_start_date__c, contract_end_date__c,
                    Requester_Commerce_ID__c, Ariba_Commodity_Code__c,
                    Title__c, Account__r.oracle_customer_number__c
                   from External_Spend_Request__c
                   where id = :esrId];
        system.debug('Rajesh -> Authorization: ' + authToken);
        if (esr == null)
            system.debug('Invalid ESR ID: ' + esrId);
    }
        
    public void process() {

        AribaBuyer.Requisition_RequisitionImportPull pullItem
                = new AribaBuyer.Requisition_RequisitionImportPull();

        pullItem.ImportedHeaderCommentStaging = esr.deal_description__c;
        pullItem.ImportedHeaderExternalCommentStaging = true;
        pullItem.Name = esr.Title__c;
        pullItem.UniqueName = esr.name;
        pullItem.OriginatingSystem = 'SFDC';
        pullItem.OriginatingSystemReferenceID = esr.name;
        
        AribaBuyer.Preparer_element preparer = new AribaBuyer.Preparer_element();
        preparer.PasswordAdapter = 'PasswordAdapter1';
        preparer.UniqueName = esr.Requester_Commerce_ID__c; // TODO
        pullItem.Preparer = preparer;
        
        AribaBuyer.Requester_element requestor = new AribaBuyer.Requester_element();
        requestor.PasswordAdapter = 'PasswordAdapter1';
        requestor.UniqueName = esr.Requester_Commerce_ID__c;        
        pullItem.Requester = requestor;
        
        AribaBuyer.item_element item = new AribaBuyer.item_element();
            AribaBuyer.BillingAddress_element billing = new AribaBuyer.BillingAddress_element();        
            billing.UniqueName = 'USBILLING';  // TODO
            item.BillingAddress = billing;
    
            AribaBuyer.ShipTo_element shipTo = new AribaBuyer.ShipTo_element();
            shipTo.UniqueName = 'AD10610026'; // TODO
            item.ShipTo = shipTo;
            
            AribaBuyer.CommodityCode_element commodityCode = new AribaBuyer.CommodityCode_element();
            commodityCode.UniqueName = esr.Ariba_Commodity_Code__c; 
            item.CommodityCode = commodityCode;
            
            AribaBuyer.Description_element description = new AribaBuyer.Description_element();
        	AribaBuyer.CommonCommodityCode_element cc = new AribaBuyer.CommonCommodityCode_element();
        		cc.UniqueName = esr.Ariba_Commodity_Code__c;
        		cc.Domain = '32';
            description.CommonCommodityCode = cc;
        	description.Description = 'Test1234567890';
        	description.ManPartNumber = 'NX2086-14-647';
        	description.SupplierPartNumber = 'NX2086-14-647';
        	description.SupplierPartAuxiliaryID = 'NX2086-14-647';
        		AribaBuyer.Price_element price = new AribaBuyer.Price_element();
        		price.amount = 1069.02;
        
        			AribaBuyer.Currency_element cur = new AribaBuyer.Currency_element();
        			cur.UniqueName = 'USD';
        
        		price.Currency_x = cur;
        	description.Price = price;
        
        	AribaBuyer.UnitOfMeasure_element uom = new AribaBuyer.UnitOfMeasure_element();
        	uom.UniqueName = 'EA';
        
        	description.UnitOfMeasure = uom;
        item.Description = description;
        item.NumberInCollection = 1;
        item.OriginatingSystemLineNumber = 1;
        item.Quantity = 1;
        item.ImportedDeliverToStaging = 'false';
        
        AribaBuyer.Supplier_element supplier = new AribaBuyer.Supplier_element();
        supplier.UniqueName = '1092919';
        item.Supplier = supplier;
        
        AribaBuyer.SupplierLocation_element supplierLocation =
            new AribaBuyer.SupplierLocation_element();
        supplierLocation.UniqueName = '1029476-003';
        supplierLocation.ContactId = 'ERIC AROD';
        item.SupplierLocation = supplierLocation;
        
        item.ImportedLineCommentStaging = 'ImportedLineCommentStaging';
        item.ImportedLineExternalCommentStaging = false;
        item.ImportedNeedByStaging = system.now();
        
        pullitem.LineItems = new AribaBuyer.LineItems_element();
        pullitem.LineItems.item = new List<AribaBuyer.item_element>();
        pullitem.LineItems.item.add(item);
        
        AribaBuyer.Requisition_RequisitionImportPull_Item_element parentNode =
            new AribaBuyer.Requisition_RequisitionImportPull_Item_element();
            
        parentNode.item = new List<AribaBuyer.Requisition_RequisitionImportPull>();
        parentNode.item.add(pullItem);
        
        system.debug('Step 1');
       	AribaBuyer.Headers_element header = new AribaBuyer.Headers_element();
        header.variant = 'vrealm_780';
        header.partition = 'prealm_780';
        
        AribaBuyer.RequisitionImportPullPortType ws = 
           new AribaBuyer.RequisitionImportPullPortType();

        // Login details
        ws.inputHttpHeaders_x = new Map<String,String>();
        ws.inputHttpHeaders_x.put('Authorization', authToken);
        ws.inputHttpHeaders_x.put('Accept-Encoding', 'gzip,deflate');

		ws.header = header;
        
        //AribaBuyer.Requisition_RequisitionIdExport_Item_element response = 
        system.debug(ws.RequisitionImportPullOperation(parentNode));
        system.debug('Step 2');
        //system.debug(response.item[0].UniqueName);
    }
}