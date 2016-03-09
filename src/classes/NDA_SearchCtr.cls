public class NDA_SearchCtr {  
/*
* Created by: BigKite Consulting
* Creation date: 01-Oct-2013
* Test Class: NDA_SearchCtrTest
* Description: This class is used as a Controller for VF page NDA search
*
* Change history:
* Changed on:
* Changed by:
* Description:
*/
    public Integer intNoOfRecords {get; set;}   
    public Integer intSize {get; set;}  
    public Boolean boolShowProduct { get; set; }
    public Boolean boolShowMultiCompany { get; set; }
    public String strNDAStatus {get; set;}
    public String strSpecNDAStatus {get; set;}
    public ApexPages.StandardSetController ndaRecords { get; set; }
    public NDA__c objNDA {get; set;}
    
    public NDA_Company__c objNDAComp { get; set; }    
    public String companyone{get; set;} 
    public String companytwo{get; set;}    
    ID MutualCompany;
    ID MultiCompany;
    public Boolean boolShowNewNDA { get; set; }

    public NDA_SearchCtr(){
        objNDA = new NDA__c();         
    }

    //builds a picklist of Company names
  /*  public List<selectOption> getNDACompanies() {
        //new list for holding all of the picklist options
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('', '- None -')); 
        for (NDA_Company__c lstCompanies : [SELECT Id, Name FROM NDA_Company__c]) { 
            //for all records found - add them to the picklist options
            options.add(new selectOption(lstCompanies.Id, lstCompanies.Name)); 
        }
        return options; //return the picklist options
    } */
    
    // Populates the list of searched NDA records   
    public list<NDA__c> getNdaRecordlist() {    
        list<NDA__c> lstNdaRecords = new list<NDA__c>();
        if(ndaRecords != null){
            for(NDA__c nda : (List<NDA__c>)ndaRecords.getRecords())
                lstNdaRecords.add(nda);
            }
        return lstNdaRecords ;
    }
    
    /**
        Method: fnSeacrh
        Description: Used to search NDAs with user entered input criterias. 
                     Invoked when user clicks Seacrh Button from VF Page.
    **/
    public PageReference fnSearch()  {    
        boolShowNewNDA = false;
        intSize = 10;       
        String eventQuery=null;
        eventQuery = 'select NDAFileID__c,NDARegion__c,Disclosure_Purpose__c,CreatedDate,Modification_Text__c,NDAStatus__c,DPLStatus__c,Expires_On__c'; 
       
       /* List<String> eventFields=new List<String>();
        eventFields.addAll(NDA__c.getSObjectType().getDescribe().fields.getMap().keyset());
        eventQuery='select '+eventFields.get(0);
        for(integer i=1;i<eventFields.size();i++){
            eventQuery+=','+eventFields.get(i);
        } */
        
        Id loggedInUserID = UserInfo.getUserId() ;
        strNDAStatus = 'Executed'; 
        strSpecNDAStatus = 'Executed-Mod'; 
        
        Id profileId=userinfo.getProfileId();
        Id roleId=userinfo.getUserRoleId();
        
        String strProfileName=[Select Id,Name from Profile where Id=:profileId].Name;
        String strRoleName=[Select Id,Name from UserRole where Id=:roleId].Name;   
        
         if (companyone != null || companyone != '') {
            List <NDA_Company__c> companyOne =  [Select id,name from NDA_Company__c where name =:companyone];
            if (companyOne.size() > 0) {
                MutualCompany = companyOne[0].Id;
            } else {
                boolShowNewNDA = true;
                return null;
            }
        }       
        if(boolShowMultiCompany) {
            if (companytwo != null || companytwo != '')
            {
                List <NDA_Company__c> companyTwo =  [Select id,name from NDA_Company__c where name =:companytwo];
                if (companyTwo.size() > 0) {
                    MultiCompany = companyTwo[0].Id;
                } else {          
                    boolShowNewNDA = true;
                    return null;
                } 
            }   
        }  
        
        if(boolShowProduct){                  
            if(!boolShowMultiCompany) { 
             if(strProfileName == 'System Administrator' || strProfileName == 'MotoDev - SysAdmin' || strRoleName == 'NDA' || strRoleName == 'NDA Specialist' ){
                 eventQuery+=' ,Company__r.name from NDA__c WHERE Company__c = \'' + MutualCompany  +'\' AND  IsProductNDA__c = true AND (NDAStatus__c = \'' + strNDAStatus+'\' OR NDAStatus__c = \'' + strSpecNDAStatus +'\' ) AND ((createdByID != \'' + loggedInUserID +'\') OR (createdByID = \'' + loggedInUserID +'\'))';
             } else{            
                eventQuery+=' ,Company__r.name from NDA__c WHERE Company__c = \'' + MutualCompany  +'\' AND  IsProductNDA__c = true AND NDAStatus__c = \'' + strNDAStatus+'\' AND ((createdByID != \'' + loggedInUserID +'\') OR (createdByID = \'' + loggedInUserID +'\'))';
             }} else{
             if(strProfileName == 'System Administrator' || strProfileName == 'MotoDev - SysAdmin' || strRoleName == 'NDA' || strRoleName == 'NDA Specialist' ){
                 eventQuery+=' ,Company__r.name from NDA__c WHERE (Company__c = \'' + MutualCompany +'\' OR Company__c = \'' + MultiCompany +'\')  AND (Multiparty_Company__c = \'' + MultiCompany +'\' OR Multiparty_Company__c = \'' + MutualCompany +'\') AND  IsProductNDA__c = true AND (NDAStatus__c = \'' + strNDAStatus+'\' OR NDAStatus__c = \'' + strSpecNDAStatus +'\' ) AND ((createdByID != \'' + loggedInUserID +'\') OR (createdByID = \'' + loggedInUserID +'\'))'; 
             } else {
           eventQuery+=' ,Company__r.name from NDA__c WHERE (Company__c = \'' + MutualCompany +'\' OR Company__c = \'' + MultiCompany +'\')  AND (Multiparty_Company__c = \'' + MultiCompany +'\' OR Multiparty_Company__c = \'' + MutualCompany +'\') AND  IsProductNDA__c = true AND NDAStatus__c = \'' + strNDAStatus+'\' AND ((createdByID != \'' + loggedInUserID +'\') OR (createdByID = \'' + loggedInUserID +'\'))';             
        }} } else{
            // User would be able to see only his NDA records
           if(!boolShowMultiCompany) {    
                if(strProfileName == 'System Administrator' || strProfileName == 'MotoDev - SysAdmin' || strRoleName == 'NDA' || strRoleName == 'NDA Specialist' ){
                    eventQuery+=' ,Company__r.name from NDA__c WHERE Company__c = \'' + MutualCompany +'\' AND  IsProductNDA__c = false AND (NDAStatus__c = \'' + strNDAStatus+'\' OR NDAStatus__c = \'' + strSpecNDAStatus +'\' ) AND  ((createdByID != \'' + loggedInUserID +'\') OR (createdByID = \'' + loggedInUserID +'\'))';
                } else {
                   eventQuery+=' ,Company__r.name from NDA__c WHERE Company__c = \'' + MutualCompany +'\' AND  IsProductNDA__c = false AND (NDAStatus__c = \'' + strNDAStatus+'\' OR NDAStatus__c = \'' + strSpecNDAStatus +'\' ) AND  ((createdByID != \'' + loggedInUserID +'\') OR (createdByID = \'' + loggedInUserID +'\'))';   
               }} else { 
               if(strProfileName == 'System Administrator' || strProfileName == 'MotoDev - SysAdmin' || strRoleName == 'NDA' || strRoleName == 'NDA Specialist' ){
                   eventQuery+=' ,Company__r.name from NDA__c WHERE (Company__c = \'' + MutualCompany +'\' OR Company__c = \'' + MultiCompany +'\')  AND (Multiparty_Company__c = \'' + MultiCompany +'\' OR Multiparty_Company__c = \'' + MutualCompany +'\') AND  IsProductNDA__c = false AND (NDAStatus__c = \'' + strNDAStatus+'\' OR NDAStatus__c = \'' + strSpecNDAStatus +'\' ) AND ((createdByID != \'' + loggedInUserID +'\') OR (createdByID = \'' + loggedInUserID +'\'))';  
               } else {
                    eventQuery+=' ,Company__r.name from NDA__c WHERE (Company__c = \'' + MutualCompany +'\' OR Company__c = \'' + MultiCompany +'\')  AND (Multiparty_Company__c = \'' + MultiCompany +'\' OR Multiparty_Company__c = \'' + MutualCompany +'\') AND  IsProductNDA__c = false AND NDAStatus__c = \'' + strNDAStatus+'\' AND ((createdByID != \'' + loggedInUserID +'\') OR (createdByID = \'' + loggedInUserID +'\'))';         
             }} 
    }
        ndaRecords = new ApexPages.StandardSetController(Database.getQueryLocator(eventQuery));        
        ndaRecords.setPageSize(intSize);      
        intNoOfRecords = ndaRecords.getResultSize();
        return null;
    } 
    
    /**
        Method: fnCreateNDA
        Description: Used to create NDAs with user entered input criterias didnot return any results or user like to create new NDA after search
                     Invoked when user clicks New NDA Button from VF Page.
    **/
    public PageReference fnCreateNDA() {  
        string strcomp1;
        string strcomp2;
        
         if (companyone != null || companyone != '') {
            List <NDA_Company__c> firstCompany =  [Select id,name from NDA_Company__c where name =:companyone];
            if (firstCompany.size() > 0) {
                strcomp1 = firstCompany[0].Id;
            } else {
               NDA_Company__c objNDAComp1 = new NDA_Company__c(); 
                objNDAComp1.Name = companyone;
                insert objNDAComp1;  
                strcomp1 = objNDAComp1.Id;
            }
        }       
        if(boolShowMultiCompany) {
            if (companytwo != null || companytwo != '')
            {
                List <NDA_Company__c> secondCompany =  [Select id,name from NDA_Company__c where name =:companytwo];
                if (secondCompany.size() > 0) {
                     strcomp2 = secondCompany[0].Id;
                } else {          
                    NDA_Company__c objNDAComp2 = new NDA_Company__c();
                    objNDAComp2.Name = companytwo;
                    insert objNDAComp2;  
                    strcomp2 = objNDAComp2.Id;  
                } 
             }
        }         
        
    
    /*  if(MutualCompany == null && (companyone != null || companyone != '')) {
            NDA_Company__c objNDAComp1 = new NDA_Company__c(); 
            objNDAComp1.Name = companyone;
            insert objNDAComp1;  
            strcomp1 = objNDAComp1.Id;  
        } else {
            strcomp1 = MutualCompany;
        }
       if(boolShowMultiCompany) { 
            if (MultiCompany == null && (companyone != null || companyone != '')) {
                NDA_Company__c objNDAComp2 = new NDA_Company__c();
                objNDAComp2.Name = companyone;
                insert objNDAComp2;  
                strcomp2 = objNDAComp2.Id;  
            } else {
                strcomp2 = MultiCompany;
            }
        } */
           
        Pagereference pageRef = Page.NDA_Create;
        pageRef.getParameters().put('pv03',String.ValueOf(boolShowProduct));
        pageRef.getParameters().put('pv06',strcomp1);
        pageRef.getParameters().put('pv07',String.ValueOf(boolShowMultiCompany));   
        pageRef.getParameters().put('pv08',strcomp2);              
        pageRef.setRedirect(true);  
        return pageRef; 
    } 
    
     /**
        Method: fnCreateNDACompany
        Description: Used to Create NDA Company with user entered input criteria didnot return any results. 
                     Invoked when user clicks Add new outside party Button from VF Page.
    **/
  /*   public PageReference fnCreateNDACompany() { 
       system.debug('boolShowProduct: ' + this.boolShowProduct);
       string strIsProduct;
 
       strIsProduct = String.ValueOf(boolShowProduct);     
       PageReference compPageRef;            
       compPageRef = Page.NDA_CustomNDACompanyLookup;
       //compPageRef.getParameters().put('sm1',String.ValueOf(boolShowProduct));       
       //compPageRef.getParameters().put('sm2',String.ValueOf(boolShowMultiCompany));
       //compPageRef.getParameters().put('pv06',MutualCompany);
       compPageRef.setRedirect(true); 
       return compPageRef;
    } */
     
    
    public Integer getResultSize(){
        if(ndaRecords!=null)
        return ndaRecords.getResultSize();
        return 0;
    }    
    
    public PageReference fnShowProduct() { 
        return null;
    }  
     public PageReference fnShowMultiCompany() {
        return null;
    }

}