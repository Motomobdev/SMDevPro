/*
* Created by: Kalyan Chakravarthy
* Creation date: 18-Jan-2014
* Description: SSC_QueryTool Test class
*
* Change history:
* Changed on:
* Changed by:
* Description:
*/
@isTest
public class SSC_QueryTool_Test{
    static testMethod void goToReport() {
        SSC_QueryTool TemporaryObject = new SSC_QueryTool();
        //SSC_QueryTool.inputFieldClass b ;
        PageReference tem = TemporaryObject.goToReport();
        Set <String> DateSet= new Set <String>();
        Set <String> monthSet = new Set <String>();
        Set <String> yearSet= new Set <String>();
        List <SSC_QueryTool.inputFieldClass> HorizonSelection= new List <SSC_QueryTool.inputFieldClass>();
        List <SSC_QueryTool.inputFieldClass> SupplierSelection = new List <SSC_QueryTool.inputFieldClass>();
        List <SSC_QueryTool.inputFieldClass> DateSelection = new List <SSC_QueryTool.inputFieldClass>();
        String URLToRedirect ;
        // AggregateResult[] Month;
        Map <String,String> mapReportNameToURL= new Map <String,String>{
            'DM Score Card'=>'apex/SSC_DM_ScoreCard'
        }
        ;
        //mapReportNameToURL.put('DM Score Card','/apex/SSC_DM_ScoreCard');
        string monthname='February';
        ID id;
        string months='February';
        string years='2014';
        String Currentmonth='February';
        String Currentyear='2014';
        String Currentdate='2014-01-17 09:05:00AM';
        string SocrecardHorizon ='Current' ;
        string SelectedCurrentDate ='2014-01-17 09:05:00AM';
        string SelectedCurrentMonth='February';
        string SelectedCurrentYear='2014';
        List <SSC_CurrentQuarterScore__c> CurrentGenerationDate= new List <SSC_CurrentQuarterScore__c>();
        //CurrentGenerationDate.add('2014-01-17 09:05:00AM','February',2014);
        List <SelectOption> tempOptions = New List <SelectOption>();
        Account a = new account();
        a.name='Test Account';
        insert a;
        List <Account> account = new List <Account>();
        account=[ select ID from Account where name = 'Test Account'];
        SSC_ScoringGuide__c TempObject = new SSC_ScoringGuide__c();
        TempObject.Name='DM Score Card';
        insert TempObject;
        List <SSC_ScoringGuide__c> scoringguide= new List <SSC_ScoringGuide__c>();
        scoringguide=[Select ID,Name from SSC_ScoringGuide__c ];
        SSC_Metric__c Temporaryvalue = new SSC_Metric__c();
        Temporaryvalue.Name='Cost';
        Temporaryvalue.SSC_ScoringGuide__c=scoringguide[0].ID;
        insert Temporaryvalue;
        List <SSC_Metric__c> metric = new List <SSC_Metric__c>();
        metric=[Select ID from SSC_Metric__c where Name='Cost'];
        SSC_SubMetric__c TempMetrics = new SSC_SubMetric__c();
        TempMetrics.Metric_Name__c = metric[0].ID;
        TempMetrics.Name='Cost Competitiveness';
        insert TempMetrics;
        List <SSC_SubMetric__c> temp5 = new List <SSC_SubMetric__c>();
        temp5=[Select ID from SSC_SubMetric__c where Name='Cost Competitiveness'];
        SSC_CurrentQuarterScore__c temp = new SSC_CurrentQuarterScore__c();
        temp.GenerationDate__c =DateTime.valueof('2014-01-17 09:05:00AM');
        temp.Account__c = account[0].ID;
        temp.SubMetric_Name__c = temp5[0].ID;
        temp.Month__c='February';
        temp.year__c='2014';
        insert temp;
        //Map<String,String> MonthNames = new Map<String,String>{'January'=>'1','February'=>'2','March'=>'3','April'=>'4','May'=>'5','June'=>'6','July'=>'7','August'=>'8','September'=>'9','October'=>'10','November'=>'11','December'=>'12'};
        CurrentGenerationDate=[Select GenerationDate__c,Month__c,year__c from SSC_CurrentQuarterScore__c];
        for(SSC_CurrentQuarterScore__c t : CurrentGenerationDate)
        {
            DateSet.add(String.valueof(t.GenerationDate__c ));
            monthSet.add(String.valueof(t.Month__c));
            yearSet.add(String.valueof(t.year__c ));
        }
        for (String tempItem : DateSet){
            SelectedCurrentDate=string.valueof(tempItem );
        }
        for (String tempItem : monthSet){
            SelectedCurrentMonth=string.valueof(tempItem );
        }
        for (String tempItem : yearSet){
            SelectedCurrentYear=string.valueof(tempItem );
        }
        String sFieldId;
        String ReportName;
        if(ReportName==Null)
        ReportName='DM Score Card';
        AggregateResult[] Month;
        tempOptions.clear();
        tempOptions.add(new SelectOption('Test Account','TestAccount'));
        SupplierSelection.add(new SSC_QueryTool.inputFieldClass('SupplierName',true,'',tempOptions,'PickList'));
        tempOptions.clear();
        tempOptions.add(new SelectOption('February','February'));
        HorizonSelection.add(new SSC_QueryTool.inputFieldClass('Month',true,'',tempOptions,'PickList'));
        tempOptions.clear();
        tempOptions.add(new SelectOption('2014','2014'));
        HorizonSelection.add(new SSC_QueryTool.inputFieldClass('Year',true,'',tempOptions,'PickList2'));
        tempOptions.clear();
        HorizonSelection.add(new SSC_QueryTool.inputFieldClass('ScoreCard Type',true,'',tempOptions,'PickList1'));
        tempOptions.add(new SelectOption('Current','Current'));
        tempOptions.clear();
        tempOptions.add(new SelectOption(String.valueof(CurrentGenerationDate),string.valueof(CurrentGenerationDate)));
        DateSelection.add(new SSC_QueryTool.inputFieldClass('Generation Date',true,'',tempOptions,'Radio'));
        TemporaryObject.goToReport();
        TemporaryObject.getTempOpti();
        TemporaryObject.save();
        TemporaryObject.gettempOptions1();
        TemporaryObject.DisplaySupplier1();
        TemporaryObject.DisplaySupplier();
        TemporaryObject.geterror();
        TemporaryObject.getSupplierList();
        TemporaryObject.save2();
        TemporaryObject.changeBool();
        TemporaryObject.changeBool3();
        TemporaryObject.getdisplay();
        TemporaryObject.getScorecardTypeDisabled();
        TemporaryObject.getVisibility();
        TemporaryObject.getVisibleError();
        SocrecardHorizon ='Current';
        //months='February';
        SocrecardHorizon='History';
        months='December';
        Map<String,String> Monthnames = new Map<String,String>{'January'=>'1','February'=>'2','March'=>'3','April'=>'4','May'=>'5','June'=>'6','July'=>'7','August'=>'8','September'=>'9','October'=>'10','November'=>'11','December'=>'12'};
        //TemporaryObject.PopulateValues();
        //String t1=String.valueOf('Qtr__c');
        List<Profile> PROFILE = new List<Profile>();
        Profile name = new profile();
        name.name='Temp';
        PROFILE.add(name);
        //PROFILE[0].Name='Temp';
        SSC_QueryTool TemporaryObject1 = new SSC_QueryTool();
    }
    static testMethod void getreports(){
        SSC_QueryTool TempQueryTool= new SSC_QueryTool();
        List <SelectOption> options = new List <SelectOption>();
        options.add(new SelectOption('History' ,'History'));
        options.add(new SelectOption('Current','Current'));
        List <SelectOption> TmepList= TempQueryTool.getReports();
        //TempQueryTool.MonthFlag=1;
        TempQueryTool.SocrecardHorizon='Current';
        TempQueryTool.changeBool();
        TempQueryTool.months='';
        TempQueryTool.PopulateValues();
        TempQueryTool.SocrecardHorizon='Previous';
        TempQueryTool.months='--None--';
        TempQueryTool.PopulateValues();
        TempQueryTool.SocrecardHorizon='Previous';
        TempQueryTool.months='October';
        TempQueryTool.PopulateValues();
        TempQueryTool.save();
    }
}