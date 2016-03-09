public class SSC_Scoringguide {
    public List<SSC_ScoringGuide__c> ScoringGuideList{get;set;}
    public List<SSC_ScoringGuide__c> ScoringGuide{get;set;} 
    public List<SSC_ScoringGuide__c > ScoringGuideList2 = new List<SSC_ScoringGuide__c >();
    public boolean displayPopup {get; set;}
    public List<SSC_ScoringGuide__c> QBEScoringGuideList{get;set;}   
    public List<SSC_ScoringGuide__c> CtrlScoringGuideList{get;set;}
    public List<SSC_ScoringGuide__c> VsScoringGuideList{get;set;}         
    public SSC_Scoringguide (){    
    ScoringGuideList = new List<SSC_ScoringGuide__c>();
    QBEScoringGuideList = new List<SSC_ScoringGuide__c>();
    CtrlScoringGuideList= new List<SSC_ScoringGuide__c>();
    
     ScoringGuideList =[Select Id,Name,Caption__c,ColorGrade__c,Max__c,Min__c, Scoring_Guide__c from  SSC_ScoringGuide__c where END_date__C=:Null and Scoring_Guide__c ='Overall'order by Caption__c];    
     ScoringGuide=[Select Id, Name,Caption__c,ColorGrade__c,Max__c,Min__c,Start_Date__c,End_Date__c from SSC_ScoringGuide__c where End_Date__c=:Null and Scoring_Guide__c ='Overall'];
     
  //   QBEScoringGuideList = [Select Id,Name,Caption__c,ColorGrade__c,Max__c,Min__c, Scoring_Guide__c from  SSC_ScoringGuide__c where Min__c=:Null order by Caption__C];
     CtrlScoringGuideList=[Select Id,Name,Caption__c,ColorGrade__c,Max__c,Min__c, Scoring_Guide__c from  SSC_ScoringGuide__c where  Start_Date__c=:Null Order By caption__C];
     VsScoringGuideList=[Select Id,Name,Caption__c,ColorGrade__c,Max__c,Min__c, Scoring_Guide__c from  SSC_ScoringGuide__c where  Min__c=:Null AND Max__c=:Null order by Scoring_Guide__c];
   
    For(SSC_ScoringGuide__c Ssgg : ScoringGuide){
     
      // Ssgg.End_Date__c =Date.Today();
       
         Ssgg.End_Date__c = DateTime.Now();
       
       }
    }
    
 
 
   public PageReference saveScore() {    
   
   /*-------------------------  Scoring Guide---------------------------------------------- */
     displayPopup = false;   
    if (!ScoringGuideList.isEmpty()){
    
      For(SSC_ScoringGuide__c Ssg : ScoringGuideList){
      
      ScoringGuideList2.add(new SSC_ScoringGuide__c( Name='DM Score Card',Scoring_Guide__c='Overall',Caption__c=Ssg.Caption__c,ColorGrade__c =Ssg.ColorGrade__c ,Max__c=Ssg.Max__c ,Min__c=Ssg.Min__c,Start_Date__c=DateTime.Now(),End_Date__c =Null));

       }         
          if(ScoringGuideList2.size()>0){ insert ScoringGuideList2;
          ScoringGuideList2.clear();
          }      
    }
    
      Update ScoringGuide;
      
      ScoringGuide.CLEAR();
       
        return Page.SSC_ScoringGuides.setRedirect(true);
   }
    public PageReference closePopup() {        
       
        displayPopup = false; 
         return Page.SSC_ScoringGuides.setRedirect(true);
           
    }     
    public void showPopup() {        
        displayPopup = true;  
          
    }
}