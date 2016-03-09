public class APTPS_CA_CreateContract {

    // Local account fields
    public String billingAddress {get; set;}
    public Account channelPartner {get; set;}

    // Wrapper for selecting attachments to send for Echosign
    public List<attachmentWrapper> attachmentList {get; set;}
    List<Attachment> selectedAttachments = new List<Attachment>();     
    public List<attachmentWrapper> getApttusAttachments() {
        attachmentList = new List<attachmentWrapper>();
        for (Attachment a : [select Id, Name, CreatedDate, CreatedById, parentId from Attachment where (not Name like '%Executive%') and ParentId =:ag.id]) {      
            attachmentList.add(new attachmentWrapper(a));                                         
        }
        return attachmentList;  
    }
    public class attachmentWrapper {
        public Attachment attach{get; set;}
        public Boolean selected {get; set;}
        public attachmentWrapper(Attachment a) {
            attach = a;
            selected = false;
        }
    }
    
    public echosign_dev1__SIGN_Agreement__c echosign {get; set;}
    // public Account motorolaAccount {get; set;}
    public Boolean boolShowParent {get; set;}
    public Boolean boolShowThirdSigner {get; set;}
    private String strSectionHeader = 'Step-1: Select Contract Template';
    //public String strAgreementName {get; set;}
    private String strAgreementName; 
    public String currentTab{get; set;} 
    public Integer availableTab {get; set;}

    // Local contact fields
    String originalEmail;
    public String email {get; set;}
    public String phone {get; set;}
    private Contact localContact;
    public Contact MotoSigner {get; set;}
    public User legalRep{get; set;}  
    private Apttus__APTS_Agreement__c ag;    
    public string strRecordType {get;set;}
    public Boolean boolIsSpecialAccess {get; set;}  
    
    public Boolean boolIsRequired {get; set;} // for letting user partial Save without checking required fields on Step 4 
    public string sendcc {get; set;}

    // dynamic tabs enabling per agreement status
    public Boolean Step1 {get; set;}
    public Boolean Step2 {get; set;}
    public Boolean Step3 {get; set;}
    public Boolean Step4 {get; set;}
    public Boolean Step5 {get; set;}
    public Boolean Step6 {get; set;}
    public Boolean Step7 {get; set;}
    
    //Custom Apttus package URL
    public String apttusURL{
        get{
            String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
            if(baseURL.indexOf('cs') != -1){
                baseURL = baseURL.replace('c.', 'apttus.');
                return baseURL;
            }
            return '';
        }
        private set;
    }
    
    private Boolean updateAgr; //Specifies whether or not an agreement should be updated
    
    public String createContractMsgSev {get; private set;} //Specifies if the contract creation was successful from Step 3
    public String createContractMsg {get; private set;} //Set success / error message of contract creation from Step 3
    public String createContractId {get; private set;} //Link of the attachment contract from Step 3
    
    public String activateContractMsgSev {get; private set;}
    public String activateContractMsg {get; private set;}

    ApexPages.StandardController controller;

    public APTPS_CA_CreateContract(ApexPages.StandardController controller) {
        this.controller = controller;        
        boolIsSpecialAccess = false;
        boolShowParent = false;
        boolShowThirdSigner = false;
        updateAgr = false;
        createContractMsgSev = '';
        createContractMsg = '';
        activateContractMsgSev = '';
        activateContractMsg = '';
        availableTab = 0;
        strRecordType ='';
        sendcc = null;
        boolIsRequired=false;

        Id profileId=userinfo.getProfileId();        
        String strProfileName=[Select Id,Name from Profile where Id=:profileId].Name; 

        if(strProfileName == 'System Administrator' || strProfileName == 'Apttus Admin' || strProfileName =='MD - Legal'){
            boolIsSpecialAccess = true;          
        }    

        //Apttus__APTS_Agreement__c 
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        Integer thisYear = System.today().year();      

        if (ag.id == null) {            
            strSectionHeader = 'Welcome Page';
            getstrAgreementName();
            currentTab = 'tab0';
            populateLegalRep();

            if(!boolIsSpecialAccess) {              
                Schema.DescribeSObjectResult d = Schema.SObjectType.Apttus__APTS_Agreement__c;
                Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();
                for(RecordType sRecordType : [SELECT Id, Name FROM RecordType WHERE Name not in ('Deal','Real Estate','Other Depts','Indirect Test') and IsActive = true AND sObjectType = 'Apttus__APTS_Agreement__c']) {          
                    if(rtMapById.get(sRecordType.id).isDefaultRecordTypeMapping())                         
                        strRecordType = rtMapById.get(sRecordType.id).getRecordTypeId(); 
                }      
            } 

            // These two fields are required to activate the agreement
            ag.APT_Business_Unit__c = 'Mobile Devices';
            //ag.APT_Product_Category__c = 'MD Products';                   
        } else {
            setAgreementTab();
            getstrAgreementName();  
    
            // Edit Mode -- Populate channel partner, contact and Moto Account details            
            if(ag.Apttus__Parent_Agreement__c != null) {
                boolShowParent = true;
            }
            if(ag.Outside_Party_Signatory_2_Email__c != null && ag.Outside_Party_Signatory_2_Name__c != null) {
                boolShowThirdSigner = true;
            }

            ag.Apttus__Workflow_Trigger_Viewed_Final__c = false;
            strRecordType = ag.RecordTypeId;
            populateChannelPartnerInfo();
            //populateContactInfo();
            // populateMotorolaAccountInfo();
            populateLegalRep();
            populateMotoSignerInfo();
        }
    }
    
    public void recordTab(){
        Boolean updateAG = false;
        if(ag.Return_to_tab__c != currentTab){
            ag.Return_to_tab__c = currentTab;
            updateAG = true;
        }               
        
        if(availableTab > ag.Available_Tab__c || ag.Available_Tab__c == null){
            ag.Available_Tab__c = availableTab;
            updateAG = true;
        }
        if(updateAG || updateAgr){
            try{                
                // Update Motorola Entity lookup with picklist entity for template address merge
                List<Account> motoAccount = [select id, Name from Account where Source_System__c='R12' AND Name =:ag.APT_MMI_Contracting_Entity__c limit 1];           
                
                if(!motoAccount.isEmpty()) 
                    ag.APTPS_Motorola_Legal_Entity__c = motoAccount[0].id;               
                 
                    update ag;
            }catch(DmlException de){
                System.debug(de.getDMLMessage(0));
            }
            updateAgr = false;
        }
        
    }
    
    public Pagereference setRedirectFalse(){
        Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        if(ag.Redirect_User__c != null && ag.Redirect_User__c.contains(UserInfo.getUserId())) {            
            RemoveUserTab(true);            
            String queryName = ag.Name + '%' + 'Original_' + '%';          
            List<Attachment> attachList = [SELECT Id, CreatedDate, Name FROM Attachment WHERE ParentId=:ag.Id AND Name LIKE: queryName AND CreatedbyId =: UserInfo.getUserId() ORDER BY CreatedDate DESC LIMIT 1];

            if(!attachList.isEmpty()){
                Attachment a = attachList.get(0);
                if(a.CreatedDate.minute() == DateTime.now().minute() || a.CreatedDate.minute() == DateTime.now().addMinutes(-1).minute()){ //Check to see if the attachment was created recently (within a minute)
                    createContractId = a.Id;
                    createContractMsgSev = 'Confirm';
                    createContractMsg = 'Contract successfully created. Please click below to view contract';
                }
            }else{
                createContractMsgSev = 'Error';
                createContractMsg = 'There was an error while creating the contract.';
            }
        }
        return null;
    }
    
    private void RemoveUserTab(Boolean performDML){
        List<UserTabClass> utList = (List<UserTabClass>)JSon.deserialize(ag.Redirect_User__c, List<UserTabClass>.class);
            
        for(Integer i=0; i<utList.size(); i++){
            if(utList.get(i).userId == UserInfo.getUserId()){
                currentTab = utList.get(i).tabName;
                //availableTab = utList.get(i).availTab;
                utList.remove(i);
                
                if(currentTab == 'tab7'){
                    if(ag.Apttus__Status_Category__c == 'In Effect'){   
                        activateContractMsgSev = 'CONFIRM';
                        activateContractMsg = 'Contract activated successfully. You may now exit clicking Close button';
                    }else{
                        activateContractMsgSev = 'ERROR';
                        activateContractMsg = 'An error occurred';
                    }
                }
                break;
            }
        }
            
        if(!utList.isEmpty()){
            ag.Redirect_User__c = JSON.serialize(utList);
        }else{
            ag.Redirect_User__c = '';
        }
        
        if(performDML){
            try{
                update ag;
            }catch(DmlException de){
                System.debug(de.getDmlMessage(0));
            }
        }
    }
    
    private void addUserTab(Boolean performDML, String tab, Integer maxTab){
        List<UserTabClass> utList = new List<UserTabClass>();
        if(ag.Redirect_User__c != null && String.isNotBlank(ag.Redirect_User__c)){
            utList = (List<UserTabClass>)JSon.deserialize(ag.Redirect_User__c, List<UserTabClass>.class);
        }
        
        UserTabClass ut = new UserTabClass();
        ut.userId = UserInfo.getUserId(); 
        ut.tabName = tab;
        ut.availTab = maxTab;
        utList.add(ut);
        
        ag.Redirect_User__c = JSON.serialize(utList);
        
        if(performDML){
            try{
                update ag;
            }catch(DmlException de){
                System.debug(de.getDmlMessage(0));
            }
        }
    }


    //Create our list of record types
    public list<SelectOption> getRecordTypes()
    {
       list<SelectOption> options = new list<SelectOption>();
       options.add(new selectOption('', '- None -'));       
       Schema.DescribeSObjectResult d = Schema.SObjectType.Apttus__APTS_Agreement__c;
       Map<Id,Schema.RecordTypeInfo> rtMapById = d.getRecordTypeInfosById();

        for(RecordType sRecordType : [SELECT Id, Name FROM RecordType WHERE Name not in ('Deal','Real Estate','Other Depts','Indirect Test') and IsActive = true AND sObjectType = 'Apttus__APTS_Agreement__c'])
        {
            if(rtMapById.get(sRecordType.id).isAvailable()){        
                // Select options are added with key,value pairing
                options.add(new SelectOption(sRecordType.Id, sRecordType.Name));
            }
            if(rtMapById.get(sRecordType.id).isDefaultRecordTypeMapping()) {                        
                strRecordType = rtMapById.get(sRecordType.id).getRecordTypeId();
            } 
        }
        return options;
    }

    public void updateRecordType()
    {
        ag.RecordTypeId = strRecordType;
    }

    // set Section Header text with selected Tab text
    public String getstrSectionHeader(){
         
        if (currentTab == 'tab1') {
            return 'Step-1: Select Contract Template';
        } else if (currentTab == 'tab2') {
            return 'Step-2: Contract Party Information';
        } else if (currentTab == 'tab3') {
            return 'Step-3: Agreement Information';
        } else if (currentTab == 'tab4') {
            return 'Step-4: Business Approval Information';
        } else if (currentTab == 'tab5') {
            return 'Step-5: Approval';
        } else if (currentTab == 'tab6') {
            return 'Step-6: Echosign';
        } else if (currentTab == 'tab7') {
            return 'Step-7: Finalize and Activate Contract';
        }else return 'Welcome Page';
    }

    // set Section Header text with selected Tab text
    public void setAgreementTab() {        
       if (ag.Apttus__Status_Category__c == 'In Filing') {           
           if (ag.Apttus__Account__c == null && ag.APTPS_subtype__c != null) {
               currentTab = 'tab2';
               availableTab = 2;
           } else if (ag.Apttus__Contract_Start_Date__c == null && ag.Apttus__Account__c != null && ag.APTPS_subtype__c != null) {
               currentTab = 'tab3';
               availableTab = 3;
           } else if (ag.Apttus__Account__c!= null && ag.Apttus__Contract_Start_Date__c != null && ag.APTPS_subtype__c != null) {
               currentTab = 'tab4';
               availableTab = 4;
           } else {
               currentTab = 'tab1';
               availableTab = 1;
           }               
       } else if (ag.Apttus__Status_Category__c == 'Request') { 
            currentTab = 'tab3';
            availableTab = 3;
       } else if (ag.Apttus__Status_Category__c == 'In Authoring' && ag.APTPS_Executive_Summary_Generated__c == false && (ag.Apttus_Approval__Approval_Status__c == 'Not Submitted' || ag.Apttus_Approval__Approval_Status__c == '')) {
           currentTab = 'tab4';
           availableTab = 4;
       } else if (ag.Apttus__Status_Category__c == 'In Authoring' && ag.APTPS_Executive_Summary_Generated__c == true && (ag.Apttus_Approval__Approval_Status__c == 'Not Submitted' || ag.Apttus_Approval__Approval_Status__c == '' || ag.Apttus_Approval__Approval_Status__c == 'Pending Approval') ) {
            currentTab = 'tab5';
            availableTab = 5;
        } else if ((ag.Apttus__Status_Category__c == 'In Authoring' && ag.Apttus_Approval__Approval_Status__c == 'Approved') || ((ag.Apttus__Status_Category__c == 'In Signatures' || ag.Apttus__Status_Category__c == 'In Filing') && ag.Apttus__Status__c == 'Other Party Signatures')) {
            currentTab = 'tab6';
            availableTab = 6;
        } else if ((ag.Apttus__Status_Category__c == 'In Signatures' && ag.Apttus__Status__c == 'Fully Signed') || ag.Apttus__Status_Category__c == 'In Effect' || ag.Apttus__Status__c == 'Activated') {
            currentTab = 'tab7';
            availableTab = 7;
        }else{
            currentTab = ag.Return_To_Tab__c;
            if(ag.Available_Tab__c != null){
                availableTab = Integer.valueOf(ag.Available_Tab__c);
            }
        }
        getstrAgreementName();

    }
    
    // Set Agreement Name
    public String getstrAgreementName() {
        if (ag.id != null && ag.Name != null && ag.Apttus__FF_Agreement_Number__c != null) 
            strAgreementName = getstrSectionHeader() + ' {' + ag.Name + '} -- {' + ag.Apttus__FF_Agreement_Number__c + '}';
        else 
            strAgreementName = getstrSectionHeader();
        
        return strAgreementName;
    }


     public void populateLegalRep() {
        string legalRepName = null;

        if (ag.Contract_Departments__c == 'Intellectual Property (In Business)') {
            legalRepName = 'Michael Willian';
        } else if (ag.Contract_Departments__c == 'Customs') {
            legalRepName = 'Renae Easley';
        } else if (ag.Contract_Departments__c == 'Procurement: Companion Products' || ag.Contract_Departments__c == 'Procurement: Batteries' || ag.Contract_Departments__c == 'Procurement: Service & Repair') {
            legalRepName = 'Holle Urbanek';
        } else if (ag.Contract_Departments__c == 'Government Relations') {
            legalRepName = 'Laura Ellinger';
        } else if (ag.Contract_Departments__c == 'HR/ Benefits') {
            legalRepName = 'Jerry Malinin';
        } else if (ag.Contract_Departments__c == 'Indirect or non-production related contracts') {
            legalRepName = 'Nicolas Jaramillo';    
        } else if (ag.Contract_Departments__c == 'Procurement: Imagers' || ag.Contract_Departments__c == 'Procurement: Touchscreen, Displays') {
            legalRepName = 'Tarek Sultani';
        } else if (ag.Contract_Departments__c == 'Marketing') {
            legalRepName = 'William Anderson';
        } else if (ag.Contract_Departments__c == 'Product Development (Arshad)' ) {
            legalRepName = 'Heather Roberts';
        } else if (ag.Contract_Departments__c == 'Procurement: Silicon & Electrical' || ag.Contract_Departments__c == 'Procurement: Software') {
            legalRepName = 'Anna Britt';      
        } else if (ag.Contract_Departments__c == 'GTM: iDEN') {
            legalRepName = 'Max Stefanescu';       
        } else if (ag.Contract_Departments__c == 'GTM: Distributor') {
            legalRepName = 'Jon Hattenbach'; 
        } else if (ag.Contract_Departments__c == 'GTM: Sales') {
            legalRepName = 'Shari Wilkozek';  
        } else if (ag.Contract_Departments__c == 'GTM: Retail') {
            legalRepName = 'Anna Britt';  
        } else if (ag.Contract_Departments__c == 'GTM: Strategic Sales') {
            legalRepName = 'Tarek Sultani'; 
        } else if (ag.Contract_Departments__c == 'GTM: Strategic Sales 2') {
            legalRepName = 'Michael Willian';               
        } else if (ag.Contract_Departments__c == 'Procurement: Mechanical' || ag.Contract_Departments__c == 'Procurement: Memory' || ag.Contract_Departments__c == 'Real Estate' ) {
            legalRepName = 'Nicolas Jaramillo';
        } else if (ag.Contract_Departments__c == 'Procurement: Outsourcing') {
            legalRepName = 'Michael Willian';
        } else if (ag.Contract_Departments__c == 'Regional: ASIA') {
            legalRepName = 'Albert Tsui';
        } else if (ag.Contract_Departments__c == 'Regional: EMEA') {
            legalRepName = 'Harvey Bishop';
        } else if (ag.Contract_Departments__c == 'Regional: LATAM') {
            legalRepName = 'Max Stefanescu';
        } else if (ag.Contract_Departments__c == 'Regional: NA') {
            legalRepName = 'Shari Wilkozek';
        } else if (ag.Contract_Departments__c == null || ag.Contract_Departments__c == '') {
            legalRepName = null;
        }

        List<User> users =  [Select Id, Name, Email from User where Name = :legalRepName limit 1];
        if (!users.isEmpty()) {
            legalRep = users[0];
        }
    }
    
    public void emailLegalRep() {
        string emailrep = 'mailto:' + legalRep.name + ' <'+legalRep.email +'>';
    }

    public void populateChannelPartnerInfo() {
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();

        if (channelPartner != null && channelPartner.id == ag.Apttus__Account__c)
            return;

        //  if (ag.Apttus__Parent_Agreement__c == null && ag.id != null) {
        List<Account> accounts = [select id, name,
                                  BillingStreet, BillingCity, BillingState, BillingCountry,
                                  BillingPostalCode, region__c, Business_Entity_Type__c,
                                  Entity_Established_State_Country__c
                                  from Account where id = :ag.Apttus__Account__c];

        if (!accounts.isEmpty()) {
            channelPartner = accounts[0];
        }
    }

   /* public void populateContactInfo() {
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        if (localContact != null && localContact.Id == ag.Apttus__Primary_Contact__c)
            return;

        List<Contact> contacts =  [select id, email, phone, accountid, account.name
                                   from Contact
                                   where id = :ag.Apttus__Primary_Contact__c];

        if (!contacts.isEmpty()) {
            localContact = contacts[0];
            email = localContact.email;
            originalEmail = email; // Used to check if the user changed email address or not
            phone = localContact.phone;
        }
    }*/

    public void populateMotoSignerInfo() {
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        if (MotoSigner != null && MotoSigner.Id == ag.Apttus__Company_Signed_By__c)
            return;

        List<Contact> contacts =  [select id, email, phone, accountid, account.name
                                   from Contact
                                   where id = :ag.Apttus__Company_Signed_By__c];

        if (!contacts.isEmpty()) {
            MotoSigner = contacts[0];
            email = MotoSigner.email;
            originalEmail = email; // Used to check if the user changed email address or not
        }
    }


    public PageReference nextTab() {         
        boolean newAgreement = false;
        boolean performUpdate = true;
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        
        // boolIsRequired = true;
        //Savepoint sp = Database.setSavepoint();
        Date startDate = ag.Apttus__Contract_Start_Date__c;   
        
        PageReference pageRef = Page.APTPS_CA_CreateContract;
        pageRef.getParameters().put('id', ag.Id);
        pageRef.getParameters().put('nooverride', '1');
        pageRef.getParameters().put('sfdc.override', '1');
        pageRef.getParameters().put('scontrolCaching', '1');
        pageRef.setRedirect(true);
        
        if (ag.id == null) {
            try {              
                 if(ag.Apttus__Status_Category__c != 'In Filing')
                     ag.Apttus__Status_Category__c = 'Request';
                
                // Update Motorola Entity lookup with picklist entity for template address merge
                List<Account> motoAccount = [select id, Name from Account where Source_System__c='R12' AND Name =:ag.APT_MMI_Contracting_Entity__c limit 1];           
                
                if(!motoAccount.isEmpty()) 
                    ag.APTPS_Motorola_Legal_Entity__c = motoAccount[0].id;
                
                // Forces a workflow rule to generate the agreement name
                 //  ag.Apttus__Contract_Start_Date__c = null; 

                      
                if(currentTab == 'tab2') {
                        if(ag.Is_Supplier_Customer_on_Connected_Party__c == 'Yes')
                            ag.Connected_Party_Approval_Status__c = 'Pending';                            
                 
                    if (ag.APTPS_subtype__c == 'Master Services Agreement (MSA)')
                            ag.Apttus__Total_Contract_Value__c = 0;
                                        
                    // set defaults for Executive summary in Step 2                     
                       if(ag.RecordTypeId == '01240000000QJ1MAAW')
                           ag.APTPS_Practice_Area__c = 'GTM';
                       else if(ag.RecordTypeId == '01240000000QJSdAAO')
                          ag.APTPS_Practice_Area__c = 'Direct Supply Chain';  
                       else if(ag.RecordTypeId == '01240000000QJ1QAAW')
                          ag.APTPS_Practice_Area__c = 'Indirect Supply Chain'; 
                        else if(ag.RecordTypeId == '01240000000QJRVAA4')
                          ag.APTPS_Practice_Area__c = 'Marketing';

                  insert ag;
                  newAgreement = true;                        
                  currentTab = 'tab3';
                  if(availableTab < 3) 
                     availableTab = 3;
                } 
                            
            }  catch (Exception e) {                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Required fields need to be filled'); 
                ApexPages.addMessage(myMsg);
            } 
            return null;                 
        } else {
            if (!newAgreement && currentTab == 'tab1') {
                try {
                    currentTab = 'tab2';
                    if(availableTab < 2)   
                        availableTab = 2;   
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                }
            } else if (!newAgreement && currentTab == 'tab2') {
                try {
                     currentTab = 'tab3';
                     if(availableTab < 3) 
                        availableTab = 3;
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                }
            } else if (!newAgreement && currentTab == 'tab3') {            
                try {
                    if(ag.Apttus__Contract_End_Date__c == null && ag.Apttus__Term_Months__c != null) {
                        ag.Apttus__Contract_End_Date__c = ag.Apttus__Contract_Start_Date__c.addMonths(Integer.valueOf(ag.Apttus__Term_Months__c)); 
                    } else if (ag.Apttus__Contract_End_Date__c != null && ag.Apttus__Term_Months__c == null) {
                        
                    }           decimal term = getMonthsBetween(ag.Apttus__Contract_Start_Date__c,ag.Apttus__Contract_End_Date__c);
                        ag.Apttus__Term_Months__c = term.intValue();
                    currentTab = 'tab4';
                    if(availableTab < 4){
                        availableTab = 4;
                        
                        // set defaults for Executive summary in Step 4                        
                        if(ag.APTPS_Practice_Area__c == 'GTM')
                            ag.Payment_Terms_Based_on_Invoice_Shipping__c = '30';
                         else if (ag.APTPS_Practice_Area__c == 'Direct Supply Chain' || ag.APTPS_Practice_Area__c == 'Marketing')
                            ag.APT_Payment_Term_Days__c = '90';
                    }                    
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                }  
            } else if (!newAgreement && currentTab == 'tab4') {
                boolIsRequired=true;
                try {                
                    if(ag.Apttus__Status_Category__c == 'Request' || ag.Apttus__Status_Category__c == 'In Authoring') {
                        ag.Apttus__Status_Category__c = 'In Authoring';
                        ag.Apttus__Status__c = 'Author Contract';
                    }    
                    ag.APTPS_Offline_Document_Imported__c = true;   
                      if(
                         ag.Apttus__Total_Contract_Value__c == null 
                         || ag.APTPS_Explanation_of_LCV__c == null 
                         || (ag.APTPS_Practice_Area__c == 'Marketing' && ag.APTPS_Department_Being_Charged__c == null)
                         || (ag.APTPS_Practice_Area__c == 'GTM' && ag.Legal_Owner__c == null) 
                         || (ag.APTPS_Practice_Area__c != 'Direct Supply Chain' && ag.APTPS_Practice_Area__c != 'Marketing' && ag.Internal_Business_Owner__c == null) 
                         || (ag.APTPS_Practice_Area__c == 'Direct Supply Chain' && ag.Secondary_Legal_Owner__c == null) 
                         || (ag.APTPS_Practice_Area__c == 'Direct Supply Chain' && ag.APTPS_Category__c == null) 
                         || ((ag.APTPS_Practice_Area__c == 'Direct Supply Chain' || ag.APTPS_Practice_Area__c == 'Marketing') && ag.APT_Payment_Term_From__c == null) 
                         || ((ag.APTPS_Practice_Area__c == 'Direct Supply Chain' || ag.APTPS_Practice_Area__c == 'Marketing') && ag.APT_Payment_Term_Days__c == null)
                         || (ag.APTPS_Practice_Area__c == 'Direct Supply Chain' && ag.APT_Pre_pay_Commitment__c == null) 
                         || (ag.APTPS_Practice_Area__c != 'Marketing' && ag.APTPS_Minimum_Committment__c == null) 
                         || ag.APTPS_Product_Segment__c == null 
                         || (ag.APTPS_Practice_Area__c != 'Indirect Supply Chain' && ag.APTPS_MMI_Products__c == null) 
                         || ag.Can_Motorola_terminate_for_Convenience__c == null 
                         || ag.APTPS_Assignability_without_consent__c == null 
                         || ag.APT_Unusual_Risk__c == null
                        ) {
                        performUpdate = false;
                        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'All required fields need to be filled out to continue Next Step.');
                        ApexPages.addMessage(myMsg);
                        return null;
                    } 
                    if(ag.APTPS_Practice_Area__c == 'Indirect Supply Chain' && ag.Payment_Terms_Based_on_Receipt__c == null && ag.Payment_Terms_Based_on_Invoice_Shipping__c == null) {
                       performUpdate = false;
                       ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Required Payment Terms Based on Receipt or Payment Terms Based on Invoice/Shipping to continue Next Step.');
                       ApexPages.addMessage(myMsg);
                       return null;    
                    } 
                    
                    if(ag.Apttus__Status_Category__c != 'In Filing') {
                        ag.Check_Completeness_of_Executive_Summary__c = true;
                        ag.APTPS_Ready_to_generate_executive_sumary__c = true;
                        currentTab = 'tab5';
                        if(availableTab < 5){
                            availableTab = 5;
                        }
                    } else {
                        ag.APTPS_Executive_Summary_Generated__c = true;
                        currentTab = 'tab7';
                        if(availableTab < 7){
                            availableTab = 7;
                        }
                   }                
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,e.getMessage());
                    ApexPages.addMessage(myMsg);
                }                 
            } else if (!newAgreement && (currentTab == 'tab5' || currentTab == 'tab6') ) {
                try {                   
                    if(currentTab == 'tab5'){
                        currentTab = 'tab6';
                        if(availableTab < 6){   
                        availableTab = 6;
                        }
                    }else if(currentTab == 'tab6'){
                        currentTab = 'tab7';
                        if(availableTab < 7){   
                            availableTab = 7;
                        }
                    } 
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                }
            } else if (!newAgreement && currentTab == 'tab7' ) {
                try {
                    ag.Check_Completeness__c = true;
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                }
            } 
            try {
                if(performUpdate)
                    update ag;    
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                ApexPages.addMessage(myMsg);
            }
            getstrAgreementName();
            return null;
        }
    }
    
     public PageReference mySave() {         
        boolean newAgreement = false;
        boolean performUpdate = true;
 
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        Savepoint sp = Database.setSavepoint();
        Date startDate = ag.Apttus__Contract_Start_Date__c;
        
        PageReference pageRef = Page.APTPS_CA_CreateContract;
        pageRef.getParameters().put('id', ag.Id);
        pageRef.getParameters().put('nooverride', '1');
        pageRef.getParameters().put('sfdc.override', '1');
        pageRef.getParameters().put('scontrolCaching', '1');
        pageRef.setRedirect(true);
        
        boolIsRequired=false;

        if (ag.id == null) {
            try {            
                // This step is to force the agreement name to be generated
                //ag.Apttus__Contract_Start_Date__c = null;
                
                if(ag.Apttus__Status_Category__c != 'In Filing')
                     ag.Apttus__Status_Category__c = 'Request';

                
                // Update Motorola Entity lookup with picklist entity for template address merge
                List<Account> motoAccount = [select id, Name from Account where Source_System__c='R12' AND Name =:ag.APT_MMI_Contracting_Entity__c limit 1];           
                
                if(!motoAccount.isEmpty()) 
                    ag.APTPS_Motorola_Legal_Entity__c = motoAccount[0].id;
                
               // Forces a workflow rule to generate the agreement name
               //ag.Apttus__Contract_Start_Date__c = null; 
     
                if(currentTab == 'tab2') {
                    if(ag.Is_Supplier_Customer_on_Connected_Party__c == 'Yes')
                        ag.Connected_Party_Approval_Status__c = 'Pending';
                        
                        if (ag.APTPS_subtype__c == 'Master Services Agreement (MSA)')
                            ag.Apttus__Total_Contract_Value__c = 0;
                    // set defaults for Executive summary in Step 2                     
                       if(ag.RecordTypeId == '01240000000QJ1MAAW')
                           ag.APTPS_Practice_Area__c = 'GTM';
                       else if(ag.RecordTypeId == '01240000000QJSdAAO')
                          ag.APTPS_Practice_Area__c = 'Direct Supply Chain';  
                       else if(ag.RecordTypeId == '01240000000QJ1QAAW')
                          ag.APTPS_Practice_Area__c = 'Indirect Supply Chain'; 
                        else if(ag.RecordTypeId == '01240000000QJRVAA4')
                          ag.APTPS_Practice_Area__c = 'Marketing';
                    
                    
                    insert ag;
                    newAgreement = true;
                } 
            } catch (Exception e) {                                   
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Required fields need to be filled'); 
                ApexPages.addMessage(myMsg);
            }
            return null;   
        } else {        
            if (!newAgreement && currentTab == 'tab2') {
                try {
                    currentTab = 'tab3';
                    if(availableTab < 3)   
                        availableTab = 3;  
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                }
            } else if (!newAgreement && currentTab == 'tab3') {            
                try {
                    if(ag.Apttus__Contract_End_Date__c == null && ag.Apttus__Term_Months__c != null) {
                        ag.Apttus__Contract_End_Date__c = ag.Apttus__Contract_Start_Date__c.addMonths(Integer.valueOf(ag.Apttus__Term_Months__c)); 
                    } else if (ag.Apttus__Contract_End_Date__c != null && ag.Apttus__Term_Months__c == null) {                  
                        decimal term = getMonthsBetween(ag.Apttus__Contract_Start_Date__c,ag.Apttus__Contract_End_Date__c);
                        ag.Apttus__Term_Months__c = term.intValue();
                    }           
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                }  
            } else if (!newAgreement && currentTab == 'tab4') {
                try {                
                    if(ag.Apttus__Status_Category__c == 'Request' || ag.Apttus__Status_Category__c == 'In Authoring') {
                        ag.Apttus__Status_Category__c = 'In Authoring';
                        ag.Apttus__Status__c = 'Author Contract';
                    }   
                    ag.APTPS_Offline_Document_Imported__c = true;
                    
                    if(ag.Apttus__Status_Category__c != 'In Filing') {
                        ag.Available_Tab__c = 4;
                    } else {
                        ag.APTPS_Executive_Summary_Generated__c = true;
                        ag.Available_Tab__c = 7;
                    } 
                    update ag;
                    performUpdate = false;
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Executive summary required fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                }
            } else if (!newAgreement && (currentTab == 'tab5' || currentTab == 'tab6') ) {
                try {
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                } 
            } else if (!newAgreement && currentTab == 'tab7' ) {
                try {
                    ag.Check_Completeness__c = true;
                } catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                    ApexPages.addMessage(myMsg);
                }
            } 
             try {
                if (performUpdate) 
                    update ag;    
            } catch(Exception e){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
                ApexPages.addMessage(myMsg);
            }      
            getstrAgreementName(); 
            return null;
        }
    }

    public PageReference nextTabStep1() {       
        currentTab = 'tab2';
        availableTab = 2;       
        getstrAgreementName();
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();           
        
        PageReference pageRef=Page.APTPS_CA_CreateContract;
        pageRef.getParameters().put('id', ag.Id);
        pageRef.getParameters().put('nooverride', '1');
        pageRef.setRedirect(false);
        return pageRef;     
    }
    
    public PageReference nextTabStep() {       
        currentTab = 'tab1';
        availableTab = 1;       
        getstrAgreementName();
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();           
        
        PageReference pageRef=Page.APTPS_CA_CreateContract;
        pageRef.getParameters().put('id', ag.Id);
        pageRef.getParameters().put('nooverride', '1');
        pageRef.setRedirect(false);
        return pageRef;     
    }       
    public PageReference prevTab() {
        Integer intCurrTab = Integer.valueOf(currentTab.remove('tab'));
        currentTab = 'tab' + String.valueOf(intCurrTab - 1);
        getstrAgreementName();
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        
        PageReference pageRef=Page.APTPS_CA_CreateContract;
        pageRef.getParameters().put('id', ag.Id);
        pageRef.getParameters().put('nooverride', '1');
        pageRef.setRedirect(false);
        return pageRef;     
    }    
    public PageReference cancelTab() {
        PageReference pageref = new PageReference('/a0P/o');
        return pageref;
    }

    public PageReference detailViewTab() {
        PageReference pageref;
        ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        if (ag.id == null) {
            pageref = new PageReference('/a0P/o');
        } else {
            pageref = new PageReference('/' + ag.id);
        }      
        return pageref;
    }

    public PageReference createContract() {         
        Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();   
        if (ag.Apttus__Status_Category__c == 'In Authoring' || ag.Apttus__Status_Category__c == 'Request'){
            ag.APTPS_Offline_Document_Imported__c = true;  
        }       
        addUserTab(false, 'tab3', 3);
               
        try {
             if(ag.Apttus__Contract_End_Date__c == null && ag.Apttus__Term_Months__c != null) {
                ag.Apttus__Contract_End_Date__c = ag.Apttus__Contract_Start_Date__c.addMonths(Integer.valueOf(ag.Apttus__Term_Months__c)); 
             } else if (ag.Apttus__Contract_End_Date__c != null && ag.Apttus__Term_Months__c == null) {                  
                decimal term = getMonthsBetween(ag.Apttus__Contract_Start_Date__c,ag.Apttus__Contract_End_Date__c);
                ag.Apttus__Term_Months__c = term.intValue();
            }  
            update ag;         
        } catch(Exception e){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be filled'); 
           ApexPages.addMessage(myMsg);
           return null;
        }  
        
        updateAgr = true;        
        recordTab();
        Pagereference pageRef = Page.Apttus__AgreementSubmitRequest;    
        pageRef.getParameters().put('id',ag.Id);    
        return pageRef;
    }

    public PageReference reviewExSummary() { 
        Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();
        if (ag.Apttus__Status_Category__c == 'In Authoring' || ag.Apttus__Status_Category__c == 'Request'){
            ag.Apttus__Status_Category__c = 'In Authoring';
            ag.Apttus__Status__c = 'Author Contract';
            ag.APTPS_Executive_Summary_Generated__c = true;  
        }       
        addUserTab(false, 'tab4', 4);
        updateAgr = true;
        recordTab();

        Pagereference pageRef = Page.Apttus__SelectTemplate;
        pageRef.getParameters().put('id',ag.Id);    
        pageRef.getParameters().put('action','Generate_Supporting_Document'); 
        pageRef.getParameters().put('templateType','Supporting_Document');  
        pageRef.setRedirect(true);  
        return pageRef;  
    }

    public PageReference Activate() { 
        Pagereference pageRef = null;
        try {
            addUserTab(false, 'tab7', 7);
            updateAgr = true;
            recordTab();
            Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();
            ag.Check_Completeness__c = true;
            update ag;

            pageRef = Page.Apttus__AgreementActivate;
            pageRef.getParameters().put('id',ag.Id);    
            pageRef.setRedirect(true);
        } catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error,'Check for fields need to be fixed'); 
            ApexPages.addMessage(myMsg);
        }
        return pageRef;
    }   

    public PageReference fnSubmitApproval() {    
        Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();       

        ag.APTPS_Ready_for_Approval__c = true;
        try{    
            update ag;
        }catch(DMLException de){
            System.debug(de.getDMLMessage(0));
        }
        
        List<Attachment> a = [select Id from Attachment where parentId=:ag.id];
        if(a.IsEmpty()) {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You must attach a Contract prior to sending for approval.');
            ApexPages.addMessage(myMsg);
            return null; 
        }

        Pagereference pageRef = new PageReference('/apex/ApprovalContextSubmit?enableAttachments=true&sObjectType=Apttus__APTS_Agreement__c&sObjectId=' + ag.Id + 'retURL=/apex/APTPS_CA_CreateContract?&id=' + ag.Id);

        String baseURL = URL.getSalesforceBaseUrl().toExternalForm();
        
        // Production OR Sandbox URL
        if(baseURL.indexOf('na') != -1 || baseURL.indexOf('cs') != -1){
            String baseURL1 = baseURL.replace('c.', 'apttus-approval.');
            pageRef = new PageReference(baseURL1  + '/apex/ApprovalContextSubmit?enableAttachments=true&sObjectType=Apttus__APTS_Agreement__c&sObjectId=' + ag.Id + '&retURL=' + baseURL + '/apex/APTPS_CA_CreateContract?id=' + ag.Id);
        } 

        pageRef.setRedirect(true);
        return pageRef;
    } 

    public PageReference fnSendforSignatures() {
        string receipients = null;
        

        try {
            Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();  
            update ag;
            
            if(ag.Apttus_Approval__Approval_Status__c != 'Approved') {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'You must get approvals in Step 5 before sending for eSignature.');
                ApexPages.addMessage(myMsg);
                return null; 
            }
            
            if(!attachmentList.IsEmpty()) {           
                echosign_dev1__SIGN_Agreement__c echosign = new echosign_dev1__SIGN_Agreement__c();
                List<echosign_dev1__SIGN_Data_Mapping__c> dataMapping = [select Id,Name from echosign_dev1__SIGN_Data_Mapping__c where Name = 'Apttus DataMapping'];
                echosign.Name = ag.name;
                echosign.Apttus_Echosign__Apttus_Agreement__c   = ag.Id; // Apttus agreement lookup field                 
                echosign.echosign_dev1__RemindRecipient__c      = 'Every Day, Until Signed'; 
                // echosign.echosign_dev1__Message__c           = 'Please sign the attached contract';
                echosign.echosign_dev1__SignatureType__c        = 'e-Signature';
                echosign.echosign_dev1__PasswordProtectSign__c  = false;        
                echosign.echosign_dev1__PasswordProtectPDF__c   = false;  
                echosign.echosign_dev1__AutoUpdate__c           = true;
                echosign.echosign_dev1__Process_Template__c     = dataMapping[0].Id;                
                echosign.echosign_dev1__Background_Action__c    = 'Send';
                echosign.echosign_dev1__ReturnURL__c            = '/'+ag.Id;
                echosign.echosign_dev1__Cc__c                   = sendcc;

                insert echosign;
                
                List<Attachment> echosignAttachments = new List<Attachment>();  
                for(attachmentwrapper accwrapper : attachmentList) {                
                    if(accwrapper.selected == true) {                       
                        Attachment a = [select Id, Name, CreatedDate, CreatedById, parentId,body from Attachment where id=:accwrapper.attach.id];
                        Attachment a1 = a.clone();                      
                        a1.parentId=echosign.Id;                                                
                        echosignAttachments.add(a1);   
                        a.body = null;
                        a = null;
                    }
                }
                if(!echosignAttachments.IsEmpty()) {
                    if(ag.Outside_Party_Signatory_Email__c != '' && ag.Outside_Party_Signatory_Email__c != null) {                        
                        echosign_dev1__SIGN_Recipients__c receipient = new echosign_dev1__SIGN_Recipients__c();
                        receipient.echosign_dev1__Agreement__c = echosign.Id;
                        receipient.echosign_dev1__Email_Address__c = ag.Outside_Party_Signatory_Email__c;
                        receipient.echosign_dev1__Recipient_Type__c = 'Email';
                        receipient.Name = ag.Outside_Party_Signatory_Name__c;
                        receipient.echosign_dev1__Order_Number__c = 1;
                        insert receipient;              
                    }
                    if(ag.Outside_Party_Signatory_2_Email__c != null) {
                        echosign_dev1__SIGN_Recipients__c receipient = new echosign_dev1__SIGN_Recipients__c();
                        receipient.echosign_dev1__Agreement__c = echosign.Id;
                        receipient.echosign_dev1__Email_Address__c = ag.Outside_Party_Signatory_2_Email__c;
                        receipient.echosign_dev1__Recipient_Type__c = 'Email';
                        receipient.Name = ag.Outside_Party_Signatory_2_Name__c;
                        receipient.echosign_dev1__Order_Number__c = 2;
                        insert receipient; 
                        
                        if (receipients != null || receipients != '') 
                            receipients = receipients + ', ' +receipient.echosign_dev1__Email_Address__c;
                        else
                            receipients = receipient.echosign_dev1__Email_Address__c;
                    }

                    if (ag.Motorola_Signatory__c != null) {
                        echosign_dev1__SIGN_Recipients__c receipient = new echosign_dev1__SIGN_Recipients__c();
                        receipient.echosign_dev1__Agreement__c = echosign.Id;
                        receipient.echosign_dev1__User__c = ag.Motorola_Signatory__c;
                        receipient.echosign_dev1__Recipient_Type__c = 'User';
                        receipient.echosign_dev1__Order_Number__c = 3;
                        insert receipient;

                        List<User> mmlcontact = [select id,email,name from User where id=:receipient.echosign_dev1__User__c limit 1];
                        if (receipients != null || receipients != '') 
                            receipients = receipients + ', ' +mmlcontact[0].email;
                        else
                            receipients = mmlcontact[0].email;
                    } 

                    echosign.echosign_dev1__Recipient_Addresses__c = receipients;
                    echosign.echosign_dev1__Status__c = 'Out for Signature';
                    
                    insert echosignAttachments;
                    update echosign; 
                    
                    if(ag.Apttus__Status_Category__c == 'In Signatures' || ag.Apttus__Status_Category__c == 'In Authoring') {
                        ag.Apttus__Status_Category__c   = 'In Signatures';
                        ag.Apttus__Status__c            = 'Other Party Signatures';    
                    }
                    update ag; 
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'Your agreement is sent for eSignatures. You will be notified once signatures complete.');
                    ApexPages.addMessage(myMsg);                   
                } else {
                    delete echosign;
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select final contract document to send for eSignature.');
                    ApexPages.addMessage(myMsg);
                    return null;                    
                }  
                echosignAttachments.clear();              
            } } catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));                 
            }
        
        Pagereference pageRef = new PageReference('/apex/APTPS_CA_CreateContract?&id=' + ag.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public PageReference fnShowParent() {     
        return null;
    }  

    public PageReference fnShowThirdSigner() {     
        return null;
    }  
    
    public class UserTabClass{
        public String UserId = '';
        public String tabName = '';
        public Integer availTab = 0;
    }
    public decimal getMonthsBetween(date startDate, date endDate){        
        decimal n = 0.0;           
        if(startDate.month()== endDate.month() && startDate.year()== endDate.year()) {
            n =  decimal.valueOf((startDate.daysBetween(endDate) + 1 )) / decimal.valueOf(date.daysInMonth(startDate.year(),startDate.month()));
        } else {
            Integer monthsBetween = startDate.monthsBetween(endDate)-1;            
            decimal firstMonth = decimal.valueOf(date.daysInMonth(startDate.year() , startDate.month())-startDate.day()+1) / decimal.valueOf(date.daysInMonth(startDate.year(), startDate.month()));            
            decimal lastMonth = decimal.valueOf(endDate.toStartOfMonth().daysBetween(endDate)+1) / decimal.valueOf(date.daysInMonth(endDate.year(), endDate.month()));            
            n = firstMonth + decimal.valueOf(monthsBetween) + lastMonth;         
        }        
        return n.setScale(2, roundingMode.HALF_UP);    
    }
    public pageReference notifyFinance(){
       try {  
                update ag;
                List<User> financeOwner = [Select id,email from User where id = :ag.APTPS_Functional_Finance_Approver__c];
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();      
                email.setSubject('Please complete Executive Summary for ' + ag.Name + ' { ' + ag.Apttus__FF_Agreement_Number__c + ' }');
                email.setToAddresses(new String[] { financeOwner[0].email });

                email.setHtmlBody(System.Userinfo.getFirstName() + ' ' + System.Userinfo.getLastName() + ' requests you to complete the following Agreement Record for processing.</b>' + 
                ' Please coordinate with ' + System.Userinfo.getFirstName() + ' ' + System.Userinfo.getLastName() + ' for data inputs and to complete approval routing  and electronic signatures.</b>' +
                ' To view agreement <a href=' + URL.getSalesforceBaseUrl().toExternalForm() + '/apex/APTPS_CA_CreateContract?id='+ag.Id+'>click here.</a>');
                email.setBccSender(true);
                
                Messaging.SendEmailResult [] r = Messaging.SendEmail(new Messaging.SingleEmailMessage[] {email});      
                for ( Messaging.sendEmailResult result : r ) {
                       if ( !r[0].isSuccess () ) {                 
                           System.debug ( result );
                       } else{
                           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'Email Sent Successfully' );
                           ApexPages.addMessage(msg);
                       }
                   }
               } catch(Exception e){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage()));                 
            }
                return null;  
     }
     
        Public Pagereference sendEmailFunction(){
                
         try {
            Apttus__APTS_Agreement__c ag = (Apttus__APTS_Agreement__c)controller.getRecord();
            update ag;
            List<Attachment> a = [select Id from Attachment where parentId=:ag.id];
            if(a.IsEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must create a Contract prior to sending for review.'));
                return null; 
            } 
            else  {
                String toaddress =legalRep.email ;
                Contact c = [select id, Email from Contact where email <> null limit 1];
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {toaddress};              
                mail.setToAddresses(toAddresses);               
                mail.setSenderDisplayName('Apttus');
                mail.setBccSender(false);

                Id EmailTemplateID = EmailUtility.FindEmailTemplateIDByDeveloperName('APTPS_Legal_Review');
                mail.setTemplateId(EmailTemplateID);
                mail.setTargetObjectId(c.id);
                mail.setWhatId(ag.id);
                mail.setSaveAsActivity(false);

                Savepoint sp = Database.setSavepoint();
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                Database.rollback(sp);

                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setToAddresses(mail.getToAddresses());
                emailToSend.setPlainTextBody(mail.getPlainTextBody());
                emailToSend.setHTMLBody(mail.getHTMLBody());
                emailToSend.setSubject(mail.getSubject());


                // Add a new Task to the contact record we just found above
                Task[] newTask = new Task[0];

                newTask.add(new Task(Description = mail.getPlainTextBody(),
                        Priority = 'High',
                        Status = 'In Progress',
                        Subject = mail.getSubject(),
                        IsReminderSet = true,
                        ReminderDateTime = System.now()+1,
                        OwnerId = legalRep.Id,
                        WhatId = ag.id,
                        RecordTypeId = '01240000000QJ8TAAW'
                        ));
                insert newTask;



                List<Messaging.Emailfileattachment> fileAttachments = new List<Messaging.Emailfileattachment>();
                List<Attachment> taskAttachments = new List<Attachment>(); 
                for(attachmentwrapper accwrapper : attachmentList) {                
                    if(accwrapper.selected == true) {                       
                        for (Attachment arg:[select Id, Name, CreatedDate, CreatedById, parentId,body from Attachment where id=:accwrapper.attach.id]){
                            // Attachments to Email
                            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
                            efa.setFileName(arg.Name);
                            efa.setBody(arg.body);
                            fileAttachments.add(efa);

                            // inserting attachments to Task
                            Attachment a1 = arg.clone();                      
                            a1.parentId=newTask[0].Id; 
                            a1.OwnerId = legalRep.Id;                           
                            taskAttachments.add(a1); 
                            arg.body = null;
                            arg = null; 
                        } 
                        insert taskAttachments;
                        emailToSend.setFileAttachments(fileAttachments);

                        // Send email

                        Messaging.SendEmailResult [] r = Messaging.SendEmail(new Messaging.SingleEmailMessage[] {emailToSend});      
                        for ( Messaging.sendEmailResult result : r ) {
                            if ( !r[0].isSuccess () ) {                 
                                System.debug ( result );
                            } else{
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Notification for Legal Review Sent Successfully' ));
                            }
                          }
                    }
                    else {       
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'You must attach a Contract prior to sending for review.'));
                        return null; 
                    } 
                }

            }
        }catch(Exception e){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,e.getMessage())); 
        }
        return null;  

    }  

}