public class NDA_DashboradSearchCtr {
/*
* Created by: BigKite Consulting
* Creation date: 30-Sep-2013
* Test Class: NDA_DashboradSearchCtrTest
* Description: This class is used as a Controller for VF page NDA_DashboradSearch
*
* Change history:
* Changed on:
* Changed by:
* Description:
*/
    public Integer intNoOfRecords {get; set;}   
    public Integer intSize {get; set;}  
    public String strSelectedRegion {get; set;}
    public String strFileID {get; set;}  
    public String companytwo{get; set;}    
    public Boolean boolInclude {get; set;}
    public ApexPages.StandardSetController ndaRecords { get; set; }
    public String strNDAStatus = 'Executed';
    public String strStatusExpire = 'Expired';
    public String strStatusCancel = 'Cancelled'; 
    public NDA__c objNDA {get; set;}
    
    public NDA_DashboradSearchCtr(){
        objNDA = new NDA__c();
        objNDA.RecordTypeId = fnRecordType();
    }
    
    /**
        Method: fnSeacrh
        Description: Used to search NDAs with user entered input criterias. 
                     Invoked when user clicks Seacrh Button from VF Page.
    **/
    public PageReference doaction()  {
        fnSeacrh();
        return null;
    }
    
    /*
        Method used to get NDA record type ID
    */
    public String fnRecordType(){
        RecordType recType = [select id,name from RecordType where Name = 'NDA' AND sobjectType = 'NDA__c' limit 1];
        return recType.Id;
    }
    
