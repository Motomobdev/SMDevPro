public class NDA_CreateCtr {
/*
* Created by: BigKite Consulting
* Creation date: 03-Oct-2013
* Test Class: NDA_CreateCtrTest
* Description: This class is used as a Controller for VF page NDA_create. This class will create the new NDA and will send it for Approvals and e-sign.
*
* Change history:
* Changed on: 12-Dec-2013
* Changed by: Swetha Mandava
* Description: UAT ROUND 2 changes 
* Changed on: 10-Feb-2014
* Changed by: Swetha Mandava
* Description: Release 1.1 enhancements
*/

    public NDA__c objNDA {get; set;}
    public NDA_Company__c objNDACompany {get; set;}
    public NDA_CompanyContact__c objNDACompanyContact {get; set;}
    public NDA_Company__c objNDAMultiCompany {get; set;}
    public NDA_CompanyContact__c objNDAMultiCompanyContact {get; set;}
    
    public String strSelectedEntity {get; set;}
    public String strSelectedVpName {get; set;}
    public String strSelectedGovLaw {get; set;}
    
    public Boolean boolShowMultiCompany {get; set;} 
    public Boolean boolShowRegionDepend {get; set;}
    
    public String strIsProdTemp {get; set;}       
    public String strCompanyID {get; set;}
    public String strMultiCompanyID {get; set;}    
    public String strIsMultiParty {get; set;}

    public Boolean boolIsProduct {get; set;}
    public Boolean boolIsSubmitted {get; set;}
    public Boolean boolIsSummary {get; set;}
    public Boolean boolIsInserted {get; set;}
    public Boolean boolIsSpecialAccess {get; set;}
    
    public list<NDA_Notifier__c> lstNotifiersAttached {get; set;}
    public list<NDA_Signatory__c> lstNDASignatories {get; set;}
       
    public NDA_CreateCtr(ApexPages.StandardController stdController){
        boolIsSummary = false;
        boolIsSubmitted = false;
        boolShowRegionDepend = true;
        boolIsInserted = false;
        boolIsSpecialAccess = false;      
       
        
        Id profileId=userinfo.getProfileId();
        Id roleId=userinfo.getUserRoleId();
        
        String strProfileName=[Select Id,Name from Profile where Id=:profileId].Name;
        String strRoleName=[Select Id,Name from UserRole where Id=:roleId].Name;   
        
        if(strProfileName == 'System Administrator' || strProfileName == 'MotoDev - SysAdmin' || strRoleName == 'NDA' || strRoleName == 'Apttus Admin' || strRoleName == 'MD - Legal' ){
          boolIsSpecialAccess = true;
        }        
        
        objNDA = (NDA__c) stdController.getRecord();
        String strID = objNDA.Id;
        if(strID != null && strID != ''){
            String strWherClause;
            strWherClause=' ,company__r.name, Multiparty_Company__r.name, vp_Name__r.vp_Name__c from NDA__c WHERE ID = \'' + objNDA.id +'\'' ;
            objNDA = Database.query(NDA_HelperDatabase.fnAllColumnsByCustomQuery('NDA__c', strWherClause));
            if(objNDA != null){
                boolIsSummary = true;
                boolIsSubmitted = true;
                boolShowRegionDepend = true;
            }
        }               
    }    
    
    public Pagereference fnAction(){
        if(!boolIsSummary){            
            strIsProdTemp = ApexPages.currentPage().getParameters().get('pv03');        
            strCompanyID = ApexPages.currentPage().getParameters().get('pv06');
            strIsMultiParty = ApexPages.currentPage().getParameters().get('pv07');
            strMultiCompanyID = ApexPages.currentPage().getParameters().get('pv08'); 
            boolShowMultiCompany = false;
                        
            if(strIsProdTemp != null && strIsProdTemp != ''){
                boolIsProduct = Boolean.valueOf(strIsProdTemp);
            }else{
                boolIsProduct = false;
            }  
            
            if(strIsMultiParty != null && strIsMultiParty != ''){
                 boolShowMultiCompany = Boolean.valueOf(strIsMultiParty);
            } 
            else
            {
                boolShowMultiCompany = false;
            }  
                       
            
            boolShowRegionDepend = true;
            boolIsSubmitted = false;
            objNDA = new NDA__c();
            
            if(strCompanyID != null && strCompanyID != ''){  
                objNDACompany = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA_Company__c', strCompanyID));
                this.objNDA.Company__c = objNDACompany.Id;
            }          
            
            objNDA.Is_this_Multiparty__c = boolShowMultiCompany;            
            if(strMultiCompanyID != null && strMultiCompanyID != ''){                 
                objNDAMultiCompany = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA_Company__c', strMultiCompanyID));
                this.objNDA.Multiparty_Company__c = objNDAMultiCompany.Id;              
            }            
            
            objNDA.IsProductNDA__c = boolIsProduct;
            objNDA.RecordTypeId = fnRecordType();
            objNDACompanyContact = new NDA_CompanyContact__c();
            objNDAMultiCompanyContact = new NDA_CompanyContact__c();        
        }else{
            boolIsProduct = objNDA.IsProductNDA__c;
            objNDACompany = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA_Company__c', objNDA.Company__c));           
            objNDACompanyContact = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA_CompanyContact__c', objNDA.Company_Contact__c));
            
            boolShowMultiCompany = objNDA.Is_this_Multiparty__c;
            if(objNDA.Is_this_Multiparty__c){
              //  boolShowMultiCompany = objNDA.Is_this_Multiparty__c;
                objNDAMultiCompany = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA_Company__c', objNDA.Multiparty_Company__c));
                objNDAMultiCompanyContact = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA_CompanyContact__c', objNDA.NDA_Multiparty_Company_Contact__c));               
            }
            strSelectedVpName = objNDA.VP_Name__c;
            strSelectedEntity = objNDA.Motorola_Entity__c;
            strSelectedGovLaw  = objNDA.Governing_Law__c;
            
           // if(objNDA.NDAStatus__c == 'Save'){
               // boolIsSubmitted = false;
              if(objNDA.NDAStatus__c == 'Pending'){
                boolIsSubmitted = true;
                boolIsInserted = true;
                fnShowVpPanel();
                lstNotifiersAttached = NDA_HelperDatabase.fnShowIndividualList(objNDA.id);    
            }else{
                lstNotifiersAttached = NDA_HelperDatabase.fnShowIndividualList(objNDA.id);    
            }       
            
        }
        return null;
    }
    
    /*
        Method used to get NDA record type ID
    */
    public String fnRecordType(){
        RecordType recType = [select id,name from RecordType where Name = 'NDA' AND sobjectType = 'NDA__c' limit 1];
        return recType.Id;
    }   

    //builds a picklist of Motorola Entities names
   // public List<selectOption> getMotorolaEntity() {     
   //     return NDA_HelperDatabase.fnPicklistValues('NDA__c', 'Motorola_Entity__c'); //return the picklist options
   // }
    
    //builds a picklist of VP names
    public List<selectOption> getVpNames() {
        //new list for holding all of the picklist options
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('', '- None -')); 
        if(lstNDASignatories != null){
            for (NDA_Signatory__c lstvpNames : lstNDASignatories) { 
                //for all records found - add them to the picklist options
                options.add(new selectOption(lstvpNames.Id, lstvpNames.VP_Name__c));
            }
        }
        return options; //return the picklist options
    }   
    
    public PageReference fnShowVpPanel() {  
            lstNDASignatories = new list<NDA_Signatory__c>();
        for (NDA_Signatory__c lstvpNames : [SELECT Id, Name,VP_Name__c FROM NDA_Signatory__c where Active__c=true and Region_Name__c =:objNDA.NDARegion__c order by VP_Name__c ASC]) { 
            lstNDASignatories.add(lstvpNames);
        }       
        return null;
    }   
    
    /*
    * This method will create an NDA record in the Database with User's inputs from the VF page.
    */
    public PageReference fnSaveAsDraft() {
        if(boolShowMultiCompany && objNDA.Multiparty_Company__c == null){       
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please provide the Multi party information.');
                ApexPages.addMessage(myMsg);
                return null;
        } 

         try {
                       // Populate and insert the NDA company Contact
                        objNDACompanyContact.NDACompany__c = objNDACompany.id;
                        //objNDACompanyContact.Full_Name__c = objNDACompany.name;
                        insert objNDACompanyContact;
                
                        objNDA.Company_Contact__c = objNDACompanyContact.id;                        
                       
                        if(boolShowMultiCompany){
                            objNDA.Is_this_Multiparty__c = boolShowMultiCompany;
                            //insert objNDAMultiCompany;
                            if(objNDA.Multiparty_Company__c != null && objNDAMultiCompanyContact != null){
                                fnInsertMultiPartyContact();
                            }
                        }                         
                        
                      // Swetha: Working on Submit instead of Save as Draft 

                        objNDA.NDAStatus__c = 'Pending';  
                        objNDA.Connected_Party_Approval_Status__c = 'Pending';
                        
                         
                        if(objNDA.IsProductNDA__c){
                            if(objNDA.Software__c == false && objNDA.Premium_Products__c == false && objNDA.Value_Products__c == false && objNDA.Companion_Products__c == false) {                                
                              ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please make Category selection to Submit this product NDA'); 
                              ApexPages.addMessage(myMsg);
                              return null;                                    
                            } else {   
                            objNDA.DPLStatus__c = 'Pending';
                            }
                          }
                          else {                        
                             objNDA.DPLStatus__c = 'N/A';
                         }
                        objNDA.vp_Name__c = strSelectedVpName;
                        fnAssignNDASpecialist(); // DDP and contact id is used for this
                        // Insert NDA
                        insert objNDA; 
                        boolIsInserted = true;
                        
                        if(objNDA.Id != null){
                            NDA__c obj = [select id, ndafileid__c from NDA__c where id =: objNDA.id];
                            objNDA.NDAFileID__c = obj.NDAFileID__c;
                        }
                           
                    boolIsSubmitted = true;           
                  
                    lstNotifiersAttached = NDA_HelperDatabase.fnShowIndividualList(objNDA.id);   
                       
                    if(objNDA.IsProductNDA__c){
                        // create the new approval request to submit
                        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                        req.setComments('Submitted for approval. Please approve.');
                        req.setObjectId(objNDA.id);
                        // submit the approval request for processing
                        Approval.ProcessResult result = Approval.process(req);
                        // display if the reqeust was successful
                    }           
                    
                    Contact objContact;
                    try{
                        objContact = [select id, name, email from contact where email =: objNDA.NDA_Specialist__c limit 1];
                    // Hardcoding for swetha's id
                    }catch(Exception e){}
                    
                    Pagereference pageRef = null;
                    pageRef = fnAttachNdaDDP();
                   
                   /* if(objNDA.Modification_Text__c != null){
                        // Send the Mod with doc to NDA Specialist and ignore if user is NDA Specialist
                        if(!boolIsSpecialAccess) {
                            pageRef = fnNotifySpecialistDDP(objContact.id,'create');
                        } 
                    }else{       
                        // No modification attach the standard NDA with NDA record.
                        pageRef = fnAttachNdaDDP();
                    } */
  
                    return pageRef;
                }catch(Exception e){
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Contact system admin with this message: '+ e.getMessage()); 
                        ApexPages.addMessage(myMsg);
                        return null;
             }                    
    }
    /*
     * This method will will create the Multiparty company contact.
     */
     public void fnInsertMultiPartyContact(){
        objNDAMultiCompany = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA_Company__c', objNDA.Multiparty_Company__c));
        objNDAMultiCompanyContact.NDACompany__c = objNDA.Multiparty_Company__c;
        //objNDAMultiCompanyContact.Full_Name__c = objNDAMultiCompany.name;
        insert objNDAMultiCompanyContact;
        objNDA.NDA_Multiparty_Company_Contact__c = objNDAMultiCompanyContact.id;
     }     
     /*
     * This method will assign the NDA Specialist according to the region selected by User. 
     */
     public void fnAssignNDASpecialist(){
        if(objNDA.NDARegion__c == 'Asia Pac - Chinese' || objNDA.NDARegion__c == 'Asia Pac - English'){
            objNDA.NDA_Specialist__c = 'nda@motorola.com';
        }else if(objNDA.NDARegion__c == 'North America - English'){
            objNDA.NDA_Specialist__c = 'nda@motorola.com'; 
        }else if(objNDA.NDARegion__c == 'Latin America - English & Portuguese' || objNDA.NDARegion__c == 'Latin America - English & Spanish' || objNDA.NDARegion__c == 'EMEA - English'){
            objNDA.NDA_Specialist__c = 'nda@motorola.com'; 
        }
    }
    
    /*
    * This method will Update an NDA record in the Database with User's inputs from the VF page.
    */
    public PageReference fnUpdateNDA(){     
        if(boolShowMultiCompany && objNDA.Multiparty_Company__c == null){                       
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please provide the Multi party information.');
                ApexPages.addMessage(myMsg);
                return null;
        }       
        try{
            // update Company's contact
            update objNDACompanyContact;
            objNDA.Company_Contact__c = objNDACompanyContact.id; 

            objNDA.Is_this_Multiparty__c = boolShowMultiCompany;
            if(boolShowMultiCompany){
                //update/insert objNDAMultiCompany;
                if(objNDA.Multiparty_Company__c != null){
                    if(objNDAMultiCompany == null){
                        fnInsertMultiPartyContact();
                    }else{
                        update objNDAMultiCompanyContact;
                    }
                }
            } 
            
            if(objNDA.Software__c == false) {
                objNDA.Software_MCR__c = false;
                objNDA.Software_Prototype__c = false;
            } 
            if(objNDA.Premium_Products__c == false) {
                objNDA.Premium_MCR__c = false;
                objNDA.Premium_Prototype__c = false;
            } 
            if(objNDA.Value_Products__c == false) {
                objNDA.Value_MCR__c = false;
                objNDA.Value_Prototype__c = false;
            } 
            if(objNDA.Companion_Products__c == false) {
                objNDA.Companion_MCR__c = false;
                objNDA.Companion_Prototype__c = false;
            }                      
                
            objNDA.vp_Name__c = strSelectedVpName;
            fnAssignNDASpecialist();  // DDP is used and contact is used for this
            update objNDA;            
                         
            if(objNDA.IsProductNDA__c){
                 if(objNDA.Software__c == false && objNDA.Premium_Products__c == false && objNDA.Value_Products__c == false && objNDA.Companion_Products__c == false) {                                
                     ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Please make Category selection to Submit this product NDA'); 
                     ApexPages.addMessage(myMsg);
                     return null;                                    
                 }                  
              /*   else { 
                       try{
                          // create the new approval request to submit
                            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                            req.setComments('Submitted for approval. Please approve.');
                            req.setObjectId(objNDA.id);
                            // submit the approval request for processing
                            Approval.ProcessResult result = Approval.process(req);
                            // display if the reqeust was successful
                         }catch(Exception e){
                             ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'If you have pending Approval request, Click Recall before it submitted '); 
                             ApexPages.addMessage(myMsg);
                         }
                 }*/
            } 
             
           Contact objContact;
            try{
                objContact = [select id, name, email from contact where email =:objNDA.NDA_Specialist__c limit 1];
            }catch(Exception e){} 
            
            Pagereference pageRef = null;
         //   pageRef = fnAttachNdaDDP();
            
            String strRoleName=[Select Id,Name from UserRole where Id=:userinfo.getUserRoleId()].Name;            
           // if(objNDA.Modification_Text__c != null && strRoleName != 'NDA Specialist'){
           if(objNDA.Modification_Text__c != null && objNDA.Modification_Text__c != ''){
                // Send the Mod with doc to NDA Specialist
               pageRef = fnNotifySpecialistDDP(objContact.id,'update');                     
            }else if (objNDA.Modification_Text__c == null || objNDA.Modification_Text__c != ''){            
                // No modification attach the standard NDA with NDA record.
                pageRef = fnAttachNdaDDP();
            } 
            return pageRef;
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Contact system admin with this message: '+ e.getMessage()); 
            ApexPages.addMessage(myMsg);
            return null;
        }   
    }  
    
    /*
    * This is a method for submitting the NDA after it has been submitted. 
    */
    public PageReference fnSubmitAfterMod() {       
        String strRoleName=[Select Id,Name from UserRole where Id=:userinfo.getUserRoleId()].Name; 
        if((objNDA.Modification_Text__c == '' || objNDA.Modification_Text__c == null) && strRoleName != 'NDA Specialist'){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: There is no Modification Text provided for submission.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        try{            
            // Only for Modification field
            update objNDA; 
                   
            boolIsSubmitted = true;                 
            
            lstNotifiersAttached = NDA_HelperDatabase.fnShowIndividualList(objNDA.id);      
                    
            // Call the DDP to attach the NDA attachment with record.
            
            Contact objContact;            
            try{
             objContact = [select id, name, email from contact where email =: objNDA.NDA_Specialist__c limit 1];
             // Hardcoding for swetha's id
            }catch(Exception e){} 
            
            Pagereference pageRef = null;
            if(objContact != null && strRoleName != 'NDA Specialist'){
                pageRef = fnNotifySpecialistDDP(objContact.id,'modification');
                return pageRef;
            }                              
            return null;
            
        }catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Contact system admin with this message: '+ e.getMessage()); 
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    /*
    * This is a method for sending the NDA for Amendment. 
    */
    public PageReference fnNDAAmendment() {     
        Pagereference pageRef = null;
            if(objNDA.NDAStatus__c == 'Executed' || objNDA.NDAStatus__c == 'Executed-Mod'){
                 
                lstNotifiersAttached = NDA_HelperDatabase.fnShowIndividualList(objNDA.id);                            
                
                Contact objContact = [select id, name, email from contact where email =: objNDA.NDA_Specialist__c limit 1];
                pageRef = fnNotifySpecialistAmendmentDDP(objContact.id);
                return pageRef;           
            }           
        return pageRef;
    }
    
      /*
    * This is a method for sending the NDA for Disclosure approval to reuse existing executed Product NDAs. 
    */
    public PageReference fnNDADisclosure() {     
        Pagereference pageRef = Page.NDA_Disclosure_Request;
        pageRef.getParameters().put('pv02',objNDA.Id);    
        pageRef.setRedirect(true);  
        return pageRef;
    }  
   
    /*
    * This method will be called for sending the doc for e-sign using Loops and echosign
    */
    public Pagereference fnCallEchosignDDP(){
        NDA_Signatory__c objSign;
        for(NDA_Signatory__c objVpNames : [SELECT Id, Name,VP_Name__c, email__c FROM NDA_Signatory__c where id =: objNDA.VP_Name__c limit 1]){
            objSign = objVpNames;
        }
        
        if(objSign == null){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: No VP assigned. Cannot send for Sign.');
            ApexPages.addMessage(myMsg);
            return null;
        }       
        
        Pagereference pageRefToLoopPlus = Page.loop__looplus;
        String strID = objNDA.Id;  
        String targetString = '/apex/nda_summary?pv03=signatures&pv02='+strID;         
        targetString = EncodingUtil.URLENCODE(targetString,'UTF-8');   
          
        pageRefToLoopPlus.getParameters().put('eid',strID);
        pageRefToLoopPlus.getParameters().put('sessionId',Userinfo.getSessionId());
        pageRefToLoopPlus.getParameters().put('autorun','true');
        pageRefToLoopPlus.getParameters().put('retURL',targetString);

        
        if(objNDA.Is_this_Multiparty__c){           
            // Parameter for Company 2
            String strcompMulti = objNDAMultiCompany.name+','+objNDAMultiCompanyContact.Email__c;
            pageRefToLoopPlus.getParameters().put('multicompany',strcompMulti);         
            // Parameter for Vp Name
            String strVPame = objSign.VP_Name__c+','+objSign.Email__c; 
            pageRefToLoopPlus.getParameters().put('VpName',strVPame);       
            // Parameter for Company 1
            String strAnyParam = objNDACompany.name +','+objNDACompanyContact.Email__c;
            pageRefToLoopPlus.getParameters().put('company',strAnyParam);       
        }else{
            // Parameter for Vp Name
            String strVPame = objSign.VP_Name__c+','+objSign.Email__c; 
            pageRefToLoopPlus.getParameters().put('VpName',strVPame);       
            // Parameter for Company 1
            String strAnyParam = objNDACompany.name +','+objNDACompanyContact.Email__c;
            pageRefToLoopPlus.getParameters().put('company',strAnyParam);
        }
        if(objNDA.AmendmentSigned__c == 'false' && objNDA.AmendmentSent__c == true){
            // Check for Multi party
            if(objNDA.Is_this_Multiparty__c){  
                // Call DDP : NDA Multi Party Amendment  : Echosign 
                // Call Custom settings
                NDA_DDPs__c objDDP = NDA_DDPs__c.getInstance('AmendEchoSignMulti');
                if(objDDP != null){ 
                    pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                    pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c);
                }   
            }else{
                // Call DDP : NDA Amendment : Echosign  
                // Call Custom settings
                NDA_DDPs__c objDDP = NDA_DDPs__c.getInstance('AmendEchoSign');
                if(objDDP != null){
                    pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                    pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c); 
                }
            }
        }else{
            if(objNDA.Modification_Text__c != null && objNDA.Modification_Text__c !=''){
                
                NDA_DDPs__c objDDP;
                // Call the Mod Echosgin DDP : assuming user has uploaded the Mod doc verified by the NDA specialist in Attachments.
                // Check for Multi party
                if(objNDA.Is_this_Multiparty__c){   
                    // DDP Name : NDA Mod MultiParty
                    // Call Custom settings
                    
                    if(objNDA.NDARegion__c == 'Asia Pac - Chinese'){
                       objDDP = NDA_DDPs__c.getInstance('NDAModEchoSignMultiAPAC');
                    }else if(objNDA.NDARegion__c == 'North America - English'  || objNDA.NDARegion__c == 'Asia Pac - English' || objNDA.NDARegion__c == 'EMEA - English'){
                       objDDP = NDA_DDPs__c.getInstance('NDAModEchoSignMulti');
                    }else if(objNDA.NDARegion__c == 'Latin America - English & Spanish'){
                        objDDP = NDA_DDPs__c.getInstance('NDAModEchoSignMultiSpanish'); 
                    } else if(objNDA.NDARegion__c == 'Latin America - English & Portuguese') {
                         objDDP = NDA_DDPs__c.getInstance('NDAModEchoSignMultiPortuguese');
                    }           
                   
                    if(objDDP != null){
                        pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                    }
                }else{
                    // DDP Name : NDA Mod Mutual
                    // Call Custom settings
                    
                    if(objNDA.NDARegion__c == 'Asia Pac - Chinese'){
                       objDDP = NDA_DDPs__c.getInstance('NDAModEchoSignAPAC');
                    }else if(objNDA.NDARegion__c == 'North America - English'  || objNDA.NDARegion__c == 'Asia Pac - English' || objNDA.NDARegion__c == 'EMEA - English'){
                       objDDP = NDA_DDPs__c.getInstance('NDAModEchoSign');
                    }else if(objNDA.NDARegion__c == 'Latin America - English & Spanish'){
                        objDDP = NDA_DDPs__c.getInstance('NDAModEchoSignSpanish'); 
                    } else if(objNDA.NDARegion__c == 'Latin America - English & Portuguese') {
                         objDDP = NDA_DDPs__c.getInstance('NDAModEchoSignPortuguese');
                    }     

                    if(objDDP != null){
                        pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                    }
                }
            }else{
                NDA_DDPs__c objDDP;
                // Check for Multi party
                if(objNDA.Is_this_Multiparty__c){           
                    // DDP Name : NDA MultiParty ; EchoSign Multi-Party
                    // Call Custom settigs
                                       
                    if(objNDA.NDARegion__c == 'Asia Pac - Chinese'){
                       objDDP = NDA_DDPs__c.getInstance('NDAEchoSignMultiAPAC');
                    }else if(objNDA.NDARegion__c == 'North America - English'  || objNDA.NDARegion__c == 'Asia Pac - English' || objNDA.NDARegion__c == 'EMEA - English'){
                       objDDP = NDA_DDPs__c.getInstance('NDAEchoSignMulti');
                    }else if(objNDA.NDARegion__c == 'Latin America - English & Spanish'){
                        objDDP = NDA_DDPs__c.getInstance('NDAEchoSignMultiSpanish'); 
                    } else if(objNDA.NDARegion__c == 'Latin America - English & Portuguese') {
                         objDDP = NDA_DDPs__c.getInstance('NDAEchoSignMultiPortuguese');
                    }                    
                    
                    if(objDDP != null){
                        pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                        pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c);
                    }
                }else{
                    // DDP Name : NDA ; EchoSign
                    // Call Custom settings
                    
                    if(objNDA.NDARegion__c == 'Asia Pac - Chinese'){
                       objDDP = NDA_DDPs__c.getInstance('NDAEchoSignAPAC');
                    }else if(objNDA.NDARegion__c == 'North America - English'  || objNDA.NDARegion__c == 'Asia Pac - English' || objNDA.NDARegion__c == 'EMEA - English'){
                       objDDP = NDA_DDPs__c.getInstance('NDAEchoSign');
                    }else if(objNDA.NDARegion__c == 'Latin America - English & Spanish'){
                        objDDP = NDA_DDPs__c.getInstance('NDAEchoSignSpanish'); 
                    } else if(objNDA.NDARegion__c == 'Latin America - English & Portuguese') {
                         objDDP = NDA_DDPs__c.getInstance('NDAEchoSignPortuguese');
                    }
                    
                    if(objDDP != null){
                        pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                        pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c);
                    }
                }           
            }
        }
        pageRefToLoopPlus.setRedirect(true);                
        return pageRefToLoopPlus;
    }   
    /*
    * This method will be called for attaching the NDA file with the record using Loops
    DDP Name : NDA Multiparty ; Attach to NDA
               NDA ; Attach to NDA
    */
    public Pagereference fnAttachNdaDDP(){
        
     //   String summaryText = summary;
     //   String targetString = '/apex/nda_summary?pv03='+summaryText+'&pv02='+objNDA.Id;         
    //    targetString = EncodingUtil.URLENCODE(targetString,'UTF-8');
        
        Pagereference pageRefToLoopPlus = Page.loop__looplus;
        pageRefToLoopPlus.getParameters().put('eid',objNDA.Id);     
        pageRefToLoopPlus.getParameters().put('sessionId',Userinfo.getSessionId());
        pageRefToLoopPlus.getParameters().put('autorun','true');
      //  pageRefToLoopPlus.getParameters().put('retURL',targetString);
        
         NDA_DDPs__c objDDP;
        // Check for Multi party
        if(objNDA.Is_this_Multiparty__c){
            // DDP Name : NDA Multiparty ; Attach to NDA
            // Call Custom settings
            
            if(objNDA.NDARegion__c == 'Asia Pac - Chinese'){
               objDDP = NDA_DDPs__c.getInstance('NDAAttachToNDAMultiAPAC');
            }else if(objNDA.NDARegion__c == 'North America - English'  || objNDA.NDARegion__c == 'Asia Pac - English' || objNDA.NDARegion__c == 'EMEA - English'){
               objDDP = NDA_DDPs__c.getInstance('NDAAttachToNDAMulti');
            }else if(objNDA.NDARegion__c == 'Latin America - English & Spanish'){
                objDDP = NDA_DDPs__c.getInstance('NDAAttachToNDAMultiSpanish'); 
            } else if(objNDA.NDARegion__c == 'Latin America - English & Portuguese') {
                objDDP = NDA_DDPs__c.getInstance('NDAAttachToNDAMultiPortuguese');
            }            
            
            if(objDDP != null){
                pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c);
            }
        }else{
            //DDP Name : NDA ; Attach to NDA
            // Call Custom settings
            
            if(objNDA.NDARegion__c == 'Asia Pac - Chinese'){
               objDDP = NDA_DDPs__c.getInstance('NDAAttachToNDAAPAC');
            }else if(objNDA.NDARegion__c == 'North America - English'  || objNDA.NDARegion__c == 'Asia Pac - English' || objNDA.NDARegion__c == 'EMEA - English'){
               objDDP = NDA_DDPs__c.getInstance('NDAAttachToNDA');
            }else if(objNDA.NDARegion__c == 'Latin America - English & Spanish'){
                objDDP = NDA_DDPs__c.getInstance('NDAAttachToNDASpanish'); 
            } else if(objNDA.NDARegion__c == 'Latin America - English & Portuguese') {
                objDDP = NDA_DDPs__c.getInstance('NDAAttachToNDAPortuguese');
            }   
        }        
            
            if(objDDP != null){
                pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c);
            }
    
        pageRefToLoopPlus.setRedirect(true);        
        return pageRefToLoopPlus;
    }
    /*
    * This method will be called for sending the email to notify the NDA with NDA mod-doc using Loops
    DDP Name : NDA ; Attach NDA for Specialist
    */
    public Pagereference fnNotifySpecialistDDP(ID contID, string summary){
        String summaryText = summary;
        String targetString = '/apex/nda_summary?pv03='+summaryText+'&pv02='+objNDA.Id;  
        targetString = EncodingUtil.URLENCODE(targetString,'UTF-8');
        
       // Contact objContact = [select id, name, email from contact where email =:objNDA.NDA_Specialist__c limit 1];
        
        Pagereference pageRefToLoopPlus = Page.loop__looplus;
        pageRefToLoopPlus.getParameters().put('eid',objNDA.Id);     
        pageRefToLoopPlus.getParameters().put('sessionId',Userinfo.getSessionId());
        pageRefToLoopPlus.getParameters().put('autorun','true');        
        pageRefToLoopPlus.getParameters().put('contactId',contID);  
        //pageRefToLoopPlus.getParameters().put('contactId',objContact.id);   
        pageRefToLoopPlus.getParameters().put('retURL',targetString); 
        
        // DDP Name : NDA ; Attach NDA for Specialist   
        // Call Custom settings
        
        NDA_DDPs__c objDDP;
         // Check for Multi party
        if(!objNDA.Is_this_Multiparty__c){
            // DDP Name : NDA Multiparty ; Attach NDA for Specialist 
            // Call Custom settings
            
            if(objNDA.NDARegion__c == 'Asia Pac - Chinese'){
                objDDP = NDA_DDPs__c.getInstance('NDAAttachNDASpecialistAPAC');
            }else if(objNDA.NDARegion__c == 'North America - English'  || objNDA.NDARegion__c == 'Asia Pac - English' || objNDA.NDARegion__c == 'EMEA - English'){
               objDDP = NDA_DDPs__c.getInstance('NDAAttachNDASpecialist');
            }else if(objNDA.NDARegion__c == 'Latin America - English & Spanish'){
                 objDDP = NDA_DDPs__c.getInstance('NDAAttachNDASpecialistSpanish'); 
            } else if(objNDA.NDARegion__c == 'Latin America - English & Portuguese') {
                  objDDP = NDA_DDPs__c.getInstance('NDAAttachNDASpecialistPortuguese');
            }            
            
            if(objDDP != null){
                pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c);
            }
        }else{
            //DDP Name : NDA ; Attach NDA for Specialist 
            // Call Custom settings
            
            if(objNDA.NDARegion__c == 'Asia Pac - Chinese'){
               objDDP = NDA_DDPs__c.getInstance('NDAAttachNDASpecialistMultiAPAC');
            }else if(objNDA.NDARegion__c == 'North America - English'  || objNDA.NDARegion__c == 'Asia Pac - English' || objNDA.NDARegion__c == 'EMEA - English'){
               objDDP = NDA_DDPs__c.getInstance('NDAAttachNDASpecialistMulti');
            }else if(objNDA.NDARegion__c == 'Latin America - English & Spanish'){
                objDDP = NDA_DDPs__c.getInstance('NDAAttachNDASpecialistMultiSpanish');
            } else if(objNDA.NDARegion__c == 'Latin America - English & Portuguese') {
                 objDDP = NDA_DDPs__c.getInstance('NDAAttachNDASpecialistMultiPortuguese');
            }           
        }        
        
        if(objDDP != null){
            pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
            pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c);
        }       
        pageRefToLoopPlus.setRedirect(true);        
        return pageRefToLoopPlus;
    }  
     
     
    /*
    * This method will be called for sending the email to notify the NDA with NDA amendment doc using Loops
    DDP Name :  NDA MultiParty Amendment ; Attach NDA for Specialist
                NDA Amendment ; Attach NDA for Specialist
    */  
    public Pagereference fnNotifySpecialistAmendmentDDP(ID contID){
        objNDA.AmendmentSent__c = true;
        objNDA.AmendmentSigned__c = 'false';
        update objNDA;
        
        //Contact objContact = [select id, name, email from contact where email =:objNDA.NDA_Specialist__c limit 1];
        
        String targetString = '/apex/nda_summary?pv03=amendment&pv02='+objNDA.Id;         
        targetString = EncodingUtil.URLENCODE(targetString,'UTF-8');
        
        Pagereference pageRefToLoopPlus = Page.loop__looplus;
        pageRefToLoopPlus.getParameters().put('eid',objNDA.Id);     
        pageRefToLoopPlus.getParameters().put('sessionId',Userinfo.getSessionId());
        pageRefToLoopPlus.getParameters().put('autorun','true');        
        pageRefToLoopPlus.getParameters().put('contactId',contID);  
        //pageRefToLoopPlus.getParameters().put('contactId',objContact.id); 
        pageRefToLoopPlus.getParameters().put('retURL',targetString);
        
        if(objNDA.Is_this_Multiparty__c){
            // Call Custom settings
            NDA_DDPs__c objDDP = NDA_DDPs__c.getInstance('AmendAttachNDASpecialistMulti');
            if(objDDP != null){
                //DDP Name: NDA MultiParty Amendment ; Attach NDA for Specialist
                pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c);
            } 
        }else{
            // DDP Name: NDA Amendment ; Attach NDA for Specialist
            NDA_DDPs__c objDDP = NDA_DDPs__c.getInstance('AmendAttachNDASpecialist');
            if(objDDP != null){
                pageRefToLoopPlus.getParameters().put('ddpIds',objDDP.ddpIds__c);
                pageRefToLoopPlus.getParameters().put('deploy',objDDP.deploy__c);
            } 
        }   
            
        pageRefToLoopPlus.setRedirect(true);        
        return pageRefToLoopPlus;
    } 
  
    public PageReference fnShowMultiCompany() {     
        return null;
    }  
    
    public PageReference fnShowPremium() {     
        return null;
    }   
    
    public PageReference fnShowValue() {     
        return null;
    } 
     
    public PageReference fnShowCompanion() {     
        return null;
    } 
     
    public PageReference fnShowSoftware() {     
        return null;
    }  

}