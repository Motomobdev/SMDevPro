public class SSC_displayscoringguide {


    public List<SSC_ScoringGuide__c> ScoringGuideList{get;set;}
    public List<SSC_ScoringGuide__c> QBEScoringGuideList{get;set;}
    public List<SSC_ScoringGuide__c> CtrlScoringGuideList{get;set;}
     public List<SSC_ScoringGuide__c> VSScoringGuideList{get;set;}
     
    public SSC_displayscoringguide(){
    
    ScoringGuideList = new List<SSC_ScoringGuide__c>();
    QBEScoringGuideList = new List<SSC_ScoringGuide__c>();
    CtrlScoringGuideList= new List<SSC_ScoringGuide__c>();
    
    ScoringGuideList =[Select Id,Name,Caption__c,ColorGrade__c,Max__c,Min__c, Scoring_Guide__c from  SSC_ScoringGuide__c where END_date__C=:Null and Scoring_Guide__c =:'Overall' order by Min__c];
   
    QBEScoringGuideList = [Select Id,Name,Caption__c,ColorGrade__c,Max__c,Min__c, Scoring_Guide__c from  SSC_ScoringGuide__c where END_date__C=:Null and Scoring_Guide__c =:'BE' order by Min__c];
   
    CtrlScoringGuideList=[Select Id,Name,Caption__c,ColorGrade__c,Max__c,Min__c, Scoring_Guide__c from  SSC_ScoringGuide__c where END_date__C=:Null and Scoring_Guide__c =:'CS' order by Min__c] ;
    VSScoringGuideList=[Select Id,Name,Caption__c,ColorGrade__c,Max__c,Min__c, Scoring_Guide__c from  SSC_ScoringGuide__c where END_date__C=:Null and Scoring_Guide__c =:'VS' order by Min__c];
    }
    

    
}