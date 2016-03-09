public class InvAndPackingSlipImageController {

    String customerNumber;
    String invoiceNumber;
    String doctype;
    ID accountid;

  
    public InvAndPackingSlipImageController() {
      customerNumber = ApexPages.currentPage().getParameters().get('cust_number');
      invoiceNumber = ApexPages.currentPage().getParameters().get('inv_number');
      doctype = ApexPages.currentPage().getParameters().get('doc_type');
      accountid = ApexPages.currentPage().getParameters().get('account_id');
      
    }
  
    public PageReference getPdf() {
       try{
        Image_Callout_Auth__c setting = Image_Callout_Auth__c.getInstance();
        
        InvoiceAndPackSlipImageService.SAS_4_3_3_getInvoiceImage_V10_Request
        request = new InvoiceAndPackSlipImageService.SAS_4_3_3_getInvoiceImage_V10_Request();

        request.cust_number = customerNumber;
        request.invoice_number = invoiceNumber;
        request.doc_type = doctype;
        request.f_o_xnumber = 'BCS';
        
        Blob bl = Blob.valueOf(setting.User_name__c + ':' + setting.password__c);
        String authToken = EncodingUtil.base64Encode(bl);
        
        InvoiceAndPackSlipImageService.MainPort imageService = new InvoiceAndPackSlipImageService.MainPort();
        imageService.inputHttpHeaders_x = new Map<String,String>();
        imageService.inputHttpHeaders_x.put('Authorization', 'Basic ' + authToken);
        imageService.Timeout_x = 60000;
        InvoiceAndPackSlipImageService.SAS_4_3_3_getInvoiceImage_V10_Response
        response = imageService.MainService(request);
         
        bl = EncodingUtil.base64Decode(response.Response);

        Attachment a = new Attachment(Parentid=accountid , Body=bl, 
        Name='Invoice-' + invoiceNumber + '.pdf');
        insert a;
 
        PageReference attachmentPage = 
        new PageReference('/servlet/servlet.FileDownload?file=' + a.id);
        attachmentPage.setRedirect(true);
        
        /*List<Attachment> l = [Select id from attachment where id <> :a.id and Parentid='0013000000XtlAc'];
        for(Attachment at :l)
        {
            delete at;
        }*/
        
        return attachmentPage;
        }
        catch (System.Exception e){
        System.debug('ERROR:' + e);
        PageReference errorPage = 
        new PageReference('/apex/MissingInvOrPackSlipError');
        errorPage.setRedirect(true);
        return errorPage;
       }
        }
   
    static testmethod void pdfTest() {
        /*****************************************************************************/
        /* Create dummy data for tests                                               */

        Account testAccount = new Account(Name='Test Account',Type='Customer',Oracle_Customer_Number__c='502048');
        insert testAccount;
        Order_Header__c testOrder = new Order_Header__c(Account__c=testAccount.Id,Oracle_Order_Number__c='ABCDE',Order_Entered_Date__c=System.today()-366,
        PO_Number__c='12345');
        insert testOrder;
        Order_Line__c testLine = new Order_Line__c(Invoice_Number__c ='9002402',Order__c=testOrder.Id,Scheduled_Ship_Date__c=System.today()-10);
        insert testLine;
                
        /*****************************************************************************/
        /* Run test                                                                  */
        /*****************************************************************************/
        
        PageReference imagePage = Page.InvAndPackingSlip;
        Test.setCurrentPageReference(imagePage);
        ApexPages.currentPage().getParameters().put('cust_number',testAccount.Oracle_Customer_Number__c); 
        ApexPages.currentPage().getParameters().put('inv_number', testLine.Invoice_Number__c);        
        ApexPages.currentPage().getParameters().put('doc_type','PS');       
        ApexPages.currentPage().getParameters().put('account_id',testAccount.id);  
                     
        InvAndPackingSlipImageController con = new InvAndPackingSlipImageController();
        con.getPdf();
    }     
}