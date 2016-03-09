public class NDA_AddAdditionalIndividualsCtr {
/*
* Created by: BigKite Consulting
* Creation date: 17-Oct-2013
* Test Class: NDA_AddAdditionalIndividualsCtrTest
* Description: This class is used as a Controller for NDA_AdditionalIndividuals component. This will add NDA notifier for a NDA on NDA_create page.
*
* Change history:
* Changed on:
* Changed by:
* Description:
*/ 
    public String strNdaId {get; set;}
    public Integer intNoofRecords{get; set;}   
    public Integer intSize{get; set;}  
    public String strlastName {get; set;}  
    public ApexPages.StandardSetController MotorolaCoreDircRecords { get; set; }
    public List<wrapperClass> wrapClassList;
    // the variable being set from the commandlink
    public String strRemoveID {get; set;}
    //We create a new list of MCD that would be populated only if MCD is selected
    public List<Motorola_Core_Directory__c> lstselectedMotoCoreDir {get; set;}
    public list<NDA_Notifier__c>  lstNdaNotifier {get; set;}
    /**
        Method: fnSeacrh
        Description: Used to search MCD with user entered input criterias. 
                     Invoked when user clicks Seacrh Button from VF Page.
    **/
    public PageReference fnSeacrh()  {
        intSize = 10;       
        String eventQuery=null;
        List<String> eventFields=new List<String>();
        eventFields.addAll(Motorola_Core_Directory__c.getSObjectType().getDescribe().fields.getMap().keyset());
        eventQuery='select '+eventFields.get(0);
        for(integer i=1;i<eventFields.size();i++){
            eventQuery+=','+eventFields.get(i);
        }
        eventQuery+=' from Motorola_Core_Directory__c WHERE DirectoryStatus__c=\'A\' and SurName__c = \'' + strlastName +'\'';   
        // -- Ends              
        MotorolaCoreDircRecords = new ApexPages.StandardSetController(Database.getQueryLocator(eventQuery));
        MotorolaCoreDircRecords.setPageSize(intSize);      
        intNoofRecords = MotorolaCoreDircRecords.getResultSize();    
        
       /* wrapClassList = new list<wrapperClass>();
        for(Motorola_Core_Directory__c mcdObj : (List<Motorola_Core_Directory__c>)MotorolaCoreDircRecords.getRecords()){
            wrapClassList.add(new wrapperClass(mcdObj));
        }
        */
            fnCallRecords();
                   
        return null;
    }
    
    public void fnCallRecords(){
        wrapClassList = new list<wrapperClass>();
        for(Motorola_Core_Directory__c mcdObj : (List<Motorola_Core_Directory__c>)MotorolaCoreDircRecords.getRecords()){
            wrapClassList.add(new wrapperClass(mcdObj));
        }
    }
     
    // Populates the list of searched NDA records   
    public List<wrapperClass> getwrapClassList() {    
        List<wrapperClass> lstRecords = new List<wrapperClass>();
        if(MotorolaCoreDircRecords != null){
            for(Motorola_Core_Directory__c obj : (List<Motorola_Core_Directory__c>)MotorolaCoreDircRecords.getRecords())
                lstRecords.add(new wrapperClass(obj));
            }
           
        return wrapClassList ;
    }
    
         
    public PageReference fnAdd(){ 
        Boolean boolCheck = false;  
        
        lstselectedMotoCoreDir = new List<Motorola_Core_Directory__c>();
        //We will cycle through our list of wrapper class and will check to see if the selected property is set to true, 
        //if it is we add the Motorola_Core_Directory__c to the selectedOppr list
        for(wrapperClass wrapC: getwrapClassList()) {
            if(wrapC.boolSelected == true) {
                boolCheck = true;
                lstselectedMotoCoreDir.add(wrapC.objMCD);               
            }
        }       
        if(!boolCheck){         
            ApexPages.addMessage(new ApexPages.Message(
            ApexPages.severity.ERROR, 'Please select at least one record '));
            return null;
        }else{
            fnAddtoIndividualList();
        }           
        return null;            
    }
        
     public PageReference Refresh(){
        wrapClassList=null; // we need this line if we performed a write operation  because wrapClassList gets a fresh list now
        MotorolaCoreDircRecords = null;
        return null;
     }
     
     public PageReference fnAddtoIndividualList(){
        list<NDA_Notifier__c>  lstNdaNotifier = new list<NDA_Notifier__c> ();
        if(lstselectedMotoCoreDir != null){
            list<NDA_Notifier__c> NdaNotifierlst = [select id, name,NDA__c,Notifier__c from NDA_Notifier__c where NDA__c =: strNdaId AND Notifier__c IN: lstselectedMotoCoreDir];
            set<id> setNotifier = new set<id>();
            for(NDA_Notifier__c obj:NdaNotifierlst){
                setNotifier.add(obj.Notifier__c);
            }
            
            NDA_Notifier__c objNdsNotifier;         
            for(Motorola_Core_Directory__c objNCD : lstselectedMotoCoreDir){
                if(setNotifier.contains(objNCD.id)){
                    // TO nothing
                }else{
                    objNdsNotifier = new NDA_Notifier__c();
                    objNdsNotifier.NDA__c = strNdaId;
                    objNdsNotifier.Notifier__c = objNCD.id;
                    lstNdaNotifier.add(objNdsNotifier);
                }
            }
            if(lstNdaNotifier != null){
                insert lstNdaNotifier;
                Refresh();
                ApexPages.addMessage(new ApexPages.Message(
                ApexPages.severity.INFO, 'Individuals have been added'));
                fnShowIndividualList();
                return null;
            }
        }       
        return null;
     }
      
     public list<NDA_Notifier__c> fnShowIndividualList(){
    
        lstNdaNotifier = new list<NDA_Notifier__c> ();
        lstNdaNotifier = NDA_HelperDatabase.fnShowIndividualList(strNdaId);                 
        return lstNdaNotifier;
     } 
     
     // handle the action of the commandlink
     public PageReference fnRemoveItem() {
        if(strRemoveID != ''){
            NDA_Notifier__c objNdaNotifier = [select id, name,NDA__c,Notifier__c, Notifier__r.DisplayFirstName__c, Notifier__r.DisplayLastName__c, Notifier__r.FriendlyEmailAddress__c from NDA_Notifier__c where id =: strRemoveID limit 1];
            if(objNdaNotifier != null){
                delete objNdaNotifier;
                fnShowIndividualList();
            }
        }
        return null;
     }    
      /*****************                Pagination Methods              *****************/
    // indicates whether there are more records after the current page set.
    public Boolean hasNext {
        get {
            return MotorolaCoreDircRecords.getHasNext();
        }
        set;
    }
 
    // indicates whether there are more records before the current page set.
    public Boolean hasPrevious {
        get {
            return MotorolaCoreDircRecords.getHasPrevious();
        }
        set;
    }
    // returns the previous page of records
    public void previous() {
        MotorolaCoreDircRecords.previous();
        fnCallRecords();
    } 
    // returns the next page of records
    public void next() {
        MotorolaCoreDircRecords.next();
        fnCallRecords();
    }   
    public void first() {        
            MotorolaCoreDircRecords.first();    
    }
    public void last() {        
        MotorolaCoreDircRecords.last();    
    } 
    public Integer pageNumber {        
        get {            
            return MotorolaCoreDircRecords.getPageNumber();        
        }        
        set;    
    }
    /*****************          Wrapper Class            *****************/
    public class wrapperClass {
        public Motorola_Core_Directory__c objMCD {get; set;}    
        public Boolean boolSelected {get; set;}       
        public wrapperClass(Motorola_Core_Directory__c mcd) {
            objMCD = mcd;           
        }
    }
}