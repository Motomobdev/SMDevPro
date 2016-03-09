/*
*************************************************************************************************
Description:
This class is for Calculating Current Quarter supplier scores and inserting into Currentquarterscore 
Object
Test Class :SSC_ScoreCalculatorBatch_Test


Revision History:
Author/Reviewer     Created/Revised Date   Change Description
 Sivani                     22-05-2015         Created   




*************************************************************************************************
*/



global class SSC_ScoreCalculatorBatch implements Database.Batchable<sObject>,Database.Stateful
{
Map<string,Id> l3submetricName1 = new Map<string,Id>();
Map<string,Id> l3submetricSubMetric1 = new Map<string,Id>();
Map<string,Id> SubMetricName1 = new Map<string,Id>();
Map<string,Id> SubMetricMetric1 = new Map<string,Id>();
Map<string,Decimal> l3submetricTarget = new Map<string,Decimal>();
Map<string,Decimal> submetricTarget = new Map<string,Decimal>();
string month;
integer year;
global SSC_ScoreCalculatorBatch(Map<string,Id> l3submetricName,Map<string,Id> l3submetricSubMetric,Map<string,Id> SubMetricName,Map<string,Id> SubMetricMetric,string month1,integer year1,Map<string,Decimal> l3target,Map<string,Decimal> subTarget)
{
l3submetricName1=l3submetricName;
l3submetricSubMetric1=l3submetricSubMetric;
SubMetricName1=SubMetricName;
SubMetricMetric1=SubMetricMetric;
month=month1;
year=year1;
l3submetricTarget = l3target;
submetricTarget=subtarget;


}
global Database.QueryLocator start(Database.BatchableContext BC){
 String query = 'select Id,Name,Oracle_Customer_Number__c from Account where SSC_Scorecard_Required__c=true';
 system.debug(query + 'query');
     return Database.getQueryLocator(query);
  }

 global void execute(Database.BatchableContext BC, List<Account> scope)
 {
  list<SSC_CurrentQuarterScore__c> insertList = new list<SSC_CurrentQuarterScore__c>();
  List<SSC_PriorQuarterScore__c> insertList1= new list<SSC_PriorQuarterScore__c>();
  List<SSC_PriorQuarterScore__c> priorList = new List<SSC_PriorQuarterScore__c>();
   for(Account acc  :scope)
   {
   system.debug('account name' + acc.name);
 List<ScoreCardQualityDelivery__c> qltyDel = [select Id ,Name,Account_Name__c,Agility_Score__c,Commitment_Score__c,Defective_PPM_Score__c,Escaping_MCAR_Score__c,Lead_Time_Score__c,Month__c,OracleCustNum__c,ORacle_Customer_Number__c,OTD_Score__c,Quality_Capability_Score__c,Status__c,Year__c from ScoreCardQualityDelivery__c where Status__c='Current' and Account_Name__c=:acc.id AND ORacle_Customer_Number__c=:acc.Oracle_Customer_Number__c AND Month__c=:month AND Year__C=:year];
  List<ScoreCardCostInnovation__c> cstInnov = [select Id ,Name,Account_Name__c,Business_Continuity_Score__c,Cost_Competiveness_Score__c,Cost_Control_Score__c,CSA_Status_Score__c,Innovative_Concepts_Score__c,Month__c,OracleCustNum__c,ORacle_Customer_Number__c,Payment_Terms_Score__c,Reduction_Performance_Score__c,SOI_Score__c,Status__c,Year__c,Technology_Roadmap_Score__c,Transparency_Score__c from ScoreCardCostInnovation__c where Status__c='Current' and Account_Name__c=:acc.id AND Month__c=:month AND Year__C=:year AND ORacle_Customer_Number__c=:acc.Oracle_Customer_Number__c];
   List<ScoreCardCSRDashboard__c> csrDash=[select Id,Name,Account_Name__c,Month__c,ORacle_Customer_Number__c,Status__c,Supplier_Score__c,Year__c from ScoreCardCSRDashboard__c where Status__c='Current' and Account_Name__c=:acc.id AND Month__c=:month AND Year__C=:year AND ORacle_Customer_Number__c=:acc.Oracle_Customer_Number__c];
    integer monNum;
   if(month=='January')
   {
     monNum=1;
   
   }
    if(month=='February')
   {
     monNum=2     ;
   
   }
   if(month=='March')
   {
     monNum=3    ;
   
   }
   if(month=='April')
   {
     monNum=4   ;
   
   }
   if(month=='May')
   {
     monNum=5   ;
   
   }
    if(month=='June')
   {
     monNum=6   ;
   
   }
    if(month=='July')
   {
     monNum=7   ;
   
   }
    if(month=='August')
   {
     monNum=8   ;
   
   }
  if(month=='September')
   {
     monNum=9   ;
   
   }
 if(month=='October')
   {
     monNum=10   ;
   
   }

 if(month=='November')
   {
     monNum=11   ;
   
   }
     if(month=='December')
   {
     monNum=12   ;
   
   }
   system.debug('month' + month + 'year' + year + 'monthnumber' + monNum + 'account name' + acc.name + 'account name' + acc.Oracle_Customer_Number__c);
   
  if(monNum==system.today().month() && year==system.today().year() && qltyDel!=null && qltyDel.size()>0 && cstInnov!=null && cstInnov.size()>0 && csrDash!=null && csrDash.size()>0)
  {
  
   SSC_CurrentQuarterScore__c curr = new SSC_CurrentQuarterScore__c();
   curr.Account__c = acc.id;
   curr.GenerationDate__c=DateTime.ValueOf(system.now());
   curr.Month__c=month;
   curr.year__c=string.valueof(year);
   curr.L3SubMetricName__c='Technology Roadmap Review';
   curr.SubMetric_Name__c=l3submetricSubMetric1.get('Technology Roadmap Review');
   curr.Score__c=(cstInnov[0].Technology_Roadmap_Score__c*l3submetricTarget.get('Technology Roadmap Review'))/100;
  insertList.add(curr);
  SSC_CurrentQuarterScore__c curr1 = new SSC_CurrentQuarterScore__c();
   curr1.Account__c = acc.id;
   curr1.GenerationDate__c=DateTime.ValueOf(system.now());
   curr1.Month__c=month;
   curr1.year__c=string.valueof(year);
   curr1.L3SubMetricName__c='SOI';
   curr1.SubMetric_Name__c=l3submetricSubMetric1.get('SOI');
   system.debug(l3submetricSubMetric1.get('SOI') +'submetric name++++++++++');
   system.debug(cstInnov[0].SOI_Score__c +'supplier score+++++++++');
   system.debug(l3submetricTarget.get('SOI') +'target score+++++++');
   
   curr1.Score__c=(cstInnov[0].SOI_Score__c*l3submetricTarget.get('SOI'))/100;
  insertList.add(curr1);
  SSC_CurrentQuarterScore__c curr2 = new SSC_CurrentQuarterScore__c();
   curr2.Account__c = acc.id;
   curr2.GenerationDate__c=DateTime.ValueOf(system.now());
   curr2.Month__c=month;
   curr2.year__c=string.valueof(year);
   curr2.L3SubMetricName__c='CSA Status';
   curr2.SubMetric_Name__c=l3submetricSubMetric1.get('CSA Status');
   curr2.Score__c=(cstInnov[0].CSA_Status_Score__c*l3submetricTarget.get('CSA Status'))/100;
  insertList.add(curr2);
  SSC_CurrentQuarterScore__c curr3 = new SSC_CurrentQuarterScore__c();
   curr3.Account__c = acc.id;
   curr3.GenerationDate__c=DateTime.ValueOf(system.now());
   curr3.Month__c=month;
   curr3.year__c=string.valueof(year);
   curr3.L3SubMetricName__c='Payment Terms';
   curr3.SubMetric_Name__c=l3submetricSubMetric1.get('Payment Terms');
   curr3.Score__c=(cstInnov[0].Payment_Terms_Score__c*l3submetricTarget.get('Payment Terms'))/100;
  insertList.add(curr3);
  SSC_CurrentQuarterScore__c curr4 = new SSC_CurrentQuarterScore__c();
   curr4.Account__c = acc.id;
   curr4.GenerationDate__c=DateTime.ValueOf(system.now());
   curr4.Month__c=month;
   curr4.year__c=string.valueof(year);
   curr4.L3SubMetricName__c='Innovative Concepts';
   curr4.SubMetric_Name__c=l3submetricSubMetric1.get('Innovative Concepts');
   curr4.Score__c=(cstInnov[0].Innovative_Concepts_Score__c*l3submetricTarget.get('Innovative Concepts'))/100;
  insertList.add(curr4);
  SSC_CurrentQuarterScore__c curr5 = new SSC_CurrentQuarterScore__c();
   curr5.Account__c = acc.id;
   curr5.GenerationDate__c=DateTime.ValueOf(system.now());
   curr5.Month__c=month;
   curr5.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr5.SubMetric_Name__c=SubMetricName1.get('Cost Competiveness');
   curr5.Score__c=(cstInnov[0].Cost_Competiveness_Score__c*submetricTarget.get('Cost Competiveness'))/100;
  insertList.add(curr5);
   SSC_CurrentQuarterScore__c curr6 = new SSC_CurrentQuarterScore__c();
   curr6.Account__c = acc.id;
   curr6.GenerationDate__c=DateTime.ValueOf(system.now());
   curr6.Month__c=month;
   curr6.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr6.SubMetric_Name__c=SubMetricName1.get('Reduction Performance');
   curr6.Score__c=(cstInnov[0].Reduction_Performance_Score__c*submetricTarget.get('Reduction Performance'))/100;
  insertList.add(curr6);
  SSC_CurrentQuarterScore__c curr7 = new SSC_CurrentQuarterScore__c();
   curr7.Account__c = acc.id;
   curr7.GenerationDate__c=DateTime.ValueOf(system.now());
   curr7.Month__c=month;
   curr7.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr7.SubMetric_Name__c=SubMetricName1.get('Cost Control');
   curr7.Score__c=(cstInnov[0].Cost_Control_Score__c*submetricTarget.get('Cost Control'))/100;
  insertList.add(curr7);
  SSC_CurrentQuarterScore__c curr8 = new SSC_CurrentQuarterScore__c();
   curr8.Account__c = acc.id;
   curr8.GenerationDate__c=DateTime.ValueOf(system.now());
   curr8.Month__c=month;
   curr8.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr8.SubMetric_Name__c=SubMetricName1.get('Transparency');
   curr8.Score__c=(cstInnov[0].Transparency_Score__c*submetricTarget.get('Transparency'))/100;
  insertList.add(curr8);
    SSC_CurrentQuarterScore__c curr9 = new SSC_CurrentQuarterScore__c();
   curr9.Account__c = acc.id;
   curr9.GenerationDate__c=DateTime.ValueOf(system.now());
   curr9.Month__c=month;
   curr9.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr9.SubMetric_Name__c=SubMetricName1.get('Escaping MCAR');
   curr9.Score__c=(qltyDel[0].Escaping_MCAR_Score__c*submetricTarget.get('Escaping MCAR'))/100;
  insertList.add(curr9);
  SSC_CurrentQuarterScore__c curr10 = new SSC_CurrentQuarterScore__c();
   curr10.Account__c = acc.id;
   curr10.GenerationDate__c=DateTime.ValueOf(system.now());
   curr10.Month__c=month;
   curr10.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr10.SubMetric_Name__c=SubMetricName1.get('Quality Capability');
   curr10.Score__c=(qltyDel[0].Quality_Capability_Score__c*submetricTarget.get('Quality Capability'))/100;
  insertList.add(curr10);
  SSC_CurrentQuarterScore__c curr11 = new SSC_CurrentQuarterScore__c();
   curr11.Account__c = acc.id;
   curr11.GenerationDate__c=DateTime.ValueOf(system.now());
   curr11.Month__c=month;
   curr11.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr11.SubMetric_Name__c=SubMetricName1.get('Defective PPM');
   curr11.Score__c=(qltyDel[0].Defective_PPM_Score__c*submetricTarget.get('Defective PPM'))/100;
  insertList.add(curr11);
  SSC_CurrentQuarterScore__c curr12 = new SSC_CurrentQuarterScore__c();
   curr12.Account__c = acc.id;
   curr12.GenerationDate__c=DateTime.ValueOf(system.now());
   curr12.Month__c=month;
   curr12.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr12.SubMetric_Name__c=SubMetricName1.get('Commitment');
   curr12.Score__c=(qltyDel[0].Commitment_Score__c*submetricTarget.get('Commitment'))/100;
  insertList.add(curr12);
   SSC_CurrentQuarterScore__c curr13 = new SSC_CurrentQuarterScore__c();
   curr13.Account__c = acc.id;
   curr13.GenerationDate__c=DateTime.ValueOf(system.now());
   curr13.Month__c=month;
   curr13.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr13.SubMetric_Name__c=SubMetricName1.get('OTD');
   curr13.Score__c=(qltyDel[0].OTD_Score__c*submetricTarget.get('OTD'))/100;
  insertList.add(curr13);
   SSC_CurrentQuarterScore__c curr14 = new SSC_CurrentQuarterScore__c();
   curr14.Account__c = acc.id;
   curr14.GenerationDate__c=DateTime.ValueOf(system.now());
   curr14.Month__c=month;
   curr14.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr14.SubMetric_Name__c=SubMetricName1.get('Lead Time Compliance');
   curr14.Score__c=(qltyDel[0].Lead_Time_Score__c*submetricTarget.get('Lead Time Compliance'))/100;
  insertList.add(curr14);
  SSC_CurrentQuarterScore__c curr15 = new SSC_CurrentQuarterScore__c();
   curr15.Account__c = acc.id;
   curr15.GenerationDate__c=DateTime.ValueOf(system.now());
   curr15.Month__c=month;
   curr15.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr15.SubMetric_Name__c=SubMetricName1.get('Agility');
   curr15.Score__c=(qltyDel[0].Agility_Score__c*submetricTarget.get('Agility'))/100;
  insertList.add(curr15);
SSC_CurrentQuarterScore__c curr16 = new SSC_CurrentQuarterScore__c();
   curr16.Account__c = acc.id;
   curr16.GenerationDate__c=DateTime.ValueOf(system.now());
   curr16.Month__c=month;
   curr16.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr16.SubMetric_Name__c=SubMetricName1.get('Business Continuity');
   curr16.Score__c=(cstInnov[0].Business_Continuity_Score__c*submetricTarget.get('Business Continuity'))/100;
  insertList.add(curr16);
  SSC_CurrentQuarterScore__c curr17 = new SSC_CurrentQuarterScore__c();
   curr17.Account__c = acc.id;
   curr17.GenerationDate__c=DateTime.ValueOf(system.now());
   curr17.Month__c=month;
   curr17.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr17.SubMetric_Name__c=SubMetricName1.get('Corporate Social Responsibility');
   curr17.Score__c=(csrDash[0].Supplier_Score__c*submetricTarget.get('Corporate Social Responsibility'))/100;
  insertList.add(curr17);

  
  
  
  
  }
  
   if(monNum!=system.today().month()  && qltyDel!=null && qltyDel.size()>0 && cstInnov!=null && cstInnov.size()>0 && csrDash!=null && csrDash.size()>0)
  { 
   
     priorList=[select Id ,Name,Account__c from SSC_PriorQuarterScore__c where Month__c=:month and Year__c=:string.valueof(year) and Account__c=:acc.id];
    SSC_PriorQuarterScore__c curr = new SSC_PriorQuarterScore__c();
   curr.Account__c = acc.id;
   curr.GenerationDate__c=DateTime.ValueOf(system.now());
   curr.Month__c=month;
   curr.year__c=string.valueof(year);
   curr.L3SubMetricName__c='Technology Roadmap Review';
   curr.SubMetric_Name__c=l3submetricSubMetric1.get('Technology Roadmap Review');
   curr.Score__c=(cstInnov[0].Technology_Roadmap_Score__c*l3submetricTarget.get('Technology Roadmap Review'))/100;
  insertList1.add(curr);
  SSC_PriorQuarterScore__c curr1 = new SSC_PriorQuarterScore__c();
   curr1.Account__c = acc.id;
   curr1.GenerationDate__c=DateTime.ValueOf(system.now());
   curr1.Month__c=month;
   curr1.year__c=string.valueof(year);
   curr1.L3SubMetricName__c='SOI';
   curr1.SubMetric_Name__c=l3submetricSubMetric1.get('SOI');
   system.debug(l3submetricSubMetric1.get('SOI') +'submetric name++++++++++');
   system.debug(cstInnov[0].SOI_Score__c +'supplier score+++++++++');
   system.debug(l3submetricTarget.get('SOI') +'target score+++++++');
   
   curr1.Score__c=(cstInnov[0].SOI_Score__c*l3submetricTarget.get('SOI'))/100;
  insertList1.add(curr1);
  SSC_PriorQuarterScore__c curr2 = new SSC_PriorQuarterScore__c();
   curr2.Account__c = acc.id;
   curr2.GenerationDate__c=DateTime.ValueOf(system.now());
   curr2.Month__c=month;
   curr2.year__c=string.valueof(year);
   curr2.L3SubMetricName__c='CSA Status';
   curr2.SubMetric_Name__c=l3submetricSubMetric1.get('CSA Status');
   curr2.Score__c=(cstInnov[0].CSA_Status_Score__c*l3submetricTarget.get('CSA Status'))/100;
  insertList1.add(curr2);
  SSC_PriorQuarterScore__c curr3 = new SSC_PriorQuarterScore__c();
   curr3.Account__c = acc.id;
   curr3.GenerationDate__c=DateTime.ValueOf(system.now());
   curr3.Month__c=month;
   curr3.year__c=string.valueof(year);
   curr3.L3SubMetricName__c='Payment Terms';
   curr3.SubMetric_Name__c=l3submetricSubMetric1.get('Payment Terms');
   curr3.Score__c=(cstInnov[0].Payment_Terms_Score__c*l3submetricTarget.get('Payment Terms'))/100;
  insertList1.add(curr3);
 SSC_PriorQuarterScore__c curr4 = new SSC_PriorQuarterScore__c();
   curr4.Account__c = acc.id;
   curr4.GenerationDate__c=DateTime.ValueOf(system.now());
   curr4.Month__c=month;
   curr4.year__c=string.valueof(year);
   curr4.L3SubMetricName__c='Innovative Concepts';
   curr4.SubMetric_Name__c=l3submetricSubMetric1.get('Innovative Concepts');
   curr4.Score__c=(cstInnov[0].Innovative_Concepts_Score__c*l3submetricTarget.get('Innovative Concepts'))/100;
  insertList1.add(curr4);
  SSC_PriorQuarterScore__c curr5 = new SSC_PriorQuarterScore__c();
   curr5.Account__c = acc.id;
   curr5.GenerationDate__c=DateTime.ValueOf(system.now());
   curr5.Month__c=month;
   curr5.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr5.SubMetric_Name__c=SubMetricName1.get('Cost Competiveness');
   curr5.Score__c=(cstInnov[0].Cost_Competiveness_Score__c*submetricTarget.get('Cost Competiveness'))/100;
  insertList1.add(curr5);
   SSC_PriorQuarterScore__c curr6 = new SSC_PriorQuarterScore__c();
   curr6.Account__c = acc.id;
   curr6.GenerationDate__c=DateTime.ValueOf(system.now());
   curr6.Month__c=month;
   curr6.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr6.SubMetric_Name__c=SubMetricName1.get('Reduction Performance');
   curr6.Score__c=(cstInnov[0].Reduction_Performance_Score__c*submetricTarget.get('Reduction Performance'))/100;
  insertList1.add(curr6);
  SSC_PriorQuarterScore__c curr7 = new SSC_PriorQuarterScore__c();
   curr7.Account__c = acc.id;
   curr7.GenerationDate__c=DateTime.ValueOf(system.now());
   curr7.Month__c=month;
   curr7.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr7.SubMetric_Name__c=SubMetricName1.get('Cost Control');
   curr7.Score__c=(cstInnov[0].Cost_Control_Score__c*submetricTarget.get('Cost Control'))/100;
  insertList1.add(curr7);
  SSC_PriorQuarterScore__c curr8 = new SSC_PriorQuarterScore__c();
   curr8.Account__c = acc.id;
   curr8.GenerationDate__c=DateTime.ValueOf(system.now());
   curr8.Month__c=month;
   curr8.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr8.SubMetric_Name__c=SubMetricName1.get('Transparency');
   curr8.Score__c=(cstInnov[0].Transparency_Score__c*submetricTarget.get('Transparency'))/100;
  insertList1.add(curr8);
    SSC_PriorQuarterScore__c curr9 = new SSC_PriorQuarterScore__c();
   curr9.Account__c = acc.id;
   curr9.GenerationDate__c=DateTime.ValueOf(system.now());
   curr9.Month__c=month;
   curr9.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr9.SubMetric_Name__c=SubMetricName1.get('Escaping MCAR');
   curr9.Score__c=(qltyDel[0].Escaping_MCAR_Score__c*submetricTarget.get('Escaping MCAR'))/100;
  insertList1.add(curr9);
  SSC_PriorQuarterScore__c curr10 = new SSC_PriorQuarterScore__c();
   curr10.Account__c = acc.id;
   curr10.GenerationDate__c=DateTime.ValueOf(system.now());
   curr10.Month__c=month;
   curr10.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr10.SubMetric_Name__c=SubMetricName1.get('Quality Capability');
   curr10.Score__c=(qltyDel[0].Quality_Capability_Score__c*submetricTarget.get('Quality Capability'))/100;
  insertList1.add(curr10);
  SSC_PriorQuarterScore__c curr11 = new SSC_PriorQuarterScore__c();
   curr11.Account__c = acc.id;
   curr11.GenerationDate__c=DateTime.ValueOf(system.now());
   curr11.Month__c=month;
   curr11.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr11.SubMetric_Name__c=SubMetricName1.get('Defective PPM');
   curr11.Score__c=(qltyDel[0].Defective_PPM_Score__c*submetricTarget.get('Defective PPM'))/100;
  insertList1.add(curr11);
  SSC_PriorQuarterScore__c curr12 = new SSC_PriorQuarterScore__c();
   curr12.Account__c = acc.id;
   curr12.GenerationDate__c=DateTime.ValueOf(system.now());
   curr12.Month__c=month;
   curr12.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr12.SubMetric_Name__c=SubMetricName1.get('Commitment');
   curr12.Score__c=(qltyDel[0].Commitment_Score__c*submetricTarget.get('Commitment'))/100;
  insertList1.add(curr12);
   SSC_PriorQuarterScore__c curr13 = new SSC_PriorQuarterScore__c();
   curr13.Account__c = acc.id;
   curr13.GenerationDate__c=DateTime.ValueOf(system.now());
   curr13.Month__c=month;
   curr13.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr13.SubMetric_Name__c=SubMetricName1.get('OTD');
   curr13.Score__c=(qltyDel[0].OTD_Score__c*submetricTarget.get('OTD'))/100;
  insertList1.add(curr13);
   SSC_PriorQuarterScore__c curr14 = new SSC_PriorQuarterScore__c();
   curr14.Account__c = acc.id;
   curr14.GenerationDate__c=DateTime.ValueOf(system.now());
   curr14.Month__c=month;
   curr14.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr14.SubMetric_Name__c=SubMetricName1.get('Lead Time Compliance');
   curr14.Score__c=(qltyDel[0].Lead_Time_Score__c*submetricTarget.get('Lead Time Compliance'))/100;
  insertList1.add(curr14);
  SSC_PriorQuarterScore__c curr15 = new SSC_PriorQuarterScore__c();
   curr15.Account__c = acc.id;
   curr15.GenerationDate__c=DateTime.ValueOf(system.now());
   curr15.Month__c=month;
   curr15.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr15.SubMetric_Name__c=SubMetricName1.get('Agility');
   curr15.Score__c=(qltyDel[0].Agility_Score__c*submetricTarget.get('Agility'))/100;
  insertList1.add(curr15);
SSC_PriorQuarterScore__c curr16 = new SSC_PriorQuarterScore__c();
   curr16.Account__c = acc.id;
   curr16.GenerationDate__c=DateTime.ValueOf(system.now());
   curr16.Month__c=month;
   curr16.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr16.SubMetric_Name__c=SubMetricName1.get('Business Continuity');
   curr16.Score__c=(cstInnov[0].Business_Continuity_Score__c*submetricTarget.get('Business Continuity'))/100;
  insertList1.add(curr16);
  SSC_PriorQuarterScore__c curr17 = new SSC_PriorQuarterScore__c();
   curr17.Account__c = acc.id;
   curr17.GenerationDate__c=DateTime.ValueOf(system.now());
   curr17.Month__c=month;
   curr17.year__c=string.valueof(year);
  // curr5.L3SubMetricName__c='Innovative Concepts';
   curr17.SubMetric_Name__c=SubMetricName1.get('Corporate Social Responsibility');
   curr17.Score__c=(csrDash[0].Supplier_Score__c*submetricTarget.get('Corporate Social Responsibility'))/100;
  insertList1.add(curr17);

   
   
   
   }
   
   
   
   }
   if(insertList!=null   &&  insertList.size()>0 )
 database.insert(insertList); 
  if(insertList1!=null   &&  insertList1.size()>0 )
 database.insert(insertList1); 
  if(priorList!=null   &&  priorList.size()>0 )
 database.Delete(priorList); 
 }
  global void finish(Database.BatchableContext BC)
    {
       string datestring='Report Date:' + System.now().format('MMMM-dd-yyyy') + '\r\n' + '\r\n';  
        Messaging.SingleEmailMessage message = new   Messaging.SingleEmailMessage();
     
      message.setSaveAsActivity(false);
      message.setTargetObjectId(userinfo.getUserId());
      message.setSubject('Current ScoreCard Data Claculation Status');
      message.setPlainTextBody(datestring +'Current Scorecrad Data Calcualtion is completed.Please check the scorecards for individual Suppliers.');
       
      
      message.setToAddresses(new String[] {userInfo.getUserEmail() });
     
      Messaging.sendEmail(new Messaging.SingleEmailMessage[] {message});  
    
    
    }






}