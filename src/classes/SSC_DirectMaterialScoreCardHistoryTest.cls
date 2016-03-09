/*
     * Created by: Kalyan Chakravarthy
     * Creation date: 20-Jan-2014
     * Description: DM_ScoreCard History Test Class 
     *
     * Change history:
     * Changed on:
     * Changed by:
     * Description:
     */

@isTest
public class SSC_DirectMaterialScoreCardHistoryTest{
    static testMethod void Gdrive()
    {  
        List<SSC_SubMetric__c > Metrics= new List<SSC_SubMetric__c >();
        List<SSC_SubMetric__c > submetricinnovation= new List<SSC_SubMetric__c >();
        List <SSC_GdriveFileID__c > FileIds= new List <SSC_GdriveFileID__c >();
        
        SSC_GdriveFileID__c gdrive = new SSC_GdriveFileID__c();
        String MetricL3='Innovation';
        gdrive.Name ='0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnc';
        gdrive.File_ID__c='0AiHwFohvc_vqdEhjb1RNZ0k';
        gdrive.Generation_Date__c=DateTime.valueof('2014-01-17 09:05:00AM');
        insert gdrive;
        
        SSC_GdriveFileID__c gdrive1 = new SSC_GdriveFileID__c();
        gdrive1.Name ='0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnd';
        gdrive1.File_ID__c='0AiHwFohvc_vqdEhjb1RNw0k';
        gdrive1.Generation_Date__c=DateTime.valueof('2014-01-17 09:05:00AM');
        insert gdrive1;
         contact a = new contact();
         a.firstname='test';
         a.lastname='test';
         a.email='abc@gmail.com';
         insert a;
         SSC_GdriveFileID__c gdrive2 = new SSC_GdriveFileID__c();
        gdrive2.Name ='0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnd';
        gdrive2.File_ID__c='0AiHwFohvc_vqdEhjb1RNw0k';
        gdrive2.Generation_Date__c=DateTime.valueof('2014-01-17 09:05:00AM');
        insert gdrive2;
        
        Account accountsinsert = new account();
        accountsinsert.name='0000000';
        insert accountsinsert ;
        SSC_ScoringGuide__c scoringguideinsert = new SSC_ScoringGuide__c();
        scoringguideinsert.Name='DM Score Card';
        insert scoringguideinsert ;
        
        List  <SSC_ScoringGuide__c > scoringguide= new List  <SSC_ScoringGuide__c >();
        scoringguide=[Select ID,Name from SSC_ScoringGuide__c ];
        SSC_Metric__c Metricinsert= new SSC_Metric__c();
        Metricinsert.Name='Cost';
        Metricinsert.SSC_ScoringGuide__c=scoringguide[0].ID;
        Metricinsert.Target_Score__c=Double.valueof(25);
        insert Metricinsert;
        
        SSC_Metric__c Metricinsert1= new SSC_Metric__c();
        Metricinsert1.Name='Innovation';
        Metricinsert1.SSC_ScoringGuide__c=scoringguide[0].ID;
        Metricinsert1.Target_Score__c=Double.valueof(25);
        insert Metricinsert1;
        
        List  <SSC_Metric__c > metrics1 = new List  <SSC_Metric__c >();
        metrics1=[Select ID from SSC_Metric__c ];
        SSC_SubMetric__c submetricinsert= new SSC_SubMetric__c();
        submetricinsert.Metric_Name__c = metrics1[0].ID;
        submetricinsert.Name='Cost Competitiveness';
        submetricinsert.TargetScore__c=Double.valueof(5);
        submetricinsert.L3Indicator__c = 'Y';
        insert submetricinsert;
        
        submetricinsert.clear();
        submetricinsert.Metric_Name__c = metrics1[0].ID;
        submetricinsert.Name='Cost Control';
        submetricinsert.TargetScore__c=Double.valueof(5);
        insert submetricinsert;
       
        Metrics=[select Metric_Name__r.Name ,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y' and End_Date__c =:null ];
                
        FileIds =[Select Name ,File_ID__c,Generation_Date__c from SSC_GdriveFileID__c ];
         Account account;
         string SelectedSupplier;
         List<Contact> AccountNames = new List<Contact>();
         List<SelectOption> AccountNames1 = new  List<SelectOption>();
        String supplierName ='0000000';
        String Month='February';
        String Year='2014';
        string Dates ='2014-01-17 09:05:00AM';
        String ScoreCard_Type ='History';
        ApexPages.currentPage().getParameters().put('Generation Date',Dates);
        SSC_DirectMaterialScoreCardHistory Temp= new SSC_DirectMaterialScoreCardHistory();
        PageReference PageRef = Temp.RedirectPDF();
        List  <SSC_ScoringGuide__c > SC= Temp.getCurrentScoringGuide();
        
        Temp.getCurrentScoringGuide();
        Temp.getMetricListTempVar();
        Temp.getSubmetric();
        Temp.getCurrentQtrScores();
        Temp.getCurrentL3SubMetricsList();
        Temp.getMetrics();
        Temp.getCurrentQtrScores();
        SSC_DirectMaterialScoreCardHistory.wrapperclass wrapperobject=Temp.getWrapperObject();
        Temp.getCurrentScore();
        Temp.getMetricScoreMap();
        Temp.RedirectLevel2();
        Temp.RedirectLevel1();
        Temp.getAccount();
        Temp.getAccountNames1();
        Temp.getmapToScore();
        Temp.showPopup();
        Temp.RedirectScoringGuides();
        Temp.Calendar();
        Temp.RedirectLevel3();
        Temp.getInterchange();
        Temp.getTempVarFlag();
        Temp.SelectContact();
        account = [SELECT Name,
                  (SELECT Contact.Name, Contact.Email FROM Account.Contacts)
                   FROM Account]
                   ;
                  for(Contact temp1 : AccountNames)  {  
                   AccountNames1.add(new SelectOption(temp1.Email,temp1.Email));}
                   //system.assertequals(account.Contacts[0].Email,null);
                   
        Temp.closePopup1();
        Temp.showpopup1();
        Temp.Rawdata3();
        boolean contains= false;
        wrapperobject.getMetricsList();
        wrapperobject.getCurrentL3SubMetricsList();
        wrapperobject.getCurrentSubMetricsList();
        wrapperobject.getCurrentMetricsList();
        wrapperobject.getCurrentScoringGuide();
        wrapperobject.getMapSubMetricList();
        wrapperobject.getMapL3SubMetricList();
        wrapperobject.getMetricListTemp();
        wrapperobject.getCurrentScore();
        wrapperobject.getCurrentL3SubMetricsList();
        wrapperobject.getMetricsList7();
        wrapperobject.getMetricScoreMap();
        wrapperobject.getSubMetricScoreMap ();
        wrapperobject.getL3SubMetricScoreMap ();
        wrapperobject.getcolor();
        wrapperobject.getPreviousColor();
        wrapperobject.getPreviousMetricColor();
        wrapperobject.getPreviousL3SubMetricColor();
        wrapperobject.getL3SubMetricColor();
        wrapperobject.getSubMetricColor();
        wrapperobject.getMetricColor();
        wrapperobject.getPreviousSubMetricColor();
        
        Temp.getVisible();
        Temp.getSave();
        //Temp.sendPdf();
        
        FileIds[0].File_ID__c='0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnc';
        Temp.Rawdata();
        Temp.Rawdata2();
        Temp.getL3MetricListTemp();
        Temp.closePopup();
    }
    static testMethod void ba()
    {
        String supplierName ='0000000';
        String Month='February';
        String Year='2014';
        string Dates ='2014-01-17 09:05:00AM';
        String ScoreCard_Type ='Current';
        ApexPages.currentPage().getParameters().put('Generation Date',Dates);
        SSC_DirectMaterialScoreCardHistory ss= new SSC_DirectMaterialScoreCardHistory();
        
    }
    static testMethod void getTemp()
    {
        String supplierName ='0000000';
        String Month='February';
        String Year='2014';
        string Dates ='2014-01-17 09:05:00AM';
        String ScoreCard_Type ='Current';
        ApexPages.currentPage().getParameters().put('Generation Date',Dates);
        SSC_DirectMaterialScoreCardHistory Temp= new SSC_DirectMaterialScoreCardHistory();
        // SSC_PriorQuarterScore__c aa = Temp.getTemp();
    }
    static testMethod void getA()
    {
        String supplierName ='0000000';
        String Month='February';
        String Year='2014';
        string Dates ='2014-01-17 09:05:00AM';
        String ScoreCard_Type ='Current';
        ApexPages.currentPage().getParameters().put('Generation Date',Dates);
        SSC_DirectMaterialScoreCardHistory Temp= new SSC_DirectMaterialScoreCardHistory();
        Temp.RedirectPDF();
    }
    static testMethod void getValue2(){
        String supplierName ='0000000';
        String Month='February';
        String Year='2014';
        string Dates ='2014-01-17 09:05:00AM';
        String ScoreCard_Type ='Current';
        ApexPages.currentPage().getParameters().put('Generation Date',Dates);
        SSC_DirectMaterialScoreCardHistory ss= new SSC_DirectMaterialScoreCardHistory();
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
        String key = '0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnc';
        string url ='https://docs.google.com/a/motorola.com/spreadsheet/ccc?key=';
        url=url+FileIds[0].File_ID__c +'&usp=drive_web#gid=0';
        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
}