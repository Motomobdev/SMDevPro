/*
*************************************************************************************************
Description:
This is the test class for SSC_scoreCardDataImport


Revision History:
Author/Reviewer     Created/Revised Date   Change Description
 Sivani                     22-05-2015         Created   




*************************************************************************************************
*/

@isTest
public class SSC_scoreCardDataImport_Test {


static testMethod void testdataimport() {
SSC_scoreCardDataImport cls = new SSC_scoreCardDataImport();
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
SSC_L3SubMetric__c l3 = new SSC_L3SubMetric__c();
l3.name='test';
l3.End_Date__c=system.today()+1;
l3.SSC_SubMetric__c=sub.id;
l3.Target_Score__c=80;
insert l3;
cls.noConfirm();
cls.yesConfirm1();
cls.getyears();
cls.confirm=true;
cls.confirmation=true;
cls.confirm1=true;
cls.confirmation1=true;
cls.confirm2=true;
cls.confirmation2=true;
cls.yesConfirm2();
cls.yesConfirm3();
/*cls.csvFile1=Blob.valueOf('Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,80,60,90,\n');
cls.csvFile2=Blob.valueof('AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n');
cls.csvFile3=Blob.ValueOf('AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n');
*/
cls.csvFile1=Blob.valueOf('Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,80,60,90,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,431911,trr,AMERICAN AUDIO COMPONENTS INC,-,-,-,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,31911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,1911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,11,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,1,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n');
cls.csvFile2=Blob.valueof('AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,431911,-,-,-,-,-,-,-,-,-,-,\n,AMERICAN AUDIO COMPONENTS INC,31911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,1911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,11,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,1,80,50,90,80,70,70,60,40,80,90,\n');
cls.csvFile3=Blob.ValueOf('AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,431911,-,-,-,-,-,-,-, \n,AMERICAN AUDIO COMPONENTS INC,31911,-,-,-,-,-,-,-, \n,AMERICAN AUDIO COMPONENTS INC,1911,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,911,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,11,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,1,60,70,80,30,50,40,90, \n');


cls.importdatacsr();
cls.importdatacst();
cls.importdataQlty();


}

static testMethod void testdataimport1() {
SSC_scoreCardDataImport cls = new SSC_scoreCardDataImport();
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
cls.confirm=true;
cls.confirmation=true;
cls.confirm=true;
cls.confirmation=true;
cls.confirm1=true;
cls.confirmation1=true;
cls.confirm2=true;
cls.confirmation2=true;
//Account acc=[select Id,name from Account where Oracle_Customer_Number__c='0431911' LIMIT 1];
Account acc= new Account();
acc.Name='AMERICAN AUDIO COMPONENTS INC';
acc.Oracle_Customer_Number__c='0431911';
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
ScoreCardCostInnovation__c csr = new ScoreCardCostInnovation__c();

             csr.Status__c='Current';
             //csr.Supplier_Score__c=integer.valueof(inputvalues[8]);
             csr.Month__c=month;
             csr.Year__c=year;
             csr.Account_Name__c=acc.id;
             insert csr;
             ScoreCardCSRDashboard__c csr1 = new ScoreCardCSRDashboard__c();
              csr1.Month__c=month;
             csr1.Year__c=year;
              csr1.Account_Name__c=acc.id;
             insert csr1;
           ScoreCardQualityDelivery__c csr2 = new ScoreCardQualityDelivery__c();
            csr2.Month__c=month;
             csr2.Account_Name__c=acc.id;
             csr2.Year__c=year;
             insert csr2;
cls.csvFile1=Blob.valueOf('Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,80,60,90,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,431911,trr,AMERICAN AUDIO COMPONENTS INC,-,-,-,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,31911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,1911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,11,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,1,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n');
cls.csvFile2=Blob.valueof('AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,431911,-,-,-,-,-,-,-,-,-,-,\n,AMERICAN AUDIO COMPONENTS INC,31911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,1911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,11,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,1,80,50,90,80,70,70,60,40,80,90,\n');
cls.csvFile3=Blob.ValueOf('AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,431911,-,-,-,-,-,-,-, \n,AMERICAN AUDIO COMPONENTS INC,31911,-,-,-,-,-,-,-, \n,AMERICAN AUDIO COMPONENTS INC,1911,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,911,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,11,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,1,60,70,80,30,50,40,90, \n');
cls.importdatacsr();
cls.importdatacst();
cls.importdataQlty();



}

static testMethod void testdataimport2() {
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
SSC_scoreCardDataImport cls = new SSC_scoreCardDataImport();
/*cls.csrFile='Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,80,60,90,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,431911,trr,AMERICAN AUDIO COMPONENTS INC,-,-,-,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,31911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,1911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,11,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,1,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n';
cls.cstFile='AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,431911,-,-,-,-,-,-,-,-,-,-,\n,AMERICAN AUDIO COMPONENTS INC,31911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,1911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,11,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,1,80,50,90,80,70,70,60,40,80,90,\n';
cls.qltyFile='AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,431911,-,-,-,-,-,-,-, \n,AMERICAN AUDIO COMPONENTS INC,31911,-,-,-,-,-,-,-, \n,AMERICAN AUDIO COMPONENTS INC,1911,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,911,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,11,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,1,60,70,80,30,50,40,90, \n';
*/
cls.csvFile1=Blob.valueOf('Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,0431911,trr,AMERICAN AUDIO COMPONENTS INC,80,60,90,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,431911,trr,AMERICAN AUDIO COMPONENTS INC,80,60,90,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,31911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,1911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,911,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,11,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n,Aac,AMERICAN AUDIO COMPONENTS INC,Mechanicals,Acoustics,1,trr,AMERICAN AUDIO COMPONENTS INC,PSL,60,PSL,\n');
cls.csvFile2=Blob.valueof('AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90, \n, AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,0431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,431911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,31911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,1911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,911,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,11,80,50,90,80,70,70,60,40,80,90,\n,AMERICAN AUDIO COMPONENTS INC,1,80,50,90,80,70,70,60,40,80,90,\n');
cls.csvFile3=Blob.ValueOf('AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,0431911,80,80,80,80,80,80,80, \n,AMERICAN AUDIO COMPONENTS INC,431911,80,80,80,80,80,80,80,  \n,AMERICAN AUDIO COMPONENTS INC,31911,80,80,80,80,80,80,80,  \n,AMERICAN AUDIO COMPONENTS INC,1911,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,911,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,11,60,70,80,30,50,40,90, \n,AMERICAN AUDIO COMPONENTS INC,1,60,70,80,30,50,40,90, \n');
cls.yesConfirm1();
cls.noConfirm();

cls.clearExistingScores();
cls.socrecardBackup();
cls.CalculateScores();



}



}