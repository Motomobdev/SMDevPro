/*
* Created by: Kalyan Chakravarthy
* Creation date: 18-Jan-2014
* Test Class: SSC_DM_ScoreCard1Test
* Description: Display scores
*
* Change history:
* Changed on:
* Changed by:
* Description:

*/
Public with sharing class SSC_DirectMaterialScoreCardHistory{
    Public String CurrentMonth{get;set;}
    Public Double Total{get;set;}
    Public Double Total1{get;set;}
    Set<String> DateSet= new Set<String>();
    Public String SelectedAccount{get;set;}
    Public boolean displayPopup {get; set;}
    Public String MetricL3{get;set;}
    Public String PreviousMonth{get;set;}
    Public  Double ScoreGenerated {get;set;}
    Public string CurrentYear{get;set;}
     public boolean displayPopup1 {get; set;}
    Public string PreviousYear{get;set;}
    Public String Month{get;set;}
    Public String supplierName{get;set;}
    Public String Year{get;set;}
    Public dateTime DatesFormat{get;set;}
    Public String Dates{get;set;}
    Public List<Contact> AccountNames = new List<Contact>();
    Public boolean visible{get;set;}
    Public String ScoreCard_Type{get;set;}
    Public String PdfUrl {get;set;}
    Public DateTime PreviousGenerationDate{get;set;}
    Public Map<Integer,List<String>> months = new Map<Integer,List<String>>();
    Public Account account;
    Public List<SSC_PriorQuarterScore__c > CurrentQtrScore = New List<SSC_PriorQuarterScore__c >();
    Public Map<Integer, String> quarters = new Map<Integer,String>();
    Public List<SSC_SubMetric__c> PrevioussubmetricInnovation = new List<SSC_SubMetric__c> ();

    Public List<SSC_PriorQuarterScore__c> PreviousnDates= new List<SSC_PriorQuarterScore__c>();
    Public List<SSC_Metric__c> PreviousMetricsList= new List<SSC_Metric__c>();
    Public List<SSC_L3SubMetric__c> PrevMetricList = new List<SSC_L3SubMetric__c>();

    Public List<SSC_L3SubMetric__c> PrevMetricListTemp = new List<SSC_L3SubMetric__c>();
    Public List<SSC_L3SubMetric__c> PrevMetricListTempVar= new List<SSC_L3SubMetric__c>();
    Public List<SSC_SubMetric__c > PrevSubMetricList= new List<SSC_SubMetric__c >();

    Public List<SSC_SubMetric__c > PreviousMetrics= new List<SSC_SubMetric__c >();
    Public List<SSC_SubMetric__c > PreviousMetric= new List<SSC_SubMetric__c >();
    Public boolean TempFlag=false;

    Public boolean TempVarFlag = true;
    Public boolean TemporaryVar{get;set;}
    Public Map<String,Double> mapToScore = new Map<string,Double>();
    Public Map<String, List< SSC_PriorQuarterScore__c> > mapToAccount = new Map<String,List< SSC_PriorQuarterScore__c> >();

    Public Map<String, List< SSC_PriorQuarterScore__c> > MapSubMetricList = new Map<String,List< SSC_PriorQuarterScore__c> >();
    Public Map<String,Double> MetricScoreMap = new Map<string,Double>();

    Public Map<String,Double> SubMetricScoreMap  = new Map<string,Double>();
    Public Map<String,Double> L3SubMetricScoreMap  = new Map<string,Double>();
    Public Map<String, List< SSC_PriorQuarterScore__c> > MapMetricList = new Map<String,List< SSC_PriorQuarterScore__c> >();

    Public Map<String, List< SSC_PriorQuarterScore__c> > MapL3SubMetricList = new Map<String,List< SSC_PriorQuarterScore__c> >();
    Public List<SSC_SubMetric__c> submetricInnovation= new List<SSC_SubMetric__c> ();

    Public Map<String,String> col= new Map<String,string>();
    Public Map<String,String> PreviousColor= new Map<String,string>();
    Public Map<String,String> PreviousMetricColor= new Map<String,string>();

    Public Map<String,String> PreviousSubMetricColor= new Map<String,string>();
    Public Map<String,String> PreviousL3SubMetricColor= new Map<String,string>();
    Public Map<String,String> L3SubMetricColor= new Map<String,string>();

    Public Map<String,String> SubMetricColor= new Map<String,string>();
    Public Map<String,String> MetricColor= new Map<String,string>();
    Public String email {get;set;}
    Public Map<Integer,string> colour= new map<Integer,string>();

    Public List< SSC_PriorQuarterScore__c> metric= new List<SSC_PriorQuarterScore__c>();
    Public List< SSC_PriorQuarterScore__c> PriorSubMetrics= new List<SSC_PriorQuarterScore__c>();
    Public List< SSC_PriorQuarterScore__c> CurrentMetrics= new List<SSC_PriorQuarterScore__c>();

    Public List< SSC_PriorQuarterScore__c> PriorMetrics= new List<SSC_PriorQuarterScore__c>();
    Public List< SSC_PriorQuarterScore__c> CurrentSubMetrics= new List<SSC_PriorQuarterScore__c>();

    Public List< SSC_PriorQuarterScore__c> CurrentL3SubMetrics= new List<SSC_PriorQuarterScore__c>();
    Public List< SSC_PriorQuarterScore__c> PriorL3SubMetrics= new List<SSC_PriorQuarterScore__c>();

    Public Double sum{get;set;}
    Public Integer PriorQtrSum{get;set;}
    Public List<Integer> sumvalues= new List<Integer>();
    Public List<SSC_Metric__c> MetricsList= new List<SSC_Metric__c>();

    Public List<SSC_L3SubMetric__c> MetricListTemp= new List<SSC_L3SubMetric__c>();
    Public List<SSC_L3SubMetric__c> MetricListTempVar= new List<SSC_L3SubMetric__c>();
    Public List<SSC_L3SubMetric__c> L3MetricListTemp= new List<SSC_L3SubMetric__c>();

    Public List<SSC_SubMetric__c > CurrentL3SubMetricsList= new List<SSC_SubMetric__c >();
    Public List<SSC_SubMetric__c > Metrics= new List<SSC_SubMetric__c >();
    Public List<SSC_SubMetric__c > SubMetrics = new List<SSC_SubMetric__c >();

    Public List <SSC_PriorQuarterScore__c> PriorQtrData= new List<SSC_PriorQuarterScore__c>();
    Public List <SSC_PriorQuarterScore__c > CurrentQtrData= new List<SSC_PriorQuarterScore__c >();

    Public List<SSC_SubMetric__c> CurrentSubMetricsList= new List<SSC_SubMetric__c>();
    Public List<SSC_SubMetric__c> L3subMetric= new List<SSC_SubMetric__c>();
    Public List<SSC_PriorQuarterScore__c> CurrentMetricsList= new List<SSC_PriorQuarterScore__c>();

    Public List<SSC_ScoringGuide__c> CurrentScoringGuide= new List<SSC_ScoringGuide__c>();
    Public List<SSC_ScoringGuide__c> CurrentScore= new List<SSC_ScoringGuide__c>();
    Public SSC_ScoringGuide__c OverallScoringGuide = new SSC_ScoringGuide__c();
    Public List<SelectOption> AccountNames1 = new  List<SelectOption>();
    Public Map<String,Double>  temporary = new Map<String,Double> ();
    Public Map<String,Double>  MetricScore = new Map<String,Double> ();
    Public Map<String,Double>  SubMetricScore = new Map<String,Double> ();

    Public Map<String,Double>  L3SubMetricScore = new Map<String,Double> ();
    Public List<SSC_SubMetric__c > submetriclist = new  List<SSC_SubMetric__c > ();
    Public Map<String,String> ListMonths = new Map<String,String>{'January'=>'1','February'=>'1','March'=>'1','April'=>'2','May'=>'2','June'=>'2','July'=>'3','August'=>'3','September'=>'3','October'=>'4','November'=>'4','December'=>'4'};

    Public Map<String,String> QtrLastMonth = new Map<String,String>{'1'=>'March','2'=>'June','3'=>'September','4'=>'December'};
    Public Map<String,String> MonthNames = new Map<String,String>{'1'=>'January','2'=>'February','3'=>'March','4'=>'April','5'=>'May','6'=>'June','7'=>'July','8'=>'August','9'=>'September','10'=>'October','11'=>'November','12'=>'December'};

    Public string CurrentMonth1{get;set;}
    Public String PreviousMonth1{get;set;}
    Public String CurrentYear1 {get;set;}
    Public String PreviousYear1{get;set;}
    Public List<SSC_L3SubMetric__c> submetriclist2 = new  List<SSC_L3SubMetric__c>();
    Public string SelectedSupplier{get;set;}
    Public List<SSC_PriorQuarterScore__c  > TempPriorQtrData = new List<SSC_PriorQuarterScore__c  >();
    Public List<SSC_PriorQuarterScore__c > TempCurrentQtrData = new List<SSC_PriorQuarterScore__c >();

    Public Set<String> PreviousDatesSet= new Set<String>();
    Public String FileId{get;set;}
    Public string url{get;set;}
    Public List<SSC_GdriveFileID__c> FileIds= new List<SSC_GdriveFileID__c>();

    Public String GenerationDate{get;set;}
    
    Public PageReference RedirectPdf()
    {
        PdfUrl  = 'https://'+ApexPages.currentPage().getHeaders().get('Host') ;
        //PdfUrl =PdfUrl +'/apex/SSC_DM_ScoreCard_pdf_History?Generation+Date='+Dates+'&Month='+Month+'&ScoreCard+Type='+ScoreCard_Type+'&Supplier+ID='+supplierName+'&Year='+Year;
        PdfUrl  = PdfUrl +'/apex/SSC_DM_ScoreCard_pdf_History?Generation+Date='+Dates+'&Month='+Month+'&ScoreCard+Type='+ScoreCard_Type+'&Supplier+ID='+supplierName+'&Year='+Year+'&Supplier+Name='+SelectedSupplier;
        //system.assertequals(null,PdfUrl);
        PageReference acctPage = new PageReference(PdfUrl);

        return acctPage;
    }
    
    Public void getInterchange()
    {
        TemporaryVar=TempFlag;
        TempFlag=TempVarFlag;
        TempVarFlag=TemporaryVar;
    }
    
    Public boolean getTempVarFlag()

    {
        return TempVarFlag;
    }
    
    Public SSC_DirectMaterialScoreCardHistory(){
        visible =false;
        supplierName = System.currentPageReference().getParameters().get('Supplier ID');

        Month=System.currentPageReference().getParameters().get('Month');
        Year=System.currentPageReference().getParameters().get('Year');
        ScoreCard_Type =System.currentPageReference().getParameters().get('ScoreCard Type');
        SelectedSupplier=System.currentPageReference().getParameters().get('Supplier Name');
        Dates=System.currentPageReference().getParameters().get('Generation Date');
        DatesFormat=DateTime.valueof(Dates);
        displayPopup1 = true;
        if(ScoreCard_Type =='History')
        {
         AccountNames = 
                  [SELECT Name, Email FROM Contact
                   
                   WHERE  Account.Name  =:SelectedSupplier ];  
  
      
      for(Contact a: AccountNames)  {
       if(a.Email != null)
       AccountNames1.add(new SelectOption(a.Email,a.Email));
      }
      
            Integer MonthPos = Date.Today().Month();

            CurrentMonth1=Month ;
            CurrentYear1=  Year;
            String Key = ListMonths.get(CurrentMonth1);
            Integer FinalKey;
            if(key== '2' || key== '3' || key == '4')

            {
                FinalKey= Integer.valueof(key)-1;
                PreviousYear1=CurrentYear1;
                PreviousMonth1=QtrLastMonth.get(String.valueof(FinalKey));
            }
            else

            {
                key = String.valueof(4);
                Integer TempYear;
                TempYear=Integer.valueof(CurrentYear1)-1;
                PreviousYear1= string.valueof(TempYear);
                PreviousMonth1=QtrLastMonth.get(key);

            }
        }
       
        this.PreviousnDates=[Select GenerationDate__c  from SSC_PriorQuarterScore__c  where Month__c=:PreviousMonth1 and year__c=:PreviousYear1 ];
        List<SSC_PriorQuarterScore__c> tempdate=[select GenerationDate__c from  SSC_PriorQuarterScore__c   where Month__c=: CurrentMonth1 and Year__c=: CurrentYear1];

        FileIds = [Select File_ID__c,Generation_Date__c   from SSC_GdriveFileID__c   ORDER BY Generation_Date__c DESC LIMIT 3 ];
        //system.assertequals(FileIds,null);

       
        for(SSC_PriorQuarterScore__c  t : PreviousnDates)
        {
            PreviousDatesSet.add(String.valueof(t.GenerationDate__c  ));
        }
       
        for (String tempItem : PreviousDatesSet){

            previousgenerationdate=DateTime.valueof(tempItem  );
        }
       
        CurrentQtrScore =[Select Comments__c,ScoreOverrides__c,VsCompetetorField__c,Controlled_Shipping__c   from SSC_PriorQuarterScore__c  where

        Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName   ];
        L3MetricListTemp =[select SSC_SubMetric__r.Name  from SSC_L3SubMetric__c where  End_Date__c >= :DateTime.valueof(Dates) and Start_Date__c<=:DateTime.valueof(Dates)];

        if(L3MetricListTemp.isempty()==true)
        L3MetricListTemp =[select SSC_SubMetric__r.Name  from SSC_L3SubMetric__c where  End_Date__c = :null];
        PrevMetricListTempVar =[select SSC_SubMetric__r.Name  from SSC_L3SubMetric__c where  End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

        if(PrevMetricListTempVar.isempty()==true)
        PrevMetricListTempVar=L3MetricListTemp ;
        MetricsList=[select Name,Target_Score__c from SSC_Metric__c where  End_Date__c >= :DateTime.valueof(Dates) and Start_Date__c<=:DateTime.valueof(Dates) ORDER BY Target_Score__c ];

        if(MetricsList.isempty()==true)
        MetricsList=[select Name,Target_Score__c from SSC_Metric__c where  End_Date__c =:null ORDER BY Target_Score__c ];
        PreviousMetricsList=[select Name,Target_Score__c from SSC_Metric__c  where End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ORDER BY Target_Score__c];

        if(PreviousMetricsList.isempty()==true)
        PreviousMetricsList=MetricsList;
        CurrentL3SubMetricsList=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y' and End_Date__c >= :DateTime.valueof(Dates) and Start_Date__c<=:DateTime.valueof(Dates)  ];

        if(CurrentL3SubMetricsList.isempty()==true)
        CurrentL3SubMetricsList=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y' and End_Date__c =:null  ];
        PrevSubMetricList=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y' and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

        if(PrevSubMetricList.isempty()==true)
        PrevSubMetricList=CurrentL3SubMetricsList;
        SubMetrics=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c!='Y' and End_Date__c >= :DateTime.valueof(Dates) and Start_Date__c<=:DateTime.valueof(Dates) ];

        if(SubMetrics.isempty()==true)
        SubMetrics=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c!='Y' and End_Date__c =:null ];
        PreviousMetric=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c!='Y' and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate ];

        if(PreviousMetric.isempty()==true)
        PreviousMetric=SubMetrics;
        Metrics=[select Metric_Name__r.Name ,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y' and End_Date__c >= :DateTime.valueof(Dates) and Start_Date__c<=:DateTime.valueof(Dates) ];

        if(Metrics.isempty()==true)
        Metrics=[select Metric_Name__r.Name ,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y' and End_Date__c =:null ];
        PreviousMetrics=[select Metric_Name__r.Name ,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y'  and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

        MetricL3='Innovation';
        if(PreviousMetrics.isempty()==true)
        PreviousMetrics=Metrics;
        submetricInnovation = [select Name,TargetScore__c from SSC_SubMetric__c where Metric_Name__r.Name =:MetricL3 and  End_Date__c >= :DateTime.valueof(Dates) and Start_Date__c<=:DateTime.valueof(Dates)];

        if(submetricInnovation.isempty()==true)
        submetricInnovation = [select Name,TargetScore__c from SSC_SubMetric__c where Metric_Name__r.Name =:MetricL3 and  End_Date__c =:null];
        PrevioussubmetricInnovation = [select Name,TargetScore__c from SSC_SubMetric__c where Metric_Name__r.Name =:MetricL3 and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate ];

        if(PrevioussubmetricInnovation .isempty()==true)
        PrevioussubmetricInnovation =submetricInnovation ;
        PriorQtrData=[Select L3SubMetricName__c,SubMetric_Name__r.Name  from SSC_PriorQuarterScore__c  where SubMetric_Name__r.Metric_Name__r.Name=:MetricL3    and  Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName   ORDER BY L3SubMetricName__c];

        CurrentQtrData=[Select L3SubMetricName__c, SubMetric_Name__r.Name from SSC_PriorQuarterScore__c  where   SubMetric_Name__r.Metric_Name__r.Name=:MetricL3  and  Month__c=:PreviousMonth1 and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName ORDER BY L3SubMetricName__c   ];

       
        for(SSC_PriorQuarterScore__c  Temp : PriorQtrData)
        {
            List<SSC_L3SubMetric__c>TempL3Submetric = new List<SSC_L3SubMetric__c> ();
            List<SSC_L3SubMetric__c> L3Submetric = new List<SSC_L3SubMetric__c> ();

            if(Temp.L3SubMetricName__c  !=null){
                TempL3Submetric=[Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:Temp.L3SubMetricName__c  and End_Date__c >= :DateTime.valueof(Dates) and Start_Date__c<=:DateTime.valueof(Dates)];

                if(TempL3Submetric.isempty()==true)
                TempL3Submetric=[Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:Temp.L3SubMetricName__c  and End_Date__c =:null];

                L3Submetric =[Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:Temp.L3SubMetricName__c  and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

                if(L3Submetric.isempty()==true)
                L3Submetric =TempL3Submetric;
                for(SSC_L3SubMetric__c  sss:TempL3Submetric)
                MetricListTemp.add(sss);
                for(SSC_L3SubMetric__c  sss: L3Submetric )

                PrevMetricList.add(sss);
            }
        }
       
        for(SSC_PriorQuarterScore__c a1 : CurrentQtrData)
        {
            List<SSC_L3SubMetric__c>TempL3Submetric = new List<SSC_L3SubMetric__c> ();

            List<SSC_L3SubMetric__c>L3Submetric = new List<SSC_L3SubMetric__c> ();
            if(a1.L3SubMetricName__c  !=null){
                TempL3Submetric =[Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:a1.L3SubMetricName__c and End_Date__c >= :DateTime.valueof(Dates) and Start_Date__c<=:DateTime.valueof(Dates) ];

                if(TempL3Submetric .isempty()==true)
                TempL3Submetric =[Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:a1.L3SubMetricName__c and End_Date__c =:null ];

                L3Submetric=[Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:a1.L3SubMetricName__c and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

                if(L3Submetric.isempty()==true)
                L3Submetric=TempL3Submetric ;
                for(SSC_L3SubMetric__c  sss: TempL3Submetric )
                MetricListTempVar.add(sss);
                for(SSC_L3SubMetric__c  sss:L3Submetric)

                PrevMetricListTemp.add(sss);
            }
        }
       
        if(ScoreCard_Type =='Current')
        {
            /*CurrentScoringGuide = [Select Name,Min__c,Max__c,ColorGrade__c from SSC_ScoringGuide__c where SSC_ScoringGuide__c.End_Date__c = :NULL AND  Scoring_Guide__c=:'Overall' ORDER BY Min__c ];

            CurrentScore = [Select Name,Min__c,Caption__c ,ColorGrade__c from SSC_ScoringGuide__c where SSC_ScoringGuide__c.End_Date__c = :NULL AND  Scoring_Guide__c=:'VS' ORDER BY Min__c ];
            for(SSC_ScoringGuide__c temp :CurrentScore  )

            {
                Integer Tempvariable = Integer.valueof(temp.Min__c);
                temp.Min__c=Tempvariable;
            }*/
        }
        else
        {
            CurrentScoringGuide = [Select Name,Min__c,Max__c,ColorGrade__c ,Caption__c from SSC_ScoringGuide__c where SSC_ScoringGuide__c.End_Date__c!= :NULL  and( SSC_ScoringGuide__c.End_Date__c >= : DatesFormat AND SSC_ScoringGuide__c.Start_Date__c <=:DatesFormat  AND Scoring_Guide__c=:'Overall')ORDER BY Min__c ];

            //system.assertequals(null,CurrentScoringGuide);
            if(CurrentScoringGuide.size()==0)
            CurrentScoringGuide = [Select Name,Min__c,Max__c,ColorGrade__c,Caption__c from SSC_ScoringGuide__c where SSC_ScoringGuide__c.End_Date__c = :NULL AND  Scoring_Guide__c=:'Overall' ORDER BY Min__c ];

            CurrentScore = [Select Name,Min__c,Caption__c, ColorGrade__c from SSC_ScoringGuide__c where ( SSC_ScoringGuide__c.End_Date__c >= : DatesFormat AND SSC_ScoringGuide__c.Start_Date__c <=:DatesFormat  AND Scoring_Guide__c=:'VS')ORDER BY Min__c ];

            if(CurrentScore.size()==0){
                CurrentScore =[Select Name,Min__c,Caption__c ,ColorGrade__c from SSC_ScoringGuide__c where End_Date__c=:Null and  Scoring_Guide__c=:'VS' ORDER BY Min__c ];

            }
        }
       
        for (SSC_Metric__c Temp : MetricsList)
        {
            metric = [select ID,Score__c ,Comments__c,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c,SubMetric_Name__r.Metric_Name__r.Name from SSC_PriorQuarterScore__c where SubMetric_Name__r.Metric_Name__r.Name = :string.valueof(temp.Name) and  Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  ];

            for(SSC_PriorQuarterScore__c  TempVar : metric)
            {
                if(TempVar.SubMetric_Name__r.Metric_Name__r.Name!=MetricL3)

                PriorSubMetrics.add(TempVar);
            }
            mapToAccount.put((string)Temp.Name,metric );
        }
       
        for(SSC_Metric__c temp : [select Name,Target_Score__c
        from SSC_Metric__c where Name !=: MetricL3  ORDER BY Name])

        {
            TempPriorQtrData =  mapToAccount.get(temp.Name);
            for(SSC_PriorQuarterScore__c   TempVar :TempPriorQtrData)
            {
                SubMetricScore.put(string.valueof(TempVar .SubMetric_Name__r.Name),Double.valueof(TempVar .Score__c) );

                // ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,String.valueof(SubMetricScore));
                //     ApexPages.addMessage(myMsg);
            }
        }
       

        for(SSC_PriorQuarterScore__c  Temp : PriorSubMetrics)
        {
            Double ScoreGenerated =Double.valueof( SubMetricScore.get(Temp.SubMetric_Name__r.Name) )*100;

            Double score=ScoreGenerated /Double.valueof(temp.SubMetric_Name__r.TargetScore__c);
                for(SSC_ScoringGuide__c  TempVar : CurrentScoringGuide){
                    if(TempVar.Min__c < = score && TempVar.Max__c >= score )

                    OverallScoringGuide.ColorGrade__c =TempVar.ColorGrade__c ;
                    }
            SubMetricColor.put(String.valueof(temp.SubMetric_Name__r.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));

        }
        
        for (SSC_L3SubMetric__c temp : MetricListTemp)
        {
            //metric = [select Score__c ,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c,SubMetric_Name__r.Metric_Name__r.Name from SSC_PriorQuarterScore__c where ( SSC_PriorQuarterScore__c.SubMetric_Name__r.Name = :string.valueof(temp.Name))];

            metric = [select Score__c ,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c from SSC_PriorQuarterScore__c where  SSC_PriorQuarterScore__c.L3SubMetricName__c!=null and SSC_PriorQuarterScore__c.SubMetric_Name__r.Name=:string.valueof(temp.SSC_SubMetric__r.Name ) and Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  ];

            MapSubMetricList.put((string)temp.SSC_SubMetric__r.Name,metric );
        }
        sum=0;
        
        for (SSC_L3SubMetric__c temp : MetricListTemp)

        {
            PriorL3SubMetrics = [select Score__c  from SSC_PriorQuarterScore__c where SubMetric_Name__r.Name = :string.valueof(temp.SSC_SubMetric__r.Name )   and  Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  ];

            for(SSC_PriorQuarterScore__c TempVar : PriorL3SubMetrics )
            {
                sum=sum+Double.valueof(TempVar.Score__c);
            }
            L3SubMetricScoreMap .put(string.valueof(temp.SSC_SubMetric__r.Name),sum);

            PriorL3SubMetrics = [select Score__c,SubMetric_Name__r.Name  from SSC_PriorQuarterScore__c where L3SubMetricName__c=:Null and ( SubMetric_Name__r.Metric_Name__r.Name = :MetricL3)  and  Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName   ];

            for(SSC_PriorQuarterScore__c TempVar: PriorL3SubMetrics )
            L3SubMetricScoreMap .put(String.valueof(TempVar.SubMetric_Name__r.Name),Double.valueof(TempVar.Score__c) );

            sum=0;
        }
        
        for(SSC_SubMetric__c Temp : submetricInnovation )
        {
            ScoreGenerated =Double.valueof( L3SubMetricScoreMap.get(Temp.Name))*100;
            Double total = (Double.valueof(Temp.TargetScore__c)*100);

            Double score=ScoreGenerated /Double.valueof(Temp.TargetScore__c);
            for(SSC_ScoringGuide__c  TempScoringGuide : CurrentScoringGuide){
                if(TempScoringGuide.Min__c < = score && TempScoringGuide.Max__c >= score )

                OverallScoringGuide.ColorGrade__c =TempScoringGuide.ColorGrade__c ;
            }
            PreviousL3SubMetricColor.put(String.valueof(Temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));

        }
        
        for(SSC_L3SubMetric__c  Temp : MetricListTemp)
        {
            List<SSC_PriorQuarterScore__c  > TempVar= new List<SSC_PriorQuarterScore__c  > ();
            TempVar=  MapSubMetricList.get(temp.SSC_SubMetric__r.Name);

            for(SSC_PriorQuarterScore__c   PriorObject :TempVar)
            {
                temporary.put(string.valueof(PriorObject.L3SubMetricName__c),Double.valueof(PriorObject.Score__c) );
            }

        }
        
        for(SSC_L3SubMetric__c  temp : MetricListTemp)
        {
            Double ScoreGenerated =Double.valueof( temporary.get(temp.Name) )*100;
            Double score=ScoreGenerated /Double.valueof(temp.Target_Score__c);

            for(SSC_ScoringGuide__c  TempScoringGuide : CurrentScoringGuide){
                if(TempScoringGuide.Min__c < = score && TempScoringGuide.Max__c >= score )
                OverallScoringGuide.ColorGrade__c =TempScoringGuide.ColorGrade__c ;

        
            }
            PreviousMetricColor.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
        }
        
        for (SSC_L3SubMetric__c temp : MetricListTempVar)

        {
            CurrentSubMetrics = [select Score__c ,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c from SSC_PriorQuarterScore__c where  SSC_PriorQuarterScore__c.L3SubMetricName__c!=null and SSC_PriorQuarterScore__c.SubMetric_Name__r.Name=:string.valueof(temp.SSC_SubMetric__r.Name ) and

            Month__c=:PreviousMonth1 and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName    ];
            MapL3SubMetricList.put((string)temp.SSC_SubMetric__r.Name,CurrentSubMetrics );

        }
        sum=0;
        Total=0;
        for (SSC_L3SubMetric__c temp : MetricListTempVar)
        {
            CurrentL3SubMetrics = [select Score__c  from SSC_PriorQuarterScore__c where SubMetric_Name__r.Name = :string.valueof(temp.SSC_SubMetric__r.Name )

            and  Month__c=:PreviousMonth1 and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName ];
            for(SSC_PriorQuarterScore__c TempVar: CurrentL3SubMetrics )
            {

                sum=sum+Double.valueof(TempVar.Score__c);
            }
            SubMetricScoreMap .put(string.valueof(temp.SSC_SubMetric__r.Name),sum);
            CurrentL3SubMetrics = [select Score__c,SubMetric_Name__r.Name  from SSC_PriorQuarterScore__c where L3SubMetricName__c=:Null and ( SubMetric_Name__r.Metric_Name__r.Name = :MetricL3)

            and  Month__c=:PreviousMonth1 and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  ];
            for(SSC_PriorQuarterScore__c TempVar: CurrentL3SubMetrics )
            SubMetricScoreMap .put(String.valueof(TempVar.SubMetric_Name__r.Name),Double.valueof(TempVar.Score__c) );

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,string.valueof(Total));
            ApexPages.addMessage(myMsg);
            sum=0;
        }
        
        for(SSC_SubMetric__c temp : PrevioussubmetricInnovation )

        {
            Double ScoreGenerated =Double.valueof( SubMetricScoreMap .get(temp.Name))*100;
            Double total = (Double.valueof(temp.TargetScore__c)*100);
            Double score=ScoreGenerated /Double.valueof(temp.TargetScore__c);

            for(SSC_ScoringGuide__c  TempScoringGuide : CurrentScoringGuide){
                if(TempScoringGuide.Min__c < = score && TempScoringGuide.Max__c >= score )
                OverallScoringGuide.ColorGrade__c =TempScoringGuide.ColorGrade__c ;

        
            }
            L3SubMetricColor.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
        }
        
        for(SSC_L3SubMetric__c  tempVar : MetricListTempVar)

        {
            List<SSC_PriorQuarterScore__c > temp= new List<SSC_PriorQuarterScore__c > ();
            temp =  MapL3SubMetricList.get(tempVar.SSC_SubMetric__r.Name);

            for(SSC_PriorQuarterScore__c PriorObject :temp)
            {
                MetricScore.put(string.valueof(PriorObject.L3SubMetricName__c),Double.valueof(PriorObject.Score__c) );
            }
        }

        
        for(SSC_L3SubMetric__c  temp : PrevMetricListTemp)
        {
            Double ScoreGenerated =Double.valueof( MetricScore.get(temp.Name) )*100;
            Double score=(ScoreGenerated /Double.valueof(temp.Target_Score__c));

            for(SSC_ScoringGuide__c  TemScoringGuide : CurrentScoringGuide){
                if(TemScoringGuide.Min__c < = score && TemScoringGuide.Max__c >= score )
                OverallScoringGuide.ColorGrade__c =TemScoringGuide.ColorGrade__c ;

            }
            PreviousSubMetricColor.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
        }
        PriorQtrSum=0;
        
        for(SSC_Metric__c temp : MetricsList)

        {
            PriorQtrSum=PriorQtrSum+Integer.valueof(temp.Target_Score__c );
        }
        sum=0;
        Total=0;
        for (SSC_Metric__c temp : MetricsList)
        {
            metric = [select Score__c  from SSC_PriorQuarterScore__c where SubMetric_Name__r.Metric_Name__r.Name = :string.valueof(temp.Name) and  Month__c=:CurrentMonth1 and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName   ];

            for(SSC_PriorQuarterScore__c tempVar : metric )
            {
                sum=sum+Double.valueof(tempVar.Score__c);
            }
            Total+=sum;
            mapToScore.put(string.valueof(temp.Name),sum);

            sum=0;
        }
        mapToScore.put('Overall',Total);
        for(SSC_Metric__c temp : MetricsList)
        {
            Double ScoreGenerated =Double.valueof( mapToScore.get(temp.Name))*100;

            Double score=ScoreGenerated /Double.valueof(temp.Target_Score__c);
            for(SSC_ScoringGuide__c  TempScoringGuide : CurrentScoringGuide){
                if(TempScoringGuide.Min__c < = score && TempScoringGuide.Max__c >= score )

                OverallScoringGuide.ColorGrade__c =TempScoringGuide.ColorGrade__c ;
        
            }
            col.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
        }


        for (SSC_Metric__c temp : PreviousMetricsList)
        {
            CurrentMetrics = [select Score__c ,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c,SubMetric_Name__r.Metric_Name__r.Name from SSC_PriorQuarterScore__c where SubMetric_Name__r.Metric_Name__r.Name = :string.valueof(temp.Name)

            and  Month__c=:PreviousMonth1 and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  ];
            for(SSC_PriorQuarterScore__c PriorObject : CurrentMetrics)
            {

                if(PriorObject.SubMetric_Name__r.Metric_Name__r.Name!=MetricL3)
                PriorMetrics.add(PriorObject);
            }

            MapMetricList.put((string)temp.Name,CurrentMetrics );
        }

        for(SSC_Metric__c temp : [select Name,Target_Score__c
        from SSC_Metric__c where Name!= :MetricL3  ORDER BY Name])

        {
            TempCurrentQtrData =  MapMetricList.get(temp.Name);
            for(SSC_PriorQuarterScore__c PriorObject :TempCurrentQtrData)
            {
                L3SubMetricScore.put(string.valueof(PriorObject.SubMetric_Name__r.Name),Double.valueof(PriorObject.Score__c) );

            }
        }

        for(SSC_PriorQuarterScore__c temp : PriorMetrics)
        {
            Double ScoreGenerated =Double.valueof( L3SubMetricScore.get(temp.SubMetric_Name__r.Name) )*100;

            Double score=ScoreGenerated /Double.valueof(temp.SubMetric_Name__r.TargetScore__c);
            for(SSC_ScoringGuide__c  TempScoringGuide : CurrentScoringGuide){
                if(TempScoringGuide.Min__c < = score && TempScoringGuide.Max__c >= score )

                OverallScoringGuide.ColorGrade__c =TempScoringGuide.ColorGrade__c ;
            }
            MetricColor.put(String.valueof(temp.SubMetric_Name__r.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));

        }
        Total1=0;
        sum=0;

        for (SSC_Metric__c temp : PreviousMetricsList)
        {
            CurrentMetrics = [select Score__c  from SSC_PriorQuarterScore__c where SubMetric_Name__r.Metric_Name__r.Name = :string.valueof(temp.Name)

            and  Month__c=:PreviousMonth1 and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName   ORDER BY SubMetric_Name__r.Metric_Name__r.Target_Score__c Desc];
            for(SSC_PriorQuarterScore__c tempVar : CurrentMetrics )

            {
                sum=sum+Integer.valueof(tempVar .Score__c);
            }
            MetricScoreMap.put(string.valueof(temp.Name),sum);
            Total1=Total1+sum;
            sum=0;
        }

        MetricScoreMap.put('Overall',Total1);

        for(SSC_Metric__c temp : PreviousMetricsList)
        {
            Double ScoreGenerated =Double.valueof( MetricScoreMap.get(temp.Name))*100;

            Double score=ScoreGenerated /Double.valueof(temp.Target_Score__c);
            for(SSC_ScoringGuide__c  TempScoringGuide : CurrentScoringGuide){
                if(TempScoringGuide.Min__c < = score && TempScoringGuide.Max__c >= score )

                OverallScoringGuide.ColorGrade__c =TempScoringGuide.ColorGrade__c ;
            }
            PreviousColor.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
        }

      
    }
    
    Public List<SSC_ScoringGuide__c> getCurrentScoringGuide() {
        return CurrentScoringGuide ;
    }
    
    Public List<SSC_ScoringGuide__c> getMetricListTempVar() {

        return CurrentScore ;
    }
    
    Public Map<String,String> getColorforoverall1()
    {
        Double ScoreGenerated =Double.valueof( MetricScoreMap.get('Overall'))*100;
        Double score=ScoreGenerated /Double.valueof(PriorQtrSum);

        for(SSC_ScoringGuide__c  TempScoringGuide : CurrentScoringGuide){
            if(TempScoringGuide.Min__c < = score && TempScoringGuide.Max__c >= score )
            OverallScoringGuide.ColorGrade__c =TempScoringGuide.ColorGrade__c ;

        }
        col.put(String.valueof('Overall'),String.valueof(OverallScoringGuide.ColorGrade__c ));
        return col;
    }
    
    Public  Map<String, Double >  getmapToScore() {

        return mapToScore;
    }
    
    Public Map<String,String> getColorforoverall()
    {
        Double ScoreGenerated =Double.valueof( mapToScore.get('Overall'))*100;
        Double score=ScoreGenerated /Double.valueof(PriorQtrSum);

        for(SSC_ScoringGuide__c  TempScoringGuide : CurrentScoringGuide){
            if(TempScoringGuide.Min__c < = score && TempScoringGuide.Max__c >= score )
            OverallScoringGuide.ColorGrade__c =TempScoringGuide.ColorGrade__c ;

        }
        PreviousColor.put(String.valueof('Overall'),String.valueof(OverallScoringGuide.ColorGrade__c ));
        return PreviousColor;
    }
    
    Public PageReference RedirectLevel1(){

        supplierName = System.currentPageReference().getParameters().get('Supplier ID');
        Month=System.currentPageReference().getParameters().get('Month');
        Year=System.currentPageReference().getParameters().get('Year');

        ScoreCard_Type =System.currentPageReference().getParameters().get('ScoreCard Type');
        Dates=System.currentPageReference().getParameters().get('Generation Date');
        String url2=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        url2= url2+'/apex/SSC_DMScoreCard_History?'+'Supplier ID='+supplierName+'&' +'Month='+Month+'&'+'Year='+Year+'&'+'ScoreCard Type='+ScoreCard_Type+'&'+'Generation Date='+Dates;

        PageReference RedirectLevel2Page= new PageReference(url2);
        return RedirectLevel2Page;
    }
    
    Public List<SSC_Metric__c> getAccount() {

        MetricsList=[select Name,Target_Score__c
        from SSC_Metric__c];
        return MetricsList ;
    }
    
    Public List<SelectOption> getAccountNames1(){
   return AccountNames1 ;
   }
       Public Void SelectContact(){
    try{
     account = [SELECT Name,
                  (SELECT Contact.Name, Contact.Email FROM Account.Contacts)
                   FROM Account
                   WHERE Name =:SelectedSupplier];
                  for(Contact temp : AccountNames)  {  
                   AccountNames1.add(new SelectOption(temp.Email,temp.Email));
                   //system.assertequals(account.Contacts[0].Email,null);
                   }}
                   catch(Exception e){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Contact Not Present for Selected Supplier');
                     ApexPages.addMessage(myMsg );
                   }
    }
    Public PageReference Calendar(){
        url=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        url='/apex/SSC_Calendar';
        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
    
    Public PageReference RedirectScoringGuides(){
        String key = '0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnc';

        url=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;
        url='/apex/SSC_AllScoringGuides';
        PageReference Redirect= new PageReference(url);
        return Redirect;

    }
    
    Public void closePopup()
    {
        displayPopup = false;
        Rawdata();
    }
    
    Public void showPopup()
    {
        displayPopup = true;
    }
     Public void closePopup1(){
        DisplayPopup1 = false;
       
    }
       Public PageReference showPopup1(){
      supplierName = System.currentPageReference().getParameters().get('Supplier ID');
        Month=System.currentPageReference().getParameters().get('Month');
        Year=System.currentPageReference().getParameters().get('Year');
        SelectedSupplier=System.currentPageReference().getParameters().get('Supplier Name');
        ScoreCard_Type =System.currentPageReference().getParameters().get('ScoreCard Type');
        Dates=System.currentPageReference().getParameters().get('Generation Date');
        String url2=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        url2= url2+'/apex/SSC_SendEmailHistory?'+'Supplier ID='+supplierName+'&' +'Month='+Month+'&'+'Year='+Year+'&'+'ScoreCard Type='+ScoreCard_Type+'&'+'Generation Date='+Dates+'&'+'Supplier Name='+SelectedSupplier;

        PageReference RedirectLevel2Page= new PageReference(url2);
        return RedirectLevel2Page;
   
    }
    Public void getSave() {

    }
    
    
    Public List<SSC_SubMetric__c> getCurrentL3SubMetricsList() {
        return CurrentL3SubMetricsList;
    }
    
    Public PageReference RedirectLevel2()
    {
        supplierName = System.currentPageReference().getParameters().get('Supplier ID');

        Month=System.currentPageReference().getParameters().get('Month');
        Year=System.currentPageReference().getParameters().get('Year');
        ScoreCard_Type =System.currentPageReference().getParameters().get('ScoreCard Type');

        Dates=System.currentPageReference().getParameters().get('Generation Date');
        String url2=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;
        url2= url2+'/apex/SSC_DMScorecardHistory_Level2?'+'Supplier ID='+supplierName+'&' +'Month='+Month+'&'+'Year='+Year+'&'+'ScoreCard Type='+ScoreCard_Type+'&'+'Generation Date='+Dates+'&Supplier Name='+selectedsupplier;

        PageReference RedirectLevel2Page= new PageReference(url2);
        return RedirectLevel2Page;
    }
    
    Public PageReference RedirectLevel3()
    {
        supplierName = System.currentPageReference().getParameters().get('Supplier ID');

        Month=System.currentPageReference().getParameters().get('Month');
        Year=System.currentPageReference().getParameters().get('Year');
        ScoreCard_Type =System.currentPageReference().getParameters().get('ScoreCard Type');

        Dates=System.currentPageReference().getParameters().get('Generation Date');
        String url2=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;
        url2= url2+'/apex/SSC_DMScorecardHistory_Level3?'+'Supplier ID='+supplierName+'&' +'Month='+Month+'&'+'Year='+Year+'&'+'ScoreCard Type='+ScoreCard_Type+'&'+'Generation Date='+Dates+'&Supplier Name='+selectedsupplier;

         PageReference RedirectLevel2Page= new PageReference(url2);
        return RedirectLevel2Page;
    }
    
    Public List<SSC_SubMetric__c> getSubmetric() {
        return submetricInnovation;

    }
    
    Public List<SSC_SubMetric__c> getMetrics() {
        return Metrics;
    }
    
    Public List<SSC_PriorQuarterScore__c>  getCurrentQtrScores() {
        return CurrentQtrScore ;

    }
    
    Public boolean  getVisible()
    {
        return visible;
    }
    
    Public PageReference sendPdf()
    {
            if(SelectedAccount=='NONE') 
        {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please Select the Contact from the List '));
        }
        visible = true;
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        email = SelectedAccount;
        PageReference pdf = Page.SSC_DM_ScoreCard_pdf_History;

        Blob body;
        try {
            // returns the output of the page as a PDF
            body = pdf.getContent();     // need to pass unit test -- current bug
        }
        catch (VisualforceException e)       {

            body = Blob.valueOf('Some Text');
        }
        Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.setContentType('application/pdf');
        attach.setFileName('DM Scorecard.pdf');

        attach.setInline(true);
        attach.Body = body;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setUseSignature(true);
        mail.setToAddresses(new String[] {

            email,Activeuser.Email
        }
        );
        mail.setSubject('Your Scorecard');
        mail.setHtmlBody('<html><body>Hello '+ SelectedSupplier+',<br><br> Please find your '+ CurrentMonth1+' '+ CurrentYear1 +' Scorecard. <br><br> Thanks,<br><br>Motorola Procurement Team</html></body>');
        
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {
            attach
        }
        );
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
            mail
        }

        );
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email with PDF sent to '+email));
        email=null;
        visible=false;

        return null;
    }
    
    Public PageReference Rawdata(){
        String key = '0AiHwFohvc_vqdEhjb1RNZ0kta3RQc0NPZGdGSGlvVnc';
        url='https://docs.google.com/a/motorola.com/spreadsheet/ccc?key='+FileIds[0].File_ID__c+'&usp=drive_web#gid=0';

        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
    
    Public PageReference Rawdata2(){
        url='https://docs.google.com/a/motorola.com/spreadsheet/ccc?key='+FileIds[1].File_ID__c+'&usp=drive_web#gid=0';

        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
    
     Public PageReference Rawdata3(){
        url='https://docs.google.com/a/motorola.com/spreadsheet/ccc?key='+FileIds[2].File_ID__c+'&usp=drive_web#gid=0';

        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
    Public List<SSC_L3SubMetric__c> getL3MetricListTemp () {
        return L3MetricListTemp ;
    }
    

    Public  Map<String, Double>  getMetricScoreMap() {
        return MetricScoreMap;
    }
    
    Public wrapperclass getWrapperObject() {
        wrapperclass TempWrapperObject = new wrapperclass (mapToScore,mapToAccount,MetricsList,CurrentL3SubMetricsList,CurrentSubMetricsList,CurrentMetricsList,MetricScoreMap,SubMetricScoreMap ,L3SubMetricScoreMap ,MapMetricList,MapSubMetricList,MetricListTemp,MapL3SubMetricList,col,PreviousColor,PreviousMetricColor,PreviousSubMetricColor,PreviousL3SubMetricColor,L3SubMetricColor,SubMetricColor,MetricColor);

        return TempWrapperObject ;
    }
    
    Public Map<String, Double> getCurrentScore()
    {
        return mapToScore;
    }
    
    Public class wrapperclass{
        Public Map<String,String> PreviousColor= new Map<String,string>();

        Public Map<String,String> PreviousMetricColor= new Map<String,string>();
        Public Map<String,String> PreviousSubMetricColor= new Map<String,string>();
        Public Map<String,String> PreviousL3SubMetricColor= new Map<String,string>();

        Public Map<String,String> L3SubMetricColor= new Map<String,string>();
        Public Map<String,String> SubMetricColor= new Map<String,string>();
        Public Map<String,String> MetricColor= new Map<String,string>();

        Public List<SSC_L3SubMetric__c> Temp1 = new List<SSC_L3SubMetric__c>();
        Public  List<SSC_L3SubMetric__c>  MetricListTemp= new  List<SSC_L3SubMetric__c> ();
        Public Map<String, List< SSC_PriorQuarterScore__c> >map1 =new Map<String, List< SSC_PriorQuarterScore__c>>() ;

        Public List<SSC_Metric__c> MetricsList= new List<SSC_Metric__c>();
        Public List<SSC_SubMetric__c> CurrentL3SubMetricsList= new List<SSC_SubMetric__c>();
        Public List<SSC_SubMetric__c> CurrentSubMetricsList= new List<SSC_SubMetric__c>();

        Public List<SSC_PriorQuarterScore__c> CurrentMetricsList= new List<SSC_PriorQuarterScore__c>();
        Public Map<String, List< SSC_PriorQuarterScore__c> > mapToAccount = new Map<String,List< SSC_PriorQuarterScore__c> >();

        Public Map<String, List< SSC_PriorQuarterScore__c> > MapSubMetricList = new Map<String,List< SSC_PriorQuarterScore__c> >();
        Public Map<String, List< SSC_PriorQuarterScore__c> > MapL3SubMetricList = new Map<String,List< SSC_PriorQuarterScore__c> >();

        Public Map<String,String> col = new Map<String,String> ();
        Public Map<String, Double> mapToScore= new Map<String,Double>();
        Public Map<String, List< SSC_PriorQuarterScore__c> > MapMetricList = new Map<String,List< SSC_PriorQuarterScore__c> >();

        Public Map<String, Double> MetricScoreMap= new Map<String,Double>();
        Public Map<String, Double> SubMetricScoreMap = new Map<String,Double>();
        Public Map<String, Double> L3SubMetricScoreMap = new Map<String,Double>();

        Public wrapperclass(Map<String, Double> mapToScore, Map<String, List< SSC_PriorQuarterScore__c> > mapToAccount,List<SSC_Metric__c> MetricsList,List<SSC_SubMetric__c> CurrentL3SubMetricsList,List<SSC_SubMetric__c> CurrentSubMetricsList,List<SSC_PriorQuarterScore__c> CurrentMetricsList,Map<String, Double> MetricScoreMap, Map<String, Double> SubMetricScoreMap ,Map<String, Double> L3SubMetricScoreMap  ,Map<String, List< SSC_PriorQuarterScore__c> > MapMetricList,Map<String, List< SSC_PriorQuarterScore__c> > MapSubMetricList, List<SSC_L3SubMetric__c> MetricListTemp, Map<String, List< SSC_PriorQuarterScore__c> > MapL3SubMetricList ,Map<String,String> col,Map<String,String> PreviousColor,Map<String,String> PreviousMetricColor,Map<String,String> PreviousSubMetricColor,Map<String,String> PreviousL3SubMetricColor,Map<String,String> L3SubMetricColor,Map<String,String> SubMetricColor,Map<String,String> MetricColor){

            this.PreviousColor=PreviousColor;
            this.PreviousMetricColor=PreviousMetricColor;
            this.PreviousSubMetricColor=PreviousSubMetricColor;
            this.PreviousL3SubMetricColor=PreviousL3SubMetricColor;

            this.L3SubMetricColor=L3SubMetricColor;
            this.SubMetricColor=SubMetricColor;
            this.MetricColor=MetricColor;
            this.MetricsList= (MetricsList);
            this.CurrentL3SubMetricsList= (CurrentL3SubMetricsList);

            this.CurrentSubMetricsList= (CurrentSubMetricsList);
            this.CurrentMetricsList= (CurrentMetricsList);
            this.MetricListTemp= (MetricListTemp);
            this.mapToAccount=mapToAccount;

            this.mapToScore=mapToScore;
            this.MapMetricList=MapMetricList;
            this.MapSubMetricList=MapSubMetricList;
            this.MapL3SubMetricList=MapL3SubMetricList;
            this.MetricScoreMap=MetricScoreMap;

            this.SubMetricScoreMap =SubMetricScoreMap ;
            this.L3SubMetricScoreMap =L3SubMetricScoreMap ;
            this.col=col;
            this.Temp1 = [Select SSC_SubMetric__r.Name from SSC_L3SubMetric__c ];

        }
    
        Public List<SSC_Metric__c> getMetricsList()
        {
            return MetricsList;
        }
    
        Public List<SSC_SubMetric__c> getCurrentL3SubMetricsList()

        {
            return CurrentL3SubMetricsList;
        }
    
        Public List<SSC_SubMetric__c> getCurrentSubMetricsList()
        {
            return CurrentSubMetricsList;
        }

    
        Public List<SSC_PriorQuarterScore__c> getCurrentMetricsList()
        {
            return CurrentMetricsList;
        }
    
        Public Map<String, List< SSC_PriorQuarterScore__c> > getCurrentScoringGuide()

        {
            mapToAccount.remove('Overall');
            return mapToAccount;
        }
    
        Public Map<String, List< SSC_PriorQuarterScore__c> > getMapSubMetricList()

        {
            return MapSubMetricList;
        }
    
        Public Map<String, List< SSC_PriorQuarterScore__c> > getMapL3SubMetricList()
        {
            return MapL3SubMetricList;

        }
    
        Public List<SSC_L3SubMetric__c>   getMetricListTemp()
        {
            return MetricListTemp;
        }
    
        Public Map<String, Double> getCurrentScore()

        {
            return mapToScore;
        }
    
        Public Map<String, List< SSC_PriorQuarterScore__c> > getMetricsList7()
        {
            return MapMetricList;
        }

    
        Public Map<String, Double> getMetricScoreMap()
        {
            return MetricScoreMap;
        }
    
        Public Map<String, Double> getSubMetricScoreMap ()
        {

            return SubMetricScoreMap ;
        }
    
        Public Map<String, Double> getL3SubMetricScoreMap ()
        {
            return L3SubMetricScoreMap ;
        }
    
        Public Map<String,String> getcolor()

        {
            return col;
        }
    
        Public Map<String,String> getPreviousColor()
        {
            return PreviousColor;
        }
    
        Public Map<String,String> getPreviousMetricColor()

        {
            return PreviousMetricColor;
        }
    
        Public Map<String,String> getPreviousL3SubMetricColor()
        {
            return PreviousL3SubMetricColor;
        }

    
        Public Map<String,String> getL3SubMetricColor()
        {
            return L3SubMetricColor;
        }
    
        Public Map<String,String> getSubMetricColor()
        {

            return SubMetricColor;
        }
    
        Public Map<String,String> getMetricColor()
        {
            return MetricColor;
        }
    
        Public Map<String,String> getPreviousSubMetricColor()

        {
            Set <String> colorSet = new Set<String>();
            colorSet = PreviousMetricColor.keySet();
            for( string TempString : colorSet)
            {
                Boolean contains =    PreviousSubMetricColor.containsKey(TempString);

                if (contains==false)
                PreviousSubMetricColor.put(TempString,'');
            }
            return PreviousSubMetricColor;
        }
    }
}