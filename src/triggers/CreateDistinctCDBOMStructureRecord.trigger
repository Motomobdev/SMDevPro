trigger CreateDistinctCDBOMStructureRecord on CD_BOM_Structure__c (after insert,after update){
    List<Distinct_CD_BOM_Structures__c> UpsertNewData =new List<Distinct_CD_BOM_Structures__c>();
    Set<String> ExistingCombination = new Set<string>();
    List<string> UniqueCombination = new List<string>();
    Map<string,Distinct_CD_BOM_Structures__c> uniqueBoms = new Map<string,Distinct_CD_BOM_Structures__c>();
    
   for(CD_BOM_Structure__c CDBom : trigger.new)
    {
        if(CDBom.Unique_Identifier_In_BOM_Structure__c!=null)
           
            UniqueCombination.add(CDBom.Unique_Identifier_In_BOM_Structure__c);
    }
    
   
 if(!UniqueCombination.isEmpty())
    {
        for(Distinct_CD_BOM_Structures__c disCD : [ Select id,Unique_Identifier_In_BOM_Structure__c from Distinct_CD_BOM_Structures__c where Unique_Identifier_In_BOM_Structure__c=:UniqueCombination LIMIT 50000 ]){
            ExistingCombination.add(disCD.Unique_Identifier_In_BOM_Structure__c); 
        }   
    }
    
    for(CD_BOM_Structure__c CDBomS : trigger.new)
    {
        if(CDBomS.Unique_Identifier_In_BOM_Structure__c!=null){
            if(!ExistingCombination.contains(CDBomS.Unique_Identifier_In_BOM_Structure__c))
            {
                Distinct_CD_BOM_Structures__c DCB = new Distinct_CD_BOM_Structures__c(Name=CDBomS.Top_Level_Assembly_Name__c,Child_Item__c=CDBomS.Child_Item__c,OrganizationCode__c=CDBomS.OrganizationCode__c,
                  CD_BOM_Structure_del__c=CDBomS.id,Top_Level_Assembly__c = CDBomS.Top_Level_Assembly__c,External_Id_in_Bom_Structure__c=CDBomS.Unique_Identifier_In_BOM_Structure__c
                );
                uniqueBoms.put(CDBomS.Unique_Identifier_In_BOM_Structure__c,DCB);
            }
        }
    } 
    
  /*  for(CD_BOM_Structure__c CDBom : trigger.new)
    {
     if(CDBom.Unique_Identifier_In_BOM_Structure__c!=null)
     {
      if(!uniqueBoms.containsKey(CDBom.Unique_Identifier_In_BOM_Structure__c))
      {
         List<Distinct_CD_BOM_Structures__c> distinctBoms =  new List<Distinct_CD_BOM_Structures__c>();
     
         distinctBoms=[Select id,Unique_Identifier_In_BOM_Structure__c from Distinct_CD_BOM_Structures__c where Unique_Identifier_In_BOM_Structure__c=:CDBom.Unique_Identifier_In_BOM_Structure__c limit 1];
        if(distinctBoms.size()==0)
        {
           Distinct_CD_BOM_Structures__c DCB = new Distinct_CD_BOM_Structures__c(Name=CDBom.Top_Level_Assembly_Name__c,Child_Item__c=CDBom.Child_Item__c,OrganizationCode__c=CDBom.OrganizationCode__c,
                   CD_BOM_Structure__c = CDBom.Id, Top_Level_Assembly__c = CDBom.Top_Level_Assembly__c,External_Id_in_Bom_Structure__c=CDBom.Unique_Identifier_In_BOM_Structure__c );
          uniqueBoms.put(CDBom.Unique_Identifier_In_BOM_Structure__c,DCB);
     
        }
      }
     }
   
    } */
    if(!uniqueBoms.isEmpty())
    {
       for(string str : uniqueBoms.keySet())
       {
        
        UpsertNewData.add(uniqueBoms.get(str));
       
       }
       
        //Upsert uniqueBoms External_Id_in_Bom_Structure__c;
    }
    if(UpsertNewData.size()>0)
    {
     Upsert UpsertNewData;
    }
}