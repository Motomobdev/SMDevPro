/**********************************************************/
// Created by:Sivani Mallampalli
// Created Date: 06/10/2015
// 
//
// Description:
// This class is used the test class for 
// SSC_scoreCardCopyLastmnthcurrent_Batch,
// SSC_scoreCardCopyLastMonthtoCurrent
// 
// Test Class: 
// Ssc_scorecopylastmnthtocurrent_Test.cls
/**********************************************************/


@isTest
private class Ssc_scorecopylastmnthtocurrent_Test { 

  static testMethod void testcopy(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='January';
        crq.year__c='2015';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
        cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
  /* static testMethod void testcopy2(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='February';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
      cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
  static testMethod void testcopy3(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='March';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
        cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }

static testMethod void testcopy4(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='April';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
        cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
  static testMethod void testcopy5(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='May';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
        cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
  static testMethod void testcopy6(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='June';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
       cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
  static testMethod void testcopy7(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='July';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
       cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
  static testMethod void testcopy8(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='August';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
        cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
  static testMethod void testcopy9(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='September';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
       cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
  static testMethod void testcopy10(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='October';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='September';
        cls.nextMonth='2015';
       cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
static testMethod void testcopy11(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='October';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='October';
        cls.nextMonth='2015';
        cls.SSC_scoreCardCopyLastMonth();
  
  
  
  } 
static testMethod void testcopy12(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='November';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='November';
        cls.nextMonth='2015';
        cls.SSC_scoreCardCopyLastMonth();
  
  
  
  }
  static testMethod void testcopy13(){  
  Account acc= new Account();
        acc.Name='accounrname';
        insert acc;  
         SSC_ScoringGuide__c sg = new SSC_ScoringGuide__c();
        sg.Caption__c='testing';
        insert sg;        
        SSC_Metric__c ssc = new SSC_Metric__c();
        ssc.SSC_ScoringGuide__c = sg.Id;
        Ssc.Name='test';
        Ssc.Target_Score__c=100;  
        insert SSC;        
        SSC_SubMetric__c subssc = new SSC_SubMetric__c();
        subssc.Metric_Name__c=ssc.Id;
        Ssc.Name='test1';
        Ssc.Target_Score__c=80;
        Insert subssc;        
        SSC_CurrentQuarterScore__c crq= new SSC_CurrentQuarterScore__c();
        crq.Account__c = acc.Id;
        crq.SubMetric_Name__c= subssc.Id;
        crq.score__c=60;
        crq.month__c='December';
        crq.year__c='2015';
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        SSC_scoreCardCopyLastMonthtoCurrent cls = new SSC_scoreCardCopyLastMonthtoCurrent();
        cls.nextYear='December';
        cls.nextMonth='2015';
        cls.display=true;
       cls.SSC_scoreCardCopyLastMonth();
  
  
  
  } */




}