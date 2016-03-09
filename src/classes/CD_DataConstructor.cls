/*
*************************************************************************************************
Description:
This  Class is called from controller of ItemCostUpload page to read lines from csv file.
Revision History:
Author/Reviewer   Change Description  Created/Revised Date
 Sivani             Created             9/26/2104




*************************************************************************************************
*/
Public with sharing class CD_DataConstructor implements Database.batchable<string>, Database.Stateful
{
   private String m_csvFile;
   private Integer m_startRow;
   private Parser m_parser;
   List<list<string>>   csvLines =  new List<list<string>>();
   List<List<String>> allCsvLines = new List<List<String>>();
   private static final Integer SCOPE_SIZE = 100;
   public CD_DataConstructor(string csvfile){
   m_csvFile=csvfile;}
   //public static ID run(){}
   public Iterable<string> start(Database.batchableContext batchableContext)
   { 
       try{
       m_csvFile = m_csvFile.replace('\r\n', '\n');
       }
       catch(Exception e)
       {
        system.debug(e);
        
       }
       return new CSVIterator(m_csvFile, parser.crlf);
   }
   public void execute(Database.BatchableContext batchableContext, List<string> scope)  
   {
       //TODO: Create a map with the column name and the position.
     // try{
       String csvFile = '';
       for(String row : scope)
       {
          csvFile += row + parser.crlf;
       }
       csvLines = CSVReader.readIETFRFC4180CSVFile(csvFile);
       allCsvLines.addAll(csvLines);
      // }
       /*catch (Exception e)
       {
       ApexPages.Message errormsg = new ApexPages.Message(ApexPages.severity.ERROR,'The file was not processed.Please make sure file is of CSV format');
        ApexPages.addMessage(errormsg);
        }*/
       //TODO: csvLines contains a List with the values of the CSV file.
       //These information will be used to create a custom object to
       //process it.
       system.debug(csvLines.size()+ 'csvLines+++++');      

   }
   public void finish(Database.BatchableContext batchableContext)
   {
   
     system.debug(allCsvLines.size()+ 'csvLines+++++');   
    ItemCostLoader1 objectData = new ItemCostLoader1();
    objectData.createmaps(allCsvLines);
  
    
    }
    

}