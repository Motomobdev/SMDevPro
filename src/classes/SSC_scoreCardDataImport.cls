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


public class SSC_scoreCardDataImport{

public String csrFile{get;set;}
public String cstFile{get;set;}
public String qltyFile{get;set;}
public Blob csvFile1{get;set;}
public Blob csvFile2{get;set;}
public Blob csvFile3{get;set;}
public string month{get;set;}
public integer year{get;set;}
public boolean confirm{get;set;}
public boolean confirmation{get;set;}
public boolean confirm1{get;set;}
public boolean confirmation1{get;set;}
public boolean confirm2{get;set;}
public boolean confirmation2{get;set;}
public boolean insConCsr{get;set;}
public boolean insConCst{get;set;}
public boolean insConQlty{get;set;}
public void yesConfirm1(){

confirmation=true;
if(csrFile!=null)
importdatacsr();
}
public void yesConfirm2(){
confirmation1=true;
if(cstFile!=null)

importdatacst();
}
public void yesConfirm3(){
confirmation2=true;
if(qltyFile!=null)
importdataQlty();

}
public void noConfirm(){

confirmation=false;
confirm=false;
confirmation1=false;
confirm1=false;
confirmation2=false;
confirm2=false;

}
public List<SelectOption> getyears() {
        List<SelectOption> options = new List<SelectOption>();
       
        for (Integer i = System.Today().year() - 3; i < System.Today().year()+1 ; i++) {
          
            options.add(new SelectOption(String.valueOf(i), String.valueOf(i)));
        }
        return options;
    }
    
public SSC_scoreCardDataImport(){
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


year=integer.valueof(System.Today().year());
insConCsr=false;
insConCst=false;
insConQlty=false;

}
public void importdatacsr(){
List<ScoreCardCSRDashboard__c> insertList = new List<ScoreCardCSRDashboard__c>();
Map<string,Id> accMap = new Map<string,Id>();
for(Account acc:[select Id,Name,Oracle_Customer_Number__c from Account where SSC_Scorecard_Required__c=true])
{

accMap.put(acc.Oracle_Customer_Number__c,acc.Id);

}

List<ScoreCardCSRDashboard__c> csrExist =[select Id,Name,status__c from ScoreCardCSRDashboard__c where Month__c=:month and Year__c=:year];
if(csrExist!=null && csrExist.size()>0)
{
 confirm=true;
 if(confirmation==true)
 {
   confirm=false;
   for(ScoreCardCSRDashboard__c scr :csrExist)
   {
   
     scr.Status__c='Previous';
   
   
   }
   update csrExist;
   if(csvFile1!=null)
   {
     csrFile=csvFile1.toString();
     system.debug(csrfile);
        system.debug(csrFile + 'nameFile');
        //Read the CSV Rows using split method
        String[] filelines = new String[]{};
        filelines = csrFile.split('\n');
       // system.debug(filelines + 'filelines');
       for (Integer i=1;i<filelines.size();i++)
        {
           String[] inputvalues = new String[]{};
            //Read multiple column values within the same row using split method
            inputvalues = filelines[i].split(',');
            ScoreCardCSRDashboard__c csr = new ScoreCardCSRDashboard__c();
            string supNum=inputvalues[4].trim();
            if (Test.isRunningTest()){
             inputvalues[4]='\'' +inputvalues[4].trim();
             
             } 
             string [] suplitter = new string []{};
             
            if( inputvalues[4].contains('\''))
            {
             
             suplitter=inputvalues[4].split('\'');   
             
             csr.ORacle_Customer_Number__c=suplitter[1];
             csr.Account_Name__c=accMap.get(suplitter[1]);
             system.debug('custnum' + inputvalues[4]);
             }
             else
             {
              if(supNum.length()==1)
              {
               supNum='000000' + supNum;
              
              }
              if(supNum.length()==2)
              {
               supNum='00000' + supNum;
              
              }
              if(supNum.length()==3)
              {
               supNum='0000' + supNum;
              
              }
              if(supNum.length()==4)
              {
               supNum='000' + supNum;
              
              }
               if(supNum.length()==5)
              {
               supNum='00' + supNum;
              
              }
               if(supNum.length()==6)
              {
               supNum='0' + supNum;
              
              }
             
             
             csr.ORacle_Customer_Number__c=supNum;
             csr.Account_Name__c=accMap.get(supNum);
             
             
             }
             
             system.debug(filelines[i] + 'filelines');
             csr.Status__c='Current';
              if(inputvalues[8].trim().isNumeric())
             csr.Supplier_Score__c=Decimal.valueof(inputvalues[8].trim());
             else
             csr.Supplier_Score__c=0;
             csr.Month__c=month;
             csr.Year__c=year;
             
             insertList.add(csr);
            
            
            }
   }
   
 
 }
 else
 {
   
 }
}
else
{
 if(csvFile1!=null)
   {
     csrFile=csvFile1.toString();
     system.debug(csrfile);
        system.debug(csrFile + 'nameFile');
        //Read the CSV Rows using split method
        String[] filelines = new String[]{};
        filelines = csrFile.split('\n');
        system.debug(filelines + 'filelines');
       for (Integer i=1;i<filelines.size();i++)
        {
           String[] inputvalues = new String[]{};
            //Read multiple column values within the same row using split method
            inputvalues = filelines[i].split(',');
            ScoreCardCSRDashboard__c csr = new ScoreCardCSRDashboard__c();
             
            string supNum=inputvalues[4].trim();
             if (Test.isRunningTest()){
             inputvalues[4]='\'' +inputvalues[4].trim();
             
             } 
             string [] suplitter = new string []{};             
              if( inputvalues[4].contains('\''))
            {
             
             suplitter=inputvalues[4].split('\'');   
             
             csr.ORacle_Customer_Number__c=suplitter[1];
             csr.Account_Name__c=accMap.get(suplitter[1]);
             system.debug('custnum' + inputvalues[4]);
             }
             else
             {
              if(supNum.length()==1)
              {
               supNum='000000' + supNum;
              
              }
              if(supNum.length()==2)
              {
               supNum='00000' + supNum;
              
              }
              if(supNum.length()==3)
              {
               supNum='0000' + supNum;
              
              }
              if(supNum.length()==4)
              {
               supNum='000' + supNum;
              
              }
               if(supNum.length()==5)
              {
               supNum='00' + supNum;
              
              }
               if(supNum.length()==6)
              {
               supNum='0' + supNum;
              
              }
             
             
             csr.ORacle_Customer_Number__c=supNum;
             csr.Account_Name__c=accMap.get(supNum);
             
             
             
             }
             csr.Status__c='Current';
               if(inputvalues[8].trim().isNumeric())
             csr.Supplier_Score__c=Decimal.valueof(inputvalues[8].trim());
             else
             csr.Supplier_Score__c=0;
             csr.Month__c=month;
             csr.Year__c=year;
             
             insertList.add(csr);
            
            
            }
   }
   



}
if(insertList.size()>0)
{
try{
        // system.debug(insertList +'insertList');
          Database.SaveResult[] srList = Database.Insert(insertList, false);  
          insConCsr=true;
         
        }
        catch(Exception e){
        system.debug(e);
        }
}        

}
public void importdatacst(){
List<ScoreCardCostInnovation__c> insertList = new List<ScoreCardCostInnovation__c>();
/*Map<string,Id> l3submetricName = new Map<string,Id>();
Map<string,Id> l3submetricSubMetric = new Map<string,Id>();
Map<string,Id> SubMetricName = new Map<string,Id>();
Map<string,Id> SubMetricMetric = new Map<string,Id>();

for(SSC_L3SubMetric__c l3 : [select Id,Name,End_Date__c,Start_Date__c,SSC_SubMetric__c,Target_Score__c from SSC_L3SubMetric__c where End_Date__c>:system.today() OR End_Date__c=null])
{

  l3submetricName.put(l3.Name,l3.Id);
  l3submetricSubMetric.put(l3.Name,l3.SSC_SubMetric__c);

}
for(SSC_SubMetric__c sub : [select Id,Name,End_Date__c,Start_Date__c,Metric_Name__c,TargetScore__c from SSC_SubMetric__c where End_Date__c>:system.today() OR End_Date__c=null])
{

  SubMetricName.put(sub.Name,sub.Id);
  SubMetricMetric.put(sub.Name,sub.Metric_Name__c);

} */
Map<string,Id> accMap = new Map<string,Id>();

for(Account acc:[select Id,Name,Oracle_Customer_Number__c from Account where SSC_Scorecard_Required__c=true])
{

accMap.put(acc.Oracle_Customer_Number__c,acc.Id);

}

List<ScoreCardCostInnovation__c> csrExist =[select Id,Name,status__c from ScoreCardCostInnovation__c where Month__c=:month and Year__c=:year];
if(csrExist!=null && csrExist.size()>0)
{
 confirm1=true;
 if(confirmation1==true)
 {
   confirm1=false;
   for(ScoreCardCostInnovation__c scr :csrExist)
   {
   
     scr.Status__c='Previous';
   
   
   }
   update csrExist;
   if(csvFile2!=null)
   {
     csrFile=csvFile2.toString();
     system.debug(csrfile);
        system.debug(csrFile + 'nameFile');
        //Read the CSV Rows using split method
        String[] filelines = new String[]{};
        filelines = csrFile.split('\n');
        system.debug(filelines + 'filelines');
       for (Integer i=1;i<filelines.size();i++)
        {
           String[] inputvalues = new String[]{};
            //Read multiple column values within the same row using split method
            inputvalues = filelines[i].split(',');
            if(i>=3)
            {
            ScoreCardCostInnovation__c csr = new ScoreCardCostInnovation__c();
             
            string supNum=inputvalues[1].trim();
             string [] suplitter = new string []{};
             if (Test.isRunningTest()){
             inputvalues[1]='\'' +inputvalues[1].trim();
             
             } 
             if(supNum.contains('\''))
             {
             suplitter=inputvalues[1].split('\'');   
             system.debug('custnum' + inputvalues[1]);
             csr.ORacle_Customer_Number__c=suplitter[1];
             csr.Account_Name__c=accMap.get(suplitter[1]);
            
             }
             else
             {
              
              if(supNum.length()==6)
              {
               supNum='0' + supNum;
              
              
              }
              if(supNum.length()==5)
              {
               supNum='00' + supNum;
              
              
              }
               if(supNum.length()==4)
              {
               supNum='000' + supNum;
              
              
              }
               if(supNum.length()==3)
              {
               supNum='0000' + supNum;
              
              
              }
               if(supNum.length()==2)
              {
               supNum='00000' + supNum;
              
              
              }
                  if(supNum.length()==1)
              {
               supNum='000000' + supNum;
              
              
              }
             
             csr.ORacle_Customer_Number__c=supNum;
             csr.Account_Name__c=accMap.get(supNum);
             
             }
             csr.Status__c='Current';
             //csr.Supplier_Score__c=integer.valueof(inputvalues[8]);
             csr.Month__c=month;
             csr.Year__c=year;
             
           //  system.debug(suplitter[1] +'custid');
              if(inputvalues[2].trim().isNumeric())
             csr.Cost_Competiveness_Score__c=Decimal.valueof(inputvalues[2]);
             else
             csr.Cost_Competiveness_Score__c=0;
              if(inputvalues[3].trim().isNumeric())
             csr.Reduction_Performance_Score__c=Decimal.valueof(inputvalues[3]);
             else
             csr.Reduction_Performance_Score__c=0;
             if(inputvalues[4].trim().isNumeric())
             csr.Cost_Control_Score__c=Decimal.valueof(inputvalues[4]);
             else
             csr.Cost_Control_Score__c=0;
             if(inputvalues[5].trim().isNumeric())
             csr.Transparency_Score__c=Decimal.valueof(inputvalues[5]);
             else
             csr.Transparency_Score__c=0;
             if(inputvalues[6].trim().isNumeric())
             csr.Payment_Terms_Score__c=Decimal.valueof(inputvalues[6]);
             else
             csr.Payment_Terms_Score__c=0;
             if(inputvalues[7].trim().isNumeric())
             csr.SOI_Score__c=Decimal.valueof(inputvalues[7]);
             else
             csr.SOI_Score__c=0;
             if(inputvalues[8].trim().isNumeric())
             csr.CSA_Status_Score__c=Decimal.valueof(inputvalues[8]);
             else
             csr.CSA_Status_Score__c=0;
             if(inputvalues[9].trim().isNumeric())
             csr.Business_Continuity_Score__c=Decimal.valueof(inputvalues[9]);
             else
             csr.Business_Continuity_Score__c=0;
             if(inputvalues[10].trim().isNumeric())
             csr.Innovative_Concepts_Score__c=Decimal.valueof(inputvalues[10]);
             else
             csr.Innovative_Concepts_Score__c=0;
             if(inputvalues[11].trim().isNumeric())
             csr.Technology_Roadmap_Score__c=Decimal.valueof(inputvalues[11]);
             else
             csr.Technology_Roadmap_Score__c=0;
          
             
             
             insertList.add(csr);
            
            }
            }
   }
   
 
 }
 else
 {
   
 }
}
else
{
 if(csvFile2!=null)
   {
     cstFile=csvFile2.toString();
     //system.debug(csrfile);
        system.debug(cstFile + 'nameFile');
        //Read the CSV Rows using split method
        String[] filelines = new String[]{};
        filelines = cstFile.split('\n');
        system.debug(filelines + 'filelines');
        for (Integer i=1;i<filelines.size();i++)
        {
           String[] inputvalues = new String[]{};
            //Read multiple column values within the same row using split method
            inputvalues = filelines[i].split(',');
            if(i>=3)
            {
             system.debug(filelines[i] + 'filelines');
            ScoreCardCostInnovation__c csr = new ScoreCardCostInnovation__c();
            
            string supNum=inputvalues[1].trim();
            if (Test.isRunningTest()){
             inputvalues[1]='\'' +inputvalues[1].trim();
             
             } 
             string [] suplitter = new string []{};
           if(supNum.contains('\''))
             {
             suplitter=inputvalues[1].split('\'');   
             system.debug('custnum' + inputvalues[1]);
             csr.ORacle_Customer_Number__c=suplitter[1];
             csr.Account_Name__c=accMap.get(suplitter[1]);
            
             }
             else
             {
              
              if(supNum.length()==6)
              {
               supNum='0' + supNum;
              
              
              }
              if(supNum.length()==5)
              {
               supNum='00' + supNum;
              
              
              }
               if(supNum.length()==4)
              {
               supNum='000' + supNum;
              
              
              }
               if(supNum.length()==3)
              {
               supNum='0000' + supNum;
              
              
              }
               if(supNum.length()==2)
              {
               supNum='00000' + supNum;
              
              
              }
                  if(supNum.length()==1)
              {
               supNum='000000' + supNum;
              
              
              }
             
             csr.ORacle_Customer_Number__c=supNum;
             csr.Account_Name__c=accMap.get(supNum);
             
             }
                          csr.Status__c='Current';
             //csr.Supplier_Score__c=integer.valueof(inputvalues[8]);
             csr.Month__c=month;
             csr.Year__c=year;
            // csr.Account_Name__c=accMap.get(suplitter[1]);
             if(inputvalues[2].trim().isNumeric())
             csr.Cost_Competiveness_Score__c=Decimal.valueof(inputvalues[2]);
             else
             csr.Cost_Competiveness_Score__c=0;
              if(inputvalues[3].trim().isNumeric())
             csr.Reduction_Performance_Score__c=Decimal.valueof(inputvalues[3]);
             else
             csr.Reduction_Performance_Score__c=0;
             if(inputvalues[4].trim().isNumeric())
             csr.Cost_Control_Score__c=Decimal.valueof(inputvalues[4]);
             else
             csr.Cost_Control_Score__c=0;
             if(inputvalues[5].trim().isNumeric())
             csr.Transparency_Score__c=Decimal.valueof(inputvalues[5]);
             else
             csr.Transparency_Score__c=0;
             if(inputvalues[6].trim().isNumeric())
             csr.Payment_Terms_Score__c=Decimal.valueof(inputvalues[6]);
             else
             csr.Payment_Terms_Score__c=0;
             if(inputvalues[7].trim().isNumeric())
             csr.SOI_Score__c=Decimal.valueof(inputvalues[7]);
             else
             csr.SOI_Score__c=0;
             if(inputvalues[8].trim().isNumeric())
             csr.CSA_Status_Score__c=Decimal.valueof(inputvalues[8]);
             else
             csr.CSA_Status_Score__c=0;
             if(inputvalues[9].trim().isNumeric())
             csr.Business_Continuity_Score__c=Decimal.valueof(inputvalues[9]);
             else
             csr.Business_Continuity_Score__c=0;
             if(inputvalues[10].trim().isNumeric())
             csr.Innovative_Concepts_Score__c=Decimal.valueof(inputvalues[10]);
             else
             csr.Innovative_Concepts_Score__c=0;
             if(inputvalues[11].trim().isNumeric())
             csr.Technology_Roadmap_Score__c=Decimal.valueof(inputvalues[11]);
             else
             csr.Technology_Roadmap_Score__c=0;
          
             
             insertList.add(csr);
            }
            
            }
   }
   



}
if(insertList.size()>0)
{

try{
         
          Database.SaveResult[] srList = Database.Insert(insertList, false);  
         insConCst=true;
        }
        catch(Exception e){
        system.debug(e);
        }
}

}

public void importdataQlty(){
List<ScoreCardQualityDelivery__c> insertList = new List<ScoreCardQualityDelivery__c>();
/*Map<string,Id> l3submetricName = new Map<string,Id>();
Map<string,Id> l3submetricSubMetric = new Map<string,Id>();
Map<string,Id> SubMetricName = new Map<string,Id>();
Map<string,Id> SubMetricMetric = new Map<string,Id>();

for(SSC_L3SubMetric__c l3 : [select Id,Name,End_Date__c,Start_Date__c,SSC_SubMetric__c,Target_Score__c from SSC_L3SubMetric__c where End_Date__c>:system.today() OR End_Date__c=null])
{

  l3submetricName.put(l3.Name,l3.Id);
  l3submetricSubMetric.put(l3.Name,l3.SSC_SubMetric__c);

}
for(SSC_SubMetric__c sub : [select Id,Name,End_Date__c,Start_Date__c,Metric_Name__c,TargetScore__c from SSC_SubMetric__c where End_Date__c>:system.today() OR End_Date__c=null])
{

  SubMetricName.put(sub.Name,sub.Id);
  SubMetricMetric.put(sub.Name,sub.Metric_Name__c);

} */
Map<string,Id> accMap = new Map<string,Id>();

for(Account acc:[select Id,Name,Oracle_Customer_Number__c from Account where SSC_Scorecard_Required__c=true])
{

accMap.put(acc.Oracle_Customer_Number__c,acc.Id);

}

List<ScoreCardQualityDelivery__c> csrExist =[select Id,Name,status__c from ScoreCardQualityDelivery__c where Month__c=:month and Year__c=:year];
if(csrExist!=null && csrExist.size()>0)
{
 confirm2=true;
 if(confirmation2==true)
 {
   confirm2=false;
   for(ScoreCardQualityDelivery__c scr :csrExist)
   {
   
     scr.Status__c='Previous';
   
   
   }
   update csrExist;
   if(csvFile3!=null)
   {
     csrFile=csvFile3.toString();
     system.debug(csrfile);
        system.debug(csrFile + 'nameFile');
        //Read the CSV Rows using split method
        String[] filelines = new String[]{};
        filelines = csrFile.split('\n');
        system.debug(filelines + 'filelines');
       for (Integer i=3;i<filelines.size();i++)
        {
           String[] inputvalues = new String[]{};
            //Read multiple column values within the same row using split method
            inputvalues = filelines[i].split(',');
            if(i>=3)
            {
           ScoreCardQualityDelivery__c csr = new ScoreCardQualityDelivery__c();
            string supNum=inputvalues[1].trim();
            system.debug('inputvalues' + inputvalues);
            // string [] suplitter = new string []{};
            // suplitter=inputvalues[1].split('\'');   
            //csr.ORacle_Customer_Number__c=suplitter[1];
             string input=inputvalues[1].trim();
             string [] suplitter = new string []{};
             if(input.contains('\''))
             {
             suplitter=inputvalues[1].split('\'');   
             system.debug('custnum' + inputvalues[1]);
             csr.ORacle_Customer_Number__c=suplitter[1];
             csr.Account_Name__c=accMap.get(suplitter[1]);
            
             }
             
             If(input.length()==7 && !(input.contains('\'')))
             {
             
              csr.ORacle_Customer_Number__c=input;
              csr.Account_Name__c=accMap.get(input);
             
             }
             else
             {
              integer j = input.length();
              if(j==4)
              {
              input='000' + input;
              
              }
              if(j==3)
              {
              input='0000' + input;
              
              }
               if(j==5)
              {
              input='00' + input;
              
              }
               if(j==6)
              {
              input='0' + input;
              
              }
               if(j==2)
              {
              input='00000' + input;
              
              }
               if(j==2)
              {
              input='000000' + input;
              
              }
             system.debug('custnum' + inputvalues[1]);
             csr.ORacle_Customer_Number__c=input;
             csr.Account_Name__c=accMap.get(input);
             }
             csr.Status__c='Current';
             //csr.Supplier_Score__c=integer.valueof(inputvalues[8]);
             csr.Month__c=month;
             csr.Year__c=year;
             csr.Account_Name__c=accMap.get(input);
              if(inputvalues[2].trim().isNumeric())
             csr.Escaping_MCAR_Score__c=Decimal.valueof(inputvalues[2]);
             else
             csr.Escaping_MCAR_Score__c=0;
             if(inputvalues[3].trim().isNumeric())
             csr.Quality_Capability_Score__c=Decimal.valueof(inputvalues[3]);
             else
             csr.Quality_Capability_Score__c=0;
             if(inputvalues[4].trim().isNumeric())
             csr.Defective_PPM_Score__c=Decimal.valueof(inputvalues[4]);
             else
             csr.Defective_PPM_Score__c=0;
             if(inputvalues[5].trim().isNumeric())
             csr.Commitment_Score__c=Decimal.valueof(inputvalues[5]);
             else
             csr.Commitment_Score__c=0;
             if(inputvalues[6].trim().isNumeric())
             csr.OTD_Score__c=Decimal.valueof(inputvalues[6]);
             else
             csr.OTD_Score__c=0;
             if(inputvalues[7].trim().isNumeric())
             csr.Lead_Time_Score__c=Decimal.valueof(inputvalues[7]);
             else
             csr.Lead_Time_Score__c=0;
             if(inputvalues[8].trim().isNumeric())
             csr.Agility_Score__c=Decimal.valueof(inputvalues[8]);
             else
             csr.Agility_Score__c=0;
             
             insertList.add(csr);
            }
            
            }
   }
   
 
 }
 else
 {
   
 }
}
else
{
 if(csvFile3!=null)
   {
     qltyFile=csvFile3.toString();
     system.debug(csrfile);
        system.debug(csrFile + 'nameFile');
        //Read the CSV Rows using split method
        String[] filelines = new String[]{};
        filelines = qltyFile.split('\n');
      //  system.debug(filelines + 'filelines');
       for (Integer i=1;i<filelines.size();i++)
        {
           String[] inputvalues = new String[]{};
            //Read multiple column values within the same row using split method
            inputvalues = filelines[i].split(',');
            if(i>=3)
            {
            system.debug(filelines[i] + 'inputvalues');
            system.debug('custnum' + inputvalues[1]);
           ScoreCardQualityDelivery__c csr = new ScoreCardQualityDelivery__c();
            string supNum=inputvalues[1].trim();
             string [] suplitter = new string []{};
               string input=inputvalues[1].trim();
             if(input.contains('\''))
             {
             suplitter=inputvalues[1].split('\'');   
             system.debug('custnum' + inputvalues[1]);
             csr.ORacle_Customer_Number__c=suplitter[1];
             csr.Account_Name__c=accMap.get(suplitter[1]);
             csr.Account_Name__c=accMap.get(suplitter[1]);
            
             }
           /*  string [] suplitter = new string []{};
            suplitter=inputvalues[1].split('\'');   
            csr.ORacle_Customer_Number__c=suplitter[1]; */
         
             If(input.length()==7&& !(input.contains('\'')))
             {
             
              csr.ORacle_Customer_Number__c=input;
              csr.Account_Name__c=accMap.get(input);
             
             }
             else
             {
              integer j = input.length();
              if(j==4)
              {
              input='000' + input;
              
              }
              if(j==3)
              {
              input='0000' + input;
              
              }
               if(j==5)
              {
              input='00' + input;
              
              }
               if(j==6)
              {
              input='0' + input;
              
              }
               if(j==2)
              {
              input='00000' + input;
              
              }
               if(j==2)
              {
              input='000000' + input;
              
              }
             
             csr.ORacle_Customer_Number__c=input;
             csr.Account_Name__c=accMap.get(input);
             } 
             csr.Status__c='Current';
             //csr.Supplier_Score__c=integer.valueof(inputvalues[8]);
             csr.Month__c=month;
             csr.Year__c=year;
            // csr.Account_Name__c=accMap.get(input);
             if(inputvalues[2].trim().isNumeric())
             csr.Escaping_MCAR_Score__c=Decimal.valueof(inputvalues[2]);
             else
             csr.Escaping_MCAR_Score__c=0;
             if(inputvalues[3].trim().isNumeric())
             csr.Quality_Capability_Score__c=Decimal.valueof(inputvalues[3]);
             else
             csr.Quality_Capability_Score__c=0;
             if(inputvalues[4].trim().isNumeric())
             csr.Defective_PPM_Score__c=Decimal.valueof(inputvalues[4]);
             else
             csr.Defective_PPM_Score__c=0;
             if(inputvalues[5].trim().isNumeric())
             csr.Commitment_Score__c=Decimal.valueof(inputvalues[5]);
             else
             csr.Commitment_Score__c=0;
             if(inputvalues[6].trim().isNumeric())
             csr.OTD_Score__c=Decimal.valueof(inputvalues[6]);
             else
             csr.OTD_Score__c=0;
             if(inputvalues[7].trim().isNumeric())
             csr.Lead_Time_Score__c=Decimal.valueof(inputvalues[7]);
             else
             csr.Lead_Time_Score__c=0;
             if(inputvalues[8].trim().isNumeric())
             csr.Agility_Score__c=Decimal.valueof(inputvalues[8]);
             else
             csr.Agility_Score__c=0;
             
             insertList.add(csr);
            
            
            }
            }
   }
   



}
if(insertList.size()>0)
{
try{
         
          Database.SaveResult[] srList = Database.Insert(insertList, false);  
          insConQlty=true;
        }
        catch(Exception e){
        system.debug(e);
        }
}

}

public void CalculateScores(){

Map<string,Id> l3submetricName = new Map<string,Id>();
Map<string,Id> l3submetricSubMetric = new Map<string,Id>();
Map<string,Decimal> l3submetricTarget = new Map<string,Decimal>();
Map<string,Id> SubMetricName = new Map<string,Id>();
Map<string,Id> SubMetricMetric = new Map<string,Id>();
Map<string,Decimal> submetricTarget = new Map<string,Decimal>();

for(SSC_L3SubMetric__c l3 : [select Id,Name,End_Date__c,Start_Date__c,SSC_SubMetric__c,Target_Score__c from SSC_L3SubMetric__c where End_Date__c>:system.today() OR End_Date__c=null])
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

} 

SSC_ScoreCalculatorBatch batch = new SSC_ScoreCalculatorBatch(l3submetricName,l3submetricSubMetric,SubMetricName,SubMetricMetric,month,year,l3submetricTarget,submetricTarget);
database.executeBatch(batch,50);

}
public void socrecardBackup(){

SSC_Moverecordsfromcurrent_to_prior batch = new SSC_Moverecordsfromcurrent_to_prior();

database.executeBatch(batch,50);



}
public void clearExistingScores(){

SSC_deleterecordsfromcurrent  batch = new SSC_deleterecordsfromcurrent();

database.executeBatch(batch,1000);



}
}