@isTest
private class SSC_Moverecordsfromcurrent_to_prior_Test { 
    
    static testMethod void test(){        
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
        insert crq;                   
        SSC_L3SubMetric__c l3ssc = new SSC_L3SubMetric__c();
        l3ssc.SSC_SubMetric__c=subssc.Id;
        l3ssc.Name='test2';
        l3ssc.Target_Score__c=50;
        Insert l3ssc;
        
        List<SSC_PriorQuarterScore__c> PList = new List<SSC_PriorQuarterScore__c>(); 
        List<SSC_CurrentQuarterScore__c> CList = new list<SSC_CurrentQuarterScore__c>(); 
        
        for(SSC_CurrentQuarterScore__c Crq1 : CList){
            SSC_PriorQuarterScore__c prq = new SSC_PriorQuarterScore__c();
            prq.Account__c ='AccountName';
            prq.SubMetric_Name__c ='Cost Comp';
            prq.Score__c = 80;
            Prq.Comments__c ='testing';
            //Prq.GenerationDate__c = ;
            Prq.L3SubMetricName__c = 'Cost Comp';
            Prq.Month__c = 'January';
            Prq.Score__c = 80;  
            Prq.ScoreOverrides__c = 'test';
            Prq.SubMetric_Name__c='Cost control';
            Prq.VsCompetetorField__c = 'test';
            Prq.year__c = '2014';           
            PList.add(Prq);
            CList.add(Crq);            
        }
        if(PList.size()>0){insert PList;}
        if(CList.size()>0){delete CList;}     
        Database.QueryLocator QL;
        Database.BatchableContext BC;        
        Ssc_Moverecordsfromcurrent_to_prior Mv = new Ssc_Moverecordsfromcurrent_to_prior();     
        Mv.start(bc);              
        ID batchprocessid = Database.executeBatch(Mv);  
        Mv.execute(BC,Clist);
        Mv.finish(BC);   
    } 
}