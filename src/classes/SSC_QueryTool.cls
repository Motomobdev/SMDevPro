/*
* Created by: Kalyan Chakravarthy
* Creation date: 25-Jan-2014
* Test Class: SSC_QueryTool_Test
* Description: Display scores
*
* Change history:
* Changed on:04-Nov-2014
* Changed by:Sivani Mallampalli
* Description:To remove profile restriction for querying Account Line Num:126
*/
Public with sharing class SSC_QueryTool{
    Public boolean cmdvisibile =true;
    Public boolean generate{get;set;}
    Public List<SelectOption> tempOpti= new List<SelectOption> ();
    List<SelectOption> tempOptions1 = new List<SelectOption>();
    Public String URLToRedirect;
    Public String OracleId;
    List<Account> SupplierList {get;set;}
    Public Integer MonthFlag =1;
    Public boolean ScorecardTypeDisabled{get;set;}
    Public boolean VisibleError{get;set;}
    Public boolean visibility{get;set;}
    Public boolean status{get;set;}
    Public String SocrecardHorizon{get;set;}
    Public boolean display{get;set;}
    Public String months{get;set;}
    Public String years{get;set;}
    Public String SelectedValueDate{get;set;}
    Public String amount {get;set;}
    Public Boolean DisabledStatus{get;set;}
    Integer key=1;
    Public Map<String,String> MonthNamesReverse = new Map<String,String>{'1'=>'January','2'=>'February','3'=>'March','4'=>'April','5'=>'May','6'=>'June','7'=>'July','8'=>'August','9'=>'September','10'=>'October','11'=>'November','12'=>'December'};
    Public Map<String,String> MonthNames = new Map<String,String>{'January'=>'1','February'=>'2','March'=>'3','April'=>'4','May'=>'5','June'=>'6','July'=>'7','August'=>'8','September'=>'9','October'=>'10','November'=>'11','December'=>'12'};
    Public String SelectedValue;
    Public String DisplayDate;
    Public List<DateTime> datesdisplayed = new List<DateTime>();
    Public List<SelectOption> temp = new List<SelectOption>();
    Public string error{get;set;}
    Public List<selectOption> ScorecardType= new List<selectOption> ();
    Private List<SSC_Metric__c > Metric = new List<SSC_Metric__c >();
    Private List<SSC_SubMetric__c > SubMetric = new List<SSC_SubMetric__c >();
    Private List<Account> Supplier = new List<Account>();
    Private List<SSC_ScoringGuide__c> ScoreCard = new List<SSC_ScoringGuide__c>();
    Private List<SSC_PriorQuarterScore__c> GenerationDates= new List<SSC_PriorQuarterScore__c>();
    Private List<SSC_CurrentQuarterScore__c> CurrentGenerationDate= new List<SSC_CurrentQuarterScore__c>();
    Private AggregateResult[] Month;// = new List<aggregateResult>();
    Private AggregateResult[] year;
    Public AggregateResult[] GDates;
    Public AggregateResult[] GDHours;
    Private Map<String,String> mapReportNameToURL = new Map<String,String>();
    Private Map<String,String> mapReportToFieldID = new Map<String,String>();
    Public Integer count;
    Public string monthname{get;set;}
    Public string yearname {get;set;}
    Public List<SelectOption> TempFieldvaluelist {get;set;}
    Public List<SelectOption> FormValueslist {get;set;}
    Public String ReportName {get;set;}
    Public String ReportName1 {get;set;}
    Public List<inputFieldClass> SupplierSelection {get;set;}
    Public List<inputFieldClass> HorizonSelection {get;set;}
    Public List<inputFieldClass> DateSelection {get;set;}
    Public class InputFieldClass {
        Public SelectOption SelectedValue{get;set;}
        Public List<selectOption> ScorecardType{get;set;}
        Public String fieldName {get;set;}
        Public boolean renderFlag {get;set;}
        Public String fieldValue {get;set;}
        Public List<String> FieldValues {get;set;}
        Public List<SelectOption> fieldValueList {get;set;}
        Public List<SelectOption> TempFieldvaluelist {get;set;}
        Public List<SelectOption> FormValueslist {get;set;}
        Public String FieldType {get;set;}
        Public inputFieldClass(String inputFieldName,boolean inputRenderFlag , String inputFieldValue,List<SelectOption> inputFieldValueList, String InputFieldType ){
            this.fieldName = inputFieldName ;
            this.renderFlag = inputRenderFlag ;
            this.fieldValue = inputFieldValue ;
            this.fieldValueList = new List<SelectOption>();
            this.TempFieldvaluelist = new List<SelectOption>();
            this.FormValueslist = new List<SelectOption>();
            if (inputFieldValueList != null) {
                for (Selectoption tempSelectOption : inputFieldValueList){
                    fieldValueList.add(new SelectOption(tempSelectOption.getValue(),tempSelectOption.getValue()));
                }
                if (InputFieldType == 'Radio') {
                    fieldValueList.add(new SelectOption('None','None'));
                }
                for (Selectoption tempSelectOption : inputFieldValueList){
                    TempFieldvaluelist.add(new SelectOption(tempSelectOption.getValue(),tempSelectOption.getValue()));
                }
                if (InputFieldType == 'PickList2') {
                    fieldValueList.add(new SelectOption('None','None'));
                }
                for (Selectoption tempSelectOption : inputFieldValueList){
                    FormValueslist.add(new SelectOption(tempSelectOption.getValue(),tempSelectOption.getValue()));
                }
            }
            this.FieldType = InputFieldType;
        }
    }
    Public SSC_QueryTool(){
        try {
            ScorecardTypeDisabled=true;
            generate=true;
            status=true;
            DisabledStatus= true;
            ScorecardType.add(new SelectOption('None','None'));
            ScorecardType.add(new SelectOption('Current','Current'));
            ScorecardType.add(new SelectOption('History','History'));
            mapReportNameToURL.put('DM Scorecard','/apex/SSC_DM_ScoreCard');
            mapReportNameToURL.put('DM Scorecard Type History','/apex/SSC_DMScoreCard_History');
            mapReportNameToURL.put('Reverse Scorecard','/apex/SSC_ScoringGuides');
            mapReportToFieldID.put('07290000000HEuS','Supplier ID');
            mapReportToFieldID.put('07290000000HEuT','Quarter');
            mapReportToFieldID.put('07290000000HEug','Year');
            mapReportToFieldID.put('07290000000HEuh','Scorecard Type');
           // Id id1 = UserInfo.getProfileId();
            //List<Profile> PROFILE = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            //String MyProflieName = PROFILE[0].Name;
            String userName = UserInfo.getUserName();
            User activeUser = [Select Email From User where Username = : userName limit 1];
            string email = activeUser.Email;
            this.SupplierSelection = new List<inputFieldClass>();
            this.HorizonSelection = new List<inputFieldClass>();
            this.DateSelection = new List<inputFieldClass>();
         //commented to remove profile restriction for scorecard
          //  if(PROFILE[0].Name == 'System Administrator'  || PROFILE[0].Name == 'MD - Procurement Lite User'|| PROFILE[0].Name == 'Scorecard Partner User' || PROFILE[0].Name == 'MD - Procurement'){
                this.Supplier = [Select Name,Oracle_Customer_Number__c  from Account  where SSC_Scorecard_Required__c = true order by Name LIMIT 1000];
            
           // }
           // else{
                //this.Supplier = [Select Name,Oracle_Customer_Number__c  from Account where SSC_User__c=:email order by Name LIMIT 1000];
            //}
            this.Month=[Select Month__c from SSC_PriorQuarterScore__c Group by Month__c  ];
            this.GDates=[select day_only(GenerationDate__c) from SSC_PriorQuarterScore__c where Month__c = :SelectedValueDate Group by day_only(GenerationDate__c) LIMIT 1000];
            this.year =[Select Year__c from SSC_PriorQuarterScore__c  Group by Year__c];
            this.ScoreCard =[Select Name from SSC_ScoringGuide__c ];
            List<SelectOption> tempOptions = new List<SelectOption>();
            tempOptions.add(new SelectOption('--NONE--','--NONE--'));
            for (Account tempItem : Supplier ){
                if (tempItem.Name != NULL) {
                    tempOptions.add(new SelectOption(tempItem.Name,tempItem.Name));
                }
            }
            SupplierSelection.add(new inputFieldClass('Supplier Name',true,'',tempOptions,'PickList1'));
            system.debug(tempOptions);
            tempOptions.clear();
            HorizonSelection.add(new inputFieldClass('ScoreCard Type',true,'',ScorecardType,'PickList1'));
            tempOptions.add(new SelectOption('--None--','--None--'));
            for (Account tempItem : Supplier ){
                if (tempItem.Name != NULL) {
                    tempOptions.add(new SelectOption(tempItem.Name,tempItem.Name));
                }
            }
            SupplierSelection.add(new inputFieldClass('Supplier ID',true,'',tempOptions,'PickList'));
            system.debug(tempOptions);
            tempOptions.clear();
            tempOptions.add(new SelectOption('--None--','--None--'));
            for (AggregateResult tempItem : Month){
                if (tempItem.get('Month__c') != NULL) {
                    tempOptions.add(new SelectOption((String)tempItem.get('Month__c'),(String)tempItem.get('Month__c')));
                }
            }
            HorizonSelection.add(new inputFieldClass('Month',true,'',tempOptions,'PickList'));
            system.debug(tempOptions);
            tempOptions.clear();
            tempOptions.add(new SelectOption('--None--','--None--'));
            for (AggregateResult tempItem : year ){
                if (tempItem.get('Year__c') != NULL) {
                    tempOptions.add(new SelectOption((String)tempItem.get('Year__c'),(String)tempItem.get('Year__c')));
                }
            }
            HorizonSelection.add(new inputFieldClass('Year',true,'',tempOptions,'PickList2'));
            system.debug(tempOptions);
            tempOptions.clear();
            for (AggregateResult tempItem : GDates ){
                if (tempItem.get('GenerationDate__c') != NULL) {
                    tempOptions.add(new SelectOption((String)tempItem.get('GenerationDate__c'),(String)tempItem.get('GenerationDate__c')));
                }
            }
            DateSelection.add(new inputFieldClass('Generation Date',true,'',tempOptions,'Radio'));
            system.debug(tempOptions);
            tempOptions.clear();
            system.debug(tempOptions);
            tempOptions.clear();
            this.GDates =[Select day_only(GenerationDate__c) from SSC_PriorQuarterScore__c where Month__c = :'February' Group by day_only(GenerationDate__c) LIMIT 1000];
            List<SelectOption> tempOpti = new List<SelectOption>();
            for (AggregateResult tempItem : GDates ){
                string TempString=string.valueof(tempItem );
                tempOpti.add(new SelectOption(TempString,TempString));
            }
            tempOptions.add(new SelectOption('None' ,'None'));
            tempOptions.add(new SelectOption('DM Scorecard' ,'DM Scorecard'));
            //tempOptions.add(new SelectOption('Reverse Scorecard','Reverse Scorecard'));
            SupplierSelection.add(new inputFieldClass('Scorecard Type',true,'',tempOptions,'Pick'));
            system.debug(tempOptions);
            tempOptions.clear();
        }
        catch (Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Unable to setup Wizard');
            ApexPages.addMessage(myMsg );
        }
    }
    Public List<SelectOption> getReports() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Current','Current'));
        options.add(new SelectOption('History' ,'History'));
        return options;
    }
    Public boolean getVisibleError(){
        return VisibleError;
    }
    Public boolean getVisibility(){
        return visibility;
    }
    Public boolean getScorecardTypeDisabled(){
        return ScorecardTypeDisabled;
    }
    Public PageReference save() {
        temp.clear();
        if(SocrecardHorizon=='Current'){
            gotoreport();
        }
        else{
            visibility=true;
            monthname = months;
            yearname=years;
            String textValue = null;
            this.GDates.clear();
            this.GenerationDates=[Select GenerationDate__c from SSC_PriorQuarterScore__c where Month__c = :monthname and Year__c =: yearname];
            Set<String> TempString = new Set<String>();
            for(SSC_PriorQuarterScore__c PriorObject : GenerationDates)
            TempString.add(String.valueof(PriorObject.GenerationDate__c ));
            for (String tempItem : TempString ){
                string SelectionValue=string.valueof(tempItem);
                temp.add(new SelectOption(SelectionValue,SelectionValue));
            }
        }
        PageReference PageRef = new PageReference ('/apex/SSC_QueryTool');
        return PageRef ;
    }
    Public List<SelectOption> getTempOpti(){
        return temp;
    }
    Public void PopulateValues(){
        MonthFlag =1;
        if(SocrecardHorizon=='Current'){
            if(months==null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select Month and Year');
                ApexPages.addMessage(myMsg );
        }}
        else{
            if(months=='--None--'){
            }
            else{
                status=false;
                visibility=true;
                monthname=months;
                cmdvisibile =false;
                key= Integer.valueof(Monthnames.get(months));
                key=key-1;
                if(key==0)
                key=12;
                String previous= MonthNamesReverse.get(string.valueof(key));
                List<SSC_PriorQuarterScore__c> priorlist = new List<SSC_PriorQuarterScore__c>();
                priorlist=[Select Month__c from SSC_PriorQuarterScore__c];
                Set <String> months1 = new Set<String>();
                for (SSC_PriorQuarterScore__c t : priorlist) {
                    months1.add(t.Month__c);
                }
                Integer size= months1.size();
                size=size-1;
                for(string s : months1){
                    if(previous==s){
                        MonthFlag =0;
                    }
                }
                if(MonthFlag ==1){
                    error='ScoreCard for the SelectedValue month cannot be generated as previous quarter details not available';
                    display=true;
                    generate=true;
                    status=true;
                    Visibility=false;
                }
                else{
                    display=false;
        } }}
    }
    Public void DisplaySupplier1(){
        for (inputFieldClass tempLoopVar : SupplierSelection){
            String  sFieldID=tempLoopVar.fieldName ;
            if(sFieldID=='Supplier Name'){
                SupplierList = [Select Name,Oracle_Customer_Number__c from Account where Account.Name=:tempLoopVar.FieldValue AND SSC_Scorecard_Required__c = true];
            }
        }
        for (Account tempItem : SupplierList ){
            if (tempItem.Name != NULL) {
                tempOptions1.clear();
                tempOptions1.add(new SelectOption(tempItem.Oracle_Customer_Number__c ,tempItem.Oracle_Customer_Number__c ));
            }
        }
    }
    Public List<SelectOption> gettempOptions1(){
        return tempOptions1;
    }
    Public void DisplaySupplier(){
        string temp;
        Integer i =1;
        string SelectedValuesupplier;
        List<SSC_PriorQuarterScore__c> scoresupplier = new List<SSC_PriorQuarterScore__c>();
        Set<String> names= new set<string>() ;
        for (inputFieldClass tempLoopVar : SupplierSelection){
            String  sFieldID=tempLoopVar.fieldName ;
            if(sFieldID=='Supplier ID'){
                SupplierList = [Select Name from Account where Name=:tempLoopVar.FieldValue ];
                SelectedValuesupplier=tempLoopVar.FieldValue ;
            }
        }
        scoresupplier =[select Account__r.Name from SSC_PriorQuarterScore__c];
        for(SSC_PriorQuarterScore__c p : scoresupplier){
            String s = string.valueof(p.Account__r.Name);
            names.add(s);
        }
        for(string s1 : names){
            if(SelectedValuesupplier==s1){
                i=0;
            }
        }
        if(i==1) {
            error='Scores are not generated for this Supplier !! Please choose different Supplier !!';
            display=true;
            generate=true;
        }
        else  {
            display=false;
        }
    }
    Public string geterror(){
        return error;
    }
    Public List<Account> getSupplierList(){
        return SupplierList;
    }
    Public void save2()
    {
        if(ReportName=='None'){
            ScorecardTypeDisabled=true;
            generate=true;
        }
        else{
            ScorecardTypeDisabled=false;
        }
    }
    Public void changeBool() {
        if(SocrecardHorizon == 'Current'){
            VisibleError=false;
            status=true;
            generate=false;
            DisabledStatus= true;
            monthname=null;
            SocrecardHorizon='Current' ;
        }
        else {
            generate=true;
            DisabledStatus= false;
            VisibleError=true;
        }
    }
    Public void changeBool3(){
        generate=false;
    }
    Public boolean getdisplay(){
        return display;
    }
    Public PageReference goToReport(){
        PageReference pageRef ;
        try{
            Set<String> DateSet= new Set<String>();
            Set<String> monthSet= new Set<String>();
            Set<String> yearSet= new Set<String>();
            String Currentmonth;
            String Currentyear;
            String Currentdate;
            string SelectedValueCurrentDate;
            string SelectedValueCurrentMonth;
            string SelectedValueCurrentYear;
            this.CurrentGenerationDate=[Select GenerationDate__c,Month__c,year__c from SSC_CurrentQuarterScore__c];
            for(SSC_CurrentQuarterScore__c t : CurrentGenerationDate){
                DateSet.add(String.valueof(t.GenerationDate__c ));
                monthSet.add(String.valueof(t.Month__c));
                yearSet.add(String.valueof(t.year__c ));
            }
            for (String tempItem : DateSet){
                SelectedValueCurrentDate=string.valueof(tempItem );
            }
            for (String tempItem : monthSet){
                SelectedValueCurrentMonth=string.valueof(tempItem );
            }
            for (String tempItem : yearSet){
                SelectedValueCurrentYear=string.valueof(tempItem );
            }
            String sFieldId;
            if(ReportName=='None')
            ReportName='DM Scorecard';
            URLToRedirect = mapReportNameToURL.get(ReportName);
            for (inputFieldClass tempLoopVar : HorizonSelection){
                sFieldID=tempLoopVar.fieldName ;
                if(sFieldID=='ScoreCard Type'){
                    if(SocrecardHorizon =='History'){
                        URLToRedirect=mapReportNameToURL.get('DM Scorecard Type History');
                    }
                }
            }
            URLToRedirect =URLToRedirect +'?';
            for (inputFieldClass tempLoopVar : DateSelection){
                sFieldID=tempLoopVar.fieldName ;
                if(sFieldID=='Generation Date'){
                    if(monthname ==null){
                        system.debug('Value of Field Values :' + tempLoopVar.FieldValues);
                        URLToRedirect = URLToRedirect + sFieldId + '=' +SelectedValueCurrentDate+ '&';
                    }
                    else {
                        system.debug('Value of Field Values :' + tempLoopVar.FieldValues);
                        URLToRedirect = URLToRedirect + sFieldId + '=' +monthname + '&';
                    }
                }
                URLToRedirect = URLToRedirect.substring(0,URLToRedirect.length()-1) + '&';
            }
            for (inputFieldClass tempLoopVar : SupplierSelection){
                sFieldID=tempLoopVar.fieldName ;
                if(sFieldID=='Supplier ID'){
                }
                if (tempLoopVar.FieldType == 'PickList'){
                    system.debug('Value of Field Values :' + tempLoopVar.FieldValues);
                    URLToRedirect = URLToRedirect + sFieldId + '=' + tempLoopVar.FieldValue + '&';
                }
                URLToRedirect = URLToRedirect.substring(0,URLToRedirect.length()-1) + '&';
            }
              for (inputFieldClass tempLoopVar : SupplierSelection){
                sFieldID=tempLoopVar.fieldName ;
                if(sFieldID=='Supplier Name'){
                }
                if (tempLoopVar.FieldType == 'PickList1'){
                    system.debug('Value of Field Values :' + tempLoopVar.FieldValues);
                    if(tempLoopVar.FieldValue.contains('&'))
                    {
                      system.debug('in contais & b4 replace');
                      tempLoopVar.FieldValue=tempLoopVar.FieldValue.replace('&', '');
                      system.debug('after rplace' + tempLoopVar.FieldValue);

                    
                    }
                    URLToRedirect = URLToRedirect + sFieldId + '=' + tempLoopVar.FieldValue + '&';
                }
                URLToRedirect = URLToRedirect.substring(0,URLToRedirect.length()-1) + '&';
            }
            for (inputFieldClass tempLoopVar1 : HorizonSelection){
                sFieldID=tempLoopVar1.fieldName ;
                if (tempLoopVar1.FieldType == 'PickList'){
                    if(sFieldID=='Month'){
                        if(monthname ==null){
                            system.debug('Value of Field Values :' + tempLoopVar1.FieldValues);
                            URLToRedirect = URLToRedirect + sFieldId + '=' +SelectedValueCurrentMonth+ '&';
                        }
                        else{
                            system.debug('Value of Field Values :' + tempLoopVar1.FieldValues);
                            URLToRedirect = URLToRedirect + sFieldId + '=' + months + '&';
                        }
                    }
                    URLToRedirect = URLToRedirect.substring(0,URLToRedirect.length()-1) + '&';
                }
                if (tempLoopVar1.FieldType == 'PickList1'){
                    system.debug('Value of Field Values :' + tempLoopVar1.FieldValues);
                    URLToRedirect = URLToRedirect + sFieldId + '=' + SocrecardHorizon+ '&';
                }
                URLToRedirect = URLToRedirect.substring(0,URLToRedirect.length()-1) + '&';
                if (tempLoopVar1.FieldType == 'Pick'){
                    system.debug('Value of Field Values :' + tempLoopVar1.FieldValues);
                    URLToRedirect = URLToRedirect + sFieldId + '=' + ReportName+ '&';
                }
                URLToRedirect = URLToRedirect.substring(0,URLToRedirect.length()-1) + '&';
                if (tempLoopVar1.FieldType == 'PickList2'){
                    if(sFieldID=='Year'){
                        if(monthname ==null){
                            system.debug('Value of Field Values :' + tempLoopVar1.FieldValues);
                            URLToRedirect = URLToRedirect + sFieldId + '=' +SelectedValueCurrentYear+ '&';
                        }
                        else{
                            system.debug('Value of Field Values :' + tempLoopVar1.FieldValues);
                            URLToRedirect = URLToRedirect + sFieldId + '=' + years+ '&';
                        }
                    }
                    URLToRedirect = URLToRedirect.substring(0,URLToRedirect.length()-1) + '&';
                }
            }
            pageRef = new PageReference(URLToRedirect);
        }
        catch(Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Unable to setup Wizard');
        ApexPages.addMessage(myMsg );  }
        return pageRef ;
    }
}