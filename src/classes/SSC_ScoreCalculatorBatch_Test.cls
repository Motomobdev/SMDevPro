/*
*************************************************************************************************
Description:
This is the test class for SSC_ScoreCalculatorBatch


Revision History:
Author/Reviewer     Created/Revised Date   Change Description
 Sivani                     22-05-2015         Created   




*************************************************************************************************
*/

@isTest
public class SSC_ScoreCalculatorBatch_Test {
static testMethod void testscorCalc() {
Account acc= new Account();
acc.Name='AMERICAN AUDIO COMPONENTS INC';
acc.Oracle_Customer_Number__c='0431912';
acc.SSC_Scorecard_Required__c=true;
insert acc;
string month;
  if(system.today().month()==1)
{
month='Januray';
}
if(system.today().month()==2)
{
month='February';
}
if(system.today().month()==3)
{
month='March';
}
if(system.today().month()==4)
{
month='April';
}
if(system.today().month()==5)
{
month='May';
}
if(system.today().month()==6)
{
month='June';
}
if(system.today().month()==7)
{
month='July';
}
if(system.today().month()==8)
{
month='August';
}
if(system.today().month()==9)
{
month='September';
}
if(system.today().month()==10)
{
month='October';
}
if(system.today().month()==11)
{
month='November';
}
if(system.today().month()==12)
{
month='December';
}
integer year=system.today().year();
ScoreCardCSRDashboard__c csr = new ScoreCardCSRDashboard__c();

             csr.Status__c='Current';
             //csr.Supplier_Score__c=integer.valueof(inputvalues[8]);
             csr.Month__c=month;
             csr.Year__c=year;
             csr.Account_Name__c=acc.id;
             csr.ORacle_Customer_Number__c='0431912';
             csr.Status__c='Current';
             csr.Supplier_Score__c=80;
             
             
             insert csr;
             ScoreCardCostInnovation__c csr1 = new ScoreCardCostInnovation__c();
              csr1.Month__c=month;
             csr1.Year__c=year;
              csr1.Account_Name__c=acc.id;
              csr1.Business_Continuity_Score__c=80;
              csr1.Cost_Competiveness_Score__c=90;
              csr1.Cost_Control_Score__c=100;
              csr1.CSA_Status_Score__c=80;
              csr1.Innovative_Concepts_Score__c=70;
            // csr1.OracleCustNum__c='0431911';
             csr1.ORacle_Customer_Number__c='0431912';
             csr1.Payment_Terms_Score__c=80;
             csr1.Reduction_Performance_Score__c=70;
             csr1.SOI_Score__c=80;
             csr1.Status__c='Current';
             csr1.Technology_Roadmap_Score__c=90;
             csr1.Transparency_Score__c=40;
             insert csr1;
           ScoreCardQualityDelivery__c csr2 = new ScoreCardQualityDelivery__c();
            csr2.Month__c=month;
             csr2.Account_Name__c=acc.id;
             csr2.Year__c=year;
             csr2.Agility_Score__c=80;
             csr2.Commitment_Score__c=90;
             csr2.Defective_PPM_Score__c=70;
             csr2.Escaping_MCAR_Score__c=85;
             csr2.Lead_Time_Score__c=90;
             //csr2.OracleCustNum__c='0431911';
             csr2.ORacle_Customer_Number__c='0431912';
             csr2.OTD_Score__c=70;
             csr2.Quality_Capability_Score__c=80;
             csr2.Status__c='Current';
             insert csr2;
Map<string,Id> l3submetricName = new Map<string,Id>();
Map<string,Id> l3submetricSubMetric = new Map<string,Id>();
Map<string,Decimal> l3submetricTarget = new Map<string,Decimal>();
Map<string,Id> SubMetricName = new Map<string,Id>();
Map<string,Id> SubMetricMetric = new Map<string,Id>();
Map<string,Decimal> submetricTarget = new Map<string,Decimal>();

/*for(SSC_L3SubMetric__c l3 : [select Id,Name,End_Date__c,Start_Date__c,SSC_SubMetric__c,Target_Score__c from SSC_L3SubMetric__c where End_Date__c>:system.today() OR End_Date__c=null])
{

  l3submetricName.put(l3.Name,l3.Id);
  l3submetricSubMetric.put(l3.Name,l3.SSC_SubMetric__c);
  l3submetricTarget.put(l3.name,l3.Target_Score__c);

}
for(SSC_SubMetric__c sub : [select Id,Name,End_Date__c,Start_Date__c,Metric_Name__c,TargetScore__c from SSC_SubMetric__c where End_Date__c>:system.today() OR End_Date__c=null])
{

  SubMetricName.put(sub.Name,sub.Id);
  SubMetricMetric.put(sub.Name,sub.Metric_Name__c);
  submetricTarget.put(sub.Name,sub.TargetScore__c);

} */
SSC_ScoringGuide__c scGuide = new SSC_ScoringGuide__c();
scGuide.Name='test';
insert scGuide;
SSC_Metric__c metric= new SSC_Metric__c();
metric.name='test';
metric.SSC_ScoringGuide__c=scGuide.id;
insert metric;
SSC_SubMetric__c sub= new SSC_SubMetric__c();
sub.Name='test';
sub.TargetScore__c=9.0;
sub.Metric_Name__c=metric.id;
insert sub;
l3submetricName.put('Technology Roadmap Review',sub.id);
l3submetricSubMetric.put('Technology Roadmap Review',sub.id);
l3submetricTarget.put('Technology Roadmap Review',80);
l3submetricName.put('SOI',sub.id);
l3submetricSubMetric.put('SOI',sub.id);
l3submetricTarget.put('SOI',80);
l3submetricName.put('CSA Status',sub.id);
l3submetricSubMetric.put('CSA Status',sub.id);
l3submetricTarget.put('Payment Terms',80);
l3submetricName.put('Payment Terms',sub.id);
l3submetricSubMetric.put('Payment Terms',sub.id);
l3submetricTarget.put('CSA Status',80);
l3submetricName.put('Innovative Concepts',sub.id);
l3submetricSubMetric.put('Innovative Concepts',sub.id);
l3submetricTarget.put('Innovative Concepts',80);
SubMetricName.put('Cost Competiveness',sub.id);
SubMetricMetric.put('Cost Competiveness',sub.id);
submetricTarget.put('Cost Competiveness',80);

SubMetricName.put('Reduction Performance',sub.id);
SubMetricMetric.put('Reduction Performance',sub.id);
submetricTarget.put('Reduction Performance',80);
SubMetricName.put('Cost Control',sub.id);
SubMetricMetric.put('Cost Control',sub.id);
submetricTarget.put('Cost Control',80);

SubMetricName.put('Transparency',sub.id);
SubMetricMetric.put('Transparency',sub.id);
submetricTarget.put('Transparency',80);

SubMetricName.put('Escaping MCAR',sub.id);
SubMetricMetric.put('Escaping MCAR',sub.id);
submetricTarget.put('Escaping MCAR',80);

SubMetricName.put('Quality Capability',sub.id);
SubMetricMetric.put('Quality Capability',sub.id);
submetricTarget.put('Quality Capability',80);
SubMetricName.put('Defective PPM',sub.id);
SubMetricMetric.put('Defective PPM',sub.id);
submetricTarget.put('Defective PPM',80);

SubMetricName.put('Commitment',sub.id);
SubMetricMetric.put('Commitment',sub.id);
submetricTarget.put('Commitment',80);

SubMetricName.put('OTD',sub.id);
SubMetricMetric.put('OTD',sub.id);
submetricTarget.put('OTD',80);

SubMetricName.put('Lead Time Compliance',sub.id);
SubMetricMetric.put('Lead Time Compliance',sub.id);
submetricTarget.put('Lead Time Compliance',80);

SubMetricName.put('Agility',sub.id);
SubMetricMetric.put('Agility',sub.id);
submetricTarget.put('Agility',80);


SubMetricName.put('Business Continuity',sub.id);
SubMetricMetric.put('Business Continuity',sub.id);
submetricTarget.put('Business Continuity',80);

SubMetricName.put('Corporate Social Responsibility',sub.id);
SubMetricMetric.put('Corporate Social Responsibility',sub.id);
submetricTarget.put('Corporate Social Responsibility',80);


//string month;
  if(system.today().month()==1)
{
month='Januray';
}
if(system.today().month()==2)
{
month='February';
}
if(system.today().month()==3)
{
month='March';
}
if(system.today().month()==4)
{
month='April';
}
if(system.today().month()==5)
{
month='May';
}
if(system.today().month()==6)
{
month='June';
}
if(system.today().month()==7)
{
month='July';
}
if(system.today().month()==8)
{
month='August';
}
if(system.today().month()==9)
{
month='September';
}
if(system.today().month()==10)
{
month='October';
}
if(system.today().month()==11)
{
month='November';
}
if(system.today().month()==12)
{
month='December';
}
//integer year=system.today().year();
             
 SSC_ScoreCalculatorBatch batch = new SSC_ScoreCalculatorBatch(l3submetricName,l3submetricSubMetric,SubMetricName,SubMetricMetric,month,year,l3submetricTarget,submetricTarget);
database.executeBatch(batch,50);     
             
             
}


static testMethod void testscorCalc2() {
Account acc= new Account();
acc.Name='AMERICAN AUDIO COMPONENTS INC';
acc.Oracle_Customer_Number__c='0431912';
acc.SSC_Scorecard_Required__c=true;
insert acc;
string month;
  if(system.today().month()==1)
{
month='Januray';
}
if(system.today().month()==2)
{
month='February';
}
if(system.today().month()==3)
{
month='March';
}
if(system.today().month()==4)
{
month='April';
}
if(system.today().month()==5)
{
month='May';
}
if(system.today().month()==6)
{
month='June';
}
if(system.today().month()==7)
{
month='July';
}
if(system.today().month()==8)
{
month='August';
}
if(system.today().month()==9)
{
month='September';
}
if(system.today().month()==10)
{
month='October';
}
if(system.today().month()==11)
{
month='November';
}
if(system.today().month()==12)
{
month='December';
}
month='January';
integer year=system.today().year();
ScoreCardCSRDashboard__c csr = new ScoreCardCSRDashboard__c();

             csr.Status__c='Current';
             //csr.Supplier_Score__c=integer.valueof(inputvalues[8]);
             csr.Month__c=month;
             csr.Year__c=year;
             csr.Account_Name__c=acc.id;
             csr.ORacle_Customer_Number__c='0431912';
             csr.Status__c='Current';
             csr.Supplier_Score__c=80;
             
             
             insert csr;
             ScoreCardCostInnovation__c csr1 = new ScoreCardCostInnovation__c();
              csr1.Month__c=month;
             csr1.Year__c=year;
              csr1.Account_Name__c=acc.id;
              csr1.Business_Continuity_Score__c=80;
              csr1.Cost_Competiveness_Score__c=90;
              csr1.Cost_Control_Score__c=100;
              csr1.CSA_Status_Score__c=80;
              csr1.Innovative_Concepts_Score__c=70;
            // csr1.OracleCustNum__c='0431911';
             csr1.ORacle_Customer_Number__c='0431912';
             csr1.Payment_Terms_Score__c=80;
             csr1.Reduction_Performance_Score__c=70;
             csr1.SOI_Score__c=80;
             csr1.Status__c='Current';
             csr1.Technology_Roadmap_Score__c=90;
             csr1.Transparency_Score__c=40;
             insert csr1;
           ScoreCardQualityDelivery__c csr2 = new ScoreCardQualityDelivery__c();
            csr2.Month__c=month;
             csr2.Account_Name__c=acc.id;
             csr2.Year__c=year;
             csr2.Agility_Score__c=80;
             csr2.Commitment_Score__c=90;
             csr2.Defective_PPM_Score__c=70;
             csr2.Escaping_MCAR_Score__c=85;
             csr2.Lead_Time_Score__c=90;
             //csr2.OracleCustNum__c='0431911';
             csr2.ORacle_Customer_Number__c='0431912';
             csr2.OTD_Score__c=70;
             csr2.Quality_Capability_Score__c=80;
             csr2.Status__c='Current';
             insert csr2;
Map<string,Id> l3submetricName = new Map<string,Id>();
Map<string,Id> l3submetricSubMetric = new Map<string,Id>();
Map<string,Decimal> l3submetricTarget = new Map<string,Decimal>();
Map<string,Id> SubMetricName = new Map<string,Id>();
Map<string,Id> SubMetricMetric = new Map<string,Id>();
Map<string,Decimal> submetricTarget = new Map<string,Decimal>();

/*for(SSC_L3SubMetric__c l3 : [select Id,Name,End_Date__c,Start_Date__c,SSC_SubMetric__c,Target_Score__c from SSC_L3SubMetric__c where End_Date__c>:system.today() OR End_Date__c=null])
{

  l3submetricName.put(l3.Name,l3.Id);
  l3submetricSubMetric.put(l3.Name,l3.SSC_SubMetric__c);
  l3submetricTarget.put(l3.name,l3.Target_Score__c);

}
for(SSC_SubMetric__c sub : [select Id,Name,End_Date__c,Start_Date__c,Metric_Name__c,TargetScore__c from SSC_SubMetric__c where End_Date__c>:system.today() OR End_Date__c=null])
{

  SubMetricName.put(sub.Name,sub.Id);
  SubMetricMetric.put(sub.Name,sub.Metric_Name__c);
  submetricTarget.put(sub.Name,sub.TargetScore__c);

} */
SSC_ScoringGuide__c scGuide = new SSC_ScoringGuide__c();
scGuide.Name='test';
insert scGuide;
SSC_Metric__c metric= new SSC_Metric__c();
metric.name='test';
metric.SSC_ScoringGuide__c=scGuide.id;
insert metric;
SSC_SubMetric__c sub= new SSC_SubMetric__c();
sub.Name='test';
sub.TargetScore__c=9.0;
sub.Metric_Name__c=metric.id;
insert sub;
l3submetricName.put('Technology Roadmap Review',sub.id);
l3submetricSubMetric.put('Technology Roadmap Review',sub.id);
l3submetricTarget.put('Technology Roadmap Review',80);
l3submetricName.put('SOI',sub.id);
l3submetricSubMetric.put('SOI',sub.id);
l3submetricTarget.put('SOI',80);
l3submetricName.put('CSA Status',sub.id);
l3submetricSubMetric.put('CSA Status',sub.id);
l3submetricTarget.put('Payment Terms',80);
l3submetricName.put('Payment Terms',sub.id);
l3submetricSubMetric.put('Payment Terms',sub.id);
l3submetricTarget.put('CSA Status',80);
l3submetricName.put('Innovative Concepts',sub.id);
l3submetricSubMetric.put('Innovative Concepts',sub.id);
l3submetricTarget.put('Innovative Concepts',80);
SubMetricName.put('Cost Competiveness',sub.id);
SubMetricMetric.put('Cost Competiveness',sub.id);
submetricTarget.put('Cost Competiveness',80);

SubMetricName.put('Reduction Performance',sub.id);
SubMetricMetric.put('Reduction Performance',sub.id);
submetricTarget.put('Reduction Performance',80);
SubMetricName.put('Cost Control',sub.id);
SubMetricMetric.put('Cost Control',sub.id);
submetricTarget.put('Cost Control',80);

SubMetricName.put('Transparency',sub.id);
SubMetricMetric.put('Transparency',sub.id);
submetricTarget.put('Transparency',80);

SubMetricName.put('Escaping MCAR',sub.id);
SubMetricMetric.put('Escaping MCAR',sub.id);
submetricTarget.put('Escaping MCAR',80);

SubMetricName.put('Quality Capability',sub.id);
SubMetricMetric.put('Quality Capability',sub.id);
submetricTarget.put('Quality Capability',80);
SubMetricName.put('Defective PPM',sub.id);
SubMetricMetric.put('Defective PPM',sub.id);
submetricTarget.put('Defective PPM',80);

SubMetricName.put('Commitment',sub.id);
SubMetricMetric.put('Commitment',sub.id);
submetricTarget.put('Commitment',80);

SubMetricName.put('OTD',sub.id);
SubMetricMetric.put('OTD',sub.id);
submetricTarget.put('OTD',80);

SubMetricName.put('Lead Time Compliance',sub.id);
SubMetricMetric.put('Lead Time Compliance',sub.id);
submetricTarget.put('Lead Time Compliance',80);

SubMetricName.put('Agility',sub.id);
SubMetricMetric.put('Agility',sub.id);
submetricTarget.put('Agility',80);


SubMetricName.put('Business Continuity',sub.id);
SubMetricMetric.put('Business Continuity',sub.id);
submetricTarget.put('Business Continuity',80);

SubMetricName.put('Corporate Social Responsibility',sub.id);
SubMetricMetric.put('Corporate Social Responsibility',sub.id);
submetricTarget.put('Corporate Social Responsibility',80);


//string month;
  if(system.today().month()==1)
{
month='Januray';
}
if(system.today().month()==2)
{
month='February';
}
if(system.today().month()==3)
{
month='March';
}
if(system.today().month()==4)
{
month='April';
}
if(system.today().month()==5)
{
month='May';
}
if(system.today().month()==6)
{
month='June';
}
if(system.today().month()==7)
{
month='July';
}
if(system.today().month()==8)
{
month='August';
}
if(system.today().month()==9)
{
month='September';
}
if(system.today().month()==10)
{
month='October';
}
if(system.today().month()==11)
{
month='November';
}
if(system.today().month()==12)
{
month='December';
}
//integer year=system.today().year();
  month='January';           
 SSC_ScoreCalculatorBatch batch = new SSC_ScoreCalculatorBatch(l3submetricName,l3submetricSubMetric,SubMetricName,SubMetricMetric,month,year,l3submetricTarget,submetricTarget);
database.executeBatch(batch,50);     
             
             
}
             
             
             
 
      










}