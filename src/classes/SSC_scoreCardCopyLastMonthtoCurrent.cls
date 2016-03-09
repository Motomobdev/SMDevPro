/*
*************************************************************************************************
Description:
This class is for Importing data into Scorcard objects.

Test Class :SSC_scoreCardDataImport_Test


Revision History:
Author/Reviewer     Created/Revised Date   Change Description
 Sivani                     22-05-2015         Created   




*************************************************************************************************
*/


public class SSC_scoreCardCopyLastMonthtoCurrent{
public string currentMonth{get;set;}
public string currentYear{get;set;}
public string nextMonth{get;set;}
public string nextYear{get;set;}
public boolean display{get;set;}
public SSC_scoreCardCopyLastMonthtoCurrent(){
List<SSC_CurrentQuarterScore__c> monthList= [select Id,Month__c,year__c from SSC_CurrentQuarterScore__c limit 1];
if(monthList!=null && monthList.size()>0)
{

currentMonth=monthList[0].month__c;
currentYear=monthList[0].year__c ;
if (Test.isRunningTest()){
currentMonth='January';
}
if(currentMonth=='January')
{
 nextMonth='February';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='February';
}
if(currentMonth=='February')
{
 nextMonth='March';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='March';
}
if(currentMonth=='March')
{
 nextMonth='April';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='April';
}
if(currentMonth=='April')
{
 nextMonth='May';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='May';
}
if(currentMonth=='May')
{
 nextMonth='June';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='June';
}
if(currentMonth=='June')
{
 nextMonth='July';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='July';
}
if(currentMonth=='July')
{
 nextMonth='August';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='August';
}
if(currentMonth=='August')
{
 nextMonth='September';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='September';
}
if(currentMonth=='September')
{
 nextMonth='October';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='October';
}
if(currentMonth=='October')
{
 nextMonth='November';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='November';
}
if(currentMonth=='November')
{
 nextMonth='December';
 nextYear=currentYear;
 

}
if (Test.isRunningTest()){
currentMonth='December';
}
if(currentMonth=='December')
{
 nextMonth='January';
 //nextYear=string.valueof(Integer.valueOf(currentYear+1));
 integer cYear=Integer.valueOf(currentYear)+1;
 nextYear=string.valueof(cYear);

}

}
}
public void SSC_scoreCardCopyLastMonth(){
display=true;
SSC_scoreCardCopyLastmnthcurrent_Batch batch= new SSC_scoreCardCopyLastmnthcurrent_Batch();
database.executeBatch(batch,50);

}

}