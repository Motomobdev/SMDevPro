public with sharing class Edit_Apttus_Deal_Accessories {

    /*
     * Author: Rajesh Krishnaiah
     * Created date: 21-Mar-2013
     * Description: Allows user to add accessories to an agreement.
     * Test class: DealTestUtility
     *
     * Change history
     * ==============
     */
    private List<Agreement_Accessory__c> aaRecords {get; set;}
    public List<Agreement_Accessory__c> aaMotoRecords {get; set;}
    public List<Agreement_Accessory__c> aaM4DeRecords {get; set;}
    public Apttus__APTS_Agreement__c ag {get; set;}

    Map<Id, Agreement_Accessory__c> oasProductMap =
            new Map<Id, Agreement_Accessory__c>();
    boolean newRecords = false;

    public Edit_Apttus_Deal_Accessories(ApexPages.StandardController controller) {
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();

        aaMotoRecords = new List<Agreement_Accessory__c>();
        aaM4DeRecords = new List<Agreement_Accessory__c>();

        ag = [select id, name, Apttus__FF_Agreement_Number__c,
                APTPS_Product_Family__c, currencyIsoCode
             from Apttus__APTS_Agreement__c
             where id = :ag.id];

        aaRecords = [select id, Agreement__c, Product__c, product_type__c,
                        interested__c, currencyIsoCode,
                        Invoice_Price__c, Quantity__c
                    from Agreement_Accessory__c
                    where Agreement__c = :ag.Id
                    order by product_type__c desc];

        // Build a map of OA records with product ID as the key
        if (!aaRecords.isEmpty()) {
            for (Agreement_Accessory__c aa : aaRecords) {
                oasProductMap.put(aa.Product__c, aa);

                if (aa.product_type__c == 'Accessory-M4DE')
                    aaM4DeRecords.add(aa);
                else
                    aaMotoRecords.add(aa);
            }
        } else
            myRefresh();
    }

    // Recreate Oppty Accessory records
    public PageReference myRefresh() {

        if (!aaRecords.isEmpty()) {
            // Ignore delete errors
            try {
                delete aaRecords;
            } catch (Exception e) {}
        }

        // The save button should insert and NOT upsert
        newRecords = true;

        // Rebuild OAS record list
        aaRecords.clear();

        // Get all accessories from the Product2 object
        List<Product2> accessories =
                    [select id, name, description, type__c
                        from Product2
                        where family = :ag.aptps_product_family__c
                          and isactive = true
                          and type__c like 'Accessory%'
                          order by type__c];

        Set<Id> accessoryIdSet = new Set<Id>();
        for (Product2 p : accessories)
            accessoryIdSet.add(p.id);

        // For each accessory
        for (Product2 p : accessories) {

            Agreement_Accessory__c oas = new Agreement_Accessory__c(
                Agreement__c = ag.Id,
                Product__c = p.id,
                interested__c = false,
                product_type__c = p.type__c,
                currencyIsoCode = ag.currencyIsoCode
            );

            // Check if this product was previously selected
            if (oasProductMap.containsKey(oas.Product__c)) {
                oas.interested__c = oasProductMap.get(oas.Product__c).interested__c;
                oas.invoice_price__c = oasProductMap.get(oas.Product__c).invoice_price__c;
                oas.quantity__c = oasProductMap.get(oas.Product__c).quantity__c;
            }

            // Separate Moto and M4DE accessories for representing them in two tables on the UI
            if (p.type__c == 'Accessory-M4DE')
                aaM4DeRecords.add(oas);
            else
                aaMotoRecords.add(oas);

            aaRecords.add(oas);
        }

        return null;
    }

    public PageReference myRefreshAndSave() {
        myRefresh();
        mySave();
        ApexPages.Message myMsg =
            new ApexPages.Message(ApexPages.Severity.INFO, 'Saved');
        ApexPages.addMessage(myMsg);
        return null;
    }

    public PageReference mySave() {

        for (Agreement_Accessory__c  a4 : aaM4DeRecords) {
            // This stops validation rules
            if (a4.interested__c)
                a4.invoice_price__c = 0;
        }

        try {
            if (newRecords)
                insert aaRecords;
            else
                update aaRecords;
            // Reset
            newRecords = false;
        } catch (Exception e) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,
                    'Unable to save: ' + e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }

        return new PageReference('/' + ag.Id);
    }
}