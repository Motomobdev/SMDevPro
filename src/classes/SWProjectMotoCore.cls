@RestResource(urlMapping='/SWProjectMotoCore')
global class SWProjectMotoCore{

    @HttpPost
    global static String addRecords(String records){
        
        List<SW_Project_Moto_Core_Directory__c> swprojectMotocores = (List< SW_Project_Moto_Core_Directory__c>)JSON.deserialize(records, List< SW_Project_Moto_Core_Directory__c>.class);
        insert swprojectMotocores;
        return JSON.serialize(swprojectMotocores);
    }
    
    @HttpPatch
    global static String updateRecords(String records){
        
        List<SW_Project_Moto_Core_Directory__c> swprojectMotocores = (List< SW_Project_Moto_Core_Directory__c>)JSON.deserialize(records, List< SW_Project_Moto_Core_Directory__c>.class);
        update swprojectMotocores;
        return JSON.serialize(swprojectMotocores);
    }
    
}