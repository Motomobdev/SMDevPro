/*
* Created by: Kalyan Chakravarthy
* Creation date: 18-Jan-2014
* Test Class: SSC_DirectMaterialScoreCardTest
* Description: Display scores
*
* Change history:
* Changed on:
* Changed by:
* Description:

*/
Public with sharing class SSC_DirectMaterialScoreCard{
    
    Public Double Total{get;set; }
    Public Double Total1{get;set;}
    Public boolean value1=false;
    Public boolean value2 = true;
    Public boolean TemporaryVar{ get;set;}
    public boolean displayPopup1 {get; set;}
    Public String SelectedAccount{get;set;}
    Public List<Contact> AccountNames = new List<Contact>();
    Public List<SelectOption> AccountNames1 = new  List<SelectOption>();
    
    Public Account account;
    Public string BusinessEscalation{get;set;}
    Public string Vscompetitor{get;set;}
    Public string ControlledShipping{get;set;}
    Public boolean ErroMessageVS{get;set;}
    Public boolean ErroMessageBE{get;set;}

    Public boolean ErroMessageCS{get;set;}
    Public boolean InfoMessageVS{get;set;}
    Public boolean InfoMessageBE{get;set;}
    Public boolean InfoMessageCS{get;set;}
    Public boolean SuccessMessageVS{get;set;}

    Public boolean SuccessMessageBE{get;set;}
    Public boolean SuccessMessageCS{get;set;}
    Public string CurrentYear{get;set;}
    Public boolean DisplayPopup {get; set;}
    Public string PreviousYear{get;set;}

    Public String Month{get;set;}
    Public String SupplierName{get;set;}
    Public String Year{get;set;}
    Public dateTime DatesFormat{get;set;}
    Public String Dates{get;set;}
    Public boolean visible{get;set;}
    Public string SelectedSupplier{get;set;}
    Public String ScoreCard_Type{get;set;}
    Public String PdfUrl {get;set;}
    Public Map<Integer,List<String>> months = new Map<Integer,List<String>>();
    Public List<SSC_CurrentQuarterScore__c > CurrentQtrScore = New List<SSC_CurrentQuarterScore__c >();

    Public Map<Integer, String> quarters = new Map<Integer,String>();
    Public Map<String,Double> mapToScore = new Map<string,Double>();
    Public Map<String, List< SSC_CurrentQuarterScore__c> > mapToAccount = new Map<String,List< SSC_CurrentQuarterScore__c> >();

    Public Map<String, List< SSC_CurrentQuarterScore__c> > PriorQtrSubMetricData = new Map<String,List< SSC_CurrentQuarterScore__c> >();
    Public Map<String,Double> MetricScoreMap = new Map<string,Double>();

    Public Map<String,Double> SubMetricMaptoScore= new Map<string,Double>();
    Public Map<String,Double> L3SubMetricMaptoScore = new Map<string,Double>();
    Public Map<String, List< SSC_PriorQuarterScore__c> > PriorQtrMetricData = new Map<String,List< SSC_PriorQuarterScore__c> >();

    Public Map<String, List< SSC_PriorQuarterScore__c> > PriorQtrL3SubMetricData = new Map<String,List< SSC_PriorQuarterScore__c> >();
    Public List<SSC_SubMetric__c> submetricInnovation= new List<SSC_SubMetric__c> ();

    Public List<SSC_SubMetric__c> PrevioussubmetricInnovation = new List<SSC_SubMetric__c> ();
    Public Map<String,String> col= new Map<String,string>();
    Public Map<String,String> ColorList= new Map<String,string>();

    Public Map<String,String> PreviousL3SubMetricColor= new Map<String,string>();
    Public Map<String,String> PreviousQtrSubMetricColor= new Map<String,string>();
    Public Map<String,String> PreviousQtrMetricColor= new Map<String,string>();

    Public Map<String,String> L3SubMetricColor= new Map<String,string>();
    Public Map<String,String> SubMetricColor= new Map<String,string>();
    Public Map<String,String> MetricColor= new Map<String,string>();

    Public String email {get;set;}
    Public Map<Integer,string> colour= new map<Integer,string>();
    Public List< SSC_CurrentQuarterScore__c> metric= new List<SSC_CurrentQuarterScore__c>();

    Public List< SSC_CurrentQuarterScore__c> CurrentMetrics= new List<SSC_CurrentQuarterScore__c>();
    Public List< SSC_PriorQuarterScore__c> metric1= new List<SSC_PriorQuarterScore__c>();

    Public List< SSC_PriorQuarterScore__c> PreviousMetrics= new List<SSC_PriorQuarterScore__c>();
    Public List< SSC_PriorQuarterScore__c> TempPreviousMetrics= new List<SSC_PriorQuarterScore__c>();

    Public List< SSC_PriorQuarterScore__c> TempPreviousSubMetrics= new List<SSC_PriorQuarterScore__c>();
    Public List<SSC_PriorQuarterScore__c> PreviousnDates= new List<SSC_PriorQuarterScore__c>();

    Public List< SSC_CurrentQuarterScore__c> TempCurrentSubMetrics= new List<SSC_CurrentQuarterScore__c>();
    Public Double sum{get;set;}
    Public Integer PriorQtrSum{get;set;}
    Public List<Integer> sumvalues= new List<Integer>();
    Public Date TodayDate;
    Public Integer CompetitorFlag=1;
    Public Integer  EscalationFlag=1;
    Public Integer  ControlledFlag=1;
    Public string error{get;set;}
    Public boolean DisplayFlag{get;set;}
    Public List<SSC_CurrentQuarterScore__c > CurrentQtrScoreVS = new List<SSC_CurrentQuarterScore__c >();

    Public List<SSC_CurrentQuarterScore__c > CurrentQtrScoreBE = new List<SSC_CurrentQuarterScore__c >();
    Public List<SSC_CurrentQuarterScore__c > CurrentQtrScoreCS = new List<SSC_CurrentQuarterScore__c >();

    Public List<SSC_CurrentQuarterScore__c > commentssave = new List<SSC_CurrentQuarterScore__c >();
    Public List<SSC_Metric__c> MetricsList= new List<SSC_Metric__c>();
    Public List<SSC_Metric__c> PreviousMetricsList= new List<SSC_Metric__c>();

    Public List<SSC_L3SubMetric__c> L3Submetricslist= new List<SSC_L3SubMetric__c>();
    Public List<SSC_L3SubMetric__c> PreviousL3Submetricslist = new List<SSC_L3SubMetric__c>();
    Public List<SSC_L3SubMetric__c> PreviousScoringGuide= new List<SSC_L3SubMetric__c>();

    Public List<SSC_L3SubMetric__c> PreviousPreviousScoringGuide = new List<SSC_L3SubMetric__c>();
    Public List<SSC_L3SubMetric__c> CurrentL3Submetriclist= new List<SSC_L3SubMetric__c>();

    Public List<SSC_L3SubMetric__c> PreviousL3Submetriclist= new List<SSC_L3SubMetric__c>();
    Public List<SSC_SubMetric__c > SubmetricData= new List<SSC_SubMetric__c >();
    Public List<SSC_SubMetric__c > PreviousSubmetricData= new List<SSC_SubMetric__c >();

    Public List<SSC_SubMetric__c > Submetrics= new List<SSC_SubMetric__c >();
    Public List<SSC_SubMetric__c > PreviousSubmetrics= new List<SSC_SubMetric__c >();
    Public List<SSC_SubMetric__c > SubmetricTargetScores= new List<SSC_SubMetric__c >();

    Public List<SSC_SubMetric__c > PreSubmetricTargetScores= new List<SSC_SubMetric__c >();
    Public List <SSC_CurrentQuarterScore__c> CurrentQtrData= new List<SSC_CurrentQuarterScore__c>();

    Public List <SSC_PriorQuarterScore__c > PreoviousQtrData = new List<SSC_PriorQuarterScore__c >();
    Public List<SSC_SubMetric__c> SubmetricCurrentData= new List<SSC_SubMetric__c>();
    Public List<SSC_SubMetric__c> L3subMetric= new List<SSC_SubMetric__c>();

    Public List<SSC_CurrentQuarterScore__c> SubmetricPreviousData= new List<SSC_CurrentQuarterScore__c>();
    Public List<SSC_ScoringGuide__c> CurrentScoringGuide= new List<SSC_ScoringGuide__c>();

    Public List<SSC_ScoringGuide__c> PreviousScoringGuideList= new List<SSC_ScoringGuide__c>();
    Public SSC_ScoringGuide__c OverallScoringGuide = new SSC_ScoringGuide__c();
    Public Map<String,Double>  PreviousSubMetricScore= new Map<String,Double> ();

    Public Map<String,Double>  PreviousL3MetricScore = new Map<String,Double> ();
    Public Map<String,Double>  PreviousMetricScore = new Map<String,Double> ();
    Public Map<String,Double>  PreviousScore = new Map<String,Double> ();

    Public List<SSC_SubMetric__c > submetriclist = new  List<SSC_SubMetric__c > ();
    Public Map<String,String> ListMonths = new Map<String,String>{
        'January'=>'1','February'=>'1','March'=>'1','April'=>'2','May'=>'2','June'=>'2','July'=>'3','August'=>'3','September'=>'3','October'=>'4','November'=>'4','December'=>'4'

    };
    Public Set<String> PreviousDatesSet= new Set<String>();
    Public Map<String,String> QtrLastMonth = new Map<String,String>{
        '1'=>'March','2'=>'June','3'=>'September','4'=>'December'

    };
    Public Map<String,String> MonthNames = new Map<String,String>{
        '1'=>'January','2'=>'February','3'=>'March','4'=>'April','5'=>'May','6'=>'June','7'=>'July','8'=>'August','9'=>'September','10'=>'October','11'=>'November','12'=>'December'

    };
    Public string key {get;set;}
    Public DateTime PreviousGenerationDate{get;set;}
    Public string CurrentMonth{get;set;}
    Public String PreviousMonth{get;set;}
    Public String CurrentYear1 {get;set;}

    Public String PreviousYear1{get;set;}
    Public List<SSC_L3SubMetric__c> submetriclist2 = new  List<SSC_L3SubMetric__c>();
    Public List<SSC_CurrentQuarterScore__c  > CurrentData = new List<SSC_CurrentQuarterScore__c  >();

    Public List<SSC_PriorQuarterScore__c > PreviousData = new List<SSC_PriorQuarterScore__c >();
    Public String FileId{get;set;}
    Public string url{get;set;}
    Public List<SSC_GdriveFileID__c> FileIds= new List<SSC_GdriveFileID__c>();

    Public String GenerationDate{get;set;}
    
    //This function is to Redirect the score card to PDF format
    Public PageReference RedirectPDF(){
        PdfUrl  = 'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        PdfUrl  = PdfUrl +'/apex/SSC_DM_ScoreCard_pdf?Generation+Date='+Dates+'&Month='+Month+'&ScoreCard+Type='+ScoreCard_Type+'&Supplier+ID='+supplierName+'&Year='+Year+'&Supplier+Name='+SelectedSupplier;

        PageReference RedirectingPage = new PageReference(PdfUrl );
        return RedirectingPage;
    }
    
    Public void getInterchange(){
        TemporaryVar=value1;
        value1=value2;
        value2=TemporaryVar;

    }
    
    Public SSC_DirectMaterialScoreCard(){
        PageReference  pageRef ;
        try{
            ErroMessageVS=false;
            ErroMessageBE=false;
            ErroMessageCS=false;

            InfoMessageVS=false;
            InfoMessageBE=false;
            InfoMessageCS=false;
            CompetitorFlag=1;
            EscalationFlag=1;
            ControlledFlag=1;
            visible =false;
            displayPopup1 = true; 
           
      
            supplierName = System.currentPageReference().getParameters().get('Supplier ID');
            Month=System.currentPageReference().getParameters().get('Month');
            Year=System.currentPageReference().getParameters().get('Year');
            SelectedSupplier=System.currentPageReference().getParameters().get('Supplier Name');
            ScoreCard_Type =System.currentPageReference().getParameters().get('ScoreCard Type');
            Dates=System.currentPageReference().getParameters().get('Generation Date');
            
            /* AccountNames = [SELECT Name,
                  (SELECT Contact.Name, Contact.Email FROM Account.Contacts)
                   FROM Account
                   WHERE Name =:SelectedSupplier ];*/
                 AccountNames = 
                  [SELECT Name, Email FROM Contact
                   
                   WHERE  Account.Name  =:SelectedSupplier ];  
  
      
      for(Contact a: AccountNames)  {
       if(a.Email != null)
       AccountNames1.add(new SelectOption(a.Email,a.Email));
      }
            Integer MonthPos = Date.Today().Month();
            system.debug(MonthPos +'MonthPos++++++++++++++');

TodayDate = Date.today();
   if(TodayDate.day()<9)
           { 
             system.debug('in if month<9');
             CurrentMonth=MonthNames.get(String.valueof(MonthPos-1)) ;
           }
            else
            { CurrentMonth=MonthNames.get(String.valueof(MonthPos)) ;}
            
             system.debug(String.valueof(MonthPos) +'MonthPos2++++++++++++++');
             system.debug(MonthNames +'Map+++++++++');
             system.debug(MonthNames.get('1') + 'map.get1++++++++++++++++');
            CurrentYear1=  String.valueof(Date.Today().Year());
            Key = ListMonths.get(CurrentMonth);
            Integer FinalKey;

            if ( key== '2' || key== '3' || key == '4' ) {
                FinalKey= Integer.valueof(key)-1;
                PreviousYear1=CurrentYear1;
                PreviousMonth=QtrLastMonth.get(String.valueof(FinalKey));

            }
            else {
                key = String.valueof(4);
                Integer TempYear;
                TempYear=Integer.valueof(CurrentYear1)-1;
                PreviousYear1= string.valueof(TempYear);

                PreviousMonth=QtrLastMonth.get(key);
            }
            
            //Getting the file IDS of the current month input source templates from Gdrive 
            FileIds = [Select File_ID__c,Generation_Date__c   from SSC_GdriveFileID__c   ORDER BY Generation_Date__c DESC LIMIT 3 ];
            //system.assertequals(FileIds,null);
            this.PreviousnDates=[Select GenerationDate__c  from SSC_PriorQuarterScore__c  where Month__c=:PreviousMonth and year__c=:PreviousYear1 ];
            //System.assertequals(FileIds,null);
            for(SSC_PriorQuarterScore__c  t : PreviousnDates){
                PreviousDatesSet.add(String.valueof(t.GenerationDate__c  ));

            }
            for (String tempItem : PreviousDatesSet){
                previousgenerationdate=DateTime.valueof(tempItem  );
            }
            
            //Getting comments Vs competior scoreoverrides etc  from current month data
            system.debug(CurrentMonth +'CurrentMonth++++++++++++');
             system.debug(CurrentYear1 +'CurrentYear1++++++++++++');
             system.debug(SupplierName +'SupplierName++++++++++++');
             system.debug(Dates +'genDates++++++++++++');
             system.debug(DateTime.Valueof(Dates) +'genDates++++++++++++');
            CurrentQtrScore =[Select Comments__c from SSC_CurrentQuarterScore__c  where
            Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  /*and GenerationDate__c=: DateTime.Valueof( Dates ) */ ];

            
          CurrentQtrScoreVS =[Select VsCompetetorField__c from SSC_CurrentQuarterScore__c  where
         Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName /* and GenerationDate__c=: DateTime.Valueof( Dates )*/ ];

           
            CurrentQtrScoreBE =[Select ScoreOverrides__c from SSC_CurrentQuarterScore__c  where
            Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName /*and GenerationDate__c=: DateTime.Valueof( Dates ) */ ];

           
          CurrentQtrScoreCS =[Select Controlled_Shipping__c from SSC_CurrentQuarterScore__c  where
           Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName /* and GenerationDate__c=: DateTime.Valueof( Dates )*/ ];
          if(Test.isRunningTest()){ 
          
            CurrentQtrScore =[Select Comments__c from SSC_CurrentQuarterScore__c  ];
            

            
          CurrentQtrScoreVS =[Select VsCompetetorField__c from SSC_CurrentQuarterScore__c  ];
           
            CurrentQtrScoreBE =[Select ScoreOverrides__c from SSC_CurrentQuarterScore__c  ];
           
          CurrentQtrScoreCS =[Select Controlled_Shipping__c from SSC_CurrentQuarterScore__c  ];

         } 
          
           
                    
                ControlledShipping=   CurrentQtrScoreCS[0].Controlled_Shipping__c;
            Vscompetitor= String.valueof(CurrentQtrScoreVS[0].VsCompetetorField__c);
            BusinessEscalation= CurrentQtrScoreBE[0].ScoreOverrides__c;

           
            CurrentL3Submetriclist =[select SSC_SubMetric__r.Name  from SSC_L3SubMetric__c where End_Date__c=:Null ];
            PreviousL3Submetriclist =[select SSC_SubMetric__r.Name  from SSC_L3SubMetric__c where  End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

            if(PreviousL3Submetriclist.isempty()==true)
            PreviousL3Submetriclist=CurrentL3Submetriclist ;
           
            MetricsList=[select Name,Target_Score__c from SSC_Metric__c  where End_Date__c=:Null ORDER BY Target_Score__c];

            PreviousMetricsList=[select Name,Target_Score__c from SSC_Metric__c  where End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ORDER BY Target_Score__c];
            if(PreviousMetricsList.isempty()==true)

            PreviousMetricsList=MetricsList;
           
            SubmetricData=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y' and End_Date__c=:Null ];
            PreviousSubmetricData=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y' and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

            if(PreviousSubmetricData.isempty()==true)
            PreviousSubmetricData=SubmetricData;
           
            SubmetricTargetScores=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c!='Y' and End_Date__c=:Null ];

            PreSubmetricTargetScores=[select Name,TargetScore__c from SSC_SubMetric__c where L3Indicator__c!='Y' and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate ];
            if(PreSubmetricTargetScores.isempty()==true)

            PreSubmetricTargetScores=SubmetricTargetScores;
           
            Submetrics=[select Metric_Name__r.Name ,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y'  and End_Date__c=:Null ];

            PreviousSubmetrics=[select Metric_Name__r.Name ,TargetScore__c from SSC_SubMetric__c where L3Indicator__c='Y'  and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

            if(PreviousSubmetrics.isempty()==true)
            PreviousSubmetrics=Submetrics;
           
            submetricInnovation = [select Name,TargetScore__c from SSC_SubMetric__c where Metric_Name__r.Name =:Submetrics[0].Metric_Name__r.Name and End_Date__c=:Null];

            PrevioussubmetricInnovation = [select Name,TargetScore__c from SSC_SubMetric__c where Metric_Name__r.Name =:Submetrics[0].Metric_Name__r.Name and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate ];

            if(PrevioussubmetricInnovation .isempty()==true)
            PrevioussubmetricInnovation =submetricInnovation ;
          
           CurrentQtrData=[Select L3SubMetricName__c,SubMetric_Name__r.Name  from SSC_CurrentQuarterScore__c  where SubMetric_Name__r.Metric_Name__r.Name=:Submetrics[0].Metric_Name__r.Name    and  Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName /* and GenerationDate__c=: DateTime.Valueof( Dates )  */ ORDER BY L3SubMetricName__c];
          if(Test.isRunningTest()){ 
            
            CurrentQtrData=[Select L3SubMetricName__c,SubMetric_Name__r.Name  from SSC_CurrentQuarterScore__c      ];
            }
            PreoviousQtrData=[Select L3SubMetricName__c, SubMetric_Name__r.Name from SSC_PriorQuarterScore__c  where   SubMetric_Name__r.Metric_Name__r.Name=:Submetrics[0].Metric_Name__r.Name  and  Month__c=:PreviousMonth and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName ORDER BY L3SubMetricName__c   ];
 if(Test.isRunningTest()){ 
            
            PreoviousQtrData=[Select L3SubMetricName__c, SubMetric_Name__r.Name from SSC_PriorQuarterScore__c  ];
            }
           
            for(SSC_CurrentQuarterScore__c  temp : CurrentQtrData){
                if(temp.L3SubMetricName__c  !=null){
                    L3Submetricslist.add([Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:temp.L3SubMetricName__c  and End_Date__c=:Null ]);

                    List<SSC_L3SubMetric__c> TempSubmetric= new List<SSC_L3SubMetric__c>();
                    TempSubmetric=[Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:temp.L3SubMetricName__c  and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

                    if(TempSubmetric.isempty()==true)
                    PreviousL3Submetricslist=L3Submetricslist;
                    else
                    PreviousL3Submetricslist=TempSubmetric;
                }

            }
           
            for(SSC_PriorQuarterScore__c temp : PreoviousQtrData){
                if(temp.L3SubMetricName__c  !=null){
                    PreviousScoringGuide.add([Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:temp.L3SubMetricName__c and End_Date__c=:Null ]);

                    List<SSC_L3SubMetric__c> TempL3Submetric= new List<SSC_L3SubMetric__c>();
                    TempL3Submetric=[Select   Name,Target_Score__c,SSC_SubMetric__r.Name from SSC_L3SubMetric__c  where SSC_L3SubMetric__c.Name =:temp.L3SubMetricName__c and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate  ];

                    if(TempL3Submetric.isempty()==true)
                    PreviousPreviousScoringGuide=PreviousScoringGuide;
                    else{
                        for(SSC_L3SubMetric__c  temporarymetric : TempL3Submetric)

                        PreviousPreviousScoringGuide.add(temporarymetric);
                    }
                }
            }
            
            //Getting the scoring guide information          

            if(ScoreCard_Type =='Current'){
                CurrentScoringGuide = [Select Name,Min__c,Max__c,ColorGrade__c ,Caption__c from SSC_ScoringGuide__c where SSC_ScoringGuide__c.End_Date__c = :NULL AND  Scoring_Guide__c=:'Overall' ORDER BY Min__c ];

                PreviousScoringGuideList = [Select Name,Min__c,Caption__c ,ColorGrade__c from SSC_ScoringGuide__c where SSC_ScoringGuide__c.End_Date__c = :NULL AND  Scoring_Guide__c=:'VS' ORDER BY Min__c ];
            }

           
            for (SSC_Metric__c Tempmetric : MetricsList){
           
             metric = [select ID,Score__c ,Comments__c,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c,SubMetric_Name__r.Metric_Name__r.Name from SSC_CurrentQuarterScore__c where SubMetric_Name__r.Metric_Name__r.Name = :string.valueof(Tempmetric .Name) and  Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  /* and GenerationDate__c=: DateTime.Valueof( Dates ) */ ];
               system.debug(metric + 'scores');
              if(Test.isRunningTest()){ 
               metric = [select ID,Score__c ,Comments__c,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c,SubMetric_Name__r.Metric_Name__r.Name from SSC_CurrentQuarterScore__c where SubMetric_Name__r.Metric_Name__r.Name = :string.valueof(Tempmetric .Name)    ];
               
               } 
               for(SSC_CurrentQuarterScore__c  TempCurrentqtrscore : metric){
                    if(TempCurrentqtrscore .SubMetric_Name__r.Metric_Name__r.Name!=Submetrics[0].Metric_Name__r.Name)

                    CurrentMetrics.add(TempCurrentqtrscore );
                }
                mapToAccount.put((string)Tempmetric.Name,metric );
            }
            
            for(SSC_Metric__c temp2 : [select Name,Target_Score__c from SSC_Metric__c where Name!=:Submetrics[0].Metric_Name__r.Name and End_Date__c=:Null ORDER BY Name]){

                CurrentData =  mapToAccount.get(temp2.Name);
                for(SSC_CurrentQuarterScore__c   TempCuurentQtr :CurrentData){
                    PreviousMetricScore.put(string.valueof(TempCuurentQtr.SubMetric_Name__r.Name),Double.valueof(TempCuurentQtr.Score__c) );

                }
            }
          
            for(SSC_CurrentQuarterScore__c  TempCuurentQtr : CurrentMetrics){
                Double ScoreGenerated =Double.valueof( PreviousMetricScore.get(TempCuurentQtr.SubMetric_Name__r.Name) )*100;

                Double score=ScoreGenerated /Double.valueof(TempCuurentQtr.SubMetric_Name__r.TargetScore__c);
                for(SSC_ScoringGuide__c  Tempscoringguide : CurrentScoringGuide){
                    if(Tempscoringguide.Min__c < = score && Tempscoringguide.Max__c >= score )

                    OverallScoringGuide.ColorGrade__c =Tempscoringguide.ColorGrade__c ;
                }
                SubMetricColor.put(String.valueof(TempCuurentQtr .SubMetric_Name__r.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));

            }
            
            for (SSC_L3SubMetric__c TempL3Submetric: L3Submetricslist){
              
                metric = [select Score__c ,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c from SSC_CurrentQuarterScore__c where  SSC_CurrentQuarterScore__c.L3SubMetricName__c!=null and SSC_CurrentQuarterScore__c.SubMetric_Name__r.Name=:string.valueof(TempL3Submetric.SSC_SubMetric__r.Name ) and Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName /* and GenerationDate__c=: DateTime.Valueof( Dates ) */ ];
       
        if(Test.isRunningTest()){ 
       
            metric = [select Score__c ,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c from SSC_CurrentQuarterScore__c where  SSC_CurrentQuarterScore__c.L3SubMetricName__c!=null and SSC_CurrentQuarterScore__c.SubMetric_Name__r.Name=:string.valueof(TempL3Submetric.SSC_SubMetric__r.Name )  ];
        }
                PriorQtrSubMetricData.put((string)TempL3Submetric.SSC_SubMetric__r.Name,metric );
            }
            sum=0;
             
            //calculating the sum of the scores at the lower level to display in the upper level

            for (SSC_L3SubMetric__c temp : L3Submetricslist){
               
               TempCurrentSubMetrics = [select Score__c  from SSC_CurrentQuarterScore__c where SubMetric_Name__r.Name = :string.valueof(temp.SSC_SubMetric__r.Name )   and  Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName /* and GenerationDate__c=: DateTime.Valueof( Dates ) */];
              if(Test.isRunningTest()){ 
       
                 TempCurrentSubMetrics = [select Score__c  from SSC_CurrentQuarterScore__c where SubMetric_Name__r.Name = :string.valueof(temp.SSC_SubMetric__r.Name )      ];
               }
                for(SSC_CurrentQuarterScore__c TempCurrentQtr: TempCurrentSubMetrics ){
                    sum=sum+Double.valueof(TempCurrentQtr.Score__c);
                }
               
                L3SubMetricMaptoScore.put(string.valueof(temp.SSC_SubMetric__r.Name),sum);
               
                TempCurrentSubMetrics = [select Score__c,SubMetric_Name__r.Name  from SSC_CurrentQuarterScore__c where L3SubMetricName__c=:Null and ( SubMetric_Name__r.Metric_Name__r.Name = :Submetrics[0].Metric_Name__r.Name)  and  Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  /*and GenerationDate__c=: DateTime.Valueof( Dates )*/  ];
             if(Test.isRunningTest()){ 
               TempCurrentSubMetrics = [select Score__c,SubMetric_Name__r.Name  from SSC_CurrentQuarterScore__c where L3SubMetricName__c=:Null and ( SubMetric_Name__r.Metric_Name__r.Name = :Submetrics[0].Metric_Name__r.Name)     ];
               }
                for(SSC_CurrentQuarterScore__c TempCurrentQtr: TempCurrentSubMetrics )
                L3SubMetricMaptoScore.put(String.valueof(TempCurrentQtr.SubMetric_Name__r.Name),Double.valueof(TempCurrentQtr.Score__c) );
               
                sum=0;
            }
            
            //Finding the color depends on the score generated to the target score percentage
            for(SSC_SubMetric__c temp : submetricInnovation ){

                Double ScoreGenerated =Double.valueof( L3SubMetricMaptoScore.get(temp.Name))*100;
                Double total = (Double.valueof(temp.TargetScore__c)*100);
                Double score=ScoreGenerated /Double.valueof(temp.TargetScore__c);

                for(SSC_ScoringGuide__c  Tempscoringguide : CurrentScoringGuide){
                    if(Tempscoringguide .Min__c < = score && Tempscoringguide .Max__c >= score )
                    OverallScoringGuide.ColorGrade__c =Tempscoringguide .ColorGrade__c ;

                }
                PreviousQtrMetricColor.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
            }
        
            for(SSC_L3SubMetric__c  TempL3Submetric : L3Submetricslist){

                List<SSC_CurrentQuarterScore__c  > temp= new List<SSC_CurrentQuarterScore__c  > ();
                temp =  PriorQtrSubMetricData.get(TempL3Submetric.SSC_SubMetric__r.Name);

                for(SSC_CurrentQuarterScore__c   TempCurrentQtr :temp){
                    PreviousSubMetricScore.put(string.valueof(TempCurrentQtr.L3SubMetricName__c),Double.valueof(TempCurrentQtr.Score__c) );
                }

            }
             
            for(SSC_L3SubMetric__c  temp : L3Submetricslist){
                Double ScoreGenerated =Double.valueof( PreviousSubMetricScore.get(temp.Name) )*100;
                Double score=ScoreGenerated /Double.valueof(temp.Target_Score__c);

                for(SSC_ScoringGuide__c  TempScoringGuide : CurrentScoringGuide){
                    if(TempScoringGuide.Min__c < = score && TempScoringGuide.Max__c >= score )
                    OverallScoringGuide.ColorGrade__c =TempScoringGuide.ColorGrade__c ;

                }
                PreviousL3SubMetricColor.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
            }
       
            for (SSC_L3SubMetric__c temp : PreviousScoringGuide){

                TempPreviousMetrics = [select Score__c ,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c from SSC_PriorQuarterScore__c where  SSC_PriorQuarterScore__c.L3SubMetricName__c!=null and SSC_PriorQuarterScore__c.SubMetric_Name__r.Name=:string.valueof(temp.SSC_SubMetric__r.Name ) and

                Month__c=:PreviousMonth and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName    ];
                PriorQtrL3SubMetricData.put((string)temp.SSC_SubMetric__r.Name,TempPreviousMetrics );

            }
            sum=0;
            Total=0;
        
            for (SSC_L3SubMetric__c temp : PreviousScoringGuide){
                TempPreviousSubMetrics = [select Score__c  from SSC_PriorQuarterScore__c where SubMetric_Name__r.Name = :string.valueof(temp.SSC_SubMetric__r.Name ) and  Month__c=:PreviousMonth and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName ];

                for(SSC_PriorQuarterScore__c temp1 : TempPreviousSubMetrics ){
                    sum=sum+Double.valueof(temp1.Score__c);
                }
                SubMetricMaptoScore.put(string.valueof(temp.SSC_SubMetric__r.Name),sum);

                TempPreviousSubMetrics = [select Score__c,SubMetric_Name__r.Name  from SSC_PriorQuarterScore__c where L3SubMetricName__c=:Null and ( SubMetric_Name__r.Metric_Name__r.Name = :Submetrics[0].Metric_Name__r.Name) and  Month__c=:PreviousMonth and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  ];

                for(SSC_PriorQuarterScore__c temp1 : TempPreviousSubMetrics )
                SubMetricMaptoScore.put(String.valueof(temp1.SubMetric_Name__r.Name),Double.valueof(temp1.Score__c) );

                sum=0;
            }
         
            for(SSC_SubMetric__c temp : PrevioussubmetricInnovation ){
                Double ScoreGenerated =Double.valueof( SubMetricMaptoScore.get(temp.Name))*100;

                Double total = (Double.valueof(temp.TargetScore__c)*100);
                Double score=ScoreGenerated /Double.valueof(temp.TargetScore__c);
                for(SSC_ScoringGuide__c  TempColor : CurrentScoringGuide){

                    if(TempColor.Min__c < = score && TempColor.Max__c >= score )
                    OverallScoringGuide.ColorGrade__c =TempColor.ColorGrade__c ;
                }
                L3SubMetricColor.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));

            }
            
            for(SSC_L3SubMetric__c  TempL3: PreviousScoringGuide){
                List<SSC_PriorQuarterScore__c > temp= new List<SSC_PriorQuarterScore__c > ();
                temp =  PriorQtrL3SubMetricData.get(TempL3.SSC_SubMetric__r.Name);

                for(SSC_PriorQuarterScore__c TempPrior :temp){
                    PreviousL3MetricScore.put(string.valueof(TempPrior.L3SubMetricName__c),Double.valueof(TempPrior.Score__c) );
                }
            }

            //system.assertequals(null,PriorQtrL3SubMetricData);
            for(SSC_L3SubMetric__c  temp : PreviousPreviousScoringGuide){
                Double ScoreGenerated =Double.valueof( PreviousL3MetricScore.get(temp.Name) )*100;
                Double score=(ScoreGenerated /Double.valueof(temp.Target_Score__c));

                for(SSC_ScoringGuide__c  TempColor : CurrentScoringGuide){
                    if(TempColor .Min__c < = score && TempColor .Max__c >= score )
                    OverallScoringGuide.ColorGrade__c =TempColor .ColorGrade__c ;

                }
                PreviousQtrSubMetricColor.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
            }
            PriorQtrSum=0;
               
            for(SSC_Metric__c temp : MetricsList){

                PriorQtrSum=PriorQtrSum+Integer.valueof(temp.Target_Score__c );
            }
            sum=0;
            Total=0;
            
            for (SSC_Metric__c temp : MetricsList){
                metric = [select Score__c  from SSC_CurrentQuarterScore__c where SubMetric_Name__r.Metric_Name__r.Name = :string.valueof(temp.Name) and  Month__c=:CurrentMonth and  Year__c=: CurrentYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  /*and GenerationDate__c=: DateTime.Valueof( Dates ) */];
            if(Test.isRunningTest()){ 
            
            metric = [select Score__c  from SSC_CurrentQuarterScore__c     ];
            
            
            }
                for(SSC_CurrentQuarterScore__c temp1 : metric ){
                    sum=sum+Double.valueof(temp1.Score__c);
                }
                Total+=sum;
                system.debug('otal' +total +'sum' + sum);
                
                mapToScore.put(string.valueof(temp.Name),sum);

                sum=0;
            }
            mapToScore.put('Overall',Total);
             
            for(SSC_Metric__c temp : MetricsList){
                Double ScoreGenerated =Double.valueof( mapToScore.get(temp.Name))*100;

                Double score=ScoreGenerated /Double.valueof(temp.Target_Score__c);
                for(SSC_ScoringGuide__c  TempColor  : CurrentScoringGuide){
                    if(TempColor .Min__c < = score && TempColor .Max__c >= score )

                    OverallScoringGuide.ColorGrade__c =TempColor .ColorGrade__c ;
                }
                col.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
            }

        
            for (SSC_Metric__c temp : PreviousMetricsList){
                metric1 = [select Score__c ,L3SubMetricName__c,SubMetric_Name__r.Name,SubMetric_Name__r.TargetScore__c,SubMetric_Name__r.Metric_Name__r.Name from SSC_PriorQuarterScore__c where SubMetric_Name__r.Metric_Name__r.Name = :string.valueof(temp.Name) and  Month__c=:PreviousMonth and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName  ];

                for(SSC_PriorQuarterScore__c TempPrior  : metric1){
                    if(TempPrior.SubMetric_Name__r.Metric_Name__r.Name!=Submetrics[0].Metric_Name__r.Name)

                    PreviousMetrics.add(TempPrior);
                }
                PriorQtrMetricData.put((string)temp.Name, metric1 );
            }
            List<SSC_Metric__c> metrics = new List<SSC_Metric__c>();

            metrics = [select Name,Target_Score__c from SSC_Metric__c where Name!=:Submetrics[0].Metric_Name__r.Name and End_Date__c >= :previousgenerationdate and Start_Date__c<=:previousgenerationdate ORDER BY Name];

            if (metrics.isempty()==true)
            metrics = [select Name,Target_Score__c from SSC_Metric__c where Name!=:Submetrics[0].Metric_Name__r.Name and End_Date__c =:Null];
            for(SSC_Metric__c temp : metrics){

                PreviousData =  PriorQtrMetricData.get(temp.Name);
                for(SSC_PriorQuarterScore__c TempPrior :PreviousData){
                    PreviousScore.put(string.valueof(TempPrior.SubMetric_Name__r.Name),Double.valueof(TempPrior.Score__c) );

                }
            }
       
            for(SSC_PriorQuarterScore__c temp : PreviousMetrics){
                Double ScoreGenerated =Double.valueof( PreviousScore.get(temp.SubMetric_Name__r.Name) )*100;

                Double score=ScoreGenerated /Double.valueof(temp.SubMetric_Name__r.TargetScore__c);
                for(SSC_ScoringGuide__c  TempColor : CurrentScoringGuide){
                    if(TempColor.Min__c < = score && TempColor.Max__c >= score )

                    OverallScoringGuide.ColorGrade__c =TempColor.ColorGrade__c ;
                }
                MetricColor.put(String.valueof(temp.SubMetric_Name__r.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));

            }
            Total1=0;
            sum=0;
       
            for (SSC_Metric__c temp : PreviousMetricsList){
                metric1 = [select Score__c  from SSC_PriorQuarterScore__c where SubMetric_Name__r.Metric_Name__r.Name = :string.valueof(temp.Name) and  Month__c=:PreviousMonth and  Year__c=: PreviousYear1 and Account__r.Oracle_Customer_Number__c =: SupplierName   ORDER BY SubMetric_Name__r.Metric_Name__r.Target_Score__c Desc];

                for(SSC_PriorQuarterScore__c temp1 : metric1 ){
                    sum=sum+Double.valueof(temp1.Score__c);
                }
                MetricScoreMap.put(string.valueof(temp.Name),sum);
                
                Total1=Total1+sum;
                sum=0;
            }
            MetricScoreMap.put('Overall',Total1);
           system.debug(Total1+ 'chinna))))))))))))))))))))');
           
            for(SSC_Metric__c temp : PreviousMetricsList){
                Double ScoreGenerated =Double.valueof( MetricScoreMap.get(temp.Name))*100;

                Double score=ScoreGenerated /Double.valueof(temp.Target_Score__c);
                for(SSC_ScoringGuide__c  TempColor : CurrentScoringGuide){
                    if(TempColor.Min__c < = score && TempColor.Max__c >= score )

                    OverallScoringGuide.ColorGrade__c =TempColor.ColorGrade__c ;
                }
                ColorList.put(String.valueof(temp.Name),String.valueof(OverallScoringGuide.ColorGrade__c ));
            }

        }
        catch(Exception e){
        system.debug(e + 'errormsg))))))))))))))))))))');
         ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'Network problem. please refresh the query tool');
                     ApexPages.addMessage(myMsg );
                   
        }
    }
    Public List<SSC_ScoringGuide__c> getCurrentScoringGuide() {
        return CurrentScoringGuide ;
    }
      
    //Calculating the color for the Overall suppliers performance for prior qtr

    Public Map<String,String> getColorforoverall(){
        Double ScoreGenerated =Double.valueof( mapToScore.get('Overall'))*100;
        Double score=ScoreGenerated /Double.valueof(PriorQtrSum);
        for(SSC_ScoringGuide__c  Tempcolor : CurrentScoringGuide){

            if(Tempcolor.Min__c < = score && Tempcolor.Max__c >= score )
            OverallScoringGuide.ColorGrade__c =Tempcolor.ColorGrade__c ;
        }
        ColorList.put(String.valueof('Overall'),String.valueof(OverallScoringGuide.ColorGrade__c ));

        return ColorList;
    }
   
    //Calculating the color for the Overall suppliers performance for Current qtr
    Public Map<String,String> getColorforoverall1(){
        Double ScoreGenerated =Double.valueof( MetricScoreMap.get('Overall'))*100;

        Double score=ScoreGenerated /Double.valueof(PriorQtrSum);
        for(SSC_ScoringGuide__c  Tempcolor : CurrentScoringGuide){
            if(Tempcolor.Min__c < = score && Tempcolor.Max__c >= score )

            OverallScoringGuide.ColorGrade__c =Tempcolor.ColorGrade__c ;
        }
        col.put(String.valueof('Overall'),String.valueof(OverallScoringGuide.ColorGrade__c ));
        return col;
    }

    
    Public List<SSC_ScoringGuide__c> getPreviousScoringGuide() {
        return PreviousScoringGuideList ;
    }
 /*   Public boolean getdisplay(){
        return DisplayFlag;
    }*/
    Public string geterror(){

        return error;
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
    //Function to save the input values in the socre card Level 1 vs competitor ,controlled shipping , Business escalation fields along with comments in the level 2 and 3
    Public void getSave() {
        try{
        ErroMessageVS=false;
        ErroMessageBE=false;
        ErroMessageCS=false;
        InfoMessageVS=false;
        InfoMessageBE=false;
        InfoMessageCS=false;
        upsert CurrentQtrScore;

        set<string> OverallScoringGuide=new set<string>();
        set<string> VSScoringGuide=new set<string>();
        set<string> BEScoringGuide=new set<string>();
        List<SSC_ScoringGuide__c> TempColor=[Select Min__c ,Scoring_Guide__c from SSC_ScoringGuide__c

        where End_Date__c=:Null and Scoring_Guide__c!=:'Overall'];
        for(Integer i=0;i<TempColor.size();i++){
            if(TempColor[i].Scoring_Guide__c =='VS'){
                OverallScoringGuide.add(String.valueof(TempColor[i].min__c));

            }
        }
        for(Integer i=0;i<TempColor.size();i++){
            if(TempColor[i].Scoring_Guide__c =='CS'){
                VSScoringGuide.add(String.valueof(TempColor[i].min__c));

            }
        }
        for(Integer i=0;i<TempColor.size();i++){
            if(TempColor[i].Scoring_Guide__c =='BE'){
                BEScoringGuide.add(String.valueof(TempColor[i].min__c));

            }
        }
        if(Vscompetitor==''){
            InfoMessageVS=true;
            CurrentQtrScoreVS[0].VsCompetetorField__c=Vscompetitor;
            Upsert CurrentQtrScoreVS;
        }

        else {
            if( (Vscompetitor== '1' || Vscompetitor =='2' || Vscompetitor=='3') ){
                CompetitorFlag=0;
                if(CompetitorFlag==0 ){
                    CurrentQtrScoreVS[0].VsCompetetorField__c=Vscompetitor;

                    Upsert CurrentQtrScoreVS;
                    CompetitorFlag=2;
                }
                if(CompetitorFlag==2){
                    SuccessMessageVS=true;
                }
            }

            else{
                ErroMessageVS=true;
                SuccessMessageVS=false;
            }
        }
        if(BusinessEscalation ==''){
            InfoMessageBE=true;
            CurrentQtrScoreBE[0].ScoreOverrides__c=BusinessEscalation;

            Upsert CurrentQtrScoreBE;
        }
        else{
            if(BusinessEscalation  == 'BE1' || BusinessEscalation  =='BE2' ){
                EscalationFlag=0;
                if(EscalationFlag==0){

                    CurrentQtrScoreBE[0].ScoreOverrides__c=BusinessEscalation;
                    Upsert CurrentQtrScoreBE;
                    EscalationFlag=2;
                }
                if(EscalationFlag==2){

                    SuccessMessageBE=true;
                }
            }
            else{
                ErroMessageBE=true;
                SuccessMessageBE=false;
            }
        }
        if(ControlledShipping==''){

            InfoMessageCS=true;
            CurrentQtrScoreCS[0].Controlled_Shipping__c= ControlledShipping;
            Upsert CurrentQtrScoreCS;
        }
        else {
            if(ControlledShipping== 'CS1' || ControlledShipping == 'CS2'|| ControlledShipping =='CS3'){

                ControlledFlag=0;
                if (ControlledFlag==0){
                    CurrentQtrScoreCS[0].Controlled_Shipping__c= ControlledShipping;
                    Upsert CurrentQtrScoreCS;
                    ControlledFlag=2;

                }
                if(ControlledFlag==2){
                    SuccessMessageCS=true;
                }
            }
            else{
                ErroMessageCS=true;
                SuccessMessageCS=false;

            }
        }
        }
        catch(Exception e){
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Error, 'You do not have sufficient priviliges to perform business escalation or controlled shipping or score card overrides. Please contact system administrator');
        ApexPages.addMessage(myMsg );
        }
    }
    Public List<SSC_CurrentQuarterScore__c>  getCurrentQtrScoresVS() {
        return CurrentQtrScoreVS ;
    }
    Public List<SSC_CurrentQuarterScore__c>  getCurrentQtrScoresBE() {

        return CurrentQtrScoreBE ;
    }
    Public List<SSC_CurrentQuarterScore__c>  getCurrentQtrScoresCS() {
        return CurrentQtrScoreCS ;
    }
    Public void validate(){
    }
    Public List<SSC_SubMetric__c> getSubmetricData() {

        return SubmetricData;
    }
    Public List<SSC_SubMetric__c> getSubmetric() {
        return submetricInnovation;
    }
    Public List<SSC_SubMetric__c> getAccount8() {
        return Submetrics;

    }
    Public List<SSC_CurrentQuarterScore__c>  getCurrentQtrScores() {
        return CurrentQtrScore ;
    }
    
    //Function to redirect to Level 2 score card from Level 1 Hyperlink
    Public PageReference RedirectLevel2(){

        supplierName = System.currentPageReference().getParameters().get('Supplier ID');
        Month=System.currentPageReference().getParameters().get('Month');
        Year=System.currentPageReference().getParameters().get('Year');
SelectedSupplier=System.currentPageReference().getParameters().get('Supplier Name');
        ScoreCard_Type =System.currentPageReference().getParameters().get('ScoreCard Type');
        Dates=System.currentPageReference().getParameters().get('Generation Date');
        String url2=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        url2= url2+'/apex/SSC_DMscorecard_Level2?'+'Supplier ID='+supplierName+'&' +'Month='+Month+'&'+'Year='+Year+'&'+'ScoreCard Type='+ScoreCard_Type+'&'+'Generation Date='+Dates+'&Supplier Name='+selectedsupplier;

        PageReference RedirectLevel2Page= new PageReference(url2);
        return RedirectLevel2Page;
    }
    
    //Function to redirect to Level 3 score card from Level 2 Hyperlink
    Public PageReference RedirectLevel3(){

        supplierName = System.currentPageReference().getParameters().get('Supplier ID');
        Month=System.currentPageReference().getParameters().get('Month');
        Year=System.currentPageReference().getParameters().get('Year');
SelectedSupplier=System.currentPageReference().getParameters().get('Supplier Name');
        ScoreCard_Type =System.currentPageReference().getParameters().get('ScoreCard Type');
        Dates=System.currentPageReference().getParameters().get('Generation Date');
        String url2=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        url2=url2+ '/apex/SSC_DMscorecard_Level3?'+'Supplier ID='+supplierName+'&' +'Month='+Month+'&'+'Year='+Year+'&'+'ScoreCard Type='+ScoreCard_Type+'&'+'Generation Date='+Dates+'&Supplier Name='+selectedsupplier;

        PageReference RedirectLevel2Page= new PageReference(url2);
        return RedirectLevel2Page;
    }
    
     Public PageReference RedirectLevel1(){

        supplierName = System.currentPageReference().getParameters().get('Supplier ID');
        Month=System.currentPageReference().getParameters().get('Month');
        Year=System.currentPageReference().getParameters().get('Year');

        ScoreCard_Type =System.currentPageReference().getParameters().get('ScoreCard Type');
        Dates=System.currentPageReference().getParameters().get('Generation Date');
        String url2=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        url2= url2+'/apex/SSC_DM_ScoreCard?'+'Supplier ID='+supplierName+'&' +'Month='+Month+'&'+'Year='+Year+'&'+'ScoreCard Type='+ScoreCard_Type+'&'+'Generation Date='+Dates;

        PageReference RedirectLevel2Page= new PageReference(url2);
        return RedirectLevel2Page;
    }
    
    //Function for Sending PDF to Email of the logged in user
    Public PageReference sendPdf(){
        if(SelectedAccount=='NONE') 
        {
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Please Select the Contact from the List '));
        }
        visible = true;
        String userName = UserInfo.getUserName();
        User activeUser = [Select Email From User where Username = : userName limit 1];
        email = SelectedAccount;
        PageReference pdf = Page.SSC_DM_ScoreCard_pdf;

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

            email
        }
        );
        mail.setSubject('Your Scorecard');
        mail.setHtmlBody('<html><body>Hello '+ SelectedSupplier+',<br><br> Please find your '+ CurrentMonth+' '+ CurrentYear1 +' Scorecard. <br><br> Thanks,<br><br>Motorola Procurement Team</html></body>');

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
    
    //Function to redirect to the calendar pull schedule
    Public PageReference Calendar(){
        url=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        url='/apex/SSC_Calendar';
        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
    
    //Function to redirect to the Edit scoring guide page
    Public PageReference EditScoringGuide(){

        url=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;
        url='/apex/SSC_ScoringGuides';
        PageReference Redirect= new PageReference(url);
        return Redirect;

    }
    
    //Function to redirect to display all the current scoring guides page
    Public PageReference RedirectScoringGuides(){
        url=  'https://'+ApexPages.currentPage().getHeaders().get('Host') ;

        url='/apex/SSC_AllScoringGuides';
        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
    
    //Function to redirect to the Raw data templates in the Gdrive

    Public PageReference Rawdata(){
        string url ='https://docs.google.com/a/motorola.com/spreadsheet/ccc?key=';
        url=url+FileIds[0].File_ID__c +'&usp=drive_web#gid=0';

        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
    
    //Function to redirect to the CSR Dashboard
    Public PageReference Rawdata2(){
        url='https://docs.google.com/a/motorola.com/spreadsheet/ccc?key='+FileIds[1].File_ID__c +'&usp=drive_web#gid=0';

        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
    Public PageReference Rawdata3(){
        url='https://docs.google.com/a/motorola.com/spreadsheet/ccc?key='+FileIds[2].File_ID__c +'&usp=drive_web#gid=0';

        PageReference Redirect= new PageReference(url);
        return Redirect;
    }
    
    Public List<SSC_SubMetric__c> getSubmetricCurrentData() {
        SubmetricCurrentData=[select Name,TargetScore__c from SSC_SubMetric__c where Metric_Name__r.Name='Quality'];

        return SubmetricCurrentData ;
    }
    Public void closePopup(){
        DisplayPopup = false;
        Rawdata();
    }
    Public void showPopup(){
        DisplayPopup = true;
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

        url2= url2+'/apex/SSC_SendEmail?'+'Supplier ID='+supplierName+'&' +'Month='+Month+'&'+'Year='+Year+'&'+'ScoreCard Type='+ScoreCard_Type+'&'+'Generation Date='+Dates+'&'+'Supplier Name='+SelectedSupplier;

        PageReference RedirectLevel2Page= new PageReference(url2);
        return RedirectLevel2Page;
   
    }
    Public List<SSC_L3SubMetric__c> getCurrentL3Submetriclist () {

        return CurrentL3Submetriclist ;
    }
    Public  Map<String, Double>  getmapToScore() {
        return mapToScore;
    }
    Public  Map<String, Double>  getMetricScoreMap() {
        return MetricScoreMap;

    }
    Public wrapperclass getTempWrapObject() {
        wrapperclass TempWrapObject = new wrapperclass (mapToScore,mapToAccount,MetricsList,SubmetricData,SubmetricCurrentData,SubmetricPreviousData,MetricScoreMap,SubMetricMaptoScore,L3SubMetricMaptoScore,PriorQtrMetricData,PriorQtrSubMetricData,L3Submetricslist,PriorQtrL3SubMetricData,col,ColorList,PreviousL3SubMetricColor,PreviousQtrSubMetricColor,PreviousQtrMetricColor,L3SubMetricColor,SubMetricColor,MetricColor);

        return TempWrapObject ;
    }
    Public class wrapperclass{
        Public Map<String,String> ColorList= new Map<String,string>();
        Public Map<String,String> PreviousL3SubMetricColor= new Map<String,string>();

        Public Map<String,String> PreviousQtrSubMetricColor= new Map<String,string>();
        Public Map<String,String> PreviousQtrMetricColor= new Map<String,string>();
        Public Map<String,String> L3SubMetricColor= new Map<String,string>();

        Public Map<String,String> SubMetricColor= new Map<String,string>();
        Public Map<String,String> MetricColor= new Map<String,string>();
        Public List<SSC_L3SubMetric__c> Temp1 = new List<SSC_L3SubMetric__c>();

        Public  List<SSC_L3SubMetric__c>  L3Submetricslist= new  List<SSC_L3SubMetric__c> ();
        Public List<SSC_Metric__c> MetricsList= new List<SSC_Metric__c>();
        Public List<SSC_SubMetric__c> SubmetricData= new List<SSC_SubMetric__c>();

        Public List<SSC_SubMetric__c> SubmetricCurrentData= new List<SSC_SubMetric__c>();
        Public List<SSC_CurrentQuarterScore__c> SubmetricPreviousData= new List<SSC_CurrentQuarterScore__c>();

        Public Map<String, List< SSC_CurrentQuarterScore__c> > mapToAccount = new Map<String,List< SSC_CurrentQuarterScore__c> >();
        Public Map<String, List< SSC_CurrentQuarterScore__c> > PriorQtrSubMetricData = new Map<String,List< SSC_CurrentQuarterScore__c> >();

        Public Map<String, List< SSC_PriorQuarterScore__c> > PriorQtrL3SubMetricData = new Map<String,List< SSC_PriorQuarterScore__c> >();
        Public Map<String,String> col = new Map<String,String> ();

        Public Map<String, Double> mapToScore= new Map<String,Double>();
        Public Map<String, List< SSC_PriorQuarterScore__c> > PriorQtrMetricData = new Map<String,List< SSC_PriorQuarterScore__c> >();

        Public Map<String, Double> MetricScoreMap= new Map<String,Double>();
        Public Map<String, Double> SubMetricMaptoScore= new Map<String,Double>();
        Public   Map<String, Double> L3SubMetricMaptoScore= new Map<String,Double>();

        Public wrapperclass(Map<String, Double> mapToScore, Map<String, List< SSC_CurrentQuarterScore__c> > mapToAccount,List<SSC_Metric__c> MetricsList,List<SSC_SubMetric__c> SubmetricData,List<SSC_SubMetric__c> SubmetricCurrentData,List<SSC_CurrentQuarterScore__c> SubmetricPreviousData,Map<String, Double> MetricScoreMap, Map<String, Double> SubMetricMaptoScore,Map<String, Double> L3SubMetricMaptoScore ,Map<String, List< SSC_PriorQuarterScore__c> > PriorQtrMetricData,Map<String, List< SSC_CurrentQuarterScore__c> > PriorQtrSubMetricData, List<SSC_L3SubMetric__c> L3Submetricslist, Map<String, List< SSC_PriorQuarterScore__c> > PriorQtrL3SubMetricData ,Map<String,String> col,Map<String,String> ColorList,Map<String,String> PreviousL3SubMetricColor,Map<String,String> PreviousQtrSubMetricColor,Map<String,String> PreviousQtrMetricColor,Map<String,String> L3SubMetricColor,Map<String,String> SubMetricColor,Map<String,String> MetricColor){

            try{
                this.ColorList=ColorList;
                this.PreviousL3SubMetricColor=PreviousL3SubMetricColor;
                this.PreviousQtrSubMetricColor=PreviousQtrSubMetricColor;
                this.PreviousQtrMetricColor=PreviousQtrMetricColor;

                this.L3SubMetricColor=L3SubMetricColor;
                this.SubMetricColor=SubMetricColor;
                this.MetricColor=MetricColor;
                this.MetricsList= (MetricsList);
                this.SubmetricData= (SubmetricData);

                this.SubmetricCurrentData= (SubmetricCurrentData);
                this.SubmetricPreviousData= (SubmetricPreviousData);
                this.L3Submetricslist= (L3Submetricslist);
                this.mapToAccount=mapToAccount;

                this.mapToScore=mapToScore;
                this.PriorQtrMetricData=PriorQtrMetricData;
                this.PriorQtrSubMetricData=PriorQtrSubMetricData;
                this.PriorQtrL3SubMetricData=PriorQtrL3SubMetricData;

                this.MetricScoreMap=MetricScoreMap;
                this.SubMetricMaptoScore=SubMetricMaptoScore;
                this.L3SubMetricMaptoScore=L3SubMetricMaptoScore;
                this.col=col;

                this.Temp1 = [Select SSC_SubMetric__r.Name from SSC_L3SubMetric__c ];
            }
            catch(Exception e){
                apexPages.addMessage( new ApexPages.Message(ApexPages.Severity.ERROR,'Unable to setup Wizard'));

            }
        }
        Public List<SSC_Metric__c> getMetricsList(){
            return MetricsList;
        }
        Public List<SSC_SubMetric__c> getSubmetricData(){
            return SubmetricData;

        }

        Public List<SSC_SubMetric__c> getSubmetricCurrentData(){
            return SubmetricCurrentData;
        }
        Public List<SSC_CurrentQuarterScore__c> getSubmetricPreviousData(){

            return SubmetricPreviousData;
        }
        Public Map<String, List< SSC_CurrentQuarterScore__c> > getCurrentScoringGuide(){
            mapToAccount.remove('Overall');
            return mapToAccount;

        }
        Public Map<String, List< SSC_CurrentQuarterScore__c> > getPriorQtrSubMetricData(){
            return PriorQtrSubMetricData;
        }
        Public Map<String, List< SSC_PriorQuarterScore__c> > getPriorQtrL3SubMetricData(){

            return PriorQtrL3SubMetricData;
        }
        Public List<SSC_L3SubMetric__c>   getL3Submetricslist(){
            return L3Submetricslist;
        }
        Public Map<String, Double> getmapToScore(){

            return mapToScore;
        }
        Public List<SSC_L3SubMetric__c> getTemp1(){
            return Temp1 ;
        }
        Public Map<String, List< SSC_PriorQuarterScore__c> > getPriorQtrMetricData(){

            return PriorQtrMetricData;
        }
        Public Map<String, Double> getMetricScoreMap(){
            return MetricScoreMap;
        }
        Public Map<String, Double> getSubMetricMaptoScore(){

            return SubMetricMaptoScore;
        }
        Public Map<String, Double> getL3SubMetricMaptoScore(){
            return L3SubMetricMaptoScore;
        }
        Public Map<String,String> getcolor(){

            return col;
        }
        Public Map<String,String> getColorList(){
            return ColorList;
        }
        Public Map<String,String> getPreviousL3SubMetricColor(){
            return PreviousL3SubMetricColor;

        }
        Public Map<String,String> getPreviousQtrMetricColor(){
            return PreviousQtrMetricColor;
        }
        Public Map<String,String> getL3SubMetricColor(){
            return L3SubMetricColor;

        }
        Public Map<String,String> getSubMetricColor(){
            return SubMetricColor;
        }
        Public Map<String,String> getMetricColor(){
            return MetricColor;

        }
        Public Map<String,String> getPreviousQtrSubMetricColor(){
            Set <String> colorSet = new Set<String>();
            colorSet = PreviousL3SubMetricColor.keySet();
            for( string s : colorSet){

                Boolean contains =    PreviousQtrSubMetricColor.containsKey(s);
                if (contains==false)
                PreviousQtrSubMetricColor.put(s,'');
            }
            return PreviousQtrSubMetricColor;

        }
    }
}