    public PageReference fnSeacrh()  {
        intSize = 10;       
        String eventQuery=null;
       /* List<String> eventFields=new List<String>();
        eventFields.addAll(NDA__c.getSObjectType().getDescribe().fields.getMap().keyset());
        eventQuery='select '+eventFields.get(0);
        for(integer i=1;i<eventFields.size();i++){
            eventQuery+=','+eventFields.get(i);
        } */
        
        eventQuery = 'select NDAFileID__c,NDARegion__c,Disclosure_Purpose__c,CreatedDate,Modification_Text__c,NDAStatus__c,DPLStatus__c,Expires_On__c'; 
        
        Id loggedInUserID = UserInfo.getUserId() ;
        
        Id profileId=userinfo.getProfileId();
        Id roleId=userinfo.getUserRoleId();
        
        String strProfileName=[Select Id,Name from Profile where Id=:profileId].Name;
        String strRoleName=[Select Id,Name from UserRole where Id=:roleId].Name;
        
        if(strProfileName == 'System Administrator' || strProfileName == 'MotoDev - SysAdmin' || strRoleName == 'NDA' || strRoleName == 'NDA Specialist' ){
            if((companytwo != null && companytwo != '') && (objNDA.NDARegion__c != null && objNDA.NDARegion__c != '') ){
                eventQuery+=' ,company__r.name, createdBy.name from NDA__c WHERE NDARegion__c = \'' + objNDA.NDARegion__c 
                         +'\' AND company__r.name = \''+ companytwo + '\'';                      
            }else if((companytwo == null || companytwo == '') && (objNDA.NDARegion__c != null && objNDA.NDARegion__c != '') ){
                eventQuery+=' ,company__r.name,createdBy.name from NDA__c WHERE NDARegion__c = \'' + objNDA.NDARegion__c+ '\'';                          
            }else if((companytwo != null && companytwo != '') && (objNDA.NDARegion__c == null || objNDA.NDARegion__c == '') ){
                eventQuery+=' ,company__r.name,createdBy.name from NDA__c WHERE company__r.name = \'' + companytwo + '\'';                          
            }
            else{
                eventQuery+=' ,company__r.name,createdBy.name from NDA__c';                            
            }
        }else{
            if((objNDA.NDARegion__c != null && objNDA.NDARegion__c != '') && (companytwo != null && companytwo != '') ){  
                if(boolInclude){                             
                    eventQuery+=' ,company__r.name,createdBy.name from NDA__c WHERE NDARegion__c = \'' + objNDA.NDARegion__c 
                             +'\' AND Ncompany__r.name = \''+ companytwo + '\' AND createdByID = \'' + loggedInUserID +'\'';         
                }else{
                    eventQuery+=' ,company__r.name,createdBy.name from NDA__c WHERE NDARegion__c = \'' + objNDA.NDARegion__c 
                             +'\' AND company__r.name = \''+ companytwo + '\' AND createdByID = \'' + loggedInUserID 
                             +'\' AND (NDAStatus__c != \'' + strStatusExpire + '\' AND NDAStatus__c != \''+ strStatusCancel +'\')';                        
                }
            }else if((companytwo == null || companytwo == '') && (objNDA.NDARegion__c != null && objNDA.NDARegion__c != '') ){
                if(boolInclude){        
                    eventQuery+=' ,company__r.name,createdBy.name from NDA__c WHERE NDARegion__c = \'' + objNDA.NDARegion__c 
                             + '\' AND createdByID = \'' + loggedInUserID +'\'';
                }else{
                    eventQuery+=' ,company__r.name,createdBy.name from NDA__c WHERE NDARegion__c = \'' + objNDA.NDARegion__c + '\' AND createdByID = \'' + loggedInUserID + '\' AND (NDAStatus__c != \'' + strStatusExpire + '\' AND NDAStatus__c != \''+ strStatusCancel +'\')';                               
                }
            }else if((companytwo != null && companytwo != '') && (objNDA.NDARegion__c == null || objNDA.NDARegion__c == '') ){
                if(boolInclude){         
                    eventQuery+=' ,company__r.name,createdBy.name from NDA__c WHERE company__r.name = \''+ companytwo + '\' AND createdByID = \'' + loggedInUserID +'\'';                            
                }else{
                    eventQuery+=' ,company__r.name,createdBy.name from NDA__c WHERE company__r.name = \''+ companytwo 
                    + '\' AND createdByID = \'' + loggedInUserID +'\' AND (NDAStatus__c != \'' + strStatusExpire + '\' AND NDAStatus__c != \''+ strStatusCancel +'\')';                               
                }
            }else{
                eventQuery+=' ,company__r.name,createdBy.name from NDA__c WHERE createdByID = \'' + loggedInUserID +'\' AND (NDAStatus__c != \'' + strStatusExpire + '\' AND NDAStatus__c != \''+ strStatusCancel +'\')';
            }
        }
        eventQuery+= ' ORDER BY CreatedDate DESC limit 10000';           
        ndaRecords = new ApexPages.StandardSetController(Database.getQueryLocator(eventQuery));        
        ndaRecords.setPageSize(intSize);      
        intNoOfRecords = ndaRecords.getResultSize();                       
        return null;
    } 
    
    // Populates the list of searched NDA records   
    public list<NDA__c> getNdaRecordlist() {    
        list<NDA__c> lstNdaRecords = new list<NDA__c>();
        if(ndaRecords != null){
            for(NDA__c nda : (List<NDA__c>)ndaRecords.getRecords())
                lstNdaRecords.add(nda);
            }
        return lstNdaRecords ;
    } 
        
    // Used to Navigae User to download Excel 
    public PageReference fnExportExcel()  {
        PageReference pageRefToExport = Page.NDA_DashboardRltsExcel;
        pageRefToExport.getParameters().put('pv01',strNDAStatus);
        pageRefToExport.getParameters().put('pv02',string.valueOf(boolInclude));
        // Remove : strFileID value assignment
        pageRefToExport.getParameters().put('pv03',companytwo);
        pageRefToExport.getParameters().put('pv04',objNDA.NDARegion__c);
        pageRefToExport.setRedirect(true);
        
        return pageRefToExport;
    }       
    
}