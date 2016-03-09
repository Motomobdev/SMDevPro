/*
     * Created by: Kalyan Chakravarthy
     * Creation date: 22-Jan-2014
     
     * Description: SSC_DirectMaterialScoreCard Test class 
     *
     * Change history:
     * Changed on:
     * Changed by:
     * Description:
     */

@isTest
public class SSC_DirectMaterialScoreCardTest{
  

   /* static testMethod void getValue2(){
        String supplierName ='0000000';
        String Month='February';
        String Year='2014';
        string Dates ='2014-01-17 09:05:00AM';
        String ScoreCard_Type ='Current';
        ApexPages.currentPage().getParameters().put('Generation Date',Dates);
        SSC_DirectMaterialScoreCard Temp= new SSC_DirectMaterialScoreCard();
        Temp.getValue2();
    }*/
    static testMethod void sendPdf(){
    string email;
        List  <SSC_GdriveFileID__c > FileIds= new List  <SSC_GdriveFileID__c >();
        contact a = new contact();
        a.email ='abc@gmail.com';
        SSC_GdriveFileID__c gdrive = new SSC_GdriveFileID__c();
        gdrive.Name ='0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnc';
        gdrive.File_ID__c='0AiHwFohvc_vqdEhjb1RNZ0k';
        gdrive.Generation_Date__c=DateTime.valueof('2014-01-17 09:05:00AM');
        insert gdrive;
        
        SSC_GdriveFileID__c gdrive1 = new SSC_GdriveFileID__c();
        gdrive1.Name ='0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnc';
        gdrive1.File_ID__c='0AiHwFohvc_vqdEhjb1RNZ0k';
        gdrive1.Generation_Date__c=DateTime.valueof('2014-01-17 09:05:00AM');
        insert gdrive1;
        
        SSC_GdriveFileID__c gdrive2 = new SSC_GdriveFileID__c();
        gdrive2.Name ='0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnc';
        gdrive2.File_ID__c='0AiHwFohvc_vqdEhjb1RNZ0k';
        gdrive2.Generation_Date__c=DateTime.valueof('2014-01-17 09:05:00AM');
        insert gdrive2;
        
        FileIds =[Select Name ,File_ID__c,Generation_Date__c from SSC_GdriveFileID__c ];
        //system.assertequals(null,FileIds);
        string url ='https://docs.google.com/a/motorola.com/spreadsheet/ccc?key=';
        FileIds[0].File_ID__c='0AiHwFohvc_vqdEhjb1RNZ0k';
        url=url+FileIds[0].File_ID__c +'&usp=drive_web#gid=0';
        PageReference Redirect= new PageReference(url);
        Account accountsinsert = new account();
        accountsinsert.name='0000000';
        accountsinsert.Oracle_Customer_Number__c ='1234567';
        insert accountsinsert ;
        SSC_ScoringGuide__c scoringguideinsert = new SSC_ScoringGuide__c();
        scoringguideinsert.Name='DM Score Card';
        scoringguideinsert.Min__c=0;
        scoringguideinsert.Max__c=50;
        scoringguideinsert.Scoring_Guide__c='VS';
        scoringguideinsert.ColorGrade__c='blue';
        insert scoringguideinsert ;
        
         SSC_ScoringGuide__c scoringguideinsert1 = new SSC_ScoringGuide__c();
        scoringguideinsert1.Name='DM Score Card';
        scoringguideinsert1.Min__c=0;
        scoringguideinsert1.Max__c=50;
        scoringguideinsert1.Scoring_Guide__c='BE';
        insert scoringguideinsert1 ;
        
           SSC_ScoringGuide__c scoringguideinsert2 = new SSC_ScoringGuide__c();
        scoringguideinsert2.Name='DM Score Card';
        scoringguideinsert2.Min__c=0;
        scoringguideinsert2.Max__c=50;
        scoringguideinsert2.Scoring_Guide__c='CS';
        insert scoringguideinsert2 ;
        
        List  <SSC_ScoringGuide__c > scoringguide= new List  <SSC_ScoringGuide__c >();
        scoringguide=[Select ID,Name from SSC_ScoringGuide__c ];
        SSC_Metric__c Metricinsert= new SSC_Metric__c();
        Metricinsert.Name='Innovation';
        Metricinsert.SSC_ScoringGuide__c=scoringguide[0].ID;
        Metricinsert.Target_Score__c=Double.valueof(25);
        insert Metricinsert;
        List  <SSC_Metric__c > metrics = new List  <SSC_Metric__c >();
        metrics=[Select ID from SSC_Metric__c ];
        SSC_SubMetric__c submetricinsert= new SSC_SubMetric__c();
        submetricinsert.Metric_Name__c = metrics[0].ID;
        submetricinsert.Name='Cost Competitiveness';
        submetricinsert.TargetScore__c=Double.valueof(5);
        submetricinsert.L3Indicator__c = 'Y';
        insert submetricinsert;
        submetricinsert.clear();
        submetricinsert.Metric_Name__c = metrics[0].ID;
        submetricinsert.Name='Cost Control';
        submetricinsert.TargetScore__c=Double.valueof(5);
        insert submetricinsert;
        List  <SSC_SubMetric__c > submetrics = new List  <SSC_SubMetric__c >();
        submetrics = [Select ID from SSC_SubMetric__c ];
        SSC_L3SubMetric__c l3submetricinsert = new SSC_L3SubMetric__c();
        l3submetricinsert.Name='SOI';
        l3submetricinsert.SSC_SubMetric__c=submetrics[0].ID;
        l3submetricinsert.Target_Score__c=Double.valueof(5);
        insert l3submetricinsert;
        List  <Account > Supplier = new List  <Account >();
        Supplier=[ select ID,Name from Account where name = '0000000'];
        List  <SSC_CurrentQuarterScore__c  > CurrentQtrScoreVS = new List  <SSC_CurrentQuarterScore__c  >();
        List  <SSC_CurrentQuarterScore__c  > CurrentQtrScoreBE = new List  <SSC_CurrentQuarterScore__c  >();
        List  <SSC_CurrentQuarterScore__c  > CurrentQtrScoreCS = new List  <SSC_CurrentQuarterScore__c  >();
        List  <SSC_SubMetric__c > temp5 = new List  <SSC_SubMetric__c >();
        temp5=[Select ID from SSC_SubMetric__c ];
        SSC_CurrentQuarterScore__c currentscoreinsert= new SSC_CurrentQuarterScore__c();
        SSC_PriorQuarterScore__c priorquarterinsert = new SSC_PriorQuarterScore__c();
        currentscoreinsert.GenerationDate__c =DateTime.valueof('2014-01-17 09:05:00AM');
        currentscoreinsert.Account__c = Supplier[0].ID;
        currentscoreinsert.SubMetric_Name__c = temp5[0].ID;
        currentscoreinsert.L3SubMetricName__c='SOI';
        currentscoreinsert.Month__c='February';
        currentscoreinsert.year__c='2014';
        currentscoreinsert.Score__c=Double.valueof(2);
        currentscoreinsert.Comments__c='temp';
        currentscoreinsert.VsCompetetorField__c='1.00';
        currentscoreinsert.ScoreOverrides__c='BE1';
        currentscoreinsert.Controlled_Shipping__c='CS1';
        insert currentscoreinsert;
        SSC_CurrentQuarterScore__c currentscoreinsert2= new SSC_CurrentQuarterScore__c();
         currentscoreinsert2.GenerationDate__c =DateTime.valueof('2014-01-17 09:05:00AM');
        currentscoreinsert2.Account__c = Supplier[0].ID;
        currentscoreinsert2.SubMetric_Name__c = temp5[0].ID;
        currentscoreinsert2.L3SubMetricName__c='SOI';
        currentscoreinsert2.Month__c='February';
        currentscoreinsert2.year__c='2014';
        currentscoreinsert2.Score__c=Double.valueof(2);
        currentscoreinsert2.Comments__c='temp';
        currentscoreinsert2.VsCompetetorField__c='1.00';
        currentscoreinsert2.ScoreOverrides__c='BE1';
        currentscoreinsert2.Controlled_Shipping__c='CS1';
        insert currentscoreinsert2;
        
        
        priorquarterinsert.GenerationDate__c =DateTime.valueof('2014-01-17 09:05:00AM');
        priorquarterinsert.Account__c = Supplier[0].ID;
        priorquarterinsert.SubMetric_Name__c = temp5[1].ID;
        priorquarterinsert.Month__c='March';
        priorquarterinsert.year__c='2014';
        priorquarterinsert.Score__c=Double.valueof(2);
        priorquarterinsert.VsCompetetorField__c='1.00';
        priorquarterinsert.ScoreOverrides__c='BE1';
        priorquarterinsert.Controlled_Shipping__c='CS1';
        insert priorquarterinsert;
         SSC_CurrentQuarterScore__c currentscoreinsert3= new SSC_CurrentQuarterScore__c();
  
        currentscoreinsert3.GenerationDate__c =DateTime.valueof('2014-01-17 09:05:00AM');
        currentscoreinsert3.Account__c = Supplier[0].ID;
        currentscoreinsert3.SubMetric_Name__c = temp5[1].ID;
        currentscoreinsert3.Month__c='April';
        currentscoreinsert3.year__c='2014';
        currentscoreinsert3.Score__c=Double.valueof(2);
        currentscoreinsert3.VsCompetetorField__c='1.00';
        currentscoreinsert3.ScoreOverrides__c='BE1';
        currentscoreinsert3.Controlled_Shipping__c='CS1';
        insert currentscoreinsert3;
        string CurrentMonth1 ='February';
        String PreviousMonth1='December';
        String CurrentYear1='2014' ;
        String PreviousYear1='2013';
        String supplierName ='1234567';
        String Month='February';
        String Year='2014';
        string Dates ='2014-01-17 09:05:00AM';
        String ScoreCard_Type ='Current';
        String key='2';
        String Vscompetitor='';
        ApexPages.currentPage().getParameters().put('Generation Date',Dates);
        SSC_DirectMaterialScoreCard Temp= new SSC_DirectMaterialScoreCard();
        temp.Total=54.6;
        temp.total1=56.4;
        temp.supplierName ='1234567';
        temp.selectedaccount='test';
        temp.currentyear='2015';
         temp.Previousyear='2015';
         temp.DatesFormat=datetime.valueof(system.now());
         temp.email='abc@salesforce.com';
         temp.sum=60.9;
         temp.PriorQtrSum=45;
         temp.displayflag=true;
         temp.PreviousGenerationDate=datetime.valueof(system.now());
         temp.fileId='001abc';
         temp.GenerationDate='2014-01-17 09:05:00AM';
         
        
        CurrentQtrScoreVS =[Select VsCompetetorField__c from SSC_CurrentQuarterScore__c  where
        Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Name=: SupplierName  and GenerationDate__c=: DateTime.Valueof( Dates ) ];
        //system.assertequals(null,CurrentQtrScoreVS );
        CurrentQtrScoreBE =[Select ScoreOverrides__c from SSC_CurrentQuarterScore__c  where
        Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Name=: SupplierName  and GenerationDate__c=: DateTime.Valueof( Dates ) ];
        CurrentQtrScoreCS =[Select Controlled_Shipping__c from SSC_CurrentQuarterScore__c  where
        Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Name=: SupplierName  and GenerationDate__c=: DateTime.Valueof( Dates ) ];
        // Vscompetitor= String.valueof(CurrentQtrScoreVS[0].VsCompetetorField__c);
           // BusinessEscalation= CurrentQtrScoreBE[0].ScoreOverrides__c;
       test.starttest();
        Temp.getCurrentScoringGuide();
        Temp.getPreviousScoringGuide();
        //Temp.getColorforoverall();
        Temp.getSubmetric();
        Temp.getAccount8();
        Temp.getCurrentQtrScores();
        Temp.getSubmetricData();
        Temp.getSubmetric();
        Temp.getCurrentQtrScores();
        SSC_DirectMaterialScoreCard.wrapperclass wcc=Temp.getTempWrapObject();
        Temp.getSubmetricCurrentData();
        Temp.RedirectLevel2();
        Temp.getMetricScoreMap();
        Temp.getmapToScore();
        Temp.showPopup();
        Temp.RedirectScoringGuides();
        Temp.Calendar();
        Temp.RedirectLevel3();
        Temp.RedirectLevel1();
        Temp.getAccountNames1();
        String selectedaccount='test@test.com';
        //email=selectedaccount;
        //Temp.sendpdf();
        Temp.Rawdata3();
        Temp.closepopup1();
        Temp.showpopup1();
        Temp.validate();
        Temp.getCurrentQtrScoresCS();
        Temp.getCurrentQtrScoresBE();
        Temp.getCurrentQtrScoresVS();
        //Temp.getdisplay();
        Temp.geterror();
        //Temp.getSum();
        //Temp.getBusinessEscalation();
        //Temp.getVscompetitor();
        //Temp.getControlledShipping();
        //Temp.getErroMessageVS();
        //Temp.getErroMessageBE();
        //Temp.getErroMessageCS();
        //Temp.getInfoMessageVS();
        //Temp.getInfoMessageBE();
        //Temp.getInfoMessageCS();
        Temp.getSave();
        test.stoptest();
        //Temp.getSuccessMessageVS();
        //Temp.getSuccessMessageBE();
        //Temp.getSuccessMessageCS();
        Temp.rawdata();
        Temp.closePopup();
        Temp.EditScoringGuide();
        Temp.SelectContact();
        Temp.getCurrentL3Submetriclist();
        Temp.Rawdata2();
        boolean contains= false;
        wcc.getMetricsList();
        wcc.getSubmetricData();
        wcc.getSubmetricCurrentData();
        wcc.getSubmetricPreviousData();
        wcc.getCurrentScoringGuide();
        wcc.getPriorQtrSubMetricData();
        wcc.getPriorQtrL3SubMetricData();
        wcc.getL3Submetricslist();
        wcc.getmapToScore();
        wcc.getTemp1();
        wcc.getPriorQtrMetricData();
        wcc.getMetricScoreMap();
        wcc.getSubMetricMaptoScore();
        wcc.getL3SubMetricMaptoScore();
        wcc.getcolor();
        wcc.getColorList();
        wcc.getPreviousL3SubMetricColor();
        wcc.getPreviousQtrMetricColor();
        wcc.getL3SubMetricColor();
        wcc.getSubMetricColor();
        wcc.getMetricColor();
        wcc.getPreviousQtrSubMetricColor();
        //Temp.getVisible();
        PageReference pdf = Page.SSC_DM_ScoreCard_pdf;
        //string[] email= new List  <string >();
        //email.add('gxn837@motorola.com');
        temp.SelectedAccount='abc@gmail.com';
       Temp.sendpdf();
       temp.MetricScoreMap= new Map<String,Double>();
        temp.MetricScoreMap.put('Overall',100.0);
        temp.mapToScore=new Map<String,Double>();
        temp.mapToScore.put('Overall',90.0);
        temp.PriorQtrSum=90;
       /* SSC_ScoringGuide__c scoringguideinsert = new SSC_ScoringGuide__c();
        scoringguideinsert.Name='DM Score Card';
        scoringguideinsert.Min__c=0;
        scoringguideinsert.Max__c=50;
        scoringguideinsert.Scoring_Guide__c='VS';
        scoringguideinsert.ColorGrade__c='blue';
        
        insert scoringguideinsert ; */
        
        temp.getColorforoverall();
        
        temp.getColorforoverall1();
    }
    static testMethod  PageReference rawdata()
    {
        List  <SSC_GdriveFileID__c > FileIds= new List  <SSC_GdriveFileID__c >();
        SSC_GdriveFileID__c gdrive = new SSC_GdriveFileID__c();
        gdrive.Name ='0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnc';
        gdrive.File_ID__c='0AiHwFohvc_vqdEhjb1RNZ0k';
        gdrive.Generation_Date__c=DateTime.valueof('2014-01-17 09:05:00AM');
        insert gdrive;
        FileIds =[Select Name ,File_ID__c,Generation_Date__c from SSC_GdriveFileID__c ];
        string url ='https://docs.google.com/a/motorola.com/spreadsheet/ccc?key=';
        FileIds[0].File_ID__c='0AiHwFohvc_vqdEhjb1RNZ0k';
        url=url+FileIds[0].File_ID__c +'&usp=drive_web#gid=0';
        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
        static testMethod void getRedirectPDF()
    {
       Map<String,String> ListMonths = new Map<String,String>{
        'January'=>'1','February'=>'1','March'=>'1','April'=>'2','May'=>'2','June'=>'2','July'=>'3','August'=>'3','September'=>'3','October'=>'4','November'=>'4','December'=>'4'
       };
      Map<String,String> MonthNames = new Map<String,String>{
        '1'=>'January','2'=>'February','3'=>'March','4'=>'April','5'=>'May','6'=>'June','7'=>'July','8'=>'August','9'=>'September','10'=>'October','11'=>'November','12'=>'December'
       };
        Integer MonthPos =2;
        String supplierName ='1234567';
        String Month='February';
        String Year='2014';
        string Dates ='2014-01-17 09:05:00AM';
        String ScoreCard_Type ='Current';
        String key='2';
        ApexPages.currentPage().getParameters().put('Generation Date',Dates);
        SSC_DirectMaterialScoreCard Temp= new SSC_DirectMaterialScoreCard();
        Temp.RedirectPDF();
        Temp.getInterchange();
    }
    
    
    
   
}