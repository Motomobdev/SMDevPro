public with sharing class Edit_Apttus_Deal_Lines {
    /*
     * Author: Rajesh Krishnaiah
     * Created date: 18-Mar-2013
     * Description: Allows the user to edit deal/Agreement line items.
     * This class is different from the standard multi line opportunity line edit class
     * Test class: DealTestUtility
     *
     * Change history
     * =====
     */

    ApexPages.StandardController controller;
    public Apttus__APTS_Agreement__c ag {get; set;}

    public List<CustomAgreementLineItem> prodCaglis {get; set;}
    public List<CustomAgreementLineItem> modCaglis {get; set;}

    boolean showAccessories = false;

    // Used for collecting deleted OLIs
    private List<Apttus__AgreementLineItem__c> deletedCagli =
        new List<Apttus__AgreementLineItem__c>();
    public Integer activeProdRowNum {get; set;}
    public Integer activeModRowNum {get; set;}

    Product2 modProduct = null;

    public Edit_Apttus_Deal_Lines(ApexPages.StandardController ctrl) {
        controller = ctrl;
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();

        String temp = ApexPages.currentPage().getParameters().get('showAccessories');

        if (temp != null && temp == 'true')
            showAccessories = true;

        List<Apttus__AgreementLineItem__c> aglis =
            [SELECT APTPS_Modification_To_Section__c, APTPS_Product_Type__c,
            APTPS_Total_Price__c, Apttus__AgreementId__c,
            Apttus__Description__c, Apttus__ExtendedPrice__c, APTPS_Invoice_Price__c,
            Apttus__ProductId__c, Apttus__ProductId__r.name,
            Apttus__ProductId__r.description, APTPS_Recommended_Retail_Price_Point__c,
            Apttus__ProductId__r.type__c, Id, Apttus__Quantity__c, Name,
            APTPS_Vol_Target_Purchase_Quantity__c, APTPS_Initial_PO_Quantity__c,
            APTPS_Minimum_Commitment_Quantity__c,
            currencyIsoCode
            FROM Apttus__AgreementLineItem__c
            WHERE Apttus__AgreementId__c = :ag.Id
            order by Id];

        prodCaglis = new List<CustomAgreementLineItem>();
        modCaglis = new List<CustomAgreementLineItem>();

        for (Apttus__AgreementLineItem__c agli : aglis) {
            CustomAgreementLineItem cagli = new CustomAgreementLineItem(agli);

            if (agli.Apttus__ProductId__r.name == 'Mod' &&
                agli.Apttus__ProductId__r.type__c == 'Option') {
                cagli.counter = modCaglis.size(); // Zero based counter
                modCaglis.add(cagli);
            } else {
            	cagli.counter = prodCaglis.size(); // Zero based counter
                prodCaglis.add(cagli);
            }
        }

        // Select predefined "Mod" product of type Option
        List<Product2> modProds = [SELECT id, name, type__c
                                FROM Product2
                                WHERE name = 'Mod'
                                  AND type__c = 'Option'];
        if (!modProds.isEmpty())
            modProduct = modProds[0];
    }

    public PageReference mySave() {

        List<Apttus__AgreementLineItem__c> newAglis = new List<Apttus__AgreementLineItem__c>();
        List<Apttus__AgreementLineItem__c> oldAglis = new List<Apttus__AgreementLineItem__c>();

        Double totalProdQty = 0.0;

        // Purchase commitment types
        String[] purchaseCommitTypes = ag.APTPS_Purchase_Commitment_Type__c.split(';');
        boolean minimumPurchase = false;
        boolean volumeTargetPurcahse = false;
        boolean initialPurchaseOrder = false;

        for (String pcType : purchaseCommitTypes) {
            system.debug(pcType);
            if (pcType == 'Minimum Purchase')
                minimumPurchase = true;
            if (pcType == 'Volume Target Purchase')
                volumeTargetPurcahse = true;
            if(pcType == 'Initial Purchase Order')
                initialPurchaseOrder = true;
        }

        for (CustomAgreementLineItem cagli : prodCaglis) {
            Double minimumPurchaseQuantity = 0.0;
            Double volumeTargetPurcahseQuantity = 0.0;
            Double initialPurchaseOrderQuantity = 0.0;

            if (minimumPurchase)
                minimumPurchaseQuantity = cagli.agli.APTPS_Minimum_Commitment_Quantity__c;
            else
                cagli.agli.APTPS_Minimum_Commitment_Quantity__c = null;

            if (volumeTargetPurcahse)
                volumeTargetPurcahseQuantity = cagli.agli.APTPS_Vol_Target_Purchase_Quantity__c;
            else
                cagli.agli.APTPS_Vol_Target_Purchase_Quantity__c = null;

            if (initialPurchaseOrder)
                initialPurchaseOrderQuantity = cagli.agli.APTPS_Initial_PO_Quantity__c;
            else
                cagli.agli.APTPS_Initial_PO_Quantity__c = null;

            Double maxQty = math.max(volumeTargetPurcahseQuantity,
                math.max(minimumPurchaseQuantity, initialPurchaseOrderQuantity));

            system.debug('volumeTargetPurcahseQuantity: ' + volumeTargetPurcahseQuantity);
            system.debug('minimumPurchaseQuantity: ' + minimumPurchaseQuantity);
            system.debug('minimumPurchaseQuantity: ' + minimumPurchaseQuantity);
            system.debug('maxQty: ' + maxQty);

            cagli.agli.Apttus__Quantity__c = maxQty;
            if (maxQty == null || maxQty <= 0.0) {
                cagli.agli.Apttus__Quantity__c = 0;
                cagli.agli.APTPS_Invoice_Price__c = 0;
            }

            totalProdQty += maxQty;
        }

        // Mod Quantity = Sum(Product Quantity)
        for (CustomAgreementLineItem cagli : modCaglis) {
            cagli.agli.Apttus__Quantity__c = totalProdQty;
        }

        // Separate new and old lines so update and/or insert calls can be made
        List<CustomAgreementLineItem> allAglis = new List<CustomAgreementLineItem>();
        allAglis.addAll(prodCaglis);
        allAglis.addAll(modCaglis);

        for (CustomAgreementLineItem cagli : allAglis) {

            cagli.agli.currencyIsoCode = ag.currencyIsoCode;

            if (cagli.agli.id == null)
                newAglis.add(cagli.agli);
            else
                oldAglis.add(cagli.agli);
        }

        // Commit all changes
        try {
            if (!oldAglis.isEmpty())
                update oldAglis;

            if (!newAglis.isEmpty())
                insert newAglis;

            if (!deletedcagli.isEmpty())
                delete deletedCagli;

            // Save agreement details
            update ag;

        } catch (Exception e) {
            String message = 'Unable to save agreement lines: ' + e.getMessage();
            ApexPages.Message myMsg =
                new ApexPages.Message(ApexPages.Severity.FATAL, message);
            ApexPages.addMessage(myMsg);
            return null;
        }

        // Show agreement accessory page if needed
        PageReference returnPage = new PageReference('/' + ag.Id);
        if (showAccessories) {
            returnPage = Page.Edit_Apttus_Deal_Accessories;
            returnPage.getParameters().put('id', ag.id); //TODO
        }

        return returnPage;
   	}

    public PageReference addProductLine() {
		CustomAgreementLineItem cagli =
            new CustomAgreementLineItem(new Apttus__AgreementLineItem__c(
                        Apttus__AgreementId__c = ag.id,
                        APTPS_Product_Type__c = 'Smartphone',
                        Apttus__Quantity__c = null,
                        APTPS_Invoice_Price__c = null,
                        APTPS_Recommended_Retail_Price_Point__c = null
                ));

        cagli.counter = prodCaglis.size();
		prodCaglis.add(cagli);
		return null;
    }

    public void updateProductLine() {
        CustomAgreementLineItem cagli = prodCaglis[activeProdRowNum];

        if (cagli.agli.Apttus__ProductId__c == null)
            return;

        List<Product2> products = [select id, type__c, description
                from Product2 where id = :cagli.agli.Apttus__ProductId__c];

        if (products.isEmpty())
            return;

        // Causes isSmartPhone to re-evaluate
        cagli.agli.APTPS_Product_Type__c = products[0].type__c;
        cagli.agli.Apttus__Description__c = products[0].description;
    }

   	public PageReference addModification() {

       if (modProduct == null) {
            ApexPages.Message myMsg =
                new ApexPages.Message(ApexPages.Severity.ERROR,
                    'Have your business admin define the "Mod" product.');
            ApexPages.addMessage(myMsg);
            return null;
       }

       CustomAgreementLineItem cagli =
            new CustomAgreementLineItem(new Apttus__AgreementLineItem__c(
                        Apttus__AgreementId__c = ag.id,
                        Apttus__Quantity__c = 0,
                        APTPS_Invoice_Price__c = 0,
                		APTPS_Recommended_Retail_Price_Point__c = null,
                        Apttus__ProductId__c = modProduct.id,
                        APTPS_Product_Type__c = modProduct.type__c
                ));

       cagli.counter = modCaglis.size();
       modCaglis.add(cagli);

       return null;
    }

    public void deleteProduct() {
        // Unsaved records will have null ID
        if (prodCaglis[activeProdRowNum].agli.id != null)
            deletedCagli.add(prodCaglis[activeProdRowNum].agli);

        prodCaglis.remove(activeProdRowNum);

        // Update counter value
        Integer i = 0;
        for (CustomAgreementLineItem cagli : prodCaglis)
            cagli.counter = i++;
    }

    public void deleteMod() {
        // Unsaved records will have null ID
        if (modCaglis[activeModRowNum].agli.id != null)
            deletedCagli.add(modCaglis[activeModRowNum].agli);

        modCaglis.remove(activeModRowNum);

        // Update counter value
        Integer i = 0;
        for (CustomAgreementLineItem cagli : modCaglis)
            cagli.counter = i++;
    }

    // This class is used merely to render the total commit value
    // on the fly using VF page's action support tag
    public class CustomAgreementLineItem {

        public Apttus__AgreementLineItem__c agli {get; set;}
        private Decimal totalCommit;
        public Integer counter {get; set;} // Zero based counter - used for deletion
        public Boolean isSmartPhone {
            get { return agli.APTPS_Product_Type__c == 'Smartphone';}}

        public CustomAgreementLineItem(Apttus__AgreementLineItem__c tagli) {
            agli = tagli;
        }

        public Decimal getTotalCommit() {
            Decimal returnValue = 0.0;

            if (agli.apttus__Quantity__c != null && agli.APTPS_Invoice_Price__c != null)
                returnValue =  agli.apttus__Quantity__c * agli.APTPS_Invoice_Price__c;

            return returnValue;
        }
    }
}