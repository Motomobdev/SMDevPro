public class NDA_SummaryCtr {
/*
* Created by: Swetha Mandava
* Creation date: 11-Nov-2013
* Test Class: NDA_CreateCtrTest
* Description: This class is used as a Controller for VF page NDA_Summary. This class will be for showing page messages as appropriate.
*
* Change history:
* Changed on:
* Changed by:
* Description:
*/
    
    public NDA__c objNDA {get; set;}
    public string strMessage {get; set;}
    public string strNDAFileID {get; set;}

    public NDA_SummaryCtr(ApexPages.StandardController controller) {     
        objNDA = (NDA__c) controller.getRecord();
        String strID = objNDA.Id;
        if(strID != null && strID != ''){
            String strWherClause;
            strWherClause=' ,company__r.name, vp_Name__r.vp_Name__c from NDA__c WHERE ID = \'' + objNDA.id +'\'' ;
            objNDA = Database.query(NDA_HelperDatabase.fnAllColumnsByCustomQuery('NDA__c', strWherClause));
       }
    }
    
      public Pagereference fnAction(){
        Pagereference pageRef = null;
        strMessage = ApexPages.currentPage().getParameters().get('pv03');         
        strNDAFileID = ApexPages.currentPage().getParameters().get('pv02'); 
        
        if (strMessage == 'signatures') {
            strMessage = 'Your NDA is pending signature. You can check the status of your NDAs by selecting View and Modify my NDAs. Close your browser if you are done, or select I need an NDA if you need another one'; 
        } else if (strMessage == 'modification') {
            strMessage = 'NDA modification request is submitted successfully. You can check the status of your NDAs by selecting View and Modify my NDAs.';
        } else if (strMessage == 'update') {
            strMessage = 'NDA update is completed successfully. You can check the status of your NDAs by selecting View and Modify my NDAs.';
        } else if (strMessage == 'create') {
            strMessage = 'NDA is created successfully. You can check the status of your NDAs by selecting View and Modify my NDAs.';
        } else if (strMessage == 'amendment') {
            strMessage = 'NDA amendment request is submitted successfully. You can check the status of your NDAs by selecting View and Modify my NDAs.';
        }
        
        if(strNDAFileID != null && strNDAFileID != ''){  
                objNDA = Database.query(NDA_HelperDatabase.fnAllColumnsById('NDA__c', strNDAFileID));
                objNDA.NDAFileID__c = objNDA.NDAFileID__c;
                return pageRef;
            }
        return null;
      }
}