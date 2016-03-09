public class NDA_DashboardRltsExcelCtr {
/*
* Created by: BigKite Consulting
* Creation date: 24-Oct-2013
* Test Class: NDA_DashboardRltsExcelCtrTest
* Description: This class is used as a Controller for VF page NDA_DashboardRltsExcel page.
*
* Change history:
* Changed on:
* Changed by:
* Description:
*/
    public String strNDAStatus;
    public Boolean boolInclude;
    public String companytwo;   
    public String strSelectedRegion;
    public String strTempVar;
    public list<NDA__c> lstNDA {get; set;}
    
    public PageReference doAction(){
        String strStatusExpire = 'Expired';
        String strStatusCancel = 'Cancelled';  
        
        strNDAStatus = ApexPages.currentPage().getParameters().get('pv01');
        strTempVar = ApexPages.currentPage().getParameters().get('pv02');
        if(strTempVar != null && strTempVar != ''){
            boolInclude = Boolean.valueOf(strTempVar);
        }else{
            boolInclude = false;
        }   
        companytwo = ApexPages.currentPage().getParameters().get('pv03');
        strSelectedRegion = ApexPages.currentPage().getParameters().get('pv04');        
        String strWherClause; 
        Id loggedInUserID = UserInfo.getUserId() ;      
        Id profileId=userinfo.getProfileId();
        Id roleId=userinfo.getUserRoleId();
        String strProfileName=[Select Id,Name from Profile where Id=:profileId].Name;       
        String strRoleName=[Select Id,Name from UserRole where Id=:roleId].Name;
        
        if(strProfileName == 'System Administrator' || strProfileName == 'MotoDev - SysAdmin' || strRoleName == 'NDA' || strRoleName == 'NDA Specialist' ){
            if((companytwo != null && companytwo != '') && (strSelectedRegion != null && strSelectedRegion != '') ){
                strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE NDARegion__c = \'' + strSelectedRegion 
                         +'\' AND company__r.name = \''+ companytwo + '\'';                      
            }else if((companytwo == null || companytwo == '') && (strSelectedRegion != null && strSelectedRegion != '') ){
                strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE NDARegion__c = \'' + strSelectedRegion+ '\'';                            
            }else if((companytwo != null && companytwo != '') && (strSelectedRegion == null || strSelectedRegion == '') ){
                strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE company__r.name = \'' + companytwo+ '\'';                            
            }else{
                strWherClause=' ,company__r.name, createdBy.name from NDA__c';                          
            }
        }else{
            if((strSelectedRegion != null && strSelectedRegion != '') && (companytwo != null && companytwo != '') ){  
                if(boolInclude){         
                    strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE NDARegion__c = \'' + strSelectedRegion 
                             +'\' AND company__r.name = \''+ companytwo + '\' AND ((NDAStatus__c = \'' +
                             strNDAStatus+'\' OR NDAStatus__c = \'' + strStatusExpire+ 
                             '\' OR NDAStatus__c = \''+ strStatusCancel +'\') AND createdByID = \'' 
                            + loggedInUserID +'\')';
                             
                }else{
                    strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE NDARegion__c = \'' + strSelectedRegion 
                             +'\' AND company__r.name = \''+ companytwo + '\' AND ((NDAStatus__c != \'' + strStatusExpire+ 
                             '\' OR NDAStatus__c != \''+ strStatusCancel +'\') AND createdByID = \'' 
                            + loggedInUserID +'\')' ;      
                }
            }else if((companytwo == null || companytwo == '') && (strSelectedRegion != null && strSelectedRegion != '') ){
                if(boolInclude){
                    strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE NDARegion__c = \'' + strSelectedRegion 
                             + '\' AND ((NDAStatus__c = \'' +
                             strNDAStatus+'\' OR NDAStatus__c = \'' + strStatusExpire+ 
                             '\' OR NDAStatus__c = \''+ strStatusCancel +'\') AND createdByID = \'' 
                            + loggedInUserID +'\')' ;
                             
                }else{
                    strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE NDARegion__c = \'' + strSelectedRegion 
                             + '\' AND ((NDAStatus__c != \'' + strStatusExpire+ 
                             '\' OR NDAStatus__c != \''+ strStatusCancel +'\') AND createdByID = \'' 
                            + loggedInUserID +'\')' ;      
                }
            }else if((companytwo != null && companytwo != '') && (strSelectedRegion == null || strSelectedRegion == '') ){
                if(boolInclude){
                    strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE company__r.name = \''+ companytwo + '\' AND ((NDAStatus__c = \'' +
                             strNDAStatus+'\' OR NDAStatus__c = \'' + strStatusExpire+ 
                             '\' OR NDAStatus__c = \''+ strStatusCancel +'\') AND createdByID = \'' 
                            + loggedInUserID +'\')' ;
                             
                }else{
                    strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE company__r.name = \''+ companytwo + '\' AND ((NDAStatus__c != \'' + strStatusExpire+ 
                             '\' OR NDAStatus__c != \''+ strStatusCancel +'\') AND createdByID = \'' 
                            + loggedInUserID +'\')' ;      
                }
            }else{
                strWherClause=' ,company__r.name, createdBy.name from NDA__c WHERE createdByID = \'' 
                            + loggedInUserID +'\'' ;
            }
        }           
                
        lstNDA = new list<NDA__c>();
        lstNDA = Database.query(NDA_HelperDatabase.fnAllColumnsByCustomQuery('NDA__c', strWherClause));     
        return null;
    }
}