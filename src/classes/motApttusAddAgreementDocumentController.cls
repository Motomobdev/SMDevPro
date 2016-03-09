public with sharing class motApttusAddAgreementDocumentController 
{
    public Apttus__APTS_Agreement__c agreement {get; set;}
    public Boolean noResult {get; set;}
    public Attachment[] availableAttachments {get; set;}
    public String agreementId {get; set;}
    public String selectedId {get; set;}

    public motApttusAddAgreementDocumentController(ApexPages.StandardController stdController) 
    {
        try
        {
            // Show message if Id parameter is not passed
            if(ApexPages.currentPage().getParameters().get('Id') == null) 
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'One or more required parameter is missing.');
                ApexPages.addMessage(myMsg);
                return;
            }
            
            // get current Agreement record
            agreement = (Apttus__APTS_Agreement__c) stdController.getRecord();
            agreementId = agreement.Id;
            
            availableAttachments = [SELECT Id, 
                                           Name, 
                                           LastModifiedDate, 
                                           CreatedBy.Name 
                                    FROM Attachment 
                                    WHERE ParentId = :agreementId];
                                    
            noResult = availableAttachments.isEmpty();
        }
        catch (Exception ex)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }

    public PageReference onSelectAttachment() 
    {
        //Create a savepoint 
        Savepoint sp = Database.setSavepoint();
            
        try
        {
            if(selectedId == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No value in attachmentId!'));
                return null;
            }

            Attachment att = [SELECT Name, 
                                     Body, 
                                     ContentType, 
                                     Description, 
                                     OwnerId  
                              FROM Attachment 
                              WHERE Id = :selectedId];
                              
            Folder fld = [SELECT Id 
                          FROM Folder 
                          WHERE Name = 'Apttus Documents'];
                          
            Blob hash = Crypto.generateDigest('SHA1',Blob.valueOf(att.Name + Crypto.getRandomInteger()));
            String hexDigest = 'DOC' + EncodingUtil.convertToHex(hash);
      
            Document doc = new Document(Name=att.Name, 
                                        AuthorId=att.OwnerId, 
                                        Body=att.Body, 
                                        ContentType=att.ContentType, 
                                        Keywords=att.Name.substring(0, att.Name.lastIndexOf('.')),
                                        Description='Created from Attachment (' + att.Name + ')', 
                                        FolderId=fld.Id, 
                                        Type=att.Name.substring(att.Name.lastIndexOf('.')+1),
                                        IsPublic=true,
                                        DeveloperName=hexDigest);
            
            insert doc;
            delete att;
            
            String url = '/servlet/servlet.FileDownload/'+ doc.Name + '?file=' + doc.Id;
            
            Apttus__Agreement_Document__c aggrDoc = new Apttus__Agreement_Document__c(Name=(doc.Name.length()>80 ? doc.Name.left(77) + '...' : doc.Name), 
                                                                                      Apttus__Agreement__c=agreementId, 
                                                                                      Apttus__Path__c=doc.Name, 
                                                                                      Apttus__Type__c='Final Electronic Copy', 
                                                                                      Apttus__URL__c=url);
            insert aggrDoc;
            
            // close popup window
            return new PageReference('javascript:window.top.close();');
        }
        catch (Exception ex)
        {
            //Rollback
            Database.rollback(sp);

            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        
        return null;
    }
  
  static testmethod void testController()
  {
    Test.startTest();

    Apttus__APTS_Agreement__c agreemt = new Apttus__APTS_Agreement__c(Name='Test Agreement', Target_Close_Month__c=date.today().addMonths(6));
    insert agreemt;
    
    Attachment att = new Attachment(Name='Test Attachment.doc', body=Blob.valueOf('Test Data'), ParentId=agreemt.Id);
    insert att;

    Test.stopTest();
    
    //without parameter (throws error)
    PageReference pageRef = Page.motApttusAddAgreementDocument;
    Test.setCurrentPage(pageRef);

    motApttusAddAgreementDocumentController ctrl = new motApttusAddAgreementDocumentController(new ApexPages.StandardController(agreemt));

    //with parameter
    pageRef = Page.motApttusAddAgreementDocument;
    pageRef.getParameters().put('Id', agreemt.Id);
    Test.setCurrentPage(pageRef);
    
    ctrl = new motApttusAddAgreementDocumentController(new ApexPages.StandardController(agreemt));
    
    //without selecting attachment (throws error)
    ctrl.onSelectAttachment();

    //select attachment
    ctrl.selectedId = att.Id;
    ctrl.onSelectAttachment();
  }
}