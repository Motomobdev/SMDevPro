public with sharing class APTPS_Contract_Integration {   
     /*
     * Author: Swetha Mandava
     * Created Date: 12-Aug-2013
     * Description:
     * Creates an Apttus agreement for a Software Contract Request).
     * The SW Contract to Agreement relation is 1:1 (programtically enforced)
     * The SW Contract must be assocaited with an AccountName prior to conversion.
     */  
    public Contract con {get;set;}
    Public RecordType AgreementRecordType {get;set;}
    public boolean hasErrors {get; set;}
    public Contact contact {get;set;}

    public APTPS_Contract_Integration(ApexPages.StandardController controller) {
        con = (Contract)controller.getRecord();

        if (con != null) {
            // Retrieve other fields on the Contract record
            con  = [select id, account.id, Contract_Type__c,Agreement__c,Contract_Status__c,Contract_Pmt_Terms__c,
                    Legal_Owner__c,SW_Procurement_Owner__c,Product_Team_Owner__c,Motorola_Entity__c,
                    Parent_Contract__c, CompanySignedDate,CustomerSignedDate,StartDate,EndDate,ContractTerm,
                    Name,ContractNumber,Auto_Renewal__c,Renewal_Term__c,Prepay_Amount__c from Contract
                   where id = :con.Id];
        }    

    } 
    
  /*  public string lookupContactinApttus(string Id)
    {
      Contact contact = new Contact();
            contact = [SELECT Name from Contact where id = :Id];   
       if(contact != null)
       {
           List<User> user  = [SELECT Id, Name from User where Name = :contact.name];
           if (!user.isEmpty())
            {
                 User c = user[0];
                 return c.id;
            }
            else
            {
               return null;
          } 
        }
        else
        {
            return null;
        }        
    } */


// Saves the agreement record and takes the user to the agreement screen
    public PageReference myCreate() {
        PageReference returnPage = null;

        RecordType AgreementRecordType = new RecordType();
        AgreementRecordType = [SELECT Id, Name, Description FROM RecordType
          WHERE SobjectType = 'Apttus__APTS_Agreement__c' AND IsActive = true AND Name = 'Procurement and Supply Chain'];
         
        // Create Agreement record from fields mapped from Contract      

        Apttus__APTS_Agreement__c agreement = new Apttus__APTS_Agreement__c(
            RecordTypeId = AgreementRecordType.Id,
            Name = con.Name,
            Contract__c = con.id,
            Apttus__Account__c = con.account.id,         
            Apttus__Contract_End_Date__c = con.EndDate,
            Apttus__Contract_Start_Date__c = con.StartDate,
            APTPS_Agreement_Name_User_Defined__c = con.Name,            
            APTPS_subtype__c = con.Contract_Type__c,
            APT_Product_Category__c = 'Software',
            APTPS_Category__c = 'Software - Masumi Reynders',
            Apttus__Auto_Renewal__c = con.Auto_Renewal__c,
            Apttus__Auto_Renew_Term_Months__c = con.Renewal_Term__c,
            Apttus__Term_Months__c = con.ContractTerm,
           /* Secondary_Legal_Owner__c = lookupContactinApttus(con.SW_Procurement_Owner__c),
            Internal_Business_Owner__c = lookupContactinApttus(con.Product_Team_Owner__c),
            Legal_Owner__c = lookupContactinApttus(con.Legal_Owner__c), */
            Apttus__Company_Signed_Date__c = con.CompanySignedDate,
            Apttus__Other_Party_Signed_Date__c = con.CustomerSignedDate      
          );
        insert agreement;

        // Update Contract record with the agreement ID
        con.agreement__c = agreement.id;
        update con; 
        
        // Create the map that will contain ContractId => Contract.AgreementId
        Map<Id,Id> contractToAgreementMap=new Map<Id,Id>();
        
         // Populate the map with the ContractId and agreement__c related to the Contract
        for(Contract ctr:[Select Id,agreement__c from Contract where Id = :con.Id]){
            contractToAgreementMap.put(ctr.Id,Ctr.agreement__c);
        }
        
       
           List<Attachment> insertingAttachments = new List<Attachment>();   
           for(Attachment atch :  [select id,name,body from Attachment where parentid = :con.Id]){  
               
               Attachment  newattch = new Attachment();    
               newattch = atch.clone(false);  
               newattch.body = atch.body; // required field  
               newattch.name = contractToAgreementMap.get(con.Id) + atch.name;// required field    
               newattch.parentId = contractToAgreementMap.get(con.Id); 
              
            insertingAttachments.add(newattch);    
        }  
           insert   insertingAttachments; 
       
        
            

        // Open the agreement in edit mode so the user can fill in the required fields
        returnPage = new PageReference('/' + agreement.id + '/e');
        
        // return the user to the Contract page after the agreement has been saved
        returnPage.getParameters().put('retURL', '/' + con.id);

        returnPage.setRedirect(false);
        return returnPage;
    } 
    

}