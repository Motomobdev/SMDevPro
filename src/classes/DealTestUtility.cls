@isTest
public class DealTestUtility {

    /*
     * Author: Rajesh Krishnaiah
     * Created date: 18-Mar-2013
     * Description: Static methods to generate test data for testing Deal Controller.
     */
    public static Account createTestAccount() {
        Account a = new Account(name = 'Deal-Account-1',
            region__c = 'North America',
            Business_Entity_Type__c = 'INC.',
            Entity_Established_State_Country__c='NO WHERE');
        insert a;
        return a;
    }

    public static Account createTestMotoAccount() {
        Account a = new Account(name = 'MOTOROLA MOBILITY LLC.',
            region__c = 'North America',
            Business_Entity_Type__c = 'LLC.',
            Entity_Established_State_Country__c='NO WHERE');
        insert a;
        return a;
    }

    public static Contact createTestContact(Account a) {
        Contact c = new Contact(firstName='Test', lastName='Me',
            email='test@example.com', accountId=a.id);
        insert c;
        return c;
    }

    public static List<Product2> createProducts() {
        List<Product2> products = new Product2[]{
           new Product2(name = 'DVX', isactive=true, type__c = 'Smartphone', family = 'DVX'),
           new Product2(name = 'DVX-Accessory-1', isactive=true, type__c = 'Accessory', family = 'DVX'),
           new Product2(name = 'DVX-Accessory-2', isactive=true, type__c = 'Accessory', family = 'DVX'),
           new Product2(name = 'DVX-Accessory-3', isactive=true, type__c = 'Accessory-M4DE', family = 'DVX'),
           new Product2(name = 'DVX-Accessory-3', isactive=true, type__c = 'Accessory-M4DE', family = 'DVX'),
           new Product2(name = 'Mod', isactive=true, type__c = 'Option', family = 'DVX')
        };

        insert products;

        return products;
    }

    public testmethod static void test_createdAndEditDeals() {
        Account a = DealTestUtility.createTestAccount();
        Contact c = DealTestUtility.createTestContact(a);
        Account motoAccount = DealTestUtility.createTestMotoAccount();

        List<Product2> products = DealTestUtility.createProducts();

        Apttus__APTS_Agreement__c  ag =
            new Apttus__APTS_Agreement__c(Apttus__Account__c=a.id,
                Apttus__Primary_Contact__c=c.id,
                Legal_Owner__c=UserInfo.getUserId(),
                Business_Unit_Finance_Approver__c=UserInfo.getUserId(),
                Internal_Business_Owner__c=UserInfo.getUserId(),
                Apttus__Contract_Start_Date__c=System.today(),
                Apttus__Contract_End_Date__c=System.today().addYears(1),
                APTPS_Product_Family__c='DVX',
                APTPS_Purchase_Commitment_Type__c='Minimum Purchase;Volume Target Purchase;Initial Purchase Order',
                APTPS_Motorola_Legal_Entity__c=motoAccount.id,
                APTPS_Authorized_Countries__c='USA'
                );

        ApexPages.StandardController sc = new ApexPages.StandardController(ag);

        Test.setCurrentPage(Page.Create_Apttus_Deal);
        ApexPages.CurrentPage().getparameters().put('productFamily', 'DVX');

        // The class constructor fills in the Agreement record with default values
        Create_Apttus_Deal cd = new Create_Apttus_Deal(sc);
        cd.populateChannelPartnerInfo();
        cd.populateMotorolaAccountInfo();
        cd.populateContactInfo();

        cd.channelPartner = a;
        cd.populateChannelPartnerInfo();

        // Simulate email address change
        cd.email = 'test2@example.com';

        cd.mySave(); // * * * This step adds lines to the opportunity * * *

        system.assert(ag.id != null);
        system.assert(sc != null);

        List<Apttus__AgreementLineItem__c> aglis = [SELECT APTPS_Modification_To_Section__c, APTPS_Product_Type__c,
            APTPS_Total_Price__c, Apttus__AgreementId__c,
            Apttus__Description__c, Apttus__ExtendedPrice__c, APTPS_Invoice_Price__c,
            Apttus__ProductId__c, Apttus__ProductId__r.name, Apttus__ProductId__r.description,
            Apttus__ProductId__r.type__c, Apttus__Quantity__c, Id, Name
            FROM Apttus__AgreementLineItem__c
            WHERE Apttus__AgreementId__c = :ag.Id
            order by Id];

        List<Apttus__AgreementLineItem__c> phoneAglis = new List<Apttus__AgreementLineItem__c>();
        String deleteAgliId = null;

        for (Apttus__AgreementLineItem__c agli : aglis) {
            if (agli.APTPS_product_type__c == 'Smartphone')
                phoneAglis.add(agli);
            else
                deleteAgliId = agli.id;
        }

        Integer i = 1;
        for (Apttus__AgreementLineItem__c phoneAgli : phoneAglis) {
            phoneAgli.APTPS_Minimum_Commitment_Quantity__c = (i * 1000);
            phoneAgli.APTPS_Vol_Target_Purchase_Quantity__c = (i * 1000) * 10;
            phoneAgli.APTPS_Initial_PO_Quantity__c = (i * 1000) * 5;
            ++i;
        }

        if (!phoneAglis.isEmpty())
            update phoneAglis;

        Test.setCurrentPage(Page.Edit_Apttus_Deal_Lines);
        ApexPages.CurrentPage().getparameters().put('showAccessories', 'true');

        Edit_Apttus_Deal_Lines edl = new Edit_Apttus_Deal_Lines(sc);
        edl.mySave();

        edl.addProductLine();
        edl.activeProdRowNum = 0;
        edl.deleteProduct();

        edl.addModification();
        edl.activeModRowNum = 0;
        edl.deleteMod();

        if (!edl.prodCaglis.isEmpty()) {
            edl.activeProdRowNum = 0;
            edl.updateProductLine();
            edl.prodCaglis[0].getTotalCommit();
        }

        Test.setCurrentPage(Page.Edit_Apttus_Deal_Accessories);

        Edit_Apttus_Deal_Accessories eda = new Edit_Apttus_Deal_Accessories(
                new ApexPages.StandardController(ag));
        if (!eda.aaMotoRecords.isEmpty()) {
            eda.aaMotoRecords[0].invoice_price__c = 1;
            eda.aaMotoRecords[0].interested__c = true;
        }

        if (!eda.aaM4deRecords.isEmpty()) {
            eda.aaM4deRecords[0].interested__c = true;
        }
        eda.myRefreshAndSave();

        // Simulate reloading an agreement that has accessories selected
        eda = new Edit_Apttus_Deal_Accessories(sc);
        eda.myRefreshAndSave();

        // Test.setCurrentPage(Page.Edit_Apttus_Agreement);
        // Edit_Apttus_Agreement eaa = new Edit_Apttus_Agreement(sc);
        // eaa.getRedir();
    }
}