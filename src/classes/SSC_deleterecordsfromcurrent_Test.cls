/**********************************************************/
// Created by:Sivani Mallampalli
// Created Date: 22/5/2015
// 
// 
//
// Description:
// This is the test class for SSC_deleterecordsfromcurrent
// 
// Test Class: 
// SSC_deleterecordsfromcurrent_Test.cls
/**********************************************************/


@isTest
public class SSC_deleterecordsfromcurrent_Test {

static testMethod void testsdelScore() {
Account acc= new Account();
acc.Name='AMERICAN AUDIO COMPONENTSe INC';
acc.Oracle_Customer_Number__c='0431913';
acc.SSC_Scorecard_Required__c=true;
insert acc;
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

SSC_CurrentQuarterScore__c curr3 = new SSC_CurrentQuarterScore__c();
   curr3.Account__c = acc.id;
   curr3.GenerationDate__c=DateTime.ValueOf(system.now());
   curr3.Month__c='May';
   curr3.year__c='2015';
   curr3.L3SubMetricName__c='Payment Terms';
   curr3.SubMetric_Name__c=sub.id;
   curr3.Score__c=7.50;
  insert curr3;
  SSC_deleterecordsfromcurrent batch = new SSC_deleterecordsfromcurrent();
database.executeBatch(batch,50);   




}





}